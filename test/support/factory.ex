defmodule Letzell.Factory do
  @dialyzer {:nowarn_function, fields_for: 1}
  use ExMachina.Ecto, repo: Letzell.Repo

  def user_factory do
    %Letzell.Accounts.User{
      name: Faker.Superhero.name(),
      email: sequence(:email, &"#{&1}#{Faker.Internet.email()}"),
      password: "12341234",
      password_hash: Comeonin.Bcrypt.hashpwsalt("12341234"),
      confirmed_at: Timex.now()
    }
  end

  def with_recipes(%Letzell.Accounts.User{} = user) do
    insert_list(10, :recipe, author: user)
    user
  end

  def recipe_factory do
    %Letzell.Recipes.Recipe{
      title: sequence(:email, &"title#{&1}"),
      content: sequence(:email, &"content#{&1}"),
      total_time: "30 min",
      level: "Facile",
      budget: "Bon marché",
      uuid: Ecto.UUID.generate(),
      author: build(:user)
    }
  end
end
