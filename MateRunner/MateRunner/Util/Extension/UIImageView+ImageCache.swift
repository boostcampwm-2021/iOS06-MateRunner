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
        
        DefaultImageCacheService.shared.setImage(url)
            .observe(on: MainScheduler.instance)
            .debug()
            .subscribe(onNext: { [weak self] image in
                self?.image = image
            })
            
    }
}
