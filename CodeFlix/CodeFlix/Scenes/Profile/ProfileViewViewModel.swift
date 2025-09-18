//
//  ProfileViewViewModel.swift
//  CodeFlix
//
//  Created by Zhdanov Konstantin on 14.09.2025.
//

import Foundation

class ProfileViewViewModel: ObservableObject {
    private let filmViewedManager: FilmViewedManagerProtocol = FilmViewedManager()

    @Published var watchedTimeString: String = ""
    @Published var forWatchingTimeString: String = ""
    @Published var progressPercentage: String = "0"
    @Published var remainingTimeString: String = ""
    @Published var totalTimeString: String = ""
    @Published var progress = 0.0
    @Published var wathedTimeText = ""
    @Published var remainingTimeText = ""
    @Published var totalTimeText = ""
    @Published var fromTotalText = ""

    func loadTimeInfo() {
        let watchedTime = filmViewedManager.getTotalWatchedTime()
        let forWatchingTime = filmViewedManager.getTotalForWatchingTime()

        watchedTimeString = formatMinutesToTimeString(watchedTime)
        forWatchingTimeString = formatMinutesToTimeString(forWatchingTime)

        let totalTime = watchedTime + forWatchingTime
        totalTimeString = formatMinutesToTimeString(totalTime)

        remainingTimeString = formatMinutesToTimeString(totalTime - watchedTime)
        progressPercentage = calculateProgress(watchedTime: watchedTime, totalTime: totalTime)

        wathedTimeText = "Просмотрено \(watchedTimeString)"
        remainingTimeText = "Осталось \(remainingTimeString)"
        totalTimeText = "Всего \(totalTimeString)"
        fromTotalText = "Из \(totalTimeString)"
    }

    private func calculateProgress(watchedTime: Int, totalTime: Int) -> String {
        guard totalTime > 0 else {
            return "0"
        }
        progress = Double(watchedTime) / Double(totalTime)
        return String(format: "%.1f", progress * 100)
    }
}
