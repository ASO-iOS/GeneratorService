//
//  File.swift
//  
//
//  Created by admin on 03.08.2023.
//

import SwiftUI

struct EGController {
    @ObservedObject var fileHandler: FileHandler
    func boot(id: String, appName: String, path: String, resPath: String, layoutPath: String, valuesPath: String, packageName: String, uiSettings: UISettings, metaLoc: String, designLocation: MetaDesignLocation?, gradlePaths: GradlePaths, xmlPaths: XMLLayoutPaths) {
        switch id {
        case AppIDs.EG_STOPWATCH:
            createStopwatch(appName: appName, path: path, layoutPath: layoutPath, valuesPath: valuesPath, packageName: packageName, uiSettings: uiSettings, metaLoc: metaLoc, gradlePaths: gradlePaths)
        case AppIDs.EG_RACE:
            createRace(appName: appName, path: path, xmlPaths: xmlPaths, packageName: packageName, uiSettings: uiSettings, metaLoc: metaLoc, gradlePaths: gradlePaths)
        case AppIDs.EG_LUCKY_NUMBER:
            createLuckyNumber(appName: appName, path: path, xmlPaths: xmlPaths, packageName: packageName, uiSettings: uiSettings, metaLoc: metaLoc, gradlePaths: gradlePaths)
        default:
            return
        }
    }
}

struct XMLLayoutPaths {
    let valuesPath: String
    let animPath: String
    let layoutPath: String
}
