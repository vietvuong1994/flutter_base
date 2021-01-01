//
//  NewSongVC.swift
//  DJCloud
//
//  Created by kien on 10/23/20.
//  Copyright © 2020 kienpt. All rights reserved.
//

import UIKit
import LNPopupController

enum TypeSongListHome {
    case new
    case today
    case top20
}

class NewSongVC: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var didLoadData: ((Bool)->Void)?
    private var listData: [PlayableItem] = []
    var typeMainHome: TypeSongListHome = .new
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpSongCollectionView()
        switch typeMainHome {
        case .new:
            getSongNewDataServer()
        case .today:
            getSongTodayDataServer()
        case .top20:
            getSongTopDataServer()
        }
    }
    
    private func getSongNewDataServer() {
        GetSongNewAPI.init(size: 5).set(silentLoad: true).execute(target: self) { (response) in
            self.listData = response.list
            self.collectionView.reloadData()
            self.didLoadData?(self.listData.count != 0)
        } failure: { (error) in
            self.didLoadData?(false)
        }
    }
    
    private func getSongTodayDataServer() {
        GetSongNewAPI.init(size: 5).set(silentLoad: true).execute(target: self) { (response) in
            self.listData = response.list
            self.collectionView.reloadData()
            self.didLoadData?(self.listData.count != 0)
        } failure: { (error) in
            self.didLoadData?(false)
        }
    }
    
    private func getSongTopDataServer() {
        GetListSongTopAPI.init(size: 20).set(silentLoad: true).execute(target: self) { (response) in
            self.listData = response.list
            self.didLoadData?(self.listData.count != 0)
            self.collectionView.reloadData()
        } failure: { (error) in
            self.didLoadData?(false)
        }
    }

    private func setUpSongCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.registerNibCellFor(type: SongGirdCell.self)
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 5
        layout.itemSize = CGSize(width: 144, height: 190)
        collectionView.collectionViewLayout = layout
    }
}
extension NewSongVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.reusableCell(type: SongGirdCell.self, indexPath: indexPath) else {
            return UICollectionViewCell()
        }
        cell.setData(item: listData[indexPath.row])
        return cell
    }
}
extension NewSongVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = MusicPlayVC()
        vc.playableList = [listData[indexPath.row]]
//        vc.audioPlayer.play(item: listData[indexPath.row])
        vc.popupBar.progressView.progressTintColor = UIColor.appColor(.ColorTintApp)
        tabBarController?.presentPopupBar(withContentViewController: vc, animated: true, completion: nil)
        tabBarController?.popupBar.imageView.layer.cornerRadius = 3
        tabBarController?.popupBar.progressViewStyle = .top
    }
}
