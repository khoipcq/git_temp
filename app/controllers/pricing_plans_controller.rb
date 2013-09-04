class PricingPlansController < ApplicationController

  SORT_MAP = {
    0 => "name",
    1 => "description",
    2 => "status"
  }
  ##
  #Get user_group list except an user_group of Administrator
  #Parameters::
  # * (Integer) *iDisplayLength*: number of row per page
  # * (Integer) *iDisplayStart*:  starting number
  # * (Integer) *iSortCol_0*: locate of sort column
  # * (String)  *sSearch*: Search string
  #Return::
  # * (json) Matched user list with paging and number all rows are finded
  #*Author*:: PhuND, KhoiPCQ
  def index

    if request.xhr?
      per_page = params[:iDisplayLength] || Settings.per_page
      page = params[:iDisplayStart] ? ((params[:iDisplayStart].to_i/per_page.to_i) + 1) : 1
      params[:iSortCol_0] = 1 if params[:iSortCol_0].blank?
      sort_field = SORT_MAP[params[:iSortCol_0].to_i]
      @pricing_plan = PricingPlan.get_all_pricing_plan(current_user, page, per_page, params[:sSearch].to_s, sort_field.to_s + " " + params[:sSortDir_0].to_s)
      
      render :json => @pricing_plan
      return
    end
  end

  ##
  #Delete pricing plan
  #Parameters::
  # * (Integer) *id*: pricing plan id
  #Return::
  # * (json) status
  #*Author*:: KhoiPCQ
  def delete
    #begin
      existed_pp = PricingPlan.find_by_id(params[:id])
      is_used = BillingReport.exists?(pricing_plan_id:params[:id])
      #is_used = true
      if existed_pp && !is_used
        existed_pp.destroy
        render :json =>{"status" => "deleted"}
      elsif is_used
        render :json =>{"status" => "is_used"}
      else
        render :json => {"status" => "not_deleted" }
      end
    #rescue => ex
    #  render :json =>{"status" => ex.message}
    #end
  end

  ##
  #Create pricing plan
  #Parameters::
  # * (Integer) *id*: pricing plan id
  #Return::
  # * (json) status
  #*Author*:: KhoiPCQ
  def create
    @pricing_plan = PricingPlan.new_pricing_plan(params)
    @is_saved = false
    
    if request.xhr?
        if @pricing_plan.save
          @is_saved = true
        end
        render :js => "create_success(#{@is_saved})"
    end
    
  end

  ##
  #Edit pricing plan
  #Parameters::
  # * (Integer) *id*: pricing plan id
  #Return::
  # * (json) status
  #*Author*:: KhoiPCQ
  def edit
    @pricing_plan = PricingPlan.find_by_id(params[:id])
    if request.xhr?
      if @pricing_plan
        pricing_plan = {
          name: @pricing_plan.name,
          description: @pricing_plan.description,
          price_per_month: @pricing_plan.price_per_month,
          number_of_stores: @pricing_plan.number_of_stores,
          user_staff: @pricing_plan.user_staff,
          status: @pricing_plan.status.to_s
        }
      end
      render :json => pricing_plan
    end
  end

  ##
  #Update pricing plan
  #Parameters::
  # * (Integer) *id*: pricing plan id
  #Return::
  # * (json) status
  #*Author*:: KhoiPCQ
  def update_pricing_plan
    is_saved = PricingPlan.update_pricing_plan(params)
    
    if request.xhr?
        result = "update_success(#{is_saved})"
        render :js => result
    end
  end
  
  ##
  #Get pricing plan
  #Parameters::
  # * (Integer) *id*: pricing plan id
  #Return::
  # * (json) status
  #*Author*:: KhoiPCQ
  def pricing_plan_list
    @pricing_plan, @feature_pp_list = PricingPlan.get_pricing_plan_list(params)
    @organization = Organization.find_by_id(params["organization_id"])
    render :layout => false
  end
end
