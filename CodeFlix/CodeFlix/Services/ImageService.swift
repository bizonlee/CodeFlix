//
//  ImageService.swift
//  CodeFlix
//
//  Created by Zhdanov Konstantin on 15.08.2025.
//
import UIKit

class ImageService {
    static let shared = ImageService()

    func loadImage(from urlString: String?, completion: @escaping (UIImage?) -> Void) {
        guard let urlString = urlString, let url = URL(string: urlString) else {
            completion(nil)
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, _ in
            let image = data.flatMap { UIImage(data: $0) }
            DispatchQueue.main.async {
                completion(image)
            }
        }.resume()
    }
}
