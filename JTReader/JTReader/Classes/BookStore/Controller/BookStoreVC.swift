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
            return 3
        }
        return storeVM.listArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookStoreCell") as! BookStoreCell
        
        if storeVM.listArr.count == 0 {
            return cell
        } else {
            
            let useModel = storeVM.listArr[indexPath.row]
            
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
                
            }
            
            return cell
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return kScreenW
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
}



