defmodule Letzell.Helpers do
  def id() do
    min = String.to_integer("1000000", 36)
    max = String.to_integer("ZZZZZZZ", 36)

    max
    |> Kernel.-(min)
    |> :rand.uniform()
    |> Kernel.+(min)
    |> Integer.to_string(36)
  end
end
