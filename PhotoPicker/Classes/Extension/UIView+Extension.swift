//
//  UIView+Extension.swift
//  PhotoPicker
//
//  Created by wave on 2018/11/12.
//  Copyright © 2018 wave. All rights reserved.
//

import UIKit
import SwifterSwift

extension UIView {
    
    static func fromNib() -> UIView? {

        guard let path = Bundle.main.path(forResource: "Frameworks/PhotoPicker", ofType: "framework"),
            let bundle = Bundle(path: path) else {
                return nil
        }
        
        let name = String(describing: self)
        let view = UINib(nibName: name, bundle: bundle).instantiate(withOwner: nil, options: nil)[0] as? UIView
        return view
    }
}

extension UIView {
    
    var centerX: CGFloat{
        set{
            self.center = CGPoint(x: newValue, y: self.center.y)
        }
        get{
            return self.center.x
        }
    }
    
    var centerY: CGFloat {
        set{
            self.center = CGPoint(x: self.center.x, y: newValue)
        }
        get{
            return self.center.y
        }
    }
    
    var left: CGFloat {
        set{
            var frame = self.frame
            frame.origin.x = newValue
            self.frame = frame
        }
        get{
            return self.frame.origin.x
        }
    }
    
    var top: CGFloat {
        set{
            var frame = self.frame
            frame.origin.y = newValue
            self.frame = frame
        }
        get{
            return self.frame.origin.y
        }
    }
    
    var right: CGFloat {
        set{
            var frame = self.frame
            frame.origin.x = newValue - frame.size.width
            self.frame = frame
        }
        get{
            return self.frame.origin.x + self.frame.size.width
        }
    }
    
    var bottom: CGFloat {
        set{
            var frame = self.frame
            frame.origin.y = newValue - frame.size.height
            self.frame = frame
        }
        get{
            return self.frame.origin.y + self.frame.size.height
        }
    }
}
