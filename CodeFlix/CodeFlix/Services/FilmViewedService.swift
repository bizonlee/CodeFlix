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
    private let viewedKey = "viewed"
    private let forWatchingKey = "forWatching"
    private let watchedTimeKey = "totalTime"
    private let forWatchingTotalKey = "totalFutureTime"
    private let userDefaults: UserDefaults = .standard

    private func viewedKey(for filmId: Int) -> String {
        return "\(viewedKey)\(filmId)"
    }

    private func forWatchingKey(for filmId: Int) -> String {
        return "\(forWatchingKey)\(filmId)"
    }
}

extension FilmViewedManager: FilmViewedManagerProtocol {
    
    func removeFilmFromViewed(with filmId: Int, _ duration: Int) {
        userDefaults.removeObject(forKey: viewedKey(for: filmId))
        
        let totalTime = userDefaults.integer(forKey: watchedTimeKey)
        userDefaults.set(totalTime - duration, forKey: watchedTimeKey)
        print("Всего посмотрел удалил")
        print(userDefaults.integer(forKey: watchedTimeKey))
    }

    func isViewed(with filmId: Int) -> Bool {
        userDefaults.bool(forKey: viewedKey(for: filmId))
    }

    func markFilmAsViewed(with filmId: Int, _ duration: Int) {
        userDefaults.set(true, forKey: viewedKey(for: filmId))

        let totalTime = userDefaults.integer(forKey: watchedTimeKey)
        userDefaults.set(totalTime + duration, forKey: watchedTimeKey)
        print("Всего посмотрел добавил")
        print(userDefaults.integer(forKey: watchedTimeKey))
    }

    func markForWatching(with filmId: Int, _ duration: Int) {
        userDefaults.set(true, forKey: forWatchingKey(for: filmId))

        let totalTime = userDefaults.integer(forKey: forWatchingKey)
        userDefaults.set(totalTime + duration, forKey: forWatchingKey)
        print("Всего собираюсь посмотреть добавил")
        print(userDefaults.integer(forKey: forWatchingKey))
    }

    func removeFilmFromWatchLater(with filmId: Int, _ duration: Int) {
        userDefaults.removeObject(forKey: forWatchingKey(for: filmId))

        let totalTime = userDefaults.integer(forKey: forWatchingKey)
        userDefaults.set(totalTime - duration, forKey: forWatchingKey)
        print("Всего собираюсь посмотреть удалил")
        print(userDefaults.integer(forKey: forWatchingKey))
    }

    func isMarkedForWatching(with filmId: Int) -> Bool {
        userDefaults.bool(forKey: forWatchingKey(for: filmId))
    }

    func getViewedFilmIds() -> [Int] {
        return userDefaults.dictionaryRepresentation().keys
            .filter { $0.hasPrefix(viewedKey) && userDefaults.bool(forKey: $0) }
            .compactMap { Int($0.replacingOccurrences(of: viewedKey, with: "")) }
    }

    func getForWatchingFilmIds() -> [Int] {
        return userDefaults.dictionaryRepresentation().keys
            .filter { $0.hasPrefix(forWatchingKey) && userDefaults.bool(forKey: $0) }
            .compactMap { Int($0.replacingOccurrences(of: forWatchingKey, with: "")) }
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
        print(userDefaults.integer(forKey: forWatchingKey))
        return userDefaults.integer(forKey: forWatchingKey)
    }
}
