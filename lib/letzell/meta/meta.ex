defmodule Letzell.Meta do
  import Ecto.Query, warn: false
  alias Letzell.Repo
  alias Letzell.Meta.Lookup
  alias Letzell.Meta.PostalCode
  alias :math, as: Math
  alias Ecto.Adapters.SQL

  @radius 3959

  def list_lookups(category) do
    with {_, lookups} <- Cachex.fetch(:meta_cache, category, &get_lookups/1) do
      # Cachex.expire(:lookups_cache,  category, :timer.seconds(7200))
      lookups
    end
  end

  defp get_lookups(category) do
    results = Repo.all(from(l in Lookup, where: l.lookup_type == ^category))
  end

  def get_lookup_description(category, value) do
    lookups = list_lookups(category)
    case lookups do
      nil -> Repo.one(from l in Lookup, where: l.lookup_type == ^category and l.lookup_code == ^value, select: l.description)
      _ -> get_value_from_list(lookups, value)
    end
  end

  defp get_value_from_list(lookups, value) do
    lookup_value = lookups |> Enum.filter( fn lookup -> lookup.lookup_code == value end)
    lookup = case lookup_value do
              [] -> nil
              _ ->
                test = hd lookup_value
                test.description
            end
  end

  def create_lookup(attrs) do
    %Lookup{}
    |> Lookup.changeset(attrs)
    |> Repo.insert()
  end

  def update_lookup(attrs) do
    %Lookup{}
    |> Lookup.changeset(attrs)
    |> Repo.update()
  end

  def list_postal_codes do
    Repo.all(PostalCode)
  end

  def get_postal_code!(id), do: Repo.get!(PostalCode, id)

  def get_geolocation(postal_code), do: Repo.get_by(PostalCode, postal_code: postal_code)

  def get_distance(from, to) do
    [from_postal, to_postal] =
      PostalCode |> where([p], p.postal_code in [^from, ^to]) |> Repo.all()

    from_location = {from_postal.latitude, from_postal.longitude}
    to_location = {to_postal.latitude, to_postal.longitude}

    distance = calculate_distance(from_location, to_location)
  end

  def get_geolocations_by_radius(postal_code, distance) do
    query =
      from(p0 in PostalCode,
        join: p1 in PostalCode,
        where:
          p1.postal_code == ^postal_code and
            fragment(
              "(3958*3.1415926*sqrt((p0.latitude-p1.latitude)*(p0.latitude-p1.latitude) 
                  + cos(p0.latitude/57.29578)*cos(p1.latitude/57.29578)*(p0.longitude-p1.longitude)*(p0.longitude-p1.longitude) )/180)"
            ) <= ^distance and
            p0.postal_code != ^postal_code,
         select: p0.postal_code
      )

    query |> Repo.all()
  end

  defp calculate_distance({lat1, long1}, {lat2, long2}) do
    lat_diff = degrees_to_radians(lat2 - lat1)
    long_diff = degrees_to_radians(long2 - long1)

    lat1 = degrees_to_radians(lat1)
    lat2 = degrees_to_radians(lat2)

    cos_lat1 = Math.cos(lat1)
    cos_lat2 = Math.cos(lat2)

    sin_lat_diff_sq = Math.sin(lat_diff / 2) |> Math.pow(2)
    sin_long_diff_sq = Math.sin(long_diff / 2) |> Math.pow(2)

    a = sin_lat_diff_sq + cos_lat1 * cos_lat2 * sin_long_diff_sq
    c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a))

    (@radius * c) |> Float.round(2)
  end

  defp degrees_to_radians(degrees) do
    degrees * (Math.pi() / 180)
  end

  def create_postal_code(attrs \\ %{}) do
    %PostalCode{}
    |> PostalCode.changeset(attrs)
    |> Repo.insert()
  end

  def update_postal_code(%PostalCode{} = postal_code, attrs) do
    postal_code
    |> PostalCode.changeset(attrs)
    |> Repo.update()
  end

  def delete_postal_code(%PostalCode{} = postal_code) do
    Repo.delete(postal_code)
  end

  def change_postal_code(%PostalCode{} = postal_code, attrs \\ %{}) do
    PostalCode.changeset(postal_code, attrs)
  end
end
