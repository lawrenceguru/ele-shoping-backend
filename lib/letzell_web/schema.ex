defmodule LetzellWeb.Schema do
  use Absinthe.Schema

  import Kronky.Payload
  alias LetzellWeb.Schema.Middleware.TranslateMessages
  alias Letzell.Recipes.Comment
  alias Letzell.Messages.Message
  alias Letzell.{Recipes, Accounts, Listings, Favorites, Messages}

  import_types(Absinthe.Type.Custom)
  import_types(Kronky.ValidationMessageTypes)
  import_types(LetzellWeb.Schema.OptionTypes)
  import_types(LetzellWeb.Schema.AccountsTypes)
  import_types(LetzellWeb.Schema.ReviewsTypes)
  import_types(LetzellWeb.Schema.RecipesTypes)
  import_types(LetzellWeb.Schema.FavoritesTypes)
  import_types(LetzellWeb.Schema.MessagesTypes)
  import_types(LetzellWeb.Schema.ListingsTypes)
  import_types(LetzellWeb.Schema.MetaTypes)

  import_types(LetzellWeb.Queries.AccountsQueries)
  import_types(LetzellWeb.Queries.RecipesQueries)
  import_types(LetzellWeb.Queries.ListingsQueries)
  import_types(LetzellWeb.Queries.FavoritesQueries)
  import_types(LetzellWeb.Queries.MessagesQueries)
  import_types(LetzellWeb.Queries.ReviewsQueries)
  import_types(LetzellWeb.Queries.MetaQueries)

  import_types(LetzellWeb.Mutations.AuthMutations)
  import_types(LetzellWeb.Mutations.AccountsMutations)
  import_types(LetzellWeb.Mutations.RecipesMutations)
  import_types(LetzellWeb.Mutations.ListingsMutations)
  import_types(LetzellWeb.Mutations.MessagesMutations)
  import_types(LetzellWeb.Mutations.FavoritesMutations)

  import_types(Absinthe.Type.Custom)
  import_types(Absinthe.Plug.Types)

  payload_object(:boolean_payload, :boolean)
  payload_object(:session_payload, :session)
  payload_object(:user_payload, :user)
  payload_object(:recipe_payload, :recipe)
  payload_object(:favorite_payload, :favorite)
  payload_object(:contact_payload, :contact)
  payload_object(:message_payload, :message)
  payload_object(:listing_payload, :listing)
  payload_object(:comment_payload, :comment)
  payload_object(:lookup_payload, :lookup)

  query do
    import_fields(:accounts_queries)
    import_fields(:recipes_queries)
    import_fields(:listings_queries)
    import_fields(:favorites_queries)
    import_fields(:reviews_queries)
    import_fields(:messages_queries)
    import_fields(:lookup_queries)
  end

  mutation do
    import_fields(:auth_mutations)
    import_fields(:accounts_mutations)
    import_fields(:recipes_mutations)
    import_fields(:listings_mutations)
    import_fields(:favorites_mutations)
    import_fields(:messages_mutations)
  end

  subscription do
    field :new_comment, :comment do
      arg(:sender_id, non_null(:id))
      arg(:recipe_id, non_null(:id))
      arg(:receiver_id, non_null(:id))

      trigger(
        :create_comment,
        topic: fn
          %Comment{} = comment -> ["new_comment:#{comment.sender.id}:#{comment.receiver.id}:#{comment.recipe.id}"]
          _ -> []
        end
      )

      config(fn args, _info ->
        {:ok, topic: "new_comment:#{args.sender_id}:#{args.receiver_id}:#{args.recipe_id}"}
      end)
    end

    field :new_message, :message do
      arg(:listing_id, non_null(:id))
      arg(:receiver_id, non_null(:id))

      trigger(
        :create_message,
        topic: fn
          %Message{} = message -> ["new_message:#{message.receiver.id}:#{message.listing.id}"]
          _ -> []
        end
      )

      config(fn args, _info ->
        {:ok, topic: "new_message:#{args.receiver_id}:#{args.listing_id}"}
      end)
    end

  end

  def middleware(middleware, _field, %Absinthe.Type.Object{identifier: :mutation}) do
    middleware ++ [&build_payload/2, TranslateMessages]
  end

  def middleware(middleware, _field, _object) do
    middleware
  end

  def plugins do
    [Absinthe.Middleware.Dataloader | Absinthe.Plugin.defaults()]
  end

  def dataloader() do
    Dataloader.new()
    |> Dataloader.add_source(Recipes, Recipes.data())
    |> Dataloader.add_source(Listings, Listings.data())
    |> Dataloader.add_source(Accounts, Accounts.data())
    |> Dataloader.add_source(Favorites, Favorites.data())
    |> Dataloader.add_source(Messages, Messages.data())
  end

  def context(ctx) do
    Map.put(ctx, :loader, dataloader())
  end
end
