defmodule ExTodo.Storage.Supervisor do
  use Supervisor
  alias ExTodo.Storage

  def start_link do
    Supervisor.start_link(__MODULE__, [], name: :todo_supervisor)
  end

  def new_todo_list(name) do
    Supervisor.start_child(:todo_supervisor, [name])
  end

  def init(_) do
    children = [
      worker(Storage.TodoServer, [])
    ]

    supervise(children, strategy: :simple_one_for_one)
  end
end
