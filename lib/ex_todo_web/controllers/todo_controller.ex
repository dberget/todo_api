defmodule ExTodoWeb.TodoController do
  use ExTodoWeb, :controller

  alias ExTodo.Todos

  action_fallback(ExTodoWeb.FallbackController)

  def index(conn, _params) do
    token = Phoenix.Token.sign(ExTodoWeb.Endpoint, "user salt", Enum.random(1..1000))
    ExTodo.Storage.Supervisor.new_todo_list(token)

    conn =
      conn
      |> put_resp_header("authorization", token)

    render(conn, "index.json", %{token: token})
  end

  def show(conn, %{"id" => todo_id}) do
  token = get_authorization_header(conn)

    case Phoenix.Token.verify(ExTodoWeb.Endpoint, "user salt", token, max_age: 86400) do
      {:ok, user_id} ->
        todo = Todos.get_todo(user_id, todo_id)
        render(conn, "show.json", todo: todo)

      {:error, _} ->
        render(conn, "error.json")
    end
  end

  def create(conn, %{"todo" => todo_params, "token" => token}) do
    case Phoenix.Token.verify(ExTodoWeb.Endpoint, "user salt", token, max_age: 86400) do
      {:ok, user_id} ->
        todos = Todos.create_todo(user_id, todo_params)
        render(conn, "show.json", todos: todos)

      {:error, _} ->
        render(conn, "error.json")
    end
  end

  def delete(conn, %{"todo" => todo_params, "token" => token}) do
    case Phoenix.Token.verify(ExTodoWeb.Endpoint, "user salt", token, max_age: 86400) do
      {:ok, user_id} ->
        todos = Todos.delete_todo(user_id, todo_params)
        render(conn, "show.json", todos: todos)

      {:error, _} ->
        render(conn, "error.json")
    end
  end

  defp get_authorization_header(conn) do
    conn
    |> get_req_header("authorization")
    |> List.first()
  end

  #   def update(conn, %{"id" => id, "todo" => todo_params}) do
  #     todo = Todos.get_todo!(id)

  #     with {:ok, %Todo{} = todo} <- Todos.update_todo(todo, todo_params) do
  #       render(conn, "show.json", todo: todo)
  #     end
  #   end

  #   def delete(conn, %{"id" => id}) do
  #     todo = Todos.get_todo!(id)
  #     with {:ok, %Todo{}} <- Todos.delete_todo(todo) do
  #       send_resp(conn, :no_content, "")
  #     end
  #   end
end
