//
//  UIImage+Extension.swift
//  PhotoPicker
//
//  Created by wave on 2018/11/27.
//  Copyright © 2018 wave. All rights reserved.
//

import UIKit

extension UIImage {
    
    static func loadLocalImage(name: String) -> UIImage {
        
        /// **
//        let bundlePath = Bundle.main.path(forResource: "Frameworks/PhotoPicker", ofType: "framework")
//        guard let path = bundlePath?.appendingPathComponent(name) else {
//            return UIImage()
//        }
//        let img = UIImage(contentsOfFile: path) ?? UIImage()
//        return img

        
        guard let path = Bundle.main.resourcePath?.appendingPathComponent(name) else {
            return UIImage()
        }
        
        let img = UIImage(contentsOfFile: path) ?? UIImage()
        return img
    }
}

