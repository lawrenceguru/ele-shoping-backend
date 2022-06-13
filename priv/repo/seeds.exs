# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Letzell.Repo.insert!(%Letzell.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
# credo:disable-for-this-file

alias Letzell.Listings.Listing
alias Letzell.Accounts.User
alias Letzell.Reviews.Review
alias Letzell.Recipes.Recipe
alias Letzell.Recipes.Comment
alias Letzell.PostalCode.{DataParser, Store, Navigator}
alias Letzell.{Listings, Accounts, Recipes, Repo, Repo, Meta}
alias Letzell.Meta.Lookup
import Ecto.Query, warn: false

# Application.ensure_all_started :inets

# listing_images_url = "#{LetzellWeb.Endpoint.url()}/uploads/seed/listings"
# profile_images_url = "#{LetzellWeb.Endpoint.url()}/uploads/seed/profiles"
# place_images_url = "#{LetzellWeb.Endpoint.url()}/images"

# images_path = Letzell.ReleaseTasks.priv_path_for(Letzell.Repo, "images")

condition_lookup = [%{lookup_code: "new" ,  description: "New"},
                    %{lookup_code: "used-like-new" ,  description: "Used - Like New"},
                    %{lookup_code: "used-very-good" ,  description: "Used - Very Good"},
                    %{lookup_code: "used-good" ,  description: "Used - Good"},
                    %{lookup_code: "used-acceptable" ,  description: "Used - Acceptable"},
                    %{lookup_code: "reconditioned" ,  description: "Reconditioned"},
                    %{lookup_code: "for-parts" ,  description: "For Parts"} ]

