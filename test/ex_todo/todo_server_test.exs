defmodule TodoServerTest do
  use ExUnit.Case, async: true
  alias ExTodo.Storage.TodoServer
  alias ExTodo.Todos.Todo

  @valid_todo %Todo{title: "Todo", id: 1, complete: false, description: nil}
  @server_name "todo_list"

  setup do
    ExTodo.Storage.Supervisor.new_todo_list(@server_name)

    %{server: @server_name}
  end

  test "add_todo/2 create new todo successfully", %{server: server} do
    {:ok, todo} = TodoServer.add_todo(@valid_todo, server)

    assert todo == @valid_todo
  end

  test "delete_todo/2 delete todo successfully", %{server: server} do
    todo = todo_fixture(%{title: "delete", id: 1})
    TodoServer.delete_todo(todo, server)
    todos = TodoServer.all(server)

    todo_in_todos? = Enum.member?(todos, todo)

    assert todo_in_todos? == false
  end

  test "mark_complete/2 changes todo successfully", %{server: server} do
    todo_fixture(%{title: "mark_complete", id: 4, complete: false})
    TodoServer.mark_complete(4, server)

    {:ok, todo} = TodoServer.get(4, server)

    assert todo.complete
  end

  test "get/2 gets todo successfully with id", %{server: server} do
    todo_fixture(%{title: "get_todo", id: 6})
    {:ok, todo} = TodoServer.get(6, server)

    assert todo.title == "get_todo"
  end 
  test "all/1 returns list of all cards", %{server: server} do
    todos = TodoServer.all(server)
  end

  def todo_fixture(attrs \\ %{}) do
    {:ok, todo} = Map.merge(@valid_todo, attrs) |> TodoServer.add_todo(@server_name)

    todo
  end
end
