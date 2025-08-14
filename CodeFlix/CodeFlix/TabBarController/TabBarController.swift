//
//  TabBarController.swift
//  CodeFlix
//
//  Created by Gryaznoy Alexander on 13.08.2025.
//

import UIKit

final class TabBarController: UITabBarController {
    
    //MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupTabBars()
    }
    
    // MARK: - Setup
    
    private func setupUI () {
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        tabBarAppearance.backgroundColor = .systemBackground
        
        tabBar.standardAppearance = tabBarAppearance
        tabBar.scrollEdgeAppearance = tabBarAppearance
    }
    
    private func setupTabBars() {
        let mainViewController = makeMainViewController()
        let favoriteViewController = makeFavoriteViewController()
        let searchViewController = makeSearchViewController()
        let profileViewController = makeProfileViewController()
        
        viewControllers = [
            mainViewController,
            favoriteViewController,
            searchViewController,
            profileViewController
        ]
    }
    
    // MARK: - Setup View Controllers
    
    private func makeMainViewController() -> UIViewController {
        let mainViewController = MainVC()
        
        let navigationController = UINavigationController(rootViewController: mainViewController)
        navigationController.navigationBar.prefersLargeTitles = true
        
        navigationController.tabBarItem.image = UIImage(systemName: "house")
        navigationController.tabBarItem.selectedImage = UIImage(systemName: "house.fill")
        navigationController.tabBarItem.title = "Главная"
        
        return navigationController
    }
    
    private func makeFavoriteViewController() -> UIViewController {
        let favoriteViewController = FavoriteVC()
        
        let navigationController = UINavigationController(rootViewController: favoriteViewController)
        navigationController.navigationBar.prefersLargeTitles = true
        
        navigationController.tabBarItem.image = UIImage(systemName: "heart")
        navigationController.tabBarItem.selectedImage = UIImage(systemName: "heart.fill")
        navigationController.tabBarItem.title = "Лайки"
        
        return navigationController
    }
    
    private func makeSearchViewController() -> UIViewController {
        let searchViewController = SearchVC()
        
        let navigationController = UINavigationController(rootViewController: searchViewController)
        navigationController.navigationBar.prefersLargeTitles = true
        
        navigationController.tabBarItem.image = UIImage(systemName: "magnifyingglass.circle")
        navigationController.tabBarItem.selectedImage = UIImage(systemName: "magnifyingglass.circle.fill")
        navigationController.tabBarItem.title = "Поиск"
        
        return navigationController
    }
    
    private func makeProfileViewController() -> UIViewController {
        let profileViewController = ProfileVC()
        
        let navigationController = UINavigationController(rootViewController: profileViewController)
        navigationController.navigationBar.prefersLargeTitles = true
        
        navigationController.tabBarItem.image = UIImage(systemName: "person.crop.circle")
        navigationController.tabBarItem.selectedImage = UIImage(systemName: "person.crop.circle.fill")
        navigationController.tabBarItem.title = "Профиль"
        
        return navigationController
    }
}
