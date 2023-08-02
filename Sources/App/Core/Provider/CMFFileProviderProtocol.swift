//
//  File.swift
//  
//
//  Created by admin on 02.08.2023.
//

import Foundation

protocol CMFFileProviderProtocol: FileProviderProtocol {
    static var fileName: String { get }

    static func fileContent(packageName: String, uiSettings: UISettings) -> String

    static func dependencies(_ mainData: MainData) -> ANDData

    static func gradle(_ packageName: String) -> GradleFilesData

    static func cmfHandler(_ packageName: String) -> ANDMainFragmentCMF
}
