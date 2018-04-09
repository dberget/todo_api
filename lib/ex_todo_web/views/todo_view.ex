defmodule ExTodoWeb.TodoView do
  use ExTodoWeb, :view
  alias ExTodoWeb.TodoView

  def render("new.json", %{token: token}) do
    %{token: token}
  end

  def render("list.json", %{todos: todos}) do
    render_many(todos, TodoView, "todo.json")
  end

  def render("show.json", %{todo: todo}) do
    %{data: render_one(todo, TodoView, "todo.json")}
  end

  def render("todos.json", %{todos: todos}) do
    %{todos: todos}
  end

  def render("todo.json", %{todo: todo}) do
    %{todo: todo}
  end

  def render("token.json", %{token: token}) do
    %{token: token}
  end
end
