//
//  File.swift
//  
//
//  Created by admin on 14.08.2023.
//

import Foundation

extension KLController {
    func createBMICalculator(appName: String, path: String, packageName: String, uiSettings: UISettings, metaLoc: String, gradlePaths: GradlePaths, xmlPaths: XMLLayoutPaths) {
        fileHandler.writeFile(filePath: path, contentText: KLBMICalculator.fileContent(packageName: packageName, uiSettings: uiSettings), fileName: KLBMICalculator.fileName)
        fileHandler.writeFile(filePath: path, contentText: KLBMICalculator.cmfHandler(packageName).content, fileName: KLBMICalculator.cmfHandler(packageName).fileName)
        fileHandler.checkDirectory(atPath: xmlPaths.layoutPath)
        let layouts = KLBMICalculator.layout(uiSettings)
        layouts.forEach { layout in
            fileHandler.writeFile(filePath: xmlPaths.layoutPath, contentText: layout.content, fileName: layout.name)
        }
        fileHandler.writeFile(filePath: xmlPaths.valuesPath, contentText: KLBMICalculator.dimens(uiSettings).content, fileName: KLBMICalculator.dimens(uiSettings).name)
        fileHandler.writeFile(filePath: xmlPaths.valuesPath, contentText: KLBMICalculator.styles().content, fileName: KLBMICalculator.styles().name)
        fileHandler.createMeta(BmiCalcMeta.self, metaLoc: metaLoc, category: .app_tools, appName: appName)
        fileHandler.createGradle(KLBMICalculator.self, packageName: packageName, gradlePaths: gradlePaths, useDeps: false)
    }
    
    func createMetricsConverter(appName: String, path: String, packageName: String, uiSettings: UISettings, metaLoc: String, gradlePaths: GradlePaths, xmlPaths: XMLLayoutPaths) {
        fileHandler.writeFile(filePath: path, contentText: KLMetricsConverter.fileContent(packageName: packageName, uiSettings: uiSettings), fileName: KLMetricsConverter.fileName)
        fileHandler.writeFile(filePath: path, contentText: KLMetricsConverter.cmfHandler(packageName).content, fileName: KLMetricsConverter.cmfHandler(packageName).fileName)
        fileHandler.checkDirectory(atPath: xmlPaths.layoutPath)
        let layouts = KLMetricsConverter.layout(uiSettings)
        layouts.forEach { layout in
            fileHandler.writeFile(filePath: xmlPaths.layoutPath, contentText: layout.content, fileName: layout.name)
        }
        fileHandler.writeFile(filePath: xmlPaths.valuesPath, contentText: KLMetricsConverter.dimens(uiSettings).content, fileName: KLMetricsConverter.dimens(uiSettings).name)
        fileHandler.writeFile(filePath: xmlPaths.valuesPath, contentText: KLMetricsConverter.styles().content, fileName: KLMetricsConverter.styles().name)
        
        fileHandler.createMeta(MetricsConverterMeta.self, metaLoc: metaLoc, category: .app_tools, appName: appName)
        fileHandler.createGradle(KLMetricsConverter.self, packageName: packageName, gradlePaths: gradlePaths, useDeps: false)
    }
    
    func createRecorder(appName: String, path: String, resPath: String, packageName: String, uiSettings: UISettings, metaLoc: String, gradlePaths: GradlePaths, xmlPaths: XMLLayoutPaths) {
        fileHandler.writeFile(filePath: path, contentText: KLRecorder.fileContent(packageName: packageName, uiSettings: uiSettings), fileName: KLRecorder.fileName)
        fileHandler.writeFile(filePath: path, contentText: KLRecorder.cmfHandler(packageName).content, fileName: KLRecorder.cmfHandler(packageName).fileName)
        let res = KLRecorderRes.res()
        res.forEach { item in
            fileHandler.writeFile(filePath: resPath, contentText: item.content, fileName: item.name)
        }
        let layouts = KLRecorder.layout(uiSettings)
        fileHandler.checkDirectory(atPath: xmlPaths.layoutPath)
        layouts.forEach { layout in
            fileHandler.writeFile(filePath: xmlPaths.layoutPath, contentText: layout.content, fileName: layout.name)
        }
        fileHandler.writeFile(filePath: xmlPaths.valuesPath, contentText: KLRecorder.dimens(uiSettings).content, fileName: KLRecorder.dimens(uiSettings).name)
        fileHandler.createMeta(RecorderMeta.self, metaLoc: metaLoc, category: .app_tools, appName: appName)
        fileHandler.createGradle(KLRecorder.self, packageName: packageName, gradlePaths: gradlePaths, useDeps: false)
    }
    
