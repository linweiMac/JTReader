//
//  NetWorkTool.swift
//  JTReader
//
//  Created by jiangT on 2017/5/2.
//  Copyright © 2017年 jiangT. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class NetWorkTool: NSObject {
    
// MARK:-获取书本评论列表  book/queryCommentList
    class func requestBookCommentData (bookId:String, pageNum:String, finishedCallback : @escaping (_ result: AnyObject) -> ()) {
        
        let parameters = ["bookId": bookId, "pageNum":pageNum, "pageSize":"20"]
        
        self.requestData(URLString: "book/queryCommentList", parameters: parameters, finishedCallback: finishedCallback)
    }
    
// MARK:-获取分类列表     book/queryCatalogList
    class func requestCatagoryList (type:String, finishedCallback : @escaping (_ result: AnyObject) -> ()) {
        
        let parameters = ["schoolId":"521","type":type]
        
        self.requestData(URLString: "book/queryCatalogList", parameters: parameters, finishedCallback: finishedCallback)
    }

// MARK:-获取各个分类下书目
    class func requestCatagoryData (type:String, catelogId:String, pageNum:String, pageSize:String, finishedCallback : @escaping (_ result: AnyObject) -> ()) {
        
        let parameters = ["schoolId":"521", "userId":"134738", "type":type, "grade":"", "catalogId":catelogId,"pageNum":pageNum, "pageSize":pageSize]
        
        self.requestData(URLString: "book/queryBookList", parameters: parameters, finishedCallback: finishedCallback)
    }
    
// MARK:-获取轮播图   circle/queryBannerList
    class func requestBookStoreLuoboData (finishedCallback : @escaping (_ result: AnyObject) -> ()) {
        
        self.requestData(URLString: "circle/queryBannerList", parameters: nil, finishedCallback: finishedCallback)
    }
    
// MARK:-获取书城列表
    class func requestBookListData (type:String, finishedCallback : @escaping (_ result: AnyObject) -> ()) {
        
        let parameters = ["schoolId":"521", "userId":"134738", "type":type, "grade":"", "catelogId":"","pageNum":"1", "pageSize":"6"]
        
        self.requestData(URLString: "book/queryBookList", parameters: parameters, finishedCallback: finishedCallback)
    }
    
// MARK:-总的请求方法
    class func requestData(URLString: String, parameters: [String : String]? = nil, finishedCallback : @escaping (_ result: AnyObject) -> ()) {
        
        //获取类型
        let metod =  HTTPMethod.post
        
        let urlStr = (kAPIBaseURLString as String)+URLString
        
        //发送网络请求
        Alamofire.request(urlStr, method: metod, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { response in
            
            switch response.result {
            case .success( _):
                //获取结果
                guard let request = response.result.value else {
                    print(response.result.error!)
                    
                    return
                }
                
//                let jsonData = JSON(request)
                
                //结果回调出去
                finishedCallback(request as AnyObject)
                
            case .failure(let error):
                print(error)
                
            }
        }
    }
    
    
//    func postRequest(urlString : String, params : [String : Any], success : @escaping (_ response : [String : AnyObject])->(), failture : @escaping (_ error : Error)->()) {
//        
//        Alamofire.request(urlString, method: HTTPMethod.post, parameters: params).responseJSON { (response) in
//            switch response.result{
//            case .success:
//                if let value = response.result.value as? [String: AnyObject] {
//                    success(value)
//                    let json = JSON(value)
//                    PrintLog(json)
//                }
//            case .failure(let error):
//                failture(error)
//                PrintLog("error:\(error)")
//            }
//            
//            }
//        }
//    }
    
}












