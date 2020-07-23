// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 23/07/2020.
//  All code (c) 2020 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import ApplicationExtensions
import LoggerKit
import UIKit

@main
class AppDelegate: BasicApplication {
    override func prelaunch() {
        // force channels on for the sake of seeing what the startup sequence is
        // (normally you'd leave them at their default configuration, and allow
        //  the user to configure them with the LoggerMenu)
        applicationChannel.enabled = true
        sceneChannel.enabled = true
    }
}

