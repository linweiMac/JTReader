//
//  DubVC.swift
//  JTReader
//
//  Created by jiangT on 2017/7/7.
//  Copyright © 2017年 jiangT. All rights reserved.
//

import UIKit
import TMCache
import ZipArchive

class DubVC: JTBaseViewController, RecordHelperDelegate {
    
    public var showBook : Book!
    var downLoadTool = JTDownLoadTool()
    var bookPath : NSString?
    
    var coredataTool = JTCoreDataTool()
    
    var pageContentArr = [DubModel]()
    var pageNum : Int = 1
    var pathAll = ""
    var mp3Path = ""
    
    var loadingView : DownLoadView?
    
    @IBOutlet var tryListenView: UIButton!
    var layer : CAShapeLayer?
    var recordTool = RecordHelper()
    
    var timer : Timer?
    
    @IBOutlet var stopRecordBtn: UIButton!
    
    @IBOutlet var recordView: UIView!
    @IBOutlet var aniImg: UIImageView!
    @IBOutlet var timeLbl: UILabel!
    
    @IBOutlet var preBtn: UIButton!
    @IBOutlet var nextBtn: UIButton!
    @IBOutlet var playBtn: UIButton!
    @IBOutlet var recorderBtn: UIButton!
    @IBOutlet var deletBtn: UIButton!
    
    
    @IBOutlet var upView: UIView!
    @IBOutlet var backBtn: UIButton!
    @IBOutlet var titleLbl: UILabel!
    @IBOutlet var upViewHeight: NSLayoutConstraint!
    
    @IBOutlet var showImg: UIImageView!
    
    @IBOutlet var toolViewHeight: NSLayoutConstraint!
    @IBOutlet var toolView: UIView!
    
    @IBOutlet var toolUpView: UIView!
    @IBOutlet var toolDownView: UIView!
    
    override var preferredStatusBarStyle: UIStatusBarStyle
    {
        return .lightContent
    }
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.automaticallyAdjustsScrollViewInsets = false
        self.navigationController?.isNavigationBarHidden = true
        
        // MARK:-横竖屏设置
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.allowRotation = 1 //1表示支持横竖屏
        let value = UIInterfaceOrientation.landscapeLeft.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // MARK:-横竖屏设置
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.allowRotation = 0
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        recordTool.delegate = self
        
        mp3Path = FilePathHelper.cacheFilePath(String(format: "/book%@", showBook.id))
        
        setShowImgGes()
        
