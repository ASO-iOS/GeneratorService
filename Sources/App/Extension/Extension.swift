//
//  File.swift
//  
//
//  Created by admin on 26.05.2023.
//

import Foundation
import SwiftUI

extension String {
    func replace(_ start: String, with: String) -> String {
        if #available(macOS 13.0, *) {
            return self.replacing(start, with: with)
        } else {
            return self.replacingOccurrences(of: " ", with: "")
        }
    }
}

extension Date {
    func getStamp() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd.HH.mm.ss"
        return formatter.string(from: self)
    }
}
