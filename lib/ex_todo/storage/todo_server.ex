defmodule ExTodo.Storage.TodoServer do
  use GenServer

  ## Client Api

  @doc """
  start the Database GenServer
  """

  def start_link(user_server) do
    GenServer.start_link(__MODULE__, [], name: via_tuple(user_server))
  end

  def all(user_server) do
    GenServer.call(via_tuple(user_server), {:get_state})
  end

  def add_todo(todo, user_server) do
    GenServer.call(via_tuple(user_server), {:add_todo, todo})
  end

  def get(todo_id, user_server) do
    GenServer.call(via_tuple(user_server), {:get_todo, todo_id})
  end

  def mark_complete(todo, user_server) do
    GenServer.call(via_tuple(user_server), {:mark_complete, todo})
  end

  def delete_todo(todo, user_server) do
    GenServer.call(via_tuple(user_server), {:delete_todo, todo})
  end

  defp via_tuple(user_server) do
    {:via, ExTodo.Storage.Registry, {:todo_list, user_server}}
  end

  ## Server Callbacks

  def init(state) do
    {:ok, state}
  end

  def handle_call({:add_todo, todo}, _from, state) do
    new_state = [todo | state]

    {:reply, {:ok, todo}, new_state}
  end

  def handle_call({:get_todo, todo_id}, _from, state) do
    todo = Enum.filter(state, &(&1.id == todo_id)) |> List.first()

    {:reply, {:ok, todo}, state}
  end

  def handle_call({:mark_complete, todo}, _from, state) when is_map(todo) do
    new_state = Enum.map(state, &if(&1.id == todo.id, do: %{&1 | complete: true}, else: &1))

    {:reply, new_state, new_state}
  end

  def handle_call({:mark_complete, todo}, _from, state) when is_integer(todo) do
    new_state = Enum.map(state, &if(&1.id == todo, do: %{&1 | complete: true}, else: &1))

    {:reply, new_state, new_state}
  end

  def handle_call({:delete_todo, todo}, _from, state) do
    new_state = Enum.reject(state, &(&1.id == todo.id))

    {:reply, new_state, new_state}
  end

  def handle_call({:get_state}, _from, state) do
    {:reply, {:ok, state}, state}
  end
end
