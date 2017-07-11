//
//  LunboModel.swift
//  JTReader
//
//  Created by jiangT on 2017/7/5.
//  Copyright © 2017年 jiangT. All rights reserved.
//

import UIKit

class LunboModel: NSObject {

    /*
     content: "http://mp.weixin.qq.com/s/nCvsiD5XHgXK25aWc1b16Q",
     id: 3,
     createTime: "2017-01-06 11:00:28",
     imageUrl: "http://h.xueduoduo.com.cn/data5/image/2016/11/29/180137816543547.jpg",
     orderNum: 3,
     orderTime: "2017-01-06 11:00:28",
     type: "link",
     delFlag: "0"
     */
    
    var content = ""
    
    var id = NSNumber()
    
    var createTime = ""
    
    var imageUrl = ""
    
    var orderNum = NSNumber()
    
    var orderTime = ""
    
    var type = ""
    
    var delFlag = ""
    
    init(dict : [String : NSObject]) {
        super.init()
        
        setValuesForKeys(dict)
        
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}
