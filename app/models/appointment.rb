class Appointment < ActiveRecord::Base
  attr_accessible :staff_id,:organization_id,:appointment_date,:is_locked,:status,:created_by,:appointment_recurring_id,:appointment_unique_id,:service_id,:cost,:appointment_time,:time,:duration,:first_name,:last_name,:gender,:email,:state,:city,:address,:postal_code,:country,:phone,:note,:customer_id, :staff, :customer
  before_create :generate_unique
  belongs_to :staff, :class_name => "User", :foreign_key => 'staff_id'
  belongs_to :user, :class_name => "User", :foreign_key => 'created_by'
  belongs_to :customer, :class_name => "User", :foreign_key => 'customer_id'
  belongs_to :service

  scope :in_organization, lambda { |id| where(organization_id: id) }
  # scope :filter_date, lambda { |on_date| where("appointment_date = ?", on_date) }
  scope :filter_date, lambda { |from_date, to_date| where("appointment_date >= ? and appointment_date <= ?", from_date, to_date) }

  def generate_unique
    self.appointment_unique_id =  SecureRandom.base64(10)
  end
  def create_appointment(param,org_id,user_created_id)
  	puts "============"
  	puts param
  	new_app = Appointment.new
  	new_app.staff_id = param["staff_id"]
  	new_app.organization_id = org_id
  	new_app.created_by = user_created_id
  	new_app.appointment_date = DateTime.parse(param["appointment_date"])
  	#new_app.appointment_date.change({:hour => param["appointment_time"]})
  	new_app.is_locked = false
  	new_app.service_id = param["service_id"]
  	new_app.cost = param["cost"]
  	month,day,year = param["appointment_date"].split("/");
  	hour = param["appointment_time"].to_i/60
  	min = param["appointment_time"].to_i%60
  	new_app.appointment_date = DateTime.new(year.to_i,month.to_i,day.to_i)
  	new_app.appointment_time = DateTime.new(year.to_i,month.to_i,day.to_i,0,0,0)
  	new_app.appointment_date = new_app.appointment_date.change({hour: hour,min: min})
  	puts param["appointment_time"].to_i
  	new_app.appointment_time = new_app.appointment_time.change({hour: hour,min: min})
  	new_app.duration = DateTime.new(year.to_i,month.to_i,day.to_i,0,0,0)
  	new_app.duration = new_app.duration.change({hour: param["duration_hour"].to_i,min: param["duration_min"].to_i})
  	puts new_app.duration
  	new_app.first_name = param["first_name"]
  	new_app.last_name = param["last_name"]
  	new_app.gender = param["gender"]
  	new_app.email = param["email_address"]
  	new_app.state = param["state"]
  	new_app.city = param["city"]
  	new_app.address = param["address"]
  	new_app.postal_code = param["postal_code"]
  	new_app.country = param["country"]
  	new_app.phone = param["phone"]
  	new_app.note = param["note"]
  	new_app.customer_id = param["customer_id"]
  	return new_app.save
  end
  def check_same_time_sheet(from_date,duration_hour,duration_min)

  end

  def self.getAppointmentByDay(on_date ,organization_id)
    appointments = Appointment.in_organization(organization_id)

    from_date = DateTime.strptime(on_date, I18n.t('time.short_format'))
    to_date = DateTime.strptime(on_date, I18n.t('time.short_format')).end_of_day

    appointments = appointments.filter_date(from_date, to_date)
    appointments = appointments.select("appointment_date, appointment_unique_id, customer_id, staff_id, service_id, created_at, status, first_name, last_name")

    return_data = {
      "aaData" => [],
      "iTotalDisplayRecords" => appointments.count
    }

    appointments.each do |appointment|
      return_data["aaData"] << [
        appointment.appointment_date.strftime( I18n.t('time.text_format')),
        appointment.appointment_unique_id,
        # customer
        appointment.customer == nil ? appointment.first_name + ' ' +appointment.last_name : appointment.customer.first_name + ' ' + appointment.customer.last_name ,
        #staff
        appointment.staff.first_name+ ' '+ appointment.staff.last_name,
        appointment.service.name,
        appointment.created_at.strftime(I18n.t('time.text_format')),
        appointment.status
      ]

    end
    return return_data
  end
end