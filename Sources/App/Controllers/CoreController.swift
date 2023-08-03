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
        
        let mainData = MainData(appId: body.mainData.appId ?? "error", appName: body.mainData.appName, applicationName: body.mainData.applicationName, packageName: body.mainData.packageName, uiSettings: uiSettings)
        mainController.createOuterFiles(path: tempLoc, appName: body.mainData.appName)
        mainController.createGradle(path: tempLoc + "gradle/wrapper/", gradleWrapper: LibVersions.gradleWrapperVersion)
        mainController.createBuildSrc(
            path: tempLoc + "buildSrc/"
        )
        mainController.createRes(
            path: tempLoc + "app/src/main/",
            appName: body.mainData.appName,
            color: appBar,
            appId: body.mainData.appId ?? "", mainData: mainData
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
            appId: body.mainData.appId ?? "", mainData: mainData
        )
        
        let appPath = tempLoc + "app/src/main/java/\(body.mainData.packageName.replacing(".", with: "/"))/presentation/fragments/main_fragment/"
        let resPath = tempLoc + "app/src/main/res/drawable/"

        
        let layoutPath = tempLoc + "app/src/main/res/layout/"
        let valuesPath = tempLoc + "app/src/main/res/values/"
        let gradlePaths = GradlePaths(projectGradlePath: tempLoc, moduleGradlePath: tempLoc + "app/", dependenciesPath: tempLoc + "buildSrc/src/main/java/dependencies/")
        let assetsLocation = tempLoc + "app/src/main/assets/"
        switch body.mainData.prefix {
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
                designLocation: designLocation,
                gradlePaths: gradlePaths
            )
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
                designLocation: designLocation,
                gradlePaths: gradlePaths
            )
        case AppIDs.BC_PREFIX:
            let bcController = BCController(fileHandler: fileHandler)
            bcController.boot(
                id: body.mainData.appId ?? "error",
                appName: body.mainData.appName,
                path: appPath,
                resPath: resPath,
                packageName: body.mainData.packageName,
                uiSettings: uiSettings,
                metaLoc: metaLoc,
                designLocation: designLocation,
                gradlePaths: gradlePaths,
                applicationName: body.mainData.applicationName
            )
        case AppIDs.IT_PREFIX:
            let itController = ITController(fileHandler: fileHandler)
            itController.boot(
                id: body.mainData.appId ?? "error",
                appName: body.mainData.appName,
                path: appPath,
                resPath: resPath,
                packageName: body.mainData.packageName,
                uiSettings: uiSettings,
                metaLoc: metaLoc,
                designLocation: designLocation,
                gradlePaths: gradlePaths
            )
        case AppIDs.VE_PREFIX:
            let veController = VEController(fileHandler: fileHandler)
            veController.boot(
                id: body.mainData.appId ?? "error",
                appName: body.mainData.appName,
                path: appPath,
                resPath: resPath,
                packageName: body.mainData.packageName,
                uiSettings: uiSettings,
                metaLoc: metaLoc,
                designLocation: designLocation,
                gradlePaths: gradlePaths,
                assetsLocation: assetsLocation
            )
        case AppIDs.EG_PREFIX:
            let egController = EGController(fileHandler: fileHandler)
            egController.boot(
                id: body.mainData.appId ?? "error",
                appName: body.mainData.appName,
                path: appPath,
                resPath: resPath,
                layoutPath: layoutPath,
                valuesPath: valuesPath,
                packageName: body.mainData.packageName,
                uiSettings: uiSettings,
                metaLoc: metaLoc,
                designLocation: designLocation,
                gradlePaths: gradlePaths
            )
        default:
            return
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
