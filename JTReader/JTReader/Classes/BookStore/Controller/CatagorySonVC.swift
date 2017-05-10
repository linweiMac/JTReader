//
//  CatagorySonVC.swift
//  JTReader
//
//  Created by jiangT on 2017/5/10.
//  Copyright © 2017年 jiangT. All rights reserved.
//

import UIKit

class CatagorySonVC: JTBaseViewController {
    
    @IBOutlet var collectionView: UICollectionView!
    
    var dataArr = [Book]()
    
    
    public var type : String!
    public var categoryId = ""
    
    var pageNum = 1
    var pageSize = 20
    
    // MARK:-懒加载自己的ViewModel属性
    lazy var catagoryVM : BookCatagoryVM = BookCatagoryVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        
        print(categoryId+"------")
        
        //1.处理界面
        setUpUI()
        
        //2.加载数据
        getCatagoryData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK:-处理界面
    func setUpUI () {
        
        let margin : CGFloat = 8.0
        let itemW = (kScreenW - 4.0 * margin)/3.0
        let itemH = (19.0*itemW)/15.0
        
        //创建layout
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: itemW, height: itemH)
        layout.minimumLineSpacing = margin
        layout.minimumInteritemSpacing = 0
        
        //初始化collectionView
        collectionView.collectionViewLayout = layout
        collectionView.register(UINib.init(nibName: "BookCell", bundle: nil), forCellWithReuseIdentifier: "BookCell")
        collectionView.showsVerticalScrollIndicator = false
    }

}

// MARK:-数据处理
extension CatagorySonVC {
    
    // MARK:-获取该分类下的数据
    fileprivate func getCatagoryData () {
        
        NetWorkTool.requestCatagoryData(type: type, catelogId: categoryId, pageNum: String(pageNum), pageSize: String(pageSize)) { (result) in
            
            //1.将result转成字典
            guard let resultDict = result as? [String : NSObject] else { return }
            
            //2.取出数组
            guard let dataArr = resultDict["list"] as? [[String : NSObject]] else { return }
            
            //3.遍历字典，并且转成模型对象
            for dict in dataArr {
                let book = Book(dict: dict)
                self.dataArr.append(book)
            }
            
            self.collectionView.reloadData()
        }
    }
}

// MARK:-协议方法
extension CatagorySonVC : UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if dataArr.count == 0 {
            return 20
        }
        return dataArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //创建cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BookCell", for: indexPath) as! BookCell
        
        if dataArr.count == 0 {
            return cell
        } else {
            let model = dataArr[indexPath.row]
            cell.model = model
            
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150, height: 190)
    }
    
}

