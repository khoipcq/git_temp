class Service < ActiveRecord::Base
  attr_accessible :name, :organization_id,:description
  has_many :service_staffs
end
