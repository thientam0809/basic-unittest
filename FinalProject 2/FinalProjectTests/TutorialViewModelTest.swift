//
//  TutorialViewModelTest.swift
//  FinalProjectTests
//
//  Created by Tam Nguyen K.T. [7] VN.Danang on 6/15/22.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import Nimble
import Quick

@testable import FinalProject

class TutorialViewModelTest: QuickSpec {
    
    override func spec() {
        var viewModel: TutorialViewModel!
        
        beforeEach {
            viewModel = TutorialViewModel()
        }
        context("Test rank") {
            it("Test case rank bad") {
                expect(viewModel.rankStudent(point: 3)) == .bad
                expect(viewModel.rankStudent(point: 3)).to(equal(.bad))
            }
            it("Test case rank middle") {
                expect(viewModel.rankStudent(point: 6)) == .middle
                expect(viewModel.rankStudent(point: 6)).toNot(equal(.bad))
            }
            it("Test case rank good") {
                expect(viewModel.rankStudent(point: 8.2)) == .good
                expect(viewModel.rankStudent(point: 8.2)).toNot(equal(.middle))
            }
            it("Test case rank verygood") {
                expect(viewModel.rankStudent(point: 8.6)) == .verygood
                expect(viewModel.rankStudent(point: 8.2)).toNot(equal(.middle))
            }
            it("Test case rank error") {
                expect(viewModel.rankStudent(point: 11)) == .error
            }
        }
        context("Test gender") {
            it("Test case gender male") {
                expect(viewModel.identify(gender: .male)) == "have bird"
            }
            it("Test case gender female") {
                expect(viewModel.identify(gender: .female)) == "dont have bird :("
            }
        }
        afterEach {
            viewModel = nil
        }
    }
}
