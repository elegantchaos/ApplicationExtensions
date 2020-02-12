import XCTest
@testable import ApplicationExtensions

final class ApplicationExtensionsTests: XCTestCase {
    func testCacheDirectory() {
        #if canImport(UIKit)
        let url = UIApplication.cacheDirectory()
        XCTAssertTrue(FileManager.default.fileExists(atPath: url.path))
        #endif
    }

    func testDocumentsDirectory() {
        #if canImport(UIKit)
        let url = UIApplication.documentsDirectory()
        XCTAssertEqual(url.lastPathComponent, "Documents")
        #endif
    }

    func testNewDocument() {
        #if canImport(UIKit)
        let url = UIApplication.newDocumentURL(withPathExtension: "test")
        XCTAssertFalse(FileManager.default.fileExists(atPath: url.path))
        XCTAssertEqual(url.pathExtension, "test")
        #endif
    }
}
