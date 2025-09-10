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
    func removeFilmFromViewed(with filmId: Int)
    func removeFilmFromWatchLater(with filmId: Int)

    func getViewedFilmIds() -> [Int]
}

final class FilmViewedManager {
    private let viewedKey = "viewed"
    private let forWatchingKey = "forWatching"
    private let userDefaults: UserDefaults = .standard

    private func viewedKey(for filmId: Int) -> String {
        return "\(viewedKey)\(filmId)"
    }

    private func forWatchingKey(for filmId: Int) -> String {
        return "\(forWatchingKey)\(filmId)"
    }
}

extension FilmViewedManager: FilmViewedManagerProtocol {
    func removeFilmFromViewed(with filmId: Int) {
        userDefaults.removeObject(forKey: viewedKey(for: filmId))
    }

    func removeFilmFromWatchLater(with filmId: Int) {
        userDefaults.removeObject(forKey: forWatchingKey(for: filmId))
    }

    func isViewed(with filmId: Int) -> Bool {
        userDefaults.bool(forKey: viewedKey(for: filmId))
    }

    func markFilmAsViewed(with filmId: Int) {
        userDefaults.set(true, forKey: viewedKey(for: filmId))
    }

    func markForWatching(with filmId: Int) {
        userDefaults.set(true, forKey: forWatchingKey(for: filmId))
    }

    func isMarkedForWatching(with filmId: Int) -> Bool {
        userDefaults.bool(forKey: forWatchingKey(for: filmId))
    }

    func getViewedFilmIds() -> [Int] {
        return userDefaults.dictionaryRepresentation().keys
            .filter { $0.hasPrefix(viewedKey) && userDefaults.bool(forKey: $0) }
            .compactMap { Int($0.replacingOccurrences(of: viewedKey, with: "")) }
    }
}
