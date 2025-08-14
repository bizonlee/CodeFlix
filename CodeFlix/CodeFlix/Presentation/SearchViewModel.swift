//
//  SearchViewModel.swift
//  CodeFlix
//
//  Created by Zhdanov Konstantin on 07.08.2025.
//

import UIKit

class SearchViewModel {

    weak var view: SearchVC?
    private let searchService = ApiService()
    var films: [Film] = []

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

                    let alert = UIAlertController(
                        title: "Ошибка",
                        message: "Не удалось загрузить популярные фильмы: \(error.localizedDescription)",
                        preferredStyle: .alert
                    )
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    self?.view?.present(alert, animated: true)
                }
                self?.view?.updateUI(with: self?.films ?? [])
            }
        }
    }
}
