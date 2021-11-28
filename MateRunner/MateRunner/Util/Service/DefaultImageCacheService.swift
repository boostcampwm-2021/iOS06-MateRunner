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
    static let shared = DefaultImageCacheService()
    private init () {}
    
    func setImage(_ url: String) -> Observable<UIImage> {
        // 1. 메모리 캐싱: 이미지가 memory cache(NSCache)에 있는지 확인
        if let image = self.checkMemory(url) {
            print("mem hit")
            return Observable.just(image)
        }
        print("mem miss")
        
        if let image = self.checkDisk(url) {
            print("disk hit")
            ImageCache.cache.setObject(image, forKey: NSString(string: url))
            return Observable.just(image)
        }
        print("disk miss")
        
        guard let imageURL = URL(string: url) else { return Observable.error(ImageCacheError.nilImageError) }
        return Observable<UIImage>.create { emitter in
            // 3. 서버통신: 받은 URL로 이미지를 가져오고 캐시 저장
            URLSession.shared.dataTask(with: imageURL, completionHandler: { (data, _, error) in
                if error != nil {
                    emitter.onError(ImageCacheError.nilImageError)
                    return
                }
                if let data = data, let image = UIImage(data: data) {
                    guard let path = NSSearchPathForDirectoriesInDomains( .cachesDirectory, .userDomainMask, true).first,
                          let tokenString  = url.components(separatedBy: "=").last,
                          let imageURL = URL(string: url) else {
                              return
                          }
                    
                    let filePath = URL(fileURLWithPath: path).appendingPathComponent(tokenString + imageURL.path)
                    ImageCache.cache.setObject(image, forKey: NSString(string: url))
                    print("save cache for \(url)")
                    FileManager.default.createFile(atPath: filePath.path, contents: image.pngData(), attributes: nil)
                    print("save distk for \(filePath.path)")
                    print(ImageCache.cache)
                    print("net cache")
                    emitter.onNext(image)
                }
            }).resume()
            
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
    
    private func checkDisk(_ url: String) -> UIImage? {
        // 2. 디스크 캐싱: disk cache(UserDefault 혹은 기기Directory에있는 file형태)에서 확인
        let fileManager = FileManager.default
        guard let path = NSSearchPathForDirectoriesInDomains( .cachesDirectory, .userDomainMask, true).first,
              let tokenString  = url.components(separatedBy: "=").last,
              let imageURL = URL(string: url) else {
                  return nil
              }
        
        let filePath = URL(fileURLWithPath: path).appendingPathComponent(tokenString + imageURL.path)
        print("filePath", filePath)
        if fileManager.fileExists(atPath: filePath.path) {
            guard let imageData = try? Data(contentsOf: filePath),
                  let image = UIImage(data: imageData)
            else { return nil }
            return image
        }
        return nil
    }
    
//    private func createImageCachePath(with url: String) {
//        guard let path = NSSearchPathForDirectoriesInDomains( .cachesDirectory, .userDomainMask, true).first,
//              let tokenString  = url.components(separatedBy: "=").last,
//              let imageURL = URL(string: url) else {
//                  return nil
//              }
//    }
    
    // 2. 디스크 캐싱: disk cache(UserDefault 혹은 기기Directory에있는 file형태)에서 확인
    //      let fileManager = FileManager.default
    //      let path = NSSearchPathForDirectoriesInDomains(
    //        .cachesDirectory,
    //        .userDomainMask,
    //        true).first ?? “”
    //      var filePath = URL(fileURLWithPath: path)
    //      if let imageURL = URL(string: url) {
    //        filePath.appendPathComponent(imageURL.lastPathComponent)
    //        if let image = self?.checkDisk(filePath: filePath, url: imageURL) {
    //          ImageCache.cache.setObject(image, forKey: NSString(string: url))
    //          emitter.onNext(image)
    //          emitter.onCompleted()
    //        }
    //      }
}
