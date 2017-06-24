//
//  PageContent.swift
//  JTReader
//
//  Created by jiangT on 2017/6/20.
//  Copyright © 2017年 jiangT. All rights reserved.
//

import UIKit

class PageContent: BaseObject {

    /*
     "id": 122082,
     "imageUrl": "http://180.153.59.193:8083/updir/dybgkr20160824/017.jpg",
     "pageNo": 17,
     "englishUrl": "",
     "bookId": 231,
     "mp3Url": "http://180.153.59.193:8083/updir/dybgkr20160824/017.mp3"
     */
    
    var id = NSNumber()
    
    var imageUrl : NSString = ""
    
    var pageNo = NSNumber()
    
    var englishUrl = ""
    
    var bookId = NSNumber()
    
    var mp3Url : NSString = ""
    
//    init(dict : [String : NSObject]) {
//        super.init()
//        
//        setValuesForKeys(dict)
//        
//    }
    
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
