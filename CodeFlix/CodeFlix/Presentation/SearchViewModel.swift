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

        searchService.searchMovies(query: query) { [weak self] result, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Search error: \(error.localizedDescription)")
                    self?.films = []
                } else if let result = result {
                    self?.films = result
                }
                self?.view?.updateUI(with: self?.films ?? [])
            }
        }
    }
}
