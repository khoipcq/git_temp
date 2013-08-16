# This controller is used to register new user
# History: June 06, 2013
# By NamTV

class RegistrationsController < Devise::RegistrationsController
  ##
  #Override new of Devise::RegistrationsController
  #Parameters::
  #Return::
  # * page of register user include organization
  #*Author*:: PhuNd
  def new
    @organizations = Organization.get_all_orgs
    super
  end

  ##
  #Override create of Devise::RegistrationsController
  #Parameters::
  #Return::
  # * page of register if error and login if not error
  #*Author*:: NamTV
  def create
    date_now = Date.today
    new_org = Organization.new(:name=>params["business_name"],:description=>"",:expired_date => date_now +1.month)

      if new_org.save        
        build_resource(user_params)
        if resource.save
          resource.organization_id = new_org.id
          resource.is_admin = true
          resource.save

          # Activity.delay.add_static_record(new_org.id, new_org.name)
          # new_org.delay.create_test_data()

          if resource.active_for_authentication?
            set_flash_message :notice, :signed_up if is_navigational_format?
            sign_up(user_params[:email], resource)
            respond_with resource, :location => after_sign_up_path_for(resource)
          else
            set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_navigational_format?
            expire_session_data_after_sign_in!
            #respond_with resource, :location => after_inactive_sign_up_path_for(resource)
            redirect_to thank_you_sign_up_path
          end
        else
          clean_up_passwords resource
          new_org.destroy
          respond_with resource
        end
      else #org errors
        build_resource
        clean_up_passwords(resource)
        new_org.errors.each do |attr, err|
          puts attr
          resource.errors.add(attr, err) unless resource.errors.include?(attr)
        end

        render :new
      end
  end

  def user_params
    params[:user]
  end
end