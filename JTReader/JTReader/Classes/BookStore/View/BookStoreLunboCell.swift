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
    
    // MARK:-轮播图点击
    var lunboClick : (LunboModel) -> () = {param in}
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        carouseView.delegate = self as JTCarouseViewDelegate
        
    }

    func carouseView(_ carouseView: JTCarouselView, selectedIndex lunboModel: LunboModel) {
        
        self.lunboClick(lunboModel)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
