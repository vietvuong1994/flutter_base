//
//  CameraPhotoService.swift
//  HopAmNhanh
//
//  Created by kien on 6/29/20.
//  Copyright © 2020 kienpt. All rights reserved.
//

import UIKit
import CropViewController
import DataCompression

enum CameraPhotoServiceType {
    case camera, photoLibrary
}

class CameraPhotoService: NSObject {
    // MARK: - Singleton
    static var instance = CameraPhotoService()
    private var resizeWidth: CGFloat = 500
    private var resizeHeight: CGFloat = 500
    private var type: CameraPhotoServiceType = .photoLibrary
    private var cropSize = CGSize(width: 0, height: 0)
    private var filePath: URL?
    private var isChosen = false
    let cameraView = UIImagePickerController()
    var allowCrop: Bool = true
    // MARK: - Closures
    private var didPickImage: ((_ dataImage: Data?) -> Void)?
    
    private func showDropImage(image: UIImage) {
        let imageSelected = image.resize(targetSize: CGSize(width: self.resizeWidth, height: self.resizeHeight))
        let cropViewController = CropViewController(image: imageSelected)
        if cropSize != CGSize(width: 0, height: 0) {
            cropViewController.customAspectRatio = cropSize
            cropViewController.aspectRatioLockEnabled = true
            cropViewController.resetButtonHidden = true
        }
        cropViewController.delegate = self
        UIViewController.top()?.present(cropViewController, animated: true, completion: nil)
    }
    
    func showScreenOf(type: CameraPhotoServiceType, sizeCrop: CGSize = CGSize(width: 0, height: 0), canEdit: Bool = false, didDenyPermission: (() -> Void)? = nil, didPickImage: @escaping ((_ image: Data? ) -> Void)) {
        func moveToImagePickerScreen() {
            let sourceType: UIImagePickerController.SourceType = type == .camera ? .camera : .photoLibrary
            guard UIImagePickerController.isSourceTypeAvailable(sourceType) else {
                didPickImage(nil)
                return
            }
            self.didPickImage = didPickImage
            cameraView.delegate = self
            cameraView.sourceType = sourceType
            cameraView.allowsEditing = canEdit
            UIViewController.top()?.present(cameraView, animated: true, completion: nil)
        }
        self.cropSize = sizeCrop
        self.type = type
        if type == .camera {
            switch Permission.cameraAuthStatus {
            case .notDetermined:
                Permission.requestCameraPermission(completion: { granted in
                    if granted {
                        moveToImagePickerScreen()
                    } else {
                        didDenyPermission?()
                    }
                })
            case .authorized:
                moveToImagePickerScreen()
            case .denied:
                showPermissionDialog(type: type)
            default: break
            }
        } else {
            switch Permission.photoAuthStatus {
            case .notDetermined:
                Permission.requestPhotoPermission(completion: { granted in
                    if granted {
                        moveToImagePickerScreen()
                    } else {
                        didDenyPermission?()
                    }
                })
            case .authorized:
                moveToImagePickerScreen()
            case .denied:
                showPermissionDialog(type: type)
            default: break
            }
        }
    }
    
    private func showPermissionDialog(type: CameraPhotoServiceType) {
        var titleAlert = ""
        switch type {
        case .photoLibrary:
            titleAlert = "photo_library".localized
        case .camera:
            titleAlert = "camera".localized
        }
        let alert = UIAlertController(title: titleAlert, message: "access_permission_message".localized, preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: "setting".localized, style: .default, handler: { (action) in
            if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(settingsURL)
                } else {
                    UIApplication.shared.openURL(settingsURL)
                }
            }
        }))
        alert.addAction(UIAlertAction.init(title: "dialog_cancel".localized, style: .cancel, handler: nil))
        alert.showDialog()
    }
    
    static func compressImage(sourceImage: UIImage) -> Data? {
        var compression: CGFloat = 0.5
        let maxCompression: CGFloat = 0.1
        let maxFileSize = 1000*1024;
        
        var imageData = sourceImage.jpegData(compressionQuality: compression)
        
        while ((imageData?.count)! > maxFileSize && compression > maxCompression)
        {
            compression -= 0.1;
            imageData = sourceImage.jpegData(compressionQuality: compression)
        }
        
        let countBytes = ByteCountFormatter()
        countBytes.allowedUnits = [.useMB]
        countBytes.countStyle = .file
        let fileSize = countBytes.string(fromByteCount: Int64(imageData!.count))
        
        print("File size: \(fileSize)")
        return imageData
    }
}

extension CameraPhotoService: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else {
            self.didPickImage?(nil)
            return
        }
        if isChosen { return }
        isChosen = true
        if allowCrop || type == .camera {
            let imageSelected = image.resize(targetSize: CGSize(width: self.resizeWidth, height: self.resizeHeight))
            let cropViewController = CropViewController(image: imageSelected)
            if cropSize != CGSize(width: 0, height: 0) {
                cropViewController.customAspectRatio = cropSize
                cropViewController.aspectRatioLockEnabled = true
                cropViewController.resetButtonHidden = true
            }
            cropViewController.delegate = self
            UIViewController.top()?.present(cropViewController, animated: true, completion: nil)
        } else {
            if let assetPath = info[UIImagePickerController.InfoKey.imageURL] {
                let url = assetPath as! URL
                let path = url.path
                if path.hasSuffix(".gif") || path.hasSuffix(".GIF") {
                    self.cameraView.dismiss(animated: true, completion: {
                        do {
                            self.didPickImage?(try Data(contentsOf: url))
                        } catch {
                            print("there's no image")
                        }
                    })
                }
            }
            showDropImage(image: image)
        }
    }
    
}

extension CameraPhotoService: CropViewControllerDelegate {
    func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        // 'image' is the newly cropped version of the original image
        cropViewController.dismiss(animated: true, completion: nil)
        self.cameraView.dismiss(animated: true, completion: {
            self.didPickImage?(CameraPhotoService.compressImage(sourceImage: image))
            self.isChosen = false
        })
    }
    
    func cropViewController(_ cropViewController: CropViewController, didFinishCancelled cancelled: Bool) {
        cropViewController.dismiss(animated: true, completion: nil)
        cameraView.dismiss(animated: true, completion: nil)
        self.isChosen = false
    }
}
