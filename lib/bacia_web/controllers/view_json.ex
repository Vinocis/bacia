defmodule BaciaWeb.ViewJSON do
  def render("render.json", data), do: Map.delete(data, :conn)

  def render("transactions.json", data) do
    data
    |> Map.delete(:conn)
    |> Map.get(:transactions)
    |> Enum.map(fn elem -> 
      %{
        id: elem.id,
        amount: elem.amount.amount,
        charged_back?: elem.is_charged_back,
        sender_id: elem.sender_id,
        receiver_id: elem.receiver_id,
        processed_at: elem.inserted_at,
      }
    end)
  end
end

