//
//  FilmsActionFactory.swift
//  CodeFlix
//
//  Created by Zhdanov Konstantin on 10.09.2025.
//

import UIKit

final class FilmActionsFactory {
    var onReload: ((Film) -> Void)?
    var onCopyLinkTap: (() -> Void)?
    private let filmViewedManager: FilmViewedManagerProtocol

    init(filmViewedManager: FilmViewedManagerProtocol) {
        self.filmViewedManager = filmViewedManager
    }

    func makeMenuController(for film: Film, sourceView: UIView) -> UIAlertController {
        let alertController = UIAlertController(
            title: film.title,
            message: nil,
            preferredStyle: .actionSheet
        )

        let watchLaterAction = UIAlertAction(
            title: "Буду смотреть",
            style: .default
        ) { [weak self] _ in
            self?.watchLaterTapped(for: film)
        }

        let viewedAction = UIAlertAction(
            title: "Посмотрел",
            style: .default
        ) { [weak self] _ in
            self?.viewedTapped(for: film)
        }

        let shareAction = UIAlertAction(
            title: "Копировать ссылку",
            style: .default
        ) { [weak self] _ in
            self?.shareTapped(for: film)
        }

        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel)

        alertController.addAction(watchLaterAction)
        alertController.addAction(viewedAction)
        alertController.addAction(shareAction)
        alertController.addAction(cancelAction)

        if let popoverController = alertController.popoverPresentationController {
            popoverController.sourceView = sourceView
            popoverController.sourceRect = sourceView.bounds
            popoverController.permittedArrowDirections = [.up]
        }

        return alertController
    }

    private func watchLaterTapped(for film: Film) {
        let isCurrentlyMarked = filmViewedManager.isMarkedForWatching(with: film.id)

        if isCurrentlyMarked {
            filmViewedManager.removeFilmFromWatchLater(with: film.id, film.movieLength ?? 0)
        } else {
            filmViewedManager.markForWatching(with: film.id, film.movieLength ?? 0)
        }

        onReload?(film)
        FilmNotificationCenter.shared.notifyFilmUpdate(film)
    }

    private func viewedTapped(for film: Film) {
        let isCurrentlyViewed = filmViewedManager.isViewed(with: film.id)

        if isCurrentlyViewed {
            filmViewedManager.removeFilmFromViewed(with: film.id, film.movieLength ?? 0)
        } else {
            filmViewedManager.markFilmAsViewed(with: film.id, film.movieLength ?? 0)
        }

        onReload?(film)
        FilmNotificationCenter.shared.notifyFilmUpdate(film)
    }

    private func shareTapped(for film: Film) {
        let movieLink = "https://www.kinopoisk.ru/film/\(film.id)"
        UIPasteboard.general.string = movieLink

        onCopyLinkTap?()
    }
}
