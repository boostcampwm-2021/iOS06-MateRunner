//
//  DefaultImageCacheService.swift
//  MateRunner
//
//  Created by 이유진 on 2021/11/24.
//

import UIKit

import RxSwift

enum ImageCache {
    static var cache = NSCache<NSString, CachableImage>()
}

final class CachableImage: Codable {
    let imageData: Data
    let etag: String
    
    init(imageData: Data, etag: String) {
        self.imageData = imageData
        self.etag = etag
    }
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
        if let image = self.checkMemory(url) {
            print("cache hit")
            print(image)
            return self.conditionalGet(imageURL: imageURL, etag: image.etag, conditional: true)
                .map({ $0.imageData })
                .catchAndReturn(image.imageData)
        }
        
        // 2. Lookup Disk
        if let image = self.checkDisk(imageURL) {
            print("disk hit")
            return self.conditionalGet(imageURL: imageURL, etag: image.etag, conditional: true)
                .map({ $0.imageData })
                .catchAndReturn(image.imageData)
        }
        
        // 3. Network Request
        return self.conditionalGet(imageURL: imageURL, etag: "", conditional: false)
            .map({ $0.imageData })
    }
    
    private func conditionalGet(imageURL: URL, etag: String, conditional: Bool) -> Observable<CachableImage> {
        return Observable<CachableImage>.create { emitter in
            var request = URLRequest(url: imageURL)
            if conditional {
                request.addValue(etag, forHTTPHeaderField: "If-None-Match")
            }
            URLSession.shared.rx.response(request: request).subscribe(
                onNext: { [weak self] (response, data) in
                    if (200...299) ~= response.statusCode {
                        let etag = response.allHeaderFields["Etag"] as? String ?? ""
                        let image = CachableImage(imageData: data, etag: etag)
                        self?.saveIntoCache(imageURL: imageURL, image: image)
                        self?.saveIntoDisk(imageURL: imageURL, image: image)
                        emitter.onNext(image)
                    } else if response.statusCode == 304 {
                        emitter.onError(ImageCacheError.nilImageError)
                    }
                },
                onError: { error in
                    emitter.onError(error)
                }
            ).disposed(by: self.disposeBag)
            
            return Disposables.create()
        }
    }
    
    private func checkMemory(_ url: String) -> CachableImage? {
        let cacheKey = NSString(string: url)
        return ImageCache.cache.object(forKey: cacheKey)
    }
    
    private func checkDisk(_ imageURL: URL) -> CachableImage? {
        guard let path = FileManager.default.urls(for: .cachesDirectory, in: .allDomainsMask).first else {
            return nil
        }
        let filePath = path.appendingPathComponent(imageURL.pathComponents.joined(separator: "-"))
        
        if FileManager.default.fileExists(atPath: filePath.path) {
            guard let imageData = try? Data(contentsOf: filePath),
                  let etag = UserDefaults.standard.string(forKey: imageURL.absoluteString)else { return nil }
            return CachableImage(imageData: imageData, etag: etag)
        }
        return nil
    }
    
    private func saveIntoCache(imageURL: URL, image: CachableImage) {
        ImageCache.cache.setObject(image, forKey: NSString(string: imageURL.absoluteString))
    }
    
    private func saveIntoDisk(imageURL: URL, image: CachableImage) {
        guard let path = FileManager.default.urls(for: .cachesDirectory, in: .allDomainsMask).first else { return }
        let filePath = path.appendingPathComponent(imageURL.pathComponents.joined(separator: "-"))
        UserDefaults.standard.set(image.etag, forKey: imageURL.absoluteString)
        FileManager.default.createFile(atPath: filePath.path, contents: image.imageData, attributes: nil)
    }
}
