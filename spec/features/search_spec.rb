require 'spec_helper'
class Home
  include Capybara::DSL
  def visit_homepage
    visit('/')
  end
end

describe 'Visit Search Page' do
  let(:home) { Home.new }

  it 'Able to see text, Search Products', js: true do
    home.visit_homepage
    expect(page).to have_content('Search Products')
  end

  it 'Has all the products', js: true do
    home.visit_homepage
    expect(page).to have_content('Search Products')
  end
end
