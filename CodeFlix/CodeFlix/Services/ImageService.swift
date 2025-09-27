//
//  ImageService.swift
//  CodeFlix
//
//  Created by Zhdanov Konstantin on 15.08.2025.
//

import UIKit

protocol Cancellable {
    func cancel()
}

class ImageService {
    static let shared = ImageService()

    private let cache: ImageCacheDescription

    private init(cache: ImageCacheDescription = ImageCache.shared) {
        self.cache = cache
    }

    func loadImage(from urlString: String?, completion: @escaping (UIImage?) -> Void) -> URLSessionDataTask? {
        guard let urlString = urlString, let url = URL(string: urlString) else {
            completion(nil)
            return nil
        }

        if let cachedImageData = cache.obtain(with: url.absoluteString),
            let cachedImage = UIImage(data: cachedImageData) {
            completion(cachedImage)
            return nil
        }

        let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let self else { return }

            guard error == nil, let data, let image = UIImage(data: data) else {
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }

            cache.store(data, with: url.absoluteString)

            DispatchQueue.main.async {
                completion(image)
            }
        }

        task.resume()
        return task
    }
}

extension URLSessionDataTask: Cancellable {}
