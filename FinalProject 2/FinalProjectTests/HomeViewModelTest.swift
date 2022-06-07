//
//  HomeViewModelTest.swift
//  FinalProjectTests
//
//  Created by Tam Nguyen K.T. [7] VN.Danang on 6/7/22.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import Nimble
import Quick

@testable import FinalProject

class HomeViewModelTest: QuickSpec { 
    
    override func spec() {
        var viewModel: HomeViewModel!
        
        describe("Test funcs homeScreen") {
            context("Test some funcs related to tableView") {
                beforeEach {
                    viewModel = HomeViewModel()
                    viewModel.musics = DummyData.dummyMusics
                }
                it("Test func numberOfSection") {
                    expect(viewModel.numberOfSections()) == 1
                    // cach khac
                    expect(viewModel.numberOfSections()).to(equal(1))
                }
                it("Test func numberOfItem in section 0") {
                    expect(viewModel.numberOfItems(inSection: 0)) == 2
                }
                it("Test func viewModelForItem with row = 0, section = 0") {
                    expect(viewModel.viewModelForItem(at: IndexPath(row: 0, section: 0))).to(beAnInstanceOf(HomeCellViewModel.self))
                    
                    // cach khac
                    expect(viewModel.viewModelForItem(at: IndexPath(row: 0, section: 0)).item?.name) == "tam"
                }
                afterEach {
                    viewModel = nil
                }
            }
            context("Test func related to api") {
                
            }
        }
    }
}

// MARK: - Dummy Data
extension HomeViewModelTest {
    
    struct DummyData {
        static var dummyMusics: [Music] {
            var items: [Music] = []
            // dummy
            let item1 = Music()
            item1.name = "tam"
            let item2 = Music()
            item2.name = "tien"
            items.append(item1)
            items.append(item2)
            return items
        }
    }
}
