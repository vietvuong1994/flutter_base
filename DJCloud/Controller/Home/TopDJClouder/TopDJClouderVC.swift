//
//  TopDJClouderVC.swift
//  DJCloud
//
//  Created by kien on 10/23/20.
//  Copyright © 2020 kienpt. All rights reserved.
//

import UIKit

class TopDJClouderVC: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var didLoadData: ((Bool)->Void)?
    private var listData: [Artist] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpSongCollectionView()
        getDataServer()
    }
    
    private func getDataServer() {
        GetListTopArtistAPI.init().set(silentLoad: true).execute(target: self) { (response) in
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
        collectionView.registerNibCellFor(type: TopDJClouderCell.self)
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 5
        layout.itemSize = CGSize(width: 85, height: 120)
        collectionView.collectionViewLayout = layout
    }
}
extension TopDJClouderVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.reusableCell(type: TopDJClouderCell.self, indexPath: indexPath) else {
            return UICollectionViewCell()
        }
        cell.setData(item: listData[indexPath.row])
        return cell
    }
}
extension TopDJClouderVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = SongDisplayVC.create()
        vc.artist = listData[indexPath.row]
        self.view.parentViewController?.navigationController?.pushViewController(vc, animated: true)
    }
}

