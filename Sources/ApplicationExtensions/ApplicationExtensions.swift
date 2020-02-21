// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 14/01/20.
//  All code (c) 2020 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

#if canImport(UIKit)
import UIKit

public extension UIApplication {
    static func cacheDirectory() -> URL {
        guard let cacheURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else {
            fatalError("unable to get system cache directory - serious problems")
        }
        
        return cacheURL
    }
    
    static func documentsDirectory() -> URL {
        guard let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            fatalError("unable to get system docs directory - serious problems")
        }
        
        return documentsURL
    }
    
    /// Return a url to use as an initial location for a new document.
    /// - Parameters:
    ///   - nameRoot: The name to give the document. Defaults to "Untitled".
    ///   - pathExtension: The path extension to use for the new document.
    ///   - makeUnique: If true, we append numbers to the file name until we come up with one that doesn't already exist.
    /// - Returns: A new URL.
    ///
    /// The URL is created in the app container's cache directory.
    /// If @makeUnique is false, and a file of the same name already exists there, it is first deleted.
    static func newDocumentURL(name nameRoot: String = "Untitled", withPathExtension pathExtension: String, makeUnique: Bool = true) -> URL {
        let directory = cacheDirectory()
        
        let fm = FileManager.default
        var name = nameRoot
        var count = 1
        repeat {
            let url = directory.appendingPathComponent(name).appendingPathExtension(pathExtension)
            if !makeUnique {
                try? fm.removeItem(at: url)
            }
            if !fm.fileExists(atPath: url.path) {
                return url
            }
            count += 1
            name = "\(nameRoot) \(count)"
        } while true
    }
    
}
#endif
