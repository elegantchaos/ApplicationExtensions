// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 06/02/20.
//  All code (c) 2020 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import UIKit

public extension UIDocument {
    
    /// Create and save an instance for the UIDocumentBrowser to use as a new document.
    /// - Parameters:
    ///   - pathExtension: extension to save the new document with
    ///   - importHandler: document browser import handler to pass the new document's location
    class func createForDocumentBrowser(withPathExtension pathExtension: String, importHandler: @escaping (URL?, UIDocumentBrowserViewController.ImportMode) -> Void) {
        let url = UIApplication.newDocumentURL(withPathExtension: pathExtension)
        let document = Self.init(fileURL: url)
        document.save(to: url, for: .forCreating) { saveResult in
            guard saveResult else {
                importHandler(nil, .none)
                return
            }
            
            importHandler(url, .move)
        }
    }
    
    
    /// Create and save an instance to use as the result of an export operation.
    /// A handler is supplied which is used to do the following things:
    /// - populate the new document with the content that's being exported
    /// - display an error (if saving fails)
    /// - display a document picker for the user to choose the final destination (if saving succeeds)
    ///
    /// - Parameters:
    ///   - pathExtension: extension to save the new document with
    ///   - handler: handler
    class func createForExport(withPathExtension pathExtension: String, handler: DocumentExportHandler) {
        let url = UIApplication.newDocumentURL(withPathExtension: pathExtension)
        let document = Self.init(fileURL: url)
        handler.prepareExport(forDocument: document)
        document.save(to: url, for: .forCreating) { saveResult in
            guard saveResult else {
                handler.presentFailure(forDocument: document)
                return
            }
            
            let documentPicker = UIDocumentPickerViewController(url: document.fileURL, in: .exportToService)
            documentPicker.delegate = handler
            handler.presentPicker(forDocument: document, picker: documentPicker)
        }
    }

}

/// Document export helper.
/// An instance of this protocol is supplied to `createForExport` to assist with the export process.
public protocol DocumentExportHandler: UIDocumentPickerDelegate {
    /// Populate the new document with the content that's being exported.
    /// - Parameter document: the document to populate
    func prepareExport(forDocument document: UIDocument)
    
    /// Display an error indicating that the export document failed to save.
    /// - Parameter document: the document that failed
    func presentFailure(forDocument document: UIDocument)
    
    /// Display a document picker for the user to choose the final destination of an export.
    /// - Parameters:
    ///   - document: the document being exported
    ///   - picker: the picker to display
    func presentPicker(forDocument document: UIDocument, picker: UIDocumentPickerViewController)
}
