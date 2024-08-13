# Categories
categories = Category.create!([
  { name: "Chocolate" },
  { name: "Vanilla" },
  { name: "Strawberry" }
])

# Flavors
flavors = Flavor.create!([
  { name: "Dark Chocolate" },
  { name: "French Vanilla" },
  { name: "Strawberry Swirl" }
])

# Items
items = Item.create!([
  { name: "Chocolate Bar", price: 2.99, category: categories[0], flavor: flavors[0], stock: 100 },
  { name: "Vanilla Ice Cream", price: 4.99, category: categories[1], flavor: flavors[1], stock: 50 },
  { name: "Strawberry Milkshake", price: 3.49, category: categories[2], flavor: flavors[2], stock: 30 }
])

# Users
users = User.create!([
  { email: "admin@example.com", password: "password", admin: true },
  { email: "user1@example.com", password: "password", admin: false },
  { email: "user2@example.com", password: "password", admin: false }
])

# Orders
orders = Order.create!([
  { order_number: "ORD001", user: users[1], total_amount: 15.47 },
  { order_number: "ORD002", user: users[2], total_amount: 9.98 }
])

# Sales
sales = Sale.create!([
  { item: items[0], order: orders[0], quantity: 2, total_price: 5.98 },
  { item: items[1], order: orders[0], quantity: 2, total_price: 9.98 },
  { item: items[2], order: orders[1], quantity: 3, total_price: 10.47 }
])
