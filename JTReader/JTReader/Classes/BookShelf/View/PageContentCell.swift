//
//  PageContentCell.swift
//  JTReader
//
//  Created by jiangT on 2017/6/28.
//  Copyright © 2017年 jiangT. All rights reserved.
//

import UIKit

class PageContentCell: UICollectionViewCell {

    public var model : PageContent? {
        
        didSet{
            setSelfInfo(model: model!)
        }
    }
    
    @IBOutlet var bgView: UIView!
    
    @IBOutlet var imageView: UIImageView!
    
    var isRightPage : Bool?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        //开启反锯齿
        self.layer.allowsEdgeAntialiasing = true
        
    }
    
    func setSelfInfo (model : PageContent) {
        
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.allDomainsMask, true)
        let documentPath = paths[0]
        
        //解析文件夹内  temp.txt 文件
        let pathAll = documentPath.appendingFormat("/zip/book%@", model.bookId.stringValue)
        
        let useStr = model.imageUrl.lastPathComponent
        let imgPath = pathAll.appendingFormat("/%@", useStr)
        
        if FileManager.default.fileExists(atPath: imgPath) {
            let image = UIImage.init(contentsOfFile: imgPath)
            self.imageView.image = image
        }
        
    }
    

    //默认自定义布局,布局圆角 和 中心线
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        
        //判断cell的奇数偶数
        if layoutAttributes.indexPath.item % 2 == 0 {
            
            //如果偶数,则中心线在左边,页面右边有圆角,左边没有圆角
            isRightPage = true
            self.layer.anchorPoint = CGPoint(x: 0, y: 0.5)
            
        } else {
            
            isRightPage = false
            self.layer.anchorPoint = CGPoint(x: 1, y: 0.5)
            
        }
        
        //圆角设置
        let bezier : UIBezierPath
        
        if isRightPage! {
            bezier = UIBezierPath.init(roundedRect: self.bgView.bounds, byRoundingCorners: [UIRectCorner.topRight, UIRectCorner.bottomRight], cornerRadii: CGSize(width: 10, height: 10))
        } else {
            bezier = UIBezierPath.init(roundedRect: self.bgView.bounds, byRoundingCorners: [UIRectCorner.topLeft, UIRectCorner.bottomLeft], cornerRadii: CGSize(width: 10, height: 10))
        }
        
        
        //CAShapeLayer: 通过给定的贝塞尔曲线UIBezierPath,在空间中作图
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bgView.bounds
        maskLayer.path = bezier.cgPath
        self.bgView.layer.mask = maskLayer
        self.bgView.clipsToBounds = true
    }
    
}















