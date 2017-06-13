//
//  CommentCell.swift
//  JTReader
//
//  Created by jiangT on 2017/5/24.
//  Copyright © 2017年 jiangT. All rights reserved.
//

import UIKit
import EDStarRating

class CommentCell: UITableViewCell {

    public var model : CommentModel? {
        didSet {
            setSelfInfo(model: model!)
        }
    }
    
    @IBOutlet var userLogo: UIImageView!
    
    @IBOutlet var userName: UILabel!
    
    @IBOutlet var levelLbl: UILabel!
    @IBOutlet var timeLbl: UILabel!
    
    
    @IBOutlet var starRating: EDStarRating!
    
    
    @IBOutlet var deletBtn: UIButton!
    
    @IBOutlet var contentLbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.userLogo.clipsToBounds = true
        self.userLogo.layer.cornerRadius = 30
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func deletClick(_ sender: UIButton) {
    }
    
    func setSelfInfo(model : CommentModel) {
        
        let url = URL(string: model.logoUrl)
        self.userLogo.kf.setImage(with: url, placeholder: UIImage.init(named: "userLogo"))
        self.userName.text = model.userName
        self.timeLbl.text = model.createTime
        self.contentLbl.text = model.content
    }
    
    
}
