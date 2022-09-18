//
//  UIColor+Extension.swift
//  Checklist_Calendar
//
//  Created by 한상민 on 2022/09/15.
//

import UIKit

extension UIColor {
    // 사용자 정의 색
    class var bgColor: UIColor { return UIColor(named: "BgColor-3")!}
    class var GrayColor: UIColor { return UIColor(named: "GrayColor-1")!}
    class var tableBgColor: UIColor { return UIColor(named: "TableBgColor")!}
    class var textColor: UIColor { return UIColor.black.withAlphaComponent(0.9)}

    // UIColor <-> String (DB에 color를 저장하기 위해 String으로 바꿔줄 필요가 있음.) (비트연산 사용.)
    convenience init(hexAlpha: String) {
        var hexFormatted: String = hexAlpha.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()

        if hexFormatted.hasPrefix("#") {
            hexFormatted = String(hexFormatted.dropFirst())
        }

        assert(hexFormatted.count == 8, "Invalid hex code used.") // 반드시 8 자리여야 함.

        var rgbaValue: UInt64 = 0
        Scanner(string: hexFormatted).scanHexInt64(&rgbaValue)

        self.init(red: CGFloat((rgbaValue & 0xFF000000) >> 24) / 255.0,
                  green: CGFloat((rgbaValue & 0x00FF0000) >> 16) / 255.0,
                  blue: CGFloat((rgbaValue & 0x0000FF00) >> 8) / 255.0,
                  alpha: CGFloat(rgbaValue & 0x000000FF) / 255.0)
    }

    func toHexString() -> String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        print(r, g, b, a)
        let rgba:Int = (Int)(r*255)<<24 | (Int)(g*255)<<16 | (Int)(b*255)<<8 | (Int)(a*255)<<0

        return String(format:"#%08x", rgba)
    }
}
