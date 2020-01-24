class ProductsController < ApplicationController
  def index
    byebug
    @products = Product.all
    render :index
  end
end
