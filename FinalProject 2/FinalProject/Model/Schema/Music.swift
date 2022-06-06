//
//  Music.swift
//  FinalProject
//
//  Created by Tam Nguyen K.T. [7] VN.Danang on 6/6/22.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import Foundation
import ObjectMapper

final class Music: Mappable {

    // MARK: - Properties

    var name: String = ""
    // MARK: - Initial
    init?(map: Map) { }

    // MARK: - Mapping
    func mapping(map: Map) {
        name <- map["artistName"]
    }
}
