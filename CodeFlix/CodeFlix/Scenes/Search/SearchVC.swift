//
//  SearchVC.swift
//  CodeFlix
//
//  Created by Zhdanov Konstantin on 06.08.2025.
//

import UIKit

final class SearchVC: BaseViewController {

    private enum Section {
        case films
    }

    private lazy var factory = FilmActionsFactory(filmViewedManager: filmViewedManager)
    private let viewModel = SearchViewModel()
    private let filmViewedManager: FilmViewedManagerProtocol = FilmViewedManager()
    private var searchTimer: Timer?
    private let debounceInterval: TimeInterval = 0.5

    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "Search..."
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.delegate = self
        searchController.searchBar.searchTextField.addTarget(
            self,
            action: #selector(searchTextFieldDidChange),
            for: .editingChanged
        )
        searchController.automaticallyShowsSearchResultsController = false
        return searchController
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.register(FilmCell.self, forCellReuseIdentifier: "FilmCell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 200
        tableView.keyboardDismissMode = .onDrag
        return tableView
    }()

    private lazy var noResultsLabel: UILabel = {
        let label = UILabel()
        label.text = "По вашему запросу фильмов не найдено"
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var dataSource: UITableViewDiffableDataSource<Section, Film> = {
        let dataSource = UITableViewDiffableDataSource<Section, Film>(tableView: tableView) { tableView, indexPath, film in
            let cell = tableView.dequeueReusableCell(withIdentifier: "FilmCell", for: indexPath) as! FilmCell
            let cellViewModel = FilmCellViewModel(film: film)
            cell.configure(with: cellViewModel)
            return cell
        }
        return dataSource
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        view.backgroundColor = .systemBackground
        viewModel.delegate = self
        setupViews()
        setupConstraints()
        FilmNotificationCenter.shared.addObserver(self)
        tableView.dataSource = dataSource
        viewModel.fetchPopularFilms()
        edgesForExtendedLayout = []
        setupCopiedLink()
    }

    deinit {
        FilmNotificationCenter.shared.removeObserver(self)
    }

    private func setupNavigationBar() {
        title = "Поиск"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }

    private func setupViews() {
        view.addSubview(tableView)
        view.addSubview(noResultsLabel)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            noResultsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noResultsLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    @objc
    private func searchButtonTapped() {
        guard let query = searchController.searchBar.text, !query.isEmpty else {
            searchBarCancelButtonClicked(searchController.searchBar)
            return
        }
        viewModel.searchFilms(query: query)
    }

    @objc
    private func searchTextFieldDidChange(_ textField: UITextField) {
        searchTimer?.invalidate()
        searchTimer = Timer.scheduledTimer(
            timeInterval: debounceInterval,
            target: self,
            selector: #selector(searchButtonTapped),
            userInfo: nil,
            repeats: false
        )
    }

    private func applySnapshot(animatingDifferences: Bool = false) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Film>()
        snapshot.appendSections([.films])
        snapshot.appendItems(viewModel.films, toSection: .films)
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
}

// MARK: - UISearchBarDelegate
extension SearchVC: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.fetchPopularFilms()
        tableView.setContentOffset(.zero, animated: true)
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        tableView.setContentOffset(.zero, animated: true)
        searchTimer?.invalidate()
        searchButtonTapped()
        searchController.searchBar.resignFirstResponder()
        tableView.setContentOffset(.zero, animated: true)
    }
}

extension SearchVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastElement = viewModel.films.count - 1
        if indexPath.row == lastElement {
            if let query = searchController.searchBar.text, !query.isEmpty {
                viewModel.searchFilms(query: query, isNewSearch: false)
            }
        }
        if let filmCell = cell as? FilmCell {
            filmCell.delegate = self
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let film = dataSource.itemIdentifier(for: indexPath) {
            let filmVC = FilmVC(film: film)
            navigationController?.pushViewController(filmVC, animated: true)
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
}

extension SearchVC: SearchViewModelDelegate {
    func showErrorAlert(message: String) {
        showErrorAlertController(message: message)
    }

    func updateUI(with films: [Film]) {
        applySnapshot(animatingDifferences: false)
        noResultsLabel.isHidden = !films.isEmpty
    }
}

extension SearchVC: FilmCellDelegate {
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

extension SearchVC: FilmObserver {
    func filmDidUpdate(_ film: Film) {
        DispatchQueue.main.async {
            if let index = self.viewModel.films.firstIndex(where: { $0.id == film.id }) {
                let indexPath = IndexPath(row: index, section: 0)
                self.tableView.reloadRows(at: [indexPath], with: .automatic)
            }
        }
    }
}

private extension SearchVC {
    func setupCopiedLink() {
        factory.onCopyLinkTap = { [weak self] in
            guard let self = self else { return }
            let alert = UIAlertController(
                title: "Ссылка скопирована",
                message: nil,
                preferredStyle: .alert)

            self.present(alert, animated: true) {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    alert.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
}
