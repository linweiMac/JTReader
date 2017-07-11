//
//  BookStoreVC.swift
//  JTReader
//
//  Created by jiangT on 2017/5/2.
//  Copyright © 2017年 jiangT. All rights reserved.
//

import UIKit

class BookStoreVC: JTBaseViewController {
    
    @IBOutlet var tableView: UITableView!

    // MARK:-懒加载自己的ViewModel属性
    fileprivate lazy var storeVM : BookStoreViewModel = BookStoreViewModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpUI()
        
        self.storeVM.requestData {
            
            print("finish")
            self.tableView.reloadData()
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}


extension BookStoreVC {
    
    fileprivate func setUpUI () {
        
        setBarButtonItem()
        
        setTableView()
        
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
    
    fileprivate func setTableView () {
        
        self.tableView.register(UINib.init(nibName: "BookStoreCell", bundle: nil), forCellReuseIdentifier: "BookStoreCell")
        self.tableView.register(UINib.init(nibName: "BookStoreLunboCell", bundle: nil), forCellReuseIdentifier: "BookStoreLunboCell")
        self.tableView.separatorStyle = .none
        self.tableView.showsVerticalScrollIndicator = false
    }
    
    
}

// MARK:-
extension BookStoreVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if storeVM.listArr.count == 0 {
            return 4
        }
        return storeVM.listArr.count+1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookStoreCell") as! BookStoreCell
        cell.selectionStyle = .none
        
        let cell1 = tableView.dequeueReusableCell(withIdentifier: "BookStoreLunboCell") as! BookStoreLunboCell
        cell1.selectionStyle = .none
        
        if storeVM.listArr.count == 0 {
            if indexPath.row == 0 {
                return cell1
            } else {
                return cell
            }
            
        } else {
            
            if indexPath.row == 0 {
                cell1.carouseView.dataArr = storeVM.lunboData
                
                cell1.lunboClick = { (model : LunboModel) -> () in
                    
                    self.activityToVC(lunboModel: model)
                }
                
                return cell1
                
            } else {
                
                let useModel = storeVM.listArr[indexPath.row-1]
                
                cell.model = useModel
                cell.selectionStyle = .none
                
                cell.intoTypeDetail = { (type:String, title:String) -> () in
                    print("跳转进入详情页面")
                    let  vc = BookCatagoryVC()
                    vc.selfType = type
                    vc.titleText = title
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                
                cell.bookDetailBlock  = { (param:Book) -> () in
                    
                    print(param)
                    let vc = BookDetailVC()
                    vc.titleText = param.bookName
                    vc.showBook = param
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                }
                return cell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 0 {
            return 108
        } else {
            return kScreenW
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
// MARK:- 轮播图点击跳转
    func activityToVC (lunboModel : LunboModel) {
        
        if lunboModel.type == "link" {
            
            let vc = ActivityVC()
            vc.linkUrl = lunboModel.content
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}



