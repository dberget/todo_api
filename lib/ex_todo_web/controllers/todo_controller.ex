defmodule ExTodoWeb.TodoController do
  use ExTodoWeb, :controller

  alias ExTodo.Todos

  action_fallback(ExTodoWeb.FallbackController)

  def index(conn, _params) do
    rand_id = Enum.random(1..1000)
    token = Phoenix.Token.sign(ExTodoWeb.Endpoint, "user salt", rand_id)
    ExTodo.Storage.Supervisor.new_todo_list(rand_id)

    conn =
      conn
      |> put_resp_header("authorization", token)

    render(conn, "new.json")
  end

  def show(conn, %{"id" => todo_id}) do
    with {:ok, user_id} <- authorize_connection(conn),
         {:ok, todo} <- Todos.get_todo(todo_id, user_id) do
      render(conn, "show.json", todo: todo)
    else
      _ ->
        render(conn, "error.json")
    end
  end

  def create(conn, %{"todo" => todo_params}) do
    with {:ok, user_id} <- authorize_connection(conn),
         {:ok, todo} <- Todos.create_todo(todo_params, user_id) do
      render(conn, "show.json", todo: todo)
    else
      _ ->
        render(conn, "error.json")
    end
  end

  def delete(conn, %{"todo" => todo_params}) do
    with {:ok, user_id} <- authorize_connection(conn),
         todos <- Todos.delete_todo(user_id, todo_params) do
      render(conn, "todos.json", todos: todos)
    else
      {:error, _} ->
        render(conn, "error.json")
    end
  end

  defp authorize_connection(conn) do
    token = get_authorization_header(conn)

    Phoenix.Token.verify(ExTodoWeb.Endpoint, "user salt", token, max_age: 86400)
  end

  defp get_authorization_header(conn) do
    conn
    |> get_req_header("authorization")
    |> List.first()
  end
end
