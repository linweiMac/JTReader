//
//  ReadContentVC.swift
//  JTReader
//
//  Created by jiangT on 2017/7/4.
//  Copyright © 2017年 jiangT. All rights reserved.
//

import UIKit

class ReadContentVC: JTBaseViewController {

    @IBOutlet var showImg: UIImageView!
    
    
    public var pageContent : PageContent?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        showImg.image = UIImage.init(named: "default_img.jpg")
        
        showImg.kf.setImage(with: URL(string: (pageContent?.imageUrl)! as String), placeholder: UIImage.init(named: "default_img.jpg"))
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    

}
