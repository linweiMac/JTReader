//
//  JTBaseViewController.swift
//  JTReader
//
//  Created by jiangT on 2017/5/2.
//  Copyright © 2017年 jiangT. All rights reserved.
//

import UIKit
import AVFoundation

class JTBaseViewController: UIViewController, AVAudioPlayerDelegate {

    public var soundPlayer : AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //播放本地音频
    public func playSound(musicPath : String, with delegate : Bool) {
        
        soundPlayer?.stop()
        soundPlayer = nil
        
        let url = URL.init(fileURLWithPath: musicPath)
        
        soundPlayer = try? AVAudioPlayer.init(contentsOf: url)
        
        if delegate {
            soundPlayer?.delegate = self as AVAudioPlayerDelegate
        }
        soundPlayer?.play()
    }
    
    //播放网络音频
    
    
    //屏幕截图
    public func screenShot() -> (UIImage) {
        
//        guard let window = UIApplication.shared().keyWindow else { return nil }
        
        let window = UIApplication.shared.keyWindow
        // 用下面这行而不是UIGraphicsBeginImageContext()，因为前者支持Retina
        UIGraphicsBeginImageContextWithOptions((window?.bounds.size)!, false, 0.0)
        
        window?.layer.render(in: UIGraphicsGetCurrentContext()!)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return image!
    }
    
}
