//
//  MenuSelectSongVC.swift
//  DJCloud
//
//  Created by kien on 9/14/20.
//  Copyright © 2020 kienpt. All rights reserved.
//

import UIKit

enum MenuSelectType {
    case SaveToFavorite
    case PlayNext
    case Share
    case DetaiInfo
    case Report
    
    var title: String {
        switch self {
        case .SaveToFavorite:
            return "Lưu vào danh sách yêu thích"
        case .PlayNext:
            return "Phát kế tiếp"
        case .Share:
            return "Chia sẻ"
        case .DetaiInfo:
            return "Thông tin DJ"
        case .Report:
            return "Báo cáo nội dung"
        }
    }
    
    var image: UIImage? {
        switch self {
        case .SaveToFavorite:
            return UIImage(named: "iconFavorite")
        case .PlayNext:
            return UIImage(named: "iconPlayLaterGray")
        case .Share:
            return UIImage(named: "iconShareGray")
        case .DetaiInfo:
            return UIImage(named: "iconUser")
        case .Report:
            return UIImage(named: "iconReport")
        }
    }
}

class MenuSelectVC: UIViewController {
    
    @IBOutlet weak var viewDrim: UIView!
    @IBOutlet weak var tableView: BaseTableView!
    @IBOutlet weak var imgHead: UIImageView!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbSubTitle: UILabel!
    @IBOutlet weak var stackViewInfoTitle: UIStackView!
    @IBOutlet weak var viewLine: UIView!
    @IBOutlet weak var viewHead: UIView!
    
    @IBOutlet weak var constraintHeightViewHead: NSLayoutConstraint!
    @IBOutlet weak var constraintWidthImageHead: NSLayoutConstraint!
    @IBOutlet weak var constraintHeightTableView: NSLayoutConstraint!
    
    // MARK: - Variables
    var didSelectMenu: ((MenuSelectType?)->Void)?
    var listData: [MenuSelectType] = []
    var itemPlay: PlayableItem?
    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewDrim.alpha = 0
        setUpTableView()
        let tap = UITapGestureRecognizer(target: self, action: #selector(actionTapOutSide))
        viewDrim.addGestureRecognizer(tap)
        constraintHeightViewHead.constant = 0
        viewHead.subviews.forEach { (view) in
            view.isHidden = true
        }
        viewLine.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        view.layoutIfNeeded()
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.viewDrim.alpha = 1
            self.view.layoutIfNeeded()
        }, completion: { _ in
            self.viewDrim.alpha = 1
        })
    }
    
    
    private func setUpTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.registerNibCellFor(type: MenuSelectCell.self)
        tableView.didChangeContentSize = {[weak self](size) in
            self?.constraintHeightTableView.constant = size.height
        }
    }
    
    @objc private func actionTapOutSide() {
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.2, options: .curveEaseInOut, animations: {
            self.viewDrim.alpha = 0
            self.view.layoutIfNeeded()
        }, completion: { _ in
            self.dismiss(animated: true, completion: nil)
        })
    }
    
}
extension MenuSelectVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.reusableCell(type: MenuSelectCell.self) else {
            return UITableViewCell()
        }
        cell.setData(menu: listData[indexPath.row])
        if listData[indexPath.row] == .SaveToFavorite {
            if itemPlay?.isFavorite == true {
                cell.imgIcon.image = UIImage(named: "starOutline")
            } else {
                cell.imgIcon.image = UIImage(named: "iconFavorite")
            }
        }
        return cell
    }
}
extension MenuSelectVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.dismiss(animated: true) {
            self.didSelectMenu?(self.listData[indexPath.row])
        }
    }
}
