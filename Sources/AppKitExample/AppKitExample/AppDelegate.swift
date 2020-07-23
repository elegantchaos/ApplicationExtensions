//
//  AppDelegate.swift
//  AppKitExample
//
//  Created by Sam Deane on 23/07/2020.
//

import ApplicationExtensions
import Cocoa
import LoggerKit
import SwiftUI

@main
class AppDelegate: BasicApplication {
    var window: NSWindow!

    override func prelaunch() {
        applicationChannel.enabled = true
    }
    
    override func makeWindow() {
        // Create the SwiftUI view that provides the window contents.
        let contentView = ContentView()

        // Create the window and set the content view.
        window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 480, height: 300),
            styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
            backing: .buffered, defer: false)
        window.isReleasedWhenClosed = false
        window.center()
        window.setFrameAutosaveName("Main Window")
        window.contentView = NSHostingView(rootView: contentView)
        window.makeKeyAndOrderFront(nil)
    }
}

