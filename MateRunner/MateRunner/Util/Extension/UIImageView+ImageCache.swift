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
        print("========== set image =============")
        print(url)
        DefaultImageCacheService.shared.setImage(url)
            .debug()
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] image in
                self?.image = image
                print("========== compleete =============")
            })
        
    }
}
