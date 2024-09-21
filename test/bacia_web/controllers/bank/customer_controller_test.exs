defmodule BaciaWeb.Bank.CustomerControllerTest do
  use BaciaWeb.ConnCase

  alias Bacia.Factory

  import Bacia.Bank.Auth.Guardian, only: [encode_and_sign: 1]

  describe "create/2" do
    test "Creates the customer when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/customer", Factory.params_for(:customer))

      assert response(conn, 201)
      assert conn.resp_body == "Customer created"
    end

    test "Status code 422 when data is not valid", %{conn: conn} do
      customer = Factory.params_for(:customer, cpf: "")
      conn = post(conn, ~p"/customer", customer)

      assert response(conn, 422)
      assert json_response(conn, 422) == %{"errors" => %{"cpf" => ["can't be blank"]}}
    end
  end

  describe "sign_in/2" do
    setup context do
      credentials = [cpf: Brcpfcnpj.cpf_generate(), password: "123456"]

      Map.put(context, :credentials, credentials)
    end

    test "Authenticate the customer when the credentials are valid", %{conn: conn, credentials: credentials} do
      Factory.insert(:customer, credentials)
      conn = post(conn, ~p"/customer/sign_in", credentials)

      assert response(conn, 200)
      assert %{"token" => _token} = json_response(conn, 200)
    end

    test "Fails to authenticate when the credentials are not valid", %{conn: conn, credentials: credentials} do
      Factory.insert(:customer, credentials)
      conn = post(conn, ~p"/customer/sign_in", Keyword.replace(credentials, :password, "111111"))

      assert response(conn, 401)
      assert json_response(conn, 401) == %{"errors" => %{"detail" => "Unauthorized"}}
    end

    test "Fails to authenticate with invalid params", %{conn: conn, credentials: credentials} do
      conn = post(conn, ~p"/customer/sign_in", Keyword.delete(credentials, :password))

      assert response(conn, 400)
      assert json_response(conn, 400) == %{"errors" => %{"detail" => "Bad Request"}}
    end
  end

  describe "show_balance/2" do
    test "Shows the customer account balance", %{conn: conn} do
      customer = Factory.insert(:customer)
      {:ok, token, _claims} =  encode_and_sign(customer)

      conn = 
        conn
        |> put_req_header("authorization", "Bearer #{token}")
        |> get(~p"/customer/balance")

      assert response(conn, 200)
      assert json_response(conn, 200) == %{"balance" => 0}
    end

    test "Do not show the customer account balance without authentication", %{conn: conn} do
      conn = get(conn, ~p"/customer/balance")

      assert response(conn, 401)
      assert json_response(conn, 401) == %{"message" => "unauthenticated"}
    end
  end
end
