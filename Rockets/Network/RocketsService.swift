//
//  RocketsService.swift
//  Rockets
//
//  Created by Walter Fettich on 11/02/2021.
//

import Foundation
import Alamofire

struct RocketServiceObject: Codable {
  
  let successRate:Int
  let name:String
  let imageURLs:[String]
  let firstFlight:String
  let active:Bool
  let costPerLaunch:Int
  let wikipediaURL:String
  let country:String
  let description:String
  
  public enum CodingKeys: String, CodingKey {
      case successRate = "success_rate_pct"
      case name
      case imageURLs = "flickr_images"
      case firstFlight = "first_flight"
      case active
      case costPerLaunch = "cost_per_launch"
      case wikipediaURL = "wikipedia"
      case country
      case description
  }
}

protocol RocketsService {
  func downloadRockets(completion:@escaping ([Rocket]?,Error?)->Void, progress:((Double)->Void)?)
}

class AlamoRocketsService: RocketsService {

  let endpoint = "https://api.spacexdata.com/v4/rockets"
  
  func downloadRockets(completion:@escaping ([Rocket]?,Error?)->Void, progress:((Double)->Void)? = nil) {
   
    AF.request(endpoint)
      .downloadProgress(closure: {
        progressValue in
        progress?(progressValue.fractionCompleted)
      })
      .responseDecodable(of: [RocketServiceObject].self) {
        response in
        switch response.result {
          case .success(let rocketObjects):
          print("Success with JSON: \(rocketObjects)")
            let rockets = rocketObjects.compactMap({Rocket(fromService: $0)})
            
            completion(rockets,nil)

          case .failure(let error):
            print("Request failed with error: \(error)")
            completion(nil,error as Error)
        }
      }
  }
}
