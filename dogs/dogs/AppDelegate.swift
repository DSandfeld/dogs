//
//  AppDelegate.swift
//  dogs
//
//  Created by Daniel Sandfeld Jensen on 04/11/2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate, UINavigationControllerDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
     
        window = UIWindow()
        
        guard let window else { return false }
        
        let vc = ViewController()
        vc.view.frame = window.bounds
        vc.view.backgroundColor = .white
        let navigationController = UINavigationController(rootViewController: vc)
        navigationController.delegate = self
        
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        return true
    }
    
    func navigationControllerPreferredInterfaceOrientationForPresentation(_ navigationController: UINavigationController) -> UIInterfaceOrientation {
        return .portrait
    }
}
