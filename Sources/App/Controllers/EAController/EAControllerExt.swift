//
//  EAControllerExt.swift
//
//
//  Created by mnats on 13.11.2023.
//

import Foundation

extension EAController {
    func createReminder(appName: String, path: String, packageName: String, uiSettings: UISettings, metaLoc: String, gradlePaths: GradlePaths) {
        fileHandler.writeFile(filePath: path, contentText: EAReminder.fileContent(packageName: packageName, uiSettings: uiSettings), fileName: EAReminder.fileName)
        fileHandler.createGradle(EAReminder.self, packageName: packageName, gradlePaths: gradlePaths)
        fileHandler.createMeta(ReminderMeta.self, metaLoc: metaLoc, category: .app_tools, appName: appName)
    }
    
    func createTimer(appName: String, path: String, packageName: String, uiSettings: UISettings, metaLoc: String, gradlePaths: GradlePaths) {
        fileHandler.writeFile(filePath: path, contentText: EATimer.fileContent(packageName: packageName, uiSettings: uiSettings), fileName: EATimer.fileName)
        fileHandler.createGradle(EATimer.self, packageName: packageName, gradlePaths: gradlePaths)
        fileHandler.createMeta(TimerMeta.self, metaLoc: metaLoc, category: .app_tools, appName: appName)
    }
    
    func createClock(appName: String, path: String, packageName: String, uiSettings: UISettings, metaLoc: String, gradlePaths: GradlePaths) {
        fileHandler.writeFile(filePath: path, contentText: EAClock.fileContent(packageName: packageName, uiSettings: uiSettings), fileName: EAClock.fileName)
        fileHandler.createGradle(EAClock.self, packageName: packageName, gradlePaths: gradlePaths)
        fileHandler.createMeta(ClockMeta.self, metaLoc: metaLoc, category: .app_tools, appName: appName)
    }
    
    func createPassgen(appName: String, path: String, packageName: String, uiSettings: UISettings, metaLoc: String, gradlePaths: GradlePaths) {
        fileHandler.writeFile(filePath: path, contentText: EAPassGen.fileContent(packageName: packageName, uiSettings: uiSettings), fileName: EAPassGen.fileName)
        fileHandler.createGradle(EAPassGen.self, packageName: packageName, gradlePaths: gradlePaths)
        fileHandler.createMeta(PassGeneratorMeta.self, metaLoc: metaLoc, category: .app_tools, appName: appName)
    }
    
    func createColorQuiz(appName: String, path: String, packageName: String, uiSettings: UISettings, metaLoc: String, gradlePaths: GradlePaths) {
        fileHandler.writeFile(filePath: path, contentText: EAColorQuiz.fileContent(packageName: packageName, uiSettings: uiSettings), fileName: EAColorQuiz.fileName)
        fileHandler.createGradle(EAColorQuiz.self, packageName: packageName, gradlePaths: gradlePaths)
        fileHandler.createMeta(ColorQuizMeta.self, metaLoc: metaLoc, category: .game_puzzle, appName: appName)
    }
    
    func createDeviceInfo(appName: String, path: String, packageName: String, uiSettings: UISettings, metaLoc: String, gradlePaths: GradlePaths) {
        fileHandler.writeFile(filePath: path, contentText: EADeviceInfo.fileContent(packageName: packageName, uiSettings: uiSettings), fileName: EADeviceInfo.fileName)
        fileHandler.createGradle(EADeviceInfo.self, packageName: packageName, gradlePaths: gradlePaths)
        fileHandler.createMeta(DeviceInfoMeta.self, metaLoc: metaLoc, category: .app_tools, appName: appName)
    }
    
    func createScramble(appName: String, path: String, packageName: String, uiSettings: UISettings, metaLoc: String, gradlePaths: GradlePaths) {
        fileHandler.writeFile(filePath: path, contentText: EAScramble.fileContent(packageName: packageName, uiSettings: uiSettings), fileName: EAScramble.fileName)
        fileHandler.createGradle(EAScramble.self, packageName: packageName, gradlePaths: gradlePaths)
        fileHandler.createMeta(ScrambleMeta.self, metaLoc: metaLoc, category: .app_tools, appName: appName)
    }
    
    func createPlanetarium(appName: String, path: String, packageName: String, uiSettings: UISettings, metaLoc: String, gradlePaths: GradlePaths) {
        fileHandler.writeFile(filePath: path, contentText: EAPlanetarium.fileContent(packageName: packageName, uiSettings: uiSettings), fileName: EAPlanetarium.fileName)
        fileHandler.createGradle(EAPlanetarium.self, packageName: packageName, gradlePaths: gradlePaths)
        fileHandler.createMeta(PlanetariumMeta.self, metaLoc: metaLoc, category: .app_tools, appName: appName)
    }
}
