//
//  BookReadVC.swift
//  JTReader
//
//  Created by jiangT on 2017/5/7.
//  Copyright © 2017年 jiangT. All rights reserved.
//

import UIKit
import TMCache
import ZipArchive
import AVFoundation

let ZipUsePassWord = "ae831eedf9094c94a019ef6b0e5d8aa1"

class BookReadVC: JTBaseViewController, JTDownLoadToolDelegate {

    public var showBook : Book!
    
    var pageContentArr = [PageContent]()
    var pageNum = 1
    var pathAll = ""
    
    var  bookPath : NSString?
    
    var downLoadTool = JTDownLoadTool()
    
    var coredataTool = JTCoreDataTool()
    
    var loadingView : DownLoadView?
    var timer : Timer?
    var rate = 0.01
    
    @IBOutlet var showView: UIView!
    
    @IBOutlet var showImg: UIImageView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // MARK:-横竖屏设置
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.allowRotation = 1 //1表示支持横竖屏
        let value = UIInterfaceOrientation.landscapeLeft.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.allowRotation = 0
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = true
        
        // MARK:- 判断是否已下载书本
        judgeIsDownLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func backClick(_ sender: UIButton) {
        
        //暂停下载
        self.downLoadTool.pauseDownload()
        
        self.navigationController?.popViewController(animated: false)
        
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        appDelegate.allowRotation = 0 //1表示支持横竖屏

        
    }
    
