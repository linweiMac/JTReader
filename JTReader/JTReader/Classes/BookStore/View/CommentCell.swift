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
        
        self.starRating.backgroundColor = UIColor.clear
        self.starRating.starImage = UIImage.init(named: "comment_starN")
        self.starRating.starHighlightedImage = UIImage.init(named: "comment_starS")
        self.starRating.maxRating = Int(5.0)
        self.starRating.horizontalMargin = 0
        self.starRating.editable = false
        self.starRating.displayMode = UInt(EDStarRatingDisplayAccurate)
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
        
        starRating.rating = Float(model.score)
    }
    
    
}
