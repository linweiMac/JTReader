//
//  BookDetailTopCell.swift
//  JTReader
//
//  Created by jiangT on 2017/5/24.
//  Copyright © 2017年 jiangT. All rights reserved.
//

import UIKit
import EDStarRating

class BookDetailTopCell: UITableViewCell {

    var bookDescTap : () -> () = {}
    
    public var book : Book? {
        didSet {
            
            // 0.校验模型是否有值
            guard let book = book else { return }
            
            let url = URL(string: book.bookIcon)
            bookIcon.kf.setImage(with: url, placeholder: UIImage.init(named: "default_img.jpg"))

            bookNameLbl.text = book.bookName
            
            typeLbl.text = book.catalogName
            
            bookDescLbl.text = "        " + book.bookDesc
            
        }
    }
    
    // MARK:-xib属性
    @IBOutlet var bookIcon: UIImageView!
    @IBOutlet var bookNameLbl: UILabel!
    @IBOutlet var typeLbl: UILabel!
    @IBOutlet var bookDescLbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(descLblTap))
        bookDescLbl.addGestureRecognizer(tap)
    }

    @objc func descLblTap() {
        bookDescLbl.numberOfLines = 0
        self.layoutIfNeeded()
        //block 去通知刷新
        self.bookDescTap()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
