//
//  SearchVC.swift
//  CodeFlix
//
//  Created by Zhdanov Konstantin on 06.08.2025.
//

import UIKit

final class SearchVC: UIViewController {

    private let viewModel = SearchViewModel()

    private lazy var searchTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Search..."
        textField.translatesAutoresizingMaskIntoConstraints = false

        let placeholderColor = UIColor(white: 0.5, alpha: 1.0)

        textField.layer.cornerRadius = 8.0
        textField.layer.masksToBounds = true

        textField.layer.borderWidth = 1.0
        textField.layer.borderColor = UIColor(white: 0.3, alpha: 1.0).cgColor

        let searchIcon = UIImageView(image: UIImage(systemName: "magnifyingglass"))
        searchIcon.tintColor = placeholderColor
        searchIcon.contentMode = .scaleAspectFit

        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 20))
        searchIcon.frame = CGRect(x: 8, y: 0, width: 20, height: 20)
        paddingView.addSubview(searchIcon)

        textField.leftView = paddingView
        textField.leftViewMode = .always
        textField.heightAnchor.constraint(equalToConstant: 30).isActive = true

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

    @objc private func searchButtonTapped() {
        searchTextField.resignFirstResponder()
        guard let query = searchTextField.text, !query.isEmpty else {
            updateUI(with: [])
            return
        }
        viewModel.searchFilms(query: query)
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
