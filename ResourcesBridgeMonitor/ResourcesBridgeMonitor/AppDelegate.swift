import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
    let popover = NSPopover()
    var eventMonitor: EventMonitor?

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        if let button = self.statusItem.button {
            button.image = #imageLiteral(resourceName: "StatusBarButtonImage")
            button.action = #selector(self.togglePopover(_:))
        }
        self.popover.animates = false
        self.popover.contentViewController = ViewController.newInstance()

        self.eventMonitor = .init(mask: [.leftMouseDown, .rightMouseDown]) { event in
            if self.popover.isShown { self.closePopover(sender: event) }
        }
    }

    @objc func togglePopover(_ sender: Any?) {
        if self.popover.isShown {
            self.closePopover(sender: sender)
        } else {
            self.showPopover(sender: sender)
        }
    }

    func showPopover(sender: Any?) {
        if let button = self.statusItem.button {
            self.popover.show(relativeTo: button.bounds,
                              of: button, preferredEdge: NSRectEdge.minY)
        }
        self.eventMonitor?.start()
    }

    func closePopover(sender: Any?) {
        self.popover.performClose(sender)
        self.eventMonitor?.stop()
    }
}
