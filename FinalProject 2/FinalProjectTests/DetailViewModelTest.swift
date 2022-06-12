//
//  DetailViewModelTest.swift
//  FinalProjectTests
//
//  Created by Tam Nguyen K.T. [7] VN.Danang on 6/9/22.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import OHHTTPStubs
import Quick
import Nimble

@testable import FinalProject

class DetailViewModelTest: QuickSpec {

    
    override func spec() {
        var viewModel: DetailViewModel!
        context("Test func getdataCovid") {
            beforeEach {
                viewModel = DetailViewModel()
            }
            it("Test api success") {
                stub(condition: isHost("api.coronavirus.data.gov.uk")) { _ in
                    let path: String! = OHPathForFile("detail.json", type(of: self))
                    return HTTPStubsResponse(fileAtPath: path, statusCode: 200, headers: nil)
                }

                waitUntil(timeout: DispatchTimeInterval.seconds(20)) { done in
                    viewModel.getDataCovid { _ in
                        expect(viewModel.covids.count) == 841
                        done()
                    }
                }
            }
            
            it("Test api failure") {
                stub(condition: isHost("api.coronavirus.data.gov.uk")) { _ in
                    let path: String! = OHPathForFile("detail.json", type(of: self))
                    return HTTPStubsResponse(fileAtPath: path, statusCode: 400, headers: nil)
                }

                waitUntil(timeout: DispatchTimeInterval.seconds(20)) { done in
                    viewModel.getDataCovid { _ in
                        expect(viewModel.covids.count) == 0
//                        done()
                    }
                }
            }
            afterEach {
                viewModel = nil
            }
        }
    }
}
