//
//  SearchVC.swift
//  HopAmNhanh
//
//  Created by kien on 8/17/20.
//  Copyright © 2020 kienpt. All rights reserved.
//

import UIKit

class SearchVC: BaseVC {
    
    @IBOutlet weak var scrollTypeSearch: UIScrollView!
    @IBOutlet weak var btnSongCloud: UIButton!
    @IBOutlet weak var btnSongLibrary: UIButton!
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var viewBgSearch: RoundedView!
    
    private var pageViewControl = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    private let searchBar = UISearchBar()
    private let searchSongCloudVC = SearchSongVC.create()
    private let searchSongLibraryVC = SearchSongVC.create()
    private var listVC: [UIViewController] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        listVC.append(searchSongCloudVC)
        listVC.append(searchSongLibraryVC)
        setUpPageController()
    }
    
    override func viewDidLayoutSubviews() {
        viewBgSearch.cornerRadius = viewBgSearch.bounds.height / 2
    }
    
    private func setUpPageController() {
        viewContainer.addSubview(pageViewControl.view)
        addChild(pageViewControl)
        pageViewControl.didMove(toParent: self)
        pageViewControl.view.fitTo(superView: viewContainer)
        pageViewControl.setViewControllers([searchSongCloudVC], direction: .reverse, animated: false, completion: nil)
    }
    
    @IBAction func actionCancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func actionDone(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func actionSearchSongCloud(_ sender: Any) {
        btnSongLibrary.alpha = 0.6
        btnSongCloud.alpha = 1
        scrollTypeSearch.setContentOffset(CGPoint.zero, animated: true)
        btnSongCloud.setTitleColor(UIColor.appColor(.ColorTintApp), for: .normal)
        btnSongLibrary.setTitleColor(UIColor.white, for: .normal)
    }
    
    @IBAction func actionSearchSongLibrary(_ sender: Any) {
        btnSongLibrary.alpha = 1
        btnSongCloud.alpha = 0.6
        btnSongLibrary.setTitleColor(UIColor.appColor(.ColorTintApp), for: .normal)
        btnSongCloud.setTitleColor(UIColor.white, for: .normal)
        scrollTypeSearch.setContentOffset(CGPoint(x: -(scrollTypeSearch.frame.width / 2), y: 0), animated: true)
    }
    
    @objc func actionBack() {
        self.dismiss(animated: true, completion: nil)
    }
}


