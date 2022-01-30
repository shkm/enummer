class AddWeirdFieldsToUser < ActiveRecord::Migration[7.0]
  def change
    change_table :users do |t|
      t.column :facial_features, "bit(8)"
      t.column :diets, "bit(8)"
      t.column :transport, "bit(8)"
      t.column :home, "bit(8)"
    end
  end
end
