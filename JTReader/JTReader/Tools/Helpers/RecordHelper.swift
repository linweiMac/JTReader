//
//  RecordHelper.swift
//  JTReader
//
//  Created by jiangT on 2017/7/12.
//  Copyright © 2017年 jiangT. All rights reserved.
//

import UIKit
import AVFoundation

protocol RecordHelperDelegate : class{
    func recordToolPlayRecordStop()
}


class RecordHelper: NSObject, AVAudioPlayerDelegate {

    weak var delegate : RecordHelperDelegate?
    
    var recordTool : AVAudioRecorder? //音频录音机
    
    var recordPlayer : AVAudioPlayer? //音频播放器
    
    public var cafPath : String?
    public var mp3Path : String?
    
    public var duration : TimeInterval?
    
    //开始录音
    public func startRecord(path : NSString) {
        
//        let document = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.allDomainsMask, true).first
//        
//        let usePath = document?.appending("/DubTest.caf")
        
        self.cafPath = path as String
        
        recordTool = try! AVAudioRecorder.init(url: getSavePath(path: path as String), settings: setSomeSettings())
        
        recordTool?.isMeteringEnabled = true
        
        recordTool?.prepareToRecord()
        
        recordTool?.record()
    }
    
    //结束录音   传来的MP3路径
    public func stopRecord () {
        
        //此处需要恢复设置回放标志，否则会导致其它播放声音也会变小
        let session = AVAudioSession.sharedInstance()
        try? session.setCategory(AVAudioSessionCategoryPlayback)
        
        recordTool?.stop()
        recordTool = nil
        
//        let mp3Path1 = path
//    
//        self.mp3Path = mp3Path1 as String
        
        //将录音转为MP3格式
//        FilePathHelper.caf(toMp3: self.cafPath, withMp3: self.mp3Path)
        
        //删除本地caf文件
//        self.perform(#selector(deletCafData), with: nil, afterDelay: 2)
        
    }
    
    //播放录音
    public func recordPlayerPlay(mp3Path : String) {
        
        if recordPlayer != nil {
            
            recordPlayer?.stop()
            recordPlayer = nil
        }
        
        recordPlayer = try! AVAudioPlayer.init(contentsOf: URL.init(string: mp3Path)!)
        recordPlayer?.delegate = self
        recordPlayer?.play()
        
        duration = recordPlayer?.duration
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag {
            self.delegate?.recordToolPlayRecordStop()
        }
    }
    
    //播放录音停止
    public func recordPlayerStop() {
        recordPlayer?.stop()
        recordPlayer = nil
    }
}

extension RecordHelper {
    
    fileprivate func setSomeSettings() -> ([String : Any]) {
        
        let session = AVAudioSession.sharedInstance()
        
        //设置录音类型
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        
        //初始化字典并添加设置参数
        let recorderSeetingsDic =
            [AVFormatIDKey: NSNumber(value: kAudioFormatLinearPCM),
                AVNumberOfChannelsKey: 2, //录音的声道数，立体声为双声道
                AVEncoderAudioQualityKey : AVAudioQuality.max.rawValue,
                AVEncoderBitRateKey : 320000,
                AVSampleRateKey : 44100.0] as [String : Any] //录音器每秒采集的录音样本数]
        
        return recorderSeetingsDic
    }

    fileprivate func getSavePath (path : String) -> (URL) {
        
        if FileManager.default.fileExists(atPath: path) {
            try? FileManager.default.removeItem(atPath: path)
        }
        return URL.init(string: path)!
    }
    
    //删除本地caf的录音数据
    @objc fileprivate func deletCafData() {
        
        if FileManager.default.fileExists(atPath: self.cafPath!) {
            try? FileManager.default.removeItem(atPath: self.cafPath!)
        }
    }
}


