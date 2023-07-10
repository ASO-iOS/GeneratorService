//
//  File.swift
//  
//
//  Created by admin on 06.06.2023.
//

import Foundation

struct LocalConst {
    static let homeDir = FileManager.default.homeDirectoryForCurrentUser.absoluteString.replacing("file://", with: "")
    
    static let gradlewDir = "\(FileManager.default.homeDirectoryForCurrentUser.absoluteString.replacing("file://", with: ""))GeneratorProjects/resources/gradlew"
    
    static let gradleWrapper = "\(FileManager.default.homeDirectoryForCurrentUser.absoluteString.replacing("file://", with: ""))GeneratorProjects/resources/wrapper/gradle-wrapper.jar"
    
    static let resDir = "\(FileManager.default.homeDirectoryForCurrentUser.absoluteString.replacing("file://", with: ""))GeneratorProjects/resources/res"
    
    static let tempDir = "\(FileManager.default.homeDirectoryForCurrentUser.absoluteString.replacing("file://", with: ""))GeneratorProjects/temp/"
    
    static let fontDir = "\(FileManager.default.homeDirectoryForCurrentUser.absoluteString.replacing("file://", with: ""))GeneratorProjects/resources/font"
    
    static let MBRaceRes = "\(FileManager.default.homeDirectoryForCurrentUser.absoluteString.replacing("file://", with: ""))GeneratorProjects/resources/MBRaceRes"
    
    static let MBCatcherRes = "\(FileManager.default.homeDirectoryForCurrentUser.absoluteString.replacing("file://", with: ""))GeneratorProjects/resources/MBCatcherRes"
    
    static let MBSpaceFighterRes = "\(FileManager.default.homeDirectoryForCurrentUser.absoluteString.replacing("file://", with: ""))GeneratorProjects/resources/MBSpaceFighterRes"
    
    static let gradleURL = "http://www.java2s.com/Code/JarDownload/gradle-wrapper/gradle-wrapper.jar.zip"
    
    static let dickButt = "https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fmedia.giphy.com%2Fmedia%2FYJ0XfO0qaXZv2%2Fgiphy.gif&f=1&nofb=1&ipt=13e60a92732c2fd3e8fd70b97ac62d158245077e567e7b3bef027c8467a7af9b&ipo=images"
}
