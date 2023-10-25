//
//  File.swift
//  
//
//  Created by admin on 02.07.2023.
//

import Foundation

extension MBController {
    func createStopwatch(appName: String, path: String, packageName: String, uiSettings: UISettings, metaLoc: String, gradlePaths: GradlePaths) {
        fileHandler.writeFile(filePath: path, contentText: MBStopwatch.fileContent(packageName: packageName, uiSettings: uiSettings), fileName: MBStopwatch.fileName)
        fileHandler.writeFile(filePath: metaLoc, contentText: MetaHandler.fileContent(appName: appName, short: StopwatchMeta.getShortDesc(appName: appName), full: StopwatchMeta.getFullDesc(appName: appName), category: AppCategory.app_tools.rawValue), fileName: MetaHandler.fileName)
        
        fileHandler.createGradle(MBStopwatch.self, packageName: packageName, gradlePaths: gradlePaths)
    }
    
    func createSpeedTest(appName: String, path: String, packageName: String, uiSettings: UISettings, metaLoc: String, gradlePaths: GradlePaths) {
        fileHandler.writeFile(filePath: path, contentText: MBSpeedTest.fileContent(packageName: packageName, uiSettings: uiSettings), fileName: MBSpeedTest.fileName)
//        fileHandler.writeFile(filePath: metaLoc, contentText: MetaHandler.fileContent(appName: appName, short: SpeedTestMeta.getShortDesc(appName: appName), full: SpeedTestMeta.getFullDesc(appName: appName), category: AppCategory.app_tools.rawValue), fileName: MetaHandler.fileName)
        fileHandler.createMeta(SpeedTestMeta.self, metaLoc: metaLoc, category: .app_tools, appName: appName)
        
        fileHandler.createGradle(MBSpeedTest.self, packageName: packageName, gradlePaths: gradlePaths)
    }
    
    func createPingTest(appName: String, path: String, packageName: String, uiSettings: UISettings, metaLoc: String, gradlePaths: GradlePaths) {
        fileHandler.writeFile(filePath: path, contentText: MBPingTest.fileContent(packageName: packageName, uiSettings: uiSettings), fileName: MBPingTest.fileName)
        fileHandler.writeFile(filePath: metaLoc, contentText: MetaHandler.fileContent(appName: appName, short: PingTestMeta.getShortDesc(appName: appName), full: PingTestMeta.getFullDesc(appName: appName), category: AppCategory.app_tools.rawValue), fileName: MetaHandler.fileName)
        
        fileHandler.createGradle(MBPingTest.self, packageName: packageName, gradlePaths: gradlePaths)
    }
    
    func createAlarm(appName: String, path: String, resPath: String, packageName: String, uiSettings: UISettings, metaLoc: String, gradlePaths: GradlePaths) {
        fileHandler.writeFile(filePath: path, contentText: MBAlarm.fileContent(packageName: packageName, uiSettings: uiSettings), fileName: MBAlarm.fileName)
        fileHandler.writeFile(filePath: resPath, contentText: MBAlarmRes.alarmText(), fileName: MBAlarmRes.alarmName)
        fileHandler.writeFile(filePath: metaLoc, contentText: MetaHandler.fileContent(appName: appName, short: AlarmMeta.getShortDesc(appName: appName), full: AlarmMeta.getFullDesc(appName: appName), category: AppCategory.app_tools.rawValue), fileName: MetaHandler.fileName)
        
        fileHandler.createGradle(MBAlarm.self, packageName: packageName, gradlePaths: gradlePaths)
    }
    
    func createIpChecker(appName: String, path: String, packageName: String, uiSettings: UISettings, metaLoc: String, gradlePaths: GradlePaths) {
        fileHandler.writeFile(filePath: path, contentText: MBIpChecker.fileContent(packageName: packageName, uiSettings: uiSettings), fileName: MBIpChecker.fileName)
        fileHandler.writeFile(filePath: metaLoc, contentText: MetaHandler.fileContent(appName: appName, short: IpCheckerMeta.getShortDesc(appName: appName), full: IpCheckerMeta.getFullDesc(appName: appName), category: AppCategory.app_tools.rawValue), fileName: MetaHandler.fileName)
        
        fileHandler.createGradle(MBIpChecker.self, packageName: packageName, gradlePaths: gradlePaths)
    }
    
