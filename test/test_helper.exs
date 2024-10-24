ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(Bacia.Repo, :manual)
{:ok, _} = Application.ensure_all_started(:ex_machina)
