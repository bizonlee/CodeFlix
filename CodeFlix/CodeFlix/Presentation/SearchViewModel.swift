//
//  SearchViewModel.swift
//  CodeFlix
//
//  Created by Zhdanov Konstantin on 07.08.2025.
//

import UIKit

protocol SearchViewModelDelegate: AnyObject {
    func updateUI(with films: [Film])
    func showErrorAlert(message: String)
}

class SearchViewModel {

    weak var delegate: SearchViewModelDelegate?
    private let searchService = ApiService()
    private let imageService = ImageService.shared
    var films: [Film] = []
    private var imageLoadTasks: [IndexPath: UUID] = [:]
    private var currentPage = 1
    private var isLoading = false
    private var hasMore = true

    func searchFilms(query: String, isNewSearch: Bool = true) {
        guard !query.isEmpty else {
            films = []
            delegate?.updateUI(with: films)
            return
        }

        if isNewSearch {
            currentPage = 1
            films = []
            hasMore = true
        }

        guard !isLoading && hasMore else { return }

        isLoading = true

        searchService.searchMovies(query: query, page: currentPage) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false

                switch result {
                case .success(let newFilms):
                    self?.films += newFilms
                    self?.hasMore = !newFilms.isEmpty
                    self?.currentPage += 1
                case .failure(let error):
                    print("Search error: \(error.localizedDescription)")
                }
                self?.delegate?.updateUI(with: self?.films ?? [])
            }
        }
    }

    func fetchPopularFilms() {
        searchService.fetchHighRatedMovies { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let films):
                    self?.films = films
                case .failure(let error):
                    print("Popular films error: \(error.localizedDescription)")
                    self?.films = []

                    self?.delegate?.showErrorAlert(message: "Не удалось загрузить популярные фильмы: \(error.localizedDescription)")
                }
                self?.delegate?.updateUI(with: self?.films ?? [])
            }
        }
    }

    func loadImage(for film: Film, at indexPath: IndexPath, completion: @escaping (UIImage?) -> Void) {
        imageService.loadImage(from: film.poster?.url, completion: completion)
    }
}
