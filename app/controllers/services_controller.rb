class ServicesController < ApplicationController  
  def index
    list_service1 = [[
        "Face",
        "30",
        "30",
        1,
        true,
        "",
        1
      ],
      [
        "Eye",
        "15",
        "15",
        2,
        false,
        "",
        2
      ],
      [
        "Lip",
        "20",
        "20",
        3,
        false,
        "",
        3
      ]
    ]
    list_service2 = [
      [
        "Base Coat",
        "15",
        "15",
        1,
        true,
        "",
        1
      ],
      [
        "Top Coat",
        "30",
        "30",
        2,
        true,
        "",
        2
      ],
      [
        "Remover",
        "40",
        "40",
        3,
        false,
        "",
        3
      ]
    ]
    list_service3 = []    
    $return_hash_service = ["Makeup", "Nails"]
    if request.xhr?
      organization_id = params["organization_id"]
      service_group_id = params["service_group_id"]
      if(service_group_id == "1")
        render :json => {"aaData" => list_service1 ,
        "iTotalDisplayRecords" => 3}
        return
      end
      if(service_group_id == "2")
        render :json => {"aaData" => list_service2 ,
        "iTotalDisplayRecords" => 3}
        return
      end
      if(service_group_id == "3")
        render :json => {"aaData" => list_service3 ,
        "iTotalDisplayRecords" => 0}
        return
      end
    end
  end

  def new
    
    
  end

  def edit
    
  end

  def service_staff

    
  end

end
