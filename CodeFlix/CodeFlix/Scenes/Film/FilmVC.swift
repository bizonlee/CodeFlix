//
//  FilmVC.swift
//  CodeFlix
//
//  Created by Gryaznoy Alexander on 17.08.2025.
//

import UIKit

final class FilmVC: UIViewController {
    
    // MARK: - Private properties
    private let film: Film
    private let filmViewedManager: FilmViewedManagerProtocol = FilmViewedManager()

    let scrollView: UIScrollView = UIScrollView()
    private let contentView: UIView = UIView()

    private let filmCover = UIImageView()
    private let filmTitle = UILabel()
    private let ratingAndAlternativeName = UILabel()
    private let filmYearAndGenres: UILabel = UILabel()
    private let filmCountriesAndLength: UILabel = UILabel()
    private let actionBar: UIStackView = UIStackView()
    private let filmDescription: UILabel = UILabel()
    private var likeButton: CustomActionButton?
    private var watchLaterButton: CustomActionButton?

    // MARK: - init
    
    init(film: Film) {
        self.film = film
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Life cyrcle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setPoster()
        setupUI()
        setupLayout()
        FilmNotificationCenter.shared.addObserver(self)
        updateActionButtonsState()
    }

    deinit {
        FilmNotificationCenter.shared.removeObserver(self)
    }

    private func updateActionButtonsState() {
        for case let button as CustomActionButton in actionBar.arrangedSubviews {
            if let index = actionBar.arrangedSubviews.firstIndex(of: button) {
                let actionType = FilmActionsType.allCases[index]

                switch actionType {
                case .like:
                    button.isSelected = filmViewedManager.isViewed(with: film.id)
                case .watchLater:
                    button.isSelected = filmViewedManager.isMarkedForWatching(with: film.id)
                default:
                    break
                }
            }
        }
    }

    //MARK: - Setup

    private func setupUI() {
        view.backgroundColor = .secondarySystemBackground

        setupFilmCover()
        setupTitle()
        setupRatingAndAlternativeName()
        setupYearAndGenres()
        setupCountriesAndLength()
        setupActionBar()
        setupDescription()

        scrollView.contentInsetAdjustmentBehavior = .never

        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

        // add subviews
        [filmCover,
         filmTitle,
         ratingAndAlternativeName,
         filmYearAndGenres,
         filmCountriesAndLength,
         actionBar,
         filmDescription].forEach {
            contentView.addSubview($0)
        }
    }

    //MARK: - Setup Film Info

    private func setupFilmCover() {
        filmCover.contentMode = .scaleAspectFit
        filmCover.clipsToBounds = true
    }
    
    private func setupTitle() {
        filmTitle.text = film.title
        filmTitle.font = .systemFont(ofSize: 27, weight: .bold)
        filmTitle.textColor = .label
        filmTitle.textAlignment = .center
        filmTitle.numberOfLines = 2
        filmTitle.lineBreakMode = .byTruncatingTail
    }

    private func setupRatingAndAlternativeName() {
        ratingAndAlternativeName.text = film.alternativeName?.description ?? ""

        ratingAndAlternativeName.font = .systemFont(ofSize: 14, weight: .medium)
        ratingAndAlternativeName.textColor = .secondaryLabel
        ratingAndAlternativeName.textAlignment = .center
        ratingAndAlternativeName.numberOfLines = 0

    }

    private func setPoster() {
        ImageService.shared.loadImage(from: film.poster?.url) { [weak self] image in
            self?.filmCover.image = image ?? UIImage(named: "placeholder")
        }
    }

    private func setupYearAndGenres() {
        let year: [String] = {
            guard let year = film.year else { return [] }
            return [String(year)]
        }()
        let genres = film.genres?.map { $0.name } ?? []
        let result = (year + genres).joined(separator: ", ")
        filmYearAndGenres.text = result

        filmYearAndGenres.font = .systemFont(ofSize: 14, weight: .medium)
        filmYearAndGenres.textColor = .secondaryLabel
        filmYearAndGenres.textAlignment = .center
        filmYearAndGenres.numberOfLines = 0
    }

    private func setupCountriesAndLength() {
        let countries = film.countries?.map { $0.name } ?? []

        let filmLength: [String] = {
            guard let length = film.movieLength else { return [] }
            return ["\(String(length / 60)) ч " + "\(String(length % 60)) мин"]
        }()
        filmCountriesAndLength.text = (countries + filmLength).joined(separator: ", ")

        filmCountriesAndLength.font = .systemFont(ofSize: 14, weight: .medium)
        filmCountriesAndLength.textColor = .secondaryLabel
        filmCountriesAndLength.textAlignment = .center
        filmCountriesAndLength.numberOfLines = 0
    }

