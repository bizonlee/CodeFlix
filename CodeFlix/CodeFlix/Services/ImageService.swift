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

    private let cache: NSCache<NSURL, UIImage> = NSCache<NSURL, UIImage>()

    private init() {
        cache.countLimit = 100
        cache.totalCostLimit = 50 * 1024 * 1024
    }

    func loadImage(from urlString: String?, completion: @escaping (UIImage?) -> Void) -> URLSessionDataTask? {
        guard let urlString = urlString, let url = URL(string: urlString) else {
            completion(nil)
            return nil
        }

        if let cachedImage = cache.object(forKey: url as NSURL) {
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

            cache.setObject(image, forKey: url as NSURL)

            DispatchQueue.main.async {
                completion(image)
            }
        }

        task.resume()
        return task
    }
}

extension URLSessionDataTask: Cancellable {}
