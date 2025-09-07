//
//  FavoriteVC.swift
//  CodeFlix
//
//  Created by Gryaznoy Alexander on 13.08.2025.
//
import UIKit

final class FavoriteVC: UIViewController {

    private let viewModel = SearchViewModel()
    private let filmViewedManager: FilmViewedManagerProtocol = FilmViewedManager()

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

    private lazy var emptyStateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Нет избранных фильмов"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .gray
        label.isHidden = true
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        title = "Лайки"
        setupViews()
        viewModel.fetchFilmsByIds()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchFilmsByIds()
    }

    private func setupViews() {
        view.addSubview(tableView)
        view.addSubview(emptyStateLabel)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            emptyStateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStateLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

extension FavoriteVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = viewModel.films.count
        emptyStateLabel.isHidden = count > 0
        return count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FilmCell", for: indexPath) as! FilmCell
        let film = viewModel.films[indexPath.row]
        let cellViewModel = FilmCellViewModel(film: film)
        cell.configure(with: cellViewModel)
        cell.delegate = self
        return cell
    }
}

extension FavoriteVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let film = viewModel.films[indexPath.row]
        let filmVC = FilmVC(film: film)
        navigationController?.pushViewController(filmVC, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension FavoriteVC: SearchViewModelDelegate {
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
        emptyStateLabel.isHidden = !films.isEmpty
    }
}

extension FavoriteVC: FilmCellDelegate {
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
