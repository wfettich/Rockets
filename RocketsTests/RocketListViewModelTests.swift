//
//  RocketListViewModelTests.swift
//  RocketsTests
//
//  Created by Walter Fettich on 13/02/2021.
//

import XCTest

@testable import Rockets
class RocketListViewModelTests: XCTestCase {

    var sut:RocketListViewModel!
  
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
      
      sut = RocketListViewModel (rocketFetcher: {
        return [.dummy]
      })
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testRocketSelection() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
      sut = RocketListViewModel (rocketFetcher: {
        return [.dummy]
      })

      sut.onSelectedRocket = { _ in XCTAssertTrue(true) }
      sut.selectRocket(at: 0)
  }

  func testDateConversion() throws {
  
    sut = RocketListViewModel (rocketFetcher: {
      return [.dummy]
    })
    let rocketSrvObj = RocketServiceObject(successRate: 0, name: "", imageURLs: [], firstFlight: "1990-07-11", active: false, costPerLaunch: 0, wikipediaURL: "", country: "", description: "")
    let rocket = Rocket.init(fromService: rocketSrvObj)
    let presentation = sut.rocketPresentation(rocket: rocket)
    
    XCTAssert(presentation.launchDate == "11 July 1990")
  }
  
  func testSuccessRate_BadgeColor() throws {
    
    func makeCellPresentation(successRate: Int) -> RocketListCellPresentation {
              let rocket = Rocket(successRate: successRate,
                                         name: "",
                                         imageURLs: [],
                                         firstFlight: nil,
                                         active: true,
                                         costPerLaunch: 0,
                                         wikipediaURL: "",
                                         country: "",
                                         description: ""
                                        )
      let sut = RocketListViewModel (rocketFetcher: {
        return []
      })
      let cellPresentation = sut.rocketPresentation(rocket: rocket)
      return cellPresentation
    }
    
    XCTAssertEqual(makeCellPresentation(successRate: 100).badgeColor, .green)
    XCTAssertEqual(makeCellPresentation(successRate: 99).badgeColor, .green)
    XCTAssertEqual(makeCellPresentation(successRate: 60).badgeColor, .green)
    XCTAssertNotEqual(makeCellPresentation(successRate: 59).badgeColor, .green)
    XCTAssertEqual(makeCellPresentation(successRate: 59).badgeColor, .orange)
    XCTAssertEqual(makeCellPresentation(successRate: 30).badgeColor, .orange)
    XCTAssertNotEqual(makeCellPresentation(successRate: 29).badgeColor, .orange)
    XCTAssertEqual(makeCellPresentation(successRate: 29).badgeColor, .red)
    XCTAssertEqual(makeCellPresentation(successRate: 0).badgeColor, .red)
  }

  
  func testFetching() throws {
      // This is an example of a functional test case.
      // Use XCTAssert and related functions to verify your tests produce the correct results.

    let sut = RocketListViewModel (rocketFetcher: {
      XCTAssert(true)
      return [.dummy]
    })
    sut.fetch()
  }
  
  func testViewUpdate() throws {
      // This is an example of a functional test case.
      // Use XCTAssert and related functions to verify your tests produce the correct results.
    let sut = RocketListViewModel (rocketFetcher: {
      return [.dummy]
    })
    sut.updateView = {
      XCTAssertTrue(true)
    }
    sut.fetch()
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
