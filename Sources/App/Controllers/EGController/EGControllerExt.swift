//
//  File.swift
//  
//
//  Created by admin on 03.08.2023.
//

import Foundation

extension EGController {
    func createStopwatch(appName: String, path: String, layoutPath: String, valuesPath: String, packageName: String, uiSettings: UISettings, metaLoc: String, gradlePaths: GradlePaths) {
        fileHandler.writeFile(filePath: path, contentText: EGStopwatch.fileContent(packageName: packageName, uiSettings: uiSettings), fileName: EGStopwatch.fileName)
        
        fileHandler.writeFile(filePath: path, contentText: EGStopwatch.cmfHandler(packageName).content, fileName: EGStopwatch.cmfHandler(packageName).fileName)
        
        fileHandler.writeFile(filePath: metaLoc, contentText: MetaHandler.fileContent(appName: appName, short: StopwatchMeta.getShortDesc(appName: appName), full: StopwatchMeta.getFullDesc(appName: appName), category: AppCategory.app_tools.rawValue), fileName: MetaHandler.fileName)
        if !FileManager.default.fileExists(atPath: layoutPath) {
            do {
                try FileManager.default.createDirectory(atPath: layoutPath, withIntermediateDirectories: true)
            } catch {
                print(error)
            }
        }
        let layout = EGStopwatch.layout(uiSettings)
        layout.forEach { layout in
            fileHandler.writeFile(filePath: layoutPath, contentText: layout.content, fileName: layout.name)
        }
        if !FileManager.default.fileExists(atPath: valuesPath) {
            do {
                try FileManager.default.createDirectory(atPath: valuesPath, withIntermediateDirectories: true)
            } catch {
                print(error)
            }
        }
        fileHandler.writeFile(filePath: valuesPath, contentText: EGStopwatch.dimens(uiSettings).content, fileName: EGStopwatch.dimens(uiSettings).name)
        
        fileHandler.createGradle(EGStopwatch.self, packageName: packageName, gradlePaths: gradlePaths)
    }
    
    func createRace(appName: String, path: String, xmlPaths: XMLLayoutPaths, packageName: String, uiSettings: UISettings, metaLoc: String, gradlePaths: GradlePaths) {
        fileHandler.writeFile(filePath: path, contentText: EGRace.fileContent(packageName: packageName, uiSettings: uiSettings), fileName: EGRace.fileName)
        fileHandler.writeFile(filePath: path, contentText: EGRace.cmfHandler(packageName).content, fileName: EGRace.cmfHandler(packageName).fileName)
        fileHandler.writeFile(filePath: metaLoc, contentText: MetaHandler.fileContent(appName: appName, short: RaceMeta.getShortDesc(appName: appName), full: RaceMeta.getFullDesc(appName: appName), category: AppCategory.game_race.rawValue), fileName: MetaHandler.fileName)
        let layoutPath = xmlPaths.layoutPath
        let valuesPath = xmlPaths.valuesPath
        let animPath = xmlPaths.animPath
        fileHandler.checkDirectory(atPath: layoutPath)
        let layout = EGRace.layout(uiSettings)
        layout.forEach { layout in
            fileHandler.writeFile(filePath: layoutPath, contentText: layout.content, fileName: layout.name)
        }
        fileHandler.checkDirectory(atPath: valuesPath)
        fileHandler.writeFile(filePath: valuesPath, contentText: EGRace.dimens(uiSettings).content, fileName: EGRace.dimens(uiSettings).name)
        
        fileHandler.checkDirectory(atPath: animPath)
        let anim = EGRace.anim()
        anim.forEach { anim in
            fileHandler.writeFile(filePath: animPath, contentText: anim.content, fileName: anim.name)
        }
        
        fileHandler.createGradle(EGRace.self, packageName: packageName, gradlePaths: gradlePaths)
        
    }
    
