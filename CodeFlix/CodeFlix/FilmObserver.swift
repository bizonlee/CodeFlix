//
//  FilmObserver.swift
//  CodeFlix
//
//  Created by Zhdanov Konstantin on 13.09.2025.
//

import Foundation

protocol FilmObserver: AnyObject {
    func filmDidUpdate(_ film: Film)
}

final class FilmNotificationCenter {
    static let shared = FilmNotificationCenter()

    private var observers: [WeakObserver] = []

    private init() {}

    func addObserver(_ observer: FilmObserver) {
        observers.append(WeakObserver(observer: observer))
        cleanupObservers()
    }

    func removeObserver(_ observer: FilmObserver) {
        observers.removeAll { $0.observer === observer }
    }

    func notifyFilmUpdate(_ film: Film) {
        cleanupObservers()
        observers.forEach { $0.observer?.filmDidUpdate(film) }
    }

    private func cleanupObservers() {
        observers = observers.filter { $0.observer != nil }
    }

    private struct WeakObserver {
        weak var observer: FilmObserver?
    }
}
