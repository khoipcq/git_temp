class FeaturesController < ApplicationController

  SORT_MAP = {
    1 => "name"
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
  #*Author*:: PhuND
  def index
    @per_page = Settings.per_page
    if request.xhr?
      organization_id = params["organization_id"]
      per_page = params[:iDisplayLength] ||  Settings.per_page
      page = params[:iDisplayStart] ? ((params[:iDisplayStart].to_i/per_page.to_i) + 1) : 1
      cols = ["name","","","status"]
      sort_field =  cols[(params[:iSortCol_0].to_i)]+" " + params[:sSortDir_0]
      search_text = params["sSearch"] || ""
      arel_feature = Feature.arel_table
      @features = Feature.order(sort_field).where(arel_feature[:name].matches("%#{search_text}%")).paginate(:page => page, :per_page => per_page)
      render :json => {"aaData" => @features,"iTotalRecords"=>@features.total_entries,"iTotalDisplayRecords"=>@features.total_entries}
    end
  end

  def update_feature
    if request.xhr?
      existed_feature = Feature.find_by_id(params["hidden_feature_id"])
      return render :json =>{"success" =>false} if existed_feature.blank?
      updated = existed_feature.update_attributes(:description => params["description"], :status =>params["status"])
      return render :js =>"success_update(true)" if updated ==true
      return render :js =>"success_update(false)"
    else
      return render :js =>"success_update(false)"
    end
  end

  def delete
     if request.xhr?
      existed_feature = Feature.find_by_id(params["id"])
      existed_feature.destroy
      return render :js =>"success_delete(true)"
    else
      return render :js =>"success_delete(false)"
    end
  end
end
