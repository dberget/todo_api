defmodule ExTodoWeb.TodoView do
  use ExTodoWeb, :view
  alias ExTodoWeb.TodoView

  def render("index.json", %{token: token}) do
    %{token: token}
  end

  def render("show.json", %{todo: todo}) do
    %{data: render_one(todo, TodoView, "todo.json")}
  end

  def render("todo.json", %{todo: todo}) do
    %{id: todo.id}
  end

  def render("token.json", %{token: token}) do
    %{token: token}
  end
end
