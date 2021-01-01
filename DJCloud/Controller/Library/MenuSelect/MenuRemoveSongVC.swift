//
//  MenuSelectSongVC.swift
//  DJCloud
//
//  Created by kien on 9/14/20.
//  Copyright © 2020 kienpt. All rights reserved.
//

import UIKit

enum TypeRemoveMenu {
    case FromLibrary
    case FromDownload
}

class MenuRemoveSongVC: BasePicker {
    
    @IBOutlet weak var dimView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var viewRemoveDownload: RoundedView!
    @IBOutlet weak var viewRemoveLibrary: RoundedView!
    
    @IBOutlet var pickerViewBottomConstraint: NSLayoutConstraint!

    
    // MARK: - Variables
    private var safeAreaInsetsBottom: CGFloat {
        if #available(iOS 11.0, *) {
            if let safeAreaInsetBottom = UIApplication.shared.keyWindow?.safeAreaInsets.bottom {
                return safeAreaInsetBottom
            }
        }
        return 0
    }
    var typeSelect: TypeRemoveMenu?
    
    var didSelectMenu: ((TypeRemoveMenu?)->Void)?
    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGestureRecognizers()
    }
    
    private func setupGestureRecognizers() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureAction(gesture:)))
        dimView.addGestureRecognizer(tapGesture)
        
        let tapRemoveDownload = UITapGestureRecognizer(target: self, action: #selector(tapRemoveDownLoadAction(gesture:)))
        viewRemoveDownload.addGestureRecognizer(tapRemoveDownload)
        let tapRemoveLibrary = UITapGestureRecognizer(target: self, action: #selector(tapRemoveLibraryAction(gesture:)))
        viewRemoveLibrary.addGestureRecognizer(tapRemoveLibrary)
    }
    
    @objc func tapGestureAction(gesture: UITapGestureRecognizer) {
        cancelPickerView()
    }
    
    @objc func tapRemoveDownLoadAction(gesture: UITapGestureRecognizer) {
        typeSelect = .FromDownload
        cancelPickerView()
    }
    
    @objc func tapRemoveLibraryAction(gesture: UITapGestureRecognizer) {
        typeSelect = .FromLibrary
        cancelPickerView()
    }
    
  
    private func cancelPickerView() {
        self.dismiss(animated: false, completion: { [weak self] in
            self?.didSelectMenu?(self?.typeSelect)
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        showWithAnimation()
    }
    
    // MARK: - Setup
    private func setupView() {
        //UI
        view.backgroundColor = .clear
        view.isOpaque = false
        let bottomValue = -containerView.bounds.height - safeAreaInsetsBottom
        pickerViewBottomConstraint.constant = bottomValue
        dimView.alpha = 0
        
        // Config animation
        configWhenShow = { [weak self] in
            self?.pickerViewBottomConstraint.constant = 0
            self?.dimView.alpha = 0.5
        }
        
        configWhenHide = { [weak self] in
            guard let sSelf = self else { return }
            let bottomValue = -sSelf.containerView.bounds.height - sSelf.safeAreaInsetsBottom
            sSelf.pickerViewBottomConstraint.constant = bottomValue
            sSelf.dimView.alpha = 0
        }
    }

    @IBAction func actionCanel(_ sender: Any) {
        typeSelect = nil
        cancelPickerView()
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
