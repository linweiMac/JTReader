//
//  CatagoryModel.swift
//  JTReader
//
//  Created by jiangT on 2017/5/10.
//  Copyright © 2017年 jiangT. All rights reserved.
//

import UIKit

class CatagoryModel: NSObject {

    /*
     "id":137,
     "catalogName":"爱与分享",
     "logoUrl":"http://180.153.59.193:8083/updir/homeleft/cn/cn-ayfx.png"
     */
    
    var catalogName = ""
    
    var logoUrl = ""
    
    var id = NSNumber()
    
    init(dict : [String : NSObject]) {
        super.init()
        
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    
}
