defmodule Bacia.Bank.Consumers.Transaction do
  use GenStage

  alias Bacia.Bank.Producers.Transaction, as: TransactionProducer

  def start_link() do
    GenStage.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    {:consumer, :ok, subscribe_to: [TransactionProducer]}
  end

  def handle_events(events, _from, state) do
    Enum.each(events, fn event -> 
      HandleTransaction.process(event)
    end)

    {:noreply, [], state}
  end
end
