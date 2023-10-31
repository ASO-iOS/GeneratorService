//
//  File.swift
//  
//
//  Created by admin on 31.10.2023.
//

import Foundation

extension KDController {
    func createGallery(appName: String, path: String, packageName: String, uiSettings: UISettings, metaLoc: String, gradlePaths: GradlePaths) {
        fileHandler.writeFile(filePath: path, contentText: KDGallery.fileContent(packageName: packageName, uiSettings: uiSettings), fileName: KDGallery.fileName)
        fileHandler.createGradle(KDGallery.self, packageName: packageName, gradlePaths: gradlePaths)
        fileHandler.createMeta(RandomPhotosMeta.self, metaLoc: metaLoc, category: .app_entertainment, appName: appName)
    }
}
