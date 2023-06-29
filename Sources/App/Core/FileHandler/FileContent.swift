//
//  File.swift
//  
//
//  Created by admin on 01.06.2023.
//

import Foundation

struct FileContent: Hashable {
    let fileName: String
    let fullPackage: String
    let content: String
    let usable: Bool
    
    static func emptyFile() -> FileContent {
        return FileContent(fileName: "", fullPackage: "", content: "", usable: false)
    }
}
