class Appointment < ActiveRecord::Base
  attr_accessible :staff_id,:date_start,:date_end,:time_start,:time_end,:is_blocked,:status,:created_by,:is_recurring,:appointment_unique_id,:block_time
  before_create :generate_unique
  belongs_to :staff, :class_name => "User", :foreign_key => 'staff_id'
  belongs_to :user, :class_name => "User", :foreign_key => 'created_by'
  belongs_to :customer
  belongs_to :service
  def generate_unique
    self.appointment_unique_id =  SecureRandom.base64(10)
  end
end