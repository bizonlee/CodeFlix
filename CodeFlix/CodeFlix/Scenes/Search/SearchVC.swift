//
//  SearchVC.swift
//  CodeFlix
//
//  Created by Zhdanov Konstantin on 06.08.2025.
//

import UIKit

final class SearchVC: UIViewController {

    private let viewModel = SearchViewModel()
    private let filmViewedManager: FilmViewedManagerProtocol = FilmViewedManager()
    private var searchTimer: Timer?
    private let debounceInterval: TimeInterval = 0.5

    private lazy var searchTextField: UISearchTextField = {
        let textField = UISearchTextField()
        textField.placeholder = "Search..."
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.layer.cornerRadius = 8.0
        textField.layer.masksToBounds = true
        textField.layer.borderWidth = 1.0
        textField.addTarget(self, action: #selector(searchTextFieldDidChange), for: .editingChanged)
        return textField
    }()

    private lazy var searchButton: UIButton = {
        let button = UIButton()
        button.setTitle("Search", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(FilmCell.self, forCellReuseIdentifier: "FilmCell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 200
        return tableView
    }()

    // TODO: - вернуть когда во вьюмодели добавится признак пустого поиска
//    private lazy var noResultsLabel: UILabel = {
//        let label = UILabel()
//        label.text = "Нет результатов"
//        label.textColor = .white
//        label.textAlignment = .center
//        label.font = UIFont.systemFont(ofSize: 16)
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.isHidden = true
//        return label
//    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Поиск"
        view.backgroundColor = .white
        viewModel.delegate = self
        setupViews()
        setupConstraints()
        viewModel.fetchPopularFilms()
    }

    private func setupViews() {
        view.addSubview(searchTextField)
        view.addSubview(searchButton)
        view.addSubview(tableView)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            searchTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            searchTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            searchTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -100),

            searchButton.topAnchor.constraint(equalTo: searchTextField.topAnchor),
            searchButton.leadingAnchor.constraint(equalTo: searchTextField.trailingAnchor, constant: 10),
            searchButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            searchButton.bottomAnchor.constraint(equalTo: searchTextField.bottomAnchor),

            tableView.topAnchor.constraint(equalTo: searchButton.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)//,
        ])
    }

    @objc
    private func searchButtonTapped() {
        guard let query = searchTextField.text, !query.isEmpty else {
            viewModel.fetchPopularFilms()
            return
        }
        viewModel.searchFilms(query: query)
    }

    @objc
    private func searchTextFieldDidChange(_ textField: UISearchTextField) {
        searchTimer?.invalidate()
        searchTimer = Timer.scheduledTimer(
            timeInterval: debounceInterval,
            target: self,
            selector: #selector(searchButtonTapped),
            userInfo: nil,
            repeats: false
        )
    }
}

extension SearchVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.films.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FilmCell", for: indexPath) as! FilmCell
        let film = viewModel.films[indexPath.row]
        let cellViewModel = FilmCellViewModel(film: film)
        cell.configure(with: cellViewModel)
        return cell
    }
}

extension SearchVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastElement = viewModel.films.count - 1
        if indexPath.row == lastElement, let query = searchTextField.text, !query.isEmpty {
            viewModel.searchFilms(query: query, isNewSearch: false)
        }
        if let filmCell = cell as? FilmCell {
            filmCell.delegate = self
        }
    }
}


extension SearchVC: SearchViewModelDelegate {
    func showErrorAlert(message: String) {
        let alert = UIAlertController(
            title: "Ошибка",
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    func updateUI(with films: [Film]) {
        tableView.reloadData()
    }
}

extension SearchVC {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let film = viewModel.films[indexPath.row]
        let filmVC = FilmVC(film: film)
        navigationController?.pushViewController(filmVC, animated: true)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension SearchVC: FilmCellDelegate {
    func filmCellDidTapMenu(_ cell: FilmCell, film: Film, sourceView: UIView) {
        showMenuForFilm(film, sourceView: sourceView)
    }

    private func showMenuForFilm(_ film: Film, sourceView: UIView) {
        let alertController = UIAlertController(
            title: film.title,
            message: nil,
            preferredStyle: .actionSheet
        )

        let watchLaterAction = UIAlertAction(
            title: "Буду смотреть",
            style: .default
        ) { [weak self] _ in
            self?.watchLaterTapped(for: film)
        }

        let viewedAction = UIAlertAction(
            title: "Посмотрел",
            style: .default
        ) { [weak self] _ in
            self?.viewedTapped(for: film)
        }

        let shareAction = UIAlertAction(
            title: "Поделиться",
            style: .default
        ) { [weak self] _ in
            self?.shareTapped(for: film)
        }

        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel)

        alertController.addAction(watchLaterAction)
        alertController.addAction(viewedAction)
        alertController.addAction(shareAction)
        alertController.addAction(cancelAction)

        if let popoverController = alertController.popoverPresentationController {
            popoverController.sourceView = sourceView
            popoverController.sourceRect = sourceView.bounds
            popoverController.permittedArrowDirections = [.up]
        }

        present(alertController, animated: true)
    }

    private func watchLaterTapped(for film: Film) {
        let isCurrentlyMarked = filmViewedManager.isMarkedForWatching(with: film.id)

        if isCurrentlyMarked {
            filmViewedManager.removeFilmFromWatchLater(with: film.id)
        } else {
            filmViewedManager.markForWatching(with: film.id)
        }

        if let index = viewModel.films.firstIndex(where: { $0.id == film.id }) {

            // хотел сделать по другому, думал на тап по ячейке запоминать индекс и если тап по ячейке и заодно это тап по кнопке 3 точки, то тогда запоминаем индекс и его уже обновляем, но вроде так проще получилось кодом. может в производительости проигрывает, я хз оставлю так, но и так оптимизиовал норм вместо reloadData всей таблицы, я считаю

            let indexPath = IndexPath(row: index, section: 0)
            tableView.reloadRows(at: [indexPath], with: .automatic)

            
        }
    }

    private func viewedTapped(for film: Film) {
        let isCurrentlyViewed = filmViewedManager.isViewed(with: film.id)

        if isCurrentlyViewed {
            filmViewedManager.removeFilmFromViewed(with: film.id)
        } else {
            filmViewedManager.markFilmAsViewed(with: film.id)
        }

        if let index = viewModel.films.firstIndex(where: { $0.id == film.id }) {
            let indexPath = IndexPath(row: index, section: 0)
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }

    private func shareTapped(for film: Film) {
        print("Поделиться: \(film.title)")
    }
}
