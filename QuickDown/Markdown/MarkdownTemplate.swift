//
//  MarkdownTemplate.swift
//  QuickDown
//
//  Created by Alexis Rondeau on 12.01.22.
//

import Foundation

import Foundation

class MarkdownTemplate {
    var templateText: String
    var cursorIndex = 0
    
    init(templateText: String) {
        self.templateText = templateText
    }
    
    func getCursorIndex() -> Int {
        if let range: Range<String.Index> = self.templateText.range(of: "%CURSOR%") {
            let index: Int = self.templateText.distance(from: self.templateText.startIndex, to: range.lowerBound)
            self.cursorIndex = index
        }
        return self.cursorIndex
    }
    
    func hasCustomCursorIndex() -> Bool {
        if(self.getCursorIndex() != 0) {
            return true
        }
        
        return false
    }
    
    func appliedTemplate() -> String {
        return self.templateText.replacingOccurrences(of: "%CURSOR%", with: "")
    }
}
