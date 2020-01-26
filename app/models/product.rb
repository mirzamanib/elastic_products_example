class Product < ApplicationRecord
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  index_name Rails.application.class.module_parent_name.underscore

  validates_presence_of(:title, :price)
  validates_uniqueness_of :title

  settings index: { number_of_shards: 1 } do
    mapping dynamic: false do
      indexes :title, analyzer: 'english'
      indexes :description, analyzer: 'english'
      indexes :tags, analyzer: 'english'
    end
  end

  def as_indexed_json(options={})
    self.as_json(only: [:id, :title, :description, :tags])
  end


  after_commit on: [:create] do
    __elasticsearch__.index_document
  end

  after_commit on: [:update] do
      __elasticsearch__.update_document
  end

  after_commit on: [:destroy] do
    __elasticsearch__.delete_document
  end

  def self.search(query)
    __elasticsearch__.search(
      query: {
        query_string: {
          type: 'phrase',
          query: "*#{query}*",
          fields: ['title^2', 'description', 'tags']
        }
      }
    )
  end
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