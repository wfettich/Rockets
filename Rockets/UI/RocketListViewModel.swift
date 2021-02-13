//
//  RocketListViewModel.swift
//  Rockets
//
//  Created by Walter Fettich on 12/02/2021.
//

import Foundation

struct RocketListCellPresentation {
  let name:String
  let launchDate:String
  let badgeColor:Rocket.BadgeColor
}

class RocketListViewModel: NSObject {
    
  typealias RocketFetcher = ()->[Rocket]
  
  var dataObserver:DataChangedObserver?
  var updateView:DataChangedObserver?
  var onSelectedRocket: ((Rocket) -> Void)?
  
  private let rocketFetcher:RocketFetcher
  
  var rockets:[Rocket]?
  var selectedRocket: Rocket! {
    didSet {
      onSelectedRocket?(selectedRocket)
    }
  }
  
  required init(rocketFetcher: @escaping RocketFetcher) {
    self.rocketFetcher = rocketFetcher
    super.init ()
    
    dataObserver = {
      [weak self] in
      self?.fetch()
      self?.updateView?()
    }
  }
    
  func fetch() {
    rockets = rocketFetcher()
    updateView?()
  }
  
  func rocketPresentation(rocket:Rocket) -> RocketListCellPresentation {
    let badgeColor = rocket.mapSuccessRate()    
    return RocketListCellPresentation(
      name: rocket.name, launchDate: rocket.firstFlightFormatted() ?? "", badgeColor:badgeColor)
  }
  
  func selectRocket(at index: Int) {
    if let selectedRocket = rockets?[index] {
      self.selectedRocket = selectedRocket
    }
  }
}
