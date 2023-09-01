//
//  File.swift
//  
//
//  Created by admin on 8/31/23.
//

import Foundation

extension DTController {
    func createNumbersFacts (appName: String, path: String, packageName: String, uiSettings: UISettings, metaLoc: String, gradlePaths: GradlePaths, resPath: String, mainData: MainData) {
        fileHandler.writeFile(filePath: path, contentText: DTNumberFacts.mainFragmentCMF(mainData).content, fileName: DTNumberFacts.mainFragmentCMF(mainData).fileName)
        
        fileHandler.createMeta(NumbersFactsMeta.self, metaLoc: metaLoc, category: .app_tools, appName: appName)
        fileHandler.createGradle(DTNumberFacts.self, packageName: packageName, gradlePaths: gradlePaths)
    }
    
}
