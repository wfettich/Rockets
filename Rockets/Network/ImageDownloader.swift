//
//  ImageDownloader.swift
//  Rockets
//
//  Created by Walter Fettich on 12/02/2021.
//

import UIKit

class ImageDownloaderService: NSObject {
  
  static let shared = ImageDownloaderService()
    
    lazy var downloadQueue: OperationQueue = {
        var queue = OperationQueue()
        queue.name = "Image Download Queue"
        queue.maxConcurrentOperationCount = 1
        return queue
      }()
  
  func downloadImageFor(url:URL,
          onSuccess:((UIImage) -> Void)? = nil,
          onError:((UIImage) -> Void)? = nil) {
    
    let downloader = ImageDownloadeOperation(url)
    downloader.onSucces = onSuccess
    downloader.Error = onError
    downloadQueue.addOperation(downloader)
  }
}

class ImageDownloadeOperation: Operation {
  
  var onSucces: ((UIImage) -> Void)?
  var onError: (() -> Void)?
  let url: URL
  
  init(_ url: URL) {
    self.url = url
  }
  
  override func main() {
    if isCancelled {
      return
    }
    guard let imageData = try? Data(contentsOf: url) else { return }
        
    if isCancelled {
      return
    }
    
    if !imageData.isEmpty {
      if let image = UIImage(data:imageData) {
        onSucces?(image)
      }
      else {
        onError?()
      }
    } else {
      onError?()
    }
  }
}
