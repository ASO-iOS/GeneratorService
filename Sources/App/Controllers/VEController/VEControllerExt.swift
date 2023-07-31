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
}