    func createFacts(appName: String, path: String, packageName: String, uiSettings: UISettings, metaLoc: String, gradlePaths: GradlePaths) {
        fileHandler.writeFile(filePath: path, contentText: MBFacts.fileContent(packageName: packageName, uiSettings: uiSettings), fileName: MBFacts.fileName)
        fileHandler.writeFile(filePath: metaLoc, contentText: MetaHandler.fileContent(appName: appName, short: FactsMeta.getShortDesc(appName: appName), full: FactsMeta.getFullDesc(appName: appName), category: AppCategory.app_entertainment.rawValue), fileName: MetaHandler.fileName)
        
        fileHandler.createGradle(MBFacts.self, packageName: packageName, gradlePaths: gradlePaths)
    }
    
    func createTorch(appName: String, path: String, packageName: String, uiSettings: UISettings, metaLoc: String, gradlePaths: GradlePaths) {
        fileHandler.writeFile(filePath: path, contentText: MBTorch.fileContent(packageName: packageName, uiSettings: uiSettings), fileName: MBTorch.fileName)
        fileHandler.writeFile(filePath: metaLoc, contentText: MetaHandler.fileContent(appName: appName, short: TorchMeta.getShortDesc(appName: appName), full: TorchMeta.getFullDesc(appName: appName), category: AppCategory.app_tools.rawValue), fileName: MetaHandler.fileName)
        
        fileHandler.createGradle(MBTorch.self, packageName: packageName, gradlePaths: gradlePaths)
    }
    
    func createLuckyNumber(appName: String, path: String, packageName: String, uiSettings: UISettings, metaLoc: String, gradlePaths: GradlePaths) {
        fileHandler.writeFile(filePath: path, contentText: MBLuckyNumber.fileContent(packageName: packageName, uiSettings: uiSettings), fileName: MBLuckyNumber.fileName)
        fileHandler.writeFile(filePath: metaLoc, contentText: MetaHandler.fileContent(appName: appName, short: LuckyNumberMeta.getShortDesc(appName: appName), full: LuckyNumberMeta.getFullDesc(appName: appName), category: AppCategory.app_entertainment.rawValue), fileName: MetaHandler.fileName)
        
        fileHandler.createGradle(MBLuckyNumber.self, packageName: packageName, gradlePaths: gradlePaths)
    }
    func createRace(appName: String, path: String, resPath: String, packageName: String, uiSettings: UISettings, metaLoc: String, gradlePaths: GradlePaths) {
        fileHandler.writeFile(filePath: path, contentText: MBRace.fileContent(packageName: packageName, uiSettings: uiSettings), fileName: MBRace.fileName)
        fileHandler.writeFile(filePath: metaLoc, contentText: MetaHandler.fileContent(appName: appName, short: RaceMeta.getShortDesc(appName: appName), full: RaceMeta.getFullDesc(appName: appName), category: AppCategory.game_race.rawValue), fileName: MetaHandler.fileName)
        
        fileHandler.createGradle(MBRace.self, packageName: packageName, gradlePaths: gradlePaths)
    }
    
    func createCatcher(appName: String, path: String, resPath: String, packageName: String, uiSettings: UISettings, metaLoc: String, gradlePaths: GradlePaths) {
        fileHandler.writeFile(filePath: path, contentText: MBCatcher.fileContent(packageName: packageName, uiSettings: uiSettings), fileName: MBCatcher.fileName)
        fileHandler.writeFile(filePath: metaLoc, contentText: MetaHandler.fileContent(appName: appName, short: CatcherMeta.getShortDesc(appName: appName), full: CatcherMeta.getFullDesc(appName: appName), category: AppCategory.game_arcade.rawValue), fileName: MetaHandler.fileName)
        
        fileHandler.createGradle(MBCatcher.self, packageName: packageName, gradlePaths: gradlePaths)
    }
    
    func createBmi(appName: String, path: String, packageName: String, uiSettings: UISettings, metaLoc: String, gradlePaths: GradlePaths) {
        fileHandler.writeFile(filePath: path, contentText: MBBmi.fileContent(packageName: packageName, uiSettings: uiSettings), fileName: MBBmi.fileName)
        fileHandler.writeFile(filePath: metaLoc, contentText: MetaHandler.fileContent(appName: appName, short: BmiCalcMeta.getShortDesc(appName: appName), full: BmiCalcMeta.getFullDesc(appName: appName), category: AppCategory.app_tools.rawValue), fileName: MetaHandler.fileName)
        
        fileHandler.createGradle(MBBmi.self, packageName: packageName, gradlePaths: gradlePaths)
    }
    
