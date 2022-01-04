import Cocoa
import SwiftUI
import HotKey

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    var popover = NSPopover.init()
    var statusBar: StatusBarController?
    var contentView: ContentView?

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        contentView = ContentView(popover: popover)
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
        if(!UserDefaults.standard.bool(forKey: "DisableCommandQuit")) {
            let alert = NSAlert()
            alert.messageText = "QuickDown"
            alert.informativeText = "Accidental quitting by Command-Quit disabled. Toggle in settings"
            alert.runModal()
            return .terminateCancel
        }
        
        return .terminateNow
    }
    
    func applicationWillTerminate(_ notification: Notification) {
        print("applicationWillTerminate")
    }
}

