defmodule Bacia.Repo.Migrations.CreateTransactionsTable do
  use Ecto.Migration

  def change do
    create table(:transactions) do
      add :amount, :integer, null: false
      add :sender_id, references(:customers), null: false
      add :receiver_id, references(:customers), null: false

      timestamps()
    end
  end
end
