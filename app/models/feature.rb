class Feature < ActiveRecord::Base
  attr_accessible :name, :description, :status, :order
  has_many :feature_pricing_plans
  scope :is_active, where(:status => true)
  def self.get_all_feature
    all_feature = self.is_active.all.order(:order)
  end  	
end
