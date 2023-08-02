//
//  File.swift
//  
//
//  Created by admin on 31.07.2023.
//

import Foundation

extension VEController {
    func createAircraft(appName: String, path: String, packageName: String, uiSettings: UISettings, metaLoc: String, gradlePaths: GradlePaths, assetsLocation: String) {
        fileHandler.writeFile(filePath: path, contentText: VETypesOfAircraft.fileContent(packageName: packageName, uiSettings: uiSettings), fileName: VETypesOfAircraft.fileName)
        do {
            if !FileManager.default.fileExists(atPath: assetsLocation) {
                try FileManager.default.createDirectory(atPath: assetsLocation, withIntermediateDirectories: true)
            }
        } catch {
            print(error)
        }

        fileHandler.writeFile(filePath: assetsLocation, contentText: VETypesOfAircraftAssets.content, fileName: VETypesOfAircraftAssets.name)
        
        fileHandler.writeFile(filePath: gradlePaths.projectGradlePath, contentText: VETypesOfAircraft.gradle(packageName).projectBuildGradle.content, fileName: VETypesOfAircraft.gradle(packageName).projectBuildGradle.name)
        fileHandler.writeFile(filePath: gradlePaths.moduleGradlePath, contentText: VETypesOfAircraft.gradle(packageName).moduleBuildGradle.content, fileName: VETypesOfAircraft.gradle(packageName).moduleBuildGradle.name)
        fileHandler.writeFile(filePath: gradlePaths.dependenciesPath, contentText: VETypesOfAircraft.gradle(packageName).dependencies.content, fileName: VETypesOfAircraft.gradle(packageName).dependencies.name)
    }
    
    func createAlarm(appName: String, path: String, resPath: String, packageName: String, uiSettings: UISettings, metaLoc: String, gradlePaths: GradlePaths) {
        fileHandler.writeFile(filePath: path, contentText: VEAlarm.fileContent(packageName: packageName, uiSettings: uiSettings), fileName: VEAlarm.fileName)
        fileHandler.writeFile(filePath: resPath, contentText: VEAlarmRes.alarmContent, fileName: VEAlarmRes.alarmName)
        fileHandler.writeFile(filePath: metaLoc, contentText: MetaHandler.fileContent(appName: appName, short: AlarmMeta.getShortDesc(appName: appName), full: AlarmMeta.getFullDesc(appName: appName), category: AppCategory.app_tools.rawValue), fileName: MetaHandler.fileName)
        
        fileHandler.writeFile(filePath: gradlePaths.projectGradlePath, contentText: VEAlarm.gradle(packageName).projectBuildGradle.content, fileName: VEAlarm.gradle(packageName).projectBuildGradle.name)
        fileHandler.writeFile(filePath: gradlePaths.moduleGradlePath, contentText: VEAlarm.gradle(packageName).moduleBuildGradle.content, fileName: VEAlarm.gradle(packageName).moduleBuildGradle.name)
        fileHandler.writeFile(filePath: gradlePaths.dependenciesPath, contentText: VEAlarm.gradle(packageName).dependencies.content, fileName: VEAlarm.gradle(packageName).dependencies.name)
    }
    
    func createQuizBooks(appName: String, path: String, resPath: String, packageName: String, uiSettings: UISettings, metaLoc: String, gradlePaths: GradlePaths) {
        fileHandler.writeFile(filePath: path, contentText: VEQuizBooks.fileContent(packageName: packageName, uiSettings: uiSettings), fileName: VEQuizBooks.fileName)
        fileHandler.writeFile(filePath: metaLoc, contentText: MetaHandler.fileContent(appName: appName, short: QuizMeta.getShortDesc(appName: appName), full: QuizMeta.getFullDesc(appName: appName), category: AppCategory.app_entertainment.rawValue), fileName: MetaHandler.fileName)
        fileHandler.writeFile(filePath: resPath, contentText: VEQuizBooksRes.content, fileName: VEQuizBooksRes.bookName)
        
        fileHandler.writeFile(filePath: gradlePaths.projectGradlePath, contentText: VEQuizBooks.gradle(packageName).projectBuildGradle.content, fileName: VEQuizBooks.gradle(packageName).projectBuildGradle.name)
        fileHandler.writeFile(filePath: gradlePaths.moduleGradlePath, contentText: VEQuizBooks.gradle(packageName).moduleBuildGradle.content, fileName: VEQuizBooks.gradle(packageName).moduleBuildGradle.name)
        fileHandler.writeFile(filePath: gradlePaths.dependenciesPath, contentText: VEQuizBooks.gradle(packageName).dependencies.content, fileName: VEQuizBooks.gradle(packageName).dependencies.name)
    }
    
    func createFacts(appName: String, path: String, resPath: String, packageName: String, uiSettings: UISettings, metaLoc: String, gradlePaths: GradlePaths) {
        fileHandler.writeFile(filePath: path, contentText: VEFacts.fileContent(packageName: packageName, uiSettings: uiSettings), fileName: VEFacts.fileName)
        fileHandler.writeFile(filePath: metaLoc, contentText: MetaHandler.fileContent(appName: appName, short: FactsMeta.getShortDesc(appName: appName), full: FactsMeta.getFullDesc(appName: appName), category: AppCategory.app_entertainment.rawValue), fileName: MetaHandler.fileName)
        fileHandler.writeFile(filePath: resPath, contentText: VEFactsRes.alarmContent, fileName: VEFactsRes.alarmName)
        
        fileHandler.createGradle(VEFacts.self, packageName: packageName, gradlePaths: gradlePaths)
//        fileHandler.writeFile(filePath: gradlePaths.projectGradlePath, contentText: VEFacts.gradle(packageName).projectBuildGradle.content, fileName: VEFacts.gradle(packageName).projectBuildGradle.name)
//        fileHandler.writeFile(filePath: gradlePaths.moduleGradlePath, contentText: VEFacts.gradle(packageName).moduleBuildGradle.content, fileName: VEFacts.gradle(packageName).moduleBuildGradle.name)
//        fileHandler.writeFile(filePath: gradlePaths.dependenciesPath, contentText: VEFacts.gradle(packageName).dependencies.content, fileName: VEFacts.gradle(packageName).dependencies.name)
    }
    
    func createFindUniversity(appName: String, path: String, packageName: String, uiSettings: UISettings, metaLoc: String, gradlePaths: GradlePaths) {
        fileHandler.writeFile(filePath: path, contentText: VEFindUniversity.fileContent(packageName: packageName, uiSettings: uiSettings), fileName: VEFindUniversity.fileName)
        
        fileHandler.createGradle(VEFindUniversity.self, packageName: packageName, gradlePaths: gradlePaths)
    }
    
    func createPassGen(appName: String, path: String, packageName: String, uiSettings: UISettings, metaLoc: String, gradlePaths: GradlePaths) {
        fileHandler.writeFile(filePath: path, contentText: VEPassGen.fileContent(packageName: packageName, uiSettings: uiSettings), fileName: VEPassGen.fileName)
        fileHandler.writeFile(filePath: metaLoc, contentText: MetaHandler.fileContent(appName: appName, short: PassGeneratorMeta.getShortDesc(appName: appName), full: PassGeneratorMeta.getFullDesc(appName: appName), category: AppCategory.app_tools.rawValue), fileName: MetaHandler.fileName)
        fileHandler.createGradle(VEPassGen.self, packageName: packageName, gradlePaths: gradlePaths)
        
    }
}
