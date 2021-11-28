//
//  UIImageView+ImageCache.swift
//  MateRunner
//
//  Created by 이유진 on 2021/11/24.
//

import UIKit

import RxSwift

extension UIImageView {
    
    func setImage(with url: String) {
        _ = DefaultImageCacheService.shared.setImage(url)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] image in
                self?.image = image
            })
    }
}
