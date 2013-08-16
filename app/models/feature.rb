class Feature < ActiveRecord::Base
  attr_accessible :name, :description, :status, :order
  has_many :feature_pricing_plans
end
