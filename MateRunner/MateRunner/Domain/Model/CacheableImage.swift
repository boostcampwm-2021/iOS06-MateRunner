//
//  CachableImage.swift
//  MateRunner
//
//  Created by 전여훈 on 2021/11/29.
//

import Foundation

final class CacheableImage {
    let imageData: Data
    let cacheInfo: CacheInfo
    
    init(imageData: Data, etag: String) {
        self.cacheInfo = CacheInfo(etag: etag, lastRead: Date())
        self.imageData = imageData
    }
}

struct CacheInfo {
    let etag: String
    let lastRead: Date
}
