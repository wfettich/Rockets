//
//  RocketDetailViewModel.swift
//  Rockets
//
//  Created by Walter Fettich on 13/02/2021.
//

import Foundation

class RocketDetailViewModel: ObservableObject {
  
  typealias OpenURL = (URL)->Void
  let rocket: Rocket
  let badgeColor: Rocket.BadgeColor
  let openURL:OpenURL?
  
  @Published var imageData: Data?
  
  init(rocket: Rocket, imageService: ImageDownloaderService = .shared, openURL: OpenURL? = nil) {
    self.rocket = rocket
    self.badgeColor = rocket.mapSuccessRate()
    self.openURL = openURL
    
    if let firstImage = rocket.imageURLs.first, let url = URL(string: firstImage) {
      imageService.downloadImageFor(url: url, onSuccess: {
        self.imageData = $0
      })
    }
  }
  
  func openWikipedia() {
    print("open wikipedia for: \(rocket.wikipediaURL)")
    if let url = URL(string:rocket.wikipediaURL) {
      openURL?(url)
    }
  }

}