        //判断是否已经下载
        judgeIsDownLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - 按钮控制方法
    @IBAction func backClick(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: false)
    }
    //上一页
    @IBAction func preClick(_ sender: UIButton) {
        
        //上一页
        pageNum -= 1
        if pageNum < 1 {
            pageNum = 1
            return
        }
        
        showImgChange()
        btnHidden()
        
    }
    //下一页
    @IBAction func nextClick(_ sender: UIButton) {
        
        //下一页
        pageNum += 1
        if pageNum > pageContentArr.count {
            pageNum = pageContentArr.count
            return;
        }
        
        showImgChange()
        btnHidden()
    }
    //播放录音
    @IBAction func playRecordClick(_ sender: UIButton) {
        
        self.upViewHeight.constant = 0
        self.toolViewHeight.constant = 10
        UIView.animate(withDuration: 0.25, animations: {
            self.view.layoutIfNeeded()
        })
        
        preBtn.isEnabled = false
        nextBtn.isEnabled = false
        showImg.isUserInteractionEnabled = false
        
        let model = pageContentArr[pageNum-1]
        recordTool.recordPlayerPlay(mp3Path: model.mp3Url!)
        
        initTryListenView()
    }
    
    func initTryListenView () {
        tryListenView.center = self.view.center
        self.view.addSubview(tryListenView)
        
        tryListenView.layer.cornerRadius = tryListenView.frame.height/2.0
        
        let rect = CGRect(x: 0, y: 0, width: tryListenView.frame.height, height: tryListenView.frame.height)
        
        let beizPath = UIBezierPath.init(roundedRect: rect, cornerRadius: tryListenView.frame.size.height/2.0)
        
        //先画一个圆
        layer = CAShapeLayer()
        layer?.path = beizPath.cgPath
        layer?.fillColor = UIColor.clear.cgColor//填充色
        layer?.strokeColor = UIColor.init(r: 59, g: 168, b: 138).cgColor//边框颜色
        layer?.lineWidth = 3
        layer?.lineCap = kCALineCapRound//线框类型
        
        let animation = CABasicAnimation.init(keyPath: "strokeEnd")
        animation.fromValue = NSNumber.init(value: 0.0)
        animation.toValue = NSNumber.init(value: 1.0)
        animation.duration = recordTool.duration!
        animation.fillMode = kCAFillModeForwards
        animation.isRemovedOnCompletion = true
        animation.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionLinear)
        layer?.add(animation, forKey: "animation")
        
        tryListenView.layer.addSublayer(layer!)
    }
    
    func recordToolPlayRecordStop() {
        
        layer?.removeAllAnimations()
        layer?.removeFromSuperlayer()
        layer = nil
        
        tryListenView.removeFromSuperview()
        
        self.upViewHeight.constant = 64
        self.toolViewHeight.constant = 75
        UIView.animate(withDuration: 0.25, animations: {
            self.view.layoutIfNeeded()
        })
        
        preBtn.isEnabled = true
        nextBtn.isEnabled = true
        showImg.isUserInteractionEnabled = true
    }
    
    //停止播放录音
    @IBAction func recordPlayStop(_ sender: UIButton) {
        
        layer?.removeAllAnimations()
        layer?.removeFromSuperlayer()
        layer = nil
        
        tryListenView.removeFromSuperview()
        
        self.upViewHeight.constant = 64
        self.toolViewHeight.constant = 75
        UIView.animate(withDuration: 0.25, animations: {
            self.view.layoutIfNeeded()
        })
        
        preBtn.isEnabled = true
        nextBtn.isEnabled = true
        showImg.isUserInteractionEnabled = true
        
    }
    
    //开始录音
    @IBAction func startRecordClick(_ sender: UIButton) {
        
        let model = pageContentArr[pageNum-1]
        if model.mp3Url == nil {
            print("无音频")
            
            self.upViewHeight.constant = 0
            self.toolViewHeight.constant = 10
            UIView.animate(withDuration: 0.25, animations: {
                self.view.layoutIfNeeded()
            })
            
            preBtn.isEnabled = false
            nextBtn.isEnabled = false
            showImg.isUserInteractionEnabled = false
            
            let imageV = UIImageView.init(image: UIImage.init(named: "开始你的表演.jpg"))
            imageV.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
            imageV.center = self.view.center
            self.view.addSubview(imageV)
            
            UIView.animate(withDuration: 2, animations: {
                imageV.transform = CGAffineTransform.init(scaleX: 1.1, y: 0.9)
            }) { (Bool) in
                imageV.removeFromSuperview()
                
                self.recordTool.startRecord(path: self.mp3Path.appendingFormat("/%d.caf", self.pageNum))
                self.recordView.isHidden = false
                self.stopRecordBtn.isHidden = false
            }

            
        } else {
            print("有音频")
            
            let alertController = UIAlertController(title: "提示", message: "确定重新录制么？", preferredStyle: .alert) // 这里因为控件都不存在改变的可能，所以一律使用let类型.UIAlertControllerStyle可以选择.actionSheet或.alert
            
            let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            let okAction = UIAlertAction(title: "确定", style: .default, handler:{
                (UIAlertAction) -> Void in
                print("点击确定事件")
                
                model.mp3Url = nil
                
                self.startRecordClick(self.recorderBtn)
                
            })
            alertController.addAction(cancelAction)
            alertController.addAction(okAction)// 当添加的UIAlertAction超过两个的时候，会自动变成纵向分布
            self.present(alertController, animated: true, completion: nil)
            return;
        }
        
    }
    
    //结束录音
    @IBAction func stopRecordClick(_ sender: UIButton) {
        
        self.upViewHeight.constant = 64
        self.toolViewHeight.constant = 75
        UIView.animate(withDuration: 0.25, animations: {
            self.view.layoutIfNeeded()
        })
        
        preBtn.isEnabled = true
        nextBtn.isEnabled = true
        showImg.isUserInteractionEnabled = true
        
        self.recordView.isHidden = true
        self.stopRecordBtn.isHidden = true
        
        recordTool.stopRecord()
        
        let model = pageContentArr[pageNum-1]
        model.mp3Url = mp3Path.appendingFormat("/%d.caf", pageNum)
        
        showImgChange()
        btnHidden()
    }
    
    
    //删除本页录音
    @IBAction func deletRecordClick(_ sender: UIButton) {
        
        let model = pageContentArr[pageNum-1]
        
        let alertController = UIAlertController(title: "提示", message: "确定删除音频么？", preferredStyle: .alert) // 这里因为控件都不存在改变的可能，所以一律使用let类型.UIAlertControllerStyle可以选择.actionSheet或.alert
        
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let okAction = UIAlertAction(title: "确定", style: .default, handler:{
            (UIAlertAction) -> Void in
            print("点击确定事件")
            try? FileManager.default.removeItem(atPath: model.mp3Url!)
            model.mp3Url = nil
            
            self.btnHidden()
        })
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)// 当添加的UIAlertAction超过两个的时候，会自动变成纵向分布
        self.present(alertController, animated: true, completion: nil)
        return;
        
    }
    
}



