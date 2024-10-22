defmodule Bacia.Bank.Producers.Transaction do
  use GenStage

  def start_link() do
    GenStage.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok), do: {:producer, :ok}

  def handle_call(message, _from, state) do
    {:noreply, [message], state}
  end

  def handle_demand(_demand, state) do
    {:noreply, [], state}
  end
end
