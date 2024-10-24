defmodule BaciaWeb.Plugs.Guardian.AuthAccessPipeline do
  use Guardian.Plug.Pipeline,
    otp_app: :bacia,
    module: Bacia.Bank.Auth.Guardian,
    error_handler: BaciaWeb.Plugs.Guardian.AuthErrorHandler

  plug Guardian.Plug.VerifySession
  plug Guardian.Plug.VerifyHeader
  plug Guardian.Plug.EnsureAuthenticated
  plug Guardian.Plug.LoadResource
end
