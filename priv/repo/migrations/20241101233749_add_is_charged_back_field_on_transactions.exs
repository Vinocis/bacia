defmodule Bacia.Repo.Migrations.AddIsChargedBackFieldOnTransactions do
  use Ecto.Migration

  def up do
    alter table(:transactions) do
      add :is_charged_back, :boolean, default: false
    end
  end

  def down do
    alter table(:transactions) do
      remove :is_charged_back, :boolean
    end
  end
end
