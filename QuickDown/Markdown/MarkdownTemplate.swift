//
//  MarkdownTemplate.swift
//  QuickDown
//
//  Created by Alexis Rondeau on 12.01.22.
//

import Foundation
import AppKit

class MarkdownTemplate {
    var templateText: String
    var cursorIndex = 0
    var pasteboardContent = ""
    
    init(templateText: String) {
        self.templateText = templateText
    }
    
    func getCursorIndex() -> Int {
        if let range: Range<String.Index> = self.appliedTemplate().range(of: "%CURSOR%") {
            let index: Int = self.appliedTemplate().distance(from: self.appliedTemplate().startIndex, to: range.lowerBound)
            self.cursorIndex = index
        }
        return self.cursorIndex
    }
    
    func getPasteboardContent() -> String {
        let pasteboard = NSPasteboard.general
        let copiedString = pasteboard.string(forType: .string)

        pasteboardContent = copiedString ?? ""

        return pasteboardContent
    }
    
    func hasCustomCursorIndex() -> Bool {
        if(self.getCursorIndex() != 0) {
            return true
        }
        
        return false
    }

    func hasPasteboardDirective() -> Bool {
        if(self.getPasteboardContent() != "") {
            return true
        }
        
        return false
    }
    
    func appliedTemplate() -> String {
        return self.templateText
            .replacingOccurrences(of: "%CLIPBOARD%", with: self.getPasteboardContent())
            .replacingOccurrences(of: "%DATETIME%", with: Date().formatted())
            .replacingOccurrences(of: "%DATE%", with: Date().formatted().components(separatedBy: ",").first! )
            .replacingOccurrences(of: "%TIME%", with: Date().formatted().components(separatedBy: ", ")[1])
    }
    
    func finalAppliedTemplate() -> String {
        return appliedTemplate().replacingOccurrences(of: "%CURSOR%", with: "")
    }
}
