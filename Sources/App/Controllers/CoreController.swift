//
//  File.swift
//  
//
//  Created by admin on 01.06.2023.
//

import SwiftUI
import Vapor

struct CoreController: RouteCollection {
    
    @ObservedObject var fileHandler: FileHandler
    let mainController: MainController
    
    init(fileHandler: FileHandler) {
        self.fileHandler = fileHandler
        self.mainController = MainController(fileHandler: fileHandler)
    }
    
    func boot(routes: Vapor.RoutesBuilder) throws {
        routes.on(.GET, PathComponent(stringLiteral: RouteConst.EMPTY_CORE_PROJECT), use: launch)
    }
    
    /// -  главный метод создания проекта
    func launch(_ request: Request) throws -> Response {
        
        // MARK: - инициализация локации файла, изнвчально пустой проект
        var fileLoc = "\(LocalConst.homeDir)GeneratorProjects/resources/empty.zip"
        
        let timeStamp = Date().getStamp()
        let token = try? request.query.get(String.self, at: EndRoutes.END_TOKEN)
        guard let bodyByteBuffer = request.body.data else { throw Abort(.badRequest) }
        let bodyData = Data(buffer: bodyByteBuffer)
        let body = try JSONDecoder().decode(RequestDto.self, from: bodyData)
        
        if UserToken.checkToken(token) {
                create(token: token ?? "error", body: body, stamp: timeStamp, completion: {
                    fileLoc = "\(FileManager.default.homeDirectoryForCurrentUser.absoluteString.replacing("file://", with: ""))GeneratorProjects/temp/\(timeStamp)/\(body.appName).zip"
                })
            return request.fileio.streamFile(at: fileLoc)
        } else {
            return request.redirect(to: LocalConst.dickButt)
        }
    }
    
}

extension CoreController {
    
