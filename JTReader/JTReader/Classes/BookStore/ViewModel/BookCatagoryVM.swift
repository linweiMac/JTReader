//
//  BookCatagoryVM.swift
//  JTReader
//
//  Created by jiangT on 2017/5/10.
//  Copyright © 2017年 jiangT. All rights reserved.
//

import UIKit

class BookCatagoryVM: NSObject {
    
    lazy var listArr = [CatagoryModel]()
    
    lazy var bookDataArr = [Book]()
    
}

extension BookCatagoryVM {
    
    func requestCatagoryList(type : String, finishedCalledBack : @escaping () -> ()) {
        
        NetWorkTool.requestCatagoryList(type: type) { (result) in
            
            //1.将result转成字典
            guard let resultDict = result as? [String : NSObject] else { return }
            
            //2.取出数组
            guard let dataArr = resultDict["catalogList"] as? [[String : NSObject]] else { return }
            
            //3.遍历字典，并且转成模型对象
            for dict in dataArr {
                let catagory = CatagoryModel(dict: dict)
                self.listArr.append(catagory)
            }
            
            finishedCalledBack()
        }
    }
    
    
    func requestCatagoryBookData(type : String, catelogId:String, pageNum:String, pageSize:String, finishedCalledBack : @escaping ([Book]) -> ()) {
        
        NetWorkTool.requestCatagoryData(type: type, catelogId: catelogId, pageNum: pageNum, pageSize: pageSize) { (result) in
            
            //1.将result转成字典
            guard let resultDict = result as? [String : NSObject] else { return }
            
            //2.取出数组
            guard let dataArr = resultDict["list"] as? [[String : NSObject]] else { return }
            
            //3.遍历字典，并且转成模型对象
            for dict in dataArr {
                let book = Book(dict: dict)
                self.bookDataArr.append(book)
            }
            
            finishedCalledBack(self.bookDataArr)
        }
    }
}

