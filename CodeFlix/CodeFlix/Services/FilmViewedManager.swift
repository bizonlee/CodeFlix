//
//  FilmViewedManager.swift
//  CodeFlix
//
//  Created by Zhdanov Konstantin on 26.08.2025.
//
import Foundation


protocol FilmViewedManagerProtocol {
    func markFilmAsViewed(with filmId: Int)
    func isViewed(with filmId: Int) -> Bool
}

final class FilmViewedManager {
    private let viewedKey: String = "viewed"

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
}
