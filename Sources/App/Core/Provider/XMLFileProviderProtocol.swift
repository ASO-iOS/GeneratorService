//
//  File.swift
//  
//
//  Created by admin on 03.08.2023.
//

import Foundation

protocol XMLFileProviderProtocol: FileProviderProtocol {
    static var fileName: String { get }

    static func fileContent(packageName: String, uiSettings: UISettings) -> String

    static func dependencies(_ mainData: MainData) -> ANDData

    static func gradle(_ packageName: String) -> GradleFilesData
    
    static func cmfHandler(_ packageName: String) -> ANDMainFragmentCMF
    
    static func layout(_ uiSettings: UISettings) -> [XMLLayoutData]
    
    static func dimens(_ uiSettings: UISettings) -> XMLLayoutData
}

struct XMLLayoutData {
    let content: String
    let name: String
}
