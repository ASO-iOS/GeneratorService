//
//  File.swift
//  
//
//  Created by admin on 09.08.2023.
//

import Foundation

extension AKController {
    func createRickAndMorty(appName: String, path: String, resPath: String, xmlPaths: XMLLayoutPaths, packageName: String, uiSettings: UISettings, metaLoc: String, gradlePaths: GradlePaths) {
        fileHandler.writeFile(filePath: path, contentText: AKRickAndMorty.fileContent(packageName: packageName, uiSettings: uiSettings), fileName: AKRickAndMorty.fileName)
        fileHandler.writeFile(filePath: path, contentText: AKRickAndMorty.cmfHandler(packageName).content, fileName: AKRickAndMorty.cmfHandler(packageName).fileName)
        fileHandler.copyPaste(from: "\(LocalConst.homeDir)GeneratorProjects/resources/images/akrickandmorty/arrow_next.png", to: resPath + "arrow_next.png")
        fileHandler.copyPaste(from: "\(LocalConst.homeDir)GeneratorProjects/resources/images/akrickandmorty/arrow_back.png", to: resPath + "arrow_back.png")
        fileHandler.copyPaste(from: "\(LocalConst.homeDir)GeneratorProjects/resources/images/akrickandmorty/arrow.png", to: resPath + "arrow.png")
        fileHandler.copyPaste(from: "\(LocalConst.homeDir)GeneratorProjects/resources/images/akrickandmorty/logo.png", to: resPath + "logo.png")
        fileHandler.checkDirectory(atPath: xmlPaths.fontPath)
        fileHandler.copyPaste(from: "\(LocalConst.homeDir)GeneratorProjects/resources/font/gilroy_bold.ttf", to: xmlPaths.fontPath + "gilroy_bold.ttf")
        fileHandler.copyPaste(from: "\(LocalConst.homeDir)GeneratorProjects/resources/font/gilroy_medium.ttf", to: xmlPaths.fontPath + "gilroy_medium.ttf")
        fileHandler.copyPaste(from: "\(LocalConst.homeDir)GeneratorProjects/resources/font/gilroy.otf", to: xmlPaths.fontPath + "gilroy.otf")
        fileHandler.writeFile(filePath: resPath, contentText: AKRickAndMortyRes.content, fileName: AKRickAndMortyRes.name)
        fileHandler.createMeta(CartoonCharactersMeta.self, metaLoc: metaLoc, category: .app_entertainment, appName: appName)
        fileHandler.createGradle(AKRickAndMorty.self, packageName: packageName, gradlePaths: gradlePaths)
    }
    
    func createShashlikCalculator(appName: String, path: String, resPath: String, packageName: String, uiSettings: UISettings, metaLoc: String, gradlePaths: GradlePaths) {
        fileHandler.writeFile(filePath: path, contentText: AKShahlikCalculator.fileContent(packageName: packageName, uiSettings: uiSettings), fileName: AKShahlikCalculator.fileName)
        fileHandler.copyPaste(from: "\(LocalConst.homeDir)GeneratorProjects/resources/images/akshashlikcalculator/chicken.webp", to: resPath + "chicken.webp")
        fileHandler.copyPaste(from: "\(LocalConst.homeDir)GeneratorProjects/resources/images/akshashlikcalculator/cow.webp", to: resPath + "cow.webp")
        fileHandler.copyPaste(from: "\(LocalConst.homeDir)GeneratorProjects/resources/images/akshashlikcalculator/pig.webp", to: resPath + "pig.webp")
        fileHandler.copyPaste(from: "\(LocalConst.homeDir)GeneratorProjects/resources/images/akshashlikcalculator/shashlik.webp", to: resPath + "shashlik.webp")
        fileHandler.copyPaste(from: "\(LocalConst.homeDir)GeneratorProjects/resources/images/akshashlikcalculator/sheep.webp", to: resPath + "sheep.webp")
        fileHandler.createGradle(AKShahlikCalculator.self, packageName: packageName, gradlePaths: gradlePaths)
    }
    
//    func createAlarm(appName: String, path: String, resPath: String, packageName: String, uiSettings: UISettings, metaLoc: String, gradlePaths: GradlePaths) {
//        fileHandler.writeFile(filePath: path, contentText: AKAlarm.fileContent(packageName: packageName, uiSettings: uiSettings), fileName: AKAlarm.fileName)
//        fileHandler.writeFile(filePath: resPath, contentText: <#T##String#>, fileName: <#T##String#>)
//    }
}