    func createSpeedTest(appName: String, path: String, packageName: String, uiSettings: UISettings, metaLoc: String, gradlePaths: GradlePaths, xmlPaths: XMLLayoutPaths) {
        fileHandler.writeFile(filePath: path, contentText: KLSpeedTest.fileContent(packageName: packageName, uiSettings: uiSettings), fileName: KLSpeedTest.fileName)
        fileHandler.writeFile(filePath: path, contentText: KLSpeedTest.cmfHandler(packageName).content, fileName: KLSpeedTest.cmfHandler(packageName).fileName)
        fileHandler.checkDirectory(atPath: xmlPaths.layoutPath)
        let layouts = KLSpeedTest.layout(uiSettings)
        layouts.forEach { layout in
            fileHandler.writeFile(filePath: xmlPaths.layoutPath, contentText: layout.content, fileName: layout.name)
        }
        fileHandler.writeFile(filePath: xmlPaths.valuesPath, contentText: KLSpeedTest.dimens(uiSettings).content, fileName: KLSpeedTest.dimens(uiSettings).name)
        fileHandler.writeFile(filePath: xmlPaths.valuesPath, contentText: KLSpeedTest.styles().content, fileName: KLSpeedTest.styles().name)
        fileHandler.createMeta(SpeedTestMeta.self, metaLoc: metaLoc, category: .app_tools, appName: appName)
        fileHandler.createGradle(KLSpeedTest.self, packageName: packageName, gradlePaths: gradlePaths, useDeps: false)
    }
    
    func createClicker(appName: String, path: String, packageName: String, uiSettings: UISettings, metaLoc: String, gradlePaths: GradlePaths) {
        fileHandler.writeFile(filePath: path, contentText: KLClicker.fileContent(packageName: packageName, uiSettings: uiSettings), fileName: KLClicker.fileName)
        fileHandler.createMeta(ClickerMeta.self, metaLoc: metaLoc, category: .game_arcade, appName: appName)
        fileHandler.createGradle(KLClicker.self, packageName: packageName, gradlePaths: gradlePaths)
    }
    
    func createColorSwatcher(appName: String, path: String, packageName: String, uiSettings: UISettings, metaLoc: String, gradlePaths: GradlePaths) {
        fileHandler.writeFile(filePath: path, contentText: KLColorSwatcher.fileContent(packageName: packageName, uiSettings: uiSettings), fileName: KLColorSwatcher.fileName)
        
        fileHandler.createMeta(ColorSwatcherMeta.self, metaLoc: metaLoc, category: .app_tools, appName: appName)
        fileHandler.createGradle(KLColorSwatcher.self, packageName: packageName, gradlePaths: gradlePaths)
    }
    
    func createDSWeapon(appName: String, path: String, packageName: String, uiSettings: UISettings, metaLoc: String, gradlePaths: GradlePaths) {
        fileHandler.writeFile(filePath: path, contentText: KLDSWeapon.fileContent(packageName: packageName, uiSettings: uiSettings), fileName: KLDSWeapon.fileName)
        fileHandler.createMeta(DarkSoulsWeaponMeta.self, metaLoc: metaLoc, category: .app_tools, appName: appName)
        fileHandler.createGradle(KLDSWeapon.self, packageName: packageName, gradlePaths: gradlePaths)
    }
    
    func createReactionTest(appName: String, path: String, packageName: String, uiSettings: UISettings, metaLoc: String, gradlePaths: GradlePaths) {
        fileHandler.writeFile(filePath: path, contentText: KLReactionTest.fileContent(packageName: packageName, uiSettings: uiSettings), fileName: KLReactionTest.fileName)
        fileHandler.createMeta(ReactionTestMeta.self, metaLoc: metaLoc, category: .game_arcade, appName: appName)
        fileHandler.createGradle(KLReactionTest.self, packageName: packageName, gradlePaths: gradlePaths)
    }
    
    func createSupernaturalQuotes(appName: String, path: String, packageName: String, uiSettings: UISettings, metaLoc: String, gradlePaths: GradlePaths) {
        fileHandler.writeFile(filePath: path, contentText: KLSupernaturalQuotes.fileContent(packageName: packageName, uiSettings: uiSettings), fileName: KLSupernaturalQuotes.fileName)
        fileHandler.createMeta(SupernaturalQuotesMeta.self, metaLoc: metaLoc, category: .app_tools, appName: appName)
        fileHandler.createGradle(KLSupernaturalQuotes.self, packageName: packageName, gradlePaths: gradlePaths)
    }
    
