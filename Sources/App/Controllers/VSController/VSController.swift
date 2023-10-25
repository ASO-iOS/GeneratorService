//
//  File.swift
//  
//
//  Created by admin on 06.06.2023.
//

import SwiftUI

struct VSController {
    @ObservedObject var fileHandler: FileHandler
    
    func boot(id: String, appName: String, path: String, resPath: String, packageName: String, uiSettings: UISettings, metaLoc: String, designLocation: MetaDesignLocation?, gradlePaths: GradlePaths) {
        switch id {
        case AppIDs.VS_STOPWATCH_ID:
            createStopwatch(appName: appName, path: path, packageName: packageName, uiSettings: uiSettings, metaLoc: metaLoc, gradlePaths: gradlePaths)
        case AppIDs.VS_TORCH_ID:
            createTorch(appName: appName, path: path, resPath: resPath, packageName: packageName, uiSettings: uiSettings, metaLoc: metaLoc, gradlePaths: gradlePaths)
        case AppIDs.VS_PHONE_INFO_ID:
            createPhoneInfo(appName: appName, path: path, resPath: resPath, packageName: packageName, uiSettings: uiSettings, metaLoc: metaLoc, gradlePaths: gradlePaths)
        default:
            print("ATTENTION\nid \(id) not found\nproject would not be created")
            return
        }
        if designLocation != nil {
            do {
                try FileManager.default.createDirectory(at: URL.init(filePath: metaLoc + "assets/"), withIntermediateDirectories: false)
            } catch {
                print(error)
            }
            fileHandler.copyPaste(from: designLocation!.iconLocation, to: metaLoc + "assets/icon.png")
            fileHandler.copyPaste(from: designLocation!.bannerLocation, to: metaLoc + "assets/banner.png")
            fileHandler.copyPaste(from: designLocation!.screen1Location, to: metaLoc + "assets/screen1.png")
            fileHandler.copyPaste(from: designLocation!.screen2Location, to: metaLoc + "assets/screen2.png")
            fileHandler.copyPaste(from: designLocation!.screen3Location, to: metaLoc + "assets/screen3.png")
        }
    }
}
