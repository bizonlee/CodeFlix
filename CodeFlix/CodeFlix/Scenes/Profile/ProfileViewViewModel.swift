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
    @Published var remainingTime: Int = 0
    @Published var totalTime: Int = 0

    func loadTimeInfo() {
        watchedTime = filmViewedManager.getTotalWatchedTime()
        forWatchingTime = filmViewedManager.getTotalForWatchingTime()
        totalTime = watchedTime + forWatchingTime
        remainingTime = totalTime - watchedTime
        progress = Double(watchedTime) / Double(totalTime)
        progressPercentage = calculateProgress()
    }

    func calculateProgress() -> String {
        guard totalTime > 0 else {
            return "0"
        }
        progress = Double(watchedTime) / Double(totalTime)
        progressPercentage = String(format: "%.1f", progress * 100)
        return progressPercentage
    }
}

