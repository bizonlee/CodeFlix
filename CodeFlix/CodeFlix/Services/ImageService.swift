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

    func loadImage(from urlString: String?, completion: @escaping (UIImage?) -> Void) -> URLSessionDataTask? {
        guard let urlString = urlString, let url = URL(string: urlString) else {
            completion(nil)
            return nil
        }

        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard error == nil, let data = data, let image = UIImage(data: data) else {
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }

            DispatchQueue.main.async {
                completion(image)
            }
        }

        task.resume()
        return task
    }
}

extension URLSessionDataTask: Cancellable {}
