class Customer < ActiveRecord::Base
	attr_accessible :first_name,:last_name,:organization_id,:email
end