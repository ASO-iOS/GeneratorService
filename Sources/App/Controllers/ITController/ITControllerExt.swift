//
//  File.swift
//  
//
//  Created by admin on 31.07.2023.
//

import Foundation

extension ITController {
    func createQuickWriter(appName: String, path: String, packageName: String, uiSettings: UISettings, metaLoc: String, gradlePaths: GradlePaths, resPath: String) {
        fileHandler.writeFile(filePath: path, contentText: ITQuickWriter.fileContent(packageName: packageName, uiSettings: uiSettings), fileName: ITQuickWriter.fileName)
        
        fileHandler.writeFile(filePath: resPath, contentText: ITQuickWriterRes.icon.content, fileName: ITQuickWriterRes.icon.name)
        fileHandler.createMeta(QuickWriteerMeta.self, metaLoc: metaLoc, category: .app_tools, appName: appName)
        fileHandler.createGradle(ITQuickWriter.self, packageName: packageName, gradlePaths: gradlePaths)
    }
    
    func createStopwatch(appName: String, path: String, packageName: String, uiSettings: UISettings, metaLoc: String, gradlePaths: GradlePaths) {
        fileHandler.writeFile(filePath: path, contentText: ITStopwatch.fileContent(packageName: packageName, uiSettings: uiSettings), fileName: ITStopwatch.fileName)
        fileHandler.writeFile(filePath: path, contentText: ITStopwatch.cmfHandler(packageName).content, fileName: ITStopwatch.cmfHandler(packageName).fileName)
        
        fileHandler.writeFile(filePath: metaLoc, contentText: MetaHandler.fileContent(appName: appName, short: StopwatchMeta.getShortDesc(appName: appName), full: StopwatchMeta.getFullDesc(appName: appName), category: AppCategory.app_tools.rawValue), fileName: MetaHandler.fileName)
        
        fileHandler.createGradle(ITStopwatch.self, packageName: packageName, gradlePaths: gradlePaths)
    }
    
    func createDeviceInfo(appName: String, path: String, packageName: String, uiSettings: UISettings, metaLoc: String, gradlePaths: GradlePaths) {
        fileHandler.writeFile(filePath: path, contentText: ITDeviceInfo.fileContent(packageName: packageName, uiSettings: uiSettings), fileName: ITDeviceInfo.fileName)
        
        fileHandler.writeFile(filePath: path, contentText: ITDeviceInfo.cmfHandler(packageName).content, fileName: ITDeviceInfo.cmfHandler(packageName).fileName)
        
        fileHandler.writeFile(filePath: metaLoc, contentText: MetaHandler.fileContent(appName: appName, short: DeviceInfoMeta.getShortDesc(appName: appName), full: DeviceInfoMeta.getFullDesc(appName: appName), category: AppCategory.app_tools.rawValue), fileName: MetaHandler.fileName)
        
        fileHandler.createGradle(ITDeviceInfo.self, packageName: packageName, gradlePaths: gradlePaths)
    }
    
    func createQuickCalc(appName: String, path: String, packageName: String, uiSettings: UISettings, metaLoc: String, gradlePaths: GradlePaths, resPath: String) {
        fileHandler.writeFile(filePath: path, contentText: ITQuickCacl.fileContent(packageName: packageName, uiSettings: uiSettings), fileName: ITQuickCacl.fileName)
        
        fileHandler.writeFile(filePath: resPath, contentText: ITQuickCalcRes.icon.content, fileName: ITQuickCalcRes.icon.name)
        fileHandler.createMeta(QuickCalcMeta.self, metaLoc: metaLoc, category: .app_tools, appName: appName)
        fileHandler.createGradle(ITQuickCacl.self, packageName: packageName, gradlePaths: gradlePaths)
    }
    
    func createNumberGen(appName: String, path: String, packageName: String, uiSettings: UISettings, metaLoc: String, gradlePaths: GradlePaths, resPath: String) {
        fileHandler.writeFile(filePath: path, contentText: ITNumberGen.fileContent(packageName: packageName, uiSettings: uiSettings), fileName: ITNumberGen.fileName)
        
        fileHandler.writeFile(filePath: resPath, contentText: ITNumberGenRes.icon.content, fileName: ITNumberGenRes.icon.name)
        fileHandler.createMeta(NumberGenMeta.self, metaLoc: metaLoc, category: .app_tools, appName: appName)
        fileHandler.createGradle(ITNumberGen.self, packageName: packageName, gradlePaths: gradlePaths)
    }
    
    
}
