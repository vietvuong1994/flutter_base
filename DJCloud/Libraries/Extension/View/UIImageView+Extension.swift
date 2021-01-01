//
//  UIImageView+Extension.swift
//  iOS Structure MVC
//
//  Created by kien on 10/9/18.
//  Copyright © 2018 kien. All rights reserved.
//

import UIKit
import SDWebImage
import Alamofire

extension UIImageView {
         func loadImage(url: URL?,
                     placeholder: UIImage? = Constants.defaultImage,
                     showIndicator: Bool = false,
                     forceRefresh: Bool = false,
                     completion: ((_ image: UIImage?, _ error: Error?, _ url: URL?) -> Void)? = nil) {
          if showIndicator {
              sd_showActivityIndicatorView()
          }
          sd_imageTransition = .fade
          var options: SDWebImageOptions = []
          if forceRefresh {
              options = [.refreshCached]
          }
          sd_setImage(with: url, placeholderImage: placeholder, options: options) { [weak self] (image, error, _, url) in
              if showIndicator {
                  self?.sd_removeActivityIndicator()
              }
              completion?(image, error, url)
          }
      }
      
      func cancelDownloadingImage() {
          sd_cancelCurrentImageLoad()
      }
    
    func set(color: UIColor) {
        image = image?.template
        tintColor = color
    }
    
    func renderOriginal() {
        image = image?.template
    }
    
    func renderTemplate() {
        image = image?.template
    }
    
//    func roundRectWith(corners: UIRectCorner, radius: CGFloat) {
//        let maskPath = UIBezierPath(roundedRect: bounds,
//                                    byRoundingCorners: corners,
//                                    cornerRadii: CGSize(width: radius, height: radius))
//        let shape = CAShapeLayer()
//        shape.path = maskPath.cgPath
//        shape.backgroundColor = UIColor.red.cgColor
//        self.layer.mask = shape
//    }
}

extension UIImageView {
    public func imageFromServerURL(urlString: String) {
        URLSession.shared.dataTask(with: NSURL(string: urlString)! as URL, completionHandler: { (data, response, error) -> Void in
            
            if error != nil {
                print(error ?? "Can't get image")
                return
            }
            DispatchQueue.main.async(execute: { () -> Void in
                let image = UIImage(data: data!)
                self.image = image
            })
            
        }).resume()
    }
}
