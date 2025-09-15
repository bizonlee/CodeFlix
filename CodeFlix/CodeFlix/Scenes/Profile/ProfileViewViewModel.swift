//
//  ProfileViewViewModel.swift
//  CodeFlix
//
//  Created by Zhdanov Konstantin on 14.09.2025.
//

import Foundation

class ProfileViewViewModel: ObservableObject {
    private let filmViewedManager: FilmViewedManagerProtocol = FilmViewedManager()

    @Published var watchedTime: Int = 0
    @Published var forWatchingTime: Int = 0
    @Published var progress: Double = 0
    @Published var progressPercentage: String = "0"

    func loadTimeInfo() {
        watchedTime = filmViewedManager.getTotalWatchedTime()
        forWatchingTime = filmViewedManager.getTotalForWatchingTime()
        progressPercentage = calculateProgress()
        progress = Double(watchedTime) / Double(forWatchingTime)
    }

    func calculateProgress() -> String {
        guard forWatchingTime > 0 else {
            return "0"
        }
        progress = Double(watchedTime) / Double(forWatchingTime)
        progressPercentage = String(format: "%.1f", progress * 100)
        return progressPercentage
    }
}
