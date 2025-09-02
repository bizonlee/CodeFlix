//
//  ViewedService.swift
//  CodeFlix
//
//  Created by Zhdanov Konstantin on 26.08.2025.
//

import Foundation
protocol FilmViewedManagerProtocol {
    func markFilmAsViewed(with filmId: Int)
    func isViewed(with filmId: Int) -> Bool
    func markForWatching(with filmId: Int)
    func isMarkedForWatching(with filmId: Int) -> Bool
}

final class FilmViewedManager {
    private let viewedKey: String = "viewed"
    private let forWatchingKey: String = "forWatching"
}

extension FilmViewedManager: FilmViewedManagerProtocol {
    func isViewed(with filmId: Int) -> Bool {
        let key: String = "\(viewedKey)\(filmId)"
        return UserDefaults.standard.bool(forKey: key)
    }

    func markFilmAsViewed(with filmId: Int) {
        let key: String = "\(viewedKey)\(filmId)"
        UserDefaults.standard.set(true, forKey: key)
    }

    func markForWatching(with filmId: Int) {
        let key: String = "\(forWatchingKey)\(filmId)"
        UserDefaults.standard.set(true, forKey: key)
    }

    func isMarkedForWatching(with filmId: Int) -> Bool {
        let key: String = "\(forWatchingKey)\(filmId)"
        return UserDefaults.standard.bool(forKey: key)
    }
}
