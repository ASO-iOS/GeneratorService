//
//  File.swift
//  
//
//  Created by admin on 10.07.2023.
//

import Foundation

struct MBLuckyNumberMetaDesign1: MetaDesignProtocol {
    var backColorPrimary: String? = "F44336"
    
    var backColorSecondary: String? = "E91E63"
    
    var surfaceColor: String? = "9C27B0"
    
    var onSurfaceColor: String? = "FFFFFF"
    
    var primaryColor: String? = "673AB7"
    
    var onPrimaryColor: String? = "3F51B5"
    
    var errorColor: String? = "2196F3"
    
    var textColorPrimary: String? = "4CAF50"
    
    var textColorSecondary: String? = "FFC107"
    
    var buttonColorPrimary: String?
    
    var buttonColorSecondary: String?
    
    var buttonTextColorPrimary: String?
    
    var buttonTextColorSecondary: String?
    
    var paddingPrimary: Int?
    
    var paddingSecondary: Int?
    
    var textSizePrimary: Int?
    
    var textSizeSecondary: Int?
    
    var iconLocation: String = "\(FileManager.default.homeDirectoryForCurrentUser.absoluteString.replacing("file://", with: ""))GeneratorProjects/metaVisual/VSLuckyNumber/1/icon.png"
    
    var bannerLocation: String = "\(FileManager.default.homeDirectoryForCurrentUser.absoluteString.replacing("file://", with: ""))GeneratorProjects/metaVisual/VSLuckyNumber/1/banner.png"
    
    var screen1Location: String = "\(FileManager.default.homeDirectoryForCurrentUser.absoluteString.replacing("file://", with: ""))GeneratorProjects/metaVisual/VSLuckyNumber/1/screens/1.png"
    
    var screen2Location: String = "\(FileManager.default.homeDirectoryForCurrentUser.absoluteString.replacing("file://", with: ""))GeneratorProjects/metaVisual/VSLuckyNumber/1/screens/2.png"
    
    var screen3Location: String = "\(FileManager.default.homeDirectoryForCurrentUser.absoluteString.replacing("file://", with: ""))GeneratorProjects/metaVisual/VSLuckyNumber/1/screens/3.png"
    
    
}
