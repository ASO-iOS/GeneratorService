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
    
    func createLuckyNumber(appName: String, path: String, xmlPaths: XMLLayoutPaths, packageName: String, uiSettings: UISettings, metaLoc: String, gradlePaths: GradlePaths) {
        fileHandler.writeFile(filePath: path, contentText: EGLuckyNumber.fileContent(packageName: packageName, uiSettings: uiSettings), fileName: EGLuckyNumber.fileName)
        fileHandler.writeFile(filePath: path, contentText: EGLuckyNumber.cmfHandler(packageName).content, fileName: EGLuckyNumber.cmfHandler(packageName).fileName)
        fileHandler.writeFile(filePath: metaLoc, contentText: MetaHandler.fileContent(appName: appName, short: LuckyNumberMeta.getShortDesc(appName: appName), full: LuckyNumberMeta.getFullDesc(appName: appName), category: AppCategory.app_entertainment.rawValue), fileName: MetaHandler.fileName)
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
