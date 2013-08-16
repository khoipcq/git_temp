class PricingPlan < ActiveRecord::Base
  
  attr_accessible :name, :description, :status, :price_per_month, :number_of_stores, :user_staff
  has_many :feature_pricing_plans, :dependent => :destroy
  scope :search_by_name, lambda { |search| where("lower(name) like ?", "%" + search + "%") }
  
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
end