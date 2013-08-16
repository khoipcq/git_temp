class CreateFeatures < ActiveRecord::Migration
  def change
    create_table :features do |t|
      t.string :name
      t.string :description
      t.boolean :status, :default => true
      t.integer :order

      t.timestamps
    end
  end
end
