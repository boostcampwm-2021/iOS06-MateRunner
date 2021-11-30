//
//  String+UIImageConverter.swift
//  MateRunner
//
//  Created by 전여훈 on 2021/11/30.
//

import Foundation

extension String {
    func emojiToImage() -> Data? {
        let size = CGSize(width: 60, height: 65)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        UIColor.clear.set()
        let rect = CGRect(origin: CGPoint(), size: size)
        UIRectFill(CGRect(origin: CGPoint(), size: size))
        (self as NSString).draw(in: rect, withAttributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 60)])
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image?.pngData()
    }
}
