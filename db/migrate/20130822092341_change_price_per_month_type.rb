class ChangePricePerMonthType < ActiveRecord::Migration
  def change
  	change_column :pricing_plans, :price_per_month,:float
  end
end
