defmodule Rumbl.PageController do
  @moduledoc """
  """

  use Rumbl.Web, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
