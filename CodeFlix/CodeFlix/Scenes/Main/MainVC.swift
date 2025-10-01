import UIKit

final class MainVC: UIViewController, UICollectionViewDelegate {

    private let viewModel = SearchViewModel()
    private let genres = ["ужасы", "комедия"]
    private var responseFilm: [Film] = []
    private var groupedFilms: [[Film]] = []

    private lazy var compositionalLayout: UICollectionViewCompositionalLayout = {
        let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(150), heightDimension: .absolute(250))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(150), heightDimension: .absolute(250))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = .fixed(8)

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0)

        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        section.boundarySupplementaryItems = [sectionHeader]

        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }()

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: compositionalLayout)
        collectionView.register(FilmItem.self, forCellWithReuseIdentifier: "FilmItem")
        collectionView.register(GenreHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "GenreHeader")
        collectionView.dataSource = self
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "CodeFlix"

        collectionView.backgroundColor = .secondarySystemBackground
        view.backgroundColor = .secondarySystemBackground

        collectionView.delegate = self

        viewModel.delegate = self
        viewModel.searchFilmsByGenres(genres: genres)

        view.addSubview(collectionView)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        collectionView.frame = .init(
            origin: .init(
                x: 0,
                y: 150),
            size: .init(
                width: view.bounds.width,
                height: view.bounds.height))
    }
}

// MARK: - DataSource & Delegate

extension MainVC: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        groupedFilms.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        groupedFilms[section].count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FilmItem", for: indexPath) as! FilmItem
        let film = groupedFilms[indexPath.section][indexPath.item]
        cell.configure(
            title: film.title,
            imageURL: film.poster?.url ?? ""
        )
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let film = groupedFilms[indexPath.section][indexPath.item]
        let filmVC = FilmVC(film: film)
        navigationController?.pushViewController(filmVC, animated: true)
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "GenreHeader", for: indexPath) as! GenreHeaderView
            header.titleLabel.text = genres[indexPath.section].capitalized
            return header
        }
        return UICollectionReusableView()
    }
}

extension MainVC {
    private func sortFilms(films: [Film], by genres: [String]) {
        var grouped: [[Film]] = []
        for genre in genres {
            let filmsForGenre = films.filter { film in
                guard let filmGenres = film.genres else { return false }
                return filmGenres.contains { $0.name == genre }
            }
            grouped.append(filmsForGenre)
        }
        groupedFilms = grouped
    }
}

extension MainVC: SearchViewModelDelegate {
    func showErrorAlert(message: String) {
        showErrorAlertController(message: message)
    }
    func updateUI(with films: [Film]) {
        DispatchQueue.main.async {
            self.responseFilm = films
            self.sortFilms(films: films, by: self.genres)
            self.collectionView.reloadData()
        }
    }
}

class GenreHeaderView: UICollectionReusableView {
    let titleLabel = UILabel()
    override init(frame: CGRect) {
        super.init(frame: frame)
        titleLabel.font = .boldSystemFont(ofSize: 24)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
