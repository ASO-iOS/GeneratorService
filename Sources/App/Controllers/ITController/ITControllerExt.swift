//
//  File.swift
//  
//
//  Created by admin on 31.07.2023.
//

import Foundation

extension ITController {
    func createQuickWriter(appName: String, path: String, resPath: String, packageName: String, uiSettings: UISettings, metaLoc: String, gradlePaths: GradlePaths) {
        fileHandler.writeFile(filePath: path, contentText: ITQuickWriter.fileContent(packageName: packageName, uiSettings: uiSettings), fileName: ITQuickWriter.fileName)
        fileHandler.writeFile(filePath: resPath, contentText: ITQuickWriterRes.noteIconContent(buttonTextColor: uiSettings.buttonColorPrimary ?? "FFFFFF"), fileName: ITQuickWriterRes.noteIconName)
        
        fileHandler.writeFile(filePath: metaLoc, contentText: MetaHandler.fileContent(appName: appName, short: NotesMeta.getShortDesc(appName: appName), full: NotesMeta.getFullDesc(appName: appName), category: AppCategory.app_tools.rawValue), fileName: MetaHandler.fileName)
        
        fileHandler.writeFile(filePath: gradlePaths.projectGradlePath, contentText: ITQuickWriter.gradle(packageName).projectBuildGradle.content, fileName: ITQuickWriter.gradle(packageName).projectBuildGradle.name)
        fileHandler.writeFile(filePath: gradlePaths.moduleGradlePath, contentText: ITQuickWriter.gradle(packageName).moduleBuildGradle.content, fileName: ITQuickWriter.gradle(packageName).moduleBuildGradle.name)
        fileHandler.writeFile(filePath: gradlePaths.dependenciesPath, contentText: ITQuickWriter.gradle(packageName).dependencies.content, fileName: ITQuickWriter.gradle(packageName).dependencies.name)
    }
}
