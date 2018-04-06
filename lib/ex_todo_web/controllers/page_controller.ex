defmodule ExTodoWeb.PageController do
  use ExTodoWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
