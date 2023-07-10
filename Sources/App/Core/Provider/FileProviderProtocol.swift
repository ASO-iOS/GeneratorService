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
