//
//  HomeVC.swift
//  DJCloud
//
//  Created by kien on 9/13/20.
//  Copyright © 2020 kienpt. All rights reserved.
//

import UIKit
import TYCyclePagerView

class HomeVC: UIViewController {

    @IBOutlet weak var viewCategoryPopular: UIView!
    @IBOutlet weak var topPageView: TYCyclePagerView!
    @IBOutlet weak var topPageControl: UIPageControl!
    @IBOutlet weak var viewNewSong: UIView!
    @IBOutlet weak var viewSongToday: UIView!
    @IBOutlet weak var viewTopDJCloud: UIView!
    @IBOutlet weak var viewTop20: UIView!
    @IBOutlet weak var viewSuggestForYou: UIView!
    @IBOutlet weak var viewBgNavigation: RoundedView!
    @IBOutlet weak var imgAvatar: CircularImageView!
    @IBOutlet weak var btnCloseSearch: UIButton!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var imgAvatarUser: CircularImageView!
    @IBOutlet weak var btnOpenPersonal: UIButton!
    
    
    @IBOutlet weak var heightViewSuggestForYou: NSLayoutConstraint!
    @IBOutlet weak var constraintHeightViewSongNew: NSLayoutConstraint!
    @IBOutlet weak var constraintHeightViewTopArtist: NSLayoutConstraint!
    @IBOutlet weak var constraintHeightViewTopSong: NSLayoutConstraint!
    @IBOutlet weak var constraintHeightViewGenres: NSLayoutConstraint!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private var searchResultView: SearchResultView?
    let newSongVC = NewSongVC.create()
    let todayVC = NewSongVC.create()
    let popularVC = PopularVC.create()
    let top20VC = NewSongVC.create()
    let topDJClouderVC = TopDJClouderVC.create()
    let suggestForYouVC = SuggestForYouVC.create()
    let widthPage = ScreenUtils.screenWidth - 16 * 2
    private var timer: Timer?
    private var isSearch = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(updateAvatarUser), name: NSNotification.Name.init("UpdateAvatar"), object: nil)
        self.btnCloseSearch.isEnabled = false
        self.btnOpenPersonal.isHidden = false
        viewBgNavigation.setNeedsDisplay()
        setupPagerView()
        setUpTextFieldSearch()
        
        self.addChild(newSongVC)
        todayVC.typeMainHome = .new
        newSongVC.didMove(toParent: self)
        viewNewSong.addSubview(newSongVC.view)
        newSongVC.view.fitTo(superView: viewNewSong)
        newSongVC.didLoadData = {[weak self] (status) in
            self?.constraintHeightViewSongNew.constant = status ? 190 : 0
            self?.viewNewSong.isHidden = !status
        }
        
        
        self.addChild(todayVC)
        todayVC.typeMainHome = .today
        todayVC.didMove(toParent: self)
        viewSongToday.addSubview(todayVC.view)
        todayVC.view.fitTo(superView: viewSongToday)
        
        
        self.addChild(popularVC)
        popularVC.didMove(toParent: self)
        viewCategoryPopular.addSubview(popularVC.view)
        popularVC.view.fitTo(superView: viewCategoryPopular)
        popularVC.didLoadData = {[weak self] (status) in
            self?.constraintHeightViewGenres.constant = status ? 100 : 0
            self?.viewCategoryPopular.isHidden = !status
        }
        
        self.addChild(topDJClouderVC)
        topDJClouderVC.didMove(toParent: self)
        viewTopDJCloud.addSubview(topDJClouderVC.view)
        topDJClouderVC.view.fitTo(superView: viewTopDJCloud)
        topDJClouderVC.didLoadData = {[weak self] (status) in
            self?.constraintHeightViewTopArtist.constant = status ? 100 : 0
            self?.viewTopDJCloud.isHidden = !status
        }
        
        self.addChild(top20VC)
        top20VC.typeMainHome = .top20
        top20VC.didMove(toParent: self)
        viewTop20.addSubview(top20VC.view)
        top20VC.view.fitTo(superView: viewTop20)
        top20VC.didLoadData = {[weak self] (status) in
            self?.constraintHeightViewTopSong.constant = status ? 190 : 0
            self?.viewTop20.isHidden = !status
        }
        
        self.addChild(suggestForYouVC)
        suggestForYouVC.didMove(toParent: self)
        viewSuggestForYou.addSubview(suggestForYouVC.view)
        suggestForYouVC.view.fitTo(superView: viewSuggestForYou)
        suggestForYouVC.didChangeHeight = {[weak self] (height) in
            self?.heightViewSuggestForYou.constant = height
        }
    }
    
    private func setupPagerView() {
        topPageView.dataSource = self
        topPageView.delegate = self
        
        topPageView.isInfiniteLoop = true
        topPageView.autoScrollInterval = 3.0
        topPageView.layout.layoutType = TYCyclePagerTransformLayoutType(rawValue: UInt(1))!
        topPageView.register(UINib(nibName: "SliderPageSongCell", bundle: nil), forCellWithReuseIdentifier: "SliderPageSongCell")
        topPageView.setNeedUpdateLayout()
        topPageView.updateData()
        
        topPageControl.numberOfPages = 6
    }
    
    private func setUpTextFieldSearch() {
        searchTextField.delegate = self
        searchTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
//        searchTextField.tintColor = .pointerTextFieldColor
//        if let cate = categoryType?.value {
//            searchTextField.placeholder = "Tìm nội dung " + cate
//        }
    }
    
    @objc private func updateAvatarUser() {
        if let image = AppDelegate.shared?.user?.imgAvatar {
            imgAvatar.image = image
        } else {
            imgAvatar.image = UIImage(named: "default_avatar")
        }
    }
    
    @IBAction func actionCloseSearch(_ sender: Any) {
        hideSearchAnimation()
        view.endEditing(true)
    }
    
    @IBAction func openPersonalTab() {
        NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "OpenPersonalTab"), object: nil, userInfo: nil)
    }
}

