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
    static func configureCachePolicy(with maximumBytes: Int) {
        Self.cache.totalCostLimit = maximumBytes
    }
}

final class DefaultImageCacheService {
    static let shared = DefaultImageCacheService()
    private init () {}
    
    func setImage(_ url: String) -> Observable<Data> {
        guard let imageURL = URL(string: url) else {
            return Observable.error(ImageCacheError.invalidURLError)
        }
        
        // 1. Lookup NSCache
        if let image = self.checkMemory(imageURL) {
            return self.get(imageURL: imageURL, etag: image.cacheInfo.etag)
                .map({ $0.imageData })
                .catchAndReturn(image.imageData)
        }
        
        // 2. Lookup Disk
        if let image = self.checkDisk(imageURL) {
            return self.get(imageURL: imageURL, etag: image.cacheInfo.etag)
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
            let disposable = URLSession.shared.rx.response(request: request).subscribe(
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
            )
            
            return Disposables.create(with: disposable.dispose )
        }
    }
    
    private func checkMemory(_ imageURL: URL) -> CacheableImage? {
        let cacheKey = NSString(string: imageURL.path)
        guard let cached = ImageCache.cache.object(forKey: cacheKey) else { return nil }
        self.updateLastRead(of: imageURL, currentEtag: cached.cacheInfo.etag)
        return cached
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
            self.updateLastRead(of: imageURL, currentEtag: etag, to: image.cacheInfo.lastRead)
            
            return image
        }
        return nil
    }
    
    private func updateLastRead(of imageURL: URL, currentEtag: String, to date: Date = Date()) {
        let updated = CacheInfo(etag: currentEtag, lastRead: date)
        UserDefaults.standard.set(updated, forKey: imageURL.path)
    }
    
    private func saveIntoCache(imageURL: URL, image: CacheableImage) {
        ImageCache.cache.setObject(image, forKey: NSString(string: imageURL.path), cost: image.imageData.count)
    }
    
    private func saveIntoDisk(imageURL: URL, image: CacheableImage) {
        guard let path = FileManager.default.urls(for: .cachesDirectory, in: .allDomainsMask).first else { return }
        let filePath = path.appendingPathComponent(imageURL.pathComponents.joined(separator: "-"))
        let cacheInfo = CacheInfo(etag: image.cacheInfo.etag, lastRead: Date())
        
        if let numOfFiles = try? FileManager.default.contentsOfDirectory(atPath: filePath.path).count {
            if numOfFiles > 50 {
                var removeTarget: (imageURL: String, minTime: Date) = ("", Date())
                UserDefaults.standard.dictionaryRepresentation().forEach({ key, value in
                    guard let cacheInfoValue = value as? CacheInfo else { return }
                    if removeTarget.minTime > cacheInfoValue.lastRead {
                        removeTarget = (key, cacheInfoValue.lastRead)
                    }
                })
                self.deleteFromDisk(imageURL: removeTarget.imageURL)
            }
        }

        UserDefaults.standard.set(cacheInfo, forKey: imageURL.path)
        FileManager.default.createFile(atPath: filePath.path, contents: image.imageData, attributes: nil)
    }
    
    private func deleteFromDisk(imageURL: String) {
        guard let imageURL = URL(string: imageURL),
              let path = FileManager.default.urls(for: .cachesDirectory, in: .allDomainsMask).first else { return }
        let filePath = path.appendingPathComponent(imageURL.pathComponents.joined(separator: "-"))
        
        UserDefaults.standard.removeObject(forKey: imageURL.path)
        try? FileManager.default.removeItem(atPath: filePath.path)
    }
}
