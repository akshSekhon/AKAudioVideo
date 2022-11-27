//
//  VideoPlayer.swift
//  MetalPetelDummy
//
//  Created by Mobile on 12/07/22.
//

import UIKit
import AVKit


class MyPlayer:NSObject{
    static let share = MyPlayer()
    var player: AVPlayer? = AVPlayer()
    var playerIsPlay = false
    var playEnd = true
    var avCntrlr:AVPlayerViewController? = AVPlayerViewController()
    var playerLayer:AVPlayerLayer?
     //self().player?.currentTime() ?? CMTimeMake(value: 1, timescale: 20)

    func addPlayerToView(_ view: UIView) {
         playerLayer = AVPlayerLayer(player: player)
//        playerLayer.frame = view.bounds
//        playerLayer?.videoGravity = .resizeAspect
//        view.layer.addSublayer(playerLayer)
       
        avCntrlr?.videoGravity = .resizeAspectFill
        avCntrlr?.player = player
        avCntrlr?.showsPlaybackControls = false
//        playerLayer?.needsDisplayOnBoundsChange = true
        
//        view.layer.addSublayer(playerLayer!)
//        DispatchQueue.main.async { [self] in
//            let vF = view.frame
//            playerLayer?.frame = view.bounds//CGRectMake(view.center.x,view.center.y, view.bounds.width, view.bounds.height)
//            playerLayer?.videoGravity = .resize
////            CGRect(origin: .zero, size: CGSize(width: vF.width, height: vF.height - 5))
//            player?.play()
//        }
//        avCntrlr?.view.frame = view.bounds
        UIApplication.visibleViewController.addChild(avCntrlr!)

        view.addSubview((avCntrlr?.view)!)
        avCntrlr?.view.layout{
            $0.top.equal(to: view.topAnchor,offsetBy: 5)
            $0.leading.equal(to: view.leadingAnchor)
            $0.trailing.equal(to: view.trailingAnchor)
            $0.bottom.equal(to: view.bottomAnchor,offsetBy: -5)
        }
        
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(durationChange), name: .AVAssetDurationDidChange, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(playerEndPlay), name: .AVPlayerItemDidPlayToEndTime, object: nil)
    }
    
//     init(_ baseView:UIView) {
//         super.init()
//        addPlayerToView(baseView)
//    }
//    deinit{
//        player = nil
//    }
    
    func playVideoWithFileName(_ fileName: String, ofType type:String) {
        guard let filePath = Bundle.main.path(forResource: fileName, ofType: type) else { return }
        let videoURL = URL(fileURLWithPath: filePath)
        let playerItem = AVPlayerItem(url: videoURL)
        player?.replaceCurrentItem(with: playerItem)
        player?.play()
    }
    func playVideoWithUrl(_ fileUrl: URL) {
        if fileUrl != nil{
            print(fileUrl)
            let playerItem = AVPlayerItem(url: fileUrl)
            player?.replaceCurrentItem(with: playerItem)
            player?.play()
            playerIsPlay = true
        }
        
    }
    func playVideoWithAsset(_ playItem: AVPlayerItem) {
        print(playItem)
        player?.replaceCurrentItem(with: playItem)
        player?.play()
        playerIsPlay = true
    }
    
    func playPause(){
        if playerIsPlay{
            player?.pause()
            playerIsPlay = false
        }
        else{
            player?.play()
            playerIsPlay = true
        }
    }
    @objc func playerEndPlay() {
        playEnd = true
        repeatPlay()
    }
    @objc func durationChange() {
        playEnd = true
        repeatPlay()
    }
    
    func repeatPlay(){
        player?.seek(to: CMTime.zero)
        
        player?.play()
        
    }
    
}
