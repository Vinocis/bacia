defmodule Bacia.Repo.Migrations.CreateCustomerTable do
  use Ecto.Migration

  def change do
    create table(:customers) do
      add :name, :string, null: false
      add :cpf, :string, null: false
      add :balance, :integer, default: 0

      timestamps()
    end

    create unique_index(:customers, [:cpf])
    create index(:customers, [:name])
  end
end
