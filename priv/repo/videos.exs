# Script for populating the database. You can run it as:
#
#     mix run priv/repo/videos.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Rumbl.Repo.insert!(%Rumbl.SomeModel{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Rumbl.Repo
alias Rumbl.Video
import Ecto.Changeset

for video <- Repo.all(Video) do
  Video.changeset(%Video{video | title: "", slug: ""}, %{title: video.title})
  |> Repo.update
end

