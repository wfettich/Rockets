//
//  ImageDownloader.swift
//  Rockets
//
//  Created by Walter Fettich on 12/02/2021.
//

import Foundation

class ImageDownloaderService: NSObject {
  
  static let shared = ImageDownloaderService()
  
  var imageCache:[URL:Data] = [:]
    
  lazy var downloadQueue: OperationQueue = {
      var queue = OperationQueue()
      queue.name = "Image Download Queue"
      queue.maxConcurrentOperationCount = 3
      return queue
    }()
  
  func downloadImageFor(url:URL,
          onSuccess:((Data) -> Void)? = nil,
          onError:(() -> Void)? = nil) {
    
    if let imageData = imageCache[url] {
      onSuccess?(imageData)
    } else {
      let downloader = ImageDownloadOperation(url)
      downloader.saveToCache = { url, data in self.imageCache[url] = data}
      downloader.onSucces = onSuccess
      downloader.onError = onError
      downloadQueue.addOperation(downloader)
    }
  }
}

class ImageDownloadOperation: Operation {
  
  var onSucces: ((Data) -> Void)?
  var onError: (() -> Void)?
  var saveToCache:((URL,Data) -> Void)?
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
    
    DispatchQueue.main.async {
      if !imageData.isEmpty {
        self.saveToCache?(self.url,imageData)
        self.onSucces?(imageData)
      } else {
        self.onError?()
      }
    }
  }
}
