//
//  File.swift
//  
//
//  Created by admin on 10.07.2023.
//

import Foundation

struct VSPhoneInfoMetaDesign1: MetaDesignProtocol {
    var backColorPrimary: String? = "3F51B5"
    
    var backColorSecondary: String? = "B53F94"
    
    var surfaceColor: String? = "071950"
    
    var onSurfaceColor: String?
    
    var primaryColor: String?
    
    var onPrimaryColor: String?
    
    var errorColor: String?
    
    var textColorPrimary: String? = "FFFFFF"
    
    var textColorSecondary: String?
    
    var buttonColorPrimary: String?
    
    var buttonColorSecondary: String? = "348810"
    
    var buttonTextColorPrimary: String? = "FFFFFF"
    
    var buttonTextColorSecondary: String?
    
    var paddingPrimary: Int?
    
    var paddingSecondary: Int?
    
    var textSizePrimary: Int?
    
    var textSizeSecondary: Int?
    
    var iconLocation: String = "\(FileManager.default.homeDirectoryForCurrentUser.absoluteString.replacing("file://", with: ""))GeneratorProjects/metaVisual/VSPhoneInfo/1/icon.png"
    
    var bannerLocation: String = "\(FileManager.default.homeDirectoryForCurrentUser.absoluteString.replacing("file://", with: ""))GeneratorProjects/metaVisual/VSPhoneInfo/1/banner.png"
    
    var screen1Location: String = "\(FileManager.default.homeDirectoryForCurrentUser.absoluteString.replacing("file://", with: ""))GeneratorProjects/metaVisual/VSPhoneInfo/1/screens/1.png"
    
    var screen2Location: String = "\(FileManager.default.homeDirectoryForCurrentUser.absoluteString.replacing("file://", with: ""))GeneratorProjects/metaVisual/VSPhoneInfo/1/screens/2.png"
    
    var screen3Location: String = "\(FileManager.default.homeDirectoryForCurrentUser.absoluteString.replacing("file://", with: ""))GeneratorProjects/metaVisual/VSPhoneInfo/1/screens/3.png"
    
    
}
