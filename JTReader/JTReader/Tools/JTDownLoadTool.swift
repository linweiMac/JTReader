//
//  JTDownLoadTool.swift
//  JTReader
//
//  Created by jiangT on 2017/6/8.
//  Copyright © 2017年 jiangT. All rights reserved.
//

import UIKit
import TMCache
import Alamofire

private let kCurrentSession = "Current Session"
private let kBackgroundSession = "Background Session"
private let kBackgroundSessionID = "cn.xdd.DownloadTask.BackgroundSession"

protocol JTDownLoadToolDelegate : class {

    func downLoadProgress (progress : Double) //刷新进度
    
    func downLoadProgress (progress : Double, with partialData : NSData)//停止
    
    func downLoadStatus (status : Int) // 1下载 2等待 3完成 5错误
}

class JTDownLoadTool: NSObject {

    var downLoadUrl : String?
    
    var cancelledData:Data? //停止下载时保存已下载部分
    
    var downloadRequest:DownloadRequest!
    
    weak var deledate : JTDownLoadToolDelegate?
    
    //指定下载路径
    let destination:DownloadRequest.DownloadFileDestination = { _, response in
        let documentURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = documentURL.appendingPathComponent("zip/"+response.suggestedFilename!)
        return (fileURL,[.removePreviousFile,.createIntermediateDirectories])
    }
    
    func downloadProgress(progress:Progress){
        print("当前进度:\(progress.fractionCompleted*100)%")
        
        self.deledate?.downLoadStatus(status: 2)
        
        self.deledate?.downLoadProgress(progress: progress.fractionCompleted)
    }
    
    func downloadResponse(response:DownloadResponse<Data>){
        switch response.result {
        case .success( _):
            //下载完成
            DispatchQueue.main.async {
                print("路径:\(String(describing: response.destinationURL?.path))")
            }
            
            self.deledate?.downLoadStatus(status: 3)
            
        case .failure(error:):
            self.cancelledData = response.resumeData //意外中止的话把已下载的数据存起来
            
            self.deledate?.downLoadStatus(status: 5)
            break
        }
    }
    
    // MARK:-开始下载
    func beginDownload () {
        
        if let cancelledData = self.cancelledData {
            //续传
            self.downloadRequest = Alamofire.download(resumingWith: cancelledData, to: self.destination)
            self.downloadRequest.downloadProgress(closure: downloadProgress)
            self.downloadRequest.responseData(completionHandler: downloadResponse)
            
            self.deledate?.downLoadStatus(status: 2)
        }else{
            //开始下载
            self.downloadRequest = Alamofire.download(self.downLoadUrl!, to: self.destination)
            self.downloadRequest.downloadProgress(closure: downloadProgress)
            self.downloadRequest.responseData(completionHandler: downloadResponse)
            
            self.deledate?.downLoadStatus(status: 1)
        }
        
    }
    
    // MARK:- 停止下载
    func pauseDownload() {
        self.downloadRequest.cancel()
        
        self.deledate?.downLoadStatus(status: 2)
    }
    
}



