//
//  File.swift
//  
//
//  Created by admin on 31.10.2023.
//

import SwiftUI

struct KDController {
    @ObservedObject var fileHandler: FileHandler
    
    func boot(id: String, appName: String, path: String, resPath: String, packageName: String, uiSettings: UISettings, metaLoc: String, gradlePaths: GradlePaths, xmlPaths: XMLLayoutPaths) {
        switch id {
        case AppIDs.KD_GALLERY:
            createGallery(appName: appName, path: path, xmlPaths: xmlPaths, packageName: packageName, uiSettings: uiSettings, metaLoc: metaLoc, gradlePaths: gradlePaths)
        case AppIDs.KD_NAME_GENERATOR:
            createNamesGennerator(appName: appName, path: path, xmlPaths: xmlPaths, packageName: packageName, uiSettings: uiSettings, metaLoc: metaLoc, gradlePaths: gradlePaths, resPath: resPath)
        case AppIDs.KD_NEWS:
            createNews(appName: appName, path: path, xmlPaths: xmlPaths, packageName: packageName, uiSettings: uiSettings, metaLoc: metaLoc, gradlePaths: gradlePaths)
        case AppIDs.KD_FIND_UNIVERSITY:
            createFindUniversity(appName: appName, path: path, packageName: packageName, uiSettings: uiSettings, metaLoc: metaLoc, gradlePaths: gradlePaths)
        default:
            print("ATTENTION\nid \(id) not found\nproject would not be created")
            return
        }
    }
}

