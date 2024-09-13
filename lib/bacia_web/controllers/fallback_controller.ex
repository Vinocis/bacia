defmodule BaciaWeb.FallbackController do
  use BaciaWeb, :controller
  
  alias BaciaWeb.ErrorJSON
  alias BaciaWeb.ChangesetJSON

  def call(conn, {:error, :unauthorized}) do
    conn
    |> put_status(401)
    |> put_view(ErrorJSON)
    |> render(:"401")
  end

  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    conn
    |> put_status(422)
    |> put_view(ChangesetJSON)
    |> render(:"422", changeset: changeset)
  end

  def call(conn, {:error, _error}) do
    conn
    |> put_status(400)
    |> put_view(ErrorJSON)
    |> render(:"400")
  end
end
