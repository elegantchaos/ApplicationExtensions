// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 04/02/20.
//  All code (c) 2020 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

#if canImport(UIKit)
import UIKit
import Logger
import LoggerKit

let applicationChannel = Channel("Application", handlers: [OSLogHandler()])

@available(iOS 13.0, tvOS 13.0, *) open class BasicApplication: LoggerApplication {
    public typealias LaunchOptions = [UIApplication.LaunchOptionsKey : Any]
    public typealias OpenOptions = [UIApplication.OpenURLOptionsKey : Any]

    public let info = BundleInfo()

    var isSetup = false
    
    
    open func open(file url: URL, options: OpenOptions) -> Bool {
        return false
    }
    
    open func open(url: URL, options: OpenOptions) -> Bool {
        return false
    }

    open func setup(withOptions options: LaunchOptions) {
        registerDefaultsFromSettingsBundle()
    }

    fileprivate func setupIfNeeded(withOptions options: LaunchOptions) {
        if !isSetup {
            setup(withOptions: options)
            isSetup = true
        }
    }
    
    // Locates the file representing the root page of the settings for this app and registers the loaded values as the app's defaults.
    fileprivate func registerDefaultsFromSettingsBundle() {
        let settingsUrl =
            Bundle.main.url(forResource: "Settings", withExtension: "bundle")!.appendingPathComponent("Root.plist")
        let settingsPlist = NSDictionary(contentsOf: settingsUrl)!
        if let preferences = settingsPlist["PreferenceSpecifiers"] as? [NSDictionary] {
            var defaultsToRegister = [String: Any]()
    
            for prefItem in preferences {
                guard let key = prefItem["Key"] as? String else {
                    continue
                }
                defaultsToRegister[key] = prefItem["DefaultValue"]
            }
            UserDefaults.standard.register(defaults: defaultsToRegister)
        }
    }
    

}

@available(iOS 13.0, *) extension BasicApplication { // UIApplicationDelegate
    override open func application(_ app: UIApplication, open inputURL: URL, options: OpenOptions = [:]) -> Bool {
        if super.application(app, open: inputURL, options: options) {
            return true
        }
        
        if inputURL.isFileURL {
            return open(file: inputURL, options: options)
        } else {
            return open(url: inputURL, options: options)
        }
    }
    
    override open func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: LaunchOptions? = nil) -> Bool {
        setupIfNeeded(withOptions: launchOptions ?? [:])

        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}

#endif
