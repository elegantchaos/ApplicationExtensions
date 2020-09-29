// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 30/07/2020.
//  All code (c) 2020 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Combine
import Foundation

@available(macOS 10.15, iOS 13, tvOS 13, *) public class StateWatcher<Model> where Model: ObservableObject {
    let model: Model
    let scheduler: RunLoop
    let delay: TimeInterval
    var observer: AnyCancellable? = nil
    var action: () -> ()
    
    public init(model: Model, delay: TimeInterval = 1.0, scheduler: RunLoop = RunLoop.main, action: @escaping () -> ()) {
        self.model = model
        self.action = action
        self.delay = delay
        self.scheduler = scheduler
        self.observer = model
            .objectWillChange
            .debounce(for: .seconds(delay), scheduler: scheduler)
            .sink {
                _ in action()
            }
    }
}
