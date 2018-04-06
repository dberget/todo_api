defmodule ExTodo.Storage.Supervisor do
  use Supervisor
  alias ExTodo.Storage

  def start_link do
    # We are now registering our supervisor process with a name
    # so we can reference it in the `start_room/1` function
    Supervisor.start_link(__MODULE__, [], name: :todo_supervisor)
  end

  def start_list(name) do
    # And we use `start_child/2` to start a new Chat.Server process
    Supervisor.start_child(:todo_supervisor, [name])
  end

  def init(_) do
    children = [
      worker(Storage.TodoServer, [])
    ]

    # We also changed the `strategy` to `simple_one_for_one`.
    # With this strategy, we define just a "template" for a child,
    # no process is started during the Supervisor initialization,
    # just when we call `start_child/2`
    supervise(children, strategy: :simple_one_for_one)
  end
end
