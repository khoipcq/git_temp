class EmailCampaignsController < ApplicationController
  SORT_MAP = {
    0 => "name"
  }
  def index
    if request.xhr?
      per_page = params[:iDisplayLength] || Settings.per_page
      page = params[:iDisplayStart] ? ((params[:iDisplayStart].to_i/per_page.to_i) + 1) : 1
      params[:iSortCol_0] = 1 if params[:iSortCol_0].blank?
      sort_field = SORT_MAP[params[:iSortCol_0].to_i]

      return_data = {
        "aaData" => [],
        "iTotalDisplayRecords" => 5
      }
      name = ["Appointment Confirmation", "Appointment Reminder", "Thank You Email", "Cancellation Confirmation", "Come Again Reminder" ]
      status = [true, true, true, true, true ]
      (0...5).each do |i|
        return_data["aaData"]<< [
          name[i],
          status[i],
          #status
          "",
          i+1
        ]
      end

      render :json => return_data
      return
    end
  end
end
