defmodule Bacia.Repo.Migrations.CreateCustomerTable do
  use Ecto.Migration

  def change do
    create table(:customers, primary_key: false) do
      add :id, :string, primary_key: true
      add :name, :string, null: false
      add :cpf, :string, null: false
      add :balance, :integer, default: 0
      add :password_hash, :string, null: false

      timestamps()
    end

    create unique_index(:customers, [:cpf])
    create index(:customers, [:name])
  end
end
