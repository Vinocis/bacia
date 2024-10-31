defmodule Bacia.Repo.Migrations.CreateTransactionsTable do
  use Ecto.Migration

  def change do
    create table(:transactions, primary_key: false) do
      add :id, :string, primary_key: true
      add :amount, :integer, null: false
      add :sender_id, references(:customers, type: :string), null: false
      add :receiver_id, references(:customers, type: :string), null: false

      timestamps()
    end
  end
end
