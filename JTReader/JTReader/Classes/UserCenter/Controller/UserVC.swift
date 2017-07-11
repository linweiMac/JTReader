//
//  UserVC.swift
//  JTReader
//
//  Created by jiangT on 2017/6/28.
//  Copyright © 2017年 jiangT. All rights reserved.
//

import UIKit
import MMDrawerController

class UserVC: JTBaseViewController, UINavigationControllerDelegate {

    var dataArr = [String]()
    
    var currentImage : UIImageView?
    
    @IBOutlet var tableView: UITableView!
    
    @IBOutlet var userLogo: UIImageView!
    @IBOutlet var userNamelbl: UILabel!
    
    @IBOutlet var funcView: UIView!
    @IBOutlet var setBtn: UIButton!
    @IBOutlet var nightBtn: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = true
        
//        settingDrawerWhenPop()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //设置导航栏
        self.navigationController?.navigationBar.barTintColor = UIColor.init(r: 46, g: 46, b: 46)
        
        initDataInfo()
        
        NotificationCenter.default.addObserver(self, selector: #selector(whenPop), name: NSNotification.Name(rawValue: "WhenPop"), object: nil)
                
    }
    
    @objc func whenPop() {
        
        settingDrawerWhenPop()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initDataInfo() {
        
        dataArr = ["阅读记录","阅读报告"]
        
        self.tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "cell")
        self.tableView.separatorStyle = .none
        self.tableView.showsVerticalScrollIndicator = false
        
        
    }
    
    
    @IBAction func setBtnClick(_ sender: UIButton) {
        
        print("设置点击")
        addCurrentPageScreenshot()
        settingDrawerWhenPush()
        
        let vc = SettingVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    /// 添加当前页面的截屏
    func addCurrentPageScreenshot() {
        
        let image = self.screenShot()
        let imageV = UIImageView.init(image: image)
        self.view.addSubview(imageV)
        
        self.currentImage = imageV
    }
    
    /// 设置抽屉视图pop后的状态
    func settingDrawerWhenPop() {
        
        self.mm_drawerController.maximumLeftDrawerWidth = 320
        self.mm_drawerController.showsShadow = true
        self.mm_drawerController.closeDrawerGestureModeMask = .all
        self.currentImage?.removeFromSuperview()
        self.currentImage = nil
    }
    
    /// 设置抽屉视图push后的状态
    func settingDrawerWhenPush() {
        
        self.mm_drawerController.maximumLeftDrawerWidth = UIScreen.main.bounds.size.width
        self.mm_drawerController.showsShadow = false
        
        self.mm_drawerController.closeDrawerGestureModeMask = .custom
        
    }
    
    @IBAction func nightBtnClick(_ sender: UIButton) {
        
        print("夜间模式点击")
        
    }
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        
        
        
    }

}


extension UserVC : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dataArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        
        cell.textLabel?.text = dataArr[indexPath.row]
        
         return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 44
    }
    
}


