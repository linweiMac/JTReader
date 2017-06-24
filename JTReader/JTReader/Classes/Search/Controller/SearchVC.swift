//
//  SearchVC.swift
//  JTReader
//
//  Created by jiangT on 2017/6/23.
//  Copyright © 2017年 jiangT. All rights reserved.
//

import UIKit
import TMCache
import MBProgressHUD

class SearchVC: JTBaseViewController, UISearchBarDelegate {

    var searchBar : UISearchBar!
    
    var resultBookArr = [Book]()
    
    var hotBookArr = [NSString]()
    var historyArr : [NSString]?
    
    
    @IBOutlet var tableView: UITableView!

    @IBOutlet var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        
        let downBookArrTemp = TMDiskCache.shared().object(forKey: "History") as? [NSString]
        
        if downBookArrTemp == nil {
            historyArr = NSMutableArray() as? [NSString]
        } else {
            historyArr = NSMutableArray.init(array: downBookArrTemp!) as? [NSString]
        }
        
        //设置导航栏
        setBarButtonItem()
        
        
        //初始化tableView
        tableView.register(UINib.init(nibName: "SearchCell", bundle: nil), forCellReuseIdentifier: "SearchCell")
        self.tableView.separatorStyle = .none
        
        //初始化collectionView
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
        
        //获取热搜书本
        getHotBookData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    fileprivate func setBarButtonItem () {
        
        self.navigationItem.hidesBackButton = true
        
        let size = CGSize(width: 40, height: 40)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(imageName: "", hightLightImageName: "", text:"取消",size: size, target: self, action: #selector(cancleClick))
        
        searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.placeholder = "输入你想要找的书名"
        self.navigationItem.titleView = searchBar
        searchBar.becomeFirstResponder()
    }
    
    @objc fileprivate func cancleClick () {
        
        self.navigationController?.popViewController(animated: false)
    }
    
    //开始输入
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        
        tableView.isHidden = false
        tableView.reloadData()
        
        collectionView.isHidden = true
        self.resultBookArr.removeAll()
        collectionView.reloadData()
        
        return true
    }
    
    //搜索点击
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("开始搜索")
        searchBar.resignFirstResponder()
        
        if self.historyArr?.count == 0 {
            print("历史记录为空")
            historyArr!.append(searchBar.text! as NSString)
        }else {
            
            if !(historyArr!.contains(searchBar.text! as NSString)) {
                historyArr!.append(searchBar.text! as NSString)
            }
        }
        
        tableView.isHidden = true
        
        collectionView.isHidden = false
        getSearchData(keyword: searchBar.text!)
        
        TMDiskCache.shared().setObject(historyArr! as NSCoding, forKey: "History")
        
    }
    
    // MARK:- 获取热门搜索的数据
    func getHotBookData() {
        
        NetWorkTool.requestHotBookData() { (result) in
            
            //1.将result转成字典
            guard let resultDict = result as? [String : NSObject] else { return }
            
            //2.取出数组
            guard let dataArr = resultDict["list"] as? [[String : NSObject]] else { return }
            
            //3.遍历字典，并且转成模型对象
            for dict in dataArr {
                let book = Book.init(dict: dict)
                self.hotBookArr.append(book.bookName as NSString)
            }
            
            //刷新界面
            self.tableView.reloadData()
        }
    }
    
    func getSearchData(keyword : String) {
        
        MBProgressHUD.showAdded(to: self.view, animated: true)

        self.resultBookArr.removeAll()
        
        NetWorkTool.starSearchBook(keyWord: keyword) { (result) in
            
            MBProgressHUD.hide(for: self.view, animated: true)
            
            //1.将result转成字典
            guard let resultDict = result as? [String : NSObject] else { return }
            
            //2.取出数组
            guard let dataArr = resultDict["list"] as? [[String : NSObject]] else { return }
            
            //3.遍历字典，并且转成模型对象
            for dict in dataArr {
                let book = Book.init(dict: dict)
                self.resultBookArr.append(book)
            }
            
            self.collectionView.reloadData()
        }
    }
}

extension SearchVC : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var count = 0
        if hotBookArr.count > 0 {
            count += 1
        }
        
        if (historyArr?.count)! > 0 {
            count += 1
        }
        
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCell", for: indexPath) as! SearchCell
        
        if indexPath.row == 0 {
            
            if hotBookArr.count == 0 {
                return cell
            }
            
            cell.typeLbl.text = "热门搜索"
            cell.trashBtn.isHidden = true
            cell.titlesArr = hotBookArr
        }
        else {
            
            if historyArr?.count == 0 {
                return cell
            }
            
            cell.typeLbl.text = "历史搜索"
            cell.trashBtn.isHidden = false
            cell.titlesArr = historyArr
        }
        
        cell.selectionStyle = .none
        
        
        cell.keywordSelected = { [weak self] (keyword : String) -> () in
            
            self?.searchBar.text = keyword
            self?.searchBar.resignFirstResponder()
            
            self?.tableView.isHidden = true
            self?.collectionView.isHidden = false
            
            self?.searchBarSearchButtonClicked((self?.searchBar)!)
            
//            self?.getSearchData(keyword: keyword)
            
        }
        
        cell.clearAllHistory = {
            
            self.historyArr?.removeAll()
            self.tableView.reloadData()
            
            TMDiskCache.shared().setObject(self.historyArr! as NSCoding, forKey: "History")
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCell") as? SearchCell
        
        if cell == nil {
            return 30
        }
        else {
            
            if indexPath.row == 0 {
                cell!.titlesArr = hotBookArr
            }
            else {
                cell!.titlesArr = historyArr
            }
            
            return cell!.cellHeight
            
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        self.searchBar.resignFirstResponder()        
    }

    
}


extension SearchVC : UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if resultBookArr.count == 0 {
            return 20
        }
        return resultBookArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //创建cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BookCell", for: indexPath) as! BookCell
        
        if resultBookArr.count == 0 {
            return cell
        } else {
            let model = resultBookArr[indexPath.row]
            cell.model = model
            
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let margin : CGFloat = 8.0
        let itemW = (kScreenW - 4.0 * margin)/3.0
        let itemH = (19.0*itemW)/15.0
        
        return CGSize(width: itemW, height: itemH)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let model = resultBookArr[indexPath.row]
        print(model.bookName);
        
        let vc = BookDetailVC()
        vc.titleText = model.bookName
        vc.showBook = model
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

