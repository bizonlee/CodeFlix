import UIKit

struct Film12 { }

final class MainVC: UIViewController {

    private var data = {
        let drama = [Film12](repeating: Film12(), count: 20)
        let comedia = [Film12](repeating: Film12(), count: 40)
        return [drama, comedia]
    }()

    private lazy var compositionalLayout = {
        let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(150), heightDimension: .absolute(250))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(150), heightDimension: .absolute(250))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = .fixed(8)

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = .init(top: 0, leading: 0, bottom: 5, trailing: 0)

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
        view.addSubview(collectionView)
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        collectionView.frame = view.bounds
    }
}

extension MainVC: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        data.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        data[section].count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FilmItem", for: indexPath) as! FilmItem
        cell.configure(title: "Cell \(indexPath)", image: UIImage(systemName: "photo"))
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor.label.cgColor
        return cell
    }
}
