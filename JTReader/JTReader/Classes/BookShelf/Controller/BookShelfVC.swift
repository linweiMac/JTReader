//
//  BookShelfVC.swift
//  JTReader
//
//  Created by jiangT on 2017/5/2.
//  Copyright © 2017年 jiangT. All rights reserved.
//

import UIKit
import SwiftyJSON

class BookShelfVC: JTBaseViewController {

    @IBOutlet var collection: UICollectionView!
    
    @IBOutlet var bookStoreBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUI()
        
        
        
//        NetWorkTool.requestBookListData(schoolId: "-9", userId: "125178", type: "Chinese", grade: "", catelogId: "", pageNum: "1") { (response) in
//            
//            
//            let json = JSON(response)
//            
//            print(json)
//            
//            print(json["list"])
//            
//            
//        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    
    @IBAction func bookStoreClick(_ sender: UIButton) {
        
        let vc = ContentVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    

}


extension BookShelfVC {
    
    fileprivate func setUpUI() {
        
        //设置导航栏
        self.navigationController?.navigationBar.barTintColor = UIColor.init(r: 46, g: 46, b: 46)
        
        
        setBarButtonItem()
        
    }
    
    fileprivate func setBarButtonItem() {
        
        let size = CGSize(width: 40, height: 40)
        navigationItem.leftBarButtonItem = UIBarButtonItem(imageName: "默认头像", hightLightImageName: "", text:"", size: size, target: self, action: #selector(userClick))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(imageName: "搜索", hightLightImageName: "", text:"",size: size, target: self, action: #selector(searchClick))
        
        
        let titleV = UILabel()
        titleV.frame = CGRect(x: 0, y: 0, width: 80, height: 40)
        titleV.text = "书架"
        titleV.textColor = UIColor.white
        titleV.backgroundColor = UIColor.clear
        titleV.textAlignment = .center
        self.navigationItem.titleView = titleV
    }
    
    
    @objc fileprivate func userClick () {
        print(#function)
    }
    
    @objc fileprivate func searchClick () {
        print(#function) 
    }
    
    
}





