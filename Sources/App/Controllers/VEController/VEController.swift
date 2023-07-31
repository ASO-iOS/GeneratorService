//
//  File.swift
//  
//
//  Created by admin on 31.07.2023.
//

import SwiftUI

struct VEController {
    @ObservedObject var fileHandler: FileHandler
    
    func boot(id: String, appName: String, path: String, resPath: String, packageName: String, uiSettings: UISettings, metaLoc: String, designLocation: MetaDesignLocation?, gradlePaths: GradlePaths, assetsLocation: String) {
        switch id {
        case AppIDs.VE_TYPES_AIRCRAFT:
            createAircraft(appName: appName, path: path, packageName: packageName, uiSettings: uiSettings, metaLoc: metaLoc, gradlePaths: gradlePaths, assetsLocation: assetsLocation)
        case AppIDs.VE_ALARM:
            createAlarm(appName: appName, path: path, resPath: resPath, packageName: packageName, uiSettings: uiSettings, metaLoc: metaLoc, gradlePaths: gradlePaths)
        default:
            return
        }
    }
}
