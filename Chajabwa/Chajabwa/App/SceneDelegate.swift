//
//  SceneDelegate.swift
//  app-show-room
//
//  Created by Moon Yeji on 2022/08/12.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    var networkStatusWinodw: UIWindow?
    var networkStatusView: NetworkStatusView?
    var mainCoordinator: Coordinator?
    
    private let appOrganizer = AppOrganizer()
    private let networkMonitor = NetworkMonitor.shared
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let navigationController = UINavigationController()
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        let mainCooordinator = SearchCoordinator(rootViewController: navigationController)
        mainCoordinator = mainCooordinator
        
        let loadingView = AppLoadingViewController()
        loadingView.modalPresentationStyle = .fullScreen
        navigationController.present(loadingView, animated: false)
        
        appOrganizer.prepare {
            DispatchQueue.main.async {
                loadingView.dismiss(animated: false)
                mainCooordinator.start()
            }
        }
        
        networkMonitor.startMonitoring(statusUpdateHandler: { [weak self] connectionStatus in
            switch connectionStatus {
            case .satisfied:
                self?.showNetworkConnectedStatusWindow()
            case .unsatisfied:
                self?.showNetworkDisconnectedStatusWindow(on: scene)
            default:
                break
            }
        })
    }
    
    private func showNetworkDisconnectedStatusWindow(on scene: UIScene) {
        addNetworkStatusWindow(on: scene)
        networkStatusWinodw?.isHidden = false
    }
    
    private func addNetworkStatusWindow(on scene: UIScene) {
        if let windowScene = scene as? UIWindowScene {
            let networkStatusWindow = UIWindow(windowScene: windowScene)
            networkStatusWindow.windowLevel = .statusBar
            networkStatusWindow.isUserInteractionEnabled = false
            self.networkStatusWinodw = networkStatusWindow
            networkStatusView = NetworkStatusView(
                frame: networkStatusWindow.frame,
                status: .disconnected)
            networkStatusWindow.addSubview(networkStatusView!)
        }
    }
    
    private func showNetworkConnectedStatusWindow() {
        networkStatusView?.switchStatus(.connected)
        UIViewPropertyAnimator.runningPropertyAnimator(
            withDuration: 1,
            delay: 1,
            options: .curveEaseOut)
        { [self] in
            self.networkStatusWinodw?.alpha = 0
        } completion: { _ in
            self.removeNetworkStatusWindow()
        }
    }
    
    private func removeNetworkStatusWindow() {
        self.networkStatusWinodw = nil
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        networkMonitor.stopMonitoring()
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
    
    
}

extension SceneDelegate {
    
    static var topMostViewController: UIViewController? {
        guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate,
              let window = sceneDelegate.window else {
            print("\(#function) : Can not found Scene")
            return nil
        }
        if var topController = window.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            return topController
        } else {
            return nil
        }
    }
    
}
