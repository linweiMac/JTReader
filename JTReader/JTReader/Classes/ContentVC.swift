//
//  ContentVC.swift
//  JTReader
//
//  Created by jiangT on 2017/5/4.
//  Copyright © 2017年 jiangT. All rights reserved.
//

import UIKit

class ContentVC: JTBaseViewController {
    @IBOutlet var contentView: UIView!

    @IBOutlet var carouselView: JTCarouselView!
    
    @IBOutlet var carouselHeight: NSLayoutConstraint!
    
    fileprivate var titleV = UILabel()
    
    var storeVC = BookStoreVC()
    
    var circleVC = CircleVC()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUI()
        self.automaticallyAdjustsScrollViewInsets = false
        
        getLuboData()
        
        carouselView.delegate = self as JTCarouseViewDelegate
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func storeClick(_ sender: UIButton) {
        
        if storeVC.view.isHidden {
            storeVC.view.isHidden = false
            circleVC.view.isHidden = true
        }
        titleV.text = "书城"
        carouselHeight.constant = 108
    }
    
    @IBAction func circleClick(_ sender: UIButton) {
        
        if circleVC.view.isHidden {
            circleVC.view.isHidden = false
            storeVC.view.isHidden = true
        }
        titleV.text = "圈子"
        carouselHeight.constant = 0
        
    }
}


extension ContentVC : JTCarouseViewDelegate {
    
    fileprivate func setUpUI () {
        
        setBarButtonItem()
        
        let vc1 = BookStoreVC()
        storeVC = vc1
        self.contentView.addSubview(vc1.view)
        self.addChildViewController(vc1)
        vc1.view.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        let vc2 = CircleVC()
        circleVC = vc2
        self.contentView.addSubview(vc2.view)
        self.addChildViewController(vc2)
        vc2.view.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        circleVC.view.isHidden = true
        
        titleV = UILabel()
        titleV.frame = CGRect(x: 0, y: 0, width: 80, height: 40)
        titleV.text = "书城"
        titleV.textColor = UIColor.white
        titleV.backgroundColor = UIColor.clear
        titleV.textAlignment = .center
        self.navigationItem.titleView = titleV
    }
    
    fileprivate func setBarButtonItem () {
        
        let size = CGSize(width: 40, height: 40)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(imageName: "搜索", hightLightImageName: "", text:"",size: size, target: self, action: #selector(searchClick))
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(imageName: "返回", hightLightImageName: "", text:"", size: size, target: self, action: #selector(backClick))
        
    }
    
    @objc fileprivate func searchClick () {
        print(#function)
    }
    
    @objc fileprivate func backClick () {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK:-轮播图数据获取
    fileprivate func getLuboData() {
        
        NetWorkTool.requestBookStoreLuoboData { (result) in
            
            //1.将result转成字典
            guard let resultDict = result as? [String : NSObject] else { return }
            
            //2.取出数组
            guard let dataArr = resultDict["list"] as? [[String : NSObject]] else { return }
            
            //3.遍历字典，并且转成模型对象
            var dataResources = [String]()
            for dict in dataArr {
                let banner = dict["imageUrl"] as! String
                dataResources.append(banner)
            }
            
            self.carouselView.dataArr = dataResources
        }
    }
    
    func carouseView(_ carouseView: JTCarouselView, selectedIndex index: Int) {
        print(index)
    }
}


