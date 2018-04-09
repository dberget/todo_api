defmodule ExTodoWeb.TodoControllerTest do
  use ExTodoWeb.ConnCase

  alias ExTodo.Todos
  alias ExTodo.Todos.Todo
  
  @server_name 123

  @create_attrs %{title: "Todo", id: 1, complete: false, description: nil}
  @update_attrs %{}
  @invalid_attrs %{}

  def todo_fixture(attrs \\ %{}) do
    {:ok, todo} = Map.merge(@create_attrs, attrs) |> Todos.create_todo(@server_name)

    todo
  end

  setup %{conn: conn} do
    conn =
      conn
      |> put_req_header("accept", "application/json")
      |> put_req_header("authorization", token)

    {:ok, conn: conn}
  end

  describe "index" do
    test "lists all todos", %{conn: conn} do
      conn = get(conn, todo_path(conn, :index))

      assert json_response(conn, 200)["data"] == []
    end
  end

  # describe "create todo" do
  #   test "renders todo when data is valid", %{conn: conn} do
  #     conn = post(conn, todo_path(conn, :create), todo: @create_attrs)
  # token = get_authorization_header(conn)
  #     assert %{"id" => id} = json_response(conn, 201)["data"]

  #     conn = get(conn, todo_path(conn, :show, id))
  #     assert json_response(conn, 200)["data"] == %{"id" => id}
  #   end

  #   test "renders errors when data is invalid", %{conn: conn} do
  #     conn = post(conn, todo_path(conn, :create), todo: @invalid_attrs)
  #     assert json_response(conn, 422)["errors"] != %{}
  #   end
  # end

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

  defp get_authorization_header(conn) do
    conn
    |> get_req_header("authorization")
    |> List.first()
  end
end
