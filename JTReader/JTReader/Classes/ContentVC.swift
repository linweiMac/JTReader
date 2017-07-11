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
    
    fileprivate var titleV = UILabel()
    
    var storeVC = BookStoreVC()
    @IBOutlet var storeBtn: UIButton!
    
    var circleVC = CircleVC()
    @IBOutlet var circleBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUI()
        self.automaticallyAdjustsScrollViewInsets = false
        
    }

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func storeClick(_ sender: UIButton) {
        
        if storeVC.view.isHidden {
            storeVC.view.isHidden = false
            circleVC.view.isHidden = true
            sender.isSelected = true
            circleBtn.isSelected = false
        }
        titleV.text = "书城"
    }
    
    @IBAction func circleClick(_ sender: UIButton) {
        
        if circleVC.view.isHidden {
            circleVC.view.isHidden = false
            storeVC.view.isHidden = true
            sender.isSelected = true
            storeBtn.isSelected = false
        }
        titleV.text = "圈子"
    }
}

extension ContentVC {
    
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
        
        let vc = SearchVC()
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    @objc fileprivate func backClick () {
        
        self.navigationController?.popViewController(animated: true)
    }
}


