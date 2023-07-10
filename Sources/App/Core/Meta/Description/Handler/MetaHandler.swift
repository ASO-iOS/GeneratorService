//
//  File.swift
//  
//
//  Created by admin on 07.07.2023.
//

import Foundation

struct MetaHandler {
    static let fileName = "Meta.txt"
    static func fileContent(appName: String, short: String, full: String, category: String) -> String {
        return """
Title:

\(appName)

Short:

\(short)

Full:

\(full)

Category:

\(category)
"""
    }
}
