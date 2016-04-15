alias Rumbl.Repo
alias Rumbl.User

User.registration_changeset(%User{name: "Wolfram", username: "wolfram"}, %{password: "wolfram"})
|> Repo.insert!
