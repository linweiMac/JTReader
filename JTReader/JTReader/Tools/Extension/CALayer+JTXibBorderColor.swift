//
//  CALayer+JTXibBorderColor.swift
//  JTReader
//
//  Created by jiangT on 2017/6/30.
//  Copyright © 2017年 jiangT. All rights reserved.
//

import Foundation
import QuartzCore

extension CALayer {
    
    func setBorderColorWithUIColor (color : UIColor) {
        
        self.borderColor = color.cgColor
    }
    
}

