//
//  SearchSongVC.swift
//  HopAmNhanh
//
//  Created by kien on 8/18/20.
//  Copyright © 2020 kienpt. All rights reserved.
//

import UIKit

class SearchSongVC: BaseVC {

    @IBOutlet weak var tableView: UITableView!
    
    private var listSongSearch: [String] = []
    var textSearch: String = ""
    private var totalItem: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
    }
    
    private func setUpTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.keyboardDismissMode = .onDrag
        tableView.registerNibCellFor(type: SongSearchCell.self)
//        tableView.infiniteScrollIndicatorStyle = ShareData.darkModeInApp ? .white : .gray
//        tableView.addInfiniteScroll {[weak self] (tableView) in
//            guard let `self` = self else { return }
//            self.loadMoreData(keyWord: self.textSearch) {
//                self.tableView.finishInfiniteScroll()
//            }
//        }
//        tableView.setShouldShowInfiniteScrollHandler { (_) -> Bool in
//            return self.listSongSearch.count < self.totalItem
//        }
    }
    
    private func searchSong(keyWord: String, completion: (()->Void)?) {
        
    }
    
   
    func setTextSearch(text: String) {
        if !text.isEmpty && text != textSearch {
            textSearch = text
            searchSong(keyWord: text, completion: nil)
        }
    }
}
extension SearchSongVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.reusableCell(type: SongSearchCell.self) else {
            return UITableViewCell()
        }
        return cell
    }
}
extension SearchSongVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
