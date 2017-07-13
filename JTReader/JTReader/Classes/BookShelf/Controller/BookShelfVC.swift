//
//  BookShelfVC.swift
//  JTReader
//
//  Created by jiangT on 2017/5/2.
//  Copyright © 2017年 jiangT. All rights reserved.
//

import UIKit
import SwiftyJSON
import TMCache
import MMDrawerController

class BookShelfVC: JTBaseViewController {

    @IBOutlet var collection: UICollectionView!
    
    @IBOutlet var bookStoreBtn: UIButton!
    
    
    var coredataTool = JTCoreDataTool()
    
    var downBookArr = [Book]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        initBookInfo()
        
        self.mm_drawerController.openDrawerGestureModeMask = .all
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.mm_drawerController.openDrawerGestureModeMask = .custom
        
        self.mm_drawerController.setGestureShouldRecognizeTouch { (drawerController : MMDrawerController?, gesture : UIGestureRecognizer?, touch : UITouch?) -> Bool in
            
            let shouldRecognizeTouch = false
            
            return shouldRecognizeTouch
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUI()
        
        let layout = ProductBookShelfFlowLayout()
        
        //初始化collectionView
        collection.collectionViewLayout = layout
        collection.register(UINib.init(nibName: "BookCell", bundle: nil), forCellWithReuseIdentifier: "BookCell")
        collection.showsVerticalScrollIndicator = false
        
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
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        //设置导航栏
        self.navigationController?.navigationBar.barTintColor = UIColor.init(r: 18, g: 123, b: 198)
        
        //设置导航栏
        setBarButtonItem()
        
        
        //初始化数据
        initBookInfo()
        
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
                
        self.mm_drawerController.toggle(MMDrawerSide.left, animated: true, completion: nil)
        
    }
    
    @objc fileprivate func searchClick () {
        print(#function)
        
        let vc = SearchVC()
        
        self.navigationController?.pushViewController(vc, animated: false)
        
    }
    
    func initBookInfo () {
        
        let arr = coredataTool.printAllDataWithCoreData()
        
        downBookArr.removeAll()
        
        let dic = ["" : ""]  as [String : NSObject]
        for downB : DownloadBook in arr {
            
            let book = Book.init(dict: dic)
            book.initSelf(downBook: downB)
            downBookArr.append(book)
        }
        
        collection.reloadData()
        
    }
    
}


extension BookShelfVC : UICollectionViewDelegate, UICollectionViewDataSource  {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return downBookArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //创建cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BookCell", for: indexPath) as! BookCell
        
            let model = downBookArr[indexPath.row]
            cell.model = model
            
            return cell
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: 150, height: 190)
//    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        //效果1
//        let model = downBookArr[indexPath.row]
//        print(model.bookName);
//        
//        let vc = ShelfReadVC()
//        vc.showBook = model
//        self.navigationController?.pushViewController(vc, animated: false)
        
        //效果2
        let model = downBookArr[indexPath.row]
        print(model.bookName);
        
        let vc = ShelfReadVCTwo()
        vc.showBook = model
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
}


