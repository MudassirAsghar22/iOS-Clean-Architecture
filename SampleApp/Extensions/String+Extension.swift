//
//  String+Extension.swift
//  Sample App
//
//  Created by Mudassir Asghar on 08/05/2024.
//

import Foundation

extension String {

    var length: Int {
        return count
    }

    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")

    }

    subscript (i: Int) -> String {
        return self[i ..< i + 1]

    }

    func substring(fromIndex: Int) -> String {
        return self[min(fromIndex, length) ..< length]

    }

    func substring(toIndex: Int) -> String {
        return self[0 ..< max(0, toIndex)]

    }

    subscript (r: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(length, r.lowerBound)),
                                            upper: min(length, max(0, r.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return String(self[start ..< end])

    }

    func convertHtml() -> NSAttributedString {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do {
            let options = [NSAttributedString.DocumentReadingOptionKey.documentType:
                            NSAttributedString.DocumentType.html]

            return try NSMutableAttributedString(data: data, options: options, documentAttributes: nil)

        } catch {
            return NSAttributedString()
        }
    }

    func slice(from: String, to: String) -> String? {
        return (range(of: from)?.upperBound).flatMap { substringFrom in
            (range(of: to, range: substringFrom..<endIndex)?.lowerBound).map { substringTo in
                substring(with: substringFrom..<substringTo)
            }
        }

    }

    func replace(_ with: String, at index: Int) -> String {
        var modifiedString = String()
        for (i, char) in self.enumerated() {
            modifiedString += String((i == index) ? with : String(char))
        }
        return modifiedString

    }

    func isValidWith(regex: String) -> Bool {
        guard let gRegex = try? NSRegularExpression(pattern: regex) else {
            return false
        }
        let range = NSRange(location: 0, length: self.utf16.count)

        if gRegex.firstMatch(in: self, options: [], range: range) != nil {
            return true
        }
        return false
    }

}
