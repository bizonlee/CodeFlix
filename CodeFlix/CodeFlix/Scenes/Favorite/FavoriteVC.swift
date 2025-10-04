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
        tableView.delegate = self
        tableView.register(FilmCell.self, forCellReuseIdentifier: "FilmCell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 200
        return tableView
    }()

    private lazy var dataSource: UITableViewDiffableDataSource<Int, Film> = {
        let dataSource = UITableViewDiffableDataSource<Int, Film>(tableView: tableView) { tableView, indexPath, film in
            let cell = tableView.dequeueReusableCell(withIdentifier: "FilmCell", for: indexPath) as! FilmCell
            let cellViewModel = FilmCellViewModel(film: film)
            cell.configure(with: cellViewModel)
            cell.delegate = self
            return cell
        }
        return dataSource
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
        tableView.dataSource = dataSource
        FilmNotificationCenter.shared.addObserver(self)
        viewModel.fetchFilmsByIds()
        edgesForExtendedLayout = []
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
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            emptyStateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStateLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    private func applySnapshot(animatingDifferences: Bool = true) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, Film>()
        snapshot.appendSections([0])
        snapshot.appendItems(viewModel.films)
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
        emptyStateLabel.isHidden = !viewModel.films.isEmpty
    }

    func reloadFilm(_ film: Film) {
        guard let index = viewModel.films.firstIndex(where: { $0.id == film.id }) else { return }
        viewModel.films[index] = film
        var snapshot = dataSource.snapshot()
        snapshot.reloadItems([film])
        dataSource.apply(snapshot, animatingDifferences: true)
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
        viewModel.films = films
        applySnapshot()
    }
}

extension FavoriteVC: FilmCellDelegate {
    func filmCellDidTapMenu(_ cell: FilmCell, film: Film, sourceView: UIView) {
        factory.onReload = { [weak self] film in
            guard let self = self else { return }
            self.reloadFilm(film)
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
                self.reloadFilm(film)
            }
        }
    }
}
