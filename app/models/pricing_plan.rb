class PricingPlan < ActiveRecord::Base
  
  attr_accessible :name, :description, :status, :price_per_month, :number_of_stores, :user_staff, :features_pricing_plans_attributes
  has_many :features, :through => :features_pricing_plans
  has_many :features_pricing_plans, :dependent => :destroy
  accepts_nested_attributes_for :features_pricing_plans
  scope :search_by_name, lambda { |search| where("lower(name) like :search or lower(description) like :search",{:search => "%" + search + "%"}) }
  
  ##
  #Get all pricing plan
  #Parameters::
  #Return::
  # * (json) pricing plan data
  #*Author*:: KhoiPCQ
  def self.get_all_pricing_plan(current_user, page, per_page, search, sort = nil)
    sort ||= "full_name"
    search ||= ""
    search = search.downcase
    pricing_plans  = PricingPlan.order(sort).search_by_name(search).paginate(:page => page, :per_page => per_page)
    return_data = {
      "aaData" => [],
      "iTotalDisplayRecords" => pricing_plans.total_entries
    }
    pricing_plans.each do |pricing_plan|
	  return_data["aaData"] << [
        pricing_plan.name,
        pricing_plan.description,
        pricing_plan.status,
        "",
        pricing_plan.id
      ]
    end
    return_data
  end

  ##
  #Delete pricing plan
  #Parameters::
  # * (Integer) *id*: pricing plan id
  #Return::
  # * (json) status
  #*Author*:: KhoiPCQ
  def self.new_pricing_plan(params)
    features = JSON.parse(params["feature_data"])
    feature_data = []
    features.each do |feature|
      feature_data << {feature_id:feature}
    end
    pricing_plan = self.new(
      name: params["name"],
      description: params["description"],
      status: params["status"],
      price_per_month: params["price_per_month"],
      number_of_stores: params["number_of_stores"],
      user_staff: params["user_staff"],
      :features_pricing_plans_attributes => feature_data
    )
   
  end
  
  ##
  #Update pricing plan
  #Parameters::
  # * (Integer) *id*: pricing plan id
  #Return::
  # * (json) status
  #*Author*:: KhoiPCQ
  def self.update_pricing_plan(params)
    pricing_plan = PricingPlan.find_by_id(params["pp_id"])
    features = JSON.parse(params["feature_data"])
    feature_data = []
    features.each do |feature|
      feature_data << {feature_id:feature}
    end
    FeaturesPricingPlan.destroy_all(pricing_plan_id: params["pp_id"])
    result = pricing_plan.update_attributes({
      name: params["name"],
      description: params["description"],
      status: params["status"],
      price_per_month: params["price_per_month"],
      number_of_stores: params["number_of_stores"],
      user_staff: params["user_staff"],
      :features_pricing_plans_attributes => feature_data
    })
    
    return result
    
  end
end