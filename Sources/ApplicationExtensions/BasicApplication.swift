// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 04/02/20.
//  All code (c) 2020 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation
import Bundles
import Logger
import LoggerKit

@available(iOS 13.0, tvOS 13.0, *) open class BasicApplication: LoggerApplication {
    public enum SetupState {
        case launching
        case initialising
        case ready
    }

    var setupState: SetupState = .launching
    var postSetupActions: [() -> ()] = []
    
    public typealias SetupCompletion = (LaunchOptions) -> ()
    
    public var setupCompletions: [SetupCompletion] = []
    public let info = BundleInfo()
    
    
    open func open(file url: URL, options: OpenOptions) -> Bool {
        return false
    }
    
    open func open(url: URL, options: OpenOptions) -> Bool {
        return false
    }

    open func setUp(withOptions options: LaunchOptions, completion: @escaping SetupCompletion) {
        registerDefaultsFromSettingsBundle()
        loadState {
            applicationChannel.log("finished loading state")
            completion(options)
        }
    }

    open func tearDown() {
        
    }
    
    open func loadState(completion: () -> ()) {
        applicationChannel.log("started loading state")
        completion()
    }
    
    open func saveState(completion: () -> ()) {
        
    }
    
    fileprivate func setUpIfNeeded(withOptions options: LaunchOptions) {
        DispatchQueue.main.async { [self] in
            if setupState == .launching {
                applicationChannel.log("starting setup")
                setupState = .initialising
                DispatchQueue.global(qos: .userInitiated).async {
                    setUp(withOptions: options) { _ in
                        finishedSetup()
                    }
                }
            }
        }
    }
    
    fileprivate func finishedSetup() {
        DispatchQueue.main.async { [self] in
            applicationChannel.log("finished setup")
            setupState = .ready
            for action in postSetupActions {
                applicationChannel.log("performing post setup action")
                action()
            }
        }
    }
    
    func afterSetup(action: @escaping () -> ()) {
        DispatchQueue.main.async { [self] in
            if setupState == .ready {
                applicationChannel.log("performing post setup action immediately")
                action()
            } else {
                applicationChannel.log("queuing post setup action")
                postSetupActions.append(action)
            }
        }
    }
    
    // Locates the file representing the root page of the settings for this app and registers the loaded values as the app's defaults.
    fileprivate func registerDefaultsFromSettingsBundle() {
        if let bundle = Bundle.main.url(forResource: "Settings", withExtension: "bundle") {
            let settingsUrl = bundle.appendingPathComponent("Root.plist")
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
    

}

#if canImport(UIKit)

import UIKit

@available(iOS 13.0, *) extension BasicApplication { // UIApplicationDelegate
    public typealias LaunchOptions = [UIApplication.LaunchOptionsKey : Any]
    public typealias OpenOptions = [UIApplication.OpenURLOptionsKey : Any]

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
        setUpIfNeeded(withOptions: launchOptions ?? [:])

        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    open override func applicationWillTerminate(_ application: UIApplication) {
        tearDown()
        super.applicationWillTerminate(application)
    }
}

#elseif canImport(AppKit)

extension BasicApplication {
    public typealias LaunchOptions = [String : Any]
    public typealias OpenOptions = [String : Any]
}

#endif