    func createSpaceFighter(appName: String, path: String, resPath: String, packageName: String, uiSettings: UISettings, metaLoc: String, gradlePaths: GradlePaths) {
        fileHandler.writeFile(filePath: path, contentText: MBSpaceFighter.fileContent(packageName: packageName, uiSettings: uiSettings), fileName: MBSpaceFighter.fileName)
        fileHandler.writeFile(filePath: metaLoc, contentText: MetaHandler.fileContent(appName: appName, short: SpaceshipAdventureMeta.getShortDesc(appName: appName), full: SpaceshipAdventureMeta.getFullDesc(appName: appName), category: AppCategory.game_arcade.rawValue), fileName: MetaHandler.fileName)
        
        fileHandler.createGradle(MBSpaceFighter.self, packageName: packageName, gradlePaths: gradlePaths)
    }
    
    func createRickNMorty(appName: String, path: String, packageName: String, uiSettings: UISettings, metaLoc: String, gradlePaths: GradlePaths) {
        fileHandler.writeFile(filePath: path, contentText: MBRickNMorty.fileContent(packageName: packageName, uiSettings: uiSettings), fileName: MBRickNMorty.fileName)
        fileHandler.writeFile(filePath: metaLoc, contentText: MetaHandler.fileContent(appName: appName, short: RickNMortyMeta.getShortDesc(appName: appName), full: RickNMortyMeta.getFullDesc(appName: appName), category: AppCategory.app_entertainment.rawValue), fileName: MetaHandler.fileName)
        
        fileHandler.createGradle(MBRickNMorty.self, packageName: packageName, gradlePaths: gradlePaths)
    }
    
    func createPassGen(appName: String, path: String, packageName: String, uiSettings: UISettings, metaLoc: String, gradlePaths: GradlePaths) {
        fileHandler.writeFile(filePath: path, contentText: MBPassGen.fileContent(packageName: packageName, uiSettings: uiSettings), fileName: MBPassGen.fileName)
        fileHandler.writeFile(filePath: metaLoc, contentText: MetaHandler.fileContent(appName: appName, short: PassGeneratorMeta.getShortDesc(appName: appName), full: PassGeneratorMeta.getFullDesc(appName: appName), category: AppCategory.app_tools.rawValue), fileName: MetaHandler.fileName)
        
        fileHandler.createGradle(MBPassGen.self, packageName: packageName, gradlePaths: gradlePaths)
    }
    
    func createDeviceInfo(appName: String, path: String, packageName: String, uiSettings: UISettings, metaLoc: String, gradlePaths: GradlePaths) {
        fileHandler.writeFile(filePath: path, contentText: MBDeviceInfo.fileContent(packageName: packageName, uiSettings: uiSettings), fileName: MBDeviceInfo.fileName)
        fileHandler.writeFile(filePath: metaLoc, contentText: MetaHandler.fileContent(appName: appName, short: DeviceInfoMeta.getShortDesc(appName: appName), full: DeviceInfoMeta.getFullDesc(appName: appName), category: AppCategory.app_tools.rawValue), fileName: MetaHandler.fileName)
        
        fileHandler.createGradle(MBDeviceInfo.self, packageName: packageName, gradlePaths: gradlePaths)
    }
    
    func createHashGen(appName: String, path: String, packageName: String, uiSettings: UISettings, metaLoc: String, gradlePaths: GradlePaths) {
        fileHandler.writeFile(filePath: path, contentText: MBHashGen.fileContent(packageName: packageName, uiSettings: uiSettings), fileName: MBHashGen.fileName)
        fileHandler.writeFile(filePath: metaLoc, contentText: MetaHandler.fileContent(appName: appName, short: HashMeta.getShortDesc(appName: appName), full: HashMeta.getFullDesc(appName: appName), category: AppCategory.app_tools.rawValue), fileName: MetaHandler.fileName)
        
        fileHandler.createGradle(MBHashGen.self, packageName: packageName, gradlePaths: gradlePaths)
    }
    
    func createSerials(appName: String, path: String, packageName: String, uiSettings: UISettings, metaLoc: String, gradlePaths: GradlePaths) {
        fileHandler.writeFile(filePath: path, contentText: MBSerials.fileContent(packageName: packageName, uiSettings: uiSettings), fileName: MBSerials.fileName)
        
        fileHandler.writeFile(filePath: metaLoc, contentText: MetaHandler.fileContent(appName: appName, short: SerialsMeta.getShortDesc(appName: appName), full: SerialsMeta.getFullDesc(appName: appName), category: AppCategory.app_entertainment.rawValue), fileName: MetaHandler.fileName)
        
        fileHandler.createGradle(MBSerials.self, packageName: packageName, gradlePaths: gradlePaths)
        
    }
}

//protocol MBAppProtocol {
//    func createMBApp(path: String, packageName: String, uiSettings: UISettings)
//    func createMBApp(path: String, packageName: String, resPath: String, uiSettings: UISettings)
//}
