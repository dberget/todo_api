defmodule ExTodo.Todos do
  alias ExTodo.Storage.TodoServer
  alias ExTodo.Todos.Todo

  def list(user_server) do
    TodoServer.all(user_server)
  end

  def get(todo_id, user_server), do: TodoServer.get(todo_id, user_server)

  def create(%{id: id} = attrs, _user_server) when is_nil(id) do
    {:error, "id can't be nil in #{attrs}"}
  end

  def create(attrs, user_server) do
    Todo
    |> to_struct(attrs)
    |> TodoServer.add_todo(user_server)
  end

  def todo_complete(todo, user_server), do: TodoServer.mark_complete(todo, user_server)

  def delete(todo_params, user_server) do
    Todo
      |> to_struct(todo_params)
      |> TodoServer.delete_todo(user_server)
  end

  defp to_struct(kind, attrs) do
    struct = struct(kind)

    Enum.reduce(Map.to_list(struct), struct, fn {k, _}, acc ->
      case Map.fetch(attrs, Atom.to_string(k)) do
        {:ok, v} -> %{acc | k => v}
        :error -> acc
      end
    end)
  end
end
