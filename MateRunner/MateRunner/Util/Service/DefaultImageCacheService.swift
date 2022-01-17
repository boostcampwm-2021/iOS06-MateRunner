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
            
            return Disposables.create(with: disposable.dispose)
        }
    }
    
    private func checkMemory(_ imageURL: URL) -> CacheableImage? {
        let cacheKey = NSString(string: imageURL.path)
        guard let cached = ImageCache.cache.object(forKey: cacheKey) else { return nil }
        self.updateLastRead(of: imageURL, currentEtag: cached.cacheInfo.etag)
        return cached
    }
    
    private func checkDisk(_ imageURL: URL) -> CacheableImage? {
        guard let filePath = self.createImagePath(with: imageURL) else { return nil }
        
        if FileManager.default.fileExists(atPath: filePath.path) {
            guard let imageData = try? Data(contentsOf: filePath),
                  let cachedData = UserDefaults.standard.data(forKey: imageURL.path),
                  let cachedInfo = self.decodeCacheData(data: cachedData) else { return nil }
            
            let image = CacheableImage(imageData: imageData, etag: cachedInfo.etag)
            self.saveIntoCache(imageURL: imageURL, image: image)
            self.updateLastRead(of: imageURL, currentEtag: cachedInfo.etag, to: image.cacheInfo.lastRead)
            
            return image
        }
        return nil
    }
    
    private func updateLastRead(of imageURL: URL, currentEtag: String, to date: Date = Date()) {
        let updated = CacheInfo(etag: currentEtag, lastRead: date)
        guard let encoded = encodeCacheData(cacheInfo: updated) else { return }
        UserDefaults.standard.set(encoded, forKey: imageURL.path)
    }
    
    private func saveIntoCache(imageURL: URL, image: CacheableImage) {
        ImageCache.cache.setObject(image, forKey: NSString(string: imageURL.path), cost: image.imageData.count)
    }
    
    private func saveIntoDisk(imageURL: URL, image: CacheableImage) {
        guard let filePath = self.createImagePath(with: imageURL) else { return }
        let cacheDirectory = filePath.deletingLastPathComponent()
        let cacheInfo = CacheInfo(etag: image.cacheInfo.etag, lastRead: Date())
        
        if let numOfFiles = try? FileManager.default.contentsOfDirectory(atPath: cacheDirectory.path).count {
            if numOfFiles >= 50 {
                var removeTarget: (imageURL: String, minTime: Date) = ("", Date())
                UserDefaults.standard.dictionaryRepresentation().forEach({ key, value in
                    guard let cacheInfoData = value as? Data,
                          let cacheInfoValue = self.decodeCacheData(data: cacheInfoData) else { return }
                    if removeTarget.minTime > cacheInfoValue.lastRead {
                        removeTarget = (key, cacheInfoValue.lastRead)
                    }
                })
                self.deleteFromDisk(imageURL: removeTarget.imageURL)
            }
        }
        
        guard let encoded = encodeCacheData(cacheInfo: cacheInfo) else { return }
        UserDefaults.standard.set(encoded, forKey: imageURL.path)
        FileManager.default.createFile(atPath: filePath.path, contents: image.imageData, attributes: nil)
    }
    
    private func deleteFromDisk(imageURL: String) {
        guard let imageURL = URL(string: imageURL),
              let filePath = self.createImagePath(with: imageURL) else { return }
        
        UserDefaults.standard.removeObject(forKey: imageURL.path)
        try? FileManager.default.removeItem(atPath: filePath.path)
    }
    
    private func decodeCacheData(data: Data) -> CacheInfo? {
        return try? JSONDecoder().decode(CacheInfo.self, from: data)
    }
    
    private func encodeCacheData(cacheInfo: CacheInfo) -> Data? {
        return try? JSONEncoder().encode(cacheInfo)
    }
    
    private func createImagePath(with imageURL: URL) -> URL? {
        guard let path = FileManager.default.urls(for: .cachesDirectory, in: .allDomainsMask).first else { return nil }
        let profileImageDirPath = path.appendingPathComponent("profileImage")
        let filePath = profileImageDirPath.appendingPathComponent(imageURL.pathComponents.joined(separator: "-"))
        
        if !FileManager.default.fileExists(atPath: profileImageDirPath.path) {
            try? FileManager.default.createDirectory(
                atPath: profileImageDirPath.path,
                withIntermediateDirectories: true,
                attributes: nil
            )
        }
        return filePath
    }
}
