//
//  UIBarButtonItem+Category.swift
//  JTReader
//
//  Created by jiangT on 2017/5/3.
//  Copyright © 2017年 jiangT. All rights reserved.
//

import Foundation
import UIKit

extension UIBarButtonItem {
    
    convenience init (imageName:String, hightLightImageName:String?=nil, text:String, size:CGSize, target: AnyObject?=nil, action:Selector?) {
        
        //创建按钮
        let btn = UIButton(type: .custom)
        
        //设置图片
        btn.setImage(UIImage.init(named: imageName), for: .normal)
        
        if hightLightImageName != nil {
            
            btn.setImage(UIImage.init(named: hightLightImageName!), for: .highlighted)
            
        }
        //设置文字
        btn.setTitle(text, for: .normal)
        
        //设置尺寸
        if size == CGSize.zero {
            btn.sizeToFit()
        }
        
        btn.frame = CGRect(origin: CGPoint.zero, size: size)
        
        //添加事件
        btn.addTarget(target, action: action!, for: .touchUpInside)
        
        self.init(customView: btn)
    }
}
