//
//  BookStoreCell.swift
//  JTReader
//
//  Created by jiangT on 2017/5/5.
//  Copyright © 2017年 jiangT. All rights reserved.
//

import UIKit
import Kingfisher

let BtnTag = 1


class BookStoreCell: UITableViewCell {

    @IBOutlet var typeLbl: UILabel!
    
    @IBOutlet var desLbl: UILabel!
    
    // MARK:-频道标题点击
    var intoTypeDetail : (String, String) -> () = {param in }
    
    // MARK:-书本点击
    var bookDetailBlock : (Book) -> () = {param in}
    
    
    // MARK:-定义模型属性
    var model : channelModel? {
        didSet {
            // 0.校验模型是否有值
            guard let model = model else { return }
            
            // 1.取出标题名字
            typeLbl.text = model.title
            
            // 2.描述
            desLbl.text = model.titleDes
            
            // 3.设置书本封面图片
            
            for index in 0..<model.bookList.count {
                let book = model.bookList[index]
                
                let img = self.contentView.viewWithTag(BtnTag+index) as! UIImageView
                
                let url = URL(string: book.bookIcon)
                img.kf.setImage(with: url)
            }
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        addGestureForImage()
    }
    
    fileprivate func addGestureForImage () {
        
        for index in 1...6 {
            let image = self.contentView.viewWithTag(index)
            image?.isUserInteractionEnabled = true
            
            let tapG = UITapGestureRecognizer(target: self, action: #selector(imgTap))
            image?.addGestureRecognizer(tapG)

        }
        
    }
    
    @objc fileprivate func imgTap (tap: UITapGestureRecognizer) {
        
        let v = tap.view
        
        print(v?.tag ?? 1)
        
        let book = model?.bookList[(v?.tag)!-1]
        self.bookDetailBlock(book!)
    }
    
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
    
    
    
    
    @IBAction func intoTypeClick(_ sender: UIButton) {
        
        print("进入频道详情")
        if model == nil {
            return
        }
        self.intoTypeDetail((model?.type)!, (model?.title)!)
    }
    
    
}
