# This controller is used to set new password when someone forgot
# History: June 06, 2013
# By NamTV

class PasswordsController < Devise::PasswordsController
  skip_before_filter :require_no_authentication, :only => [:create]
  skip_authorize_resource

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
    super
  end

end
