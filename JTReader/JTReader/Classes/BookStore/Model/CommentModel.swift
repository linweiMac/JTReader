//
//  CommentModel.swift
//  JTReader
//
//  Created by jiangT on 2017/6/4.
//  Copyright © 2017年 jiangT. All rights reserved.
//

import UIKit

class CommentModel: NSObject {

    /*
     /*
     "content":"细菌有毒，我们要多洗手",
     "createTime":"2016-09-13 14:31:31",
     "userId":2,
     "userSex":"男",
     "score":5,
     "userName":"老师",
     "logoUrl":"http://h.xueduoduo.com.cn/data5/image/2016/10/28/155601804376672.jpg"
     */
     */
    
    var logoUrl = ""
    
    var createTime = ""
    
    var userId = NSNumber()
    
    var userSec = ""
    
    var score = NSNumber()
    
    var userName = ""
    
    var content = ""
    
    init(dict : [String : NSObject]) {
        super.init()
        
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    
}
