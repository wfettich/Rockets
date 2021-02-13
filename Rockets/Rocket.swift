//
//  Rocket.swift
//  Rockets
//
//  Created by Walter Fettich on 12/02/2021.
//

import Foundation

struct Rocket {
  
  let successRate:Int
  let name:String
  let imageURLs:[String]
  let firstFlight:Date?
  let active:Bool
  let costPerLaunch:Int
  let wikipediaURL:String
  let country:String
  let description:String
  
  private let readDateFormatter:DateFormatter = {
    let fmt = DateFormatter()
    fmt.dateFormat = "yyyy-MM-dd"
    return fmt
  }()
  
  private let showDateFormatter:DateFormatter = {
    let fmt = DateFormatter()
    fmt.dateFormat = "dd MMMM yyyy"
    return fmt
  }()
  
  private let costFormatter:NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.locale = Locale.current
    formatter.numberStyle = .currency
    return formatter
  }()
  
}

extension Rocket {
  
  init (fromService serviceObject:RocketServiceObject) {
  
    name = serviceObject.name
    successRate = serviceObject.successRate
    imageURLs = serviceObject.imageURLs
    firstFlight = readDateFormatter.date(from:serviceObject.firstFlight)
    active = serviceObject.active
    costPerLaunch = serviceObject.costPerLaunch
    wikipediaURL = serviceObject.wikipediaURL
    country = serviceObject.country
    description = serviceObject.description
  }
  
  init (fromCoreData coreDataObject:RocketCD) {
    
    name = coreDataObject.name ?? ""
    successRate = Int(coreDataObject.successRate)
    imageURLs = coreDataObject.imageURLs ?? []
    firstFlight = coreDataObject.firstFlight
    active = coreDataObject.active
    costPerLaunch = Int(coreDataObject.costPerLaunch)
    wikipediaURL = coreDataObject.wikipediaURL ?? ""
    country = coreDataObject.country ?? ""
    description = coreDataObject.theDescription ?? ""
  }
  
  static let dummy = Rocket(
    successRate: 30, name: "placeholder", imageURLs: ["https://picsum.photos/300"], firstFlight: Date(), active: false, costPerLaunch: 9999, wikipediaURL: "placeholder", country: "placeholder", description: "placeholder placeholder placeholder placeholder placeholder placeholder placeholder placeholder placeholder placeholder placeholder placeholder placeholder placeholder placeholder placeholder placeholder placeholder placeholder placeholder placeholder placeholder placeholder placeholder placeholder placeholder "
  )
}

//presentation helpers

extension Rocket {

  func costPerLaunchFormatted() -> String {
    let formattedCost = costFormatter.string(from: NSNumber(value:costPerLaunch))!
    return formattedCost
  }
  
  func firstFlightFormatted() -> String? {
    return firstFlight != nil ? showDateFormatter.string(from: firstFlight!) : nil
  }

  enum BadgeColor {
    case green, orange, red
  }

  func mapSuccessRate() -> BadgeColor {
    return successRate >= 60 ? .green : successRate >= 30 ? .orange : .red
  }

}
