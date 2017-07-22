//
//  Color.swift
//  SkillLayerMask
//
//  Created by adeveloper on 26.05.17.
//  Copyright © 2017 adeveloper. All rights reserved.
//

import UIKit

extension UIColor {
    
    class func from(_ hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.characters.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
}

extension UIColor {
    
    class func random() -> UIColor {
        let rgb  = (CGFloat(rand()/200), CGFloat(rand()/200), CGFloat(rand()/200))
        let color = UIColor.init(red: rgb.0, green: rgb.1, blue: rgb.2, alpha: 1.0)
        return color
    }
}

func rand() -> CGFloat {
    let random = arc4random_uniform(100)
    return CGFloat(random) + 0.5
}


