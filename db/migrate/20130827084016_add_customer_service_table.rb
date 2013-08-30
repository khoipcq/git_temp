class AddCustomerServiceTable < ActiveRecord::Migration
  def up
    create_table :customers do |t|
      t.integer :organization_id
      t.string :first_name
      t.string :last_name
      t.string :gender
      t.string :email
      t.string :state
      t.string :city
      t.string :address
      t.string :postal_code
      t.string :country
      t.string :phone
      t.string :note
      t.date :date_of_birth
      t.timestamps
    end
    create_table :services do |t|
      t.integer :organization_id
      t.string :name
      t.string :description
      t.timestamps
    end
    create_table :service_staffs do |t|
      t.integer :service_id
      t.string :user_id
      t.timestamps
    end
  end

  def down
    drop_table :customers
    drop_table :services
    drop_table :service_staffs
  end
end
