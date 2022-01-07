//
//  DefaultImageCacheService.swift
//  MateRunner
//
//  Created by 이유진 on 2021/11/24.
//

import UIKit

import RxSwift

enum ImageCache {
    static var cache = NSCache<NSString, CacheableImage>()
}

final class DefaultImageCacheService {
    private let disposeBag = DisposeBag()
    static let shared = DefaultImageCacheService()
    private init () {}
    
    func setImage(_ url: String) -> Observable<Data> {
        guard let imageURL = URL(string: url) else {
            return Observable.error(ImageCacheError.invalidURLError)
        }
        
        // 1. Lookup NSCache
        if let image = self.checkMemory(imageURL) {
            return self.get(imageURL: imageURL, etag: image.etag)
                .map({ $0.imageData })
                .catchAndReturn(image.imageData)
        }
        
        // 2. Lookup Disk
        if let image = self.checkDisk(imageURL) {
            return self.get(imageURL: imageURL, etag: image.etag)
                .map({ $0.imageData })
                .catchAndReturn(image.imageData)
        }
        
        // 3. Network Request
        return self.get(imageURL: imageURL)
            .map({ $0.imageData })
    }
    
    private func get(imageURL: URL, etag: String? = nil) -> Observable<CacheableImage> {
        return Observable<CacheableImage>.create { emitter in
            var request = URLRequest(url: imageURL)
            if let etag = etag {
                request.addValue(etag, forHTTPHeaderField: "If-None-Match")
            }
            URLSession.shared.rx.response(request: request).subscribe(
                onNext: { [weak self] (response, data) in
                    switch response.statusCode {
                    case (200...299):
                        let etag = response.allHeaderFields["Etag"] as? String ?? ""
                        let image = CacheableImage(imageData: data, etag: etag)
                        self?.saveIntoCache(imageURL: imageURL, image: image)
                        self?.saveIntoDisk(imageURL: imageURL, image: image)
                        emitter.onNext(image)
                    case 304:
                        emitter.onError(ImageCacheError.imageNotModifiedError)
                    case 402:
                        emitter.onError(ImageCacheError.networkUsageExceedError)
                    default:
                        emitter.onError(ImageCacheError.unknownNetworkError)
                    }
                },
                onError: { error in
                    emitter.onError(error)
                }
            ).disposed(by: self.disposeBag)
            
            return Disposables.create()
        }
    }
    
    private func checkMemory(_ imageURL: URL) -> CacheableImage? {
        let cacheKey = NSString(string: imageURL.path)
        return ImageCache.cache.object(forKey: cacheKey)
    }
    
    private func checkDisk(_ imageURL: URL) -> CacheableImage? {
        guard let path = FileManager.default.urls(for: .cachesDirectory, in: .allDomainsMask).first else {
            return nil
        }
        let filePath = path.appendingPathComponent(imageURL.pathComponents.joined(separator: "-"))
        
        if FileManager.default.fileExists(atPath: filePath.path) {
            guard let imageData = try? Data(contentsOf: filePath),
                  let etag = UserDefaults.standard.string(forKey: imageURL.path) else { return nil }
            
            let image = CacheableImage(imageData: imageData, etag: etag)
            self.saveIntoCache(imageURL: imageURL, image: image)
            
            return image
        }
        return nil
    }
    
    private func saveIntoCache(imageURL: URL, image: CacheableImage) {
        ImageCache.cache.setObject(image, forKey: NSString(string: imageURL.path))
    }
    
    private func saveIntoDisk(imageURL: URL, image: CacheableImage) {
        guard let path = FileManager.default.urls(for: .cachesDirectory, in: .allDomainsMask).first else { return }
        let filePath = path.appendingPathComponent(imageURL.pathComponents.joined(separator: "-"))
        UserDefaults.standard.set(image.etag, forKey: imageURL.path)
        FileManager.default.createFile(atPath: filePath.path, contents: image.imageData, attributes: nil)
    }
}
