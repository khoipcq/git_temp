class SettingsController < ApplicationController
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
        "iTotalDisplayRecords" => 2
      }
      dates = ["Aug 1, 2013-Aug 3,2013", "Aug 1, 2013-Aug 3,2013" ]
      total_days = [3, 2 ]
      description = ["Vacation", "Vacation"]
      (0...2).each do |i|
        return_data["aaData"]<< [
          dates[i],
          total_days[i],
          description[i],
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
