class ProductsIndex < Chewy::Index
  define_type Product do
    field :title, :description, :tags, :country, type: 'string'
    field :price, type: 'integer'
  end
end
