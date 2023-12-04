defmodule SanchonetExplorer.Queries do
  alias SanchonetExplorer.Repo

  @query_all_pools """
  SELECT ph.id, view, url FROM pool_hash ph
    LEFT JOIN pool_metadata_ref pmr ON ph.id = pmr.pool_id ORDER BY ph.id ASC;
  """

  @spec list_all_pools_with_metadata_url() :: {:ok, any()} | {:error, []}
  def list_all_pools_with_metadata_url do
    results =
      Ecto.Adapters.SQL.query(Repo, @query_all_pools, [], [])
      |> parse_results()

    case results do
      {:ok, results} ->
        pool_data =
          Enum.map(results, fn [id, pool_id, metadata_url] ->
            %{id: id, pool_id: pool_id, metadata_url: metadata_url}
          end)

        {:ok, pool_data}

      {:error, _} ->
        []
    end
  end

  defp parse_results({:ok, %{rows: rows}}) do
    {:ok, rows}
  end

  defp parse_results(_) do
    {:error, []}
  end
end
