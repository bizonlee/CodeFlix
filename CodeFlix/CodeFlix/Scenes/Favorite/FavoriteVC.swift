//
//  FavoriteVC.swift
//  CodeFlix
//
//  Created by Gryaznoy Alexander on 13.08.2025.
//
import UIKit

final class FavoriteVC: BaseViewController {

    private let viewModel = SearchViewModel()
    private let filmViewedManager: FilmViewedManagerProtocol = FilmViewedManager()
    private lazy var factory = FilmActionsFactory(filmViewedManager: filmViewedManager)

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
        title = "Избранное"
        setupViews()
        FilmNotificationCenter.shared.addObserver(self)
        viewModel.fetchFilmsByIds()

        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
    }

    deinit {
        FilmNotificationCenter.shared.removeObserver(self)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchFilmsByIds()
    }

    private func setupViews() {
        view.addSubview(tableView)
        view.addSubview(emptyStateLabel)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 140),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
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
        showErrorAlertController(message: message)
    }

    func updateUI(with films: [Film]) {
        tableView.reloadData()
        emptyStateLabel.isHidden = !films.isEmpty
    }
}

extension FavoriteVC: FilmCellDelegate {
    func filmCellDidTapMenu(_ cell: FilmCell, film: Film, sourceView: UIView) {
        factory.onReload = { [weak self] film in
            guard let self else { return }
            if let index = viewModel.films.firstIndex(where: { $0.id == film.id }) {
                let indexPath = IndexPath(row: index, section: 0)
                tableView.reloadRows(at: [indexPath], with: .automatic)
            }
        }
        let controller = factory.makeMenuController(for: film, sourceView: sourceView)
        present(controller, animated: true)
    }
}

extension FavoriteVC: FilmObserver {
    func filmDidUpdate(_ film: Film) {
        DispatchQueue.main.async {
            if !FilmViewedManager().isViewed(with: film.id) && !FilmViewedManager().isMarkedForWatching(with: film.id) {
                self.viewModel.fetchFilmsByIds()
            } else {
                if let index = self.viewModel.films.firstIndex(where: { $0.id == film.id }) {
                    let indexPath = IndexPath(row: index, section: 0)
                    self.tableView.reloadRows(at: [indexPath], with: .automatic)
                }
            }
        }
    }
}
