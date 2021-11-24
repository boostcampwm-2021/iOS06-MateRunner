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
        return Observable<UIImage>.create { [weak self] emitter in
            // 1. 메모리 캐싱: 이미지가 memory cache(NSCache)에 있는지 확인
            if let image = self?.checkMemory(url) {
                emitter.onNext(image)
            }
            
            //2. 디스크 캐싱: disk cache(UserDefault 혹은 기기Directory에있는 file형태)에서 확인
            if let image = try self?.checkDisk(url) {
                emitter.onNext(image)
            }
            
            //3. 서버통신: 받은 URL로 이미지를 가져오고 캐시 저장
            if let imageURL = URL(string: url){
                URLSession.shared.dataTask(with: imageURL, completionHandler: { (data, res, err) in
                    if err != nil {
                        return
                    }

                    DispatchQueue.main.async {
                        if let data = data, let image = UIImage(data: data) {
                            ImageCache.cache.setObject(image, forKey: cacheKey)
                            fileManager.createFile(atPath: filePath.path, contents: image.pngData(), attributes: nil)
                            on(image)
                        }
                    }
                }).resume()
            }
        }
    }
    
    private func checkMemory(_ url: String) -> UIImage? {
        // 1. 메모리 캐싱: 이미지가 memory cache(NSCache)에 있는지 확인
        let cacheKey = NSString(string: url)
        if let cachedImage = ImageCache.cache.object(forKey: cacheKey){
            return cachedImage
        }
        return nil
    }
    
    private func checkDisk(_ url: String) throws -> UIImage? {
        //2. 디스크 캐싱: disk cache(UserDefault 혹은 기기Directory에있는 file형태)에서 확인
        let fileManager = FileManager.default
        guard let path = NSSearchPathForDirectoriesInDomains(
            .cachesDirectory,
            .userDomainMask,
            true).first else {
                throw ImageCacheError.nilPathError
            }
        var filePath = URL(fileURLWithPath: path)
        
        if let imageURL = URL(string: url){
            filePath.appendPathComponent(imageURL.lastPathComponent)
            if fileManager.fileExists(atPath: filePath.path) {
                guard let imageData = try? Data(contentsOf: filePath),
                      let image = UIImage(data: imageData)
                else { return nil }
                return image
            }
        }
        return nil
    }
}