category_lookup = [
              %{lookup_group: "Electronics", lookup_code: "mobile-phones" ,  description: "Mobile Phones"},
              %{lookup_group: "Electronics", lookup_code: "desktop-computers" ,  description: "Desktop Computers"},
              %{lookup_group: "Electronics", lookup_code: "computer-accessories" ,  description: "Computer Accessories"},
              %{lookup_group: "Electronics", lookup_code: "laptops" ,  description: "Laptops"},
              %{lookup_group: "Electronics", lookup_code: "wearables" ,  description: "Wearables"},
              %{lookup_group: "Electronics", lookup_code: "headsets" ,  description: "Headsets"},
              %{lookup_group: "Electronics", lookup_code: "tablets" ,  description: "Tablets"},
              %{lookup_group: "Electronics", lookup_code: "video-games" ,  description: "Video Games"},
              %{lookup_group: "Electronics", lookup_code: "tvs" ,  description: "TVs"},
              %{lookup_group: "Electronics", lookup_code: "media-players" ,  description: "Media Players"},
              %{lookup_group: "Electronics", lookup_code: "drones" ,  description: "Drones"},
              %{lookup_group: "Electronics", lookup_code: "cameras" ,  description: "Cameras"},
              %{lookup_group: "Electronics", lookup_code: "electronics-other" ,  description: "Electronics Other"},

              %{lookup_group: "Appliances", lookup_code: "refrigerators" ,  description: "Refrigerators"},
              %{lookup_group: "Appliances", lookup_code: "washers-driers" ,  description: "Washers & Driers"},
              %{lookup_group: "Appliances", lookup_code: "driers" ,  description: "Driers"},
              %{lookup_group: "Appliances", lookup_code: "dishwasher" ,  description: "Dishwashers"},
              %{lookup_group: "Appliances", lookup_code: "ovens" ,  description: "Ovens"},
              %{lookup_group: "Appliances", lookup_code: "cooktops" ,  description: "Cooktops"},
              %{lookup_group: "Appliances", lookup_code: "appliances-other" ,  description: "Appliances Other"},

              %{lookup_group: "Vehicles", lookup_code: "cars" ,  description: "Cars"},
              %{lookup_group: "Vehicles", lookup_code: "trucks" ,  description: "Trucks"},
              %{lookup_group: "Vehicles", lookup_code: "campers-rvs" ,  description: "Campers RVs"},
              %{lookup_group: "Vehicles", lookup_code: "boats" ,  description: "Boats"},
              %{lookup_group: "Vehicles", lookup_code: "motorcycles" ,  description: "Motorcyles"},
              %{lookup_group: "Vehicles", lookup_code: "trailers" ,  description: "Trailers"},
              %{lookup_group: "Vehicles", lookup_code: "tires" ,  description: "Tires"},
              %{lookup_group: "Vehicles", lookup_code: "auto-parts" ,  description: "Auto Parts"},
              %{lookup_group: "Vehicles", lookup_code: "vehicles-other" ,  description: "Vehicles Other"},

              %{lookup_group: "Jewelry/Watches", lookup_code: "jewelry" ,  description: "Jewelry"},
              %{lookup_group: "Jewelry/Watches", lookup_code: "kids-jewelry" ,  description: "Kids Jewelry"},
              %{lookup_group: "Jewelry/Watches", lookup_code: "ladies-watches" ,  description: "Ladies Watches"},
              %{lookup_group: "Jewelry/Watches", lookup_code: "mens-watches" ,  description: "Mens Watches"},

              %{lookup_group: "Fashion", lookup_code: "baby-kids-clothing" ,  description: "Baby & Kids Clothing"},
              %{lookup_group: "Fashion", lookup_code: "mens-clothing" ,  description: "Mens Clothing"},
              %{lookup_group: "Fashion", lookup_code: "ladies-clothing" ,  description: "Ladies Clothing"},
              %{lookup_group: "Fashion", lookup_code: "boys-clothing" ,  description: "Boys Clothing"},
              %{lookup_group: "Fashion", lookup_code: "girls-clothing" ,  description: "Girls Clothing"},
              %{lookup_group: "Fashion", lookup_code: "mens-shoes" ,  description: "Mens shoes"},
              %{lookup_group: "Fashion", lookup_code: "ladies-shoes" ,  description: "Ladies Shoes"},
              %{lookup_group: "Fashion", lookup_code: "boys-shoes" ,  description: "Boys Shoes"},
              %{lookup_group: "Fashion", lookup_code: "girls-shoes" ,  description: "Girls Shoes"},
              %{lookup_group: "Fashion", lookup_code: "perfumes" ,  description: "Perfumes"},
              %{lookup_group: "Fashion", lookup_code: "bags-and-purses" ,  description: "Bags and Purses"},
              %{lookup_group: "Fashion", lookup_code: "belts-and-hats" ,  description: "Belts and Hats"},
              %{lookup_group: "Fashion", lookup_code: "fashion-other" ,  description: "Fashion Other"},

              %{lookup_group: "Arts/Collectibles", lookup_code: "artwork" ,  description: "Artwork"},
              %{lookup_group: "Arts/Collectibles", lookup_code: "crafts" ,  description: "Crafts"},
              %{lookup_group: "Arts/Collectibles", lookup_code: "antique" ,  description: "Antiques"},
              %{lookup_group: "Arts/Collectibles", lookup_code: "collectibles" ,  description: "Collectibles"},
              %{lookup_group: "Arts/Collectibles", lookup_code: "handmade" ,  description: "Handmade"},
              %{lookup_group: "Arts/Collectibles", lookup_code: "books" ,  description: "Books"},
              %{lookup_group: "Arts/Collectibles", lookup_code: "movies" ,  description: "Movies"},
              %{lookup_group: "Arts/Collectibles", lookup_code: "musical-instruments" ,  description: "Musical Instruments"},
              %{lookup_group: "Arts/Collectibles", lookup_code: "arts-other" ,  description: "Arts Other"},

              %{lookup_group: "Home Decor", lookup_code: "beddings", description: "Bedding"},
              %{lookup_group: "Home Decor", lookup_code: "lamps", description: "Lamps"},
              %{lookup_group: "Home Decor", lookup_code: "mirrors", description: "Mirrors"},
              %{lookup_group: "Home Decor", lookup_code: "toss-pillows", description: "Toss Pillows"},
              %{lookup_group: "Home Decor", lookup_code: "clocks", description: "Clocks"},
              %{lookup_group: "Home Decor", lookup_code: "decorative", description: "Decorative Accessories"},
              %{lookup_group: "Home Decor", lookup_code: "wall-decor", description: "Wall Decor"},
              %{lookup_group: "Home Decor", lookup_code: "bath-linens", description: "Bath Linens"},
              %{lookup_group: "Home Decor", lookup_code: "window-treatments", description: "Window Treatments"},
              %{lookup_group: "Home Decor", lookup_code: "fountains", description: "Fountains"},
              %{lookup_group: "Home Decor", lookup_code: "home-decor-others", description: "Home Decor Others"},

              %{lookup_group: "Kitchen", lookup_code: "bakeware", description: "Bakeware"},
              %{lookup_group: "Kitchen", lookup_code: "cookware", description: "Cookware"},
              %{lookup_group: "Kitchen", lookup_code: "cutlery", description: "Cutlery"},
              %{lookup_group: "Kitchen", lookup_code: "cutting-boards", description: "Cutting Boards"},
              %{lookup_group: "Kitchen", lookup_code: "dinnerware", description: "Dinnerware"},
              %{lookup_group: "Kitchen", lookup_code: "flatware", description: "Flatware"},
              %{lookup_group: "Kitchen", lookup_code: "jars-containers", description: "Jars and Containers"},
              %{lookup_group: "Kitchen", lookup_code: "kitchen-gadgets", description: "Kitchen Gadgets"},
              %{lookup_group: "Kitchen", lookup_code: "kitchen-towels", description: "Kitchen Towels"},
              %{lookup_group: "Kitchen", lookup_code: "potholders", description: "Potholders and Oven Mitts"},
              %{lookup_group: "Kitchen", lookup_code: "serveware", description: "Serveware"},
              %{lookup_group: "Kitchen", lookup_code: "tea-kettles", description: "Tea Kettles"},
              %{lookup_group: "Kitchen", lookup_code: "utensils", description: "Utensils"},
              %{lookup_group: "Kitchen", lookup_code: "kitchen-others", description: "Kitchen Others"},

              %{lookup_group: "Pets", lookup_code: "pet-collars-leashes" ,  description: "Collars and Leashes"},
              %{lookup_group: "Pets", lookup_code: "pet-food" ,  description: "Pet Food"},
              %{lookup_group: "Pets", lookup_code: "pet-toys" ,  description: "Toys"},
              %{lookup_group: "Pets", lookup_code: "pet-clothing" ,  description: "Pet Clothing"},
              %{lookup_group: "Pets", lookup_code: "pet-health" ,  description: "Health"},
              %{lookup_group: "Pets", lookup_code: "pet-fences" ,  description: "Fences"},
              %{lookup_group: "Pets", lookup_code: "pet-training" ,  description: "Training"},
              %{lookup_group: "Pets", lookup_code: "pets-other" ,  description: "Pets Other"},

              %{lookup_group: "Home Office", lookup_code: "printers-inks" ,  description: "Printers, Ink"},
              %{lookup_group: "Home Office", lookup_code: "shredders" ,  description: "Shredders"},
              %{lookup_group: "Home Office", lookup_code: "scanners" ,  description: "Scanners"},
              %{lookup_group: "Home Office", lookup_code: "office-furniture" ,  description: "Office Furniture"},
              %{lookup_group: "Home Office", lookup_code: "fax-and-copiers" ,  description: "Fax and Copiers"},
              %{lookup_group: "Home Office", lookup_code: "projectors" ,  description: "Projectors"},
              %{lookup_group: "Home Office", lookup_code: "home-office-other" ,  description: "Home Office Other"},

              %{lookup_group: "Sports/Outdoors", lookup_code: "yoga-equipment", description: "Yoga Equipment"},
              %{lookup_group: "Sports/Outdoors", lookup_code: "excercise", description: "Excercise"},
              %{lookup_group: "Sports/Outdoors", lookup_code: "skateboards", description: "Skateboards"},
              %{lookup_group: "Sports/Outdoors", lookup_code: "camping", description: "Camping"},
              %{lookup_group: "Sports/Outdoors", lookup_code: "fishing", description: "Fishing"},
              %{lookup_group: "Sports/Outdoors", lookup_code: "sports-other", description: "Sports Other"},

              %{lookup_group: "Services", lookup_code: "tutoring", description: "Tutoring"},
              %{lookup_group: "Services", lookup_code: "event-planning", description: "Event Planning"},
              %{lookup_group: "Services", lookup_code: "tax-planning", description: "Tax Planning"},
              %{lookup_group: "Services", lookup_code: "child-care", description: "Child Care"},
              %{lookup_group: "Services", lookup_code: "landscaping", description: "Landscaping"},

              %{lookup_group: "Others", lookup_code: "others", description: "Other"}

            ]

Letzell.PostalCode.DataParser.insert_data

Lookup |> Repo.delete_all()

condition_lookup |> Enum.map(fn condition ->
  %{
    lookup_type: "Condition",
    lookup_code: condition.lookup_code,
    description: condition.description
  } |> Meta.create_lookup

end)

category_lookup |> Enum.map( fn category ->
 %{
    lookup_type: "Category",
    lookup_group:  category.lookup_group,
    lookup_code: category.lookup_code,
    description: category.description
  } |> Meta.create_lookup
end)
