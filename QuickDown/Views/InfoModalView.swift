import SwiftUI
import AppKit
import LaunchAtLogin

struct InfoModalView: View {
    @Binding var showModal: Bool
    @State var disableCommandQuit: Bool = UserDefaults.standard.bool(forKey: "DisableCommandQuit")
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10, content: {

            ZStack {
                Text("Settings")
                    .font(.title2)

                Button(action: {
                    self.showModal.toggle()
                }, label: {
                    Image(systemName: "xmark")
                })
                    .buttonStyle(.plain)
                    .offset(x: 230, y: 0)
            }
            
            Divider()

            Group {
                Text("Launch at Login")
                    .font(.title2)

                LaunchAtLogin.Toggle()
            }
            
            Divider()
                        
            Group {

                Text("Hotkeys")
                    .font(.title2)
                
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
            }
        
            Divider()

            Group {
                
                Text("Custom Overrides")
                    .font(.title2)

                HStack {
                    Button(action: {
                        self.disableCommandQuit.toggle()
                        UserDefaults.standard.set(self.disableCommandQuit, forKey: "DisableCommandQuit")
                    }, label: {
                        Text("Avoid accidental ⌘-Q quitting")
                    })
                    
                    if(disableCommandQuit) {
                        Text("Disabled")
                    } else {
                        Text("Enabled")
                    }
                }
            }
        })
        .padding(20)
        .frame(width: 300, height: 350)
        .onExitCommand(perform: {
            self.showModal.toggle()
        })
    }
}
