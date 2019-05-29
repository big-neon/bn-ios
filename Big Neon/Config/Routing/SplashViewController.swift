

import Foundation
import UIKit
import AVKit

final class SplashViewController: UIViewController {
    
    lazy var fetcher: Fetcher = {
        let fetcher = Fetcher()
        return fetcher
    }()

    // MARK: internal is default access level - not need for explicit definition
    internal var player: AVPlayer = {
        let player = AVPlayer()
        return player
    }()
    
    override func viewDidLoad() {
        // MARK: self is not needed
        super.viewDidLoad()
        self.hideNavBar()
        self.view.backgroundColor = UIColor.white
        self.playVideo()
        self.configurePlayerObserver()
    }
    
    private func playVideo() {
        guard let path = Bundle.main.path(forResource: "splash", ofType:"mp4") else {
            debugPrint("video.m4v not found")
            return
        }
        // MARK: self is not needed
        self.player = AVPlayer(url: URL(fileURLWithPath: path))
        let playerLayer = AVPlayerLayer(player: self.player)
        playerLayer.frame = self.view.bounds
        self.view.layer.addSublayer(playerLayer)
        player.play()
        player.isMuted = true
    }
    
    deinit {
        // MARK: As of iOS 9, according to an answer below, observers are automatically removed
        // for you unless you're using block-based ones
        NotificationCenter.default.removeObserver(self)
    }
    
    private func configurePlayerObserver() {
        //MARK:  use abbreviation / syntax sugar  eg.
        // NSNotification.Name.AVPlayerItemDidPlayToEndTime can be written as just  .AVPlayerItemDidPlayToEndTime
        // MARK: self is not needed
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying),
                                               name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
                                               object: self.player.currentItem)
    }
    
    @objc internal func playerDidFinishPlaying() {
        navigateHome()
    }
    
    private func navigateHome() {
        let doorPersonVC = DoorPersonViewController(fetcher: fetcher)
        let doorPersonNavVC = UINavigationController(rootViewController: doorPersonVC)
        present(doorPersonNavVC, animated: false, completion: nil)
    }
    
}
