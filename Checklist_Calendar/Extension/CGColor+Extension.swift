//
//  CGColor+Extension.swift
//  Checklist_Calendar
//
//  Created by 한상민 on 2023/02/03.
//

import CoreGraphics

extension CGColor {
    func toHex() -> String? {
        guard let components = components else { return nil }
        
        if components.count == 2 {
            let value = components[0]
            let alpha = components[1]
            return String(format: "#%02lX%02lX%02lX%02lX", lroundf(Float(value*255)), lroundf(Float(value*255)), lroundf(Float(value*255)), lroundf(Float(alpha*255)))
        }
        
        guard components.count == 4 else { return nil }
        
        let red   = components[0]
        let green = components[1]
        let blue  = components[2]
        let alpa  = components[3]
        
        let hexString = String(format: "#%02lX%02lX%02lX%02lX", lroundf(Float(red*255)), lroundf(Float(green*255)), lroundf(Float(blue*255)), lroundf(Float(alpa*255)))
        
        return hexString
    }
}
