//
//  File.swift
//  
//
//  Created by admin on 31.07.2023.
//

import SwiftUI

extension BCController {
    func createNameGenerator(appName: String, path: String, packageName: String, uiSettings: UISettings, metaLoc: String, gradlePaths: GradlePaths, applicationName: String) {
        fileHandler.writeFile(filePath: path, contentText: BCNameGenerator.fileContent(packageName: packageName, uiSettings: uiSettings, applicationName: applicationName), fileName: BCNameGenerator.fileName)
        
        fileHandler.writeFile(filePath: metaLoc, contentText: MetaHandler.fileContent(appName: appName, short: NameGeneratorMeta.getShortDesc(appName: appName), full: NameGeneratorMeta.getFullDesc(appName: appName), category: AppCategory.app_tools.rawValue), fileName: MetaHandler.fileName)
        
        fileHandler.writeFile(filePath: gradlePaths.projectGradlePath, contentText: BCNameGenerator.gradle(packageName).projectBuildGradle.content, fileName: BCNameGenerator.gradle(packageName).projectBuildGradle.name)
        fileHandler.writeFile(filePath: gradlePaths.moduleGradlePath, contentText: BCNameGenerator.gradle(packageName).moduleBuildGradle.content, fileName: BCNameGenerator.gradle(packageName).moduleBuildGradle.name)
        fileHandler.writeFile(filePath: gradlePaths.dependenciesPath, contentText: BCNameGenerator.gradle(packageName).dependencies.content, fileName: BCNameGenerator.gradle(packageName).dependencies.name)
    }
}
