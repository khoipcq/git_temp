class CreateBillingCardInformation < ActiveRecord::Migration
  def up
  	create_table :billing_card_infos do |t|
      t.belongs_to :user
      t.string :state
      t.string :city
      t.string :address
      t.string :postal_code
      t.string :country
      t.string :phone_number
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
  	  drop_table :billing_card_infos
  end
end