    func createTeaWiki(appName: String, path: String, packageName: String, uiSettings: UISettings, metaLoc: String, gradlePaths: GradlePaths) {
        fileHandler.writeFile(filePath: path, contentText: KLTeaWiki.fileContent(packageName: packageName, uiSettings: uiSettings), fileName: KLTeaWiki.fileName)
        fileHandler.createMeta(TeaWikiMeta.self, metaLoc: metaLoc, category: .app_tools, appName: appName)
        fileHandler.createGradle(KLTeaWiki.self, packageName: packageName, gradlePaths: gradlePaths)
    }
    
    func createWeatherApp(appName: String, path: String, packageName: String, uiSettings: UISettings, metaLoc: String, gradlePaths: GradlePaths, resPath: String, xmlPaths: XMLLayoutPaths) {
        fileHandler.writeFile(filePath: path, contentText: KLWeatherApp.fileContent(packageName: packageName, uiSettings: uiSettings), fileName: KLWeatherApp.fileName)
        fileHandler.writeFile(filePath: path, contentText: KLWeatherApp.cmfHandler(packageName).content, fileName: KLWeatherApp.cmfHandler(packageName).fileName)
        fileHandler.writeFile(filePath: resPath, contentText: KLWeatherAppRes.content, fileName: KLWeatherAppRes.name)
        fileHandler.checkDirectory(atPath: xmlPaths.layoutPath)
        let layouts = KLWeatherApp.layout(uiSettings)
        layouts.forEach { layout in
            fileHandler.writeFile(filePath: xmlPaths.layoutPath, contentText: layout.content, fileName: layout.name)
        }
        fileHandler.writeFile(filePath: xmlPaths.valuesPath, contentText: KLWeatherApp.dimens(uiSettings).content, fileName: KLWeatherApp.dimens(uiSettings).name)
        fileHandler.writeFile(filePath: xmlPaths.valuesPath, contentText: KLWeatherApp.styles().content, fileName: KLWeatherApp.styles().name)
        fileHandler.createMeta(WeatherAppMeta.self, metaLoc: metaLoc, category: .app_tools, appName: appName)
        fileHandler.createGradle(KLWeatherApp.self, packageName: packageName, gradlePaths: gradlePaths, useDeps: false)
        
    }
    
    func createBodyTypeCalculator(appName: String, path: String, packageName: String, uiSettings: UISettings, metaLoc: String, gradlePaths: GradlePaths, xmlPaths: XMLLayoutPaths) {
        fileHandler.writeFile(filePath: path, contentText: KLBodyTypeCalculator.fileContent(packageName: packageName, uiSettings: uiSettings), fileName: KLBodyTypeCalculator.fileName)
        fileHandler.checkDirectory(atPath: xmlPaths.fontPath)
        fileHandler.copyPaste(from: "\(LocalConst.homeDir)GeneratorProjects/resources/font/montserrat_light.ttf", to: xmlPaths.fontPath + "montserrat_light.ttf")
        fileHandler.copyPaste(from: "\(LocalConst.homeDir)GeneratorProjects/resources/font/montserrat_medium.ttf", to: xmlPaths.fontPath + "montserrat_medium.ttf")
        fileHandler.copyPaste(from: "\(LocalConst.homeDir)GeneratorProjects/resources/font/montserrat_regular.ttf", to: xmlPaths.fontPath + "montserrat_regular.ttf")
        fileHandler.copyPaste(from: "\(LocalConst.homeDir)GeneratorProjects/resources/font/montserrat_semibold.ttf", to: xmlPaths.fontPath + "montserrat_semibold.ttf")
        
        fileHandler.createMeta(BodyTypeCalculatorMeta.self, metaLoc: metaLoc, category: .app_tools, appName: appName)
        fileHandler.createGradle(KLBodyTypeCalculator.self, packageName: packageName, gradlePaths: gradlePaths)
    }
    
