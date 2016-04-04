defmodule Rumbl.SessionController do
  use Rumbl.Web, :controller

  alias Rumbl.User

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def create(conn, params = %{"session" => session_params}) do
    case Rumbl.Auth.login_by_username_and_password(conn, session_params["username"], session_params["password"], repo: Rumbl.Repo) do
      {:ok, conn} ->
        conn
        |> put_flash(:info, "Welcome back!")
        |> redirect(to: user_path(conn, :index))
      {:error, _reason, conn} ->
        conn
        |> put_flash(:error, "Invalid username/password combination!")
        |> render("new.html")
    end
  end

  def delete(conn, _params) do
    conn
    |> Rumbl.Auth.logout()
    |> redirect(to: page_path(conn, :index))
  end
end
