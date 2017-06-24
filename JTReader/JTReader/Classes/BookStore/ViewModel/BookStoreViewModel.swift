//
//  BookStoreViewModel.swift
//  JTReader
//
//  Created by jiangT on 2017/5/5.
//  Copyright © 2017年 jiangT. All rights reserved.
//

import UIKit

class BookStoreViewModel: NSObject {
    
    lazy var listArr = [channelModel]()
    
    lazy var lunboData = [String]()
    
    fileprivate lazy var chinaList = channelModel()
    fileprivate lazy var englishList = channelModel()
    fileprivate lazy var schoolList = channelModel()
}


extension BookStoreViewModel {
    
    func requestData(_ finishedCallBack : @escaping () -> () ) {
     
        //多线程   因为要请求三部分数据
        let dGroup = DispatchGroup()
        
        //进入组
        dGroup.enter()
        
        NetWorkTool.requestBookListData(type: "Chinese") { (result) in
            
            //1.将result转成字典
            guard let resultDict = result as? [String : NSObject] else { return }
            
            //2.取出数组
            guard let dataArr = resultDict["list"] as? [[String : NSObject]] else { return }
             
            //3.遍历字典，并且转成模型对象
            //3.2设置组属性
            self.chinaList.title = "中文绘本"
            self.chinaList.titleDes = "好看、好玩的绘本都在这里哦！"
            self.chinaList.type = "Chinese"
            
            //3.3获取主播数据
            for dict in dataArr {
                let book = Book(dict: dict)
                self.chinaList.bookList.append(book)
            }
            
            //离开组
            dGroup.leave()
            print("请求到中文绘本数据")
            
        }
        
        //进入组
        dGroup.enter()
        
        NetWorkTool.requestBookListData(type: "English") { (result) in
            
            //1.将result转成字典
            guard let resultDict = result as? [String : NSObject] else { return }
            
            //2.取出数组
            guard let dataArr = resultDict["list"] as? [[String : NSObject]] else { return }
            
            //3.遍历字典，并且转成模型对象
            //3.2设置组属性
            self.englishList.title = "英文绘本"
            self.englishList.titleDes = "好看、好玩的绘本都在这里哦！"
            self.englishList.type = "English"
            
            //3.3获取主播数据
            for dict in dataArr {
                let book = Book(dict: dict)
                self.englishList.bookList.append(book)
            }
            
            //离开组
            dGroup.leave()
            print("请求到英文绘本数据")
        }
        
        //进入组
        dGroup.enter()
        
        NetWorkTool.requestBookListData(type: "school") { (result) in
            
            //1.将result转成字典
            guard let resultDict = result as? [String : NSObject] else { return }
            
            //2.取出数组
            guard let dataArr = resultDict["list"] as? [[String : NSObject]] else { return }
            
            //3.遍历字典，并且转成模型对象
            //3.2设置组属性
            self.schoolList.title = "学校绘本"
            self.schoolList.titleDes = "好看、好玩的绘本都在这里哦！"
            self.schoolList.type = "school"
            
            //3.3获取主播数据
            for dict in dataArr {
                let book = Book.init(dict: dict)
                self.schoolList.bookList.append(book)
            }
            
            //离开组
            dGroup.leave()
            print("请求到学校绘本数据")
        }

        //进入组
        dGroup.enter()
        // MARK:-轮播图数据获取
        NetWorkTool.requestBookStoreLuoboData { (result) in
            
            //1.将result转成字典
            guard let resultDict = result as? [String : NSObject] else { return }
            
            //2.取出数组
            guard let dataArr = resultDict["list"] as? [[String : NSObject]] else { return }
            
            //3.遍历字典，并且转成模型对象
            var dataResources = [String]()
            for dict in dataArr {
                let banner = dict["imageUrl"] as! String
                dataResources.append(banner)
            }
            
            self.lunboData = dataResources
            
            //离开组
            dGroup.leave()
            print("请求到轮播图数据")
        }
        
        
        //所有数据都请求到
        dGroup.notify(queue: DispatchQueue.main) {
            print("所有数据都请求到了")
            
            self.listArr.insert(self.schoolList, at: 0)
            self.listArr.insert(self.englishList, at: 0)
            self.listArr.insert(self.chinaList, at: 0)
            
            finishedCallBack()
        }
        
        
    }
}


















