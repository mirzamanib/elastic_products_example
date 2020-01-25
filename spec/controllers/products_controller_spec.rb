require 'rails_helper'

RSpec.describe ProductsController, type: :controller do
  describe 'GET #index' do
    it 'returns http success' do
      get :index

      expect(response).to have_http_status(:success)
    end
  end

  context 'when Sort Results' do
    describe 'Basic Functionality' do
      it 'has all the products' do
        get :index

        expect(assigns[:products].total_count).to eq(Product.count)
      end

      it 'returns first 10 products' do
        get :index

        expect(assigns[:products]).to eq(Product.first(10))
      end
    end

    describe 'Sort Functionality' do
      it 'Sort by Newest' do
        params = {
          sort: 'newest'
        }

        get :index, params: params

        expect(assigns[:products].first).to eq(Product.order(created_at: :desc).first)
      end

      it 'Sort by Most Expensive' do
        params = {
          sort: 'most_expensive'
        }

        get :index, params: params

        expect(assigns[:products].first).to eq(Product.order(price: :desc).first)
      end

      it 'Sort by Least Expensive' do
        params = {
          sort: 'least_expensive'
        }

        get :index, params: params

        expect(assigns[:products].first).to eq(Product.order(price: :asc).first)
      end
    end
  end

  context 'when Filter Results' do
    describe 'Filter Functionality' do
      let(:price) { Product.distinct.pluck(:price).uniq.sample }
      let(:countries) { Product.distinct.pluck(:country).sample(2) }

      it 'Filter Country' do
        params = {
          country: countries
        }

        get :index, params: params

        expect(countries.include?(assigns[:products].map(&:country).uniq) ||
                   assigns[:products].map(&:country).uniq.sort == countries.sort).to be_truthy
      end

      it 'Filter Price equals to ?' do
        params = {
          operator: '=',
          price: price
        }
        get :index, params: params

        expect(assigns[:products].map(&:price).uniq.first).to eq(price)
        expect(assigns[:products].map(&:id)).to eq(Product.where(price: price).first(10).map(&:id))
      end

      it 'Filter Price lower than ?' do
        params = {
          operator: '<',
          price: price
        }
        get :index, params: params

        expect(assigns[:products].map(&:price).select { |p| p >= price }).not_to be_any
        expect(assigns[:products].map(&:id)).to eq(Product.where('price < ?', price).first(10).map(&:id))
      end

      it 'Filter Price greater than ?' do
        params = {
          operator: '>',
          price: price
        }
        get :index, params: params

        expect(assigns[:products].map(&:price).select { |p| p <= price }).not_to be_any
        expect(assigns[:products].map(&:id)).to eq(Product.where('price > ?', price).first(10).map(&:id))
      end
    end
  end

  context 'with Full Text Search Results' do
    describe 'search for Oil' do
      it 'finds products with Oil' do
        params = {
          search: 'Oil'
        }

        get :index, params: params

        expect(assigns[:products].map(&:id)).to eq(Product.search('Oil').records.first(10).map(&:id))
      end
    end
  end
end
