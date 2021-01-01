//
//  CreatePlayListVC.swift
//  DJCloud
//
//  Created by kien on 9/14/20.
//  Copyright © 2020 kienpt. All rights reserved.
//

import UIKit

class CreatePlayListVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var listData: [String] = ["One", "Two", "Three", "Four", "Five"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
    }
    
    private func setUpTableView() {
        tableView.registerNibHeaderFooterFor(type: CreatePlayListInfoHeaderView.self)
        tableView.registerNibCellFor(type: SongPlayListCell.self)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.isEditing = true
    }

    @IBAction func actionCancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func actionDone(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
extension CreatePlayListVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.reusableCell(type: SongPlayListCell.self) else {
            return UITableViewCell()
        }
        if #available(iOS 13.0, *) {
            cell.overrideUserInterfaceStyle = .dark
        } else {
            // Fallback on earlier versions
        }
        return cell
        
    }
}
extension CreatePlayListVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.reusableHeaderFooterFor(type: CreatePlayListInfoHeaderView.self)
        header?.didSelectAddSong = {[weak self] in
            SearchVC.present(from: self, animated: true, prepare: { (vc) in
                vc.modalTransitionStyle = .crossDissolve
                vc.modalPresentationStyle = .overFullScreen
            }, completion: nil)
        }
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 184
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let item = listData[sourceIndexPath.row]
        listData.remove(at: sourceIndexPath.row)
        listData.insert(item, at: destinationIndexPath.row)
    }
        
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
    }

    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .normal, title:  "", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            // Call edit action

            // Reset state
            success(true)
        })
        deleteAction.image = UIImage(named: "iconTrash")
        deleteAction.backgroundColor = .red
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}
