class CreateProducts < ActiveRecord::Migration[6.0]
  def change
    create_table :products do |t|
      t.string :title
      t.integer :price
      t.string :description
      t.string :tags
      t.string :country

      t.timestamps
    end
  end
end
