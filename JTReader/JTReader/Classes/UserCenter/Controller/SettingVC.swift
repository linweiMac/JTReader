//
//  SettingVC.swift
//  JTReader
//
//  Created by jiangT on 2017/7/5.
//  Copyright © 2017年 jiangT. All rights reserved.
//

import UIKit

class SettingVC: JTBaseViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var tableView: UITableView!
    
    
    //懒加载属性
    fileprivate lazy var dataArr : [[String]] = {
        
        var dataA = [[String]]()
        
        let a = ["视力保护", "清理缓存"]
        let b = ["关于我们", "问题反馈", "修改密码"]
        let c = ["退出登录"]
        
        dataA.append(a)
        dataA.append(b)
        dataA.append(c)
        
        return dataA
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        NotificationCenter.default.post(Notification.init(name: Notification.Name(rawValue: "WhenPop")))
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        
        
        //设置导航栏返回
        setBarButton()
        
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "cell")
        
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setBarButton () {
        
        let size = CGSize(width: 40, height: 40)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(imageName: "返回", hightLightImageName: "", text:"", size: size, target: self, action: #selector(backClick))
        
        let titleV = UILabel()
        titleV.frame = CGRect(x: 0, y: 0, width: 80, height: 40)
        titleV.text = "设置"
        titleV.textColor = UIColor.white
        titleV.backgroundColor = UIColor.clear
        titleV.textAlignment = .center
        self.navigationItem.titleView = titleV
    }
    
    @objc fileprivate func backClick () {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    
// MARK:- delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.dataArr.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let a = self.dataArr[section]
        return a.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        
        let useA = self.dataArr[indexPath.section]
        cell?.textLabel?.text = useA[indexPath.row]
        //最后一组
        if indexPath.section == self.dataArr.count-1 {
            
            cell?.textLabel?.textAlignment = .center
        }
        else {
            
            cell?.textLabel?.textAlignment = .left
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let v = UIView.init(frame: CGRect(x: 0, y: 0, width: kScreenW, height: 10))
        v.backgroundColor = UIColor.lightGray
        return v
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 8
    }
    
    
    
    
    
    
    
    

}




















