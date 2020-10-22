// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 04/02/20.
//  All code (c) 2020 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

#if canImport(UIKit)
import UIKit
import LoggerKit

open class BasicScene: LoggerScene {
    let application = BasicApplication.shared

    public typealias LoadSceneCompletion = (UIScene, UISceneSession, UIScene.ConnectionOptions) -> ()

    open func loadState(completion: () -> ()) {
        sceneChannel.log("started loading state")
        completion()
    }
    
    open func refreshState(completion: () -> () = {}) {
        sceneChannel.log("started refreshing state")
        completion()
    }
    
    open func saveState(completion: () -> () = {}) {
        sceneChannel.log("started saving state")
    }
    
    open func makeScene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    }
    
    open override func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        sceneChannel.debug("connecting")

        super.scene(scene, willConnectTo: session, options: connectionOptions)
        guard let _ = (scene as? UIWindowScene) else { return }

        application.afterSetup {
            sceneChannel.debug("loading")
            self.loadState() {
                onMainQueue {
                    sceneChannel.log("finished loading state")
                    self.makeScene(scene, willConnectTo:session, options: connectionOptions)
                    sceneChannel.debug("shown")
                }
            }
        }
    }
    
    func refreshAllState() {
        DispatchQueue.global(qos: .background).async {
            self.refreshState()
        }
        DispatchQueue.global(qos: .background).async {
            self.application.refreshState()
        }
    }
    
    func saveAllState() {
        DispatchQueue.global(qos: .background).async {
            self.saveState()
        }
        DispatchQueue.global(qos: .background).async {
            self.application.saveState()
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
        refreshAllState()
    }
}
#endif
