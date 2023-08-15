//
//  File.swift
//  
//
//  Created by admin on 14.08.2023.
//

import SwiftUI

struct KLController {
    @ObservedObject var fileHandler: FileHandler
    
    func boot(id: String, appName: String, path: String, resPath: String, packageName: String, uiSettings: UISettings, metaLoc: String, gradlePaths: GradlePaths, xmlPaths: XMLLayoutPaths) {
        switch id {
        case AppIDs.KL_BMI_CALCULATOR:
            createBMICalculator(appName: appName, path: path, packageName: packageName, uiSettings: uiSettings, metaLoc: metaLoc, gradlePaths: gradlePaths, xmlPaths: xmlPaths)
        case AppIDs.KL_CONVERTER:
            createMetricsConverter(appName: appName, path: path, packageName: packageName, uiSettings: uiSettings, metaLoc: metaLoc, gradlePaths: gradlePaths, xmlPaths: xmlPaths)
        case AppIDs.KL_RECORDER:
            createRecorder(appName: appName, path: path, resPath: resPath, packageName: packageName, uiSettings: uiSettings, metaLoc: metaLoc, gradlePaths: gradlePaths, xmlPaths: xmlPaths)
        case AppIDs.KL_SPEED_TEST:
            createSpeedTest(appName: appName, path: path, packageName: packageName, uiSettings: uiSettings, metaLoc: metaLoc, gradlePaths: gradlePaths, xmlPaths: xmlPaths)
        case AppIDs.KL_CLICK_FASTER:
            createClicker(appName: appName, path: path, packageName: packageName, uiSettings: uiSettings, metaLoc: metaLoc, gradlePaths: gradlePaths)
        case AppIDs.KL_COLOR_SWATCHER:
            createColorSwatcher(appName: appName, path: path, packageName: packageName, uiSettings: uiSettings, metaLoc: metaLoc, gradlePaths: gradlePaths)
        case AppIDs.KL_DS_WEAPON:
            createDSWeapon(appName: appName, path: path, packageName: packageName, uiSettings: uiSettings, metaLoc: metaLoc, gradlePaths: gradlePaths)
        case AppIDs.KL_REACTION_TEST:
            createReactionTest(appName: appName, path: path, packageName: packageName, uiSettings: uiSettings, metaLoc: metaLoc, gradlePaths: gradlePaths)
        default:
            return
        }
    }
}
