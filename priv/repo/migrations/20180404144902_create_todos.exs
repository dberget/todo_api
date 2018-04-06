defmodule ExTodo.Repo.Migrations.CreateTodos do
  use Ecto.Migration

  def change do
    create table(:todos) do

      timestamps()
    end

  end
end
