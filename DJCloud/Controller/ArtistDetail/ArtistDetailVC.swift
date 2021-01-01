//
//  ArtistDetailVC.swift
//  DJCloud
//
//  Created by kien on 11/18/20.
//  Copyright © 2020 kienpt. All rights reserved.
//

import UIKit

class ArtistDetailVC: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var tableView: BaseTableView!
    @IBOutlet weak var viewBgNavigation: UIView!
    
    @IBOutlet weak var constraintHeightTableView: NSLayoutConstraint!
    
    let header = HeaderArtistDetail()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
        scrollView.contentInset.top = -ScreenUtils.safeAreaInsetTop
        scrollView.parallaxHeader.view = header
        scrollView.parallaxHeader.height = 590
        scrollView.parallaxHeader.mode = .bottomFill
        scrollView.parallaxHeader.parallaxHeaderDidScrollHandler = {[weak self] (progress) in
            guard let `self` = self else { return }
            self.viewBgNavigation.alpha = 1 - progress.progress
        }
    }

    private func setUpTableView() {
        tableView.registerNibCellFor(type: SongListCell.self)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.didChangeContentSize = {[weak self] (size) in
            self?.constraintHeightTableView.constant = size.height
        }
    }
    
    @IBAction func actionBack(_ sender: Any) {
        pop()
    }
    
}
extension ArtistDetailVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.reusableCell(type: SongListCell.self) else {
            return UITableViewCell()
        }
        return cell
    }
}
extension ArtistDetailVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
