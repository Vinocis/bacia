defmodule BaciaWeb.ViewJSON do
  def render("render.json", data), do: Map.delete(data, :conn)
end

