//
//  UIImageView+DownloadImage.swift
//  NBA Statistics APP
//
//  Created by Ryan Chevarria on 4/26/22.
//

import UIKit

extension UIImageView {
  func loadImage(url: URL) -> URLSessionDownloadTask {
    let session = URLSession.shared
    // 1
    let downloadTask = session.downloadTask(with: url) {
      [weak self] url, _, error in
      // 2
      if error == nil, let url = url,
        let data = try? Data(contentsOf: url),
        let image = UIImage(data: data) {
        // 4
        DispatchQueue.main.async {
          if let weakSelf = self {
            weakSelf.image = image
          }
            
        }
      }
    }
    downloadTask.resume()
    return downloadTask
  }
}

