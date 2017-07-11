//
//  ActivityVC.swift
//  JTReader
//
//  Created by jiangT on 2017/7/5.
//  Copyright © 2017年 jiangT. All rights reserved.
//

import UIKit

class ActivityVC: JTBaseViewController {

    public var linkUrl : String?
    
    @IBOutlet var webView: UIWebView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        
        let size = CGSize(width: 40, height: 40)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(imageName: "返回", hightLightImageName: "", text:"", size: size, target: self, action: #selector(backClick))
        
        let titleV = UILabel()
        titleV.frame = CGRect(x: 0, y: 0, width: 80, height: 40)
        titleV.text = "活动"
        titleV.textColor = UIColor.white
        titleV.backgroundColor = UIColor.clear
        titleV.textAlignment = .center
        self.navigationItem.titleView = titleV
        
        webView.loadRequest(NSURLRequest.init(url: URL.init(string: self.linkUrl!)!) as URLRequest)
        webView.dataDetectorTypes = .all
        
        //清楚UIWebView的缓存
        URLCache.shared.removeAllCachedResponses()
    }
    
    @objc fileprivate func backClick () {
        
        self.navigationController?.popViewController(animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}



















