//
//  MusicPlayVC.swift
//  DJCloud
//
//  Created by kien on 10/25/20.
//  Copyright © 2020 kienpt. All rights reserved.
//

import UIKit
import MaterialComponents.MaterialSlider
import RxCocoa
import RxSwift
import LNPopupController

class MusicPlayVC: UIViewController {

    @IBOutlet weak var progressContainer: UIView!
    @IBOutlet weak var progressPassedView: UILabel!
    @IBOutlet weak var durationView: UILabel!
    @IBOutlet weak var tableViewPlayNext: BaseTableView!
    @IBOutlet weak var playPauseStopButton: UIButton!
    @IBOutlet weak var imgThumbCurrentPlay: UIImageView!
    @IBOutlet weak var lbTitleCurrent: UILabel!
    @IBOutlet weak var viewHeaderSongNext: UIView!
    @IBOutlet weak var lbSubTitleCurrent: UILabel!
    @IBOutlet weak var popupCloseButton: LNPopupCloseButton!
    @IBOutlet weak var vibrancyView: RoundedView!
    @IBOutlet weak var lbFavoriteCount: UILabel!
    @IBOutlet weak var lbCommentCount: UILabel!
    
    @IBOutlet weak var constraintHeightTabelView: NSLayoutConstraint!

    private var playPausePopUpButton: UIBarButtonItem?
    private var nextPopUpButton: UIBarButtonItem?
    private lazy var progressBarView: MDCSlider = {
        let progressBar = MDCSlider()
        progressBar.color = UIColor.appColor(.ColorTintApp)
        progressBar.addTarget(self, action: #selector(self.onProgressBarValueChanged(slider:event:)), for: .valueChanged)
        progressBar.maximumValue = 100.0
        progressBar.isContinuous = false
        progressBar.isThumbHollowAtStart = false
        return progressBar
    }()
    
    private let disposeBag = DisposeBag()
    private let audioPlayer = AudioPlayer.shared;
    private var currentItem = BehaviorRelay<PlayableItem?>(value: nil)
    private var currentItemImage = BehaviorRelay<UIImage?>(value: nil)
    private var currentItemDuration = BehaviorRelay<TimeInterval?>(value: nil)
    private var currentItemProgression = BehaviorRelay<TimeInterval?>(value: nil)
    private var audioPlayerState = BehaviorRelay<AudioPlayerState?>(value: AudioPlayerState.playing)
    
    var playableList: [PlayableItem] = []
    var indexPlay = 0
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        progressContainer.addSubview(progressBarView)
        progressBarView.fitTo(superView: progressContainer)
        setUpTableView()
        
        setupObservers()
        
        audioPlayer.delegate = self
        
        if(self.audioPlayer.queue != nil) {
            self.audioPlayer.stop()
//            self.playableList = self.audioPlayer.queue!.items
        }
        tableViewPlayNext.reloadData()
        let pause = UIBarButtonItem(image: UIImage(named: "iconPauseGray"), style: .plain, target: self, action: #selector(onPlayPause))
        let next = UIBarButtonItem(image: UIImage(named: "iconNext"), style: .plain, target: nil, action: nil)
        playPausePopUpButton = pause
        popupItem.barButtonItems = [ pause, next ]
        
        setUpNotificationObserver()
        getUrlSongPlay()
    }
    
    private func updateDataUI() {
        self.currentItem.accept(self.audioPlayer.currentItem)
        imgThumbCurrentPlay.loadImage(url: URL(string: self.audioPlayer.currentItem?.imageUrl ?? ""))
        lbTitleCurrent.text = self.audioPlayer.currentItem?.title
        lbSubTitleCurrent.text = self.audioPlayer.currentItem?.artist
        lbFavoriteCount.text = self.audioPlayer.currentItem?.viewCount?.formatPoints()
        lbCommentCount.text = self.audioPlayer.currentItem?.avgRating?.formatPoints()
        popupItem.image = imgThumbCurrentPlay.image
        popupItem.title = self.audioPlayer.currentItem?.title
        popupItem.subtitle = self.audioPlayer.currentItem?.artist
    }
    
    private func getUrlSongPlay() {
        if playableList.count > 0 {
            guard let slug = playableList[indexPlay].slug else {
                return
            }
            GetLinkSongFileAPI.init(slug: slug).showIndicator(false).execute(target: self) { (response) in
                self.playableList[self.indexPlay].url = response.url
                self.audioPlayer.play(item: self.playableList[self.indexPlay])
                self.updateDataUI()
            } failure: { (error) in
                
            }
        }
    }
    
    private func setUpNotificationObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.onStopAndClearPlayers(_:)), name: Notification.Name(rawValue: Constants.audioPlayerStopAndClearPlayersBroadcastNotificationKey), object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(self.audioPlayerWillStartPlaying(_:)), name: Notification.Name(rawValue: AudioPlayer.Notifications.willStartPlayingItem), object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(self.audioPlayerDidChangeState(_:)), name: Notification.Name(rawValue: AudioPlayer.Notifications.didChangeState), object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(self.onPlaybackProgression), name: Notification.Name(rawValue: AudioPlayer.Notifications.didProgressTo), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // set the progress slider before page is shown to the user
        if(self.audioPlayer.currentItem != nil) {
            let itemDuration = self.audioPlayer.currentItemDuration ?? 0;
            let itemProgression = self.audioPlayer.currentItemProgression ?? 0;
            let percentage = (itemDuration > 0 ? CGFloat(itemProgression / itemDuration) * 100 : 0)

            self.progressPassedView.text = format(duration: itemProgression);
            self.progressBarView.value = percentage;
            popupItem.progress = Float(percentage / 100)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    
    func setupObservers() {
        self.setupAudioPlayerStateObserver()
        self.setupCurrentAudioItemObserver()
        self.setupCurrentAudioItemDurationObserver()
        self.setupCurrentAudioItemProgressionObserver()
        self.setupCurrentAudioItemImage()
    }
    
    func setupAudioPlayerStateObserver() {
        self.audioPlayerState.observeOn(MainScheduler.instance)
            .subscribeOn(MainScheduler.instance)
            .asObservable()
            .subscribe(onNext: { audioPlayerState in
                if(audioPlayerState == AudioPlayerState.paused) {
                    self.playPauseStopButton.setImage(UIImage(named: "iconPlayGray"), for: .normal)
                    self.playPausePopUpButton?.image = UIImage(named: "iconPlayGray")
                } else if(audioPlayerState == AudioPlayerState.playing) {
                    self.playPauseStopButton.setImage(UIImage(named: "iconPauseGray"), for: .normal)
                    self.playPausePopUpButton?.image = UIImage(named: "iconPauseGray")
                }
            }).disposed(by: self.disposeBag)
    }
    
    func setupCurrentAudioItemObserver() {
        self.currentItem.observeOn(MainScheduler.instance)
            .subscribeOn(MainScheduler.instance)
            .asObservable()
            .subscribe(onNext: { currentItem in
                if(currentItem == nil) {
                    return
                }
//                self.titleView.text = currentItem!.title;
//                self.artistView.text = currentItem!.artist;
                
//                self.loadImageToArtworkViewAndPlayableItem(imageUrl: currentItem!.imageUrl);
                
                self.progressBarView.value = 0
                self.popupItem.progress = 0
                self.progressPassedView.text = format(duration: self.audioPlayer.currentItemProgression ?? 0)
                self.durationView.text = format(duration: self.audioPlayer.currentItemDuration ?? 0)
                
//                self.chevronDownIcon?.setIcon(color: currentItem!.colors.accentColor, forState: .normal);
                if(currentItem!.imageUrl != nil) {
//                    self.setupCurrentAudioItemImage(imageUrl: currentItem!.imageUrl!);
                }
//                self.setupColorsForUIElements(currentItem: currentItem!);
            })
            .disposed(by: self.disposeBag)
    }
    
    func setupCurrentAudioItemProgressionObserver() {
        self.currentItemProgression.observeOn(MainScheduler.instance)
            .subscribeOn(MainScheduler.instance)
            .asObservable()
            .subscribe(onNext: { currentItemProgression in
                if(currentItemProgression == nil) {
                    return
                }
                let itemDuration = self.currentItemDuration.value ?? 0
                self.currentItemDuration.accept(self.audioPlayer.currentItemDuration)
                let percentage = (itemDuration > 0 ? CGFloat(currentItemProgression! / itemDuration) * 100 : 0)
                self.progressPassedView.text = format(duration: currentItemProgression!)
                
                if(percentage > 0.0 && !self.progressBarView.isTracking) {
                    self.progressBarView.value = percentage;
                    self.popupItem.progress = Float(percentage / 100)
                }
            }).disposed(by: self.disposeBag)
    }
    
    func setupCurrentAudioItemDurationObserver() {
        self.currentItemDuration.observeOn(MainScheduler.instance)
            .subscribeOn(MainScheduler.instance)
            .asObservable()
            .subscribe(onNext: { currentItemDuration in
                if(currentItemDuration == nil) {
                    return
                }
                
                self.durationView.text = format(duration: currentItemDuration!)
            }).disposed(by: self.disposeBag)
    }
    
    func setupCurrentAudioItemImage() {
        self.currentItemImage.asObservable()
            .subscribe(onNext: { currentItemImage in
                if(currentItemImage == nil) {
                    return
                }
//                self.artworkView.image = currentItemImage
                let whiteAndAccentContrastRatio = UIColor.white.contrastRatio(with: self.audioPlayer.currentItem!.colors.accentColor)
                let blackAndAccentContrastRatio = UIColor.black.contrastRatio(with: self.audioPlayer.currentItem!.colors.accentColor)

                if(whiteAndAccentContrastRatio > blackAndAccentContrastRatio) {
                    // white is more suitable
//                    self.progressBarView.maximumTrackTintColor = .white;
//                    self.mpVolumeSlider.maximumTrackTintColor = UIColor.white;
                } else {
                    // black is more suitable
//                    self.progressBarView.maximumTrackTintColor = .black;
//                    self.mpVolumeSlider.maximumTrackTintColor = UIColor.black;
                }

                if(Constants.COLORED_PLAYER) {
//                    if(self.backgroundBlurredImageView.image != nil) {
//                        self.updateBackgroundForMusicPlayer();
//                    } else {
//                        self.setBackgroundForMusicPlayer();
//                    }
                }
            }).disposed(by: self.disposeBag)
    }
    
    
    func setupCurrentAudioItemImage(imageUrl: String) {
//        KingfisherManager.shared.retrieveImage(with: ImageResource(downloadURL: URL.createFrom(localOrRemoteAddress: imageUrl)), options: nil, progressBlock: nil) { (image, error, cacheType, imageURL) -> () in
//            self.currentItemImage.accept(image);
//        };
    }
    
    private func setUpTableView() {
        tableViewPlayNext.dataSource = self
        tableViewPlayNext.delegate = self
        tableViewPlayNext.registerNibCellFor(type: SongListCell.self)
        tableViewPlayNext.didChangeContentSize = {[weak self] (size) in
            self?.constraintHeightTabelView.constant = size.height
        }
    }
    
    @objc func onProgressBarValueChanged(slider: MDCSlider, event: UIEvent) {
        let value = slider.value
        let alreadyPaused = self.audioPlayer.state == .paused ? true : false
        // pause the player to avoid ui glitches
        self.audioPlayer.pause()
        // the value coming from the slider is in percentage, convert it to seconds according to the item duration
        let time = Int(value * CGFloat(self.audioPlayer.currentItemDuration ?? 0) / 100)
        self.audioPlayer.seek(to: TimeInterval(time))
        if(!alreadyPaused) {
            self.audioPlayer.resume()
        }
    }
    
    @objc
    func onStopAndClearPlayers(_ notification: Notification) {
        self.dismiss(animated: true, completion: nil);
    }
    
    @objc
    func audioPlayerWillStartPlaying(_ notification: Notification) {
        self.currentItemDuration.accept(self.audioPlayer.currentItemDuration);
        self.currentItem.accept(self.audioPlayer.currentItem);
    }
    
    @objc
    func audioPlayerDidChangeState(_ notification: Notification) {
        self.audioPlayerState.accept(self.audioPlayer.state);
    }
    
    @objc
    func onPlaybackProgression() {
        self.currentItemProgression.accept(self.audioPlayer.currentItemProgression);
    }

    @objc func onPlayPause() {
        if(self.audioPlayer.state == AudioPlayerState.paused) {
            self.audioPlayer.resume()
        } else if(self.audioPlayer.state == AudioPlayerState.playing || self.audioPlayer.state == AudioPlayerState.buffering) {
            self.audioPlayer.pause()
        }
    }
    
    // MARK: - Action
    @IBAction func actionPlayPause(_ sender: Any) {
        onPlayPause()
    }
}
extension MusicPlayVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playableList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.reusableCell(type: SongListCell.self, indexPath: indexPath) else {
            return UITableViewCell()
        }
        cell.setData(item: playableList[indexPath.row])
        cell.didSelectMoreMenu = {[weak self] in
            guard let `self` = self else { return }
            MenuSelectVC.present(from: self, animated: true, prepare: { (vc) in
                vc.modalTransitionStyle = .coverVertical
                vc.modalPresentationStyle = .overFullScreen
                vc.listData = [.SaveToFavorite, .Report]
                vc.itemPlay = self.playableList[indexPath.row]
            }, completion: nil)
        }
        return cell
    }
}
extension MusicPlayVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.audioPlayer.play(item: self.playableList[indexPath.row])
    }
}
extension MusicPlayVC: AudioPlayerDelegate {
    
}
