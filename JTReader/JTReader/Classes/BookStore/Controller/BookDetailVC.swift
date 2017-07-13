//
//  BookDetailVC.swift
//  JTReader
//
//  Created by jiangT on 2017/5/5.
//  Copyright © 2017年 jiangT. All rights reserved.
//

import UIKit

class BookDetailVC: JTBaseViewController {

    public var titleText : String!
    public var showBook : Book!
    
    var pageNum : NSInteger = 1
    
    var downloadTool = JTDownLoadTool()
    
    @IBOutlet var tableView: UITableView!
    var dataArr = [CommentModel]()
    
    @IBOutlet var funcTionView: UIView!
    @IBOutlet var dubBtn: UIButton!
    @IBOutlet var downloadBtn: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
//        self.automaticallyAdjustsScrollViewInsets = false
        self.view.backgroundColor = UIColor.white
        
        getBookCommentData()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK:-配音按钮点击
    @IBAction func dubBtnClick(_ sender: UIButton) {
        
        let vc = DubVC()
        vc.showBook = self.showBook
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    // MARK:-下载/阅读点击
    @IBAction func downloadBtnClick(_ sender: UIButton) {
        
        let vc = BookReadVC()
        vc.showBook = self.showBook
        self.navigationController?.pushViewController(vc, animated: false)
    }
}

// MARK:-UI
extension BookDetailVC {
    
    func setUpUI() {
        
        //1.设置导航栏
        setBarButtonItem()
        //2.设置列表
        setTableView()
        //3.设置下部功能view
        createTheFunctionView()
        
    }
    
    //1.设置导航栏
    fileprivate func setBarButtonItem () {
        
        let size = CGSize(width: 40, height: 40)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(imageName: "返回", hightLightImageName: "", text:"", size: size, target: self, action: #selector(backClick))
        
        let titleV = UILabel()
        titleV.frame = CGRect(x: 0, y: 0, width: 80, height: 40)
        titleV.text = titleText
        titleV.textColor = UIColor.white
        titleV.backgroundColor = UIColor.clear
        titleV.textAlignment = .center
        self.navigationItem.titleView = titleV
    }

    @objc fileprivate func backClick () {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    //2.设置列表
    fileprivate func setTableView () {
        
        self.tableView.register(UINib.init(nibName: "BookDetailTopCell", bundle: nil), forCellReuseIdentifier: "BookDetailTopCell")
        self.tableView.register(UINib.init(nibName: "CommentCell", bundle: nil), forCellReuseIdentifier: "CommentCell")
        self.tableView.register(UINib.init(nibName: "CommentHeaderCell", bundle: nil), forHeaderFooterViewReuseIdentifier: "CommentHeaderCell")
        self.tableView.separatorStyle = .none
        self.tableView.showsVerticalScrollIndicator = false
        
        
        let footer = MJGifFooter(refreshingTarget: self, refreshingAction: #selector(loadMore))
        self.tableView.mj_footer = footer
    }
    
    //3.设置下部功能view
    func createTheFunctionView () {
        
        self.view.addSubview(funcTionView)
        
        funcTionView.snp.makeConstraints { (make) in
            make.left.equalTo(self.view).offset(-1)
            make.right.equalTo(self.view).offset(-1)
            make.bottom.equalTo(self.view).offset(-1)
            make.height.equalTo(51)
        }
        
    }
}

// MARK:-数据
extension BookDetailVC {
    
    func loadMore(){
        
        //上拉加载
        pageNum += 1;
        self.getBookCommentData()
    }
    
    func getBookCommentData() {
        
        NetWorkTool.requestBookCommentData(bookId: showBook.id.stringValue, pageNum: String(pageNum)) { (result) in
            
            //1.将result转成字典
            guard let resultDict = result as? [String : NSObject] else {
        
                return
            }
            
            //2.取出数组
            guard let dataArr = resultDict["list"] as? [[String : NSObject]] else { return }
            
            //3.遍历字典，并且转成模型对象
            for dict in dataArr {
                let comment = CommentModel(dict: dict)
                self.dataArr.append(comment)
            }
            
            self.tableView.reloadData()
        }
    }
}



extension BookDetailVC : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return 1
        } else {
            return dataArr.count
        }
        
//        return dataArr.count+1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "BookDetailTopCell") as! BookDetailTopCell
            cell.book = showBook
            
            cell.bookDescTap  = {
                print("展开")
                self.tableView.reloadData()
            }
            
            return cell
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell") as! CommentCell
            
            print(indexPath.row)
            cell.model = self.dataArr[indexPath.row]
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
//        return UITableViewAutomaticDimension
        
        if indexPath.section == 0 {
            self.tableView.estimatedRowHeight = 300;
            return UITableViewAutomaticDimension
        } else {
            self.tableView.estimatedRowHeight = 80;
            return UITableViewAutomaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "CommentHeaderCell") as! CommentHeaderCell
        view.score = showBook.score as? CGFloat
        
        view.beginComment = { [weak self] in
            print("开始评论")
//            [nav setModalPresentationStyle:UIModalPresentationOverCurrentContext];
            let vc = CommentVC()
            vc.showBook = self?.showBook
            vc.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            self?.present(vc, animated: false, completion: { 
                
                vc.bookImg.kf.setImage(with: URL(string: (self?.showBook.bookIcon)!), placeholder: UIImage.init(named: "default_img.jpg"))
                vc.bookNameLbl.text = self?.showBook.bookName
                vc.bookCategoryLbl.text = self?.showBook.catalogName
            })
        }
        
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 {
            return 44
        }
        else {
            return 0
        }
    }

    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        print(scrollView.contentOffset)
        
    }
    
}

