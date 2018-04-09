defmodule ExTodo.Todos do
  alias ExTodo.Storage.TodoServer
  alias ExTodo.Todos.Todo

  def list_todos(user_pid) do
    TodoServer.all(user_pid)
  end

  def get_todo(todo_id, user_pid), do: TodoServer.get(todo_id, user_pid)

  def create_todo(attrs, user_pid) do
    Todo
    |> to_struct(attrs)
    |> TodoServer.add_todo(user_pid)
  end

  def todo_complete(todo, user_pid), do: TodoServer.mark_complete(todo, user_pid)

  def delete_todo(%Todo{} = todo, user_pid) do
    TodoServer.delete_todo(user_pid, todo)
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
