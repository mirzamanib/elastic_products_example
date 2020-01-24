require 'rails_helper'

RSpec.describe Product, type: :model do
  describe 'Validations' do
    subject { Product.create }

    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:price) }

    it { is_expected.to validate_uniqueness_of(:title) }
  end
end
