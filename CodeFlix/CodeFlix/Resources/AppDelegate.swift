//
//  AppDelegate.swift
//  CodeFlix
//
//  Created by Zhdanov Konstantin on 06.08.2025.
//

import OKTracer

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var tracerService: TracerServiceProtocol!

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        tracerService = TracerFactory.tracerServiceForCrashReporting(EndpointConfiguration(token: "oxvjFwJbRiCgkzDZx66w3KgmoCNgAvaEBgi5qK4x6kI"))
        tracerService.start()

        // Обработка сбоя приложения после перезапуска
        switch tracerService.lastSessionState() {
        case let .normal(crashCount):
            print("В последней сессии сбоев не было. Не отправлено \(crashCount) сбоев.")
        case let .crashed(crashCount, result):
            print("В последней сессии был сбой. Не отправлено \(crashCount) сбоев.")
            switch result {
            case let .success(crashModel):
                print("Время последнего сбоя\(crashModel.timestamp). Время последнего запуска приложения \(crashModel.startTime).")
            case let .failure(error):
                print("При получении последнего сбоя произошла ошибка \(error)")
            }
        }
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    
}


