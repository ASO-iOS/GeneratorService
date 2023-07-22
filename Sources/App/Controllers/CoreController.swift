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
        routes.on(.POST, PathComponent(stringLiteral: RouteConst.EMPTY_CORE_PROJECT), use: launch)
    }
    
    /// -  главный метод создания проекта
    func launch(_ request: Request) throws -> Response {
        
        // MARK: - инициализация локации файла, изнвчально пустой проект
        var fileLoc = "\(LocalConst.homeDir)GeneratorProjects/resources/empty.zip"
        
//        let timeStamp = Date().getStamp()
        let token = try? request.query.get(String.self, at: "token")
        guard let bodyByteBuffer = request.body.data else { throw Abort(.badRequest) }
        let bodyData = Data(buffer: bodyByteBuffer)
        let body = try JSONDecoder().decode(RequestDto.self, from: bodyData)
        
        if UserToken.checkToken(token) {
            create(token: token ?? "error", body: body, completion: {
                fileLoc = "\(FileManager.default.homeDirectoryForCurrentUser.absoluteString.replacing("file://", with: ""))GeneratorProjects/temp/\(body.mainData.stamp).zip"
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
        completion: @escaping () -> Void
    ) {
        //        DispatchQueue.global(qos: .default).sync {
        let stamp = body.mainData.stamp
        let tempLoc = LocalConst.tempDir + stamp + "/" + body.mainData.appName + "/"
        let metaLoc = LocalConst.tempDir + stamp + "/"
        let uiSettings: UISettings
        let designLocation: MetaDesignLocation?
        let appBar: String
        if body.mainData.manual {
            uiSettings = UISettings(
                backColorPrimary: body.ui?.backColorPrimary ?? getColor(),
                backColorSecondary: body.ui?.backColorSecondary ?? getColor(),
                surfaceColor: body.ui?.surfaceColor ?? getColor(),
                onSurfaceColor: body.ui?.onSurfaceColor ?? getColor(),
                primaryColor: body.ui?.primaryColor ?? getColor(),
                onPrimaryColor: body.ui?.onPrimaryColor ?? getColor(),
                errorColor: body.ui?.errorColor ?? getColor(),
                textColorPrimary: body.ui?.textColorPrimary ?? getColor(),
                textColorSecondary: body.ui?.textColorSecondary ?? getColor(),
                buttonColorPrimary: body.ui?.buttonColorPrimary ?? getColor(),
                buttonColorSecondary: body.ui?.buttonColorSecondary ?? getColor(),
                buttonTextColorPrimary: body.ui?.buttonTextColorPrimary ?? getColor(),
                buttonTextColorSecondary: body.ui?.buttonTextColorSecondary ?? getColor(),
                paddingPrimary: body.ui?.paddingPrimary,
                paddingSecondary: body.ui?.paddingSecondary,
                textSizePrimary: body.ui?.textSizePrimary,
                textSizeSecondary: body.ui?.textSizeSecondary
            )
            appBar = body.ui?.appBarColor ?? "ffffff"
            designLocation = nil
        } else {
            let designData = DesignHandler.getDesign(MetaDesignProtocolConverter.convert(prefix: body.mainData.prefix ?? "", protocolId: body.mainData.uiDesignId ?? "", appId: body.mainData.appId ?? ""))
            uiSettings = designData.uiSettings
            designLocation = designData.designLocation
            appBar = designData.uiSettings.backColorPrimary ?? "ffffff"
        }
        
        mainController.createOuterFiles(path: tempLoc, appName: body.mainData.appName)
        mainController.createGradle(path: tempLoc + "gradle/wrapper/", gradleWrapper: body.versions?.gradleWrapper ?? LibVersions.gradleWrapperVersion)
        mainController.createBuildSrc(
            path: tempLoc + "buildSrc/",
            packageName: body.mainData.packageName,
            gradleVersion: body.versions?.gradleVersion ?? LibVersions.gradleVersion,
            compileSdk: body.versions?.compileSdk ?? LibVersions.compileSdk,
            minsdk: body.versions?.minSdk ?? LibVersions.minsdk,
            targetsdk: body.versions?.targetSdk ?? LibVersions.targetsdk,
            kotlin: body.versions?.kotlin ?? LibVersions.kotlin,
            kotlin_coroutines: body.versions?.kotlinCoroutines ?? LibVersions.kotlin_coroutines,
            hilt: body.versions?.hilt ?? LibVersions.hilt,
            hilt_viewmodel_compiler: body.versions?.hiltViewmodelCompiler ?? LibVersions.hilt_viewmodel_compiler,
            ktx: body.versions?.ktx ?? LibVersions.ktx,
            lifecycle: body.versions?.lifecycle ?? LibVersions.lifecycle,
            fragment_ktx: body.versions?.fragmentKtx ?? LibVersions.fragment_ktx,
            appcompat: body.versions?.appcompat ?? LibVersions.appcompat,
            material: body.versions?.material ?? LibVersions.material,
            compose: body.versions?.compose ?? LibVersions.compose,
            compose_navigation: body.versions?.composeNavigation ?? LibVersions.compose_navigation,
            activity_compose: body.versions?.activityCompose ?? LibVersions.activity_compose,
            compose_hilt_nav: body.versions?.composeHiltNav ?? LibVersions.compose_hilt_nav,
            oneSignal: body.versions?.oneSignal ?? LibVersions.oneSignal,
            glide: body.versions?.glide ?? LibVersions.glide,
            swipe: body.versions?.swipe ?? LibVersions.swipe,
            glide_skydoves: body.versions?.glideSkydoves ?? LibVersions.glide_skydoves,
            retrofit: body.versions?.retrofit ?? LibVersions.retrofit,
            okhttp: body.versions?.okhttp ?? LibVersions.okhttp,
            room: body.versions?.room ?? LibVersions.room,
            coil: body.versions?.coil ?? LibVersions.coil,
            exp: body.versions?.exp ?? LibVersions.exp,
            calend: body.versions?.calend ?? LibVersions.calend,
            paging: body.versions?.paging ?? LibVersions.paging,
            accompanist: body.versions?.accompanist ?? LibVersions.accompanist
        )
        mainController.createRes(
            path: tempLoc + "app/src/main/",
            appName: body.mainData.appName,
            color: appBar,
            appId: body.mainData.appId ?? ""
        )
        mainController.createManifest(
            path: tempLoc + "app/src/main/",
            packageName: body.mainData.packageName,
            applicationName: body.mainData.applicationName,
            name: body.mainData.appName,
            screenOrientation: ScreenOrientationEnum.getOrientationFromString(body.ui?.screenOrientation ?? ScreenOrientationEnum.portrait.name),
            appId: body.mainData.appId ?? ""
        )
        mainController.createAppGradle(
            path: tempLoc + "app/",
            appId: body.mainData.appId ?? ""
        )
        mainController.createApp(
            path: tempLoc + "app/src/main/",
            packageName: body.mainData.packageName,
            applicationName: body.mainData.applicationName,
            appId: body.mainData.appId ?? ""
        )
        
        let appPath = tempLoc + "app/src/main/java/\(body.mainData.packageName.replacing(".", with: "/"))/presentation/fragments/main_fragment/"
        let resPath = tempLoc + "app/src/main/res/drawable/"


        switch body.mainData.prefix {
        case AppIDs.ALPHA_PREFIX:
            _ = (() -> Void).self
        case AppIDs.VS_PREFIX:
            let vsController = VSController(fileHandler: fileHandler)
            vsController.boot(
                id: body.mainData.appId ?? "error",
                appName: body.mainData.appName,
                path: appPath,
                resPath: resPath,
                packageName: body.mainData.packageName,
                uiSettings: uiSettings,
                metaLoc: metaLoc,
                designLocation: designLocation
            )
        case AppIDs.JK_PREFIX:
            _ = (() -> Void).self
        case AppIDs.SK_PREFIX:
            _ = (() -> Void).self
        case AppIDs.MB_PREFIX:
            let mbController = MBController(fileHandler: fileHandler)
            mbController.boot(
                id: body.mainData.appId ?? "error",
                appName: body.mainData.appName,
                path: appPath,
                resPath: resPath,
                packageName: body.mainData.packageName,
                uiSettings: uiSettings,
                metaLoc: metaLoc,
                designLocation: designLocation
            )
        default:
            _ = (() -> Void).self
        }
        mainController.createLogFile(path: LocalConst.tempDir + stamp + "/", token: token)
        if FileManager.default.fileExists(atPath: tempLoc) {
            UnzipHandler.zip(filePath: URL.init(filePath: LocalConst.tempDir + stamp), destinationPath: URL.init(filePath: LocalConst.tempDir + stamp + ".zip"), completion: { state, error in
                completion()
            })
        } else {
            print("sosi")
        }
    }
    
    private func getColor() -> String {
        let backColors = [
            "FF0000",
            "FF5722",
            "FFEB3B",
            "8BC34A",
            "00BCD4",
            "3F51B5",
            "9C27B0",
            "000000",
            "FFFFFF"
        ]
        return backColors.randomElement() ?? "FF6666"
    }
}
