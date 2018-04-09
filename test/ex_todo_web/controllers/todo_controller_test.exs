defmodule ExTodoWeb.TodoControllerTest do
  use ExTodoWeb.ConnCase

  alias ExTodo.Todos
  alias ExTodo.Todos.Todo

  @create_attrs %{title: "Todo", id: 1, complete: false, description: nil}

  setup_all :create_token

  setup %{conn: conn, token: token, pid: pid} do
    conn =
      conn
      |> put_req_header("authorization", token)

    {:ok, conn: conn, pid: pid}
  end

  def todo_fixture(attrs \\ %{}) do
    {:ok, todo} = Map.merge(@create_attrs, attrs) |> Todos.create_todo()

    todo
  end

  describe "index" do
    test "index creates new token if no token exists", %{conn: _conn} do
      conn = build_conn()
      auth_header = get(conn, todo_path(conn, :index)) |> get_resp_header("authorization")

      assert [token] = auth_header
    end

    test "index displays list of todos if token exists", %{conn: conn, pid: pid} do
      conn = get(conn, todo_path(conn, :index))
      {:ok, todos} = Todos.list_todos(pid)

      # list_todo returns Todo struct but json_resp is a map, so checking length for now.
      assert length(todos) == length(json_response(conn, 200))
    end
  end

  describe "create todo" do
    test "renders todo when data is valid", %{conn: conn} do
      conn_1 = post(conn, todo_path(conn, :create), todo: @create_attrs)
      assert %{"id" => id} = json_response(conn_1, 200)
    end
  end

  # describe "update todo" do

  #   test "renders todo when data is valid", %{conn: conn, todo: %Todo{id: id} = todo} do
  #     conn = put(conn, todo_path(conn, :update, todo), todo: @update_attrs)
  #     assert %{"id" => ^id} = json_response(conn, 200)["data"]

  #     conn = get(conn, todo_path(conn, :show, id))
  #     assert json_response(conn, 200)["data"] == %{"id" => id}
  #   end

  #   test "renders errors when data is invalid", %{conn: conn, todo: todo} do
  #     conn = put(conn, todo_path(conn, :update, todo), todo: @invalid_attrs)
  #     assert json_response(conn, 422)["errors"] != %{}
  #   end
  # end

  # describe "delete todo" do
  #   test "deletes chosen todo", %{conn: conn, todo: todo} do
  #     conn = delete(conn, todo_path(conn, :delete, todo))
  #     assert response(conn, 204)

  #     assert_error_sent(404, fn ->
  #       get(conn, todo_path(conn, :show, todo))
  #     end)
  #   end
  # end

  defp authorize_connection(conn) do
    token = get_authorization_header(conn)

    Phoenix.Token.verify(ExTodoWeb.Endpoint, "user salt", token, max_age: 86400)
  end

  defp get_authorization_header(conn) do
    conn
    |> get_req_header("authorization")
    |> List.first()
  end

  defp create_token(context) do
    rand_id = Enum.random(1..1000)
    token = Phoenix.Token.sign(ExTodoWeb.Endpoint, "user salt", rand_id)
    ExTodo.Storage.Supervisor.new_todo_list(rand_id)

    %{token: token, pid: rand_id}
  end
end
