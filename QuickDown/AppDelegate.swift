import Cocoa
import SwiftUI
import HotKey

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    var contentView: ContentView?
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
    let hotKey = HotKey(key: .n, modifiers: [.command, .option])
    let icon = NSImage(named: "StatusBarIcon")

    func applicationDidFinishLaunching(_ aNotification: Notification) {

        statusItem.button?.image = icon
        statusItem.button?.image?.size = NSSize(width: 18.0, height: 18.0)
        statusItem.button?.image?.isTemplate = true
        statusItem.button?.target = self
        statusItem.button?.action = #selector(showNotepad)

        hotKey.keyDownHandler = {
            self.showNotepad()
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
    
    @objc func showNotepad() {
        guard let button = statusItem.button else {
            fatalError("Couldn't find status item button.")
        }

        let popoverView = NSPopover()
        contentView = ContentView()
        popoverView.contentViewController = MenuBarViewController()
        popoverView.contentViewController?.view = NSHostingView(rootView: contentView)

        popoverView.contentSize = NSSize(width: 500, height: 300)
        popoverView.behavior = .semitransient
        popoverView.show(relativeTo: button.bounds, of: button, preferredEdge: .maxY)
    }
}

