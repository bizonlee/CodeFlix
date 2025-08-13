//
//  SearchViewModel.swift
//  CodeFlix
//
//  Created by Zhdanov Konstantin on 07.08.2025.
//

import Foundation

class SearchViewModel {

    weak var view: SearchVC?
    private let searchService = ApiService()
    private var films: [Film] = []

    func searchFilms(query: String) {
        guard !query.isEmpty else {
            films = []
            view?.updateUI(with: films)
            return
        }

        searchService.searchMovies(query: query) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let films):
                    self?.films = films
                case .failure(let error):
                    print("Search error: \(error.localizedDescription)")
                    self?.films = []
                }
                self?.view?.updateUI(with: self?.films ?? [])
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
                }
                self?.view?.updateUI(with: self?.films ?? [])
            }
        }
    }
}
