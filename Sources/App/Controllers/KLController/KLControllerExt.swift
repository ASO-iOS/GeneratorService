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
        
        // MARK: - todo meta
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
}
