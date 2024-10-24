defmodule Bacia.ServiceBehaviour do
  @moduledoc """
   Service behaviour

   Services are where the application process the business logic.

   Contexts are ONLY allowed to interact with each other via the facade module
   or services.
  """

  @callback process(map) :: {:ok, term} | {:error, term}
end
