class CreateFeaturesPricingPlans < ActiveRecord::Migration
  def change
    create_table :features_pricing_plans do |t|
      t.integer :feature_id
      t.integer :pricing_plan_id

      t.timestamps
    end
  end
end
