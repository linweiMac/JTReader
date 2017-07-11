//
//  BookCatagoryVC.swift
//  JTReader
//
//  Created by jiangT on 2017/5/5.
//  Copyright © 2017年 jiangT. All rights reserved.
//

import UIKit

let kTitleViewH : CGFloat = 40

class BookCatagoryVC: JTBaseViewController {
    
    public var selfType : String!
    public var titleText : String!
    
    //选择的类型Id
    fileprivate var categoryId = ""
    
    // MARK:-懒加载自己的ViewModel属性
    fileprivate lazy var catagoryVM : BookCatagoryVM = BookCatagoryVM()
    
    
    fileprivate var titlesView : PageTitleView!
    
    fileprivate var pageContentView : PageContentView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        self.automaticallyAdjustsScrollViewInsets = false
        self.view.backgroundColor = UIColor.white
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

extension BookCatagoryVC {
    
    fileprivate func setUpUI () {
        
        setBarButtonItem()
 
        //获取数据创建头部以及contentView titlesView
        getTitlesData()
        
    }
    
    fileprivate func setBarButtonItem () {
        
        let size = CGSize(width: 40, height: 40)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(imageName: "搜索", hightLightImageName: "", text:"",size: size, target: self, action: #selector(searchClick))
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(imageName: "返回", hightLightImageName: "", text:"", size: size, target: self, action: #selector(backClick))
        
        let titleV = UILabel()
        titleV.frame = CGRect(x: 0, y: 0, width: 80, height: 40)
        titleV.text = titleText
        titleV.textColor = UIColor.white
        titleV.backgroundColor = UIColor.clear
        titleV.textAlignment = .center
        self.navigationItem.titleView = titleV
    }
    
    @objc fileprivate func searchClick () {
        print(#function)
        let vc = SearchVC()
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    @objc fileprivate func backClick () {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK:-获取分类列表信息
    fileprivate func getTitlesData () {
        
        self.catagoryVM.requestCatagoryList(type: selfType) {
         
            var titles = [String]()
            var idArr = [NSNumber]()
            for model in self.catagoryVM.listArr {
                titles.append(model.catalogName)
                idArr.append(model.id)
            }
            
            self.createTitlesView(titles: titles)
            
            self.createContentView(idArr: idArr)
        }
    }
    
    // MARK:-创建头部分类条
    fileprivate func createTitlesView (titles : [String]) {
        
        let titleFrame = CGRect(x: 0, y: kStatusH+kNavGationH, width: kScreenW, height: kTitleViewH)
        titlesView = PageTitleView(frame: titleFrame, isScrollEnable: false, titles: titles)
        titlesView.delegate = self
        
        self.view.addSubview(titlesView)
    }
    
    
    // MARK:-创建分类详情界面
    func createContentView(idArr : [NSNumber]) {
        
        //1.frame
        let contentH = kScreenH-kStatusH-kNavGationH-kTitleViewH
        let contentFrame = CGRect(x: 0, y: kStatusH+kNavGationH+kTitleViewH, width: kScreenW, height: contentH)
        
        //2.创建控制器
        var childVcs = [CatagorySonVC]()
        
        for index in 0..<idArr.count {
            let vc = CatagorySonVC()
            
            vc.categoryId = idArr[index].stringValue
            vc.type = self.selfType
            
            vc.view.backgroundColor = UIColor.white
            childVcs.append(vc)
        }
        
        let contentView = PageContentView(frame: contentFrame, childVcs: childVcs, parentVC: self)
        
        contentView.delegate = self
        pageContentView = contentView
        self.view.addSubview(contentView)
    }
    
}


// MARK:-遵守PageTitleView的协议

extension BookCatagoryVC : PageTitleViewDelagate {
    
    func pageTitleView(_ titleView: PageTitleView, selectedIndex index: Int) {
        
        print(index)
        pageContentView.setCurrentIndex(index)
        
        
        
    }
    
}

// MARK:-遵守PageContentViewDelegaet
extension BookCatagoryVC : PageContentViewDelagate {
    
    func pageContentView(_ contentView: PageContentView, progress: CGFloat, sourceIndex: Int, targetIndex: Int) {
        
        print(targetIndex)
        titlesView.setTitleWithProgress(progress, sourceIndex: sourceIndex, targetIndex: targetIndex)
        
    }
    
}


