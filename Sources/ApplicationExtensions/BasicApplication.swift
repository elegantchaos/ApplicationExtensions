// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 04/02/20.
//  All code (c) 2020 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import UIKit
import Logger
import LoggerKit

let applicationChannel = Channel("Application", handlers: [OSLogHandler()])

open class BasicApplication: LoggerApplication {
    open func open(file url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
        return false
    }
    
    open func open(url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
        return false
    }

    public override func application(_ app: UIApplication, open inputURL: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if super.application(app, open: inputURL, options: options) {
            return true
        }
        
        if inputURL.isFileURL {
            return open(file: inputURL, options: options)
        } else {
            return open(url: inputURL, options: options)
        }
    }
}


