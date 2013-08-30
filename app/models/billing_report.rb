include ActionView::Helpers::NumberHelper
class BillingReport < ActiveRecord::Base
  set_table_name "payment_histories"
  attr_accessible :total_paid,:user_id,:pricing_plan_id
  belongs_to :user
  belongs_to :pricing_plan
  scope :join_org, lambda {
    joins(:user).joins("JOIN organizations on users.organization_id = organizations.id").select("")
  }
  def self.export(id)
    @existed_org = Organization.find_by_id(id)
    org_admin_user = User.where(:is_admin=>true,:organization_id =>id).first();
    @sum =BillingReport.where(:user_id => org_admin_user.id).sum("total_paid")
    @billings = BillingReport.where(:user_id => org_admin_user.id)
    headers = ["Billing Date","Transaction Amount (JPY)","Note"]
    columns = ['created_at','total_paid','note']
    file_name = Time.now.strftime("%b_%d_%Y_%H_%M_%S")+ "_billing_report_#{"%05d"% @existed_org.id.to_i }.xls"

    file_path = 'public/export_file/' + file_name
    book = Spreadsheet::Workbook.new
    sheet1 = book.create_worksheet
    sheet1.name = 'Result'
    #Billing header
    sheet1.row(0).concat([I18n.t('billing_reports.name') +" #"+"%05d"% @existed_org.id.to_i])
    format_title = Spreadsheet::Format.new :weight => :bold,:size => 15
    sheet1.row(0).default_format = format_title
    sheet1.row(0).height = 25
    format_normal = Spreadsheet::Format.new :size => 12
    sheet1.row(0).set_format(5, format_normal)
    #Row 0
    sheet1.row(1).concat([I18n.t('users.business_name'),@existed_org.name,I18n.t('users.credit_card.cardholder_name'),""])
    format_title = Spreadsheet::Format.new :size => 12
    sheet1.row(1).default_format = format_title
    sheet1.row(1).height = 18
    format_normal = Spreadsheet::Format.new :size => 10
    sheet1.row(1).set_format(5, format_normal)
    #Row 1
    sheet1.row(2).concat([I18n.t("billing_reports.subcription_from"),@existed_org.created_at.strftime("%b %d, %Y"),I18n.t('users.credit_card.card_number'),""])
    format_title = Spreadsheet::Format.new :size => 12
    sheet1.row(2).default_format = format_title
    sheet1.row(2).height = 18
    format_normal = Spreadsheet::Format.new :size => 10
    sheet1.row(2).set_format(5, format_normal)
    #Row 2
    sheet1.row(3).concat([I18n.t("billing_reports.account_expiry"),@existed_org.expired_date.strftime("%b %d, %Y"),I18n.t('billing_reports.expiration_date'),""])
    format_title = Spreadsheet::Format.new :size => 12
    sheet1.row(3).default_format = format_title
    sheet1.row(3).height = 18
    format_normal = Spreadsheet::Format.new :size => 10
    sheet1.row(3).set_format(5, format_normal)
    #Row 3
    pricing_plan = ""
    pricing_plan = @existed_org.pricing_plan.name unless @existed_org.pricing_plan.blank?
    sheet1.row(4).concat([I18n.t("billing_reports.subcription_plan"),pricing_plan])
    format_title = Spreadsheet::Format.new :size => 12
    sheet1.row(4).default_format = format_title
    sheet1.row(4).height = 18
    format_normal = Spreadsheet::Format.new :size => 10
    sheet1.row(4).set_format(5, format_normal)

    
    sheet1.row(5).push("")

    # set columns width
    column_widths = {0=>100,1=>100,2=>100,3=>100}
    alignment = {0=>:center,1=>:center,2=>:left,3=>:left}
    column_widths.each do |x,v|
      width = column_widths[x].to_i/3

      align = alignment[x]          

      sheet1.column(x).width = width
      sheet1.column(x).default_format = (Spreadsheet::Format.new :align => align)
    end

    format_header = Spreadsheet::Format.new :weight => :bold,
      :size => 10,
      :align => :center
    sheet1.row(6).concat(headers)
    sheet1.row(6).default_format = format_header
    sheet1.row(6).height = 13

    bold_heading = Spreadsheet::Format.new :weight => :bold, :size => 9
    format_right = Spreadsheet::Format.new 
    format_right.align = :right
    index = 0
    if !@billings.blank?
      @billings.each do |rec|          
        data = []
        columns.each_with_index do |x,c_i|
          if c_i == 0 
            data <<  rec[x].strftime("%b %d, %Y")
          elsif c_i == 1
            data <<  number_with_delimiter(rec[x])
          else
            data << rec[x]
          end
        end
        index+=1
        sheet1.row(index+6).concat(data)
        sheet1.row(index+6).set_format(1, format_right)
      end
    end
    index+=7
    #Row 3
    sheet1.row(index).concat([I18n.t("billing_reports.total"),number_with_delimiter(@sum)])
    format_title = Spreadsheet::Format.new :weight => :bold,:size => 10
    format_title.align = :right
    sheet1.row(index).default_format = format_title
    sheet1.row(index).height = 18
    format_normal = Spreadsheet::Format.new :size => 10
    sheet1.row(index).set_format(5, format_normal)

    book.write file_path
    return file_path
  end
end