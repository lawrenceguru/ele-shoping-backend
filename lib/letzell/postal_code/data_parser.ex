defmodule Letzell.PostalCode.DataParser do
  @us_postal_codes "data/US.txt"

  alias Letzell.Meta
  alias Letzell.Meta.PostalCode

  def parse_data do
    [_header | data_rows] = File.read!(@us_postal_codes) |> String.split("\n")

    data_rows
    |> Stream.map(&String.split(&1, "\t"))
    |> Stream.filter(&data_row?(&1))
    |> Stream.map(&parse_data_columns(&1))
    |> Stream.map(&format_row(&1))
    |> Enum.into(%{})
  end

  def insert_data do
    [_header | data_rows] = File.read!(@us_postal_codes) |> String.split("\n")

    data_rows
    |> Stream.map(&String.split(&1, "\t"))
    |> Stream.filter(&data_row?(&1))
    |> Stream.map(fn row ->
      [country_code, postal_code, place_name, state_name, state_code, county_name, county_code, community_name, community_code, latitude, longitude, accuracy] = row

      Meta.create_postal_code(%{
        country_code: country_code,
        postal_code: postal_code,
        place_name: place_name,
        state_code: state_name,
        state_code: state_code,
        county_name: county_name,
        county_code: county_code,
        community_name: community_name,
        community_code: community_code,
        latitude: latitude,
        longitude: longitude,
        accuracy: accuracy
      })
    end)
    |> Enum.to_list()
  end

  defp data_row?(row) do
    case row do
      [_country_code, _postal_code, _place_name, _state_name, _state_code, _county_name, _county_code, _, _, _latitude, _longitude, _accuracy] -> true
      _ -> false
    end
  end

  defp parse_data_columns(row) do
    [_, postal_code, place_name, _, state_code, _, _, _, _, latitude, longitude, _] = row
    [postal_code, place_name, state_code, latitude, longitude]
  end

  defp parse_number(str) do
    {f, _} = Float.parse(str |> String.replace(" ", ""))

    f
  end

  # format three element list into a two element tuple
  # [postal_code, latitude, longitude] # => {postal_code, {latitude, longitude}}
  defp format_row([postal_code, place_name, state_code, latitude, longitude]) do
    latitude = parse_number(latitude)
    longitude = parse_number(longitude)
    {postal_code, %{place_name: place_name, state_code: state_code, latitude: latitude, longitude: longitude}}
  end
end
