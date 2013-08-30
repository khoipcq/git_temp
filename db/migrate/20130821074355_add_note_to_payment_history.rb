class AddNoteToPaymentHistory < ActiveRecord::Migration
  def change
    add_column :payment_histories,:note,:string,:default=>""
  end
end
