class Product < ApplicationRecord
  validates_presence_of(:title, :price)
  validates_uniqueness_of :title
end