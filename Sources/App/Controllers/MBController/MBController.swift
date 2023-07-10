//
//  File.swift
//  
//
//  Created by admin on 14.06.2023.
//

import SwiftUI

struct MBController {
    @ObservedObject var fileHandler: FileHandler
    
    func boot(id: String, appName: String, path: String, resPath: String, packageName: String, uiSettings: UISettings, metaLoc: String, designLocation: MetaDesignLocation?) {
        switch id {
        case AppIDs.MB_STOPWATCH:
            createStopwatch(appName: appName, path: path, packageName: packageName, uiSettings: uiSettings, metaLoc: metaLoc)
        case AppIDs.MB_SPEED_TEST:
            createSpeedTest(appName: appName, path: path, packageName: packageName, uiSettings: uiSettings, metaLoc: metaLoc)
        case AppIDs.MB_PING_TEST:
            createPingTest(appName: appName, path: path, packageName: packageName, uiSettings: uiSettings, metaLoc: metaLoc)
        case AppIDs.MB_ALARM:
            createAlarm(appName: appName, path: path, resPath: resPath, packageName: packageName, uiSettings: uiSettings, metaLoc: metaLoc)
        case AppIDs.MB_FACTS:
            createFacts(appName: appName, path: path, packageName: packageName, uiSettings: uiSettings, metaLoc: metaLoc)
        case AppIDs.MB_TORCH:
            createTorch(appName: appName, path: path, packageName: packageName, uiSettings: uiSettings, metaLoc: metaLoc)
        case AppIDs.MB_LUCKY_NUMBER:
            createLuckyNumber(appName: appName, path: path, packageName: packageName, uiSettings: uiSettings, metaLoc: metaLoc)
        case AppIDs.MB_RACE:
            createRace(appName: appName, path: path, resPath: resPath, packageName: packageName, uiSettings: uiSettings, metaLoc: metaLoc)
        case AppIDs.MB_CATCHER:
            createCatcher(appName: appName, path: path, resPath: resPath, packageName: packageName, uiSettings: uiSettings, metaLoc: metaLoc)
        case AppIDs.MB_BMI_CALC_ID:
            createBmi(appName: appName, path: path, packageName: packageName, uiSettings: uiSettings, metaLoc: metaLoc)
        case AppIDs.MB_SPACE_FIGHTER:
            createSpaceFighter(appName: appName, path: path, resPath: resPath, packageName: packageName, uiSettings: uiSettings, metaLoc: metaLoc)
        case AppIDs.MB_CHECK_IP:
            createIpChecker(appName: appName, path: path, packageName: packageName, uiSettings: uiSettings, metaLoc: metaLoc)
        case AppIDs.MB_RICK_AND_MORTY:
            createRickNMorty(appName: appName, path: path, packageName: packageName, uiSettings: uiSettings, metaLoc: metaLoc)
        case AppIDs.MB_PASS_GEN:
            createPassGen(appName: appName, path: path, packageName: packageName, uiSettings: uiSettings, metaLoc: metaLoc)
        case AppIDs.MB_DEVICE_INFO:
            createDeviceInfo(appName: appName, path: path, packageName: packageName, uiSettings: uiSettings, metaLoc: metaLoc)
        default:
            return
        }
        if designLocation != nil {
            fileHandler.copyPaste(from: designLocation!.iconLocation, to: metaLoc + "assets/icon.png")
            fileHandler.copyPaste(from: designLocation!.bannerLocation, to: metaLoc + "assets/banner.png")
            fileHandler.copyPaste(from: designLocation!.screen1Location, to: metaLoc + "assets/screen1.png")
            fileHandler.copyPaste(from: designLocation!.screen2Location, to: metaLoc + "assets/screen2.png")
            fileHandler.copyPaste(from: designLocation!.screen3Location, to: metaLoc + "assets/screen3.png")
        }
    }
}

//protocol ProjectProtocol {
//    var fileName: String { get set }
//    var fileContent: String { get set }
//    var resFiles: [ResFilesProtocol]? { get set }
//    var mainActivityAdd: MainActivityAddProtocol { get set }
//    var mainFragmentAdd: MainFragmentAddProtocol { get set }
//    var gradleDependencies: String { get set }
//}
//
//protocol ResFilesProtocol {
//    var fileName: String { get set }
//    var fileContent: String { get set }
//}
//
//protocol MainActivityAddProtocol {
//    var imports: String { get set }
//    var fun: String { get set }
//    var funInit: String { get set }
//}
//
//protocol MainFragmentAddProtocol {
//    var imports: String { get set }
//    var content: String { get set }
//}