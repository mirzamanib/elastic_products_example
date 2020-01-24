# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
ActiveRecord::Migration.say_with_time 'Products' do
  products_file = File.read(Rails.root.join('vendor', 'products.json'))
  products_hash = JSON.parse(products_file)
  products_hash.each { |h| Product.create(h) }
  puts "#{products_hash.size} Products Created."
  puts Product.count.to_s
end
