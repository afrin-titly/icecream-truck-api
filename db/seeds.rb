# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

# Create Categories
Category.create!([
  { name: 'Ice Cream' },
  { name: 'Shaved Ice' },
  { name: 'Snack Bars' }
])

# Create Flavors
Flavor.create!([
  { name: 'Chocolate' },
  { name: 'Vanilla' },
  { name: 'Strawberry' },
  { name: 'Mint' }
])

# Create Users
User.create!([
  { email: 'user1@example.com', password: 'password' },
  { email: 'user2@example.com', password: 'password' }
])

# Create Items
ice_cream_category = Category.find_by(name: 'Ice Cream')
shaved_ice_category = Category.find_by(name: 'Shaved Ice')

Item.create!([
  { name: 'Chocolate Ice Cream', price: 3.5, flavor_id: Flavor.find_by(name: 'Chocolate').id, category_id: ice_cream_category.id, stock: 20 },
  { name: 'Vanilla Ice Cream', price: 3.5, flavor_id: Flavor.find_by(name: 'Vanilla').id, category_id: ice_cream_category.id, stock: 15 },
  { name: 'Strawberry Ice Cream', price: 4.0, flavor_id: Flavor.find_by(name: 'Strawberry').id, category_id: ice_cream_category.id, stock: 10 },
  { name: 'Mint Ice Cream', price: 4.0, flavor_id: Flavor.find_by(name: 'Mint').id, category_id: ice_cream_category.id, stock: 10 },
  { name: 'Shaved Ice', price: 2.0, flavor_id: nil, category_id: shaved_ice_category.id, stock: 30 }
])

# Create Orders with Sales (example)
User.all.each do |user|
  Order.transaction do
    order = Order.create!(user: user)

    # Example sales for the order
    Sale.create!([
      { item_id: Item.find_by(name: 'Chocolate Ice Cream').id, quantity: 2, total_price: 7.0, order_id: order.id },
      { item_id: Item.find_by(name: 'Strawberry Ice Cream').id, quantity: 1, total_price: 4.0, order_id: order.id }
    ])

    order.calculate_total_price
  end
end
