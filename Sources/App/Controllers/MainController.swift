//
//  File.swift
//  
//
//  Created by admin on 21.06.2023.
//

import SwiftUI

struct MainController {
    @ObservedObject var fileHandler: FileHandler
    
    init(fileHandler: FileHandler) {
        self.fileHandler = fileHandler
    }
    
    func createOuterFiles(path: String, appName: String) {
        fileHandler.writeFile(filePath: path, contentText: GradleSettings.gradleSettings(appName: appName), fileName: "settings.gradle")
        fileHandler.writeFile(filePath: path, contentText: LocalProperties.fileContent(homeDir: LocalConst.homeDir), fileName: "local.properties")
        fileHandler.writeFile(filePath: path, contentText: GradlewBat.fileContent(), fileName: "gradlew.bat")
        fileHandler.writeFile(filePath: path, contentText: GradleProperties.fileContent(), fileName: "gradle.properties")
        fileHandler.copyPaste(from: LocalConst.gradlewDir, to: path + "gradlew")
    }
    
    func createGradle(path: String, gradleWrapper: String) {
        fileHandler.writeFile(filePath: path, contentText: GradleWrapperProperties.fileContent(gradleWrapper: gradleWrapper), fileName: "gradle-wrapper.properties")
        fileHandler.copyPaste(from: LocalConst.gradleWrapper, to: path + "gradle-wrapper.jar")
    }
    
    func createBuildSrc(
        path: String
    ) {
        
        fileHandler.writeFile(filePath: path, contentText: BuildSrc.bSrcKts(), fileName: "build.gradle.kts")
    }
    
    func createRes(path: String, appName: String, color: String, appId: String, mainData: MainData) {
        do {
            if !FileManager.default.fileExists(atPath: path) {
                try FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true)
                try FileManager.default.copyItem(atPath: LocalConst.resDir, toPath: path + "res")
            } else {
                try FileManager.default.copyItem(atPath: LocalConst.resDir, toPath: path + "res")
            }
        } catch {
            print(error)
        }
        fileHandler.writeFile(filePath: path + "res/values/", contentText: ResDefault.colorsText(mainData: mainData), fileName: "colors.xml")
        fileHandler.writeFile(filePath: path + "res/values/", contentText: ResDefault.stringsText(name: appName, mainData: mainData), fileName: "strings.xml")
        fileHandler.writeFile(filePath: path + "res/values/", contentText: ResDefault.themesText(name: appName, color: color, mainData: mainData), fileName: "themes.xml")
    }
    
    func createManifest(
        path: String,
        packageName: String,
        applicationName: String,
        name: String,
        screenOrientation: ScreenOrientationEnum,
        appId: String
    ) {
        fileHandler.writeFile(filePath: path, contentText: Manifest.fileContent(appId: appId, applicationName: applicationName, name: name, screenOrientation: screenOrientation), fileName: Manifest.fileName)
    }
    
    func createAppGradle(
        path: String,
        appId: String
    ) {
        fileHandler.writeFile(filePath: path, contentText: ProguardRules.fileContent(), fileName: "proguard-rules.pro")
    }
    
    func createApp(path: String, packageName: String, applicationName: String, appId: String,  mainData: MainData, customMainFragment: Bool = false) {
        let mainPath = path + "java/\(packageName.replacing(".", with: "/"))/"
        fileHandler.writeFile(filePath: mainPath + "application/", contentText: AndroidAppApplication.fileContent(packageName: packageName, applicationName: applicationName, useContext: appId == AppIDs.BC_NAME_GENERATOR), fileName: applicationName + ".kt")
        if !cmfList().contains(appId) {
            fileHandler.writeFile(filePath: mainPath + "presentation/fragments/main_fragment/", contentText: AndroidAppMainFragment.fileContent(packageName: packageName, appId: appId, mainData: mainData), fileName: "MainFragment.kt")
        }
        fileHandler.writeFile(filePath: mainPath + "presentation/main_activity/", contentText: AndroidAppMainActivity.fileContent(packageName: packageName, appId: appId, mainData: mainData), fileName: "MainActivity.kt")
        
        fileHandler.writeFile(filePath: mainPath + "repository/state/", contentText: AndroidAppFragmentState.fileContent(mainData: mainData), fileName: "FragmentState.kt")
        fileHandler.writeFile(filePath: mainPath + "repository/state/", contentText: AndroidAppStateViewModel.fileContent(mainData: mainData), fileName: "StateViewModel.kt")
    }
    
    func createLogFile(path: String, token: String) {
        let content = """
\(Date().getStamp())
\(token)
\(getIfConfigOutput())
"""
        fileHandler.writeFile(filePath: path, contentText: content, fileName: "Log.txt")
    }
    
    func cmfList() -> [String] {
        return [
            AppIDs.IT_STOPWATCH,
            AppIDs.IT_DEVICE_INFO,
            AppIDs.EG_STOPWATCH,
            AppIDs.EG_RACE,
            AppIDs.EG_LUCKY_NUMBER,
            AppIDs.EG_PHONE_CHECKER,
            AppIDs.EG_DICE_ROLLER,
            AppIDs.EG_FLASHLIGHT,
            AppIDs.EG_LOVE_CALCULATOR,
            AppIDs.KL_BMI_CALCULATOR,
            AppIDs.KL_CONVERTER,
            AppIDs.KL_RECORDER,
            AppIDs.KL_SPEED_TEST
        ]
    }
}

struct GradlePaths {
    let projectGradlePath: String
    let moduleGradlePath: String
    let dependenciesPath: String
}
