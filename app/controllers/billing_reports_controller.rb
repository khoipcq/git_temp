class BillingReportsController < ApplicationController
  skip_authorize_resource
  def index
    @per_page = Settings.per_page
    if request.xhr?
      per_page = params[:iDisplayLength] ||  Settings.per_page
      page = params[:iDisplayStart] ? ((params[:iDisplayStart].to_i/per_page.to_i) + 1) : 1
      cols = ["organizations.id","organizations.name","total_paid"]
      sort_field =  cols[(params[:iSortCol_0].to_i)]+" " + params[:sSortDir_0]
      search_text = params["sSearch"] || ""
      arel_org = Organization.arel_table
      @billings = BillingReport.order(sort_field).joins(:user).joins("JOIN organizations on users.organization_id = organizations.id").where(arel_org[:name].matches("%#{search_text}%")).select("organizations.name,organizations.id as org_id,sum(total_paid) as org_total").group("organizations.id").paginate(:page => page, :per_page => per_page,:count=>{:group=>'organizations.id'})
      @sum = BillingReport.order(sort_field).joins(:user).joins("JOIN organizations on users.organization_id = organizations.id").where(arel_org[:name].matches("%#{search_text}%")).sum("total_paid")
      @billings.each do |i|
        i["sum_paid"] = @sum
        i["org_id"] = "%05d"% i.org_id.to_i
      end
      render :json => {"aaData" => @billings,"iTotalRecords"=>@billings.total_entries,"iTotalDisplayRecords"=>@billings.total_entries,"sum_paid"=>@sum}
    end
  end

  def show
    @existed_org = Organization.find_by_id(params["id"])
    if request.xhr?
      cols = ["created_at","total_paid"]
      sort_field =  cols[(params[:iSortCol_0].to_i)]+" " + params[:sSortDir_0]
      org_admin_user = User.where(:is_admin=>true,:organization_id =>params["id"]).first();
      return  render :file => "#{Rails.root}/public/500.html", :status => 500, :layout => false if org_admin_user.blank?

      @billings = BillingReport.order(sort_field).where(:user_id => org_admin_user.id)
      @sum =BillingReport.order(sort_field).where(:user_id => org_admin_user.id).sum("total_paid")
      @billings.each do |i|
        i["created_at_s"] = i.created_at.strftime("%b %d, %Y") 
        i["sum_paid"] = @sum
      end 
      render :json => {"aaData" => @billings}   
    else
      render :file => "#{Rails.root}/public/500.html", :status => 500, :layout => false if @existed_org.blank?
      
    end
  end
  def export
    id = params["billing_report_id"]
    file_path = BillingReport.export(id.to_i)
    puts file_path
    send_file file_path
  end
end
