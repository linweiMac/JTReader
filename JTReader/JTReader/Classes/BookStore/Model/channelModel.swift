//
//  channelModel.swift
//  JTReader
//
//  Created by jiangT on 2017/5/5.
//  Copyright © 2017年 jiangT. All rights reserved.
//

import UIKit

class channelModel: NSObject {

    //书本列表数组
    var bookList = [Book]()
    
    //频道类型
    var type : String = ""
    
    //用于显示频道的标题
    var title : String = ""
    
    //该组显示的图标
    var titleDes : String = ""
    
    init(dict : [String : NSObject]) {
        
        super.init()
        
        setValuesForKeys(dict)
        
    }
    
    override init() {
        
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    
}
