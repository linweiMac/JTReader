//
//  JTDownLoadMode.swift
//  JTReader
//
//  Created by jiangT on 2017/6/15.
//  Copyright © 2017年 jiangT. All rights reserved.
//

import UIKit

class JTDownLoadMode: BaseObject {

    /*
     /* 下载地址 */
     @property (nonatomic, strong) NSString *downUrl;
     /* 下载进度 */
     @property (nonatomic, assign) float progress;
     /* 用于可恢复的下载任务的数据 */
     @property (nonatomic, strong) NSData *partialData;
     /* 下载完成后保存的文件路径 */
     @property (strong, nonatomic) NSString *fileName;
     */
    
    public var downurl : String?
    
    public var progress : Double?
    
    public var partialData : Data?
    
    public var filePath : String?
    
    override init() {
        super.init()
        
    }
    
    required init!(coder aDecoder: NSCoder!) {
        super.init(coder: aDecoder)
    }
    
    override func encode(with aCoder: NSCoder){
        super.encode(with: aCoder)
    }
    
}
