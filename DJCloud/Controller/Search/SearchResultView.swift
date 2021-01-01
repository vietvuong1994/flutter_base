//
//  SearchResultView.swift
//  TetViet
//
//  Created by QuangLH on 12/24/18.
//  Copyright © 2018 Rikkeisoft. All rights reserved.
//

import UIKit
import UIScrollView_InfiniteScroll

protocol SearchResultViewDelegate: class {
    func scrollViewDidScroll(_ scrollView: UIScrollView)
}

enum SearchTypeAPI {
    case history
    case suggest
    case result
}

class SearchResultView: UIView {
    
    // MARK: - Outlets
    @IBOutlet weak var tableView: BaseTableView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var viewResultEmpty: UIView!
    @IBOutlet weak var lbTextEmptySearch: UILabel!
    
    // MARK: - Variables
    var didSelectSong: ((PlayableItem)->Void)?
    var searchText: String? {
        didSet {
            if searchText?.count ?? 0 < 3 { return }
            listResult = []
            listHistory = []
            tableView.reloadData()
            callSearchAPI(completion: nil)
        }
    }
    
    weak var delegate: SearchResultViewDelegate?
    var typeSearch: SearchTypeAPI? {
        didSet {
            if let type = typeSearch {
                switch type {
                case .suggest:
                    tableView.registerNibCellFor(type: SearchViewCell.self)
                case .result:
                    tableView.registerNibCellFor(type: SongListCell.self)
                case .history:
                    break
                }
            }
        }
    }
    private var listHistory: [String] = []
    private var listResult: [PlayableItem] = []
    
    // MARK: - Initiazer
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("SearchResultView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        tableView.addInfiniteScroll {[weak self] (tableView) in
            self?.callSearchAPI {
                tableView.finishInfiniteScroll()
            }
        }
        tableView.setShouldShowInfiniteScrollHandler {[weak self] (_) -> Bool in
            guard let `self` = self else { return false }
            return false
        }
        self.viewResultEmpty.isHidden = true
        typeSearch = .history
        callGetHistory(completion: nil)
    }
    
    // MARK: - Functions
    func callSearchAPI(completion: (()->Void)?) {
        guard let text = searchText, !text.isEmpty else { return }
        if typeSearch == .suggest {
            callSearchResult(text: text) {
                self.viewResultEmpty.isHidden = true
                completion?()
            }
        } else if typeSearch == .result {
            callSearchResult(text: text) {
                completion?()
                self.viewResultEmpty.isHidden = self.listResult.count > 0
                self.lbTextEmptySearch.text = self.searchText
            }
        }
        
    }
    
    private func callGetHistory(completion: (()->Void)?) {
        GetHistorySearchAPI.init().set(silentLoad: true).showIndicator(true).autoShowApiErrorAlert(true).execute(target: nil, success: {[weak self] (response) in
            guard let `self` =  self else { return }
            self.listHistory = response.list
            self.tableView.reloadData()
            completion?()
        }) { (_) in
            completion?()
        }
    }
    
    private func callSearchResult(text: String, completion: (()->Void)?) {
        SearchSongAPI.init(keyWord: searchText ?? "", offset: listResult.count).set(silentLoad: true).showIndicator(true).autoShowApiErrorAlert(true).execute(target: nil, success: {[weak self] (response) in
            guard let `self` =  self else { return }
            // create new index paths
            let count = self.listResult.count
            let (start, end) = (count, response.list.count + count)
            let indexPaths = (start..<end).map { return IndexPath(row: $0, section: 0) }

            // update data source
            self.listResult.append(contentsOf: response.list)
//            self.eventObj = response.eventObj

            // update table view
            self.tableView.beginUpdates()
            self.tableView.insertRows(at: indexPaths, with: .automatic)
            self.tableView.endUpdates()
            
            completion?()
        }) { (_) in
            completion?()
        }
    }
}

// MARK: - UITableViewDataSource
extension SearchResultView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch typeSearch {
        case .history:
            return listHistory.count
        default:
            return listResult.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch typeSearch {
        case .result:
            guard let cell = self.tableView.reusableCell(type: SongListCell.self) else {
                return UITableViewCell()
            }
            cell.setData(item: listResult[indexPath.row])
            return cell
        case .suggest:
            guard let cell = self.tableView.reusableCell(type: SearchViewCell.self) else {
                return UITableViewCell()
            }
            cell.setData(item: listResult[indexPath.row])
            return cell
        default:
            let cell = UITableViewCell()
            cell.textLabel?.text = listHistory[indexPath.row]
            return cell
        }
    }
}

// MARK: - UITableViewDelegate
extension SearchResultView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.typeSearch == .suggest || typeSearch == .result {
            didSelectSong?(listResult[indexPath.row])
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension SearchResultView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        delegate?.scrollViewDidScroll(scrollView)
    }
}
