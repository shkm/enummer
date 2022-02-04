class AddWeirdFieldsToUser < ActiveRecord::Migration[7.0]
  def change
    change_table :users do |t|
      t.integer :facial_features
      t.integer :diets
      t.integer :transport
      t.integer :home
    end
  end
end
