//
//  JTCarouselView.swift
//  JTReader
//
//  Created by jiangT on 2017/5/7.
//  Copyright © 2017年 jiangT. All rights reserved.
//

import UIKit

protocol JTCarouseViewDelegate : class {
    
    func carouseView(_ carouseView : JTCarouselView, selectedIndex index : Int)
}

class JTCarouselView: UIView {

    weak var delegate : JTCarouseViewDelegate?
    
    fileprivate var leftImg = UIImageView()
    fileprivate var midImg = UIImageView()
    fileprivate var rightImg = UIImageView()
    
    fileprivate var currentIndex = 0
    
    fileprivate var timer = Timer()
    
    // MARK:-数据源
    var dataArr : [String]? {
        
        didSet {
            configureImage()
        }
    }
    
    // MARK:-滚动的scrollView
    fileprivate lazy var scrollView : UIScrollView = { [unowned self] in
       
        let sco = UIScrollView()
        sco.isPagingEnabled = true
        sco.frame = CGRect(x: 0, y: 0, width: kScreenW, height: 108)
        sco.contentSize = CGSize(width: kScreenW*3, height: 108)
        sco.bounces = false
        sco.backgroundColor = UIColor.lightGray
        sco.contentOffset = CGPoint(x: kScreenW, y: 0)
        sco.delegate = self
        return sco
    }()
    
    // MARK:-页面指示器
    fileprivate lazy var pageControl : UIPageControl = {
        
        let control = UIPageControl(frame: CGRect(x: kScreenW/2-60,
                                                  y: 88, width: 120, height: 20))
        control.isUserInteractionEnabled = false
        return control
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.clipsToBounds = true
        
        //添加scrollView
        addSubview(self.scrollView)
        
        //添加页面指示器
        addSubview(self.pageControl)
        
        //定时器
        configureTimer()
    }
    
}

// MARK:-初始化
extension JTCarouselView {
    
    fileprivate func configureImage () {
        
        self.leftImg = UIImageView(frame: CGRect(x: 0, y: 0,
                                                 width: kScreenW, height: 108))
        self.midImg = UIImageView(frame: CGRect(x: kScreenW, y: 0,
                                                width: kScreenW, height: 108));
        self.rightImg = UIImageView(frame: CGRect(x: 2*kScreenW, y: 0,
                                                  width: kScreenW, height: 108));
        self.scrollView.showsHorizontalScrollIndicator = false
        
        //设置初始时左中右三个imageView的图片（分别时数据源中最后一张，第一张，第二张图片）
        if(self.dataArr?.count != 0){
            reloadImage()
            self.pageControl.numberOfPages = (self.dataArr?.count)!
        }
        
        self.scrollView.addSubview(self.leftImg)
        self.scrollView.addSubview(self.midImg)
        self.scrollView.addSubview(self.rightImg)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.imageTap))
        midImg.isUserInteractionEnabled = true
        midImg.addGestureRecognizer(tap)
    }
    
    @objc fileprivate func imageTap() {
        print("点击轮播")
        delegate?.carouseView(self, selectedIndex: self.currentIndex)
    }
    
    
    fileprivate func reloadImage () {
        
        //当前显示的是第一张图片
        if self.currentIndex == 0 {
            self.leftImg.kf.setImage(with: URL(string : self.dataArr!.last!))
            self.midImg.kf.setImage(with: URL(string : self.dataArr!.first!))
            
            let rightIndex = (self.dataArr?.count)!>1 ? 1 : 0 //保护
            self.rightImg.kf.setImage(with: URL(string : self.dataArr![rightIndex]))
        }
            //当前显示的是最好一张图片
        else if self.currentIndex == (self.dataArr?.count)! - 1 {
            
            self.leftImg.kf.setImage(with: URL(string : self.dataArr![self.currentIndex-1]))
            self.midImg.kf.setImage(with: URL(string : self.dataArr!.last!))
            self.rightImg.kf.setImage(with: URL(string : self.dataArr!.first!))
        }
            //其他情况
        else{
            
            self.leftImg.kf.setImage(with: URL(string : self.dataArr![self.currentIndex-1]))
            self.midImg.kf.setImage(with: URL(string : self.dataArr![self.currentIndex]))
            self.rightImg.kf.setImage(with: URL(string : self.dataArr![self.currentIndex+1]))
        }
    }
    
    fileprivate func configureTimer () {
        
        timer = Timer.scheduledTimer(timeInterval: 8, target: self, selector: #selector(JTCarouselView.letScroll), userInfo: nil, repeats: true)
    }
    
    func letScroll () {
        let offset = CGPoint(x: 2*kScreenW, y: 0)
        self.scrollView.setContentOffset(offset, animated: true)
    }
    
}


// MARK:-实现 UIScrollViewDelegate
extension JTCarouselView : UIScrollViewDelegate {
    
    // MARK:-开始拖动  需要关闭定时器
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.timer.invalidate()
    }
    
    // MARK:-结束拖动  重新启动自动滚动计时器
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.configureTimer()
    }
    
    // MARK:-滚动完毕后触发
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        print("-----")
        
        //获取当前偏移量
        let offset = scrollView.contentOffset.x
        
        if(self.dataArr?.count != 0){
            
            //如果向左滑动（显示下一张）
            if(offset >= kScreenW*2){
                //还原偏移量
                scrollView.contentOffset = CGPoint(x: kScreenW, y: 0)
                //视图索引+1
                self.currentIndex = self.currentIndex + 1
                
                if self.currentIndex == self.dataArr?.count {
                    self.currentIndex = 0
                }
            }
            
            //如果向右滑动（显示上一张）
            if(offset <= 0){
                //还原偏移量
                scrollView.contentOffset = CGPoint(x: kScreenW, y: 0)
                //视图索引-1
                self.currentIndex = self.currentIndex - 1
                
                if self.currentIndex == -1 {
                    self.currentIndex = (self.dataArr?.count)! - 1
                }
            }
            
            //重新设置各个imageView的图片
            reloadImage()
            //设置页控制器当前页码
            self.pageControl.currentPage = self.currentIndex
        }

    }
    
}






