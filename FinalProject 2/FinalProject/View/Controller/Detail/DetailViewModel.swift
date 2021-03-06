//
//  DetailViewModel.swift
//  FinalProject
//
//  Created by Tam Nguyen K.T. [7] VN.Danang on 6/9/22.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import Foundation
import MVVM
import OHHTTPStubs

final class DetailViewModel: ViewModel {

    // MARK: - Properites
    var covids: [Covid] = []

    // MARK: - Methods
    func getDataCovid(completion: @escaping APICompletion) {
        HomeService.getDataCovid { [weak self] result in
            guard let this = self else { return }
            switch result {
            case .success(let items):
                this.covids = items
                completion(.success)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func numberOfItems(inSection section: Int) -> Int {
        return covids.count
    }

    func viewModelForItem(at indexPath: IndexPath) -> DetailCellViewModel {
        return DetailCellViewModel(item: covids[indexPath.row])
    }

    // handle stub
    func handleStub(completion: () -> Void) {
        stub(condition: isHost("api.coronavirus.data.gov.uk")) { _ in
            let path: String! = OHPathForFile("test.json", type(of: self))
            return HTTPStubsResponse(fileAtPath: path, statusCode: 200, headers: nil)
        }
        completion()
    }
}
