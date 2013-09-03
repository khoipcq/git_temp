# This controller is used to manager user
# History: June 06, 2013
# By NamTV
class UsersController < ApplicationController
  before_filter :authenticate_user!
  SORT_MAP = {
    1 => "full_name",
    2 => "username"
  }

  ##
  #Get user list except an user with specify ID
  #Parameters::
  # * (Integer) *iDisplayLength*: number of row per page
  # * (Integer) *iDisplayStart*:  starting number
  # * (Integer) *iSortCol_0*: locate of sort column
  # * (String)  *sSearch*: Search string
  #Return::
  # * (json) Matched user list with paging and number all rows are finded
  #*Author*:: NamTV
  def index
    list_user1 = [[
        "Ken Nguyen",
        "kenng@gmail.com",
        "(555) 435 1245",
        "",
        1
      ],
      [
        "Ken Nguyen",
        "kenng@gmail.com",
        "(555) 435 1245",
        "",
        2
      ],
      [
        "Ken Nguyen",
        "kenng@gmail.com",
        "(555) 435 1245",
        "",
        3
      ]
    ]
    list_user2 = [
      [
        "Ken Nguyen a",
        "kenng@gmail.com",
        "(555) 435 1245",
        "",
        1
      ],
      [
        "Ken Nguyen b",
        "kenng@gmail.com",
        "(555) 435 1245",
        "",
        2
      ],
      [
        "Ken Nguyen c",
        "kenng@gmail.com",
        "(555) 435 1245",
        "",
        3
      ]
    ]
    @return_hash = ["Group 1", "Group 2"]
    if request.xhr?
      organization_id = params["organization_id"]
      staff_group_id = params["staff_group_id"]
      if(staff_group_id == "1")
        render :json => {"aaData" => list_user1 ,
        "iTotalDisplayRecords" => 3}
        return
      end
      if(staff_group_id == "2")
        render :json => {"aaData" => list_user2 ,
        "iTotalDisplayRecords" => 3}
        return
      end
    end

    # if request.xhr?
    #   organization_id = params["organization_id"]
    #   per_page = params[:iDisplayLength] ||  Settings.per_page
    #   page = params[:iDisplayStart] ? ((params[:iDisplayStart].to_i/per_page.to_i) + 1) : 1
    #   params[:iSortCol_0] = 1 if params[:iSortCol_0].blank?
    #   sort_field = SORT_MAP[params[:iSortCol_0].to_i]
    #   @users = User.get_all_users_except_id(current_user.id, page, per_page, params[:sSearch], sort_field + " " + params[:sSortDir_0],organization_id)
    #   render :json => @users
    #   return
    # end

  end

  ##
  #Handle new an user
  #Parameters::
  #Return::
  # * (object) an new instance user
  #*Author*:: NamTV
  #
  def new
     @user = User.new
     @user_groups = UserGroup.get_all_user_groups_in_org(params[:organization_id])
  end

  ##
  #Handle create an user
  #Parameters::
  # * (object) *user*: current input user
  # * (Array) *user_groups*: current groups that user join
  #Return::
  # * (object) an new instance user
  #*Author*::NamTV
  #
  def create
    group_ids = params["user_groups"]
    org_id = params[:organization_id]
    @user = User.new(params[:user])
    @user.user_group_ids = group_ids
    @user.organization_id = org_id

    if @user.save
      redirect_to organization_users_path(org_id)
    else
      flash[:error] = t('users.new.exist')
      @user_groups = UserGroup.all
      render :new
    end
  end

  ##
  #Handle edit an user
  #Parameters::
  # * (integer) *id*: current user id to edit
  #Return::
  # * (object) an new instance user
  #*Author*:: NamTV
  #
  def edit
    @user = User.includes(:organization, :billing_card_info).find_by_id(params[:id])

    #@user_groups = UserGroup.get_all_user_groups_in_org(params[:organization_id])
    #render :edit_temp
    render :edit
    #render :_edit_store_owner
  end

  ##
  #Handle update an user
  #Parameters::
  # * (integer) *id*: current user id to update
  # * (object) *user*: current user input
  # * (Array) *user_groups*: current groups that user join
  #Return::
  # * (object) an new instance user
  #*Author*:: NamTV
  #
  def update
    user_group_ids = params["user_groups"] || []
    user_group_ids.map! { |g| g.to_i }
    @user = User.find_by_id(params[:id])
    current_group_ids = @user.user_group_ids

    if params["user"] && params["user"]["password"].blank?
      params["user"].delete(:password)
      params["user"].delete(:password_confirmation)
    end

    if @user.update_attributes(params["user"])
      is_logged = !@user.previous_changes.blank?
      if current_group_ids != user_group_ids
        @user.user_group_ids = user_group_ids
        @user.create_activity :edit_info, owner: current_user, params: {:detail => I18n.t('logs.edit_user', user_name: @user.user_full_name)} if !is_logged
      end
      redirect_to organization_users_path(params[:organization_id])
      return
    else
      @user_groups = UserGroup.get_all_user_groups_in_org(params[:organization_id])
      render :edit_temp
      return
    end
  end
  ##
  #Handle update profile for user
  #Parameters::
  # * (integer) *id*: current user id to update
  # * (object) *user*: current user input
  #Return::
  # * (object) an new instance user
  #*Author*:: ThuyLC
  #
  def update_profile
    @status_update = false;
    user_info ={}
    user_info["first_name"] = params["first_name"]
    user_info["last_name"] = params["last_name"]
    user_info["email"] = params["email"]
    user_info["password"] = params["password"] unless params["password"].blank?
    @existed_user = User.find_by_id(params["hidden_user_id"])
    if @existed_user.id == current_user.id
      @existed_user.organization.update_attributes(:language => params["language"],:time_zone => params["time_zone"])
      @status_update = @existed_user.update_attributes(user_info)
      sign_in(@existed_user,:bypass => true)

      @full_name = @existed_user.first_name + " " + @existed_user.last_name 
    end
    respond_to do |format|
      format.js
    end
  end

  ##
  #Update account store owner
  #Parameters::
  # * (integer) *id*: current user id to update
  # * (object) *user*: current user input
  #Return::
  # * (object) an new instance user
  #*Author*:: KhoiPCQ
  #
  def update_profile_store_owner
    @status_update = false;
    user_info ={}
    error_type = ""
    org_name = params["business_name"]
    user_info["first_name"] = params["first_name"]
    user_info["last_name"] = params["last_name"]
    user_info["email"] = params["email"]
    user_info["password"] = params["password"] unless params["password"].blank?
    @existed_user = User.find_by_id(params["hidden_user_id"])
    if @existed_user.id == current_user.id
      @status_update = @existed_user.update_attributes(user_info)
      @existed_user.organization.update_attributes(:name =>params["business_name"])
      sign_in(@existed_user,:bypass => true)
      @full_name = @existed_user.first_name + " " + @existed_user.last_name 
    end
    respond_to do |format|
      format.js
    end
    #render :js => "update_success(#{@status_update}, #{@full_name})"
  end

  ##
  #Update creadit card store owner
  #Parameters::
  # * (integer) *id*: current user id to update
  # * (object) *user*: current user input
  #Return::
  # * (object) an new instance user
  #*Author*:: KhoiPCQ
  #
  def update_credit_card_store_owner

    @status_update = false;
    billing_card_info ={
      state:params["state"],
      city:params["city"],
      address:params["address"],
      postal_code:params["postal_code"],
      phone_number:params["phone_number"],
      country:params["country"],
      card_type:params["card_type"],
      card_number:params["card_number"],
      expiration_month:params["month"],
      expiration_year:params["year"],
      cvv:params["cvv"],
      card_holder_name:params["cardholder_name"]
    }
    
    @existed_billing_card_info = BillingCardInfo.find_by_user_id(params["hidden_credit_card_user_id"])
    if !@existed_billing_card_info.nil?
      @status_update = @existed_billing_card_info.update_attributes(billing_card_info) 
    else
      billing_card_info["user_id"] = params["hidden_credit_card_user_id"]
      BillingCardInfo.create(billing_card_info)
    end
    respond_to do |format|
      format.js
    end
    #render :js => "update_success(#{@status_update}, #{@full_name})"
  end

  ##
  #Handle detroy an user
  #Parameters::
  # * (integer) *id*: current user id to destroy
  #Return::
  # * (json) status: ok=>done
  #*Author*:: NamTV
  #
  def destroy
    @user = User.find_by_id(params[:id])
    @user.destroy
    render :json=>{:status =>t('users.destroy.success')}
  end

  def reorder

  end

end