    //MARK: - Setup ActionBar

    private func setupActionBar() {
        for type in FilmActionsType.allCases {
            let button = CustomActionButton()
            button.setupImage(type.imageNormalState, for: .normal)
            button.setupImage(type.imageSelectedState, for: .selected)
            button.setupTitle(type.title)

            switch type {
            case .like:
                likeButton = button
                button.onTap = { [weak self] in
                    self?.likeTapped(button)
                }
            case .watchLater:
                watchLaterButton = button
                button.onTap = { [weak self] in
                    self?.watchLaterTapped(button)
                }
            case .share:
                button.onTap = { [weak self] in
                    self?.shareTapped()
                }
            case .more:
                button.onTap = { [weak self] in
                    self?.moreTapped()
                }
            }

            actionBar.addArrangedSubview(button)
        }

        actionBar.axis = .horizontal
        actionBar.distribution = .fillEqually
        actionBar.spacing = 10
    }

    private func updateButtonsState() {
        likeButton?.isSelected = filmViewedManager.isViewed(with: film.id)
        watchLaterButton?.isSelected = filmViewedManager.isMarkedForWatching(with: film.id)
    }

    @objc
    private func likeTapped(_ button: CustomActionButton) {
        if filmViewedManager.isViewed(with: film.id) {
            filmViewedManager.removeFilmFromViewed(with: film.id, film.movieLength ?? 0)
        } else {
            filmViewedManager.markFilmAsViewed(with: film.id, film.movieLength ?? 0)
        }
        updateButtonsState()
        FilmNotificationCenter.shared.notifyFilmUpdate(film)
    }

    @objc
    private func watchLaterTapped(_ button: CustomActionButton) {
        if filmViewedManager.isMarkedForWatching(with: film.id) {
            filmViewedManager.removeFilmFromWatchLater(with: film.id, film.movieLength ?? 0)
        } else {
            filmViewedManager.markForWatching(with: film.id,  film.movieLength ?? 0)
        }
        updateButtonsState()
        FilmNotificationCenter.shared.notifyFilmUpdate(film)
    }

    @objc
    private func shareTapped() {
        print("Share tapped")

    }

    @objc
    func moreTapped() {
        print("More tapped")

    }

    // MARK: - Setup Description

    private func setupDescription() {
        filmDescription.text = film.description

        filmDescription.font = .systemFont(ofSize: 16, weight: .light)
        filmDescription.textColor = .label
        filmDescription.numberOfLines = 0
    }

    //MARK: - Layout
    
    func setupLayout() {
        [
            scrollView,
            contentView,
            filmCover,
            filmTitle,
            filmYearAndGenres,
            filmDescription,
            filmCountriesAndLength,
            ratingAndAlternativeName,
            actionBar,
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            filmCover.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 100),
            filmCover.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            filmCover.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            filmCover.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            filmCover.heightAnchor.constraint(equalTo: filmCover.widthAnchor),

            filmTitle.topAnchor.constraint(equalTo: filmCover.bottomAnchor, constant: 15),
            filmTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            filmTitle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),

            ratingAndAlternativeName.topAnchor.constraint(equalTo: filmTitle.bottomAnchor, constant: 15),
            ratingAndAlternativeName.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            ratingAndAlternativeName.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),

            filmYearAndGenres.topAnchor.constraint(equalTo: ratingAndAlternativeName.bottomAnchor),
            filmYearAndGenres.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 40),
            filmYearAndGenres.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -40),

            filmCountriesAndLength.topAnchor.constraint(equalTo: filmYearAndGenres.bottomAnchor),
            filmCountriesAndLength.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 40),
            filmCountriesAndLength.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -40),

            actionBar.topAnchor.constraint(equalTo: filmCountriesAndLength.bottomAnchor, constant: 20),
            actionBar.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30),
            actionBar.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30),

            filmDescription.topAnchor.constraint(equalTo: actionBar.bottomAnchor, constant: 30),
            filmDescription.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            filmDescription.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            filmDescription.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -90)
        ])
    }
}

extension FilmVC: FilmObserver {
    func filmDidUpdate(_ updatedFilm: Film) {
        guard updatedFilm.id == film.id else { return }

        DispatchQueue.main.async {
            self.updateButtonsState()
        }
    }
}
