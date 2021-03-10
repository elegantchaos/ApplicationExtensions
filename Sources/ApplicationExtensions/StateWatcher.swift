// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 30/07/2020.
//  All code (c) 2020 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Combine
import Foundation

@available(macOS 10.15, iOS 13, tvOS 13, *) public class StateWatcher<Object> where Object: ObservableObject {
//    let object: Object
    let scheduler: RunLoop
    let delay: TimeInterval
    var observer: AnyCancellable? = nil
    var action: () -> ()
    
    public init(for object: Object, delay: TimeInterval = 1.0, scheduler: RunLoop = RunLoop.main, action: @escaping () -> ()) {
//        self.object = object
        self.action = action
        self.delay = delay
        self.scheduler = scheduler
        self.observer = object
            .objectWillChange
            .debounce(for: .seconds(delay), scheduler: scheduler)
            .sink {
                _ in action()
            }
    }
}
