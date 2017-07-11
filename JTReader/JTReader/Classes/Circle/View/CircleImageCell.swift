//
//  CircleImageCell.swift
//  JTReader
//
//  Created by jiangT on 2017/7/10.
//  Copyright © 2017年 jiangT. All rights reserved.
//

import UIKit

class CircleImageCell: UITableViewCell {

    @IBOutlet var logoImg: UIImageView!
    
    @IBOutlet var nameLbl: UILabel!
    
    @IBOutlet var timeLbl: UILabel!
    
    @IBOutlet var contentLbl: UILabel!
    
    @IBOutlet var deletBtn: UIButton!
    
    @IBOutlet var praiseBtn: UIButton!
    
    @IBOutlet var commentBtn: UIButton!
    
    @IBOutlet var imgContentView: UIView!
    
    @IBOutlet var imgCOntentViewHeight: NSLayoutConstraint!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func deletClick(_ sender: UIButton) {
    }
    
    @IBAction func praiseClick(_ sender: UIButton) {
    }
    
    @IBAction func commentClick(_ sender: UIButton) {
    }
    
    
}
