class StaffsController < ApplicationController
  before_filter :authenticate_user!

  SORT_MAP = {
    1 => "full_name",
    2 => "username"
  }

  def index
    list_user1 = [[
        "Ken Nguyen",
        "kenng@gmail.com",
        "(555) 435 1245",
        "",
        1
      ],
      [
        "Ken Nguyen",
        "kenng@gmail.com",
        "(555) 435 1245",
        "",
        2
      ],
      [
        "Ken Nguyen",
        "kenng@gmail.com",
        "(555) 435 1245",
        "",
        3
      ]
    ]
    list_user2 = [
      [
        "Ken Nguyen a",
        "kenng@gmail.com",
        "(555) 435 1245",
        "",
        1
      ],
      [
        "Ken Nguyen b",
        "kenng@gmail.com",
        "(555) 435 1245",
        "",
        2
      ],
      [
        "Ken Nguyen c",
        "kenng@gmail.com",
        "(555) 435 1245",
        "",
        3
      ]
    ]
    list_user3 = []
    @return_hash = ["Group 1", "Group 2", "Group 3"]
    if request.xhr?
      organization_id = params["organization_id"]
      staff_group_id = params["staff_group_id"]
      if(staff_group_id == "1")
        render :json => {"aaData" => list_user1 ,
        "iTotalDisplayRecords" => 3}
        return
      end
      if(staff_group_id == "2")
        render :json => {"aaData" => list_user2 ,
        "iTotalDisplayRecords" => 3}
        return
      end
      if(staff_group_id == "3")
        render :json => {"aaData" => list_user3 ,
        "iTotalDisplayRecords" => 0}
        return
      end
    end
  end

end
