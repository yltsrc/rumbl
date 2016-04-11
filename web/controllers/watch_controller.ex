defmodule Rumbl.WatchController do
  @moduledoc """
  """

  use Rumbl.Web, :controller

  alias Rumbl.Video

  def show(conn, %{"id" => id}) do
    video = Rumbl.Repo.get!(Video, id)
    render(conn, "show.html", video: video)
  end
end
