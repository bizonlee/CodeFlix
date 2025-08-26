//
//  FilmCellViewModel.swift
//  CodeFlix
//
//  Created by Zhdanov Konstantin on 20.08.2025.
//

import UIKit

final class FilmCellViewModel {
    let film: Film
    var task: Cancellable?

    init(film: Film) {
        self.film = film
    }

    func loadImage(completion: @escaping (UIImage?) -> Void) {
        task?.cancel()

        guard let imageUrl = film.poster?.url else {
            completion(nil)
            return
        }

        task = ImageService.shared.loadImage(from: imageUrl) { image in
            completion(image)
        }
    }

    func cancelImageDownloadTask() {
        task?.cancel()
        task = nil
    }
}
