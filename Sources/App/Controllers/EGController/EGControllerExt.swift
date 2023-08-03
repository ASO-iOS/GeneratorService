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
        fileHandler.writeFile(filePath: valuesPath, contentText: EGStopwatch.dimens().content, fileName: EGStopwatch.dimens().name)
        
        fileHandler.createGradle(EGStopwatch.self, packageName: packageName, gradlePaths: gradlePaths)
        
    }
}
