//
//  CommentHeaderCell.swift
//  JTReader
//
//  Created by jiangT on 2017/5/25.
//  Copyright © 2017年 jiangT. All rights reserved.
//

import UIKit
import EDStarRating

class CommentHeaderCell: UITableViewHeaderFooterView {

    @IBOutlet var starrating: EDStarRating!
    
    @IBOutlet var commentBtn: UIButton!
    
    var beginComment : () -> () = {}
    
    public var score : CGFloat? {
        
        didSet {
            
            guard  let v = score else { return }
            
            starrating.maxRating = 5

            starrating.rating = Float(v)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        /*
         self.starRating.maxRating = 5.0;
         self.starRating.horizontalMargin = 5;
         self.starRating.editable = NO;
         self.starRating.displayMode = EDStarRatingDisplayAccurate;
         self.starRating.rating = [_bookContent.score floatValue];
         */
        
        self.commentBtn.layer.cornerRadius = 14
        self.commentBtn.layer.borderWidth = 1
        self.commentBtn.layer.borderColor = UIColor(r: 60, g: 154, b: 252).cgColor
        
        self.starrating.backgroundColor = UIColor.clear
        self.starrating.starImage = UIImage.init(named: "comment_star")
        self.starrating.starHighlightedImage = UIImage.init(named: "comment_starL")
        self.starrating.maxRating = Int(5.0)
        self.starrating.horizontalMargin = 0
        self.starrating.editable = false
        self.starrating.displayMode = UInt(EDStarRatingDisplayAccurate)
        
    }
    
    @IBAction func commentClick(_ sender: UIButton) {
        self.beginComment()
    }
}
