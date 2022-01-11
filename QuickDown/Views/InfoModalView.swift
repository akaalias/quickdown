import SwiftUI
import AppKit
import LaunchAtLogin

struct InfoModalView: View {
    @Binding var showModal: Bool
    @State var disableCommandQuit: Bool = UserDefaults.standard.bool(forKey: "DisableCommandQuit")
    @State var markdownTemplate: String = UserDefaults.standard.string(forKey: "MarkdownTemplate") ?? ""
    @State var markdownTemplateSaveMessage: String = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10, content: {

            Group {
                Text("QuickDown Settings")
                    .font(.title2)
                
                Text("Version 1.6")
                Text("Contact: alexis.rondeau@gmail.com")
            }
            
            Divider()

            Group {
                Text("Launch at Login")
                    .font(.title2)

                LaunchAtLogin.Toggle()
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
            
            Divider()
            
            Group {

                Text("Markdown Template")
                    .font(.title2)

                TextEditor(text: $markdownTemplate)
                    .foregroundColor(.primary)
                    .frame(width: 250, height: 50)
                
                HStack {
                    Button(action: {
                        self.saveMarkdownTemplate()
                    },
                           label: {
                        Text("Save Template")
                    })
                    
                    Text(markdownTemplateSaveMessage)
                }
            }

            Divider()
            
            Group {

                Text("Default Hotkeys")
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
            
            Button(action: {
                self.showModal.toggle()
            }, label: {
                Text("Close Settings")
            })
                .buttonStyle(.bordered)
        })
        .padding(20)
        .onExitCommand(perform: {
            self.showModal.toggle()
        })
    }
    
    func saveMarkdownTemplate() {
        UserDefaults.standard.set(self.markdownTemplate, forKey: "MarkdownTemplate")
        self.markdownTemplateSaveMessage = "Saved"
    }
}
