class BillingCardInfo < ActiveRecord::Base
  attr_accessible :state, :city, :address, :postal_code, :phone_number, :country, :card_type, :card_number, :expiration_month, :expiration_year, :cvv, :card_holder_name, :user_id
end
