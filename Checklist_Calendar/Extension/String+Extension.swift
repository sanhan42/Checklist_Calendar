//
//  String+Extension.swift
//  Checklist_Calendar
//
//  Created by 한상민 on 2022/09/25.
//

import UIKit
import RealmSwift

extension String {
    func heightWithConstrainedWidth(width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: [.usesFontLeading, .usesLineFragmentOrigin], attributes: [NSAttributedString.Key.font: font], context: nil)
        return boundingBox.height
    }
    
    // 취소선 긋기
    func strikeThrough() -> NSAttributedString {
        let attributeString = NSMutableAttributedString(string: self)
        attributeString.addAttribute(.font, value: UIFont.systemFont(ofSize: 13), range: NSMakeRange(0,attributeString.length))
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: NSMakeRange(0,attributeString.length))
        attributeString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.textColor.withAlphaComponent(0.5), range: NSMakeRange(0,attributeString.length))
        return attributeString
    }
    
    func regular() -> NSAttributedString {
        let attributeString = NSMutableAttributedString(string: self)
        attributeString.addAttribute(.font, value: UIFont.systemFont(ofSize: 13), range: NSMakeRange(0,attributeString.length))
        attributeString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.textColor, range: NSMakeRange(0,attributeString.length))
        return attributeString
    }
}
