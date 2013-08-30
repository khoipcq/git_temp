# This controller is used to process and render home page
# History: June 06, 2013
# By NamTV

class OrganizationsController < ApplicationController
  authorize_resource
  SORT_MAP = {
    1 => "name"
  }
  ##
  #Get user list except an user with specify ID
  #Parameters::
  # * (Integer) *iDisplayLength*: number of row per page
  # * (Integer) *iDisplayStart*:  starting number
  # * (Integer) *iSortCol_0*: locate of sort column
  # * (String)  *sSearch*: Search string
  #Return::
  # * (json) Matched organization list with paging and number all rows are finded
  #*Author*:: PhuNd
  def index

    if request.xhr?
      per_page = params[:iDisplayLength] || Settings.per_page
      page = params[:iDisplayStart] ? ((params[:iDisplayStart].to_i/per_page.to_i) + 1) : 1
      params[:iSortCol_0] = 1 if params[:iSortCol_0].blank?
      sort_field = SORT_MAP[params[:iSortCol_0].to_i]
      @organizations = Organization.get_all_organizations(page, per_page, params[:sSearch], sort_field + " " + params[:sSortDir_0])
      render :json => @organizations
      return
    end

    @search = params[:search]

  end

  # GET /organizations/:id
  def show
    @per_page = Settings.per_page
    @organization = current_user.organization
    @customers = Customer.where(:organization_id => current_user.organization_id)
    @staffs = User.where(:is_admin => false, :organization_id => current_user.organization_id)
    @services = Service.where(:organization_id => current_user.organization_id)
    date_now = Date.today
    begin_of_month = date_now.at_beginning_of_month
    end_of_month = date_now.at_end_of_month
    arel_appointment = Appointment.arel_table
    @sum_month = Appointment.where(arel_appointment[:created_at].gteq(begin_of_month).and(arel_appointment[:created_at].lteq(end_of_month))).count(:id)
    @sum_day = Appointment.where(arel_appointment[:created_at].eq(date_now)).count(:id)
  end

  def get_appointments
    if request.xhr?
      per_page = params[:iDisplayLength] ||  Settings.per_page
      page = params[:iDisplayStart] ? ((params[:iDisplayStart].to_i/per_page.to_i) + 1) : 1
      cols = ["appointments.created_at", "full_staff_name","full_cus_name","service_name"]
      search_text = params["sSearch"] || ""
      search_text = ActiveRecord::Base.sanitize("%"+search_text+"%")
      puts search_text
      sort_field =  cols[(params[:iSortCol_0].to_i)]+" " + params[:sSortDir_0]
      arel_appointment = Appointment.arel_table
      arel_user = User.arel_table
      arel_service = Service.arel_table
      @appointments = Appointment.order(sort_field).joins(:staff,:service,"left join customers on appointments.customer_id = customers.id").where("appointments.organization_id = ? and ((CONCAT(users.first_name,' ',users.last_name) like #{search_text}) or (services.name like #{search_text}) or (CONCAT(appointments.first_name ,' ', appointments.last_name) like #{search_text}))",current_user.organization_id).select("appointments.created_at,CONCAT(users.first_name,' ',users.last_name) as full_staff_name,CONCAT(appointments.first_name ,' ', appointments.last_name) as full_cus_name, services.name as service_name").paginate(:page => page, :per_page => per_page)
      
      render :json => {"aaData" => @appointments,"iTotalRecords"=>@appointments.total_entries,"iTotalDisplayRecords"=>@appointments.total_entries}
    end
  end
  # GET /organizations/new
  def new
    @organization = Organization.new
    @organization.users.build
  end

  # POST /organizations
  def create
    @organization = Organization.new(params[:organization])
    if @organization.save
      user = @organization.users.first
      user.is_admin = true
      user.save
      redirect_to organizations_path
    else
      render :new
    end

  end

  # GET /organizations/:id/edit
  def edit
    @organization = Organization.find_by_id(params[:id])
    @user_admin = @organization.users.where(:is_admin =>true).first
    p @user_admin
  end

  # PUT /organizations/:id
  def update
    @organization = Organization.find_by_id(params[:id])
    organization_name =  params["organization"]["name"]
    if params["organization"]["users_attributes"]["password"].blank?
      params["organization"]["users_attributes"].delete(:password)
      params["organization"]["users_attributes"].delete(:password_confirmation)
    end

    if @organization.update_attributes(params["organization"])
      redirect_to organizations_path
    else
      render :edit
    end

  end

  # DELETE /organizations/:id
  def destroy
    @organization = Organization.find_by_id(params[:id])
    @organization.destroy
    render :json=>{:status =>t('users.destroy.success')}
  end

end


