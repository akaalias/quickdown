import Cocoa
import SwiftUI
import HotKey

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    var popover = NSPopover.init()
    var statusBar: StatusBarController?

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        let contentView = ContentView(popover: popover)
        popover.contentViewController = MenuBarViewController()
        popover.contentSize = NSSize(width: 500, height: 300)
        popover.contentViewController?.view = NSHostingView(rootView: contentView)
        statusBar = StatusBarController.init(popover)

        let hotKey = HotKey(key: .n, modifiers: [.command, .option])
        
        hotKey.keyDownHandler = {
            self.statusBar?.showPopover(hotKey)
        }
    }
    
    func applicationShouldTerminate(_ sender: NSApplication) -> NSApplication.TerminateReply {
        print("applicationShouldTerminate")
        return .terminateCancel
    }
    
    func applicationWillTerminate(_ notification: Notification) {
        print("applicationWillTerminate")
    }
}

