//
//  UITableViewHeaderFooterView+Extension.swift
//  iOS Structure MVC
//
//  Created by kien on 2/19/19.
//  Copyright © 2019 kien. All rights reserved.
//

import UIKit

// MARK: - UITableHeaderFooterView
protocol XibTableHeaderFooterView {
    static var name: String { get }
    static func registerHeaderFooterTo(tableView: UITableView)
    static func reusableHeaderFooterFor(tableView: UITableView) -> Self?
}

extension XibTableHeaderFooterView where Self: UITableViewHeaderFooterView {
    static var name: String {
        return String(describing: self).components(separatedBy: ".").last ?? ""
    }
    
    static func registerHeaderFooterTo(tableView: UITableView) {
        tableView.register(Self.self, forHeaderFooterViewReuseIdentifier: name)
    }
    
    static func reusableHeaderFooterFor(tableView: UITableView) -> Self? {
        return tableView.dequeueReusableHeaderFooterView(withIdentifier: name) as? Self
    }
}

extension UITableViewHeaderFooterView: XibTableHeaderFooterView { }
