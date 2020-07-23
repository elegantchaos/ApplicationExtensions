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
        BasicApplication.shared.afterSetup { [self] in
                sceneChannel.debug("loading")
                loadScene(scene, willConnectTo: session, options: connectionOptions) { _,_,_ in
                DispatchQueue.main.async {
                    sceneChannel.debug("loaded")
                    makeScene(scene, willConnectTo:session, options: connectionOptions)
                    sceneChannel.debug("shown")
                }
            }
        }
    }
}
#endif
