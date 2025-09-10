//
//  FavoriteViewModel.swift
//  CodeFlix
//
//  Created by Zhdanov Konstantin on 04.09.2025.
//

import UIKit

final class FavoriteViewModel {

    private let searchService = ApiService()
    private let imageService = ImageService.shared
    private(set) var films: [Film] = []
    private var imageLoadTasks: [IndexPath: UUID] = [:]
    private var currentPage = 1
    private var isLoading = false

}
