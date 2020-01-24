class ProductsController < ApplicationController
  def index
    @products = Product.all.page(params[:page] || 1).per(params[:per] || 10)
    render :index
  end
end
