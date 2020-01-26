class Product < ApplicationRecord
  include Elasticsearch::Model
  include Searchable


  validates_presence_of(:title, :price)
  validates_uniqueness_of :title

end

# Delete the previous articles index in Elasticsearch
begin
  Product.__elasticsearch__.client.indices.delete index: Product.index_name
rescue StandardError
  nil
end

# Create the new index with the new mapping
Product.__elasticsearch__.client.indices.create \
  index: Product.index_name,
  body: { settings: Product.settings.to_hash, mappings: Product.mappings.to_hash }

# Index all article records from the DB to Elasticsearch
Product.import
Product.__elasticsearch__.refresh_index!