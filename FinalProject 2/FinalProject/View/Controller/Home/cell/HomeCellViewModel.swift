//
//  HomeCellViewModel.swift
//  FinalProject
//
//  Created by Tam Nguyen K.T. [7] VN.Danang on 6/6/22.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import Foundation

final class HomeCellViewModel {

    // MARK: - Properties
    var item: Music?
    var index: Int = 0

    // MARK: - Initial
    init(item: Music?, index: Int = 0) {
        self.item = item
        self.index = index
    }

    func isEven() -> Bool {
        return index % 2 == 0
    }
}
