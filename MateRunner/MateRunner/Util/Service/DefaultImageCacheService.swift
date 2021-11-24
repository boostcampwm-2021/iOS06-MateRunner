//
//  DefaultImageCacheService.swift
//  MateRunner
//
//  Created by 이유진 on 2021/11/24.
//

import UIKit

import RxSwift

enum ImageCache {
    static var cache = NSCache<NSString, UIImage>()
}

final class DefaultImageCacheService {
    private let disposeBag = DisposeBag()
    
    func setImage(_ url: String) -> Observable<UIImage> {
        return Observable<UIImage>.create { [weak self] emitter in
            // 1. 메모리 캐싱: 이미지가 memory cache(NSCache)에 있는지 확인
            if let image = self?.checkMemory(url) {
                emitter.onNext(image)
                emitter.onCompleted()
            }
            
            // 2. 디스크 캐싱: disk cache(UserDefault 혹은 기기Directory에있는 file형태)에서 확인
            let fileManager = FileManager.default
            let path = NSSearchPathForDirectoriesInDomains(
                .cachesDirectory,
                .userDomainMask,
                true).first ?? ""
            var filePath = URL(fileURLWithPath: path)
            if let imageURL = URL(string: url) {
                filePath.appendPathComponent(imageURL.lastPathComponent)
                if let image = self?.checkDisk(filePath: filePath, url: imageURL) {
                    emitter.onNext(image)
                    emitter.onCompleted()
                }
            }
            
            // 3. 서버통신: 받은 URL로 이미지를 가져오고 캐시 저장
            if let imageURL = URL(string: url) {
                URLSession.shared.dataTask(with: imageURL, completionHandler: { (data, _, err) in
                    if err != nil {
                        return
                    }

                    if let data = data, let image = UIImage(data: data) {
                        ImageCache.cache.setObject(image, forKey: NSString(string: url))
                        fileManager.createFile(atPath: filePath.path, contents: image.pngData(), attributes: nil)
                        emitter.onNext(image)
                    }
                }).resume()
            }
            return Disposables.create()
        }
    }
    
    private func checkMemory(_ url: String) -> UIImage? {
        let cacheKey = NSString(string: url)
        if let cachedImage = ImageCache.cache.object(forKey: cacheKey) {
            return cachedImage
        }
        return nil
    }
    
    private func checkDisk(filePath: URL, url: URL) -> UIImage? {
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: filePath.path) {
            guard let imageData = try? Data(contentsOf: filePath),
                  let image = UIImage(data: imageData)
            else {
                return nil
            }
            return image
        }
        return nil
    }
}
