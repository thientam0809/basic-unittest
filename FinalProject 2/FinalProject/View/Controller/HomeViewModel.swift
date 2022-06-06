//
//  HomeViewModel.swift
//  FinalProject
//
//  Created by Tam Nguyen K.T. [7] VN.Danang on 6/6/22.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import Foundation
import MVVM

final class HomeViewModel: ViewModel {

    // MARK: - Properties
    private(set) var musics: [Music] = []

    // MARK: - Methods
    func getData(completion: @escaping APICompletion) {
        HomeService.getData { [weak self] result in
            guard let this = self else { return }
            switch result {
            case .success(let items):
                this.musics = items
                completion(.success)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func numberOfSections() -> Int {
        return 1
    }

    func numberOfItems(inSection section: Int) -> Int {
        return musics.count
    }

    func viewModelForItem(at indexPath: IndexPath) -> HomeCellViewModel {
        return HomeCellViewModel(item: musics[indexPath.row], index: indexPath.row)
    }
}
