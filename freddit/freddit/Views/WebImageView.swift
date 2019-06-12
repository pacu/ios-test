//
//  WebImageView.swift
//  freddit
//
//  Created by Francisco Gindre on 12/06/2019.
//  Copyright © 2019 Appscrafter. All rights reserved.
//

import UIKit

class WebImageView: UIImageView {
    
    private var downloadTask: URLSessionDataTask?
    
    func cancelTask() {
        downloadTask?.cancel()
    }
    
    func setImage(from url: URL, usePlaceholder: Bool = true, completion: ((Bool) -> Void)? = nil) {
        downloadTask?.cancel()
        
        if let image = ImageCache.cachedImage(from: url) {
            self.image = image
            completion?(true)
            return
        }
        
        self.setPlaceholderImage()
        downloadTask = URLSession.shared.dataTask(with: url, completionHandler: { [weak self] (data, response, error) in
            
            guard let `self` = self else { return }  // do nothing
            if let e = error {
                print("❌ Error downloading from \(url), error: \(e)")
                completion?(false)
                return
            }
            
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.image = image
                    completion?(true)
                }
                //save in cache
                DispatchQueue.global().async {
                    ImageCache.cache(image: image, url: url)
                }
            } else {
                completion?(false)
            }
            
        })
        downloadTask?.resume()
    }
    
}

struct ImageCache {
    
    static func cachedImage(from url: URL) -> UIImage? {
        return nil
    }
    
    static func cache(image: UIImage, url: URL) {
        
    }
}
