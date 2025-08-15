//
//  ImageService.swift
//  CodeFlix
//
//  Created by Zhdanov Konstantin on 15.08.2025.
//
import UIKit

class ImageService {
    static let shared = ImageService()
    private var runningRequests = [UUID: URLSessionDataTask]()

    func loadImage(from urlString: String?, completion: @escaping (UIImage?) -> Void) -> UUID? {
        guard let urlString = urlString, let url = URL(string: urlString) else {
            completion(nil)
            return nil
        }

        let uuid = UUID()

        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            defer { self?.runningRequests.removeValue(forKey: uuid) }

            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async { completion(image) }
            } else {
                DispatchQueue.main.async { completion(nil) }
            }
        }
        task.resume()

        runningRequests[uuid] = task
        return uuid
    }

    func cancelLoad(_ uuid: UUID) {
        runningRequests[uuid]?.cancel()
        runningRequests.removeValue(forKey: uuid)
    }
}