    func createHiddenParis(appName: String, path: String, packageName: String, uiSettings: UISettings, metaLoc: String, gradlePaths: GradlePaths, xmlPaths: XMLLayoutPaths) {
        fileHandler.writeFile(filePath: path, contentText: KLHiddenParis.fileContent(packageName: packageName, uiSettings: uiSettings), fileName: KLHiddenParis.fileName)
        fileHandler.checkDirectory(atPath: xmlPaths.fontPath)
        fileHandler.copyPaste(from: "\(LocalConst.homeDir)GeneratorProjects/resources/font/montserrat_light.ttf", to: xmlPaths.fontPath + "montserrat_light.ttf")
        fileHandler.copyPaste(from: "\(LocalConst.homeDir)GeneratorProjects/resources/font/montserrat_medium.ttf", to: xmlPaths.fontPath + "montserrat_medium.ttf")
        fileHandler.copyPaste(from: "\(LocalConst.homeDir)GeneratorProjects/resources/font/montserrat_regular.ttf", to: xmlPaths.fontPath + "montserrat_regular.ttf")
        fileHandler.copyPaste(from: "\(LocalConst.homeDir)GeneratorProjects/resources/font/montserrat_semibold.ttf", to: xmlPaths.fontPath + "montserrat_semibold.ttf")
        
        fileHandler.createMeta(HiddenParisMeta.self, metaLoc: metaLoc, category: .game_arcade, appName: appName)
        fileHandler.createGradle(KLHiddenParis.self, packageName: packageName, gradlePaths: gradlePaths)
        
        
    }
    
    func createBubblePicker(appName: String, path: String, packageName: String, uiSettings: UISettings, metaLoc: String, gradlePaths: GradlePaths) {
        fileHandler.writeFile(filePath: path, contentText: KLBubblePicker.fileContent(packageName: packageName, uiSettings: uiSettings), fileName: KLBubblePicker.fileName)
        
        fileHandler.createMeta(BubblePickerMeta.self, metaLoc: metaLoc, category: .game_arcade, appName: appName)
        fileHandler.createGradle(KLBubblePicker.self, packageName: packageName, gradlePaths: gradlePaths)
    }
    
    func createMoodTracker(appName: String, path: String, packageName: String, uiSettings: UISettings, metaLoc: String, gradlePaths: GradlePaths, xmlPaths: XMLLayoutPaths, resPath: String) {
        fileHandler.writeFile(filePath: path, contentText: KLMoodTracker.fileContent(packageName: packageName, uiSettings: uiSettings), fileName: KLMoodTracker.fileName)
        fileHandler.checkDirectory(atPath: xmlPaths.fontPath)
        fileHandler.copyPaste(from: "\(LocalConst.homeDir)GeneratorProjects/resources/font/montserrat_light.ttf", to: xmlPaths.fontPath + "montserrat_light.ttf")
        fileHandler.copyPaste(from: "\(LocalConst.homeDir)GeneratorProjects/resources/font/montserrat_medium.ttf", to: xmlPaths.fontPath + "montserrat_medium.ttf")
        fileHandler.copyPaste(from: "\(LocalConst.homeDir)GeneratorProjects/resources/font/montserrat_regular.ttf", to: xmlPaths.fontPath + "montserrat_regular.ttf")
        fileHandler.copyPaste(from: "\(LocalConst.homeDir)GeneratorProjects/resources/font/montserrat_semibold.ttf", to: xmlPaths.fontPath + "montserrat_semibold.ttf")
        
        fileHandler.writeFile(filePath: resPath, contentText: KLMoodTrackerRes.happyFace.content, fileName: KLMoodTrackerRes.happyFace.name)
        fileHandler.writeFile(filePath: resPath, contentText: KLMoodTrackerRes.neutalFace.content, fileName: KLMoodTrackerRes.neutalFace.name)
        fileHandler.writeFile(filePath: resPath, contentText: KLMoodTrackerRes.sadFace.content, fileName: KLMoodTrackerRes.sadFace.name)
        fileHandler.writeFile(filePath: resPath, contentText: KLMoodTrackerRes.smileFace.content, fileName: KLMoodTrackerRes.smileFace.name)
        
        fileHandler.createMeta(MoodTrackerMeta.self, metaLoc: metaLoc, category: .app_tools, appName: appName)
        fileHandler.createGradle(KLMoodTracker.self, packageName: packageName, gradlePaths: gradlePaths)
    }
    
    func createDotCrossGame(appName: String, path: String, packageName: String, uiSettings: UISettings, metaLoc: String, gradlePaths: GradlePaths) {
        fileHandler.writeFile(filePath: path, contentText: KLDotCrossGame.fileContent(packageName: packageName, uiSettings: uiSettings), fileName: KLDotCrossGame.fileName)
        fileHandler.createMeta(DotCrossGameMeta.self, metaLoc: metaLoc, category: .game_puzzle, appName: appName)
        fileHandler.createGradle(KLDotCrossGame.self, packageName: packageName, gradlePaths: gradlePaths)
    }
}
