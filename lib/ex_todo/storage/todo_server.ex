defmodule ExTodo.Storage.TodoServer do
  use GenServer

  ## Client Api

  @doc """
  start the Database GenServer
  """

  def start_link(list_name) do
    GenServer.start_link(__MODULE__, [], name: via_tuple(list_name))
  end

  def all(list_name) do
    GenServer.call(via_tuple(list_name), {:get_state})
  end

  def add_todo(todo, list_name) do
    GenServer.call(via_tuple(list_name), {:add_todo, todo})
  end

  def get(todo_id, list_name) do
    GenServer.call(via_tuple(list_name), {:get_todo, todo_id})
  end

  def mark_complete(todo, list_name) do
    GenServer.call(via_tuple(list_name), {:mark_complete, todo})
  end

  def delete_todo(todo, list_name) do
    GenServer.call(via_tuple(list_name), {:delete_todo, todo})
  end

  defp via_tuple(list_name) do
    {:via, ExTodo.Storage.Registry, {:todo_list, list_name}}
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
    {:reply, state, state}
  end
end
