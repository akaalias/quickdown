import SwiftUI
import AppKit
import LaunchAtLogin

struct InfoModalView: View {
    @Binding var showModal: Bool
    
    var body: some View {
        List {
            Text("Settings")
                .font(.title2)

            Divider()

            LaunchAtLogin.Toggle()

            Divider()
            
            HStack {
                Text("Global Hotkey")
                Text("⌘-⌥-N")
                    .bold()
            }

            HStack {
                Text("Save Note")
                Text("⌘-S")
                    .bold()
            }

            HStack {
                Text("Open Note")
                Text("⌘-O")
                    .bold()
            }

            HStack {
                Text("Dismiss Popover")
                Text("Esc")
                    .bold()
            }
            
            Divider()
            
            Button("Dismiss") {
                self.showModal.toggle()
            }

        }
        .frame(width: 300, height: 250)
        .onExitCommand(perform: {
            self.showModal.toggle()
        })
    }
}
