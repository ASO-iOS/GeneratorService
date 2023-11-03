//
//  File.swift
//  
//
//  Created by admin on 31.10.2023.
//

import Foundation

extension KDController {
    func createGallery(appName: String, path: String, xmlPaths: XMLLayoutPaths, packageName: String, uiSettings: UISettings, metaLoc: String, gradlePaths: GradlePaths) {
        fileHandler.writeFile(filePath: path, contentText: KDGallery.fileContent(packageName: packageName, uiSettings: uiSettings), fileName: KDGallery.fileName)
        fileHandler.createGradle(KDGallery.self, packageName: packageName, gradlePaths: gradlePaths)
        fileHandler.createMeta(RandomPhotosMeta.self, metaLoc: metaLoc, category: .app_entertainment, appName: appName)
        fileHandler.checkDirectory(atPath: xmlPaths.fontPath)
        fileHandler.copyPaste(from: LocalConst.fontDir + "/arvo_bold.ttf", to: xmlPaths.fontPath + "/arvo_bold.ttf")
        fileHandler.copyPaste(from: LocalConst.fontDir + "/lilitaone_regular.ttf", to: xmlPaths.fontPath + "/lilitaone_regular.ttf")
    }
    
    func createNamesGennerator(appName: String, path: String, xmlPaths: XMLLayoutPaths, packageName: String, uiSettings: UISettings, metaLoc: String, gradlePaths: GradlePaths, resPath: String) {
        fileHandler.writeFile(filePath: path, contentText: KDNameGenerator.fileContent(packageName: packageName, uiSettings: uiSettings), fileName: KDNameGenerator.fileName)
        fileHandler.copyPaste(from: LocalConst.homeDir + "/GeneratorProjects/resources/bannerResources/kdnamegenerator/button_icon.png", to: resPath + "generator.png")
        fileHandler.checkDirectory(atPath: xmlPaths.fontPath)
        fileHandler.copyPaste(from: LocalConst.fontDir + "/roboto_bold.ttf", to: xmlPaths.fontPath + "/roboto_bold.ttf")
        fileHandler.copyPaste(from: LocalConst.fontDir + "/roboto_medium.ttf", to: xmlPaths.fontPath + "/roboto_medium.ttf")
        fileHandler.createGradle(KDNameGenerator.self, packageName: packageName, gradlePaths: gradlePaths)
        fileHandler.createMeta(NameGeneratorMeta.self, metaLoc: metaLoc, category: .app_entertainment, appName: appName)
        
    }
}
