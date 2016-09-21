//
//  StartViewController.swift
//  视频起始页
//
//  Created by 侯宝伟 on 16/9/9.
//  Copyright © 2016年 ZHUNJIEE. All rights reserved.
//

import UIKit
import MediaPlayer

class StartViewController: UIViewController, UIScrollViewDelegate {
    // 屏幕宽高
    let ScreenWidth = Singleton.sharedInstance.ScreenWidth
    let ScreenHeight = Singleton.sharedInstance.ScreenHeight
    // scrollView懒加载
    lazy var scrollView: UIScrollView = {
        
        let scrollView = UIScrollView(frame: CGRectMake(0, -20, self.view.frame.size.width, self.view.frame.size.height + 20))
        /**
         枚举类型的多选
         */
        scrollView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        
        scrollView.contentSize = CGSizeMake(self.view.frame.size.width * 3, self.view.frame.size.height)
        scrollView.backgroundColor = UIColor.clearColor()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.bounces = false
        scrollView.pagingEnabled = true
        
        return scrollView
    }()
    
    var lastIndex: CGFloat = 0
    
    var avPlayer1 = AVPlayer()
    var avPlayer2 = AVPlayer()
    var avPlayer3 = AVPlayer()
    var pagecontrol = UIPageControl()
    

    // 登录、注册按钮
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 创建添加滚动视图
        self.view.addSubview(scrollView)
        scrollView.delegate = self
        
        // 将按钮移到最上面
        self.view.bringSubviewToFront(registerButton)
        self.view.bringSubviewToFront(loginButton)
        registerButton.layer.cornerRadius = 10
        loginButton.layer.cornerRadius = registerButton.layer.cornerRadius
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, withOptions: .MixWithOthers)
        } catch {
            print("设置视频播放模式失败")
        }
        
        let movieUrl1 = NSURL.fileURLWithPath(NSBundle.mainBundle().pathForResource("1", ofType: "m4v")!)
        let movieUrl2 = NSURL.fileURLWithPath(NSBundle.mainBundle().pathForResource("2", ofType: "m4v")!)
        let movieUrl3 = NSURL.fileURLWithPath(NSBundle.mainBundle().pathForResource("3", ofType: "m4v")!)
        
        let asset1 = AVURLAsset(URL: movieUrl1, options: nil)
        let asset2 = AVURLAsset(URL: movieUrl2, options: nil)
        let asset3 = AVURLAsset(URL: movieUrl3, options: nil)
        
        let playerItem1 = AVPlayerItem(asset: asset1)
        let playerItem2 = AVPlayerItem(asset: asset2)
        let playerItem3 = AVPlayerItem(asset: asset3)
        
        avPlayer1 = AVPlayer(playerItem: playerItem1)
        avPlayer2 = AVPlayer(playerItem: playerItem2)
        avPlayer3 = AVPlayer(playerItem: playerItem3)
        
        let avPlayerLayer1 = AVPlayerLayer(player: avPlayer1)
        let avPlayerLayer2 = AVPlayerLayer(player: avPlayer2)
        let avPlayerLayer3 = AVPlayerLayer(player: avPlayer3)
        
        avPlayerLayer1.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)
        avPlayerLayer2.frame = CGRectMake(self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height)
        avPlayerLayer3.frame = CGRectMake(self.view.frame.size.width * 2, 0, self.view.frame.size.width, self.view.frame.size.height)
        // 视频充满
        avPlayerLayer1.videoGravity = AVLayerVideoGravityResizeAspectFill
        avPlayerLayer2.videoGravity = AVLayerVideoGravityResizeAspectFill
        avPlayerLayer3.videoGravity = AVLayerVideoGravityResizeAspectFill
        
        scrollView.layer.addSublayer(avPlayerLayer1)
        scrollView.layer.addSublayer(avPlayerLayer2)
        scrollView.layer.addSublayer(avPlayerLayer3)
        
        avPlayer1.play()
        
        pagecontrol = UIPageControl(frame: CGRectMake(ScreenWidth / 2 - 100, ScreenHeight - 100, 200, 30))
        pagecontrol.numberOfPages = 3
        self.view.addSubview(pagecontrol)
        
        let logoImage = UIImageView(image: UIImage(named: "keep"))
        logoImage.frame = CGRectMake((ScreenWidth - 180) / 2, (ScreenWidth - 100) / 2, 180, 50)
        self.view.addSubview(logoImage)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = true
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.x / scrollView.frame.size.width
        
        if offset == lastIndex {
            return
        }
        
        if offset == 0 {
            avPlayer1.seekToTime(kCMTimeZero)
            avPlayer1.play()
            avPlayer2.seekToTime(kCMTimeZero)
            avPlayer2.pause()
            avPlayer3.seekToTime(kCMTimeZero)
            avPlayer3.pause()
            pagecontrol.currentPage = 0
        } else if offset == 1 {
            avPlayer1.seekToTime(kCMTimeZero)
            avPlayer1.pause()
            avPlayer2.seekToTime(kCMTimeZero)
            avPlayer2.play()
            avPlayer3.seekToTime(kCMTimeZero)
            avPlayer3.pause()
            pagecontrol.currentPage = 1
        } else if offset == 2 {
            avPlayer1.seekToTime(kCMTimeZero)
            avPlayer1.pause()
            avPlayer2.seekToTime(kCMTimeZero)
            avPlayer2.pause()
            avPlayer3.seekToTime(kCMTimeZero)
            avPlayer3.play()
            pagecontrol.currentPage = 2
        }
        
        lastIndex = offset
    }
}
