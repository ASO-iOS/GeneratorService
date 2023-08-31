//
//  File.swift
//  
//
//  Created by admin on 8/31/23.
//

import SwiftUI

struct DTController {
    @ObservedObject var fileHandler: FileHandler
    
    func boot(id: String, appName: String, path: String, resPath: String, packageName: String, uiSettings: UISettings, metaLoc: String, gradlePaths: GradlePaths, xmlPaths: XMLLayoutPaths, mainData: MainData) {
        switch id {
        case AppIDs.DT_NUMBER_FACTS:
            createNumbersFacts(appName: appName, path: path, packageName: packageName, uiSettings: uiSettings, metaLoc: metaLoc, gradlePaths: gradlePaths, resPath: resPath, mainData: mainData)
            
        default:
            return
        }
        
    }
}
