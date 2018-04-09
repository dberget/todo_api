# defmodule ExTodo.TodosTest do
#   alias ExTodo.Todos

#   describe "todos" do
#     alias ExTodo.Todos.Todo

#     @valid_attrs %{title: "Todo", id: 1, complete: false, description: nil}
#     @update_attrs %{title: "Todo 2", id: 2, complete: true, description: nil}
#     @invalid_attrs %{}


#     def todo_fixture(attrs \\ %{}) do
#       {:ok, todo} =
#         attrs
#         |> Enum.into(@valid_attrs)
#         |> Todos.create_todo()

#       todo
#     end

#     test "list_todos/0 returns all todos" do
#       todo = todo_fixture()
#       assert Todos.list_todos() == [todo]
#     end

#     test "get_todo!/1 returns the todo with given id" do
#       todo = todo_fixture()
#       assert Todos.get_todo!(todo.id) == todo
#     end

#     test "create_todo/1 with valid data creates a todo" do
#       assert {:ok, %Todo{} = todo} = Todos.create_todo(@valid_attrs)
#     end

#     test "create_todo/1 with invalid data returns error changeset" do
#       assert {:error, %Ecto.Changeset{}} = Todos.create_todo(@invalid_attrs)
#     end

#     test "update_todo/2 with valid data updates the todo" do
#       todo = todo_fixture()
#       assert {:ok, todo} = Todos.update_todo(todo, @update_attrs)
#       assert %Todo{} = todo
#     end

#     test "update_todo/2 with invalid data returns error changeset" do
#       todo = todo_fixture()
#       assert {:error, %Ecto.Changeset{}} = Todos.update_todo(todo, @invalid_attrs)
#       assert todo == Todos.get_todo!(todo.id)
#     end

#     test "delete_todo/1 deletes the todo" do
#       todo = todo_fixture()
#       assert {:ok, %Todo{}} = Todos.delete_todo(todo)
#       assert_raise Ecto.NoResultsError, fn -> Todos.get_todo!(todo.id) end
#     end

#     test "change_todo/1 returns a todo changeset" do
#       todo = todo_fixture()
#       assert %Ecto.Changeset{} = Todos.change_todo(todo)
#     end
#   end

# end
