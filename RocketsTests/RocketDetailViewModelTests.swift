//
//  RocketDetailViewModelTests.swift
//  RocketsTests
//
//  Created by Walter Fettich on 13/02/2021.
//

import XCTest
@testable import Rockets

class RocketDetailViewModelTests: XCTestCase {

  func testSuccessRate_BadgeColor() throws {
    
    func makeSUT(successRate: Int) -> RocketDetailViewModel {
      RocketDetailViewModel(rocket: Rocket(successRate: successRate,
                                           name: "",
                                           imageURLs: [],
                                           firstFlight: nil,
                                           active: true,
                                           costPerLaunch: 0,
                                           wikipediaURL: "",
                                           country: "",
                                           description: ""
                                          )
      )
    }

    XCTAssertEqual(makeSUT(successRate: 100).badgeColor, .green)
    XCTAssertEqual(makeSUT(successRate: 99).badgeColor, .green)
    XCTAssertEqual(makeSUT(successRate: 60).badgeColor, .green)
    XCTAssertNotEqual(makeSUT(successRate: 59).badgeColor, .green)
    XCTAssertEqual(makeSUT(successRate: 59).badgeColor, .orange)
    XCTAssertEqual(makeSUT(successRate: 30).badgeColor, .orange)
    XCTAssertNotEqual(makeSUT(successRate: 29).badgeColor, .orange)
    XCTAssertEqual(makeSUT(successRate: 29).badgeColor, .red)
    XCTAssertEqual(makeSUT(successRate: 0).badgeColor, .red)
  }

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
