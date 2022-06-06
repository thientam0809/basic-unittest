//
//  API.Service.swift
//  FinalProject
//
//  Created by Tam Nguyen K.T. [7] VN.Danang on 6/6/22.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import Foundation
import Alamofire
import SwiftUtils
import ObjectMapper

class HomeService {

    class func getData(completion: @escaping Completion<[Music]>) {
        let urlString = "https://rss.applemarketingtools.com/api/v2/us/music/most-played/10/albums.json"
        api.request(method: .get, urlString: urlString) { result in
            switch result {
            case .success(let data):
                if let data = data as? JSObject, let feed = data["feed"] as? JSObject, let items = feed["results"] as? JSArray {
                    let items = Mapper<Music>().mapArray(JSONArray: items)
                    completion(.success(items))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
