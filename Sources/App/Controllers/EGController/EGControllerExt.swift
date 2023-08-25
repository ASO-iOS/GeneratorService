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
        fileHandler.createMeta(LuckyNumberMeta.self, metaLoc: metaLoc, category: .app_entertainment, appName: appName)
        fileHandler.createGradle(EGLuckyNumber.self, packageName: packageName, gradlePaths: gradlePaths)
    }
    
    func createPhoneChecker(appName: String, path: String, resPath: String, packageName: String, uiSettings: UISettings, metaLoc: String, gradlePaths: GradlePaths) {
        fileHandler.writeFile(filePath: path, contentText: EGPhoneChecker.fileContent(packageName: packageName, uiSettings: uiSettings), fileName: EGPhoneChecker.fileName)
        
        fileHandler.writeFile(filePath: path, contentText: EGPhoneChecker.cmfHandler(packageName).content, fileName: EGPhoneChecker.cmfHandler(packageName).fileName)
        
        fileHandler.writeFile(filePath: resPath, contentText: EGPhoneCkeckerRes.content, fileName: EGPhoneCkeckerRes.name)
        fileHandler.createMeta(PhoneInfoMeta.self, metaLoc: metaLoc, category: .app_tools, appName: appName)
        fileHandler.createGradle(EGPhoneChecker.self, packageName: packageName, gradlePaths: gradlePaths)
    }
    
    func createDiceRoller(appName: String, path: String, resPath: String, packageName: String, uiSettings: UISettings, metaLoc: String, gradlePaths: GradlePaths) {
        fileHandler.writeFile(filePath: path, contentText: EGDiceRoller.fileContent(packageName: packageName, uiSettings: uiSettings), fileName: EGDiceRoller.fileName)
        fileHandler.writeFile(filePath: path, contentText: EGDiceRoller.cmfHandler(packageName).content, fileName: EGDiceRoller.cmfHandler(packageName).fileName)
        for i in 1..<7 {
            fileHandler.copyPaste(from: "\(LocalConst.homeDir)GeneratorProjects/resources/images/egdiceroller/dice\(i).png", to: resPath + "dice\(i).png")
        }
        fileHandler.createMeta(DiceRollerMeta.self, metaLoc: metaLoc, category: .app_entertainment, appName: appName)
        fileHandler.createGradle(EGDiceRoller.self, packageName: packageName, gradlePaths: gradlePaths)
    }
    
    func createWaterTracker(appName: String, path: String, packageName: String, uiSettings: UISettings, metaLoc: String, gradlePaths: GradlePaths) {
        fileHandler.writeFile(filePath: path, contentText: EGWaterTracker.fileContent(packageName: packageName, uiSettings: uiSettings), fileName: EGWaterTracker.fileName)
        fileHandler.createMeta(WaterTrackerMeta.self, metaLoc: metaLoc, category: .app_tools, appName: appName)
        fileHandler.createGradle(EGWaterTracker.self, packageName: packageName, gradlePaths: gradlePaths)
        
    }
    
    func createCurrencyRate(appName: String, path: String, packageName: String, uiSettings: UISettings, metaLoc: String, gradlePaths: GradlePaths) {
        fileHandler.writeFile(filePath: path, contentText: EGCurrencyRate.fileContent(packageName: packageName, uiSettings: uiSettings), fileName: EGCurrencyRate.fileName)
        fileHandler.createMeta(CurrencyRateMeta.self, metaLoc: metaLoc, category: .app_tools, appName: appName)
        fileHandler.createGradle(EGCurrencyRate.self, packageName: packageName, gradlePaths: gradlePaths)
    }
    
    func createLearnSlang(appName: String, path: String, packageName: String, uiSettings: UISettings, metaLoc: String, gradlePaths: GradlePaths) {
        fileHandler.writeFile(filePath: path, contentText: EGLearnSlang.fileContent(packageName: packageName, uiSettings: uiSettings), fileName: EGLearnSlang.fileName)
        fileHandler.createMeta(LearnSlangMeta.self, metaLoc: metaLoc, category: .app_tools, appName: appName)
        fileHandler.createGradle(EGLearnSlang.self, packageName: packageName, gradlePaths: gradlePaths)
    }
    
    func createFlashlight(appName: String, path: String, xmlPaths: XMLLayoutPaths, packageName: String, uiSettings: UISettings, metaLoc: String, gradlePaths: GradlePaths) {
        fileHandler.writeFile(filePath: path, contentText: EGFlashlight.fileContent(packageName: packageName, uiSettings: uiSettings), fileName: EGFlashlight.fileName)
        fileHandler.writeFile(filePath: path, contentText: EGFlashlight.cmfHandler(packageName).content, fileName: EGFlashlight.cmfHandler(packageName).fileName)
        fileHandler.checkDirectory(atPath: xmlPaths.rawPath)
        fileHandler.writeFile(filePath: xmlPaths.rawPath, contentText: EGFlashlight.motionScene().content, fileName: EGFlashlight.motionScene().name)
        fileHandler.createMeta(TorchMeta.self, metaLoc: metaLoc, category: .app_tools, appName: appName)
        fileHandler.createGradle(EGFlashlight.self, packageName: packageName, gradlePaths: gradlePaths)
    }
    
    func createExpenseTracker(appName: String, path: String, packageName: String, uiSettings: UISettings, metaLoc: String, gradlePaths: GradlePaths) {
        fileHandler.writeFile(filePath: path, contentText: EGExpenseTracker.fileContent(packageName: packageName, uiSettings: uiSettings), fileName: EGExpenseTracker.fileName)
        fileHandler.createMeta(ExpenseTrackerMeta.self, metaLoc: metaLoc, category: .app_tools, appName: appName)
        fileHandler.createGradle(EGExpenseTracker.self, packageName: packageName, gradlePaths: gradlePaths)
    }
    
    func createWhichSpf(appName: String, path: String, packageName: String, uiSettings: UISettings, metaLoc: String, gradlePaths: GradlePaths) {
        fileHandler.writeFile(filePath: path, contentText: EGWhichSpf.fileContent(packageName: packageName, uiSettings: uiSettings), fileName: EGWhichSpf.fileName)
        fileHandler.createMeta(WhichSpfMeta.self, metaLoc: metaLoc, category: .app_tools, appName: appName)
        fileHandler.createGradle(EGWhichSpf.self, packageName: packageName, gradlePaths: gradlePaths)
    }
    
    func createLoveCalculator(appName: String, path: String, packageName: String, uiSettings: UISettings, metaLoc: String, gradlePaths: GradlePaths) {
        fileHandler.writeFile(filePath: path, contentText: EGLoveCalculator.fileContent(packageName: packageName, uiSettings: uiSettings), fileName: EGLoveCalculator.fileName)
        fileHandler.writeFile(filePath: path, contentText: EGLoveCalculator.cmfHandler(packageName).content, fileName: EGLoveCalculator.cmfHandler(packageName).fileName)
        fileHandler.createMeta(LoveCalculatorMeta.self, metaLoc: metaLoc, category: .app_entertainment, appName: appName)
        fileHandler.createGradle(EGLoveCalculator.self, packageName: packageName, gradlePaths: gradlePaths)
    }
    
    func createGetLyrics(appName: String, path: String, packageName: String, uiSettings: UISettings, metaLoc: String, gradlePaths: GradlePaths) {
        fileHandler.writeFile(filePath: path, contentText: EGGetLyrics.fileContent(packageName: packageName, uiSettings: uiSettings), fileName: EGGetLyrics.fileName)
        fileHandler.createMeta(GetLyricsMeta.self, metaLoc: metaLoc, category: .app_tools, appName: appName)
        fileHandler.createGradle(EGGetLyrics.self, packageName: packageName, gradlePaths: gradlePaths)
    }
    
    func createPuzzleDigits(appName: String, path: String, packageName: String, uiSettings: UISettings, metaLoc: String, gradlePaths: GradlePaths) {
        fileHandler.writeFile(filePath: path, contentText: EGPuzzleDigits.fileContent(packageName: packageName, uiSettings: uiSettings), fileName: EGPuzzleDigits.fileName)
        fileHandler.createMeta(PuzzleDigitsMeta.self, metaLoc: metaLoc, category: .game_puzzle, appName: appName)
        fileHandler.createGradle(EGPuzzleDigits.self, packageName: packageName, gradlePaths: gradlePaths)
    }
    
    func createCocktailCraft(appName: String, path: String, packageName: String, uiSettings: UISettings, metaLoc: String, gradlePaths: GradlePaths) {
        fileHandler.writeFile(filePath: path, contentText: EGCocktailCraft.fileContent(packageName: packageName, uiSettings: uiSettings), fileName: EGCocktailCraft.fileName)
        fileHandler.writeFile(filePath: path, contentText: EGCocktailCraft.cmfHandler(packageName).content, fileName: EGCocktailCraft.cmfHandler(packageName).fileName)
        fileHandler.createMeta(CocktailCraftMeta.self, metaLoc: metaLoc, category: .app_entertainment, appName: appName)
        fileHandler.createGradle(EGCocktailCraft.self, packageName: packageName, gradlePaths: gradlePaths)
    }
}
