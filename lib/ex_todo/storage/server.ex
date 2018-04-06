defmodule ExTodo.Storage.TodoServer do
  use GenServer

  ## Client Api

  @doc """
  start the Database GenServer
  """

  def start_link(state \\ []) do
    GenServer.start_link(__MODULE__, state)
  end

  def all(pid) do
    GenServer.call(pid, {:get_state})
  end

  def get(pid, todo_id) do
    GenServer.call(pid, {:get_todo, todo_id})
  end

  def mark_complete(pid, todo) do
    GenServer.call(pid, {:mark_complete, todo})
  end

  def add_todo(pid, todo) do
    GenServer.call(pid, {:push, todo})
  end

  def delete_todo(pid, todo) do
    GenServer.call(pid, {:delete_todo, todo})
  end

  ## Server Callbacks

  def init(state) do
    {:ok, state}
  end

  # returns :ok, async
  def handle_call({:push, todo}, _from, state) do
    new_state = [todo | state]
    {:reply, new_state, new_state}
  end

  def handle_call({:get_todo, todo_id}, _from, state) do
    todo = Enum.filter(state, &(&1.id == todo_id))

    {:reply, todo, state}
  end

  def handle_call({:mark_complete, todo}, _from, state) do
    new_state = Enum.map(state, &if(&1.id == todo.id, do: %{&1 | complete: true}, else: &1))

    {:reply, new_state, new_state}
  end

  def handle_call({:delete_todo, todo}, _from, state) do
    new_state = Enum.reject(state, &(&1.id == todo.id))

    {:reply, new_state, new_state}
  end

  def handle_call({:get_state}, _from, state) do
    {:reply, state, state}
  end
end
