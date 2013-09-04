class AppointmentsController < ApplicationController

  def index
    arel_user = User.arel_table
    @list_user = User.where(arel_user[:id].not_eq(current_user.id).and(arel_user[:organization_id].eq(current_user.organization_id)))
    @list_appointments = Appointment.all
    puts "========================="
    puts @list_appointments
    @list_appointments.each do |i|
      puts i.appointment_date
      puts i.appointment_date.month
      i["year"] = i.appointment_date.year
      i["month"] = i.appointment_date.month
      i["day"] = i.appointment_date.day
      i["start_hour"] = i.appointment_date.hour
      i["start_min"] = i.appointment_date.min
      i["end_hour"] = i.appointment_date.hour + i.duration.hour
      i["end_min"] = i.appointment_date.min + i.duration.min
      i["title"] = "Event" + i.note
      i["UserId"] = i.staff_id
      i["id"] = 0
    end

  end
  def create_appointment
    puts "vao Creeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee"
    list_param = params["data"]
    customer_id = 0
    #start check expected params to create a customer
    if !list_param["first_name"].blank? && !list_param["last_name"].blank? && !list_param["first_name"].blank? && !list_param["email_address"].blank?
      new_customer = Customer.create(:first_name => list_param["first_name"],:last_name =>list_param["last_name"],:email =>list_param["email_address"])
      customer_id = new_customer.id
    end
    list_param["customer_id"] = customer_id
    #create appointment
    new_app = Appointment.new
    is_save = new_app.create_appointment(list_param,current_user.organization_id, current_user.id)
    render :json =>{"status" =>"ok"}
  end
  def new
    @list_staff = User.where(:organization_id =>current_user.organization_id,:is_admin =>false)
  end
  def get_service_by_staff
    list_service = Service.joins(:service_staffs).where("services.organization_id = #{current_user.organization_id} and user_id = #{params['staff_id']}")
    render :json =>{"data" =>list_service}
  end

  def report

    if request.xhr?
      curent_day = params["current_day"]
      type_report = params["type_report"]
      p "--------report ajax---------"
      p curent_day
      p type_report
      p "-----------------------"

      organization_id = params[:organization_id]
      @appointments = Appointment.getAppointmentByDay(curent_day,organization_id)
      # return_data = {
      #   "aaData" => [],
      #   "iTotalDisplayRecords" => 5
      # }
      # date = ["July 29 2013 9:00AM", "July 29 2013 2:00PM", "July 29 2013 3:30PM"]
      # confirm_id = ["EC123FF12", "EC123FF13", "EC123FF14"]
      # customer = ["Cindy Pham", "Tamika Leaka", "Vicky P.Pollay"]
      # staff = ["Susan Botton", "Susan Botton", "Magdalena"]
      # service = ["Massage", "Massage", "Massage"]
      # recived_date = ["July 15 2013 9:00PM", "July 22 2013 5:00PM", "July 15 2013 9:00PM"]
      # status = ["Booked", "Booked", "Booked"]

      # (0...3).each do |i|
      #   return_data["aaData"]<< [
      #     date[i],
      #     confirm_id[i],
      #     customer[i],
      #     staff[i],
      #     service[i],
      #     recived_date[i],
      #     status[i],
      #   ]
      # end
      render :json => @appointments
      return
    end
  end

end