    func createLuckyNumber(appName: String, path: String, resPath: String, xmlPaths: XMLLayoutPaths, packageName: String, uiSettings: UISettings, metaLoc: String, gradlePaths: GradlePaths) {
        fileHandler.writeFile(filePath: path, contentText: EGLuckyNumber.fileContent(packageName: packageName, uiSettings: uiSettings), fileName: EGLuckyNumber.fileName)
        fileHandler.writeFile(filePath: path, contentText: EGLuckyNumber.cmfHandler(packageName).content, fileName: EGLuckyNumber.cmfHandler(packageName).fileName)
        fileHandler.writeFile(filePath: metaLoc, contentText: MetaHandler.fileContent(appName: appName, short: LuckyNumberMeta.getShortDesc(appName: appName), full: LuckyNumberMeta.getFullDesc(appName: appName), category: AppCategory.app_entertainment.rawValue), fileName: MetaHandler.fileName)
        fileHandler.writeFile(filePath: resPath, contentText: EGLuckyNumberRes.questContent(uiSettings.buttonColorPrimary ?? "FFFFFF"), fileName: EGLuckyNumberRes.questName)
        fileHandler.writeFile(filePath: resPath, contentText: EGLuckyNumberRes.borderContent, fileName: EGLuckyNumberRes.borderName)
        fileHandler.copyPaste(from: LocalConst.homeDir + "GeneratorProjects/resources/images/clover.webp", to: resPath + "clover.webp")
        let layoutPath = xmlPaths.layoutPath
        let valuesPath = xmlPaths.valuesPath
        let layouts = EGLuckyNumber.layout(uiSettings)
        layouts.forEach { layout in
            fileHandler.writeFile(filePath: layoutPath, contentText: layout.content, fileName: layout.name)
        }
        fileHandler.checkDirectory(atPath: valuesPath)
        fileHandler.writeFile(filePath: valuesPath, contentText: EGLuckyNumber.dimens(uiSettings).content, fileName: EGLuckyNumber.dimens(uiSettings).name)
        fileHandler.createGradle(EGLuckyNumber.self, packageName: packageName, gradlePaths: gradlePaths)
    }
    
    func createPhoneChecker(appName: String, path: String, resPath: String, packageName: String, uiSettings: UISettings, metaLoc: String, gradlePaths: GradlePaths) {
        fileHandler.writeFile(filePath: path, contentText: EGPhoneChecker.fileContent(packageName: packageName, uiSettings: uiSettings), fileName: EGPhoneChecker.fileName)
        
        fileHandler.writeFile(filePath: path, contentText: EGPhoneChecker.cmfHandler(packageName).content, fileName: EGPhoneChecker.cmfHandler(packageName).fileName)
        
        fileHandler.writeFile(filePath: resPath, contentText: EGPhoneCkeckerRes.content, fileName: EGPhoneCkeckerRes.name)
        
        fileHandler.writeFile(filePath: metaLoc, contentText: MetaHandler.fileContent(appName: appName, short: PhoneInfoMeta.getShortDesc(appName: appName), full: PhoneInfoMeta.getFullDesc(appName: appName), category: AppCategory.app_tools.rawValue), fileName: MetaHandler.fileName)
        fileHandler.createGradle(EGPhoneChecker.self, packageName: packageName, gradlePaths: gradlePaths)
    }
    
    func createDiceRoller(appName: String, path: String, resPath: String, packageName: String, uiSettings: UISettings, metaLoc: String, gradlePaths: GradlePaths) {
        fileHandler.writeFile(filePath: path, contentText: EGDiceRoller.fileContent(packageName: packageName, uiSettings: uiSettings), fileName: EGDiceRoller.fileName)
        fileHandler.writeFile(filePath: path, contentText: EGDiceRoller.cmfHandler(packageName).content, fileName: EGDiceRoller.cmfHandler(packageName).fileName)
        for i in 1..<7 {
            fileHandler.copyPaste(from: "\(LocalConst.homeDir)GeneratorProjects/resources/images/egdiceroller/dice\(i).png", to: resPath + "dice\(i).png")
        }
        fileHandler.writeFile(filePath: metaLoc, contentText: MetaHandler.fileContent(appName: appName, short: DiceRollerMeta.getShortDesc(appName: appName), full: DiceRollerMeta.getFullDesc(appName: appName), category: AppCategory.app_entertainment.rawValue), fileName: MetaHandler.fileName)
        fileHandler.createGradle(EGDiceRoller.self, packageName: packageName, gradlePaths: gradlePaths)
    }
    
    func createWaterTracker(appName: String, path: String, packageName: String, uiSettings: UISettings, metaLoc: String, gradlePaths: GradlePaths) {
        fileHandler.writeFile(filePath: path, contentText: EGWaterTracker.fileContent(packageName: packageName, uiSettings: uiSettings), fileName: EGWaterTracker.fileName)
//        fileHandler.writeFile(filePath: metaLoc, contentText: MetaHandler.fileContent(appName: appName, short: <#T##String#>, full: <#T##String#>, category: <#T##String#>), fileName: <#T##String#>)
        fileHandler.createGradle(EGWaterTracker.self, packageName: packageName, gradlePaths: gradlePaths)
        
    }
}

extension FileHandler {
    func checkDirectory(atPath path: String) {
        if !FileManager.default.fileExists(atPath: path) {
            do {
                try FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true)
            } catch {
                print(error)
            }
        }
    }
}
