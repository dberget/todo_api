defmodule ExTodoWeb.TodoController do
  use ExTodoWeb, :controller

  alias ExTodo.Todos

  action_fallback(ExTodoWeb.FallbackController)

  def index(conn, _params) do
    case authorize_connection(conn) do
      {:ok, user_id} ->
        {:ok, todos} = Todos.list_todos(user_id)
        render(conn, "list.json", todos: todos)

      {:error, :missing} ->
        {:ok, token} = create_new_token()

        conn
        |> put_resp_header("authorization", token)
        |> render("new.json")

      _ ->
        render(conn, "error.json")
    end
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

  defp create_new_token() do
    rand_id = Enum.random(1..1000)
    ExTodo.Storage.Supervisor.new_todo_list(rand_id)
    token = Phoenix.Token.sign(ExTodoWeb.Endpoint, "user salt", rand_id)

    {:ok, token}
  end

  defp get_authorization_header(conn) do
    conn
    |> get_req_header("authorization")
    |> List.first()
  end
end
