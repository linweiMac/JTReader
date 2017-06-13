//
//  BookReadVC.swift
//  JTReader
//
//  Created by jiangT on 2017/5/7.
//  Copyright © 2017年 jiangT. All rights reserved.
//

import UIKit

class BookReadVC: JTBaseViewController {

    public var bookId = ""
    
    var downLoadTool = JTDownLoadTool()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
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
    
//    override func viewDidDisappear(_ animated: Bool) {
//        super.viewDidDisappear(animated)
//        
//        self.navigationController?.isNavigationBarHidden = false
//        
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        appDelegate.allowRotation = 0
//        let value = UIInterfaceOrientation.portrait.rawValue
//        UIDevice.current.setValue(value, forKey: "orientation")
//        
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = true
        
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.allowRotation = 1 //1表示支持横竖屏
        
        //下载代码
//        downloadTool.downLoadUrl = showBook.zipUrl
//        downloadTool.beginDownload()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func backClick(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: false)
        
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        appDelegate.allowRotation = 0 //1表示支持横竖屏

        
    }
    

    

}
