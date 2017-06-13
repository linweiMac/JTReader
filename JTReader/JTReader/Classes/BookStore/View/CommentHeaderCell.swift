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
        
        self.starrating.backgroundColor = UIColor.clear
        self.starrating.starImage = UIImage.init(named: "starN")
        self.starrating.starHighlightedImage = UIImage.init(named: "startS")
        self.starrating.maxRating = Int(5.0)
        self.starrating.horizontalMargin = 0
        self.starrating.editable = false
        self.starrating.displayMode = UInt(EDStarRatingDisplayAccurate)
        
    }
    
    @IBAction func commentClick(_ sender: UIButton) {
    }
}
