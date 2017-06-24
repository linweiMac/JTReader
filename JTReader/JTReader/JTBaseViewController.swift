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
    
}
