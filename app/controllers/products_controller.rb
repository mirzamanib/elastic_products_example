class ProductsController < ApplicationController
  def index
    @products = Product.all
    filter_products
    sort_products
    @products = @products.page(params[:page] || 1).per(params[:per] || 10)
    render :index
  end

  private

  def filter_products
    arel_table = Product.arel_table
    @products = Product.search(params[:search]).records if params[:search].present?
    if params[:price].present? && params[:operator]
      @products = @products.where(arel_table[:price].gt(params[:price])) if params[:operator] == '>'
      @products = @products.where(arel_table[:price].eq(params[:price])) if params[:operator] == '='
      @products = @products.where(arel_table[:price].lt(params[:price])) if params[:operator] == '<'
    end
    @products = @products.where(arel_table[:country].eq(params[:country])) if params[:country].present?
  end

  def sort_products
    @products = case params[:sort]
                when 'newest' then @products.order(created_at: :desc)
                when 'most_expensive' then @products.order(price: :desc)
                when 'least_expensive' then @products.order(price: :asc)
                else; @products
                end
  end
end
