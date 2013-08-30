class AddStoreOwnerInfomation < ActiveRecord::Migration
  def up
    add_column :organizations, :state,:string,:default =>""
    add_column :organizations, :city,:string,:default =>""
    add_column :organizations, :address,:string,:default =>""
    add_column :organizations, :country,:string,:default =>""
    add_column :organizations, :phone,:string,:default =>""
    add_column :organizations,:pricing_plan_id,:integer,:default =>0
  end

  def down
  end
end
