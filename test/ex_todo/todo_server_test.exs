defmodule TodoServerTest do
  use ExUnit.Case, async: true
  alias ExTodo.Storage.TodoServer
  alias ExTodo.Todos.Todo

  @valid_todo %Todo{title: "Todo", id: 1, complete: false, description: nil}
  @server_name "todo_list"

  setup do
    ExTodo.Storage.Supervisor.new_todo_list(@server_name)
    %{user_server: @server_name}
  end

  test "add_todo/2 create new todo successfully", %{user_server: user_server} do
    {:ok, todo} = TodoServer.add_todo(@valid_todo, user_server)

    assert todo == @valid_todo
  end

  test "delete_todo/2 delete todo successfully", %{user_server: user_server} do
    todo = todo_fixture(%{title: "delete", id: 1})
    TodoServer.delete_todo(todo, user_server)

    {:ok, todos} = TodoServer.all(user_server)

    refute Enum.member?(todos, todo)
  end

  test "mark_complete/2 changes todo successfully", %{user_server: user_server} do
    todo_fixture(%{title: "mark_complete", id: 4, complete: false})
    TodoServer.mark_complete(4, user_server)
    {:ok, todo} = TodoServer.get(4, user_server)

    assert todo.complete
  end

  test "mark_complete/2 when map updates todo successfully", %{user_server: user_server} do
    todo = todo_fixture(%{title: "mark_complete", id: 4, complete: false})
    TodoServer.mark_complete(todo, user_server)

    {:ok, todo} = TodoServer.get(4, user_server)

    assert todo.complete
  end

  test "get/2 gets todo successfully with id", %{user_server: user_server} do
    todo_fixture(%{title: "get_todo", id: 6})
    {:ok, todo} = TodoServer.get(6, user_server)

    assert todo.title == "get_todo"
  end

  test "all/1 returns list of all cards", %{user_server: user_server} do
    todo_fixture(%{title: "get_todo", id: 7})
    {:ok, todos} = TodoServer.all(user_server)

    assert [_hd | _tl] = [todos] 
  end

  def todo_fixture(attrs \\ %{}) do
    {:ok, todo} = Map.merge(@valid_todo, attrs) |> TodoServer.add_todo(@server_name)

    todo
  end
end
