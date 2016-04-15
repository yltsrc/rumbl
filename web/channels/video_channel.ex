defmodule Rumbl.VideoChannel do
  @moduledoc """
  """

  use Rumbl.Web, :channel

  def join("videos:" <> video_id, params, socket) do
    case Rumbl.Permalink.cast(video_id) do
      {:ok, id} ->
        last_seen_at = params["last_seen_at"] || "1990-01-01T00:00:00.000Z"
        video = Repo.get!(Rumbl.Video, id)
        annotations = Repo.all(from a in assoc(video, :annotations), where: a.inserted_at > ^last_seen_at, order_by: [asc: a.at, asc: a.inserted_at], limit: 100, preload: [:user])
        resp = %{annotations: Phoenix.View.render_many(annotations, Rumbl.AnnotationView, "annotation.json")}
        {:ok, resp, assign(socket, :video_id, id)}
      :error ->
        {:error, socket}
    end
  end

  def handle_in(event, params, socket) do
    user = Repo.get(Rumbl.User, socket.assigns.user_id)
    handle_in(event, params, user, socket)
  end

  def handle_in("new_annotation", params, user, socket) do
    changes = user
    |> build_assoc(:annotations, video_id: socket.assigns.video_id)
    |> Rumbl.Annotation.changeset(params)

    case Repo.insert(changes) do
      {:ok, ann} ->
        broadcast_annotation(socket, ann)
        Task.start_link(fn -> compute_additional_info(ann, socket) end)
        {:reply, :ok, socket}
      {:error, changeset} ->
        {:reply, {:error, %{errors: changeset}}, socket}
    end
  end

  def handle_info(:ping, socket) do
    count = socket.assigns.count || 1
    push(socket, "ping", %{count: count})
    {:noreply, assign(socket, :count, count + 1)}
  end

  defp broadcast_annotation(socket, annotation) do
    annotation = Repo.preload(annotation, :user)
    rendered_ann = Phoenix.View.render(Rumbl.AnnotationView, "annotation.json", %{annotation: annotation})
    broadcast!(socket, "new_annotation", rendered_ann)
  end

  defp compute_additional_info(ann, socket) do
    for result <- Rumbl.InfoSys.compute(ann.body, limit: 1, timeout: 10_000) do
      attrs = %{url: result.url, body: result.text, at: ann.at}
      info_changeset =
        Repo.get_by!(Rumbl.User, username: result.backend)
        |> build_assoc(:annotations, video_id: ann.video_id)
        |> Rumbl.Annotation.changeset(attrs)

      case Repo.insert(info_changeset) do
        {:ok, info_ann} -> broadcast_annotation(socket, info_ann)
        {:error, _changeset} -> :ignore
      end
    end
  end
end
