//
//  ShareDubModel.swift
//  JTReader
//
//  Created by jiangT on 2017/7/11.
//  Copyright © 2017年 jiangT. All rights reserved.
//

import UIKit

class ShareDubModel: BaseObject {
    
    
    
    init(dict : [String : NSObject]) {
        super.init()
        
        setValuesForKeys(dict)
        
    }
    
    required init!(coder aDecoder: NSCoder!) {
        fatalError("init(coder:) has not been implemented")
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }

}
