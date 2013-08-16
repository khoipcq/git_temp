class CreatePricingPlans < ActiveRecord::Migration
  def change
    create_table :pricing_plans do |t|
      t.string :name
      t.string :description
      t.boolean :status, :default => true
      t.integer :price_per_month
      t.integer :number_of_stores
      t.integer :user_staff

      t.timestamps
    end
  end
end