    // MARK:-判断是否下载
    func judgeIsDownLoad() {
        
        downLoadTool.delegate = self as JTDownLoadToolDelegate
        
        //检测是否下载
        let cacheBook = TMDiskCache.shared().object(forKey: showBook.bookName) as? Book
        
        if cacheBook != nil { //下载完成了  开始看书
            print("下载完成")
            //书本保存的路径
//            let documentURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
//            let filePath = documentURL.appendingPathComponent("zip/" + showBook.id.stringValue + ".zip")
            
            let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.allDomainsMask, true)
            let documentPath = paths[0]
            
            let filePath = documentPath.appendingFormat("/zip/book%@.zip", showBook.id.stringValue)
            
            bookPath = filePath as NSString
            setUpUI()
        } else {//未下载完成
            
            //下载动画初始化
            loadingView = DownLoadView.init(frame: CGRect(x: 0, y: 0, width: 248, height: 35))
            loadingView!.center = self.view.center
            self.view.addSubview(loadingView!)
            
            let downMode = TMDiskCache.shared().object(forKey: showBook.zipUrl) as? JTDownLoadMode
            
            if downMode != nil { //断点续传
                print("断点续传")
                
                //下载动画开始
                loadingView?.setProgress(rate: CGFloat((downMode?.progress)!))
                loadingView?.startLoading()
                
                //开始下载
                downLoadTool.cancelledData = downMode?.partialData
                downLoadTool.beginDownload()
                
            } else { //全新未下载   开始下载  下载完成开始看书
                print("全新未下载")
                
                //下载动画开始
                loadingView?.startLoading()
                
                //开始下载
                downLoadTool.downLoadUrl = showBook.zipUrl
                downLoadTool.beginDownload()
            }
        }
    }
    

    // MARK:-JTDownLoadToolDelegate
    func downLoadStatus(status: Int) {
        
        // 1开始下载了 2正在下载中 3完成下载
        if status == 1 {
            print("开始下载了")
        }
        else if status == 2 {
            print("正在下载中")
        }
        else if status == 3 {
            print("下载完成了")
            
            //本地持久化存储已下载书本信息
            coredataTool.addCoreData(saveBook: showBook)
            
            let arr = coredataTool.printAllDataWithCoreData()
            print(arr.first?.bookName ?? "")
            
            //保存已下载记录
            TMDiskCache.shared().setObject(showBook, forKey: showBook.bookName)
            
            //书本保存的路径
            bookPath = downLoadTool.downLoadMode.filePath as NSString?
            
            //删除可能的缓存的数据
            TMDiskCache.shared().removeObject(forKey: showBook.zipUrl)
            
            //下载完成  删除下载动画
            loadingView?.removeFromSuperview()
            showView.backgroundColor = UIColor.white
            
            //下载完成解压压缩包
            unZipMetod()
        }
        else {
            print("状态外的")
            
        }
    }
    
    func downLoadProgress(progress: CGFloat) {
        
        loadingView?.setProgress(rate: progress)
    }
    
    func downLoadFailed(partialData: Data) {
        
    }
    
    
    // MARK:- 先解压文件并删除文件 展示阅读界面
    func setUpUI () {
        
        showSelf()
    }
    
    
    // MARK:- 解压文件
    func unZipMetod () {
        
        guard let zipPath = bookPath else {
            return
        }
        let useUzip = bookPath?.deletingLastPathComponent
        guard let unzipPath = useUzip else {
            return
        }
        
        let jtZipTool = ZipArchive.init()
        
        let success = jtZipTool.unzipOpenFile(zipPath as String!, password: ZipUsePassWord)
        if !success {
            return
        }
        print("解压成功---\(unzipPath)")
        jtZipTool.unzipFile(to: useUzip, overWrite: true)
            
        if FileManager.default.fileExists(atPath: bookPath! as String) {
            
           try! FileManager.default.removeItem(atPath: bookPath! as String)
        }
        
        showSelf()
        
    }
    
    // MARK:- 显示界面
    func showSelf() {
        //解析文件夹内  temp.txt 文件
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.allDomainsMask, true)
        let documentPath = paths[0]
        pathAll = documentPath.appendingFormat("/zip/book%@", showBook.id.stringValue)
        
        let usePath = pathAll.appending("/temp.txt")
        
        let data = FileManager.default.contents(atPath: usePath)
        
        let jsonDic : NSDictionary = try! JSONSerialization.jsonObject(with: data! as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
        
        let arr = jsonDic["contents"] as? [[String : NSObject]]
        
        for dic in arr! {
            let pageContent = PageContent.init(dict : dic )
            pageContentArr.append(pageContent)
        }
        
        let leftSwip = UISwipeGestureRecognizer.init(target: self, action: #selector(swipGesMeyod(sender:)))
        leftSwip.direction = .left
        
        let rightSwip = UISwipeGestureRecognizer.init(target: self, action: #selector(swipGesMeyod(sender:)))
        rightSwip.direction = .right
        
        showImg.isUserInteractionEnabled = true
        showImg.addGestureRecognizer(leftSwip)
        showImg.addGestureRecognizer(rightSwip)
        
        //显示图片
        showImgChange()
        //播放音频
        playMusic()
    }
    
    @objc func swipGesMeyod(sender : UISwipeGestureRecognizer) {
        
        soundPlayer?.stop()
        
        switch sender.direction {
        case UISwipeGestureRecognizerDirection.left:
            //下一页
            pageNum += 1
            if pageNum > pageContentArr.count {
                pageNum = pageContentArr.count
                return;
            }
            
            UIView.animate(withDuration: 0.6) {
                
                UIView.setAnimationCurve(UIViewAnimationCurve.easeInOut)
                UIView.setAnimationTransition(UIViewAnimationTransition.curlUp, for: self.showView, cache: true)
            }
            
            break
        case UISwipeGestureRecognizerDirection.right:
            //上一页
            pageNum -= 1
            if pageNum < 1 {
                pageNum = 1
                return
            }
            
            UIView.animate(withDuration: 0.6) {
                
                UIView.setAnimationCurve(UIViewAnimationCurve.easeInOut)
                UIView.setAnimationTransition(UIViewAnimationTransition.curlDown, for: self.showView, cache: true)
            }
            
            break
        default: break
            
        }
        
        showImgChange()
        
        playMusic()
        
    }
    
    
    
    func showImgChange() {
        
        let content = pageContentArr[pageNum-1]
        let useStr = content.imageUrl.lastPathComponent
        let imgPath = pathAll.appendingFormat("/%@", useStr)
        
        if FileManager.default.fileExists(atPath: imgPath) {
            let image = UIImage.init(contentsOfFile: imgPath)
            showImg.image = image
        }
        
    }
    
    func playMusic() {
        let content = pageContentArr[pageNum-1]
        let useStr = content.mp3Url.lastPathComponent
        let musicPath = pathAll.appendingFormat("/%@", useStr)
        
        if FileManager.default.fileExists(atPath: musicPath) {
            
            self.playSound(musicPath: musicPath, with: true)
            
        }
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag {
            print("音频播放成功")
        }
    }
    
}
