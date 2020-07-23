// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 23/07/2020.
//  All code (c) 2020 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import ApplicationExtensions
import LoggerKit
import UIKit

@main
class AppDelegate: BasicApplication {
    override func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: BasicApplication.LaunchOptions? = nil) -> Bool {
        applicationChannel.enabled = true
        sceneChannel.enabled = true
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}

