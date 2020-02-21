//
//  File.swift
//  
//
//  Created by Developer on 21/02/2020.
//

import UIKit

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
    public let icon: UIImage
    public let build: Int
    public let version: BundleVersion
    public let commit: String
    public let copyright: String
    
    init(for bundle: Bundle = Bundle.main) {
        id = bundle.bundleIdentifier!
        let info = bundle.infoDictionary!
        name = info[stringWithKey: "CFBundleName"] ?? ""
        executable = info[stringWithKey: "CFBundleExecutable"] ?? ""
        icon = UIImage(named: info[stringWithKey: "CFBundleIconName"]!) ?? UIImage()
        build = info[intWithKey: "CFBundleVersion"] ?? 0
        version = BundleVersion(string: info[stringWithKey:"CFBundleShortVersionString"])
        commit = info[stringWithKey: "Commit"] ?? ""
        copyright = info[stringWithKey: "NSHumanReadableCopyright"] ?? ""
    }
}
