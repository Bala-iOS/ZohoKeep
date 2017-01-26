//
//  UIView+Extension.swift
//  ZohoKeep
//
//  Created by Bala on 1/25/17.
//  Copyright © 2017 Bala. All rights reserved.
//

import UIKit

extension UIView{
    @IBInspectable
    var CornerRadius: CGFloat{
        get{
            return layer.cornerRadius/2
        }
        set{
            layer.cornerRadius = newValue
            layer.masksToBounds = true
        }
    }
    
    @IBInspectable var BorderWidth: CGFloat {
        get{
            return layer.borderWidth
        }
        set{
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set(newValue) {
            layer.borderColor = newValue?.cgColor
        }
    }
}
