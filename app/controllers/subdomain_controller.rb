class SubdomainController < ApplicationController
  skip_authorize_resource
  before_filter :check
  
  def index
  end
  
  def login
  end

  def forgot_password
    
  end

  def signup
  end

  def show
  end
  
  def booking    
    flash[:confirm] = 'Your appointment is not confirmed yet.'
    flash[:booking_sucess] = 'Booking successful.'
    flash[:confirmation] = 'A confirmation has been sent to your email.'
  end
  
  private
  def check
    org = Organization.find_by_subdomain(request.subdomain)
    render :file => 'public/404.html' and return unless org
  end
  
  def org_id(api_key)
    org = Organization.find_by_subdomain(request.subdomain)
    return org.id
  end
end
