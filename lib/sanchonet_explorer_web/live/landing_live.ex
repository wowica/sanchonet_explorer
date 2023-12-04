defmodule SanchonetExplorerWeb.LandingLive do
  use Phoenix.LiveView

  def mount(_params, _session, socket) do
    pid = Process.whereis(SanchonetExplorer.PoolInfo)
    pool_info = SanchonetExplorer.PoolInfo.get_pool_info(pid)

    {:ok, assign(socket, pool_info: pool_info)}
  end

  def render(assigns) do
    ~H"""
    <!-- Container for centering the table and title -->
    <div class="flex flex-col">
      <header class="text-center mb-5 mt-10">
        <h1 class="text-4xl font-bold text-[#0098bb]">SanchoNet Explorer</h1>
      </header>
      <div class="flex flex-col justify-center items-center bg-blue-100">
        <div class="text-2xl font-semibold mb-4 text-blue-800">
          Pools
        </div>
        <div class="w-full max-w-2xl mx-auto overflow-x-auto shadow-lg">
          <table class="min-w-full table-auto bg-white rounded-lg overflow-hidden">
            <thead class="bg-blue-200 text-blue-800">
              <tr>
                <th class="px-4 py-3 text-left text-sm font-medium uppercase tracking-wider">
                  Ticker
                </th>
                <th class="px-4 py-3 text-left text-sm font-medium uppercase tracking-wider">
                  Name
                </th>
                <th class="px-4 py-3 text-left text-sm font-medium uppercase tracking-wider">
                  ID
                </th>
              </tr>
            </thead>
            <tbody class="divide-y divide-blue-300">
              <tr :for={pool_info <- assigns.pool_info}>
                <td class={[
                  "px-4 py-2 whitespace-nowrap text-sm text-gray-700",
                  if(Map.get(pool_info, :ticker), do: "font-bold")
                ]}>
                  <%= Map.get(pool_info, :ticker, "missing") %>
                </td>
                <td class="px-4 py-2 whitespace-nowrap text-sm text-gray-700">
                  <%= Map.get(pool_info, :name, "missing") %>
                </td>
                <td class="px-4 py-2 whitespace-nowrap text-sm text-gray-700">
                  <%= String.slice(pool_info.pool_id, 0..10) <>
                    "..." <> String.slice(pool_info.pool_id, -5..-1) %>
                </td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>
    </div>
    """
  end
end
