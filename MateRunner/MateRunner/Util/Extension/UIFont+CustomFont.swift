//
//  UIFont+CustomFont.swift
//  MateRunner
//
//  Created by 이유진 on 2021/11/01.
//

import UIKit

extension UIFont {
    enum Family: String {
        case black, bold, light, medium, regular, thin
    }

    static func notoSans(size: CGFloat = 10, family: Family = .regular) -> UIFont {
        return UIFont(name: "NotoSansKR-\(family)", size: size) ?? UIFont.systemFont(ofSize: size)
    }
}
