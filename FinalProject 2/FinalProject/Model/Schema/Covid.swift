//
//  Covid.swift
//  FinalProject
//
//  Created by Tam Nguyen K.T. [7] VN.Danang on 6/9/22.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import ObjectMapper

class Covid: Mappable {
    
    
    // MARK: - Properties
    var areaName: String = ""
    var death: Int = 0
    
    // MARK: - Initial
    required init?(map: Map) { }
    init() { }
    
    // MARK: - Mapping
    func mapping(map: Map) {
        areaName <- map["areaName"]
        death <- map["death"]
    }
}
