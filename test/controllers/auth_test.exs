defmodule Rumbl.AuthTest do
  use Rumbl.ConnCase

  alias Rumbl.Auth

  setup %{conn: conn} do
    conn = conn
      |> bypass_through(Rumbl.Router, :browser)
      |> get("/")
    {:ok, %{conn: conn}}
  end

  test "authenticate_user halts when no current_user exists", %{conn: conn} do
    conn = Auth.authenticate_user(conn, [])
    assert conn.halted
  end

  test "authenticate_user continues when current_user exists", %{conn: conn} do
    conn = conn
      |> assign(:current_user, %Rumbl.User{})
      |> Auth.authenticate_user([])
    refute conn.halted
  end

  test "login puts the user in the session", %{conn: conn} do
    id = Ecto.UUID.generate()
    login_conn = conn
      |> Auth.login(%Rumbl.User{id: id})
      |> send_resp(:ok, "")
    next_conn = get(login_conn, "/")
    assert get_session(next_conn, :user_id) == id
  end

  test "logout drops the session", %{conn: conn} do
    login_conn = conn
      |> put_session(:user_id, Ecto.UUID.generate())
      |> Auth.logout()
      |> send_resp(:ok, "")
    next_conn = get(login_conn, "/")
    refute get_session(next_conn, :user_id)
  end

  test "call places user from session into assign", %{conn: conn} do
    user = insert_user()
    conn = conn
      |> put_session(:user_id, user.id)
      |> Auth.call(Repo)
    assert conn.assigns.current_user.id == user.id
  end

  test "call with no session sets curent_user assign to nil", %{conn: conn} do
    conn = Auth.call(conn, Repo)
    assert conn.assigns.current_user == nil
  end

  test "login with a valid username and password", %{conn: conn} do
    user = insert_user(username: "me", password: "secret")
    {:ok, conn} =
      Auth.login_by_username_and_password(conn, "me", "secret", repo: Repo)
    assert conn.assigns.current_user.id == user.id
  end

  test "login with a not found user", %{conn: conn} do
    assert {:error, :not_found, _conn} =
      Auth.login_by_username_and_password(conn, "me", "secret", repo: Repo)
  end

  test "login with password mismatch", %{conn: conn} do
    user = insert_user(username: "me", password: "secret")
    assert {:error, :unauthorized, conn} =
      Auth.login_by_username_and_password(conn, "me", "password", repo: Repo)
  end
end
