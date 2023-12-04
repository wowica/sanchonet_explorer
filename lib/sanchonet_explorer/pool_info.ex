defmodule SanchonetExplorer.PoolInfo do
  use GenServer

  alias SanchonetExplorer.Queries

  def start_link(opts) do
    {name, opts} = Keyword.pop(opts, :name, __MODULE__)
    {should_fetch, _opts} = Keyword.pop(opts, :should_fetch_data, false)

    GenServer.start_link(__MODULE__, should_fetch, name: name)
  end

  def init(should_fetch_data) do
    if should_fetch_data, do: schedule_fetch_data()

    initial_state = %{}
    {:ok, initial_state}
  end

  def handle_info(:update_pool_info, _state) do
    {:ok, pool_data} = Queries.list_all_pools_with_metadata_url()

    # Builds list of registered pools, sending those with missing
    # metadata_url towards the end of the list
    new_state =
      Enum.reduce(pool_data, [], fn pool, acc ->
        if (pool.metadata_url || "") |> String.trim() |> String.length() == 0 do
          acc ++ [%{pool_id: pool.pool_id}]
        else
          pool_info = fetch_pool_data(pool.metadata_url)
          [Map.merge(%{pool_id: pool.pool_id}, pool_info) | acc]
        end
      end)

    IO.inspect(new_state)

    {:noreply, new_state}
  end

  def handle_call(:get_pool_info, _from, state) do
    {:reply, state, state}
  end

  defp fetch_pool_data(metadata_url) do
    {:ok, %{body: raw_body}} = Req.request(metadata_url)

    raw_body
    |> parse_body
    |> build_data()
  end

  def get_pool_info(pid) do
    GenServer.call(pid, :get_pool_info)
  end

  defp parse_body(body) when is_map(body), do: body

  defp parse_body(body) when is_binary(body) do
    Jason.decode!(body)
  end

  defp build_data(body) do
    %{name: body["name"] || "", ticker: body["ticker"]}
  end

  defp schedule_fetch_data do
    IO.inspect("fetching data")
    Process.send_after(self(), :update_pool_info, 10_000)
  end
end
