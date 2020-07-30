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

    public typealias SetupCompletion = (LaunchOptions) -> ()
    public typealias LoadStateCompletion = () -> ()
    public typealias SaveStateCompletion = () -> ()
    public typealias PostSetupAction = () -> ()
    
    var setupState: SetupState = .launching
    var postSetupActions: [PostSetupAction] = []
    
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
    
    open func loadState(completion: @escaping LoadStateCompletion) {
        applicationChannel.log("started loading state")
        completion()
    }
    
    open func saveState(completion: @escaping SaveStateCompletion = {}) {
        
    }
    
    fileprivate func setUpIfNeeded(withOptions options: LaunchOptions) {
        DispatchQueue.main.async {
            if self.setupState == .launching {
                applicationChannel.log("starting setup")
                self.setupState = .initialising
                DispatchQueue.global(qos: .userInitiated).async {
                    self.setUp(withOptions: options) { _ in
                        self.finishedSetup()
                    }
                }
            }
        }
    }
    
    fileprivate func finishedSetup() {
        DispatchQueue.main.async {
            applicationChannel.log("finished setup")
            self.setupState = .ready
            for action in self.postSetupActions {
                applicationChannel.log("performing post setup action")
                action()
            }
        }
    }
    
    func afterSetup(action: @escaping PostSetupAction) {
        DispatchQueue.main.async {
            if self.setupState == .ready {
                applicationChannel.log("performing post setup action immediately")
                action()
            } else {
                applicationChannel.log("queuing post setup action")
                self.postSetupActions.append(action)
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

extension BasicApplication {
    public static var shared: BasicApplication {
        UIApplication.shared.delegate as! BasicApplication
    }
}

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

import AppKit

extension BasicApplication {
    public static var shared: BasicApplication {
        NSApp.delegate as! BasicApplication
    }

    @objc open func makeWindow() {
    }
    
    open override func applicationDidFinishLaunching(_ notification: Notification) {
        super.applicationDidFinishLaunching(notification)
        afterSetup {
            DispatchQueue.main.async {
                self.makeWindow()
            }
        }
        setUpIfNeeded(withOptions: notification.userInfo as! LaunchOptions)
    }
    
    public typealias LaunchOptions = [String : Any]
    public typealias OpenOptions = [String : Any]
}

#endif