// MARK: - UITextFieldDelegate
extension HomeVC: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        addSearchResultView()
        return true
    }

    @objc func textFieldDidChange(_ textField: UITextField) {
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(doSearch), userInfo: nil, repeats: false)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if searchTextField.text?.count ?? 0 > 3 {
            searchResultView?.typeSearch = .result
            searchResultView?.searchText = searchTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            self.view.endEditing(true)
        }
        return true
    }
    
    @objc func doSearch() {
        searchResultView?.typeSearch = .suggest
        searchResultView?.searchText = searchTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    // animate with search text field
    private func addSearchResultView() {
        if searchResultView != nil { return }
        searchResultView = SearchResultView(frame: CGRect(x: 0,
                                                          y: viewBgNavigation.frame.maxY,
                                                          width: ScreenUtils.screenWidth,
                                                          height: ScreenUtils.screenHeight - viewBgNavigation.frame.maxY))
        searchResultView?.typeSearch = .history
        searchResultView?.delegate = self
        searchResultView?.didSelectSong = {[weak self] (song) in
            self?.playSong(song: song)
            self?.hideSearchAnimation()
        }
        searchResultView?.alpha = 0
        view.addSubview(searchResultView!)
        searchResultView?.typeSearch = .history
        showSearchAnimation()
    }
    
    private func playSong(song: PlayableItem) {
        let vc = MusicPlayVC()
        vc.playableList = [song]
//        vc.audioPlayer.play(item: listData[indexPath.row])
        vc.popupBar.progressView.progressTintColor = UIColor.appColor(.ColorTintApp)
        tabBarController?.presentPopupBar(withContentViewController: vc, animated: true, completion: nil)
        tabBarController?.popupBar.imageView.layer.cornerRadius = 3
        tabBarController?.popupBar.progressViewStyle = .top
    }
    
    private func showSearchAnimation() {
        view.layoutIfNeeded()
        UIView.animate(withDuration: 0.2, animations: {
            self.isSearch = true
            self.btnCloseSearch.alpha = 1
            self.imgAvatar.alpha = 0
            self.searchResultView?.alpha = 1
            self.view.layoutIfNeeded()
        }) { (_) in
            self.btnCloseSearch.isEnabled = true
            self.btnOpenPersonal.isHidden = true
        }
    }
    
    private func hideSearchAnimation() {
        view.layoutIfNeeded()
        UIView.animate(withDuration: 0.2, animations: {
            self.isSearch = false
            self.searchResultView?.alpha = 0
            self.imgAvatar.alpha = 1
            self.btnCloseSearch.alpha = 0
            self.searchTextField.resignFirstResponder()
            self.searchTextField.text = nil
            self.view.layoutIfNeeded()
        }) { (_) in
            self.searchResultView?.removeFromSuperview()
            self.searchResultView = nil
            self.btnCloseSearch.isEnabled = false
            self.btnOpenPersonal.isHidden = false
        }
    }
}

extension HomeVC: TYCyclePagerViewDelegate, TYCyclePagerViewDataSource {
    
    func numberOfItems(in pageView: TYCyclePagerView) -> Int {
        return 6
    }
    
    func pagerView(_ pagerView: TYCyclePagerView, cellForItemAt index: Int) -> UICollectionViewCell {
        guard let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "SliderPageSongCell", for: index) as? SliderPageSongCell else { return UICollectionViewCell() }
        cell.imgImage.image = UIImage(named: "image2")
        cell.lbTitle.text = "I Won't Fall"
        cell.lbSubTitle.text = "SNOW LAB ft. Nicole Gray & Ke..."
        return cell
    }
    
    func layout(for pageView: TYCyclePagerView) -> TYCyclePagerViewLayout {
        let layout = TYCyclePagerViewLayout()
        layout.itemSize = CGSize(width: widthPage, height: widthPage * 184 / 344)
        layout.itemSpacing = 5
        layout.itemHorizontalCenter = true
        return layout
    }
    
    func pagerView(_ pageView: TYCyclePagerView, didSelectedItemCell cell: UICollectionViewCell, at index: Int) {
        
    }
    
    func pagerView(_ pageView: TYCyclePagerView, didScrollFrom fromIndex: Int, to toIndex: Int) {
        self.topPageControl.currentPage = toIndex
    }
}
extension HomeVC: SearchResultViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < 0, !searchTextField.isFirstResponder {
            searchTextField.becomeFirstResponder()
        } else if scrollView.contentOffset.y > 10, searchTextField.isFirstResponder {
            searchTextField.resignFirstResponder()
        }
    }
}
