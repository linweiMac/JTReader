//
//  SearchCell.swift
//  JTReader
//
//  Created by jiangT on 2017/6/23.
//  Copyright © 2017年 jiangT. All rights reserved.
//

import UIKit

class SearchCell: UITableViewCell {

    public var titlesArr : [NSString]? {
        didSet {
            setBtnView(textArr: titlesArr!)
        }
    }
    
    var keywordSelected : (String) -> () = {param in }
    
    var clearAllHistory : () -> () = {param in }

    
    public var cellHeight : CGFloat!
    
    @IBOutlet var typeLbl: UILabel!
    @IBOutlet var btnView: UIView!
    @IBOutlet var trashBtn: UIButton!
    
//    var btnClick : (NSString) -> () = {param in}
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setBtnView(textArr : [NSString]) {
        
        for v in self.btnView.subviews {
            v.removeFromSuperview()
        }
        
        let rect = UIScreen.main.bounds
        var lastBtn : UIButton?
        
        for i in 0..<textArr.count{
            
            let str = textArr[i]
            
            let btn = UIButton()
            btn.backgroundColor = UIColor.init(white: 0.946, alpha: 1.0)
            btn.layer.cornerRadius = 3
            btn.layer.masksToBounds = true
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
            btn.setTitle(str as String, for: UIControlState.normal)
            btn.setTitleColor(UIColor.black, for: UIControlState.normal)
            btn.tag = i+100
            btn.addTarget(self, action: #selector(btnClick), for: UIControlEvents.touchUpInside)
            self.btnView.addSubview(btn)
            
            let att = [NSFontAttributeName : UIFont.init(name: btn.titleLabel!.font.fontName, size: btn.titleLabel!.font.pointSize)]
            var titleSize = str.size(attributes: att as Any as? [String : Any])
            titleSize.height = 30
            titleSize.width += 10

            if lastBtn != nil {
                
                var aa = lastBtn!.frame.origin.x + lastBtn!.frame.width + 10
                var bb = lastBtn!.frame.origin.y
                
                if (aa+titleSize.width+10) > rect.size.width-30 {
                    aa = 0
                    bb = lastBtn!.frame.origin.y+lastBtn!.frame.size.height+10
                }
                btn.frame = CGRect(x: aa, y: bb, width: titleSize.width, height: titleSize.height)
            }
            else {
                
                btn.frame = CGRect(x: 0, y: 0, width: titleSize.width, height: titleSize.height)
            }
            
            lastBtn = btn
        }
        
        if lastBtn != nil {
            cellHeight = lastBtn!.frame.origin.y+lastBtn!.frame.size.height+80;
        }
        else {
            cellHeight = 0
        }
        
    }
    
    @objc func btnClick(sender : UIButton) {
        print(#function)
        print(sender.titleLabel!.text!)
        
        self.keywordSelected(sender.titleLabel!.text!)
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func clearBtnClick(_ sender: UIButton) {
        self.clearAllHistory()
    }
    
    
}
