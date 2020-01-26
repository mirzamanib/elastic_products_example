module Searchable
  extend ActiveSupport::Concern


  included do
    include Elasticsearch::Model

    index_name Rails.application.class.module_parent_name.underscore

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
end