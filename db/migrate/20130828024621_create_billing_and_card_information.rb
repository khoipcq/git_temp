class CreateBillingAndCardInformation < ActiveRecord::Migration
  def up
  	create_table :billing_infos do |t|
      t.belongs_to :user
      t.string :state
      t.string :city
      t.string :address
      t.string :postal_code
      t.string :phone_number
 
      t.timestamps
    end

    create_table :card_infos do |t|
      t.belongs_to :user
      t.string :card_type
      t.string :card_number
      t.string :expiration_month
      t.string :expiration_year
      t.string :cvv
      t.string :card_holder_name
      t.timestamps
    end
  end

  def down
  	drop_table :billing_infos
  	drop_table :card_infos
  end
end
