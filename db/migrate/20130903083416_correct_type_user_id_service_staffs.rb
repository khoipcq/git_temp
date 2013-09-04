class CorrectTypeUserIdServiceStaffs < ActiveRecord::Migration
  def up
  	remove_column :service_staffs, :user_id
  	add_column :service_staffs, :user_id,:integer
  end

  def down
  end
end
