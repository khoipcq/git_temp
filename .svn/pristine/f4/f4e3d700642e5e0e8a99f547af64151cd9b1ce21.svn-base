class AddExpiredDateAndIsPaymentOrg < ActiveRecord::Migration
  def up
  	add_column :organizations,:expired_date,:date
  	add_column :organizations,:is_monthly_paid,:boolean,:default => false
  end

  def down
  end
end
