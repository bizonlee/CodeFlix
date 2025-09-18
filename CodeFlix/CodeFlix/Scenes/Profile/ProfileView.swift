//
//  ProfileView.swift
//  CodeFlix
//
//  Created by Zhdanov Konstantin on 13.09.2025.
//


import SwiftUI

struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewViewModel()

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Потрачено")
                .font(.title2)
                .fontWeight(.bold)

            HStack(spacing: 30) {
                ZStack {
                    Circle()
                        .stroke(Color.gray.opacity(0.3),  lineWidth: 20)

                    Circle()
                        .trim(from: 0, to: CGFloat(viewModel.progress))
                        .stroke(Color.blue, style: StrokeStyle(lineWidth: 20, lineCap: .round))
                        .rotationEffect(.degrees(-90))

                    VStack {
                        Text(viewModel.watchedTimeString)
                            .font(.title3)
                            .fontWeight(.bold)
                        Text(viewModel.fromTotalText)
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
                .frame(width: 120, height: 120)

                VStack(alignment: .leading, spacing: 12) {
                    HStack(spacing: 8) {
                        Circle()
                            .fill(Color.blue)
                            .frame(width: 12, height: 12)
                        Text(viewModel.totalTimeText)
                            .font(.subheadline)
                    }

                    HStack(spacing: 8) {
                        Circle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: 12, height: 12)
                        Text(viewModel.remainingTimeText)
                            .font(.subheadline)
                    }

                    HStack(spacing: 8) {
                        Circle()
                            .fill(Color.clear)
                            .frame(width: 12, height: 12)
                        Text(viewModel.totalTimeText)
                            .font(.subheadline)
                    }
                }
            }
            .padding(.vertical)

            VStack(alignment: .leading, spacing: 10) {
                Text("Детализация:")
                    .fontWeight(.semibold)

                HStack() {
                    Text("Всего посмотрел")
                        .foregroundColor(.secondary)
                    Spacer()
                    Text(viewModel.watchedTimeString)
                }

                HStack() {
                    Text("Планирую посмотреть")
                        .foregroundColor(.secondary)
                    Spacer()
                    Text(viewModel.forWatchingTimeString)
                }

                HStack() {
                    Text("Осталось")
                        .foregroundColor(.secondary)
                    Spacer()
                    Text(viewModel.remainingTimeString)
                }

                HStack() {
                    Text("Процент просмотренного")
                        .foregroundColor(.secondary)
                    Spacer()
                    Text(viewModel.progressPercentage)
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .onAppear() {
            viewModel.loadTimeInfo()
        }
        Spacer()
    }
}

#Preview {
    ProfileView()
}
