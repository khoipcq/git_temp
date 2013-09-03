class AddOrgActiveColumn < ActiveRecord::Migration
  def up
  	add_column :organizations,:is_org_active,:boolean,:default => true
  end

  def down
  end
end
