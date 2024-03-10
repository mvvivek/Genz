//
//  GenzVideoPlayer.swift
//  Genz
//
//  Created by Vivek MV on 10/03/24.
//

import UIKit
import AVKit
import EasyPeasy

class GenzVideoPlayer: UIView {

    public var player: AVPlayer!
    var playerLayer: AVPlayerLayer!
    var isVideoPlaying = false
    
    var lblCurrentTime: UILabel = {
        let label = UILabel()
        label.text = "00:00"
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        return label
    }()
    
    var lblDurationTime: UILabel = {
        let label = UILabel()
        label.text = "00:00"
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        return label
    }()
    
    let sliderContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    lazy var slider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 0
        slider.maximumValue = 100
        slider.addTarget(self, action: #selector(sliderValueChange(_:)), for: .valueChanged)
        return slider
    }()
        
    let activityIndicatorView: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(style: .large)
        return aiv
    }()
    
    lazy var pausePlayButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(named: "play")
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .white
        button.isHidden = false
        button.addTarget(self, action: #selector(onBtnPlay(_:)), for: .touchUpInside)
        return button
    }()
    
    let url: String
    
    init(url: String) {
        self.url = url
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("deinit called")
        NotificationCenter.default.removeObserver(self)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer.frame = self.bounds
    }
    
    func setup() {
        setupPlayer()
        setupPlayButton()
        setupSlider()
    }
    
    func setupPlayer() {
        guard let videoURL = URL(string: url) else {
            return
        }
        
        player = AVPlayer(url: videoURL)
        player.currentItem?.addObserver(self, forKeyPath: "duration", options: [.new, .initial], context: nil)
        player?.addObserver(self, forKeyPath: "currentItem.loadedTimeRanges", options: .new, context: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(playerEndPlay), name: .AVPlayerItemDidPlayToEndTime, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(playerItemFailedToPlayToEnd(_:)), name: .AVPlayerItemFailedToPlayToEndTime, object: nil)

        addTimeObserver()
        
        playerLayer = AVPlayerLayer(player: player)
        playerLayer.videoGravity = .resizeAspect
        self.layer.addSublayer(playerLayer)
    }
    
    func setupPlayButton() {
        self.addSubview(activityIndicatorView)
        activityIndicatorView.easy.layout(Center(), Size(30))

        self.addSubview(pausePlayButton)
        pausePlayButton.easy.layout(Center(), Size(30))

        let gesture = UITapGestureRecognizer(target: self, action:  #selector (self.someAction (_:)))
        self.addGestureRecognizer(gesture)
    }
    
    func setupSlider() {
        addSubview(sliderContainerView)
        sliderContainerView.easy.layout(Bottom(), Left(), Right(), Height(42))
        
        sliderContainerView.addSubview(lblCurrentTime)
        sliderContainerView.addSubview(lblDurationTime)
        sliderContainerView.addSubview(slider)

        lblCurrentTime.easy.layout(CenterY(),  Left(5))
        lblDurationTime.easy.layout(CenterY(), Right(5))
        slider.easy.layout( CenterY(), Left(5).to(lblCurrentTime), Right(5).to(lblDurationTime), Height(32))
        
        slider.addTarget(self, action: #selector(onSliderValChanged(slider:event:)), for: .valueChanged)
        slider.isUserInteractionEnabled = false
    }
    
    @objc func someAction(_ sender: UITapGestureRecognizer){
        didTapPlayPause()
    }

    @objc func playerEndPlay() {
        didTapPlayPause()
        player.seek(to: CMTime.zero)
        player.pause()
    }
    
    func didTapPlayPause() {
        if isVideoPlaying {
            player.pause()
            pausePlayButton.setImage(UIImage(named: "play"), for: .normal)
            self.pausePlayButton.isHidden = false
        } else {
            player.play()
            pausePlayButton.setImage(UIImage(named: "pause"), for: .normal)
        }
        isVideoPlaying = !isVideoPlaying

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 4) {
            if self.isVideoPlaying {
                self.pausePlayButton.isHidden = true
            }
        }
    }

    @objc func onBtnPlay(_ sender: Any) {
        if isVideoPlaying {
            player.pause()
            pausePlayButton.setImage(UIImage(named: "play"), for: .normal)
            self.pausePlayButton.isHidden = false
        } else {
            player.play()
            pausePlayButton.setImage(UIImage(named: "pause"), for: .normal)
        }
        isVideoPlaying = !isVideoPlaying

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 4) {
            if self.isVideoPlaying {
                self.pausePlayButton.isHidden = true
            }
        }
    }
}


// MARK: - OBSERVERS AND OBSERVERS METHODS


extension GenzVideoPlayer {
    func addTimeObserver() {
        let interval = CMTime(seconds: 0.5, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        let mainQueue = DispatchQueue.main
        player.addPeriodicTimeObserver(forInterval: interval, queue: mainQueue) { [weak self] time in
            guard let currentItem = self?.player.currentItem else {return}
            if self?.player.currentItem!.status == .readyToPlay {
                self?.slider.minimumValue = 0
                self?.slider.maximumValue = Float(currentItem.duration.seconds)
                self?.slider.value = Float(currentItem.currentTime().seconds)
                self?.lblCurrentTime.text = currentItem.currentTime().durationText
            }
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "duration", let duration = player.currentItem?.duration.seconds, duration > 0.0 {
            self.lblDurationTime.text = player.currentItem!.duration.durationText
        }

        if keyPath == "currentItem.loadedTimeRanges" {
            slider.isUserInteractionEnabled = true
            activityIndicatorView.stopAnimating()
        }
    }
    
    @objc func playerItemFailedToPlayToEnd(_ notification: Notification) {
        // Handle player item failed to play to end time (e.g., show error message)
        if let error = notification.userInfo?[AVPlayerItemFailedToPlayToEndTimeErrorKey] as? Error {
            print("Error: \(error.localizedDescription)")
            UIApplication.topViewController()?.view.makeToast("\(error.localizedDescription)", position: .center)
        }
    }
}


// MARK: - SLIDER METHODS


extension GenzVideoPlayer {
    @objc func sliderValueChange(_ sender: UISlider) {
        player.seek(to: CMTimeMake(value: Int64(sender.value*1000), timescale: 1000))
    }
    
    @objc func onSliderValChanged(slider: UISlider, event: UIEvent) {
        if let touchEvent = event.allTouches?.first {
            switch touchEvent.phase {
            case .began:
                player.pause()
                break
            case .moved:
                break
            case .ended:
                if isVideoPlaying {
                    player.play()
                    self.pausePlayButton.isHidden = true
                } else {
                    player.pause()
                    self.pausePlayButton.isHidden = false
                }
                break
            default:
                break
            }
        }
    }
}
