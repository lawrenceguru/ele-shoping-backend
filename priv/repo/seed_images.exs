alias Letzell.Meta

Application.ensure_all_started :inets

categories = Meta.list_lookups("Category") |> Enum.map( fn cat -> cat.lookup_code end)

categories  |> Task.async_stream( fn category ->
        1..250 |> Enum.map( fn image ->
            case :httpc.request(:get, {'https://source.unsplash.com/random/?#{category}', []}, [], [body_format: :binary]) do
                {:ok, resp}  ->     {{_, 200, 'OK'}, _headers, body} = resp
                                    File.write!("/var/images/listings/#{category}-#{image}.jpg", body)
                                    :timer.sleep(5000)
                {:error, _}  -> :ok
            end
        end)
end, max_concurrency: 25,timeout: :infinity) |> Enum.to_list
