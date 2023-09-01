//
//  File.swift
//  
//
//  Created by admin on 01.09.2023.
//

import Foundation

extension DTController {
    func createNumbersFacts (appName: String, path: String, packageName: String, uiSettings: UISettings, metaLoc: String, gradlePaths: GradlePaths, resPath: String, mainData: MainData) {
        fileHandler.writeFile(filePath: path, contentText: DTNumberFacts.mainFragmentCMF(mainData).content, fileName: DTNumberFacts.mainFragmentCMF(mainData).fileName)
        
        fileHandler.createMeta(NumbersFactsMeta.self, metaLoc: metaLoc, category: .app_tools, appName: appName)
        fileHandler.createGradle(DTNumberFacts.self, packageName: packageName, gradlePaths: gradlePaths)
    }
    
    func createProgrammingJokes(appName: String, path: String, packageName: String, uiSettings: UISettings, metaLoc: String, gradlePaths: GradlePaths, resPath: String, mainData: MainData) {
        fileHandler.writeFile(filePath: path, contentText: DTProgrammingJokes.mainFragmentCMF(mainData).content, fileName: DTProgrammingJokes.mainFragmentCMF(mainData).fileName)
        
        fileHandler.createMeta(ProgrammingJokesMeta.self, metaLoc: metaLoc, category: .app_tools, appName: appName)
        fileHandler.createGradle(DTProgrammingJokes.self, packageName: packageName, gradlePaths: gradlePaths)
    }
    
    func createQrGenShare(appName: String, path: String, packageName: String, uiSettings: UISettings, metaLoc: String, gradlePaths: GradlePaths, resPath: String, mainData: MainData, xmlPaths: XMLLayoutPaths) {
        fileHandler.writeFile(filePath: path, contentText: DTQrGenShare.mainFragmentCMF(mainData).content, fileName: DTQrGenShare.mainFragmentCMF(mainData).fileName)
        fileHandler.writeFile(filePath: xmlPaths.valuesPath, contentText: DTQrGenShareRes.icon.content, fileName: DTQrGenShareRes.icon.name)
        
        fileHandler.createMeta(QrGenShareMeta.self, metaLoc: metaLoc, category: .app_tools, appName: appName)
        fileHandler.createGradle(DTQrGenShare.self, packageName: packageName, gradlePaths: gradlePaths)
    }
    
    func createRot13Encrypt(appName: String, path: String, packageName: String, uiSettings: UISettings, metaLoc: String, gradlePaths: GradlePaths, resPath: String, mainData: MainData, xmlPaths: XMLLayoutPaths) {
        fileHandler.writeFile(filePath: path, contentText: DTRot13Encrypt.mainFragmentCMF(mainData).content, fileName: DTRot13Encrypt.mainFragmentCMF(mainData).fileName)
        fileHandler.writeFile(filePath: xmlPaths.valuesPath, contentText: DTRot13EncryptRes.icon.content, fileName: DTRot13EncryptRes.icon.name)
        
        fileHandler.createMeta(ROT13EncryptMeta.self, metaLoc: metaLoc, category: .app_tools, appName: appName)
        fileHandler.createGradle(DTRot13Encrypt.self, packageName: packageName, gradlePaths: gradlePaths)
    }
    
    func createTextSimilarity(appName: String, path: String, packageName: String, uiSettings: UISettings, metaLoc: String, gradlePaths: GradlePaths, resPath: String, mainData: MainData, xmlPaths: XMLLayoutPaths) {
        fileHandler.writeFile(filePath: path, contentText: DTTextSimilarity.mainFragmentCMF(mainData).content, fileName: DTTextSimilarity.mainFragmentCMF(mainData).fileName)
        fileHandler.writeFile(filePath: xmlPaths.valuesPath, contentText: DTTextSimilarityRes.icon.content, fileName: DTTextSimilarityRes.icon.name)
        
        fileHandler.createMeta(TextSimilarityMeta.self, metaLoc: metaLoc, category: .app_tools, appName: appName)
        fileHandler.createGradle(DTTextSimilarity.self, packageName: packageName, gradlePaths: gradlePaths)
        
    }
    
    
}
