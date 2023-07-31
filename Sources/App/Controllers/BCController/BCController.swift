//
//  File.swift
//  
//
//  Created by admin on 31.07.2023.
//

import SwiftUI

struct BCController {
    @ObservedObject var fileHandler: FileHandler
    
    func boot(id: String, appName: String, path: String, resPath: String, packageName: String, uiSettings: UISettings, metaLoc: String, designLocation: MetaDesignLocation?, gradlePaths: GradlePaths, applicationName: String) {
        switch id {
        case AppIDs.BC_NAME_GENERATOR:
            createNameGenerator(appName: appName, path: path, packageName: packageName, uiSettings: uiSettings, metaLoc: metaLoc, gradlePaths: gradlePaths, applicationName: applicationName)
        default:
            return
        }
    }
}
