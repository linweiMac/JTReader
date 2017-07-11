//
//  MJGifHeader.swift
//  JTReader
//
//  Created by jiangT on 2017/7/6.
//  Copyright © 2017年 jiangT. All rights reserved.
//

import UIKit
import MJRefresh

class MJGifHeader: MJRefreshGifHeader {
    
    override func prepare() {
        super.prepare()
        
        var images = [UIImage]()
        
        for i in 0..<10 {
            let image = UIImage.init(named: String(format: "loading_min_%ld", i+1))
            images.append(image!)
        }
        
        self.setImages(images, for: MJRefreshState.idle)
        
        // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
        var images1 = [UIImage]()
        
        for index in 0..<10 {
            let image = UIImage.init(named: String(format: "loading_min_%ld", index+1))
            images1.append(image!)
        }
        
        self.setImages(images1, for: MJRefreshState.pulling)
        
        // 设置正在刷新状态的动画图片
        self.setImages(images1, for: MJRefreshState.refreshing)
    }

}
