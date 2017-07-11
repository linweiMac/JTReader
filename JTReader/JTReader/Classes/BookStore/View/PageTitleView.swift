//
//  PageTitleView.swift
//  JT_LiveShow
//
//  Created by jiangT on 16/10/17.
//  Copyright © 2016年 Xdd. All rights reserved.
//

import UIKit

// MARK:-定义常量
let kScrollLineH : CGFloat  = 2
private let kNormalColor : (CGFloat, CGFloat, CGFloat) = (85, 85, 85)
private let kSelectColor : (CGFloat, CGFloat, CGFloat) = (255, 128, 0)

// MARK:-定义协议
protocol PageTitleViewDelagate : class {
    
    func pageTitleView(_ titleView : PageTitleView, selectedIndex index : Int)
}
// MARK:-定义PageTitleView类
class PageTitleView: UIView {
    
    //定义属性
    fileprivate var titles : [String]
    fileprivate var currentIndex :Int = 0
    weak var delegate : PageTitleViewDelagate?
    
    //懒加载属性
    fileprivate lazy var scrollView : UIScrollView = {
        
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.bounces = true
        scrollView.scrollsToTop = false
        scrollView.contentOffset = CGPoint(x: 0, y: 0)
        return scrollView
    }()
    
    fileprivate lazy var titleLabels : [UILabel] = [UILabel]()
    
    fileprivate lazy var scrollViewLine : UIView = {
       
        let scrollViewLine = UIView()
        scrollViewLine.backgroundColor = UIColor.orange
        return scrollViewLine
    }()
   
    //自定义构造函数
    init(frame: CGRect, isScrollEnable: Bool, titles: [String]) {
        
        self.titles = titles
        
        super.init(frame: frame)
        
        self.setUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


extension PageTitleView {
    
    fileprivate func setUI() {
        
        //1.添加ScroolView
        addSubview(scrollView)
        scrollView.frame = bounds
        
        //2.创建titles对应的label
        self.setTitleLables()
        
        //3.创建底部线条
        self.setScrollLine()
        
    }
    
    fileprivate func setTitleLables() {
        
        let labelY : CGFloat = 0
//        let labelW : CGFloat = kScreenW / 4
        
        var labelW : CGFloat
        if titles.count > 4 {
            labelW = 80
        } else {
            labelW = kScreenW / 4
        }
        
        let labelH : CGFloat = kTitleViewH
        
        for (index, title) in titles.enumerated() {
            
            //1.创建label
            let label = UILabel()
            
            //2.设置属性
            label.text = title
            label.textAlignment = .center
            label.font = UIFont.systemFont(ofSize: 13)
            label.tag = index
            label.textColor = UIColor(r: kNormalColor.0, g: kNormalColor.1, b: kNormalColor.2)
            
            //3.设置label的frame
            let labelX : CGFloat = CGFloat(index) * labelW
            label.frame = CGRect(x: labelX, y: labelY, width: labelW, height: labelH)
            
            //4.将label添加到scrollView
            scrollView.addSubview(label)
            titleLabels.append(label)
            
            //5.给label添加手势
            label.isUserInteractionEnabled = true
            let tapGes = UITapGestureRecognizer(target: self, action: #selector(self.titleLabelClick(_:)))
            label.addGestureRecognizer(tapGes)
        }
        
        scrollView.contentSize = CGSize(width: (labelW * CGFloat(titles.count)), height: 0);
    }
    
    fileprivate func setScrollLine() {
    
        //1.设置底部一条黑线
        let bottomLine = UIView()
        bottomLine.backgroundColor = UIColor.lightGray
        let bottomH : CGFloat = 0.5
        bottomLine.frame = CGRect(x: 0, y: frame.height-bottomH, width: kScreenW, height: bottomH)
        addSubview(bottomLine)
        
        //2.设置底下滑块
        
        guard let firstLabel = titleLabels.first else { return }
        firstLabel.textColor = UIColor(r: kSelectColor.0, g: kSelectColor.1, b: kSelectColor.2)
        
        scrollViewLine.frame = CGRect(x: firstLabel.frame.origin.x, y: frame.height-kScrollLineH, width: firstLabel.frame.width, height: kScrollLineH)
        scrollView.addSubview(scrollViewLine)
    }
    
//    private func
}

// MARK:-label的点击手势
extension PageTitleView {
    
    @objc fileprivate func titleLabelClick (_ tapGes : UITapGestureRecognizer) {
        
        //1.获取当前点击label的下标
        guard let currentLabel = tapGes.view as? UILabel else { return }
        
        //2.获取之前的label
        let oldLabel = titleLabels[currentIndex]
        
        if oldLabel == currentLabel {
            return
        }
        
        //3.切换文字的颜色
        currentLabel.textColor = UIColor(r: kSelectColor.0, g: kSelectColor.1, b: kSelectColor.2)
        oldLabel.textColor = UIColor(r: kNormalColor.0, g: kNormalColor.1, b: kNormalColor.2)
        
        //4.保存最新的lable的下标值
        currentIndex = currentLabel.tag
        
        //5.滚动条位置发生变化
        let scrollLineX = CGFloat(currentLabel.tag) * scrollViewLine.frame.width
        
        UIView.animate(withDuration: 0.15, animations: {
            self.scrollViewLine.frame.origin.x = scrollLineX
        }) 
        
        //6.通知代理
        delegate?.pageTitleView(self, selectedIndex: currentIndex)
        
    }
    
}

// MARK:-对外暴露的方法
extension PageTitleView {
    
    func setTitleWithProgress(_ progress: CGFloat, sourceIndex: Int, targetIndex: Int){
        
        //1.取出sourceLabel和targetLabel
        let sourceLabel = titleLabels[sourceIndex]
        let targetLabel = titleLabels[targetIndex]
        
        //2.处理滑块的逻辑
        let allMoveX = targetLabel.frame.origin.x - sourceLabel.frame.origin.x
        let moveX = progress * allMoveX
        scrollViewLine.frame.origin.x = sourceLabel.frame.origin.x + moveX
        
        //2.1处理scrollView的offset逻辑
        if progress == 1 {
            print("开始处理offset")
            let scrollViewW = self.scrollView.frame.width
            var offsetX:CGFloat = 0
            
            if targetLabel.center.x + scrollViewW/2 >= scrollView.contentSize.width {
                offsetX = scrollView.contentSize.width - scrollViewW
            }
            else if (targetLabel.center.x - scrollViewW/2) <= 0 {
                offsetX = 0
            }
            else {
                offsetX = targetLabel.center.x - scrollViewW/2
            }
            scrollView.setContentOffset(CGPoint(x:offsetX,y:0), animated: true)
        }
        
        
        //3.titleLabel的字体颜色变化
        let colorRang = (r: kSelectColor.0 - kNormalColor.0, g: kSelectColor.1 - kNormalColor.1, b: kSelectColor.2 - kNormalColor.2)
        
        //3.1 sourceLabel 颜色变化
        sourceLabel.textColor = UIColor(r: kSelectColor.0 - colorRang.0*progress, g: kSelectColor.1 - colorRang.1*progress, b: kSelectColor.2 - colorRang.2*progress)
        
        //3.2 targetLabel 颜色变化
        targetLabel.textColor = UIColor(r: kNormalColor.0 + colorRang.0*progress, g: kNormalColor.1 + colorRang.1*progress, b: kNormalColor.2 + colorRang.2*progress)
        
        //4. 记录最新的currentIndex
        currentIndex = targetIndex
        
    }
    
}


















