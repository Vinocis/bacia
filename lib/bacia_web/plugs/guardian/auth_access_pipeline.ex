defmodule BaciaWeb.Plugs.Guardian.AuthAccessPipeline do
  use Guardian.Plug.Pipeline,
    otp_app: :bacia,
    module: Bacia.Bank.Auth.Guardian,
    error_handler: Bacia.Plugs.Guardian.AuthErrorHandler

  plug Guardian.Plug.VerifySession, claims: %{"typ" => "access"}
  plug Guardian.Plug.VerifyHeader, claims: %{"typ" => "access"}
  plug Guardian.Plug.EnsureAuthenticated
  plug Guardian.Plug.LoadResource, allow_blank: true
end
