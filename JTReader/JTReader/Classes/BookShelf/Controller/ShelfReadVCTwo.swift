//
//  ShelfReadVCTwo.swift
//  JTReader
//
//  Created by jiangT on 2017/7/4.
//  Copyright © 2017年 jiangT. All rights reserved.
//

import UIKit

class ShelfReadVCTwo: JTBaseViewController {
    
    public var showBook : Book!
    var  bookPath : NSString?
    var pathAll = ""
    var pageContentArr = [PageContent]()
    
    @IBOutlet var contentView: UIView!
    @IBOutlet var backBtn: UIButton!
    
    //懒加载属性
    fileprivate lazy var pageController : UIPageViewController = { [weak self] in
        
//        UIPageViewControllerSpineLocation
        
        let pageCon = UIPageViewController(transitionStyle: UIPageViewControllerTransitionStyle.pageCurl, navigationOrientation: UIPageViewControllerNavigationOrientation.horizontal, options: [UIPageViewControllerOptionSpineLocationKey : NSNumber.init(value: 2)])
        pageCon.delegate = self
        pageCon.dataSource = self
        pageCon.isDoubleSided = true
        return pageCon
    }()
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // MARK:-横竖屏设置
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.allowRotation = 1 //1表示支持横竖屏
        let value = UIInterfaceOrientation.landscapeLeft.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.allowRotation = 0
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        
        self.navigationController?.isNavigationBarHidden = false
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

//        //添加pageViewController
//        self.pageController.view.frame = self.view.bounds
//        self.addChildViewController(pageController)
//        self.view.addSubview(pageController.view)
        
        getBookInfo()
        
        //初始化内容控制器
        let initalViewController = self.viewControllerAtIndex(index: 0)
        let initalViewController2 = self.viewControllerAtIndex(index: 1)
        pageController.setViewControllers([initalViewController, initalViewController2], direction: .forward, animated: false) { (b:Bool) in
            
            //UIPageController必须放在Controller Container中
            self.pageController.view.frame = self.contentView.bounds
            self.addChildViewController(self.pageController)
            self.contentView.addSubview(self.pageController.view)
            self.pageController.didMove(toParentViewController: self)
            
            self.view.bringSubview(toFront: self.backBtn)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func getBookInfo() {
        
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.allDomainsMask, true)
        let documentPath = paths[0]
        
        let filePath = documentPath.appendingFormat("/zip/book%@.zip", showBook.id.stringValue)
        
        bookPath = filePath as NSString
        
        //解析文件夹内  temp.txt 文件
        pathAll = documentPath.appendingFormat("/zip/book%@", showBook.id.stringValue)
        
        let usePath = pathAll.appending("/temp.txt")
        
        let data = FileManager.default.contents(atPath: usePath)
        
        let jsonDic : NSDictionary = try! JSONSerialization.jsonObject(with: data! as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
        
        let arr = jsonDic["contents"] as? [[String : NSObject]]
        
        for dic in arr! {
            
            let pageContent = PageContent.init(dict : dic )
            pageContentArr.append(pageContent)
        }
        
        
    }
    //自定义方法，创建显示视图
    func viewControllerAtIndex(index : Int) -> ReadContentVC {
        
//        if self.pageContentArr.count == 0 || index > self.pageContentArr.count {
//            var vc = ReadContentVC()
//            vc = NSNull()
//            return vc
//        }
        
        //创建一个VC
        let vc = ReadContentVC()
        vc.pageContent = pageContentArr[index]
        
        let k = index%2
        if k == 0 {
            vc.isLeft = true
        } else {
            vc.isLeft = false
        }
        
        return vc
    }
    
    //自定义方法，获取viewController的页码
    func indexOfViewController(viewControler:ReadContentVC) -> Int {
        return self.pageContentArr.index(of: viewControler.pageContent!)!
    }
    
    @IBAction func backClick(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
        
    }
}


extension ShelfReadVCTwo : UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
// MARK:- UIPageViewControllerDataSource
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {

        //获取当前viewController的页码
        var index:Int = self.indexOfViewController(viewControler: viewController as! ReadContentVC)
        
        //如果是第0页，返回nil
        if index == 0 || (index == NSNotFound) {
            return nil
        }
        
        index -= 1

        return self.viewControllerAtIndex(index: index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        //获取当前viewController的页码
        var index:Int = self.indexOfViewController(viewControler: viewController as! ReadContentVC)
        
        if index == NSNotFound {
            return nil
        }

        index += 1
        
        //如果是最后一张，返回nil
        if index == self.pageContentArr.count {
            return nil
        }
        
        return self.viewControllerAtIndex(index: index)
        
    }
    
    
// MARK:- UIPageViewControllerDelegate
}

