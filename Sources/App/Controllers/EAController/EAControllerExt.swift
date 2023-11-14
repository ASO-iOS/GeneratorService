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
}
