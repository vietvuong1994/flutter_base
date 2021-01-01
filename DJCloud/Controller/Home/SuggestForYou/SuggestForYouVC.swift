//
//  SuggestForYouVC.swift
//  DJCloud
//
//  Created by kien on 10/23/20.
//  Copyright © 2020 kienpt. All rights reserved.
//

import UIKit

class SuggestForYouVC: UIViewController {

    @IBOutlet weak var tableView: BaseTableView!
    
    var didChangeHeight: ((CGFloat)->Void)?
    private var listData: [PlayableItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
        getDataServer()
    }
    
    private func getDataServer() {
        GetListSongSuggestAPI.init().set(silentLoad: true).execute(target: self) { (response) in
            self.listData = response.list
            self.tableView.reloadData()
        } failure: { (error) in
            
        }

    }
    
    private func setUpTableView() {
        tableView.registerNibCellFor(type: SongListCell.self)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.didChangeContentSize = {[weak self] (size) in
            self?.didChangeHeight?(size.height)
        }
    }
}
extension SuggestForYouVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.reusableCell(type: SongListCell.self) else {
            return UITableViewCell()
        }
        cell.setData(item: listData[indexPath.row])
        cell.didSelectMoreMenu = {[weak self] in
            guard let `self` = self else { return }
            MenuSelectVC.present(from: self, animated: true, prepare: { (vc) in
                vc.modalTransitionStyle = .coverVertical
                vc.modalPresentationStyle = .overFullScreen
                vc.listData = [.SaveToFavorite, .Report]
                vc.itemPlay = self.listData[indexPath.row]
                vc.didSelectMenu = {[weak self] (menu) in
                    guard let `self` = self else { return }
                    switch menu {
                    case .SaveToFavorite:
                        if self.listData[indexPath.row].isFavorite {
                            self.listData[indexPath.row].isFavorite = false
                            let _ = Toast.show(message: "Đã bỏ hát yêu thích", controller: self)
                        } else {
                            self.listData[indexPath.row].isFavorite = true
                            let _ = Toast.show(message: "Đã thêm vào bài hát yêu thích", controller: self)
                        }
                    case .Report:
                        GeneralUtils.openUrl(string: "https://docs.google.com/forms/d/e/1FAIpQLSf2eZX22P7PA5uUnMiOmMcEzE6tARK4Gc2hicp1OP-86_pEDQ/viewform")
                    default:
                        break
                    }
                }
            }, completion: nil)
        }
        return cell
    }
}
extension SuggestForYouVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = MusicPlayVC()
        vc.playableList = [listData[indexPath.row]]
//        vc.audioPlayer.play(item: listData[indexPath.row])
        vc.popupBar.progressView.progressTintColor = UIColor.appColor(.ColorTintApp)
        tabBarController?.presentPopupBar(withContentViewController: vc, animated: true, completion: nil)
        tabBarController?.popupBar.imageView.layer.cornerRadius = 3
        tabBarController?.popupBar.progressViewStyle = .top
    }
}
