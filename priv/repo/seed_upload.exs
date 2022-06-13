alias Letzell.Meta

categories = Meta.list_lookups("Category") |> Enum.map( fn cat -> cat.lookup_code end)

categories |> Enum.map( fn cat ->
    ExAws.S3.put_object("letzell","/#{cat}/", "") |> ExAws.request
    1..250 |> Enum.map ( fn image ->
            image_file = "#{cat}-#{image}.jpg"
            local_image = File.read!("/var/images/listings/#{cat}-#{image}.jpg")
            ExAws.S3.put_object("letzell/#{cat}", image_file, local_image) |> ExAws.request!()
        end)
end)
