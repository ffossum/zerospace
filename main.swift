import AppKit

let portName = "io.github.ffossum.zerospace.ipc" as CFString

// If an existing instance is listening, signal it and exit
if let remote = CFMessagePortCreateRemote(nil, portName) {
    CFMessagePortSendRequest(remote, 0, nil, 1.0, 0, nil, nil)
    exit(0)
}

class AppDelegate: NSObject, NSApplicationDelegate {
    var port: CFMessagePort?

    @discardableResult
    func makeWindow() -> NSWindow {
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 400, height: 300),
            styleMask: [.titled, .resizable, .closable, .miniaturizable],
            backing: .buffered,
            defer: false
        )
        window.title = "zerospace"
        window.isReleasedWhenClosed = false
        window.isOpaque = false
        window.backgroundColor = .clear
        window.titlebarAppearsTransparent = true
        window.titleVisibility = .hidden
        window.ignoresMouseEvents = true
        window.center()
        window.makeKeyAndOrderFront(nil)
        return window
    }

    func applicationDidFinishLaunching(_: Notification) {
        makeWindow()

        var context = CFMessagePortContext(
            version: 0,
            info: Unmanaged.passUnretained(self).toOpaque(),
            retain: nil, release: nil, copyDescription: nil
        )
        port = CFMessagePortCreateLocal(nil, portName, { _, _, _, info in
            let delegate = Unmanaged<AppDelegate>.fromOpaque(info!).takeUnretainedValue()
            DispatchQueue.main.async { delegate.makeWindow() }
            return nil
        }, &context, nil)
        if let port = port {
            let source = CFMessagePortCreateRunLoopSource(nil, port, 0)
            CFRunLoopAddSource(CFRunLoopGetMain(), source, .commonModes)
        }

        NSEvent.addLocalMonitorForEvents(matching: .keyDown) { event in
            let flags = event.modifierFlags.intersection(.deviceIndependentFlagsMask)
            guard flags == .command, let key = event.charactersIgnoringModifiers else { return event }
            switch key {
            case "w":
                NSApp.keyWindow?.close()
                return nil
            case "n", "t":
                self.makeWindow()
                return nil
            default:
                return event
            }
        }
    }

    func applicationShouldTerminateAfterLastWindowClosed(_: NSApplication) -> Bool {
        true
    }
}

let app = NSApplication.shared
app.setActivationPolicy(.regular)
let delegate = AppDelegate()
app.delegate = delegate
app.run()
