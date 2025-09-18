//
//  TimeFormatter.swift
//  CodeFlix
//
//  Created by Zhdanov Konstantin on 17.09.2025.
//



public func formatMinutesToTimeString(_ minutes: Int) -> String {
    guard minutes > 0 else {
        return "0 мин"
    }

    let days = minutes / (24 * 60)
    let hours = (minutes % (24 * 60)) / 60
    let mins = minutes % 60

    switch (days, hours, mins) {
    case (0, 0, let m) where m > 0:
        return "\(m) мин"
    case (0, let h, 0):
        return "\(h) ч"
    case (0, let h, let m):
        return "\(h) ч \(m) мин"
    case (let d, 0, 0):
        return "\(d) д"
    case (let d, let h, 0):
        return "\(d) д \(h) ч"
    case (let d, 0, let m):
        return "\(d) д \(m) мин"
    default:
        return "\(days) д \(hours) ч \(mins) мин"
    }
}
