//
//  CircleModel.swift
//  JTReader
//
//  Created by jiangT on 2017/7/10.
//  Copyright © 2017年 jiangT. All rights reserved.
//

import UIKit

class CircleModel: BaseObject {
    
    //发帖人信息
    var userId : NSNumber?
    var userSec : String?
    var userName : String?
    var logoUrl : String?
    var level : NSNumber?
    
    //帖子信息
    var content : String?
    var createTime : String?
    var topFlag : String?
    var essenceFlag : String?
    var replyNum : NSNumber?
    var praiseNum : NSNumber?
    var id : NSNumber?
    var isPraise : NSNumber?
    
    var circleId : NSNumber? //所在圈子Id
    
    var objectId : NSNumber? //分享内容的id
    var objectType : String? //分享内容的类型
    
    var attachUrl : String?
    var objectContent : String?
    
    var attachArr : [[String : NSObject]]?
    
    var book : Book?
    var dubModel : ShareDubModel?
    
    var type : Int?
    
    init(dict : [String : NSObject]) {
        super.init()
        
        setValuesForKeys(dict)
    
        if self.objectId != nil { //分享的书本或是配音
            
//            let data = self.objectContent?.data(using: String.Encoding.utf8)!
//            
//            let dic = try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! [String : NSObject]
            
            let dict = JsonHelper.jsonObject(fromJsonString: self.objectContent) as! [String : NSObject]
            
            
            if self.objectType == "book" {
                //书本
                let book = Book.init(dict: dict)
                self.book = book
            }
            else if self.objectType == "record" {
                //配音
                let model = ShareDubModel.init(dict: dict)
                self.dubModel = model
            }
        }
        
        if self.attachUrl != nil {
            
            let arrs = JsonHelper.jsonObject(fromJsonString: self.attachUrl)
            self.attachArr = arrs as? [[String : NSObject]]
//            let data : Data = self.attachUrl!.data(using: String.Encoding.utf8)!
//            let arr = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! [[String : NSObject]]
//            self.attachArr = arr
            
        }
        
        judgeType()
    }
    
    func judgeType() {
        
        if self.dubModel != nil && self.book == nil { //配音
            type = 4
        }
        else if self.dubModel == nil && self.book != nil { //绘本
            type = 3
        }
        else if self.dubModel == nil && self.book == nil && self.attachArr != nil {
            //有图片
            type = 2
        }
        else {
            //纯文字
            type = 1
        }
    }
    
    
    required init!(coder aDecoder: NSCoder!) {
        fatalError("init(coder:) has not been implemented")
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}
