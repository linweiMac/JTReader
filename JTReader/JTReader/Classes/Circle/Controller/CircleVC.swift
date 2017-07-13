//
//  CircleVC.swift
//  JTReader
//
//  Created by jiangT on 2017/5/4.
//  Copyright © 2017年 jiangT. All rights reserved.
//

import UIKit
import UITableView_FDTemplateLayoutCell

class CircleVC: JTBaseViewController {

    @IBOutlet var tableView: UITableView!
    
    var pageNumber : Int?
    var listArr = [CircleModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        pageNumber = 1
        
        //初始化tableView
        setTableViewInfo()
        
        //数据
        getData()
        
    }

    func setTableViewInfo() {
        
        tableView.register(UINib.init(nibName: "CircleTopCell", bundle: nil), forCellReuseIdentifier: "CircleTopCell")
        tableView.register(UINib.init(nibName: "CircleTextCell", bundle: nil), forCellReuseIdentifier: "CircleTextCell")
        tableView.register(UINib.init(nibName: "CircleImageCell", bundle: nil), forCellReuseIdentifier: "CircleImageCell")
        tableView.register(UINib.init(nibName: "CircleObjcCell", bundle: nil), forCellReuseIdentifier: "CircleObjcCell")
        tableView.separatorStyle = .none
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// MARK: - 获取数据的方法
extension CircleVC {
    
    //加载更多数据
    func loadMoreData() {
        
    }
    
    //刷新数据
    func refreshData() {
        
    }
    
    //获取数据
    func getData() {
        
        NetWorkTool.requestCircleData(circleId: "", pageNumber: String.init(format: "%d", pageNumber!)) { (result) in
            
            //1.将result转成字典
            guard let resultDict = result as? [String : NSObject] else { return }
            
            //2.取出数组
            guard let dataArr = resultDict["list"] as? [[String : NSObject]] else { return }
            
            //3.遍历字典，并且转成模型对象
            for dict in dataArr {
                let model = CircleModel(dict: dict)
                self.listArr.append(model)
            }
            
            //4.刷新界面
            self.tableView.reloadData()
        }
    }
}


// MARK:- 协议方法
extension CircleVC : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if self.listArr.count == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CircleTextCell", for: indexPath)
            
            return cell
        }
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CircleTopCell", for: indexPath)
            return cell
        }
        else
        {
            let model = self.listArr[indexPath.row-1] as CircleModel
            
            if model.type == 1 //纯文字
            {
                let cell = tableView.dequeueReusableCell(withIdentifier: "CircleTextCell", for: indexPath)
                
                return cell
            }
            else if model.type == 2 //图片
            {
                let cell = tableView.dequeueReusableCell(withIdentifier: "CircleImageCell", for: indexPath)
                
                return cell
            }
            else // 绘本和配音
            {
                let cell = tableView.dequeueReusableCell(withIdentifier: "CircleObjcCell", for: indexPath)
                
                return cell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 0
        {
            return 70
        }
        else
        {
            return 340
        }
    }
}





