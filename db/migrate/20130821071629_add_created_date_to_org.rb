class AddCreatedDateToOrg < ActiveRecord::Migration
  def change
    change_table(:organizations) {|t| t.timestamps}
  end
end
