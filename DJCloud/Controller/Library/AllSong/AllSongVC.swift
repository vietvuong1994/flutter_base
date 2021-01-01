//
//  AllSongVC.swift
//  DJCloud
//
//  Created by kien on 9/13/20.
//  Copyright © 2020 kienpt. All rights reserved.
//

import UIKit

class AllSongVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewAlphabet: BaseTableView!
    
    @IBOutlet weak var constraintHeightAlphabet: NSLayoutConstraint!
    
    private var listAlphabet: [String] = ["#","A","B","C","D","E","F","G","H","I","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
    }
    
    private func setUpTableView() {
        tableView.tableHeaderView = AdBannerView(frame: CGRect(x: 0, y: 0, width: ScreenUtils.screenWidth, height: 56))
        tableView.registerNibCellFor(type: SongListCell.self)
        tableView.dataSource = self
        tableView.delegate = self
        
        tableViewAlphabet.dataSource = self
        tableViewAlphabet.delegate = self
        tableViewAlphabet.didChangeContentSize = {[weak self] (size) in
            self?.constraintHeightAlphabet.constant = size.height
        }
    }
}
extension AllSongVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView === tableViewAlphabet {
            return listAlphabet.count
        }
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView === tableViewAlphabet {
            let cell = UITableViewCell()
            cell.selectionStyle = .none
            cell.contentView.backgroundColor = UIColor.clear
            cell.backgroundColor = UIColor.clear
            cell.textLabel?.text = listAlphabet[indexPath.row]
            cell.textLabel?.textColor = UIColor(displayP3Red: 152, green: 151, blue: 158, alpha: 1)
            cell.textLabel?.font = UIFont.systemFont(ofSize: 9)
            return cell
        } else {
            guard let cell = tableView.reusableCell(type: SongListCell.self) else {
                return UITableViewCell()
            }
            return cell
        }
    }
    
    private func showDeleteMenu() {
        MenuRemoveSongVC.present(from: self, animated: false, prepare: { picker in
            picker.modalPresentationStyle = .overFullScreen
            
        })
    }
}
extension AllSongVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView === tableViewAlphabet {
            return 14
        }
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView === tableViewAlphabet {
            
        } else {
           
        }
    }
}
