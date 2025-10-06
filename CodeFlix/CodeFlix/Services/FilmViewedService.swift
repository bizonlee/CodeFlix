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
    func markForWatching(with filmId: Int, _ duration: Int)
    func isMarkedForWatching(with filmId: Int) -> Bool
    func removeFilmFromViewed(with filmId: Int, _ duration: Int)
    func removeFilmFromWatchLater(with filmId: Int, _ duration: Int)
    func getViewedFilmIds() -> [Int]
    func getForWatchingFilmIds() -> [Int]
    func getTotalWatchedTime() -> Int
    func getTotalForWatchingTime() -> Int
    func getAdjustedForWatchingTime() -> Int
    func getFavoritesIds() -> [Int]
    func getFilmDuration(for filmId: Int) -> Int?
    func setFilmDuration(for filmId: Int, duration: Int)
}

final class FilmViewedManager {
    private let viewedKeyId = "viewed"
    private let forWatchingKeyId = "forWatching"
    private let watchedTimeKey = "totalTime"
    private let forWatchingTimeKey = "totalFutureTime"
    private let filmDurationKey = "filmDuration"
    private let userDefaults: UserDefaults = .standard

    private func viewedKeyId(for filmId: Int) -> String {
        return "\(viewedKeyId)\(filmId)"
    }

    private func forWatchingKeyId(for filmId: Int) -> String {
        return "\(forWatchingKeyId)\(filmId)"
    }

    private func filmDurationKey(for filmId: Int) -> String {
        return "\(filmDurationKey)\(filmId)"
    }
}

extension FilmViewedManager: FilmViewedManagerProtocol {

    // MARK: - Film Duration Management
    func getFilmDuration(for filmId: Int) -> Int? {
        let duration = userDefaults.integer(forKey: filmDurationKey(for: filmId))
        return duration > 0 ? duration : nil
    }

    func setFilmDuration(for filmId: Int, duration: Int) {
        userDefaults.set(duration, forKey: filmDurationKey(for: filmId))
    }

    // MARK: - Viewed Films
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
        setFilmDuration(for: filmId, duration: duration)

        let totalTime = userDefaults.integer(forKey: watchedTimeKey)
        userDefaults.set(totalTime + duration, forKey: watchedTimeKey)
        print("Всего посмотрел добавил")
        print(userDefaults.integer(forKey: watchedTimeKey))
    }

    // MARK: - For Watching Films
    func markForWatching(with filmId: Int, _ duration: Int) {
        userDefaults.set(true, forKey: forWatchingKeyId(for: filmId))
        setFilmDuration(for: filmId, duration: duration)

        let totalTime = userDefaults.integer(forKey: forWatchingTimeKey)
        userDefaults.set(totalTime + duration, forKey: forWatchingTimeKey)
        print("Всего собираюсь посмотреть добавил")
        print(userDefaults.integer(forKey: forWatchingTimeKey))
    }

    func removeFilmFromWatchLater(with filmId: Int, _ duration: Int) {
        userDefaults.removeObject(forKey: forWatchingKeyId(for: filmId))

        let totalTime = userDefaults.integer(forKey: forWatchingTimeKey)
        userDefaults.set(totalTime - duration, forKey: forWatchingTimeKey)
        print("Всего собираюсь посмотреть удалил")
        print(userDefaults.integer(forKey: forWatchingTimeKey))
    }

    func isMarkedForWatching(with filmId: Int) -> Bool {
        userDefaults.bool(forKey: forWatchingKeyId(for: filmId))
    }

    // MARK: - Get Film Lists
    func getViewedFilmIds() -> [Int] {
        return userDefaults.dictionaryRepresentation().keys
            .filter { $0.hasPrefix(viewedKeyId) && userDefaults.bool(forKey: $0) }
            .compactMap { key in
                let filmIdString = key.replacingOccurrences(of: viewedKeyId, with: "")
                return Int(filmIdString)
            }
    }

    func getForWatchingFilmIds() -> [Int] {
        return userDefaults.dictionaryRepresentation().keys
            .filter { $0.hasPrefix(forWatchingKeyId) && userDefaults.bool(forKey: $0) }
            .compactMap { key in
                let filmIdString = key.replacingOccurrences(of: forWatchingKeyId, with: "")
                return Int(filmIdString)
            }
    }

    func getFavoritesIds() -> [Int] {
        let watched = getViewedFilmIds()
        let forWatching = getForWatchingFilmIds()
        return Array(Set(watched + forWatching))
    }

    // MARK: - Time Calculations
    func getTotalWatchedTime() -> Int {
        print("Total watched time: \(userDefaults.integer(forKey: watchedTimeKey))")
        return userDefaults.integer(forKey: watchedTimeKey)
    }

    func getTotalForWatchingTime() -> Int {
        print("Total for watching time: \(userDefaults.integer(forKey: forWatchingTimeKey))")
        return userDefaults.integer(forKey: forWatchingTimeKey)
    }

    func getAdjustedForWatchingTime() -> Int {
        let watchedFilmIds = getViewedFilmIds()
        let forWatchingFilmIds = getForWatchingFilmIds()

        // Исключаем фильмы, которые уже просмотрены
        let uniqueForWatchingFilmIds = Set(forWatchingFilmIds).subtracting(Set(watchedFilmIds))

        // Суммируем длительность только уникальных фильмов для просмотра
        let adjustedTime = uniqueForWatchingFilmIds.reduce(0) { total, filmId in
            if let duration = getFilmDuration(for: filmId) {
                return total + duration
            }
            return total
        }

        print("Adjusted for watching time: \(adjustedTime)")
        return adjustedTime
    }
}
