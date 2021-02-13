//
//  Rocket+CoreDataProperties.swift
//  
//
//  Created by Walter Fettich on 11/02/2021.
//
//

import Foundation
import CoreData

extension RocketCD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RocketCD> {
        return NSFetchRequest<RocketCD>(entityName: "RocketCD")
    }

    @NSManaged public var name: String?
    @NSManaged public var successRate: Int32
    @NSManaged public var imageURLs: [String]?
    @NSManaged public var firstFlight: Date?
    @NSManaged public var active: Bool
    @NSManaged public var costPerLaunch: Int64
    @NSManaged public var wikipediaURL: String?
    @NSManaged public var country: String?
    @NSManaged public var theDescription: String?

}

extension RocketCD {
  func populateWith (rocket:Rocket) {
    name = rocket.name
    successRate = Int32(rocket.successRate)
    imageURLs = rocket.imageURLs
    firstFlight = rocket.firstFlight
    active = rocket.active
    costPerLaunch = Int64(rocket.costPerLaunch)
    wikipediaURL = rocket.wikipediaURL
    country = rocket.country
    theDescription = rocket.description
  }  
}
