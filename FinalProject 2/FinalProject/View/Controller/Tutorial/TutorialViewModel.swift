//
//  TutorialViewModel.swift
//  FinalProject
//
//  Created by Tam Nguyen K.T. [7] VN.Danang on 6/15/22.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import Foundation

enum Rank {
    case bad
    case middle
    case good
    case verygood
    case error
}

class TutorialViewModel {

    func rankStudent(point: Float) -> Rank {
        switch point {
        case 0.0 ... 4.9:
            return .bad
        case 5.0 ... 6.9:
            return .middle
        case 7.0 ... 8.4:
            return .good
        case 8.5 ... 10.0:
            return .verygood
        default:
            return .error
        }
    }
}
