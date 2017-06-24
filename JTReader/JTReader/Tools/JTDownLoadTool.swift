//
//  JTDownLoadTool.swift
//  JTReader
//
//  Created by jiangT on 2017/6/8.
//  Copyright © 2017年 jiangT. All rights reserved.
//

import UIKit
import Alamofire
import TMCache

private let kCurrentSession = "Current Session"
private let kBackgroundSession = "Background Session"
private let kBackgroundSessionID = "cn.xdd.DownloadTask.BackgroundSession"

protocol JTDownLoadToolDelegate : class {

    func downLoadProgress (progress : CGFloat) //刷新进度
    
    func downLoadFailed (partialData : Data)//停止
    
    func downLoadStatus (status : Int) // 1开始下载了 2正在下载中 3完成下载
}

class JTDownLoadTool: NSObject {

    var downLoadUrl : String?
    
    var cancelledData:Data? //停止下载时保存已下载部分
    
    var downLoadMode = JTDownLoadMode()
    
    var downloadRequest:DownloadRequest!
    
    weak var delegate : JTDownLoadToolDelegate?
    
    //指定下载路径
    let destination:DownloadRequest.DownloadFileDestination = { _, response in
        let documentURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = documentURL.appendingPathComponent("zip/"+response.suggestedFilename!)
        return (fileURL,[.removePreviousFile,.createIntermediateDirectories])
    }
    
    func downloadProgress(progress:Progress){
        print("当前进度:\(progress.fractionCompleted*100)%")
        
        self.delegate?.downLoadStatus(status: 2)
        
        downLoadMode.progress = progress.fractionCompleted*100
        
        self.delegate?.downLoadProgress(progress: CGFloat(progress.fractionCompleted))
    }
    
    func downloadResponse(response:DownloadResponse<Data>){
        switch response.result {
        case .success( _):
            //下载完成
            DispatchQueue.main.async {
                print("路径:\(String(describing: response.destinationURL?.path))")
            }
            
            downLoadMode.filePath = response.destinationURL?.path
            
            self.delegate?.downLoadStatus(status: 3)
            
        case .failure(error:):
            self.cancelledData = response.resumeData //意外中止的话把已下载的数据存起来
            
            //保存下载的数据  供下次下载
            downLoadMode.partialData = response.resumeData
            TMDiskCache.shared().setObject(downLoadMode, forKey: self.downLoadUrl)
            
            self.delegate?.downLoadFailed(partialData: self.cancelledData!)
            
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
            
            self.delegate?.downLoadStatus(status: 2)
        }else{
            //开始下载
            self.downloadRequest = Alamofire.download(self.downLoadUrl!, to: self.destination)
            self.downloadRequest.downloadProgress(closure: downloadProgress)
            self.downloadRequest.responseData(completionHandler: downloadResponse)
            
            self.delegate?.downLoadStatus(status: 1)
        }
        
    }
    
    // MARK:- 停止下载
    func pauseDownload() {
        self.downloadRequest?.cancel()
        
        self.delegate?.downLoadStatus(status: 2)
    }
    
}



