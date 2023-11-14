//
//  EAController.swift
//
//
//  Created by mnats on 13.11.2023.
//

import SwiftUI

struct EAController {
    @ObservedObject var fileHandler: FileHandler
    
    func boot(id: String, appName: String, path: String, resPath: String, packageName: String, uiSettings: UISettings, metaLoc: String, gradlePaths: GradlePaths, xmlPaths: XMLLayoutPaths, maPath: String, mainData: MainData) {
        switch id {
        case AppIDs.EA_REMINDER:
            createReminder(appName: appName, path: path, packageName: packageName, uiSettings: uiSettings, metaLoc: metaLoc, gradlePaths: gradlePaths)
        case AppIDs.EA_TIMER:
            createTimer(appName: appName, path: path, packageName: packageName, uiSettings: uiSettings, metaLoc: metaLoc, gradlePaths: gradlePaths)
        default:
            print("ATTENTION\nid \(id) not found\nproject would not be created")
            return
        }
    }
}
