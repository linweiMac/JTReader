//
//  ShelfReadVC.swift
//  JTReader
//
//  Created by jiangT on 2017/6/28.
//  Copyright © 2017年 jiangT. All rights reserved.
//

import UIKit

class ShelfReadVC: JTBaseViewController {

    @IBOutlet var collectionView: UICollectionView!
    
    public var showBook : Book!
    var  bookPath : NSString?
    
    var pageContentArr = [PageContent]()
    var pageNum = 1
    var pathAll = ""
    
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
        
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK:-横竖屏设置
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.allowRotation = 1 //1表示支持横竖屏
        
        let layout = BookLayout_OC()
        collectionView.collectionViewLayout = layout
        //初始化collectionView
        collectionView.register(UINib.init(nibName: "PageContentCell", bundle: nil), forCellWithReuseIdentifier: "PageContentCell")
        collectionView.showsVerticalScrollIndicator = false
        
        //找到书本数据
        getBookInfo()
    }

    func getBookInfo() {
        
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.allDomainsMask, true)
        let documentPath = paths[0]
        
        let filePath = documentPath.appendingFormat("/zip/book%@.zip", showBook.id.stringValue)
        
        bookPath = filePath as NSString
        
        //解析文件夹内  temp.txt 文件
        pathAll = documentPath.appendingFormat("/zip/book%@", showBook.id.stringValue)
        
        let usePath = pathAll.appending("/temp.txt")
        
        let data = FileManager.default.contents(atPath: usePath)
        
        let jsonDic : NSDictionary = try! JSONSerialization.jsonObject(with: data! as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
        
        let arr = jsonDic["contents"] as? [[String : NSObject]]
        
        for dic in arr! {
            
            let pageContent = PageContent.init(dict : dic )
            pageContentArr.append(pageContent)
        }
        
        self.collectionView.reloadData()
    }
    
    
    @IBAction func backClick(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: false)
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}


extension ShelfReadVC : UICollectionViewDelegate, UICollectionViewDataSource  {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return pageContentArr.count+2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //创建cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PageContentCell", for: indexPath) as! PageContentCell
        
        if indexPath.row == 0 {
            return cell
        } else if indexPath.row == pageContentArr.count+1 {
            return cell
        }
        
        cell.model = pageContentArr[indexPath.row-1]
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        print(indexPath.row)
        
    }
    
}





