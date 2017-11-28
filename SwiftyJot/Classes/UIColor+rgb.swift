//
//  UIColor+rgb.swift
//  AnnotateImage
//
//  Created by David Lari on 11/25/17.
//  Copyright © 2017 David Lari. All rights reserved.
//
import UIKit

extension UIColor {

    struct Components {
        let red: Int
        let green: Int
        let blue: Int
        let alpha: Int
    }

    func getRGBAColorComponents() -> Components? {
        var red : CGFloat = 0
        var green : CGFloat = 0
        var blue : CGFloat = 0
        var alpha: CGFloat = 0
        if getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
            return Components(red: Int(red * 255), green: Int(green * 255), blue: Int(blue * 255), alpha: Int(alpha * 255))
        } else {
            return nil
        }
    }
}
