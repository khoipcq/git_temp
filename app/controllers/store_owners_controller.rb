class StoreOwnersController < ApplicationController

  def index
    @per_page = Settings.per_page
    if request.xhr?
      per_page = params[:iDisplayLength] ||  Settings.per_page
      page = params[:iDisplayStart] ? ((params[:iDisplayStart].to_i/per_page.to_i) + 1) : 1
      cols = ["name", "expired_date","is_monthly_paid"]
      sort_field =  cols[(params[:iSortCol_0].to_i)]+" " + params[:sSortDir_0]
      search_text = params["sSearch"] || ""
      arel_org = Organization.arel_table
      @orgs = Organization.order(sort_field).where(arel_org[:name].matches("%#{search_text}%").and(arel_org[:is_super_org].eq(false))).paginate(:page => page, :per_page => per_page)
      @orgs.each do |i|
        i["email"] = ""
        admin_user = i.users.where(:is_admin => true).first()
        i["email"] = admin_user.email unless admin_user.blank?
      end
      render :json => {"aaData" => @orgs,"iTotalRecords"=>@orgs.total_entries,"iTotalDisplayRecords"=>@orgs.total_entries}
    end
  end

  def delete
    begin
      existed_org = Organization.find_by_id(params[:id])
      if !existed_org.expired_date.blank? && existed_org.expired_date < Date.today
        existed_org.destroy
        render :json =>{"status" => "deleted"}
      else
        render :json => {"status" => "not_deleted" }
      end
    rescue => ex
      render :json =>{"status" => ex.message}
    end
  end

  def stop_access
    begin
      existed_org = Organization.find_by_id(params[:id])
      if !existed_org.blank?
        existed_org.update_attributes(:is_stopped => !existed_org.is_stopped)
        render :json =>{"status" => "success"}
      else
        render :json => {"status" => "not_stop" }
      end
    rescue => ex
      render :json =>{"status" => ex.message}
    end
  end

end
