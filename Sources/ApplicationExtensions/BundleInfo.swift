// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 21/02/20.
//  All code (c) 2020 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation

extension Dictionary {
    public subscript(stringWithKey key: Key) -> String? {
        return self[key] as? String
    }
    public subscript(intWithKey key: Key) -> Int? {
        return self[key] as? Int
    }
}

public struct BundleVersion {
    let major: Int
    let minor: Int
    let patch: Int
    
    init(string: String? = nil) {
        let numbers = string?.split(separator: ".").map({ Int($0) ?? 0 }) ?? [0,0,0]
        major = numbers.count > 0 ? numbers[0] : 0
        minor = numbers.count > 1 ? numbers[1] : 0
        patch = numbers.count > 2 ? numbers[2] : 0
    }
}

public struct BundleInfo {
    public let name: String
    public let id: String
    public let executable: String
    public let icon: Image
    public let build: Int
    public let version: BundleVersion
    public let commit: String
    public let copyright: String
    
    init(for bundle: Bundle = Bundle.main) {
        id = bundle.bundleIdentifier!
        let info = bundle.infoDictionary!
        name = info[stringWithKey: "CFBundleName"] ?? ""
        icon = Image.imageOrBlank(named: info[stringWithKey: "CFBundleIconName"])
        executable = info[stringWithKey: "CFBundleExecutable"] ?? ""
        build = info[intWithKey: "CFBundleVersion"] ?? 0
        version = BundleVersion(string: info[stringWithKey:"CFBundleShortVersionString"])
        commit = info[stringWithKey: "Commit"] ?? ""
        copyright = info[stringWithKey: "NSHumanReadableCopyright"] ?? ""
    }
}
