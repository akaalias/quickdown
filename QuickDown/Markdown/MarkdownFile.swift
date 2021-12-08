import Foundation
import SwiftUI
import UniformTypeIdentifiers

struct MarkdownFile: FileDocument {
    // tell the system we support only plain text
    static var readableContentTypes = [UTType.markdownText]

    // by default our document is empty
    var text = ""
    var fileName = ""

    // a simple initializer that creates new, empty documents
    init(initialText: String = "", givenFileName: String = "") {
        text = initialText
        fileName = givenFileName
    }

    // this initializer loads data that has been saved previously
    init(configuration: ReadConfiguration) throws {
        if let data = configuration.file.regularFileContents {
            text = String(decoding: data, as: UTF8.self)
        }
    }

    // this will be called when the system wants to write our data to disk
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        let data = Data(text.utf8)
        let wrapper = FileWrapper(regularFileWithContents: data)
        wrapper.filename = self.fileName
        return wrapper
    }
}

extension UTType {
  static var markdownText: UTType {
    UTType(importedAs: "net.daringfireball.markdown")
  }
}
