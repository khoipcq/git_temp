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

  ##
  #Get pricing plan list
  #Parameters::
  # * (Integer) *id*: pricing plan id
  #Return::
  # * (json) status
  #*Author*:: KhoiPCQ
  def self.get_pricing_plan_list(params)
    pricing_plans = PricingPlan.paginate(:page => params["page"], :per_page => params["per_page"])
    feature_pp_list = {}
    pricing_plans.each do |pricing_plan| 
      feature_list = Feature.get_all_data_by_pricing_plan_id(pricing_plan.id)
      p "LLLLLLLLLLLLLLLLLLLL"
      p pricing_plan.id
      p feature_list
      feature_list_in = []
      feature_list_out =[]
      feature_list["aaData"].each do |fl|
        if fl[1] == "1"
          feature_list_in << fl[0]
        else
          feature_list_out << fl[0]
        end
      end

      feature_pp_list[pricing_plan.id] = [feature_list_in, feature_list_out] 
      pricing_plan["feature_list"] = feature_list
    end
    return pricing_plans, feature_pp_list
  end
end