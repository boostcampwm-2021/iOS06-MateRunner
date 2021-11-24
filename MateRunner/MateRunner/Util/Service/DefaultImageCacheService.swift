//
//  DefaultImageCacheService.swift
//  MateRunner
//
//  Created by 이유진 on 2021/11/24.
//

import UIKit

import RxSwift

//1. 이미지가 memory cache(NSCache)에 있는지 확인하고
//원하는 이미지가 없다면
//
//2. disk cache(UserDefault 혹은 기기Directory에있는 file형태)에서 확인하고
//있다면 memory cache에 추가해주고 다음에는 더 빨리 가져 올수 있도록
//이마저도 없다면
//
//3. 서버통신을 통해서 받은 URL로 이미지를 가져옴
//이때 서버통신을 통해서 이미지를 가져왔으면 memory와 disk cache에 저장

enum ImageCache {
    static var cache = NSCache<NSString, UIImage>()
}

final class DefaultImageCacheService {
    func setImage(_ url: String) -> Observable<UIImage> {
        return Observable<UIImage>.create { emitter in
            // 1. 메모리 캐싱: 이미지가 memory cache(NSCache)에 있는지 확인
            let cacheKey = NSString(string: url)
            if let cachedImage = ImageCache.cache.object(forKey: cacheKey){
                emitter.onNext(cachedImage)
            }
            
            //2. 디스크 캐싱: disk cache(UserDefault 혹은 기기Directory에있는 file형태)에서 확인
            let fileManager = FileManager.default
            guard let path = NSSearchPathForDirectoriesInDomains(
                .cachesDirectory, // cache폴더를 사용
                .userDomainMask,
                true
            ).first else {
                emitter.onError(ImageCacheError.nilPathError)
            }
            
            var filePath = URL(fileURLWithPath: path)
            
            if let imageURL = URL(string: url){
                filePath.appendPathComponent(imageURL.lastPathComponent)
                if fileManager.fileExists(atPath: filePath.path) {
                    guard let imageData = try? Data(contentsOf: filePath),
                          let image = UIImage(data: imageData)
                    else {
                        emitter.onError(ImageCacheError.nilImageError)
                    }
                    emitter.onNext(image)
                }
            }
        }
    }
    
}
