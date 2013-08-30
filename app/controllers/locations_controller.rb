class LocationsController < ApplicationController
  def index
    list_locations = [[
        "Adidas 1",
        "12 Helen Street - New York City",
        "adidas1.com",
        "(800)252618",
        "",
        1
      ],
      [
        "Adidas 2",
        "23 Caroli Street- Washington City",
        "adidas2.com",
        "(800)123456",
        "",
        2
      ],
      [
        "Adidas 3",
        "34 Militon Street - Osam City",
        "adidas3.com",
        "(800)252618",
        "",
        3
      ]
    ]

    if request.xhr?
      organization_id = params["organization_id"]
      render :json => {"aaData" => list_locations ,
      "iTotalDisplayRecords" => 3}
      
    end
  end

  def new
    render :new
  end

  def edit
    list_staff1 = [[
        "Ken Nguyen",
        "kenng@gmail.com",        
        "(555) 252 6181",
        "",
        1
      ],
      [
        "Maria",
        "maria@gmail.com",        
        "(555) 252 6181",
        "",
        2
      ],
      [
        "Samson Lee",
        "sslee@gmail.com",        
        "(555) 252 6181",
        "",
        3
      ],
      [
        "Bin Tran",
        "bintran@gmail.com",        
        "(555) 252 6181",
        "",
        4
      ]
    ]

    list_staff2 = [[
        "Tommy",
        "kenng@gmail.com",        
        "(555) 252 6181",
        "",
        1
      ],
      [
        "Matta",
        "maria@gmail.com",        
        "(555) 252 6181",
        "",
        2
      ],
      [
        "Lee",
        "sslee@gmail.com",        
        "(555) 252 6181",
        "",
        3
      ],
      [
        "Winne",
        "bintran@gmail.com",        
        "(555) 252 6181",
        "",
        4
      ]
    ]

    list_closed_dates = [[
        "Aug 1, 2013 - Aug 3, 2013",
        3,        
        "Vacation",
        "",
        1
      ],
      [
        "Sep 1, 2013 - Sep 2, 2013",
        2,        
        "Vacation",
        "",
        2
      ],      
    ]
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

    @return_hash_staff = ["Group 1", "Group 2"] 
    $return_hash_service = ["Makeup", "Nails"]   
        
    if request.xhr?      
      
      organization_id = params["organization_id"]
      service_group_id = params["service_group_id"]
      staff_group_id = params['staff_group_id']
      closed_table_id = params['closed_table_id']
      if(closed_table_id == '1')
        render :json => {"aaData" => list_closed_dates, 
          "iTotalDisplayRecords" => 2}
      end
      
      #draw service
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

      #draw service
      if(staff_group_id == "1")
        render :json => {"aaData" => list_staff1 ,
        "iTotalDisplayRecords" => 4}
        return
      end
      if(staff_group_id == "2")
        render :json => {"aaData" => list_staff2 ,
        "iTotalDisplayRecords" => 4}
        return
      end      
    end
    
  end
end
