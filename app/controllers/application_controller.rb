# This controller is used as parent controller

# History: June 06, 2013
# By NamTV

class ApplicationController < ActionController::Base

  include PublicActivity::StoreController
  protect_from_forgery
  authorize_resource :unless => :devise_controller?
  # before_filter :check_org
  def after_sign_in_path_for(resource)
    root_url
  end
  rescue_from CanCan::AccessDenied do |exception|
    render :file => "#{Rails.root}/public/401.html", :status => 401, :layout => false
  end

  private

  ##
  #Method Name:: support create permissions
  #Parameters::
  #Return:: current user and current organization id
  #*Author*:: NamTV#
  #---------------------------------------------------------------------
  def current_ability
    @current_ability ||= Ability.new(current_user, params[:organization_id].to_i|| params[:id].to_i)
  end

  ##
  #Method Name:: after_sign_in_path_for
  #Parameters:: resource from devise
  #Return:: Path after signin
  #*Author*:: NamTV
  #----------------------------------------------------------------------------
  def after_sign_in_path_for(resource)
    organization = resource.organization
    session[:org_id] = resource.organization_id
    if resource.admin? && organization.super_org?
      store_owners_path
    else
      organization_path(organization)
    end
    # (resource.admin? && organization.super_org?) ? store_owners_path : root_path
    # (resource.admin? && organization.super_org?) ? organizations_path : organization_path(organization)
  end

  ##
  #Method Name:: after_sign_out_path_for
  #Parameters:: resource from devise
  #Return:: Return the new session path
  #*Author*:: NamTV
  #----------------------------------------------------------------------------
  def after_sign_out_path_for(resource)
    session[:org] = nil
    new_user_session_path
  end
  ##
  #Method Name:: check correct organization whether user change url
  #Parameters:: resource from devise
  #Return:: Return the new session path
  #*Author*:: ThuyLC
  #----------------------------------------------------------------------------
  def check_org
    puts params
    if params["controller"] =="organizations" || !params["organization_id"].blank?
      if !params["id"].blank?
        id = params["id"].to_i
      else
        id = params["organization_id"].to_i
      end
     return true if current_user.organization_id == id
     return render :file => "#{Rails.root}/public/401.html", :status => 401, :layout => false
    else
      return true
    end
  end
end
