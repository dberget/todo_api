defmodule ExTodo.Todos do
  alias ExTodo.Storage.TodoServer
  alias ExTodo.Todos.Todo


  def list_todos(user_pid) do
    TodoServer.all(user_pid)
  end

  def get_todo(todo_id, user_pid), do: TodoServer.get(user_pid, todo_id)

  def create_todo(attrs, user_pid) do
   %Todo{}
   |> Map.merge(attrs)
   |> TodoServer.add_todo(user_pid)
  end

  def delete_todo(%Todo{} = todo, user_pid) do
     TodoServer.delete_todo(user_pid, todo)
  end
end
