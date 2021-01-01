//
//  UIImage+Extension.swift
//  iOS Structure MVC
//
//  Created by kien on 10/9/18.
//  Copyright © 2018 kien. All rights reserved.
//

import UIKit
import AVFoundation
import ImageIO

extension UIImage {
    // MARK: - Variables
    var original: UIImage {
        return withRenderingMode(.alwaysOriginal)
    }
    
    var template: UIImage {
        return withRenderingMode(.alwaysTemplate)
    }
    
    // MARK: - Init
    convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
    
    // MARK: - Static functions
    static func getVideoThumbnailFor(url : URL) -> UIImage? {
        let asset: AVAsset = AVAsset(url: url)
        let assetImgGenerate : AVAssetImageGenerator = AVAssetImageGenerator(asset: asset)
        assetImgGenerate.appliesPreferredTrackTransform = true
        let time: CMTime = CMTimeMake(value: 1, timescale: 60)
        let img: CGImage
        do {
            try img = assetImgGenerate.copyCGImage(at: time, actualTime: nil)
            let frameImg: UIImage = UIImage(cgImage: img)
            return frameImg
        } catch { }
        return nil
    }
    
    func resizeTo(width: CGFloat) -> UIImage? {
        let image = self
        let scale = width / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: width, height: newHeight))
        image.draw(in: CGRect(x: 0, y: 0, width: width, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    func resizeTo(percentage: CGFloat) -> UIImage? {
        let canvasSize = CGSize(width: size.width * percentage, height: size.height * percentage)
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    func resizeTo(mb: Int) -> UIImage? {
        guard let imageData = pngData() else { return nil }
        var resizingImage = self
        var imageSizeKB = Double(imageData.count) / 1024.0 // ! Or devide for 1024 if you need KB but not kB
        while imageSizeKB > 1024.0 * Double(mb) { // ! Or use 1024 if you need KB but not kB
            guard let resizedImage = resizingImage.resizeTo(percentage: 0.9),
                let imageData = resizedImage.pngData()
                else { return nil }
            resizingImage = resizedImage
            imageSizeKB = Double(imageData.count) / 1000.0 // ! Or devide for 1024 if you need KB but not kB
        }
        return resizingImage
    }
    
    func scalingAndCroppingFor(size: CGSize) -> UIImage? {
        let sourceImage = self
        var newImage: UIImage? = nil
        let imageSize = sourceImage.size
        let width = imageSize.width
        let height = imageSize.height
        let targetWidth = size.width
        let targetHeight = size.height
        var scaleFactor: CGFloat = 0.0
        var scaledWidth = targetWidth
        var scaledHeight = targetHeight
        var thumbnailPoint = CGPoint(x: 0.0, y: 0.0)
        if !imageSize.equalTo(size) {
            let widthFactor = targetWidth / width
            let heightFactor = targetHeight / height
            if widthFactor > heightFactor { scaleFactor = widthFactor }
            else { scaleFactor = heightFactor }
            scaledWidth = width * scaleFactor
            scaledHeight = height * scaleFactor
            if widthFactor < heightFactor {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5
            }
        }
        UIGraphicsBeginImageContext(size) // this will crop
        var thumbnailRect = CGRect.zero
        thumbnailRect.origin = thumbnailPoint
        thumbnailRect.size.width  = scaledWidth
        thumbnailRect.size.height = scaledHeight
        sourceImage.draw(in: thumbnailRect)
        newImage = UIGraphicsGetImageFromCurrentImageContext()
        //pop the context to get back to the default
        UIGraphicsEndImageContext()
        return newImage
    }
    
    func rotateBy(degrees: CGFloat) -> UIImage {
        let rotatedViewBox: UIView = UIView(frame: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
        let t: CGAffineTransform = CGAffineTransform(rotationAngle: degrees * CGFloat.pi / 180)
        rotatedViewBox.transform = t
        let rotatedSize: CGSize = rotatedViewBox.frame.size
        
        UIGraphicsBeginImageContext(rotatedSize)
        let bitmap: CGContext = UIGraphicsGetCurrentContext()!
        
        bitmap.translateBy(x: rotatedSize.width / 2, y: rotatedSize.height / 2)
        
        bitmap.rotate(by: (degrees * CGFloat.pi / 180))
        
        bitmap.scaleBy(x: 1.0, y: -1.0)
        bitmap.draw(self.cgImage!, in: CGRect(x: -self.size.width / 2, y: -self.size.height / 2, width: self.size.width, height: self.size.height))
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
    func convertImageToBase64String() -> String? {
        return self.jpegData(compressionQuality: 0.1)?.base64EncodedString()
    }
}

import UIKit
import ImageIO
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}



extension UIImage {
    
    public class func gifImageWithData(_ data: Data) -> UIImage? {
        guard let source = CGImageSourceCreateWithData(data as CFData, nil) else {
            print("image doesn't exist")
            return nil
        }
        
        return UIImage.animatedImageWithSource(source)
    }
    
    public class func gifImageWithURL(_ gifUrl:String) -> UIImage? {
        guard let bundleURL:URL? = URL(string: gifUrl)
            else {
                print("image named \"\(gifUrl)\" doesn't exist")
                return nil
        }
        guard let imageData = try? Data(contentsOf: bundleURL!) else {
            print("image named \"\(gifUrl)\" into NSData")
            return nil
        }
        
        return gifImageWithData(imageData)
    }
    
    public class func gifImageWithName(_ name: String) -> UIImage? {
        guard let bundleURL = Bundle.main
            .url(forResource: name, withExtension: "gif") else {
                print("SwiftGif: This image named \"\(name)\" does not exist")
                return nil
        }
        guard let imageData = try? Data(contentsOf: bundleURL) else {
            print("SwiftGif: Cannot turn image named \"\(name)\" into NSData")
            return nil
        }
        
        return gifImageWithData(imageData)
    }
    
    class func delayForImageAtIndex(_ index: Int, source: CGImageSource!) -> Double {
        var delay = 0.1
        
        let cfProperties = CGImageSourceCopyPropertiesAtIndex(source, index, nil)
        let gifProperties: CFDictionary = unsafeBitCast(
            CFDictionaryGetValue(cfProperties,
                Unmanaged.passUnretained(kCGImagePropertyGIFDictionary).toOpaque()),
            to: CFDictionary.self)
        
        var delayObject: AnyObject = unsafeBitCast(
            CFDictionaryGetValue(gifProperties,
                Unmanaged.passUnretained(kCGImagePropertyGIFUnclampedDelayTime).toOpaque()),
            to: AnyObject.self)
        if delayObject.doubleValue == 0 {
            delayObject = unsafeBitCast(CFDictionaryGetValue(gifProperties,
                Unmanaged.passUnretained(kCGImagePropertyGIFDelayTime).toOpaque()), to: AnyObject.self)
        }
        
        delay = delayObject as! Double
        
        if delay < 0.1 {
            delay = 0.1
        }
        
        return delay
    }
    
    
    class func animatedImageWithSource(_ source: CGImageSource) -> UIImage? {
        let count = CGImageSourceGetCount(source)
        var images = [CGImage]()
        var delays = [Int]()
        
        for i in 0..<count {
            if let image = CGImageSourceCreateImageAtIndex(source, i, nil) {
                images.append(image)
            }
            
            let delaySeconds = UIImage.delayForImageAtIndex(Int(i),
                source: source)
            delays.append(Int(delaySeconds * 1000.0)) // Seconds to ms
        }
        
        let duration: Int = {
            var sum = 0
            
            for val: Int in delays {
                sum += val
            }
            
            return sum
        }()
        
        let gcd = gcdForArray(delays)
        var frames = [UIImage]()
        
        var frame: UIImage
        var frameCount: Int
        for i in 0..<count {
            frame = UIImage(cgImage: images[Int(i)])
            frameCount = Int(delays[Int(i)] / gcd)
            
            for _ in 0..<frameCount {
                frames.append(frame)
            }
        }
        
        let animation = UIImage.animatedImage(with: frames,
            duration: Double(duration) / 1000.0)
        
        return animation
    }
}


extension UIImage {
    private(set) static var cachedImages = NSCache<NSString, UIImage>()
    private static let downloadQueue = DispatchQueue(label: "com.kienpt.UIImage.download", qos: .utility)
    
    static func downloadImage(withURL urlString: String?, completion: @escaping (String, UIImage) -> Void, error: (() -> Void)? = nil) {
        guard let urlString = urlString, let url = URL(string: urlString) else { error?(); return }
        
        if let downloadedImage = UIImage.cachedImages.object(forKey: NSString(string: urlString)) {
            DispatchQueue.main.async {
                completion(urlString, downloadedImage)
            }
            return
        }
        
        downloadQueue.async {
            URLSession.shared.dataTask(with: url) { (data, response, err) in
                guard let data = data, let image = UIImage(data: data) else { error?(); return }

                DispatchQueue.main.async {
                    UIImage.cachedImages.setObject(image, forKey: NSString(string: urlString))
                    completion(urlString, image)
                }
            }.resume()
        }
    }
    
    static func downloadGifImage(withURL urlString: String?, imgOrg: Int? = nil, completion: @escaping (String, UIImage) -> Void, error: (() -> Void)? = nil) {
        guard let urlString = urlString, let url = URL(string: urlString) else { error?(); return }
        
        if let downloadedImage = UIImage.cachedImages.object(forKey: NSString(string: urlString)) {
            DispatchQueue.main.async {
                completion(urlString, downloadedImage)
            }
            return
        }
        
        downloadQueue.async {
            URLSession.shared.dataTask(with: url) { (data, response, err) in
                guard let data = data, let image = UIImage.gif(data: data, imgOrg) else { error?(); return }
                
                DispatchQueue.main.async {
                    UIImage.cachedImages.setObject(image, forKey: NSString(string: urlString))
                    completion(urlString, image)
                }
            }.resume()
        }
    }
}

//  Gif.swift
//  SwiftGif
//  Created by Arne Bahlo on 07.06.14.
//  Copyright (c) 2014 Arne Bahlo. All rights reserved.
var imageGifCache = NSCache<NSString, UIImage>()
extension UIImage {
    class func gif(data: Data,_ imageOrg: Int? = nil) -> UIImage? {
        // Create source from data
        guard let source = CGImageSourceCreateWithData(data as CFData, nil) else {
            print("SwiftGif: Source for the image does not exist")
            return nil
        }
        
        return UIImage.animatedImageWithSource(source,imageOrg)
    }
    
    class func gif(url: String, imageOrg: Int? = nil) -> UIImage? {
        var image = UIImage()
        if let imageFromCache = imageGifCache.object(forKey: url as NSString) {
            image = imageFromCache
            return image
        }
        // Validate URL
        guard let bundleURL = URL(string: url) else {
            print("SwiftGif: This image named \"\(url)\" does not exist")
            return nil
        }
//
//        // Validate data
        guard let imageData = try? Data(contentsOf: bundleURL) else {
            print("SwiftGif: Cannot turn image named \"\(url)\" into NSData")
            return nil
        }
        image = gif(data: imageData, imageOrg) ?? UIImage()
        image = UIImage(named: "image_placeholder_landscape") ?? UIImage()
        imageGifCache.setObject(image, forKey: url as NSString)
        return image
    }
    
    class func gif(name: String) -> UIImage? {
        // Check for existance of gif
        guard let bundleURL = Bundle.main
            .url(forResource: name, withExtension: "gif") else {
                print("SwiftGif: This image named \"\(name)\" does not exist")
                return nil
        }
        
        // Validate data
        guard let imageData = try? Data(contentsOf: bundleURL) else {
            print("SwiftGif: Cannot turn image named \"\(name)\" into NSData")
            return nil
        }
        
        return gif(data: imageData)
    }
    
   
    class func gcdForPair(_ lhs: Int?, _ rhs: Int?) -> Int {
        var lhs = lhs
        var rhs = rhs
        // Check if one of them is nil
        if rhs == nil || lhs == nil {
            if rhs != nil {
                return rhs!
            } else if lhs != nil {
                return lhs!
            } else {
                return 0
            }
        }
        
        // Swap for modulo
        if lhs! < rhs! {
            let ctp = lhs
            lhs = rhs
            rhs = ctp
        }
        
        // Get greatest common divisor
        var rest: Int
        while true {
            rest = lhs! % rhs!
            
            if rest == 0 {
                return rhs! // Found it
            } else {
                lhs = rhs
                rhs = rest
            }
        }
    }
    
    class func gcdForArray(_ array: [Int]) -> Int {
        if array.isEmpty {
            return 1
        }
        
        var gcd = array[0]
        
        for val in array {
            gcd = UIImage.gcdForPair(val, gcd)
        }
        
        return gcd
    }
    
    class func animatedImageWithSource(_ source: CGImageSource,_ imageOrg: Int? = nil) -> UIImage? {
        let count = CGImageSourceGetCount(source)
        var images = [CGImage]()
        var delays = [Int]()
        
        if count > 0 {
            // Fill arrays
            for index in 0..<count {
                // Add image
                if let image = CGImageSourceCreateImageAtIndex(source, index, nil) {
                    images.append(image)
                }
                
                // At it's delay in cs
                let delaySeconds = UIImage.delayForImageAtIndex(Int(index),
                                                                source: source)
                delays.append(Int(delaySeconds * 1000.0)) // Seconds to ms
            }
            
            // Calculate full duration
            let duration: Int = {
                var sum = 0
                
                for val: Int in delays {
                    sum += val
                }
                
                return sum
            }()
            
            // Get frames
            let gcd = gcdForArray(delays)
            var frames = [UIImage]()
            
            var frame: UIImage
            var frameCount: Int
            for index in 0..<count {
                frame = UIImage(cgImage: images[Int(index)])
                frameCount = Int(delays[Int(index)] / gcd)
                
                for _ in 0..<frameCount {
                    frames.append(frame)
                }
            }
            
            if let _ = imageOrg {
                frames = [frames[frames.endIndex - 1]]
            }
            // Heyhey
            let animation = UIImage.animatedImage(with: frames,
                                                  duration: Double(duration) / 1000.0)
            
            return animation
        }
        return UIImage(named: "image_placeholder_landscape")
    }
    
    func renderOriginal() -> UIImage {
        return self.withRenderingMode(.alwaysOriginal)
    }
}
extension UIImage {
    func resize(targetSize: CGSize) -> UIImage {
        let size = self.size
        
        let widthRatio  = targetSize.width  / self.size.width
        let heightRatio = targetSize.height / self.size.height
        
        var newSize: CGSize
        if widthRatio > heightRatio {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0)
        self.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}

extension UIImage {
    func resized(withPercentage percentage: CGFloat) -> UIImage? {
        let canvasSize = CGSize(width: size.width * percentage, height: size.height * percentage)
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }

    func resizedTo12MB() -> UIImage? {
        guard let imageData = self.pngData() else { return nil }
        let megaByte = 1200.0

        var resizingImage = self
        var imageSizeKB = Double(imageData.count) / megaByte
        while imageSizeKB > megaByte {
            guard let resizedImage = resizingImage.resized(withPercentage: 0.7),
            let imageData = resizedImage.pngData() else { return nil }

            resizingImage = resizedImage
            imageSizeKB = Double(imageData.count) / megaByte
        }

        return resizingImage
    }
}

extension UIImage {
    func getImageRatio() -> CGFloat {
        let imageRatio = CGFloat(self.size.width / self.size.height)
        return imageRatio
    }
}
