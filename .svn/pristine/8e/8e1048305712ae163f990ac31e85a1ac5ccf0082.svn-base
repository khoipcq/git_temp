class CreatePaymentHistories < ActiveRecord::Migration
  def change
    create_table :payment_histories do |t|
      t.integer :user_id
      t.integer :pricing_plan_id
      t.float :total_paid

      t.timestamps
    end
  end
end
