//
//  ViewedService.swift
//  CodeFlix
//
//  Created by Zhdanov Konstantin on 26.08.2025.
//

import Foundation

protocol FilmViewedManagerProtocol {
    func markFilmAsViewed(with filmId: Int, _ duration: Int)
    func isViewed(with filmId: Int) -> Bool
    func markForWatching(with filmId: Int,  _ duration: Int)
    func isMarkedForWatching(with filmId: Int) -> Bool
    func removeFilmFromViewed(with filmId: Int, _ duration: Int)
    func removeFilmFromWatchLater(with filmId: Int,  _ duration: Int)
    func getViewedFilmIds() -> [Int]
    func getTotalWatchedTime() -> Int
    func getTotalForWatchingTime() -> Int
    func getFavoritesIds() -> [Int]
}

final class FilmViewedManager {
    private let viewedKeyId = "viewed"
    private let forWatchingKeyId = "forWatching"
    private let watchedTimeKey = "totalTime"
    private let forWatchingTimeKey = "totalFutureTime"
    private let userDefaults: UserDefaults = .standard

    private func viewedKeyId(for filmId: Int) -> String {
        return "\(viewedKeyId)\(filmId)"
    }

    private func forWatchingKeyId(for filmId: Int) -> String {
        return "\(forWatchingKeyId)\(filmId)"
    }
}

extension FilmViewedManager: FilmViewedManagerProtocol {
    
    func removeFilmFromViewed(with filmId: Int, _ duration: Int) {
        userDefaults.removeObject(forKey: viewedKeyId(for: filmId))
        
        let totalTime = userDefaults.integer(forKey: watchedTimeKey)
        userDefaults.set(totalTime - duration, forKey: watchedTimeKey)
        print("Всего посмотрел удалил")
        print(userDefaults.integer(forKey: watchedTimeKey))
    }

    func isViewed(with filmId: Int) -> Bool {
        userDefaults.bool(forKey: viewedKeyId(for: filmId))
    }

    func markFilmAsViewed(with filmId: Int, _ duration: Int) {
        userDefaults.set(true, forKey: viewedKeyId(for: filmId))

        let totalTime = userDefaults.integer(forKey: watchedTimeKey)
        userDefaults.set(totalTime + duration, forKey: watchedTimeKey)
        print("Всего посмотрел добавил")
        print(userDefaults.integer(forKey: watchedTimeKey))
    }

    func markForWatching(with filmId: Int, _ duration: Int) {
        userDefaults.set(true, forKey: forWatchingKeyId(for: filmId))

        let totalTime = userDefaults.integer(forKey: forWatchingTimeKey)
        userDefaults.set(totalTime + duration, forKey: forWatchingTimeKey)
        print("Всего собираюсь посмотреть добавил")
        print(userDefaults.integer(forKey: forWatchingKeyId))
    }

    func removeFilmFromWatchLater(with filmId: Int, _ duration: Int) {
        userDefaults.removeObject(forKey: forWatchingKeyId(for: filmId))

        let totalTime = userDefaults.integer(forKey: forWatchingKeyId)
        userDefaults.set(totalTime - duration, forKey: forWatchingKeyId)
        print("Всего собираюсь посмотреть удалил")
        print(userDefaults.integer(forKey: forWatchingKeyId))
    }

    func isMarkedForWatching(with filmId: Int) -> Bool {
        userDefaults.bool(forKey: forWatchingKeyId(for: filmId))
    }

    func getViewedFilmIds() -> [Int] {
        return userDefaults.dictionaryRepresentation().keys
            .filter { $0.hasPrefix(viewedKeyId) && userDefaults.bool(forKey: $0) }
            .compactMap { Int($0.replacingOccurrences(of: viewedKeyId, with: "")) }
    }

    func getForWatchingFilmIds() -> [Int] {
        return userDefaults.dictionaryRepresentation().keys
            .filter { $0.hasPrefix(forWatchingKeyId) && userDefaults.bool(forKey: $0) }
            .compactMap { Int($0.replacingOccurrences(of: forWatchingKeyId, with: "")) }
    }

    func getFavoritesIds() -> [Int] {
        let watched = getViewedFilmIds()
        let forWatching = getForWatchingFilmIds()
        return Array(Set(watched + forWatching))
    }

    func getTotalWatchedTime() -> Int {
        print(userDefaults.integer(forKey: watchedTimeKey))
        return userDefaults.integer(forKey: watchedTimeKey)
    }

    func getTotalForWatchingTime() -> Int {
        print(userDefaults.integer(forKey: forWatchingTimeKey))
        return userDefaults.integer(forKey: forWatchingTimeKey)
    }
}
