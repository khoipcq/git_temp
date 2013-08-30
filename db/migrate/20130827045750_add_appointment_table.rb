class AddAppointmentTable < ActiveRecord::Migration
  def up
    create_table :appointments do |t|
      t.integer :staff_id
      t.integer :organization_id
      t.datetime :appointment_date
      t.boolean :is_locked,:default => false
      t.string :status
      t.integer :created_by
      t.integer :appointment_recurring_id
      t.string :appointment_unique_id
      t.integer :service_id
      t.decimal :cost, :precision=>2,:default =>0
      t.time :appointment_time,:time
      t.time :duration
      t.string :first_name,:default => ''
      t.string :last_name,:default => ''
      t.string :gender,:default => ''
      t.string :email,:default => ''
      t.string :state,:default => ''
      t.string :city,:default => ''
      t.string :address,:default => ''
      t.string :postal_code,:default => ''
      t.string :country,:default => ''
      t.string :phone,:default => ''
      t.string :note,:default => ''
      t.integer :customer_id,:default =>0
      t.timestamps
    end
    create_table :appointment_recurrings do |t|
      t.string :repeat_type
      t.string :repeat_every
      t.boolean :date_mon,:default => false
      t.boolean :date_tue,:default => false
      t.boolean :date_wed,:default => false
      t.boolean :date_thu,:default => false
      t.boolean :date_fri,:default => false
      t.boolean :date_sat,:default => false
      t.boolean :date_sun,:default => false
      t.integer :time_to_repeat
      t.date :end_date
      t.timestamps
    end
  end

  def down
    drop_table :appointments
    drop_table :appointment_recurrings

  end
end
