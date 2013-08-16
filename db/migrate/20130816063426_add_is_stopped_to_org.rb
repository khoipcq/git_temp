class AddIsStoppedToOrg < ActiveRecord::Migration
  def change
  	add_column :organizations,:is_stopped,:boolean,:default => false
  end
end
