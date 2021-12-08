import Foundation

class MarkdownExportManager {
        
    func createFileFromString(text: String) -> MarkdownFile {
        
        let file = MarkdownFile(initialText: text)

        return file
    }
    
    func createFileNameFromString(text: String) -> String {
        
        let chars: Set<Character> = [" ", "-",
                                     "1", "2", "3", "4", "5", "6", "7", "8", "9", "0",
                                     "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m",
                                     "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z",
                                     "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M",
                                     "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"
        ]

        if(!text.isEmpty) {
            let firstNewLineEndIndex = text.firstIndex(of: "\n")
            var mutableText = text
            if(firstNewLineEndIndex != nil) {
                var firstLine = text[...firstNewLineEndIndex!]
                firstLine.removeAll(where: { !chars.contains($0) })
                return String(firstLine.trimmingCharacters(in: .whitespacesAndNewlines) + ".md")
            } else {
                mutableText.removeAll(where: { !chars.contains($0) })
                return String(mutableText.trimmingCharacters(in: .whitespacesAndNewlines) + ".md")
            }
        }
        
        return "Test.md"
    }
}
