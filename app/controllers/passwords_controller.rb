# This controller is used to set new password when someone forgot
# History: June 06, 2013
# By NamTV

class PasswordsController < Devise::PasswordsController
  skip_before_filter :require_no_authentication, :only => [:create]
  skip_authorize_resource
  p "fjdfhdjkfhdjkfhdkfhdkjf"
  ##
  #Action Name:: create
  #Parameters:: N/A
  #Return:: Return the response of get new password request
  #*Author*:: NamTV
  #----------------------------------------------------------------------------
  def create
    # if verify_recaptcha
    #   self.resource = resource_class.send_reset_password_instructions(resource_params)
    #   if successfully_sent?(resource)
    #     redirect_to new_user_session_path
    #   else
    #     respond_with(resource)
    #   end
    # else
    #   flash[:error] = t("errors.messages.wrong_captcha")
    #   self.resource = build_resource
    #   render :new
    # end
    self.resource = resource_class.send_reset_password_instructions(resource_params)
    if successfully_sent?(resource)
      #redirect_to new_user_session_path
      redirect_to thank_you_password_reset_path
    else
      respond_with(resource)
    end
  end

  def update
    self.resource = resource_class.reset_password_by_token(resource_params)

    if resource.errors.empty?
      resource.unlock_access! if unlockable?(resource)
      flash_message = resource.active_for_authentication? ? :updated : :updated_not_active
      set_flash_message(:notice, flash_message) if is_navigational_format?
      redirect_to updated_password_path
    else
      respond_with resource
    end
  end

  def thank_you_password_reset
  end

  def changed_successfully
  end
end
