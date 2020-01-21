// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 21/01/20.
//  All code (c) 2020 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation

public extension Bundle {
    func stringResource(named name: String, withExtension ext: String? = nil, subdirectory: String? = nil) -> String {
        guard let url = url(forResource: name, withExtension: ext ?? "string", subdirectory: subdirectory) else {
            fatalError("Missing string resource: \(name).")
        }
        
        guard let string = try? String(contentsOf: url, encoding: .utf8) else {
            fatalError("Corrupt string resource: \(name).")
        }
        return string
    }
}
