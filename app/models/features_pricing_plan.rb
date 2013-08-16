class FeaturesPricingPlan < ActiveRecord::Base
  attr_accessible :feature_id, :pricing_plan_id
  belongs_to :feature
  belongs_to :pricing_plan
end