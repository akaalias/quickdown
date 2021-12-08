import SwiftUI
import AppKit

struct ContentView: View {
    enum FocusField: Hashable {
        case field
    }
    
    @State var popover: NSPopover
    @State private var noteText: String = "## "
    @State var showingExporter = false
    @State var errorMessage = ""
    @FocusState private var focusedField: FocusField?
    @State private var showModal = false
    
    
    var body: some View {
        ZStack {
            TextEditor(text: $noteText)
                .foregroundColor(.primary)
                .font(.system(.title, design: .monospaced))
                .task { self.focusedField = .field }
                .onExitCommand(perform: {
                    popover.performClose(self)
                })
            
            Button {
                self.showModal.toggle()
            } label: {
                Image(systemName: "gear")
            }
            .sheet(isPresented: $showModal) {
                InfoModalView(showModal: self.$showModal)
            }
            .offset(x: 210, y: 110)
            .buttonStyle(.borderless)

            Button("Save") {
                showingExporter = true
            }
            .frame(width: 0, height: 0, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            .keyboardShortcut("s", modifiers: [.command])
            .hidden()
            
        }
        .padding(20)
        .fileExporter(isPresented: $showingExporter,
                      document: MarkdownExportManager().createFileFromString(text: noteText),
                      contentType: .markdownText,
                      defaultFilename: MarkdownExportManager().createFileNameFromString(text: noteText)) { result in
            switch result {
            case .success(let url):
                print("Success: \(url) markdown files exported\n")
                noteText = "## "
                popover.performClose(self)
                
            case .failure(let error):
                print("Error: \(error.localizedDescription)\n")
                errorMessage = error.localizedDescription
            }
        }
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