    func create(
        token: String,
        body: RequestDto,
        stamp: String,
        completion: @escaping () -> Void
    ) {
        DispatchQueue.global(qos: .default).sync {
            let tempLoc = LocalConst.tempDir + stamp + "/" + body.appName + "/"
            
            mainController.createOuterFiles(path: tempLoc, appName: body.appName)
                mainController.createGradle(path: tempLoc + "gradle/wrapper/", gradleWrapper: body.gradleWrapper ?? LibVersions.gradleWrapperVersion)
            mainController.createBuildSrc(
                path: tempLoc + "buildSrc/",
                packageName: body.packageName,
                gradleVersion: body.gradleVersion ?? LibVersions.gradleVersion,
                compileSdk: body.compileSdk ?? LibVersions.compileSdk,
                minsdk: body.minSdk ?? LibVersions.minsdk,
                targetsdk: body.targetSdk ?? LibVersions.targetsdk,
                kotlin: body.kotlin ?? LibVersions.kotlin,
                kotlin_coroutines: body.kotlinCoroutines ?? LibVersions.kotlin_coroutines,
                hilt: body.hilt ?? LibVersions.hilt,
                hilt_viewmodel_compiler: body.hiltViewmodelCompiler ?? LibVersions.hilt_viewmodel_compiler,
                ktx: body.ktx ?? LibVersions.ktx,
                lifecycle: body.lifecycle ?? LibVersions.lifecycle,
                fragment_ktx: body.fragmentKtx ?? LibVersions.fragment_ktx,
                appcompat: body.appcompat ?? LibVersions.appcompat,
                material: body.material ?? LibVersions.material,
                compose: body.compose ?? LibVersions.compose,
                compose_navigation: body.composeNavigation ?? LibVersions.compose_navigation,
                activity_compose: body.activityCompose ?? LibVersions.activity_compose,
                compose_hilt_nav: body.composeHiltNav ?? LibVersions.compose_hilt_nav,
                oneSignal: body.oneSignal ?? LibVersions.oneSignal,
                glide: body.glide ?? LibVersions.glide,
                swipe: body.swipe ?? LibVersions.swipe,
                glide_skydoves: body.glideSkydoves ?? LibVersions.glide_skydoves,
                retrofit: body.retrofit ?? LibVersions.retrofit,
                okhttp: body.okhttp ?? LibVersions.okhttp,
                room: body.room ?? LibVersions.room,
                coil: body.coil ?? LibVersions.coil,
                exp: body.exp ?? LibVersions.exp,
                calend: body.calend ?? LibVersions.calend,
                paging: body.paging ?? LibVersions.paging,
                accompanist: body.accompanist ?? LibVersions.accompanist
            )
            mainController.createRes(
                path: tempLoc + "app/src/main/",
                appName: body.appName,
                color: body.appBarColor ?? "ffffff",
                appId: body.appId ?? ""
            )
            mainController.createManifest(
                path: tempLoc + "app/src/main/",
                packageName: body.packageName,
                applicationName: body.applicationName,
                name: body.appName,
                screenOrientation: ScreenOrientationEnum.getOrientationFromString(body.screenOrientation ?? ScreenOrientationEnum.portrait.name),
                appId: body.appId ?? ""
            )
            mainController.createAppGradle(
                path: tempLoc + "app/",
                appId: body.appId ?? ""
            )
            if AppIDs.checkSupportedProject(body.appId ?? "") {
                mainController.createApp(
                    path: tempLoc + "app/src/main/",
                    packageName: body.packageName,
                    applicationName: body.applicationName,
                    appId: body.appId ?? ""
                )
            } else {
                mainController.createApp(
                    path: tempLoc + "app/src/main/",
                    packageName: body.packageName,
                    applicationName: body.applicationName,
                    appId: body.appId ?? "",
                    commonPresentation: false
                )
            }
            
            let appPath = tempLoc + "app/src/main/java/\(body.packageName.replacing(".", with: "/"))/presentation/fragments/main_fragment/"
            let resPath = tempLoc + "app/src/main/res/drawable/"
            switch body.prefix {
            case AppIDs.ALPHA_PREFIX:
                _ = (() -> Void).self
            case AppIDs.VS_PREFIX:
                let vsController = VSController(fileHandler: fileHandler)
                vsController.boot(
                    id: body.appId ?? "error",
                    path: appPath,
                    pathRes: resPath,
                    packageName: body.packageName,
                    backColorPrimary: body.backColorPrimary ?? getColor(),
                    backColorSecondary: body.backColorSecondary ?? getColor(),
                    surfaceColor: body.surfaceColor ?? getColor(),
                    onSurfaceColor: body.onSurfaceColor ?? getColor(),
                    primaryColor: body.primaryColor ?? getColor(),
                    onPrimaryColor: body.onPrimaryColor ?? getColor(),
                    errorColor: body.errorColor ?? getColor(),
                    textColorPrimary: body.textColorPrimary ?? getColor(),
                    textColorSecondary: body.textColorSecondary ?? getColor(),
                    buttonColorPrimary: body.buttonColorPrimary ?? getColor(),
                    buttonColorSecondary: body.buttonColorSecondary ?? getColor(),
                    buttonTextColorPrimaty: body.buttonTextColorPrimaty ?? getColor(),
                    buttonTextColorSecondary: body.buttonTextColorSecondary ?? getColor(),
                    paddingPrimary: body.paddingPrimary ?? 16,
                    paddingSecondary: body.paddingSecondary ?? 16,
                    textSizePrimary: body.textSizePrimary ?? 22,
                    textSizeSecondary: body.textSizeSecondary ?? 22
                )
            case AppIDs.JK_PREFIX:
                _ = (() -> Void).self
            case AppIDs.SK_PREFIX:
                _ = (() -> Void).self
            case AppIDs.MB_PREFIX:
                let mbController = MBController(fileHandler: fileHandler)
                mbController.boot(
                    id: body.appId ?? "error",
                    path: appPath,
                    pathRes: resPath,
                    packageName: body.packageName,
                    backColorPrimary: body.backColorPrimary ?? getColor(),
                    backColorSecondary: body.backColorSecondary ?? getColor(),
                    surfaceColor: body.surfaceColor ?? getColor(),
                    onSurfaceColor: body.onSurfaceColor ?? getColor(),
                    primaryColor: body.primaryColor ?? getColor(),
                    onPrimaryColor: body.onPrimaryColor ?? getColor(),
                    errorColor: body.errorColor ?? getColor(),
                    textColorPrimary: body.textColorPrimary ?? getColor(),
                    textColorSecondary: body.textColorSecondary ?? getColor(),
                    buttonColorPrimary: body.buttonColorPrimary ?? getColor(),
                    buttonColorSecondary: body.buttonColorSecondary ?? getColor(),
                    buttonTextColorPrimary: body.buttonTextColorPrimaty ?? getColor(),
                    buttonTextColorSecondary: body.buttonTextColorSecondary ?? getColor(),
                    paddingPrimary: body.paddingPrimary ?? 12,
                    paddingSecondary: body.paddingSecondary ?? 8,
                    textSizePrimary: body.textSizePrimary ?? 24,
                    textSizeSecondary: body.textSizeSecondary ?? 20
                )
            default:
                _ = (() -> Void).self
            }
            mainController.createLogFile(path: LocalConst.tempDir + stamp + "/", token: token)
            if FileManager.default.fileExists(atPath: tempLoc) {
                UnzipHandler.zip(filePath: URL.init(filePath: LocalConst.tempDir + stamp + "/" + body.appName), destinationPath: URL.init(filePath: LocalConst.tempDir + stamp + "/" + body.appName + ".zip"), completion: { state, error in
                    completion()
                })
            } else {
                print("sosi")
            }
        }

        
    }
    
    private func getColor() -> String {
        let backColors = [
            "FF6666",
            "D1AB74",
            "E7EB76",
            "9CDA46",
            "1A9E15",
            "5980E4",
            "D6161A",
            "FF7666",
            "D1AA74",
            "E8EB76",
            "9C1A46",
            "1A9E85",
            "5180E4",
            "D61B1A",
            "FF1666",
            "D4AB74",
            "E44B76",
            "9CCA46",
            "1A1E15",
            "5970E4",
            "D6145A"
        ]
        return backColors.randomElement() ?? "FF6666"
    }
}
