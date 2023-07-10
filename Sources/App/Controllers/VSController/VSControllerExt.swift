//
//  File.swift
//  
//
//  Created by admin on 02.07.2023.
//

import Foundation

extension VSController {
    func createStopwatch(
        appName: String,
        path: String,
        packageName: String,
        uiSettings: UISettings,
        metaLoc: String
    ) {
        fileHandler.writeFile(filePath: path, contentText: VSStopwatch.fileContent(packageName: packageName, uiSettings: uiSettings), fileName: VSStopwatch.fileName)
//        fileHandler.writeFile(filePath: metaLoc, contentText: <#T##String#>, fileName: "Meta.txt")
    }
    
    func createTorch(
        appName: String,
        path: String,
        resPath: String,
        packageName: String,
        uiSettings: UISettings,
        metaLoc: String
    ) {
        fileHandler.writeFile(filePath: path, contentText: VSTorch.fileContent(
            packageName: packageName, uiSettings: uiSettings), fileName: VSTorch.fileName)
        fileHandler.writeFile(filePath: resPath, contentText: VSTorchXmlRes.onIconFileText(buttonColor: uiSettings.buttonColorPrimary ?? "FFFFFF"), fileName: VSTorchXmlRes.onIconFileName)
        fileHandler.writeFile(filePath: resPath, contentText: VSTorchXmlRes.off1FileText(backColor: uiSettings.backColorPrimary ?? "FFFFFF", buttonColor: uiSettings.buttonColorPrimary ?? "FFFFFF"), fileName: VSTorchXmlRes.off1FileName)
        fileHandler.writeFile(filePath: resPath, contentText: VSTorchXmlRes.off3FileText(backColor: uiSettings.backColorPrimary ?? "FFFFFF", buttonColor: uiSettings.buttonColorPrimary ?? "FFFFFF"), fileName: VSTorchXmlRes.off3FileName)
        fileHandler.writeFile(filePath: resPath, contentText: VSTorchXmlRes.on1FileText(backColor: uiSettings.backColorPrimary ?? "FFFFFF", buttonColor: uiSettings.buttonColorPrimary ?? "FFFFFF"), fileName: VSTorchXmlRes.on1FileName)
        fileHandler.writeFile(filePath: resPath, contentText: VSTorchXmlRes.on3FileText(backColor: uiSettings.backColorPrimary ?? "FFFFFF", buttonColor: uiSettings.buttonColorPrimary ?? "FFFFFF"), fileName: VSTorchXmlRes.on3FileName)
        fileHandler.writeFile(filePath: metaLoc, contentText: MetaHandler.fileContent(appName: appName, short: TorchMeta.getShortDesc(), full: TorchMeta.getFullDesc(), category: AppCategory.app_tools.rawValue), fileName: MetaHandler.fileName)
    }
    
    func createPhoneInfo(
        appName: String,
        path: String,
        resPath: String,
        packageName: String,
        uiSettings: UISettings,
        metaLoc: String
    ) {
        fileHandler.writeFile(filePath: path, contentText: VSPhoneInfo.fileContent(packageName: packageName, uiSettings: uiSettings), fileName: VSPhoneInfo.fileName)
        fileHandler.writeFile(filePath: resPath, contentText: VSPhoneInfoRes.nothingFoundText(color: uiSettings.onSurfaceColor ?? "FFFFFF"), fileName: VSPhoneInfoRes.nothingFoundName)
        fileHandler.writeFile(filePath: resPath, contentText: VSPhoneInfoRes.imgPhoneText(color: uiSettings.onSurfaceColor ?? "FFFFFF"), fileName: VSPhoneInfoRes.imgPhoneName)
//        fileHandler.writeFile(filePath: metaLoc, contentText: <#T##String#>, fileName: "Meta.txt")
    }
}
