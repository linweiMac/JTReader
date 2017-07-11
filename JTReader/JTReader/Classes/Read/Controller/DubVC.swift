//
//  DubVC.swift
//  JTReader
//
//  Created by jiangT on 2017/7/7.
//  Copyright © 2017年 jiangT. All rights reserved.
//

import UIKit

class DubVC: JTBaseViewController {

    @IBOutlet var upView: UIView!
    @IBOutlet var backBtn: UIButton!
    @IBOutlet var titleLbl: UILabel!
    @IBOutlet var upViewHeight: NSLayoutConstraint!
    
    @IBOutlet var showImg: UIImageView!
    
    @IBOutlet var toolViewHeight: NSLayoutConstraint!
    @IBOutlet var toolView: UIView!
    
    @IBOutlet var toolUpView: UIView!
    @IBOutlet var toolDownView: UIView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.automaticallyAdjustsScrollViewInsets = false
        self.navigationController?.isNavigationBarHidden = true
        
        // MARK:-横竖屏设置
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.allowRotation = 2 //1表示支持横竖屏
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // MARK:-横竖屏设置
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.allowRotation = 0
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backClick(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
