//
//  CategoryVC.swift
//  DJCloud
//
//  Created by kien on 10/24/20.
//  Copyright © 2020 kienpt. All rights reserved.
//

import UIKit

class CategoryVC: UIViewController {
    
    @IBOutlet weak var tableView: BaseTableView!
    @IBOutlet weak var viewPlay: UIView!
    @IBOutlet weak var imageBgNavigation: UIImageView!
    @IBOutlet weak var lbTitleCategory: UILabel!
    
    private var listData: [PlayableItem] = []
    var genre: Genre?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lbTitleCategory.text = genre?.title
        setUpTableView()
        getDataServer()
    }
    
    private func setUpTableView() {
        tableView.registerNibCellFor(type: SongListCell.self)
        tableView.contentInset.top = 24
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        viewPlay.roundRectWith(corners: [.topLeft, .topRight, .bottomLeft, .bottomRight], radius: 24)
        viewPlay.layoutIfNeeded()
        viewPlay.setGradientBackground(startColor: UIColor(hex: 0x32237e), endColor: UIColor(hex: 0x7291c6), gradientDirection: .leftToRight)
        imageBgNavigation.roundRectWith(corners: [.bottomLeft, .bottomRight], radius: 20)
        imageBgNavigation.layoutIfNeeded()
    }
    
    private func getDataServer() {
        if let slug = genre?.slug, !slug.isEmpty {
            GetListSongByGenreAPI.init(slug: slug).execute(target: self) { (response) in
                self.listData = response.list
                self.tableView.reloadData()
            } failure: { (error) in
                
            }
        }

    }

    @IBAction func actionBack(_ sender: Any) {
        self.pop()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension CategoryVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.reusableCell(type: SongListCell.self) else {
            return UITableViewCell()
        }
        cell.setData(item: listData[indexPath.row])
        return cell
    }
}
extension CategoryVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = MusicPlayVC()
        vc.playableList = [listData[indexPath.row]]
//        vc.audioPlayer.play(item: listData[indexPath.row])
//        vc.playableList.append(listData[indexPath.row])
        vc.popupBar.progressView.progressTintColor = UIColor.appColor(.ColorTintApp)
        tabBarController?.presentPopupBar(withContentViewController: vc, animated: true, completion: nil)
        tabBarController?.popupBar.imageView.layer.cornerRadius = 3
        tabBarController?.popupBar.progressViewStyle = .top
    }
}
