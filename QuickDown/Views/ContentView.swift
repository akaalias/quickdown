import SwiftUI
import AppKit
import Introspect

struct ContentView: View {
    enum FocusField: Hashable {
        case field
    }
    let template = MarkdownTemplate(templateText: UserDefaults.standard.string(forKey: "MarkdownTemplate") ?? "")

    @State private var noteText: String = UserDefaults.standard.string(forKey: "MarkdownTemplate") ?? ""
    @State var showingExporter = false
    @State var errorMessage = ""
    @State private var showModal = false
    @State var showingImporter = false
    
    @FocusState private var focusedField: FocusField?

    @State var cursorIndex = 0
    @State var customCursorIndexConfigured = false
    @State var customCursorIndexWasSet = false

    var body: some View {
        ZStack {
            TextEditor(text: $noteText)
                .foregroundColor(.primary)
                .font(.system(.title, design: .monospaced))
                .task {
                    print("Rendering TextEditor...")
                    
                    customCursorIndexConfigured = template.hasCustomCursorIndex()
                    cursorIndex = template.getCursorIndex()
                    noteText = template.appliedTemplate()
                
                    self.focusedField = .field
                }
                .introspectTextView { textView in
                    if(customCursorIndexConfigured && !customCursorIndexWasSet) {
                        textView.setSelectedRange(NSMakeRange(cursorIndex, 0))
                        customCursorIndexWasSet = true
                    }
                }
            
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

            Button("Open") {
                showingImporter = true
            }
            .frame(width: 0, height: 0, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            .keyboardShortcut("o", modifiers: [.command])
            .hidden()
        }
        .fileImporter(isPresented: $showingImporter, allowedContentTypes: [.markdownText], onCompletion: { result in
            switch result {
            case .success(let url):
                guard url.startAccessingSecurityScopedResource() else { return }
                if let textData = try? String(contentsOf: url) {
                    noteText = textData
                }
                url.stopAccessingSecurityScopedResource()

            case .failure(let error):
                print("Error: \(error.localizedDescription)\n")
            }

        })
        .fileExporter(isPresented: $showingExporter,
                      document: MarkdownExportManager().createFileFromString(text: noteText),
                      contentType: .markdownText,
                      defaultFilename: MarkdownExportManager().createFileNameFromString(text: noteText)) { result in
            switch result {
                case .success(let url):
                    customCursorIndexConfigured = template.hasCustomCursorIndex()
                    cursorIndex = template.getCursorIndex()
                    customCursorIndexWasSet = false
                    noteText = template.appliedTemplate()
                    focusedField = .field

                case .failure(let error):
                    errorMessage = error.localizedDescription
            }
        }
        .padding(20)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
