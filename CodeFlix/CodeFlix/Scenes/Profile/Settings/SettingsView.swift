//
//  SettingsView.swift
//  CodeFlix
//
//  Created by Zhdanov Konstantin on 27.09.2025.
//

import SwiftUI

struct SettingsView: View {
    @StateObject private var viewModel = SettingsViewModel()
    @State private var showDeleteAlert: Bool = false

    var body: some View {
        List {
            Section {
                HStack {
                    Text("Занято")
                    Spacer()
                    Text(
                        ByteCountFormatter.string(
                            fromByteCount: Int64(viewModel.diskSize),
                            countStyle: .file
                        )
                    )
                    .foregroundStyle(.secondary)
                }
            }

            Section {
                Button(role: .destructive) {
                    showDeleteAlert = true
                } label: {
                    Text("Очистить кэш")
                        .frame(maxWidth: .infinity, alignment: .center)
                }
            }

            if !viewModel.files.isEmpty {
                Section("Файлы") {
                    ForEach(viewModel.files, id: \.url) { file in
                        HStack {
                            Text(file.url.lastPathComponent)
                                .font(.subheadline)
                                .lineLimit(1)

                            Spacer()

                            Text(
                                ByteCountFormatter.string(
                                    fromByteCount: Int64(file.size),
                                    countStyle: .file
                                )
                            )
                            .foregroundStyle(.secondary)
                        }
                    }
                }
            }
        }
        .onAppear(perform: { viewModel.refresh() })
        .alert("Удалить весь кэш?", isPresented: $showDeleteAlert) {
            Button("Удалить", role: .destructive) {
                viewModel.clear()
            }
            Button("Отмена", role: .cancel) {}
        }
    }
}

struct CacheFileInfo {
    let url: URL
    let size: UInt64
}
