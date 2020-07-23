// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 04/02/20.
//  All code (c) 2020 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

#if canImport(UIKit)
import UIKit
import LoggerKit

open class BasicScene: LoggerScene {
    
    public typealias LoadSceneCompletion = (UIScene, UISceneSession, UIScene.ConnectionOptions) -> ()
    open func loadScene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions, completion: @escaping LoadSceneCompletion) {
        completion(scene, session, connectionOptions)
    }
    
    open func makeScene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    }
    
    open override func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        sceneChannel.debug("connecting")

        super.scene(scene, willConnectTo: session, options: connectionOptions)
        guard let _ = (scene as? UIWindowScene) else { return }

        BasicApplication.shared.afterSetup {
            sceneChannel.debug("loading")
            self.loadScene(scene, willConnectTo: session, options: connectionOptions) { _,_,_ in
                DispatchQueue.main.async {
                    sceneChannel.debug("loaded")
                    self.makeScene(scene, willConnectTo:session, options: connectionOptions)
                    sceneChannel.debug("shown")
                }
            }
        }
    }
    
    
    open override func sceneWillResignActive(_ scene: UIScene) {
        super.sceneWillResignActive(scene)
        BasicApplication.shared.saveState()
    }
    
    open override func sceneDidDisconnect(_ scene: UIScene) {
        super.sceneDidDisconnect(scene)
        BasicApplication.shared.saveState()
    }
}
#endif
