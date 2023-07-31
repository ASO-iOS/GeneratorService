//
//  File.swift
//  
//
//  Created by admin on 05.07.2023.
//

import Foundation

protocol FileProviderProtocol {
    static var fileName: String { get }
    
    static func fileContent(packageName: String, uiSettings: UISettings) -> String
    
    static func dependencies(_ mainData: MainData) -> ANDData
    
    static func gradle(_ packageName: String) -> GradleFilesData
}

struct UISettings {
    let backColorPrimary: String?
    let backColorSecondary: String?
    let surfaceColor: String?
    let onSurfaceColor: String?
    let primaryColor: String?
    let onPrimaryColor: String?
    let errorColor: String?
    let textColorPrimary: String?
    let textColorSecondary: String?
    let buttonColorPrimary: String?
    let buttonColorSecondary: String?
    let buttonTextColorPrimary: String?
    let buttonTextColorSecondary: String?
    let paddingPrimary: Int?
    let paddingSecondary: Int?
    let textSizePrimary: Int?
    let textSizeSecondary: Int?
}

struct MainData {
    let appId: String
    let appName: String
    let applicationName: String
    let packageName: String
}

struct GradleFilesData {
    let projectBuildGradle: GradleFileInfoData
    let moduleBuildGradle: GradleFileInfoData
    let dependencies: GradleFileInfoData
}

struct GradleFileInfoData {
    let content: String
    let name: String
}