// MARK: - 界面初始化方法
extension DubVC {
    
    func setShowImgGes() {
        
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(showImgTap))
        showImg.isUserInteractionEnabled = true
        showImg.addGestureRecognizer(tap)
    }
    @objc func showImgTap() {
        
        if self.upViewHeight.constant == 64 {
            
            self.upViewHeight.constant = 0
            self.toolViewHeight.constant = 10
            UIView.animate(withDuration: 0.25, animations: {
                self.view.layoutIfNeeded()
            })
        }
        else
        {
            self.upViewHeight.constant = 64
            self.toolViewHeight.constant = 75
            UIView.animate(withDuration: 0.25, animations: {
                self.view.layoutIfNeeded()
            })
        }
    }
    
    //页码显示
    func initToolUpView() {
        
        let margin : CGFloat = 3
        let hei : CGFloat = 4
        let wid : CGFloat = (kScreenH - CGFloat(pageContentArr.count+1)*margin)/CGFloat(pageContentArr.count)
        
        for i in 0..<pageContentArr.count {
            
            let model = pageContentArr[i]
            
            let label = UILabel.init(frame: CGRect(x: margin + CGFloat(CGFloat(i)*(wid + margin)), y: margin, width: wid, height: hei))
            
            label.tag = 10000+i
            
            if model.mp3Url != nil
            {
                label.backgroundColor = UIColor.init(r: 30, g: 222, b: 165)
            }
            else
            {
                label.backgroundColor = UIColor.init(r: 137, g: 136, b: 133)
            }
            
            if i == pageNum-1 {
                label.backgroundColor = UIColor.init(r: 241, g: 239, b: 98)
            }
            
            toolUpView.addSubview(label)
        }
    }
    
}

// MARK:- 判断是否下载
extension DubVC : JTDownLoadToolDelegate {
    
    // MARK:-判断是否下载
    func judgeIsDownLoad() {
        
        downLoadTool.delegate = self as JTDownLoadToolDelegate
        
        //检测是否下载
        let cacheBook = TMDiskCache.shared().object(forKey: showBook.bookName) as? Book
        
        if cacheBook != nil { //下载完成了  开始看书
            print("下载完成")
            //书本保存的路径
            let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.allDomainsMask, true)
            let documentPath = paths[0]
            
            let filePath = documentPath.appendingFormat("/zip/book%@.zip", showBook.id.stringValue)
            
            bookPath = filePath as NSString
            setUpUI()
        } else {//未下载完成
            
            //下载动画初始化
            loadingView = DownLoadView.init(frame: self.view.bounds)
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
            
            let dubModel = DubModel()
            dubModel.imageUrl = pageContent.imageUrl
            pageContentArr.append(dubModel)
        }
        
        for i in 0..<pageContentArr.count {
            
            let index = i + 1
            
            let path = mp3Path.appendingFormat("/%d.caf", index)
            
            let dubModel = pageContentArr[i]
            
            if FileManager.default.fileExists(atPath: path) {
                //有录音的
                dubModel.mp3Url = path
            } else {
                dubModel.mp3Url = nil
            }
        }
        
        btnHidden()
        initToolUpView()
        //显示图片
        showImgChange()
        
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
    
    func btnHidden() {
        
        preBtn.isHidden = false
        nextBtn.isHidden = false
        
        if pageNum == 1 {
            preBtn.isHidden = true
        }
        if pageNum == pageContentArr.count {
            nextBtn.isHidden = true
        }
        
        let model = pageContentArr[pageNum-1]
        
        playBtn.isHidden = true
        deletBtn.isHidden = true
        if model.mp3Url != nil {
            playBtn.isHidden = false
            deletBtn.isHidden = false
        }
        
        for k in 0..<pageContentArr.count {
            
            let model = pageContentArr[k]
            
            let label = self.toolUpView.viewWithTag(10000+k)
            
            if model.mp3Url != nil
            {
                label?.backgroundColor = UIColor.init(r: 30, g: 222, b: 165)
            }
            else
            {
                label?.backgroundColor = UIColor.init(r: 137, g: 136, b: 133)
            }
            
            if k == pageNum-1 {
                label?.backgroundColor = UIColor.init(r: 241, g: 239, b: 98)
            }

        }
    }
}
