//
//  File.swift
//  
//
//  Created by admin on 02.07.2023.
//

import Foundation

extension VSController {
    func createStopwatch(
        appName: String,
        path: String,
        packageName: String,
        uiSettings: UISettings,
        metaLoc: String,
        gradlePaths: GradlePaths
    ) {
        fileHandler.writeFile(filePath: path, contentText: VSStopwatch.fileContent(packageName: packageName, uiSettings: uiSettings), fileName: VSStopwatch.fileName)
        fileHandler.writeFile(filePath: metaLoc, contentText: MetaHandler.fileContent(appName: appName, short: StopwatchMeta.getShortDesc(appName: appName), full: StopwatchMeta.getFullDesc(appName: appName), category: AppCategory.app_tools.rawValue), fileName: MetaHandler.fileName)
        
        fileHandler.writeFile(filePath: gradlePaths.projectGradlePath, contentText: VSStopwatch.gradle(packageName).projectBuildGradle.content, fileName: VSStopwatch.gradle(packageName).projectBuildGradle.name)
        fileHandler.writeFile(filePath: gradlePaths.moduleGradlePath, contentText: VSStopwatch.gradle(packageName).moduleBuildGradle.content, fileName: VSStopwatch.gradle(packageName).moduleBuildGradle.name)
        fileHandler.writeFile(filePath: gradlePaths.dependenciesPath, contentText: VSStopwatch.gradle(packageName).dependencies.content, fileName: VSStopwatch.gradle(packageName).dependencies.name)
    }
    
    func createTorch(
        appName: String,
        path: String,
        resPath: String,
        packageName: String,
        uiSettings: UISettings,
        metaLoc: String,
        gradlePaths: GradlePaths
    ) {
        fileHandler.writeFile(filePath: path, contentText: VSTorch.fileContent(
            packageName: packageName, uiSettings: uiSettings), fileName: VSTorch.fileName)
        fileHandler.writeFile(filePath: resPath, contentText: VSTorchXmlRes.onIconFileText(), fileName: VSTorchXmlRes.onIconFileName)
        fileHandler.writeFile(filePath: resPath, contentText: VSTorchXmlRes.off1FileText(), fileName: VSTorchXmlRes.off1FileName)
        fileHandler.writeFile(filePath: resPath, contentText: VSTorchXmlRes.off3FileText(), fileName: VSTorchXmlRes.off3FileName)
        fileHandler.writeFile(filePath: resPath, contentText: VSTorchXmlRes.on1FileText(), fileName: VSTorchXmlRes.on1FileName)
        fileHandler.writeFile(filePath: resPath, contentText: VSTorchXmlRes.on3FileText(), fileName: VSTorchXmlRes.on3FileName)
        fileHandler.writeFile(filePath: metaLoc, contentText: MetaHandler.fileContent(appName: appName, short: TorchMeta.getShortDesc(appName: appName), full: TorchMeta.getFullDesc(appName: appName), category: AppCategory.app_tools.rawValue), fileName: MetaHandler.fileName)
        
        fileHandler.writeFile(filePath: gradlePaths.projectGradlePath, contentText: VSTorch.gradle(packageName).projectBuildGradle.content, fileName: VSTorch.gradle(packageName).projectBuildGradle.name)
        fileHandler.writeFile(filePath: gradlePaths.moduleGradlePath, contentText: VSTorch.gradle(packageName).moduleBuildGradle.content, fileName: VSTorch.gradle(packageName).moduleBuildGradle.name)
        fileHandler.writeFile(filePath: gradlePaths.dependenciesPath, contentText: VSTorch.gradle(packageName).dependencies.content, fileName: VSTorch.gradle(packageName).dependencies.name)
    }
    
    func createPhoneInfo(
        appName: String,
        path: String,
        resPath: String,
        packageName: String,
        uiSettings: UISettings,
        metaLoc: String,
        gradlePaths: GradlePaths
    ) {
        fileHandler.writeFile(filePath: path, contentText: VSPhoneInfo.fileContent(packageName: packageName, uiSettings: uiSettings), fileName: VSPhoneInfo.fileName)
        fileHandler.writeFile(filePath: resPath, contentText: VSPhoneInfoRes.nothingFoundText(), fileName: VSPhoneInfoRes.nothingFoundName)
        fileHandler.writeFile(filePath: resPath, contentText: VSPhoneInfoRes.imgPhoneText(), fileName: VSPhoneInfoRes.imgPhoneName)
        fileHandler.writeFile(filePath: metaLoc, contentText: MetaHandler.fileContent(appName: appName, short: PhoneInfoMeta.getShortDesc(appName: appName), full: PhoneInfoMeta.getFullDesc(appName: appName), category: AppCategory.app_tools.rawValue), fileName: MetaHandler.fileName)
        
        fileHandler.writeFile(filePath: gradlePaths.projectGradlePath, contentText: VSPhoneInfo.gradle(packageName).projectBuildGradle.content, fileName: VSPhoneInfo.gradle(packageName).projectBuildGradle.name)
        fileHandler.writeFile(filePath: gradlePaths.moduleGradlePath, contentText: VSPhoneInfo.gradle(packageName).moduleBuildGradle.content, fileName: VSPhoneInfo.gradle(packageName).moduleBuildGradle.name)
        fileHandler.writeFile(filePath: gradlePaths.dependenciesPath, contentText: VSPhoneInfo.gradle(packageName).dependencies.content, fileName: VSPhoneInfo.gradle(packageName).dependencies.name)
    }
}
