defmodule SanchonetExplorer.Release do
  @moduledoc """
  Used for executing DB release tasks when run in production without Mix
  installed.
  """

  # @app :sanchonet_explorer

  def migrate do
    raise "Should never run migrate"
    # load_app()

    # for repo <- repos() do
    #   {:ok, _, _} = Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :up, all: true))
    # end
  end

  # def rollback(repo, version) do
  #   load_app()
  #   {:ok, _, _} = Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :down, to: version))
  # end

  # defp repos do
  #   Application.fetch_env!(@app, :ecto_repos)
  # end

  # defp load_app do
  #   Application.load(@app)
  # end
end
