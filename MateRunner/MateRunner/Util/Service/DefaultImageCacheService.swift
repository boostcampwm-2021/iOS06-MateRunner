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
        guard let imageURL = URL(string: url) else {
            return Observable.error(ImageCacheError.invalidURLError)
        }
        
        // 1. Lookup NSCache
        if let image = self.checkMemory(url) {
            return Observable.just(image)
        }
        
        // 2. Lookup Disk
        if let image = self.checkDisk(imageURL) {
            self.saveIntoCache(imageURL: imageURL, image: image)
            return Observable.just(image)
        }
        
        // 3. Network Request
        return Observable<UIImage>.create { emitter in
            let request = URLRequest(url: imageURL)
            URLSession.shared.rx.response(request: request).subscribe(
                onNext: { [weak self] response in
                    guard let image = UIImage(data: response.data) else { return }
                    self?.saveIntoCache(imageURL: imageURL, image: image)
                    self?.saveIntoDisk(imageURL: imageURL, image: image)
                    emitter.onNext(image)
                },
                onError: { error in
                    emitter.onError(error)
                }
            ).disposed(by: self.disposeBag)

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
    
    private func checkDisk(_ imageURL: URL) -> UIImage? {
        guard let path = FileManager.default.urls(for: .cachesDirectory, in: .allDomainsMask).first else {
            return nil
        }
        let filePath = path.appendingPathComponent(imageURL.pathComponents.joined(separator: "-"))
        if FileManager.default.fileExists(atPath: filePath.path) {
            guard let imageData = try? Data(contentsOf: filePath) else { return nil }
            return UIImage(data: imageData)
        }
        return nil
    }
    
    private func saveIntoCache(imageURL: URL, image: UIImage) {
        ImageCache.cache.setObject(image, forKey: NSString(string: imageURL.absoluteString))
    }
    
    private func saveIntoDisk(imageURL: URL, image: UIImage) {
        guard let path = FileManager.default.urls(for: .cachesDirectory, in: .allDomainsMask).first else { return }
        let filePath = path.appendingPathComponent(imageURL.pathComponents.joined(separator: "-"))
        FileManager.default.createFile(atPath: filePath.path, contents: image.pngData(), attributes: nil)
    }
}
