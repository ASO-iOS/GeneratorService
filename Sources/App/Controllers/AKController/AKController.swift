//
//  File.swift
//  
//
//  Created by admin on 09.08.2023.
//

import SwiftUI

struct AKController {
    @ObservedObject var fileHandler: FileHandler
    
    func boot(id: String, appName: String, path: String, resPath: String, packageName: String, uiSettings: UISettings, metaLoc: String, gradlePaths: GradlePaths, xmlPaths: XMLLayoutPaths) {
        switch id {
        case AppIDs.AK_RICK_AND_MORTY:
            createRickAndMorty(appName: appName, path: path, resPath: resPath, xmlPaths: xmlPaths, packageName: packageName, uiSettings: uiSettings, metaLoc: metaLoc, gradlePaths: gradlePaths)
        case AppIDs.AK_SHASHLICK_CALCULATOR:
            createShashlikCalculator(appName: appName, path: path, resPath: resPath, packageName: packageName, uiSettings: uiSettings, metaLoc: metaLoc, gradlePaths: gradlePaths)
        case AppIDs.AK_ALARM:
            createAlarm(appName: appName, path: path, resPath: resPath, packageName: packageName, uiSettings: uiSettings, metaLoc: metaLoc, gradlePaths: gradlePaths)
        case AppIDs.AK_TODO:
            createToDo(appName: appName, path: path, resPath: resPath, packageName: packageName, uiSettings: uiSettings, metaLoc: metaLoc, gradlePaths: gradlePaths)
        case AppIDs.AK_BOILING_EGG:
            createBoilingEgg(appName: appName, path: path, resPath: resPath, xmlPaths: xmlPaths, packageName: packageName, uiSettings: uiSettings, metaLoc: metaLoc, gradlePaths: gradlePaths)
        case AppIDs.AK_COLOR_CONVERTER:
            createColorConverter(appName: appName, path: path, resPath: resPath, xmlPaths: xmlPaths, packageName: packageName, uiSettings: uiSettings, metaLoc: metaLoc, gradlePaths: gradlePaths)
        default:
            return
        }
    }
}

