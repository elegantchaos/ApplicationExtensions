// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 04/02/20.
//  All code (c) 2020 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

#if canImport(UIKit)
import UIKit
import LoggerKit

open class BasicScene: LoggerScene {
    public let stateQueue = DispatchQueue.global(qos: .background)
    var isConnected = false
    
    public typealias LoadSceneCompletion = (UIScene, UISceneSession, UIScene.ConnectionOptions) -> ()

    open func loadState(completion: @escaping () -> ()) {
        completion()
    }
    
    open func refreshState(completion: @escaping () -> () = {}) {
        completion()
    }
    
    open func saveState(completion: @escaping () -> () = {}) {
        completion()
    }
    
    open func makeScene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    }
    
    open override func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        sceneChannel.debug("connecting")

        super.scene(scene, willConnectTo: session, options: connectionOptions)
        guard let _ = (scene as? UIWindowScene) else { return }

        BasicApplication.shared.afterSetup {
            sceneChannel.debug("loading")
            self.loadState() {
                onMainQueue {
                    sceneChannel.log("finished loading")
                    self.makeScene(scene, willConnectTo:session, options: connectionOptions)
                    self.isConnected = true
                    sceneChannel.debug("shown")
                }
            }
        }
    }
    
    func refreshAllState() {
        let application = BasicApplication.shared
        let group = DispatchGroup()

        group.enter()
        stateQueue.async {
            self.refreshState() {
                group.leave()
            }
        }
        
        group.enter()
        stateQueue.async {
            application.refreshState() {
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            sceneChannel.log("Done refreshing all state.")
        }
    }
    
    func saveAllState() {
        let application = BasicApplication.shared
        let group = DispatchGroup()

        group.enter()
        stateQueue.async {
            self.saveState() {
                group.leave()
            }
        }

        group.enter()
        stateQueue.async {
            application.saveState() {
                group.leave()
            }
        }

        group.notify(queue: .main) {
            sceneChannel.log("Done saving all state.")
        }
    }

    open override func sceneWillResignActive(_ scene: UIScene) {
        super.sceneWillResignActive(scene)
        saveAllState()
    }
    
    open override func sceneDidDisconnect(_ scene: UIScene) {
        super.sceneDidDisconnect(scene)
        saveAllState()
    }
    
    open override func sceneWillEnterForeground(_ scene: UIScene) {
        super.sceneWillEnterForeground(scene)
        if isConnected {
            refreshAllState()
        }
    }
}
#endif
