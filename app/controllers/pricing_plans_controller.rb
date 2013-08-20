class PricingPlansController < ApplicationController

  SORT_MAP = {
    1 => "name",
    2 => "description",
    3 => "status"
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
      if existed_pp #and don't have user use it
        existed_pp.destroy
        render :json =>{"status" => "deleted"}
      else
        render :json => {"status" => "not_deleted" }
      end
    #rescue => ex
    #  render :json =>{"status" => ex.message}
    #end
  end

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
end
