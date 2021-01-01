//
//  PlayListVC.swift
//  DJCloud
//
//  Created by kien on 9/13/20.
//  Copyright © 2020 kienpt. All rights reserved.
//

import UIKit

class PlayListVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
    }
    
    private func setUpTableView() {
        tableView.tableHeaderView = AdBannerView(frame: CGRect(x: 0, y: 0, width: ScreenUtils.screenWidth, height: 56))
        tableView.registerNibHeaderFooterFor(type: CreatePlayListHeaderView.self)
        tableView.registerNibCellFor(type: PlayListCell.self)
        tableView.dataSource = self
        tableView.delegate = self
        
    }
}
extension PlayListVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            guard let cell = tableView.reusableCell(type: PlayListCell.self) else {
                return UITableViewCell()
            }
            return cell
        
    }
}
extension PlayListVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 108
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.reusableHeaderFooterFor(type: CreatePlayListHeaderView.self)
        header?.didSelectCreate = {[weak self] in
            CreatePlayListVC.present(from: self, animated: true, prepare: { (vc) in
                vc.modalTransitionStyle = .crossDissolve
                vc.modalPresentationStyle = .overFullScreen
            }, completion: nil)
        }
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 56
    }
        
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
    }
}
