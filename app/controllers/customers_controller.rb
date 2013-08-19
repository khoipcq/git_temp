class CustomersController < ApplicationController
  skip_authorize_resource
  SORT_MAP = {
    1 => "name"
  }
  ##
  #Get user_group list except an user_group of Administrator
  #Parameters::
  # * (Integer) *iDisplayLength*: number of row per page
  # * (Integer) *iDisplayStart*:  starting number
  # * (Integer) *iSortCol_0*: locate of sort column
  # * (String)  *sSearch*: Search string
  #Return::
  # * (json) Matched user list with paging and number all rows are finded
  #*Author*:: PhuND
  def index
    if request.xhr?
      organization_id = params["organization_id"]
      per_page = params[:iDisplayLength] || Settings.per_page
      page = params[:iDisplayStart] ? ((params[:iDisplayStart].to_i/per_page.to_i) + 1) : 1
      params[:iSortCol_0] = 1 if params[:iSortCol_0].blank?
      sort_field = SORT_MAP[params[:iSortCol_0].to_i]

      customers = ["Marco Botton", "Mariah Macah", "Valerir Liberty"]
      emails = ["marco@gmail.com", "mariad@gmail.com", "valerie@gamil.com"]
      phones = ["(800) 478-2145", "(800) 478-2145", "(800) 478-2145"]
      cities = ["New York", "New York", "New York"]
      return_data = {
      "aaData" => [],
      "iTotalDisplayRecords" => 3
      }
      (0...3).each do |i|
        return_data["aaData"] << [
            "",
            customers[i],
            emails[i],
            phones[i],
            cities[i],
            "",
            i+1
          ]
      end

      render :json => return_data
      return
    end
  end
end
