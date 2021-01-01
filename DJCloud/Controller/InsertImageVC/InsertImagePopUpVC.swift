//
//  RKInsertImagePopUpVC.swift
//  Rocket.Chat
//
//  Created by ThuongLTT-D1 on 9/6/19.
//  Copyright © 2019 Rocket.Chat. All rights reserved.
//

import UIKit
import Photos
import CropViewController

class InsertImagePopUpVC: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet weak var tapBackView: UIView!
    @IBOutlet weak var heightOfTableView: NSLayoutConstraint!

    @IBOutlet weak var registerTablevView: UITableView!
    
    var imagePass: ((ImageInfo) -> Void)?
    var isCoverImage = false
    var imagePicker = UIImagePickerController()
    var isPictureFromCamera = false
    var resizeWidth: CGFloat = 500
    var resizeHeight: CGFloat = 500
    
    private var filePath: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let handleTap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        tapBackView.addGestureRecognizer(handleTap)
        heightOfTableView.constant = CGFloat(ImageSelectionType.allCases.count * 50)
        setUpTableView()
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }
    
    private func setUpTableView() {
        registerTablevView.dataSource = self
        registerTablevView.delegate = self
        registerTablevView.registerNibCellFor(type: FilterCell.self)
        registerTablevView.separatorStyle = .none
    }
}

extension InsertImagePopUpVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let index = ImageSelectionType(rawValue: indexPath.row) else { return }
        var cropSize = CGSize(width: 0, height: 0)
        if isCoverImage {
            let screenRect = UIScreen.main.bounds
            let screenWidth = screenRect.size.width
            let screenHeight = screenRect.size.width * 234/375
            cropSize = CGSize(width: screenWidth , height: screenHeight)
        }
        CameraPhotoService.instance.showScreenOf(type: index == .library ? .photoLibrary : .camera, sizeCrop: cropSize) { (dataImage) in
            guard let data = dataImage, let image = UIImage(data: dataImage ?? Data()) else { return }
            self.imagePass?(ImageInfo(image: image, dataImage: data, numberInAPI: -1))
            CameraPhotoService.instance.allowCrop = true
            self.dismiss(animated: true, completion: nil)
        }
    }
}

extension InsertImagePopUpVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ImageSelectionType.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let model = ImageSelectionType(rawValue: indexPath.row) else {
            return UITableViewCell()
        }
        guard let cell = tableView.reusableCell(type: FilterCell.self, indexPath: indexPath) else {
            return UITableViewCell()
        }
        cell.setupCell(image: model.icon, title: model.title)
        cell.separateView.isHidden = indexPath.row == ImageSelectionType.allCases.count - 1
        return cell
    }
}

enum ImageSelectionType: Int, CaseIterable {
    case library
    case camera
    
    var icon : String {
        switch self {
        case .library:
            return "redLibary"
        case .camera:
            return "redCam"
        }
    }
    
    var title : String {
        switch self {
        case .library:
            return "pick_image_form_library".localized
        case .camera:
            return "new_photo_form_camera".localized
        }
    }
}

struct ImageInfo {
    var image: UIImage
    var dataImage: Data
    var numberInAPI: Int
}
