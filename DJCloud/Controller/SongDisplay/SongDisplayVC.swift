//
//  ListSongVC.swift
//  HopAmNhanh
//
//  Created by kien on 8/5/20.
//  Copyright © 2020 kienpt. All rights reserved.
//

import UIKit
import UIScrollView_InfiniteScroll

class SongDisplayVC: BaseVC {

    // MARK: - Outlet
    @IBOutlet weak var tableView: BaseTableView!
    
    // MARK: - Variable
    private var isScale = false
    let header = HeaderSongDisplaySongView()
    var artist: Artist?
    var listSong: [PlayableItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        header.lbTitle.text = artist?.name
        header.imgImageHeader.loadImage(url: URL(string: artist?.thumbImage ?? ""))
        setUpTableView()
        getDataServer()
    }
    
    private func setUpTableView() {
        tableView.registerNibCellFor(type: SongListCell.self)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.parallaxHeader.view = header
        tableView.parallaxHeader.height = 420
        tableView.parallaxHeader.mode = .topFill
        tableView.addInfiniteScroll {[weak self] (tableView) in
            guard let `self` = self else { return }
            
        }
        tableView.infiniteScrollIndicatorStyle = .gray
        tableView.setShouldShowInfiniteScrollHandler { (_) -> Bool in
            return false
        }
        tableView.parallaxHeader.parallaxHeaderDidScrollHandler = {[weak self] (progress) in
            guard let `self` = self else { return }
            if progress.progress < 0.9 {
                if !self.isScale {
                    let originalTransform = self.header.viewContent.transform
                    let scaledTransform = originalTransform.scaledBy(x: 0.9, y: 0.9)
                    self.isScale = true
                    UIView.animate(withDuration: 0.4, animations: {
                        self.header.viewContent.transform = scaledTransform
                    })
                }
            } else {
                if self.isScale {
                    let originalTransform = self.header.viewContent.transform
                    let scaledTransform = originalTransform.scaledBy(x: 1.1, y: 1.1)
                    self.isScale = false
                    UIView.animate(withDuration: 0.4, animations: {
                        self.header.viewContent.transform = scaledTransform
                    })
                }
            }
        }
    }
    
    private func getDataServer() {
        guard let slug = artist?.slug else {
            return
        }
        GetSongByArtistAPI.init(slug: slug).execute(target: self) { (response) in
            self.listSong = response.list
            self.tableView.reloadData()
        } failure: { (error) in
            
        }
    }

    @IBAction func actionBack(_ sender: Any) {
        self.pop()
    }
    
}
extension SongDisplayVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listSong.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.reusableCell(type: SongListCell.self, indexPath: indexPath) else {
            return UITableViewCell()
        }
        cell.setData(item: listSong[indexPath.row])
        return cell
    }
}
extension SongDisplayVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if AppDelegate.shared?.user?.isGuest == true {
            UIAlertController.showSystemAlert(target: self, title: "Bạn dùng tài khoản khách.", message: "Bạn cần đăng kí tài khoản để được trải nghiệm tính năng này!", buttons: ["Đăng kí ngay", "Để sau"]) { (index, str) in
                if index == 0 {
                    NotificationCenter.default.post(name: NotifiNameCenter.ShowLinkAccount, object: nil)
                }
            }
            return
        }
        let vc = MusicPlayVC()
        vc.playableList = [listSong[indexPath.row]]
        vc.popupBar.progressView.progressTintColor = UIColor.appColor(.ColorTintApp)
        tabBarController?.presentPopupBar(withContentViewController: vc, animated: true, completion: nil)
        tabBarController?.popupBar.imageView.layer.cornerRadius = 3
        tabBarController?.popupBar.progressViewStyle = .top
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
}
