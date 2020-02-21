// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 21/02/20.
//  All code (c) 2020 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

#if canImport(UIKit)

import UIKit

public typealias Image = UIImage

#elseif canImport(AppKit)

import AppKit

public typealias Image = NSImage

#endif

extension Image {
    static func imageOrBlank(named name: String?) -> Image {
    guard let name = name, let image = Image(named: name) else {
        return Image()
    }
    
    return image
    }
}
