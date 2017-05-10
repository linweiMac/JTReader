//
//  PageContentView.swift
//  JT_LiveShow
//
//  Created by jiangT on 16/10/17.
//  Copyright © 2016年 Xdd. All rights reserved.
//

import UIKit

let ContentCellID = "ContentCellID"

// MARK:-定义协议
protocol PageContentViewDelagate : class {
    func pageContentView(_ contentView: PageContentView, progress: CGFloat, sourceIndex: Int, targetIndex: Int)
}

// MARK:-定义PageContentView类
class PageContentView: UIView {
    
    //定义属性 
    fileprivate var childVcs : [UIViewController]
    fileprivate weak var parentVc : UIViewController?
    fileprivate var startOffsetx : CGFloat = 0
    fileprivate var isForbidScroll : Bool = false
    weak var delegate : PageContentViewDelagate?
    
    //懒加载属性
    fileprivate lazy var collectionView : UICollectionView = { [weak self] in
       
        //创建layout
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = (self?.bounds.size)!
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        
        //创建UICollectionView
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.bounces = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: ContentCellID)
        
        return collectionView
    }()
    
    
    //自定一构造函数
    init(frame: CGRect, childVcs: [UIViewController], parentVC: UIViewController?) {
        
        self.childVcs = childVcs
        self.parentVc = parentVC
        super.init(frame: frame)
        
        //设置UI
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK:- SetUI
extension PageContentView {
    
    fileprivate func setupUI() {
        
        //1.讲所有的子控制器加到父控制器上
        for childVc in childVcs {
            parentVc?.addChildViewController(childVc)
        }
        
        //2.添加UICollectionView  用于在cell中存放控制器的view
        addSubview(collectionView)
        collectionView.frame = bounds
    }
}

// MARK:- UICollectionViewDataSource
extension PageContentView : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return childVcs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //创建cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContentCellID, for: indexPath)
        
        //设置内容
        for view in cell.contentView.subviews {
            view.removeFromSuperview()
        }
        
        let childVc = childVcs[indexPath.row]
        childVc.view.frame = cell.contentView.bounds
        cell.contentView.addSubview(childVc.view)
        
        return cell
    }
    
}

// MARK:-UICollectionViewDelegate
extension PageContentView : UICollectionViewDelegate {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        isForbidScroll = false
        
        startOffsetx = scrollView.contentOffset.x
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        //0 判断是否是点击事件  点击事件不需要通知代理去
        if isForbidScroll { return }
        
        //1.获取需要的数据
        var progress : CGFloat = 0
        var sourceIndex : Int = 0
        var targetIndex : Int = 0
        
        
        //2.判断左滑还是右滑
        let currentOffsetX = scrollView.contentOffset.x
        if currentOffsetX > startOffsetx {
            //左滑
            //1.计算progress
            progress = currentOffsetX / scrollView.bounds.width - floor(currentOffsetX / scrollView.bounds.width)
            
            //2.计算sourceIndex
            sourceIndex = Int(currentOffsetX / scrollView.bounds.width)
            
            //3.计算targetIndex
            targetIndex = sourceIndex + 1
            if targetIndex >= childVcs.count {
                targetIndex = childVcs.count - 1
            }
            
            //4.如果完全滑过去 
            if currentOffsetX - startOffsetx == scrollView.bounds.width {
                progress = 1
                targetIndex = sourceIndex
            }
            
        }else{
            //右滑
            //1.计算progress
            progress = 1 - (currentOffsetX / scrollView.bounds.width - floor(currentOffsetX / scrollView.bounds.width))
            
            //2.计算targetIndex
            targetIndex = Int(currentOffsetX / scrollView.bounds.width)
            
            //3.计算sourceIndex
            sourceIndex = targetIndex + 1
            if sourceIndex >= childVcs.count {
                sourceIndex = childVcs.count - 1
            }
            
            //4.如果完全滑过去
            if currentOffsetX - startOffsetx == scrollView.bounds.width {
                progress = 1
                targetIndex = sourceIndex
            }
        }
        
        //3.将progress/sourceIndex/targetIndex 传递给titleView
        delegate?.pageContentView(self, progress: progress, sourceIndex: sourceIndex, targetIndex: targetIndex)
        
        print(progress,sourceIndex,targetIndex)
        
        
    }
    
}

// MARK:- 对外暴露的方法
extension PageContentView {
    
    func setCurrentIndex(_ currentIndex : Int) {
        
        //需要禁止
        isForbidScroll = true
        
        let  offSetX = CGFloat(currentIndex) * frame.width
        collectionView.setContentOffset(CGPoint(x: offSetX, y: 0), animated: false)
        
    }
    
}


























