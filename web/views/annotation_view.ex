defmodule Rumbl.AnnotationView do
  @moduledoc """
  """

  use Rumbl.Web, :view

  def render("annotation.json", %{annotation: annotation}) do
    %{
      id: annotation.id,
      body: annotation.body,
      at: annotation.at,
      user: render_one(annotation.user, Rumbl.UserView, "user.json"),
      inserted_at: annotation.inserted_at
    }
  end
end
