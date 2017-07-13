//
//  DownLoadView.swift
//  JTReader
//
//  Created by jiangT on 2017/6/13.
//  Copyright © 2017年 jiangT. All rights reserved.
//

import UIKit

class DownLoadView: UIView, CAAnimationDelegate {

//    //风扇
//    var flowerView : UIImageView!
//    
//    var progressImageView : UIImageView!
//    
//    var progressBgImageView : UIImageView!
//    
//    var textLabel : UILabel!
    
    var gifImageView : UIImageView!
    
    var progressLbl : UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //跑步
        self.backgroundColor = UIColor.init(r: 18, g: 123, b: 198)
        //八爪鱼
//        self.backgroundColor = UIColor.init(r: 0, g: 173, b: 238)
        
        //设置背景
        setUpUI()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setUpUI () {
        
//        //背景图片
//        let imageBg = UIImageView.init(frame: self.bounds)
//        let image1 = UIImage.init(named: "bg")
//        imageBg.image = image1!.stretchableImage(withLeftCapWidth: Int(image1!.size.width/2.0), topCapHeight: Int(image1!.size.height/2.0))
//        self.addSubview(imageBg)
//        
//        //花瓣
//        flowerView = UIImageView.init(frame: CGRect(x: self.frame.size.width-32, y: 2, width: 30, height: 30))
//        let image2 = UIImage.init(named: "flower")
//        flowerView.image = image2!.stretchableImage(withLeftCapWidth: Int(image1!.size.width/2.0), topCapHeight: Int(image1!.size.height/2.0))
//        self.addSubview(flowerView)
//        
//        //背景
//        progressBgImageView = UIImageView.init(frame: CGRect(x: 4, y: 6.2, width: frame.size.width-8-30, height: 24))
//        progressBgImageView.contentMode = .left
//        progressBgImageView.backgroundColor = UIColor.clear
//        progressBgImageView.clipsToBounds = true
//        self.addSubview(progressBgImageView)
//        
//        //进度条
//        progressImageView = UIImageView.init(frame: CGRect(x: 4, y: 6.2, width: 0, height: 24))
//        let image3 = UIImage.init(named: "progress")
//        progressImageView.image = image3!.stretchableImage(withLeftCapWidth: Int(image1!.size.width/2.0), topCapHeight: Int(image1!.size.height/2.0))
//        progressImageView.contentMode = .left
//        progressImageView.clipsToBounds = true
//        self.addSubview(progressImageView)
//        
//        //显示100%文字的
//        textLabel = UILabel.init(frame: flowerView.frame)
//        textLabel.text = "100%"
//        textLabel.textColor = UIColor.white
//        textLabel.font = UIFont.boldSystemFont(ofSize: 11)
//        textLabel.isHidden = true
//        self.addSubview(textLabel)
        
        
        //显示gif图片
        gifImageView = UIImageView.init(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
        gifImageView.center = self.center
        gifImageView.contentMode = .scaleAspectFit
        gifImageView.animationImages = [UIImage.init(named: "type1_loading1")!, UIImage.init(named: "type1_loading2")!, UIImage.init(named: "type1_loading3")!, UIImage.init(named: "type1_loading4")!, UIImage.init(named: "type1_loading5")!,UIImage.init(named: "type1_loading6")!, UIImage.init(named: "type1_loading1")!, UIImage.init(named: "type1_loading2")!, UIImage.init(named: "type1_loading3")!, UIImage.init(named: "type1_loading4")!, UIImage.init(named: "type1_loading5")!,UIImage.init(named: "type1_loading6")!]
        gifImageView.animationDuration = 2
        gifImageView.animationRepeatCount = 100000
        self.addSubview(gifImageView)
        
        //进度条
        progressLbl = UILabel.init(frame: CGRect(x: 0, y: 320, width: 0, height: 5))
        progressLbl.backgroundColor = UIColor.white
        progressLbl.layer.cornerRadius = 2.5
        progressLbl.layer.masksToBounds = true
        self.addSubview(progressLbl)
    }
    
    
    //开始加载
    public func startLoading() {
        
        gifImageView.startAnimating()
        
//        //花瓣转动
//        let rotationAnimation = CABasicAnimation(keyPath: "transform")
//        rotationAnimation.fromValue = NSValue(caTransform3D: CATransform3DIdentity)
//        rotationAnimation.toValue = NSValue(caTransform3D: CATransform3DRotate(flowerView.layer.transform, .pi, 0, 0, 1))
//        rotationAnimation.isCumulative = true
//        rotationAnimation.duration = 0.5
//        rotationAnimation.repeatCount = MAXFLOAT
//        flowerView.layer.add(rotationAnimation, forKey: "flowerAnimation")
//        
//        //树叶效果
//        let leafLayer = CALayer()
//        leafLayer.contents = UIImage.init(named: "leaf")?.cgImage
//        leafLayer.bounds = CGRect(x: 0, y: 0, width: 10, height: 10)
//        leafLayer.position = CGPoint(x: progressBgImageView.frame.origin.x + progressBgImageView.frame.size.width, y: 8)
//        progressBgImageView.layer.addSublayer(leafLayer)
        
    }
    
    //结束加载
    public func stopLoading() {
        
        gifImageView.stopAnimating()
        
//        //花瓣停止转动
//        flowerView.layer.removeAllAnimations()
//        
//        //花瓣缩小
//        let scaleAni = CABasicAnimation(keyPath: "transform.scale")
//        scaleAni.fromValue = 1
//        scaleAni.toValue = 0
//        scaleAni.duration = 0.5
//        scaleAni.isRemovedOnCompletion = false
//        scaleAni.fillMode = kCAFillModeForwards
//        flowerView.layer.add(scaleAni, forKey: nil)
//        
//        //文字显示
//        textLabel.isHidden = false
//        scaleAni.fromValue = 0
//        scaleAni.toValue = 1
//        textLabel.layer.add(scaleAni, forKey: nil)
    }
    
    //设置进度条
    public func setProgress(rate : CGFloat) {
        
        progressLbl.frame = CGRect(x: 0, y: 320, width: self.bounds.size.width*rate, height: 5)
        
//        //进度条
//        progressImageView.frame = CGRect(x: progressImageView.frame.origin.x, y: progressImageView.frame.origin.y, width: progressBgImageView.frame.width * rate, height: progressImageView.frame.size.height)
//        
//        //树叶效果
//        let leafLayer = CALayer()
//        leafLayer.contents = UIImage.init(named: "leaf")?.cgImage
//        leafLayer.bounds = CGRect(x: 0, y: 0, width: 10, height: 10)
//        leafLayer.position = CGPoint(x: progressBgImageView.frame.origin.x + progressBgImageView.frame.size.width, y: 8)
//        progressBgImageView.layer.addSublayer(leafLayer)
//        
//        //树叶移动路径动画
//        let keyAnimation = CAKeyframeAnimation(keyPath: "position")
//        
//        let p1 = NSValue.init(cgPoint: leafLayer.position)
//        
//        let a = progressBgImageView.frame.origin.x + (progressBgImageView.frame.size.width*3)/4.0
//        let b = CGFloat(arc4random()%(UInt32(progressBgImageView.frame.size.width/4.0)))
//        let c = progressBgImageView.frame.origin.y + CGFloat(arc4random()%(UInt32(progressBgImageView.frame.size.height)))
//        let p2 = NSValue.init(cgPoint: CGPoint(x: a+b, y: c))
//        
//        let k1 = progressBgImageView.frame.origin.x + progressBgImageView.frame.size.width/2.0
//        let k2 = CGFloat(arc4random()%(UInt32(progressBgImageView.frame.size.width/4.0)))
//        let k3 = progressBgImageView.frame.origin.y + CGFloat(arc4random()%(UInt32(progressBgImageView.frame.size.height)))
//        let p3 = NSValue.init(cgPoint: CGPoint(x: k1+k2, y: k3))
//        
//        let b1 = progressBgImageView.frame.origin.x + progressBgImageView.frame.size.width/4.0
//        let b2 = CGFloat(arc4random()%(UInt32(progressBgImageView.frame.size.width/4.0)))
//        let b3 = progressBgImageView.frame.origin.y + CGFloat(arc4random()%(UInt32(progressBgImageView.frame.size.height)))
//        let p4 = NSValue.init(cgPoint: CGPoint(x: b1+b2, y: b3))
//        
//        
//        let p5 = NSValue.init(cgPoint: CGPoint(x: progressBgImageView.frame.origin.x+5, y: b3))
//        
//        keyAnimation.values = [p1, p2, p3, p4, p5]
//        
//        //树叶旋转动画
//        let rotationAni = CABasicAnimation(keyPath: "transform.rotation.z")
//        rotationAni.fromValue = 0
//        let zz = Double(arc4random()%(36*6))
//        rotationAni.toValue = .pi/18.0 * zz
//        
//        
//        let group = CAAnimationGroup.init()
//        group.animations = [rotationAni, keyAnimation]
//        group.duration = 8
//        group.delegate = self as CAAnimationDelegate
//        group.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionDefault)
//        group.setValue(leafLayer, forKey: "leafLayer")
//        
//        leafLayer.add(group, forKey: nil)

    }
    
//    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
//        
//        let layer = anim.value(forKey: "leafLayer") as? CALayer
//        layer?.removeFromSuperlayer()
//                
//    }
}










