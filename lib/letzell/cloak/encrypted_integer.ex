defmodule Letzell.Encrypted.Integer do
  use Cloak.Ecto.Integer, vault: Letzell.Vault
end
