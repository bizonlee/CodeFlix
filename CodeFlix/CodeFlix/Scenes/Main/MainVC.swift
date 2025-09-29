import UIKit

final class MainVC: UIViewController, UICollectionViewDelegate {

    private let viewModel = SearchViewModel()
    private let genres = ["комедии", "ужасы"]
    private var responseFilm: [Film] = []
    private var groupedFilms: [[Film]] = []



    private lazy var titleBanner: UIImageView = {
        let banner = UIImageView()
        banner.image = UIImage(named: "MainBanner")
        banner.contentMode = .scaleAspectFill
        return banner
    }()

    private lazy var compositionalLayout = {
        let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(150), heightDimension: .absolute(250))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(150), heightDimension: .absolute(250))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = .fixed(8)

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0)

        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }()

    private lazy var collectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: compositionalLayout)
        collectionView.register(FilmItem.self, forCellWithReuseIdentifier: "FilmItem")
        collectionView.dataSource = self
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = UIColor(red: 0/255, green: 74/255, blue: 110/255, alpha: 1.0)
        view.backgroundColor = UIColor(red: 0/255, green: 74/255, blue: 110/255, alpha: 1.0)

        collectionView.delegate = self

        viewModel.delegate = self
        viewModel.searchFilmsByGenres(genres: genres)

        view.addSubview(collectionView)
        view.addSubview(titleBanner)
    }

    //MARK: - Setup Subviews

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        titleBanner.frame = .init(
            origin: .zero,
            size: .init(
                width: view.bounds.width,
                height: 180))


        collectionView.frame = .init(
            origin: .init(
                x: 0,
                y: titleBanner.frame.height + 50),
            size: .init(
                width: view.bounds.width,
                height: view.bounds.height - titleBanner.frame.height))
    }
}

    //MARK: - Setup Data CollectionView

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
