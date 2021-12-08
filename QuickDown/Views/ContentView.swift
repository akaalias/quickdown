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
    
    var body: some View {
        VStack {
            TextEditor(text: $noteText)
                .foregroundColor(.primary)
                .font(.system(.title, design: .monospaced))
                .task { self.focusedField = .field }
            HStack {
                Button("Save (⌘-S)") {
                    showingExporter = true
                }
                .keyboardShortcut("s", modifiers: [.command])
                .hidden()

                Button("Close (⌘-E)") {
                    popover.performClose(self)
                }
                .keyboardShortcut("e", modifiers: [.command])
                .hidden()

            }
            .frame(width: 0, height: 0, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
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
