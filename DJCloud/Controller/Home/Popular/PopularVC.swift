//
//  PopularVC.swift
//  DJCloud
//
//  Created by kien on 9/13/20.
//  Copyright © 2020 kienpt. All rights reserved.
//

import UIKit

class PopularVC: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var listData: [Genre] = []
    var didLoadData: ((Bool)->Void)?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private func getDataServer() {
        GetListGenresAPI.init().set(silentLoad: true).execute(target: self) { (resonse) in
            self.listData = resonse.list
            self.didLoadData?(self.listData.count != 0)
            self.collectionView.reloadData()
        } failure: { (error) in
            self.didLoadData?(false)
        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpSongCollectionView()
        getDataServer()
    }
    
    private func setUpSongCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.registerNibCellFor(type: CategoryPopularCell.self)
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 5
        layout.itemSize = CGSize(width: 120, height: 72)
        collectionView.collectionViewLayout = layout
    }
}
extension PopularVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.reusableCell(type: CategoryPopularCell.self, indexPath: indexPath) else {
            return UICollectionViewCell()
        }
        cell.setData(item: listData[indexPath.row])
        return cell
    }
}
extension PopularVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = CategoryVC.create()
        vc.genre = listData[indexPath.row]
        self.view.parentViewController?.navigationController?.pushViewController(vc, animated: true)

    }
}

