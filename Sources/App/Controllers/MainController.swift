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
        fileHandler.writeFile(filePath: path, contentText: BuildGradleProject.fileContent(), fileName: "build.gradle")
        fileHandler.copyPaste(from: LocalConst.gradlewDir, to: path + "gradlew")
    }
    
    func createGradle(path: String, gradleWrapper: String) {
        fileHandler.writeFile(filePath: path, contentText: GradleWrapperProperties.fileContent(gradleWrapper: gradleWrapper), fileName: "gradle-wrapper.properties")
        fileHandler.copyPaste(from: LocalConst.gradleWrapper, to: path + "gradle-wrapper.jar")
    }
    
    func createBuildSrc(
        path: String,
        packageName: String,
        gradleVersion: String,
        compileSdk: String,
        minsdk: String,
        targetsdk: String,
        kotlin: String,
        kotlin_coroutines: String,
        hilt: String,
        hilt_viewmodel_compiler: String,
        ktx: String,
        lifecycle: String,
        fragment_ktx: String,
        appcompat: String,
        material: String,
        compose: String,
        compose_navigation: String,
        activity_compose: String,
        compose_hilt_nav: String,
        oneSignal: String,
        glide: String,
        swipe: String,
        glide_skydoves: String,
        retrofit: String,
        okhttp: String,
        room: String,
        coil: String,
        exp: String,
        calend: String,
        paging: String,
        accompanist: String
    ) {
        let src = "src/main/java/dependencies/"
        
        fileHandler.writeFile(filePath: path, contentText: BuildSrc.bSrcKts(), fileName: "build.gradle.kts")
        fileHandler.writeFile(filePath: path + src, contentText: BuildSrc.bSrcApplication(packageName: packageName), fileName: "Application.kt")
        fileHandler.writeFile(filePath: path + src, contentText: BuildSrc.bSrcBuild(), fileName: "Build.kt")
        fileHandler.writeFile(filePath: path + src, contentText: BuildSrc.bSrcDependencies(), fileName: "Dependencies.kt")
        fileHandler.writeFile(filePath: path + src, contentText: BuildSrc.bSrcVersions(
            gradleVersion: gradleVersion,
            compileSdk: compileSdk,
            minsdk: minsdk,
            targetsdk: targetsdk,
            kotlin: kotlin,
            kotlin_coroutines: kotlin_coroutines,
            hilt: hilt,
            hilt_viewmodel_compiler: hilt_viewmodel_compiler,
            ktx: ktx,
            lifecycle: lifecycle,
            fragment_ktx: fragment_ktx,
            appcompat: appcompat,
            material: material,
            compose: compose,
            compose_navigation: compose_navigation,
            activity_compose: activity_compose,
            compose_hilt_nav: compose_hilt_nav,
            oneSignal: oneSignal,
            glide: glide,
            swipe: swipe,
            glide_skydoves: glide_skydoves,
            retrofit: retrofit,
            okhttp: okhttp,
            room: room,
            coil: coil,
            exp: exp,
            calend: calend,
            paging: paging,
            accompanist: accompanist
        ), fileName: "Versions.kt")
    }
    
    func createRes(path: String, appName: String, color: String, appId: String) {
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
        fileHandler.writeFile(filePath: path + "res/values/", contentText: ResDefault.colorsText(), fileName: "colors.xml")
        fileHandler.writeFile(filePath: path + "res/values/", contentText: ResDefault.stringsText(name: appName, appId: appId), fileName: "strings.xml")
        fileHandler.writeFile(filePath: path + "res/values/", contentText: ResDefault.themesText(name: appName, color: color), fileName: "themes.xml")
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
        fileHandler.writeFile(filePath: path, contentText: BuildGradleApp.fileContent(appId: appId), fileName: "build.gradle")
        fileHandler.writeFile(filePath: path, contentText: ProguardRules.fileContent(), fileName: "proguard-rules.pro")
    }
    
    
    
    func createApp(path: String, packageName: String, applicationName: String, appId: String, commonPresentation: Bool = true) {
        let mainPath = path + "java/\(packageName.replacing(".", with: "/"))/"
        fileHandler.writeFile(filePath: mainPath + "application/", contentText: AndroidAppApplication.fileContent(packageName: packageName, applicationName: applicationName), fileName: applicationName + ".kt")
        
        if commonPresentation {
            fileHandler.writeFile(filePath: mainPath + "presentation/main_activity/", contentText: AndroidAppMainActivity.fileContent(packageName: packageName, appId: appId), fileName: "MainActivity.kt")
            fileHandler.writeFile(filePath: mainPath + "presentation/fragments/main_fragment/", contentText: AndroidAppMainFragment.fileContent(packageName: packageName, appId: appId), fileName: "MainFragment.kt")
            fileHandler.writeFile(filePath: mainPath + "repository/state/", contentText: AndroidAppFragmentState.fileContent(packageName: packageName), fileName: "FragmentState.kt")
            fileHandler.writeFile(filePath: mainPath + "repository/state/", contentText: AndroidAppStateViewModel.fileContent(packageName: packageName), fileName: "StateViewModel.kt")
        }
    }
    
    func createLogFile(path: String, token: String) {
        let content = """
\(Date().getStamp())
\(token)
\(getIfConfigOutput())
"""
        fileHandler.writeFile(filePath: path, contentText: content, fileName: "Log.txt")
    }
}
