import XCTest
@testable import ApplicationExtensions

#if canImport(UIKit)
final class ApplicationExtensionsTests: XCTestCase {
    func testCacheDirectory() {
        let url = UIApplication.cacheDirectory()
        XCTAssertTrue(FileManager.default.fileExists(atPath: url.path))
    }

    func testDocumentsDirectory() {
        let url = UIApplication.documentsDirectory()
        XCTAssertTrue(FileManager.default.fileExists(atPath: url.path))
    }

    func testNewDocument() {
        let url = UIApplication.newDocumentURL(withPathExtension: "test")
        XCTAssertFalse(FileManager.default.fileExists(atPath: url.path))
        XCTAssertEqual(url.pathExtension, "test")
    }
}
#endif
