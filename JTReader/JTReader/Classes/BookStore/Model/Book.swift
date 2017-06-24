//
//  Book.swift
//  JTReader
//
//  Created by jiangT on 2017/5/5.
//  Copyright © 2017年 jiangT. All rights reserved.
//

import UIKit

class Book: BaseObject {

    /*
     allowed: 0
     id: 203,
     catalogName: "爱与分享",
     count: 616,
     isNew: 0,
     score: 4,
     catalogId: 137,
     zipUrl: "http://180.153.59.193:8083/updir/book203/book203.zip",
     isCourse: "0",
     recommend: 0,
     bookDesc: "这是一个非常有趣而温馨的小故事。故事中的主人公是 一只饥肠辘辘的小老鼠，在面对美味比萨的时候，它没有选择独自享用，而是找来小伙伴们把它搬回家，和大家一起分享。通过小老鼠找食物、搬运比萨和一起吃比萨的整个过程，让小朋友们在阅读中感受合作和分享的快乐。 成人和孩子阅读时，可以根据画面的内容提出问题引发孩子思考：如果你有一块大比萨会怎么做呢？引导小朋友理解故事传递的内容。还可以利用故事中的句式“......像...... 像......”引导孩子模仿说话。也可以和小朋友一起在家里制作比萨，带到幼儿园和小朋友一起分享，体验分享的快乐。",
     bookIcon: "http://180.153.59.193:8083/updir/20160824/ykdps20160824.jpg",
     bookName: "一块大披萨"
     */
    
    var catalogName = ""
    
    var bookName = ""
    
    var bookIcon = ""
    
    var bookDesc = ""
    
    var zipUrl = ""
    
    var score = NSNumber()
    
    var id = NSNumber()
    
    init(dict : [String : NSObject]) {
        super.init()
        
        setValuesForKeys(dict)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
//        fatalError("init(coder:) has not been implemented")
    }
    
    override func encode(with aCoder: NSCoder){
        super.encode(with: aCoder)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    
}
