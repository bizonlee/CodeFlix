//
//  SettingsViewModel.swift
//  CodeFlix
//
//  Created by Zhdanov Konstantin on 27.09.2025.
//

import SwiftUI

final class SettingsViewModel: ObservableObject {
    @Published var diskSize: UInt64 = 0
    @Published var files: [CacheFileInfo] = []

    func refresh() {
        diskSize = ImageCache.shared.getSize()
        files = ImageCache.shared.fileLists()
    }

    func clear() {
        ImageCache.shared.clear {
            self.refresh()
        }
    }
}
