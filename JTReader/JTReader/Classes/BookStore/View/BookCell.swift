//
//  BookCell.swift
//  JTReader
//
//  Created by jiangT on 2017/5/10.
//  Copyright © 2017年 jiangT. All rights reserved.
//

import UIKit

class BookCell: UICollectionViewCell {

    @IBOutlet var bookIcon: UIImageView!
    
    // MARK:-定义模型属性
    var model : Book? {
        didSet {
            // 0.校验模型是否有值
            guard let model = model else { return }
    
            bookIcon.kf.setImage(with: URL(string: model.bookIcon), placeholder: UIImage.init(named: "default_img.jpg"))
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
