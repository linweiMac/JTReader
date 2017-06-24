//
//  BookStoreLunboCell.swift
//  JTReader
//
//  Created by jiangT on 2017/6/21.
//  Copyright © 2017年 jiangT. All rights reserved.
//

import UIKit

class BookStoreLunboCell: UITableViewCell, JTCarouseViewDelegate {
    
    @IBOutlet var carouseView: JTCarouselView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        carouseView.delegate = self as JTCarouseViewDelegate
        
    }

    func carouseView(_ carouseView: JTCarouselView, selectedIndex index: Int) {
        print(index)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
