//
//  CachableImage.swift
//  MateRunner
//
//  Created by 전여훈 on 2021/11/29.
//

import Foundation

final class CacheableImage {
    let imageData: Data
    let etag: String
    
    init(imageData: Data, etag: String) {
        self.imageData = imageData
        self.etag = etag
    }
}
