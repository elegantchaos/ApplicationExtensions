//
//  SceneDelegate.swift
//  Example
//
//  Created by Sam Deane on 23/07/2020.
//

import ApplicationExtensions
import SwiftUI
import UIKit

class SceneDelegate: BasicScene {
    override func makeScene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Create the SwiftUI view that provides the window contents.
        let contentView = ContentView()

        // Use a UIHostingController as window root view controller.
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = UIHostingController(rootView: contentView)
            self.window = window
            window.makeKeyAndVisible()
        }
    }
}

