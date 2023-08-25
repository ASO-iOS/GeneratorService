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
    
    func createNextPaper(appName: String, path: String, packageName: String, uiSettings: UISettings, metaLoc: String, gradlePaths: GradlePaths, resPath: String) {
        fileHandler.writeFile(filePath: path, contentText: ITNextPaper.fileContent(packageName: packageName, uiSettings: uiSettings), fileName: ITNextPaper.fileName)
        
        fileHandler.writeFile(filePath: resPath, contentText: ITNextPaperRes.icon.content, fileName: ITNextPaperRes.icon.name)
        fileHandler.createMeta(NextpaperMeta.self, metaLoc: metaLoc, category: .app_tools, appName: appName)
        fileHandler.createGradle(ITNextPaper.self, packageName: packageName, gradlePaths: gradlePaths)
    }
    
    func createCinemaScope(appName: String, path: String, packageName: String, uiSettings: UISettings, metaLoc: String, gradlePaths: GradlePaths, resPath: String) {
        fileHandler.writeFile(filePath: path, contentText: ITCinemaScope.fileContent(packageName: packageName, uiSettings: uiSettings), fileName: ITCinemaScope.fileName)
        
        fileHandler.writeFile(filePath: resPath, contentText: ITCinemaScopeRes.icon.content, fileName: ITCinemaScopeRes.icon.name)
        fileHandler.createMeta(CinemaScopeMeta.self, metaLoc: metaLoc, category: .app_tools, appName: appName)
        fileHandler.createGradle(ITCinemaScope.self, packageName: packageName, gradlePaths: gradlePaths)
    }
    
    func createTrySecret(appName: String, path: String, packageName: String, uiSettings: UISettings, metaLoc: String, gradlePaths: GradlePaths, resPath: String) {
        fileHandler.writeFile(filePath: path, contentText: ITTRySecret.fileContent(packageName: packageName, uiSettings: uiSettings), fileName: ITTRySecret.fileName)
        fileHandler.writeFile(filePath: path, contentText: ITTRySecret.cmfHandler(packageName).content, fileName: ITTRySecret.cmfHandler(packageName).fileName)
        fileHandler.writeFile(filePath: resPath, contentText: ITTrySecretRes.icon.content, fileName: ITTrySecretRes.icon.name)
        fileHandler.createMeta(TrySecretMeta.self, metaLoc: metaLoc, category: .app_tools, appName: appName)
        fileHandler.createGradle(ITTRySecret.self, packageName: packageName, gradlePaths: gradlePaths)
    }
    
    func createHeroQuest(appName: String, path: String, packageName: String, uiSettings: UISettings, metaLoc: String, gradlePaths: GradlePaths, resPath: String) {
        fileHandler.writeFile(filePath: path, contentText: ITHeroQuest.fileContent(packageName: packageName, uiSettings: uiSettings), fileName: ITHeroQuest.fileName)
        
        fileHandler.writeFile(filePath: resPath, contentText: ITHeroQuestRes.icon.content, fileName: ITHeroQuestRes.icon.name)
        fileHandler.createMeta(HeroQuestMeta.self, metaLoc: metaLoc, category: .app_tools, appName: appName)
        fileHandler.createGradle(ITHeroQuest.self, packageName: packageName, gradlePaths: gradlePaths)
    }
    
    func createWifiRate(appName: String, path: String, packageName: String, uiSettings: UISettings, metaLoc: String, gradlePaths: GradlePaths, resPath: String) {
        fileHandler.writeFile(filePath: path, contentText: ITWifiRate.fileContent(packageName: packageName, uiSettings: uiSettings), fileName: ITWifiRate.fileName)
        fileHandler.writeFile(filePath: path, contentText: ITWifiRate.cmfHandler(packageName).content, fileName: ITWifiRate.cmfHandler(packageName).fileName)
        fileHandler.writeFile(filePath: resPath, contentText: ITWifiRateRes.icon.content, fileName: ITWifiRateRes.icon.name)
        fileHandler.createMeta(WifiRateMeta.self, metaLoc: metaLoc, category: .app_tools, appName: appName)
        fileHandler.createGradle(ITWifiRate.self, packageName: packageName, gradlePaths: gradlePaths)
    }
    
    func createLearningCats(appName: String, path: String, packageName: String, uiSettings: UISettings, metaLoc: String, gradlePaths: GradlePaths, resPath: String) {
        fileHandler.writeFile(filePath: path, contentText: ITLearningCats.fileContent(packageName: packageName, uiSettings: uiSettings), fileName: ITLearningCats.fileName)
        
        fileHandler.writeFile(filePath: resPath, contentText: ITLearningCatsRes.icon.content, fileName: ITLearningCatsRes.icon.name)
        fileHandler.createMeta(LearningCatsMeta.self, metaLoc: metaLoc, category: .app_tools, appName: appName)
        fileHandler.createGradle(ITLearningCats.self, packageName: packageName, gradlePaths: gradlePaths)
    }
    
    func createOneMinTimer(appName: String, path: String, packageName: String, uiSettings: UISettings, metaLoc: String, gradlePaths: GradlePaths, resPath: String) {
        fileHandler.writeFile(filePath: path, contentText: ITOneMinTimer.fileContent(packageName: packageName, uiSettings: uiSettings), fileName: ITOneMinTimer.fileName)
        fileHandler.writeFile(filePath: path, contentText: ITOneMinTimer.cmfHandler(packageName).content, fileName: ITOneMinTimer.cmfHandler(packageName).fileName)
        fileHandler.writeFile(filePath: resPath, contentText: ITOneMinTimerRes.icon.content, fileName: ITOneMinTimerRes.icon.name)
        fileHandler.createMeta(OneMinTimerMeta.self, metaLoc: metaLoc, category: .app_tools, appName: appName)
        fileHandler.createGradle(ITOneMinTimer.self, packageName: packageName, gradlePaths: gradlePaths)
    }
    
    func createQrGenerator(appName: String, path: String, packageName: String, uiSettings: UISettings, metaLoc: String, gradlePaths: GradlePaths, resPath: String) {
        fileHandler.writeFile(filePath: path, contentText: ITQrGenerator.fileContent(packageName: packageName, uiSettings: uiSettings), fileName: ITQrGenerator.fileName)
        fileHandler.writeFile(filePath: path, contentText: ITQrGenerator.cmfHandler(packageName).content, fileName: ITQrGenerator.cmfHandler(packageName).fileName)
        fileHandler.writeFile(filePath: resPath, contentText: ITQrGeneratorRes.icon.content, fileName: ITQrGeneratorRes.icon.name)
        fileHandler.createMeta(QrGeneratorMeta.self, metaLoc: metaLoc, category: .app_tools, appName: appName)
        fileHandler.createGradle(ITQrGenerator.self, packageName: packageName, gradlePaths: gradlePaths)
    }
    
    
}
