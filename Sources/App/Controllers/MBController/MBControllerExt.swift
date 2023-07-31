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
        
        fileHandler.writeFile(filePath: gradlePaths.projectGradlePath, contentText: MBStopwatch.gradle(packageName).projectBuildGradle.content, fileName: MBStopwatch.gradle(packageName).projectBuildGradle.name)
        fileHandler.writeFile(filePath: gradlePaths.moduleGradlePath, contentText: MBStopwatch.gradle(packageName).moduleBuildGradle.content, fileName: MBStopwatch.gradle(packageName).moduleBuildGradle.name)
        fileHandler.writeFile(filePath: gradlePaths.dependenciesPath, contentText: MBStopwatch.gradle(packageName).dependencies.content, fileName: MBStopwatch.gradle(packageName).dependencies.name)
    }
    
    func createSpeedTest(appName: String, path: String, packageName: String, uiSettings: UISettings, metaLoc: String, gradlePaths: GradlePaths) {
        fileHandler.writeFile(filePath: path, contentText: MBSpeedTest.fileContent(packageName: packageName, uiSettings: uiSettings), fileName: MBSpeedTest.fileName)
        fileHandler.writeFile(filePath: metaLoc, contentText: MetaHandler.fileContent(appName: appName, short: SpeedTestMeta.getShortDesc(appName: appName), full: SpeedTestMeta.getFullDesc(appName: appName), category: AppCategory.app_tools.rawValue), fileName: MetaHandler.fileName)
        
        fileHandler.writeFile(filePath: gradlePaths.projectGradlePath, contentText: MBSpeedTest.gradle(packageName).projectBuildGradle.content, fileName: MBSpeedTest.gradle(packageName).projectBuildGradle.name)
        fileHandler.writeFile(filePath: gradlePaths.moduleGradlePath, contentText: MBSpeedTest.gradle(packageName).moduleBuildGradle.content, fileName: MBSpeedTest.gradle(packageName).moduleBuildGradle.name)
        fileHandler.writeFile(filePath: gradlePaths.dependenciesPath, contentText: MBSpeedTest.gradle(packageName).dependencies.content, fileName: MBSpeedTest.gradle(packageName).dependencies.name)
    }
    
    func createPingTest(appName: String, path: String, packageName: String, uiSettings: UISettings, metaLoc: String, gradlePaths: GradlePaths) {
        fileHandler.writeFile(filePath: path, contentText: MBPingTest.fileContent(packageName: packageName, uiSettings: uiSettings), fileName: MBPingTest.fileName)
        fileHandler.writeFile(filePath: metaLoc, contentText: MetaHandler.fileContent(appName: appName, short: PingTestMeta.getShortDesc(appName: appName), full: PingTestMeta.getFullDesc(appName: appName), category: AppCategory.app_tools.rawValue), fileName: MetaHandler.fileName)
        
        fileHandler.writeFile(filePath: gradlePaths.projectGradlePath, contentText: MBPingTest.gradle(packageName).projectBuildGradle.content, fileName: MBPingTest.gradle(packageName).projectBuildGradle.name)
        fileHandler.writeFile(filePath: gradlePaths.moduleGradlePath, contentText: MBPingTest.gradle(packageName).moduleBuildGradle.content, fileName: MBPingTest.gradle(packageName).moduleBuildGradle.name)
        fileHandler.writeFile(filePath: gradlePaths.dependenciesPath, contentText: MBPingTest.gradle(packageName).dependencies.content, fileName: MBPingTest.gradle(packageName).dependencies.name)
    }
    
    func createAlarm(appName: String, path: String, resPath: String, packageName: String, uiSettings: UISettings, metaLoc: String, gradlePaths: GradlePaths) {
        fileHandler.writeFile(filePath: path, contentText: MBAlarm.fileContent(packageName: packageName, uiSettings: uiSettings), fileName: MBAlarm.fileName)
        fileHandler.writeFile(filePath: resPath, contentText: MBAlarmRes.alarmText(), fileName: MBAlarmRes.alarmName)
        fileHandler.writeFile(filePath: metaLoc, contentText: MetaHandler.fileContent(appName: appName, short: AlarmMeta.getShortDesc(appName: appName), full: AlarmMeta.getFullDesc(appName: appName), category: AppCategory.app_tools.rawValue), fileName: MetaHandler.fileName)
        
        fileHandler.writeFile(filePath: gradlePaths.projectGradlePath, contentText: MBAlarm.gradle(packageName).projectBuildGradle.content, fileName: MBAlarm.gradle(packageName).projectBuildGradle.name)
        fileHandler.writeFile(filePath: gradlePaths.moduleGradlePath, contentText: MBAlarm.gradle(packageName).moduleBuildGradle.content, fileName: MBAlarm.gradle(packageName).moduleBuildGradle.name)
        fileHandler.writeFile(filePath: gradlePaths.dependenciesPath, contentText: MBAlarm.gradle(packageName).dependencies.content, fileName: MBAlarm.gradle(packageName).dependencies.name)
    }
    
    func createIpChecker(appName: String, path: String, packageName: String, uiSettings: UISettings, metaLoc: String, gradlePaths: GradlePaths) {
        fileHandler.writeFile(filePath: path, contentText: MBIpChecker.fileContent(packageName: packageName, uiSettings: uiSettings), fileName: MBIpChecker.fileName)
        fileHandler.writeFile(filePath: metaLoc, contentText: MetaHandler.fileContent(appName: appName, short: IpCheckerMeta.getShortDesc(appName: appName), full: IpCheckerMeta.getFullDesc(appName: appName), category: AppCategory.app_tools.rawValue), fileName: MetaHandler.fileName)
        
        fileHandler.writeFile(filePath: gradlePaths.projectGradlePath, contentText: MBIpChecker.gradle(packageName).projectBuildGradle.content, fileName: MBIpChecker.gradle(packageName).projectBuildGradle.name)
        fileHandler.writeFile(filePath: gradlePaths.moduleGradlePath, contentText: MBIpChecker.gradle(packageName).moduleBuildGradle.content, fileName: MBIpChecker.gradle(packageName).moduleBuildGradle.name)
        fileHandler.writeFile(filePath: gradlePaths.dependenciesPath, contentText: MBIpChecker.gradle(packageName).dependencies.content, fileName: MBIpChecker.gradle(packageName).dependencies.name)
    }
    
    func createFacts(appName: String, path: String, packageName: String, uiSettings: UISettings, metaLoc: String, gradlePaths: GradlePaths) {
        fileHandler.writeFile(filePath: path, contentText: MBFacts.fileContent(packageName: packageName, uiSettings: uiSettings), fileName: MBFacts.fileName)
        fileHandler.writeFile(filePath: metaLoc, contentText: MetaHandler.fileContent(appName: appName, short: FactsMeta.getShortDesc(appName: appName), full: FactsMeta.getFullDesc(appName: appName), category: AppCategory.app_entertainment.rawValue), fileName: MetaHandler.fileName)
        
        fileHandler.writeFile(filePath: gradlePaths.projectGradlePath, contentText: MBFacts.gradle(packageName).projectBuildGradle.content, fileName: MBFacts.gradle(packageName).projectBuildGradle.name)
        fileHandler.writeFile(filePath: gradlePaths.moduleGradlePath, contentText: MBFacts.gradle(packageName).moduleBuildGradle.content, fileName: MBFacts.gradle(packageName).moduleBuildGradle.name)
        fileHandler.writeFile(filePath: gradlePaths.dependenciesPath, contentText: MBFacts.gradle(packageName).dependencies.content, fileName: MBFacts.gradle(packageName).dependencies.name)
    }
    
    func createTorch(appName: String, path: String, packageName: String, uiSettings: UISettings, metaLoc: String, gradlePaths: GradlePaths) {
        fileHandler.writeFile(filePath: path, contentText: MBTorch.fileContent(packageName: packageName, uiSettings: uiSettings), fileName: MBTorch.fileName)
        fileHandler.writeFile(filePath: metaLoc, contentText: MetaHandler.fileContent(appName: appName, short: TorchMeta.getShortDesc(appName: appName), full: TorchMeta.getFullDesc(appName: appName), category: AppCategory.app_tools.rawValue), fileName: MetaHandler.fileName)
        
        fileHandler.writeFile(filePath: gradlePaths.projectGradlePath, contentText: MBTorch.gradle(packageName).projectBuildGradle.content, fileName: MBTorch.gradle(packageName).projectBuildGradle.name)
        fileHandler.writeFile(filePath: gradlePaths.moduleGradlePath, contentText: MBTorch.gradle(packageName).moduleBuildGradle.content, fileName: MBTorch.gradle(packageName).moduleBuildGradle.name)
        fileHandler.writeFile(filePath: gradlePaths.dependenciesPath, contentText: MBTorch.gradle(packageName).dependencies.content, fileName: MBTorch.gradle(packageName).dependencies.name)
    }
    
    func createLuckyNumber(appName: String, path: String, packageName: String, uiSettings: UISettings, metaLoc: String, gradlePaths: GradlePaths) {
        fileHandler.writeFile(filePath: path, contentText: MBLuckyNumber.fileContent(packageName: packageName, uiSettings: uiSettings), fileName: MBLuckyNumber.fileName)
        fileHandler.writeFile(filePath: metaLoc, contentText: MetaHandler.fileContent(appName: appName, short: LuckyNumberMeta.getShortDesc(appName: appName), full: LuckyNumberMeta.getFullDesc(appName: appName), category: AppCategory.app_entertainment.rawValue), fileName: MetaHandler.fileName)
        
        fileHandler.writeFile(filePath: gradlePaths.projectGradlePath, contentText: MBLuckyNumber.gradle(packageName).projectBuildGradle.content, fileName: MBLuckyNumber.gradle(packageName).projectBuildGradle.name)
        fileHandler.writeFile(filePath: gradlePaths.moduleGradlePath, contentText: MBLuckyNumber.gradle(packageName).moduleBuildGradle.content, fileName: MBLuckyNumber.gradle(packageName).moduleBuildGradle.name)
        fileHandler.writeFile(filePath: gradlePaths.dependenciesPath, contentText: MBLuckyNumber.gradle(packageName).dependencies.content, fileName: MBLuckyNumber.gradle(packageName).dependencies.name)
    }
    func createRace(appName: String, path: String, resPath: String, packageName: String, uiSettings: UISettings, metaLoc: String, gradlePaths: GradlePaths) {
        fileHandler.writeFile(filePath: path, contentText: MBRace.fileContent(packageName: packageName, uiSettings: uiSettings), fileName: MBRace.fileName)
        fileHandler.writeFile(filePath: metaLoc, contentText: MetaHandler.fileContent(appName: appName, short: RaceMeta.getShortDesc(appName: appName), full: RaceMeta.getFullDesc(appName: appName), category: AppCategory.game_race.rawValue), fileName: MetaHandler.fileName)
        
        fileHandler.writeFile(filePath: gradlePaths.projectGradlePath, contentText: MBRace.gradle(packageName).projectBuildGradle.content, fileName: MBRace.gradle(packageName).projectBuildGradle.name)
        fileHandler.writeFile(filePath: gradlePaths.moduleGradlePath, contentText: MBRace.gradle(packageName).moduleBuildGradle.content, fileName: MBRace.gradle(packageName).moduleBuildGradle.name)
        fileHandler.writeFile(filePath: gradlePaths.dependenciesPath, contentText: MBRace.gradle(packageName).dependencies.content, fileName: MBRace.gradle(packageName).dependencies.name)
    }
    
    func createCatcher(appName: String, path: String, resPath: String, packageName: String, uiSettings: UISettings, metaLoc: String, gradlePaths: GradlePaths) {
        fileHandler.writeFile(filePath: path, contentText: MBCatcher.fileContent(packageName: packageName, uiSettings: uiSettings), fileName: MBCatcher.fileName)
        fileHandler.writeFile(filePath: metaLoc, contentText: MetaHandler.fileContent(appName: appName, short: CatcherMeta.getShortDesc(appName: appName), full: CatcherMeta.getFullDesc(appName: appName), category: AppCategory.game_arcade.rawValue), fileName: MetaHandler.fileName)
        
        fileHandler.writeFile(filePath: gradlePaths.projectGradlePath, contentText: MBCatcher.gradle(packageName).projectBuildGradle.content, fileName: MBCatcher.gradle(packageName).projectBuildGradle.name)
        fileHandler.writeFile(filePath: gradlePaths.moduleGradlePath, contentText: MBCatcher.gradle(packageName).moduleBuildGradle.content, fileName: MBCatcher.gradle(packageName).moduleBuildGradle.name)
        fileHandler.writeFile(filePath: gradlePaths.dependenciesPath, contentText: MBCatcher.gradle(packageName).dependencies.content, fileName: MBCatcher.gradle(packageName).dependencies.name)
    }
    
    func createBmi(appName: String, path: String, packageName: String, uiSettings: UISettings, metaLoc: String, gradlePaths: GradlePaths) {
        fileHandler.writeFile(filePath: path, contentText: MBBmi.fileContent(packageName: packageName, uiSettings: uiSettings), fileName: MBBmi.fileName)
        fileHandler.writeFile(filePath: metaLoc, contentText: MetaHandler.fileContent(appName: appName, short: BmiCalcMeta.getShortDesc(appName: appName), full: BmiCalcMeta.getFullDesc(appName: appName), category: AppCategory.app_tools.rawValue), fileName: MetaHandler.fileName)
        
        fileHandler.writeFile(filePath: gradlePaths.projectGradlePath, contentText: MBBmi.gradle(packageName).projectBuildGradle.content, fileName: MBBmi.gradle(packageName).projectBuildGradle.name)
        fileHandler.writeFile(filePath: gradlePaths.moduleGradlePath, contentText: MBBmi.gradle(packageName).moduleBuildGradle.content, fileName: MBBmi.gradle(packageName).moduleBuildGradle.name)
        fileHandler.writeFile(filePath: gradlePaths.dependenciesPath, contentText: MBBmi.gradle(packageName).dependencies.content, fileName: MBBmi.gradle(packageName).dependencies.name)
    }
    
    func createSpaceFighter(appName: String, path: String, resPath: String, packageName: String, uiSettings: UISettings, metaLoc: String, gradlePaths: GradlePaths) {
        fileHandler.writeFile(filePath: path, contentText: MBSpaceFighter.fileContent(packageName: packageName, uiSettings: uiSettings), fileName: MBSpaceFighter.fileName)
        fileHandler.writeFile(filePath: metaLoc, contentText: MetaHandler.fileContent(appName: appName, short: SpaceshipAdventureMeta.getShortDesc(appName: appName), full: SpaceshipAdventureMeta.getFullDesc(appName: appName), category: AppCategory.game_arcade.rawValue), fileName: MetaHandler.fileName)
        
        fileHandler.writeFile(filePath: gradlePaths.projectGradlePath, contentText: MBSpaceFighter.gradle(packageName).projectBuildGradle.content, fileName: MBSpaceFighter.gradle(packageName).projectBuildGradle.name)
        fileHandler.writeFile(filePath: gradlePaths.moduleGradlePath, contentText: MBSpaceFighter.gradle(packageName).moduleBuildGradle.content, fileName: MBSpaceFighter.gradle(packageName).moduleBuildGradle.name)
        fileHandler.writeFile(filePath: gradlePaths.dependenciesPath, contentText: MBSpaceFighter.gradle(packageName).dependencies.content, fileName: MBSpaceFighter.gradle(packageName).dependencies.name)
    }
    
    func createRickNMorty(appName: String, path: String, packageName: String, uiSettings: UISettings, metaLoc: String, gradlePaths: GradlePaths) {
        fileHandler.writeFile(filePath: path, contentText: MBRickNMorty.fileContent(packageName: packageName, uiSettings: uiSettings), fileName: MBRickNMorty.fileName)
        fileHandler.writeFile(filePath: metaLoc, contentText: MetaHandler.fileContent(appName: appName, short: RickNMortyMeta.getShortDesc(appName: appName), full: RickNMortyMeta.getFullDesc(appName: appName), category: AppCategory.app_entertainment.rawValue), fileName: MetaHandler.fileName)
        
        fileHandler.writeFile(filePath: gradlePaths.projectGradlePath, contentText: MBRickNMorty.gradle(packageName).projectBuildGradle.content, fileName: MBRickNMorty.gradle(packageName).projectBuildGradle.name)
        fileHandler.writeFile(filePath: gradlePaths.moduleGradlePath, contentText: MBRickNMorty.gradle(packageName).moduleBuildGradle.content, fileName: MBRickNMorty.gradle(packageName).moduleBuildGradle.name)
        fileHandler.writeFile(filePath: gradlePaths.dependenciesPath, contentText: MBRickNMorty.gradle(packageName).dependencies.content, fileName: MBRickNMorty.gradle(packageName).dependencies.name)
    }
    
    func createPassGen(appName: String, path: String, packageName: String, uiSettings: UISettings, metaLoc: String, gradlePaths: GradlePaths) {
        fileHandler.writeFile(filePath: path, contentText: MBPassGen.fileContent(packageName: packageName, uiSettings: uiSettings), fileName: MBPassGen.fileName)
        fileHandler.writeFile(filePath: metaLoc, contentText: MetaHandler.fileContent(appName: appName, short: PassGeneratorMeta.getShortDesc(appName: appName), full: PassGeneratorMeta.getFullDesc(appName: appName), category: AppCategory.app_tools.rawValue), fileName: MetaHandler.fileName)
        
        fileHandler.writeFile(filePath: gradlePaths.projectGradlePath, contentText: MBPassGen.gradle(packageName).projectBuildGradle.content, fileName: MBPassGen.gradle(packageName).projectBuildGradle.name)
        fileHandler.writeFile(filePath: gradlePaths.moduleGradlePath, contentText: MBPassGen.gradle(packageName).moduleBuildGradle.content, fileName: MBPassGen.gradle(packageName).moduleBuildGradle.name)
        fileHandler.writeFile(filePath: gradlePaths.dependenciesPath, contentText: MBPassGen.gradle(packageName).dependencies.content, fileName: MBPassGen.gradle(packageName).dependencies.name)
    }
    
    func createDeviceInfo(appName: String, path: String, packageName: String, uiSettings: UISettings, metaLoc: String, gradlePaths: GradlePaths) {
        fileHandler.writeFile(filePath: path, contentText: MBDeviceInfo.fileContent(packageName: packageName, uiSettings: uiSettings), fileName: MBDeviceInfo.fileName)
        fileHandler.writeFile(filePath: metaLoc, contentText: MetaHandler.fileContent(appName: appName, short: DeviceInfoMeta.getShortDesc(appName: appName), full: DeviceInfoMeta.getFullDesc(appName: appName), category: AppCategory.app_tools.rawValue), fileName: MetaHandler.fileName)
        
        fileHandler.writeFile(filePath: gradlePaths.projectGradlePath, contentText: MBDeviceInfo.gradle(packageName).projectBuildGradle.content, fileName: MBDeviceInfo.gradle(packageName).projectBuildGradle.name)
        fileHandler.writeFile(filePath: gradlePaths.moduleGradlePath, contentText: MBDeviceInfo.gradle(packageName).moduleBuildGradle.content, fileName: MBDeviceInfo.gradle(packageName).moduleBuildGradle.name)
        fileHandler.writeFile(filePath: gradlePaths.dependenciesPath, contentText: MBDeviceInfo.gradle(packageName).dependencies.content, fileName: MBDeviceInfo.gradle(packageName).dependencies.name)
    }
    
    func createHashGen(appName: String, path: String, packageName: String, uiSettings: UISettings, metaLoc: String, gradlePaths: GradlePaths) {
        fileHandler.writeFile(filePath: path, contentText: MBHashGen.fileContent(packageName: packageName, uiSettings: uiSettings), fileName: MBHashGen.fileName)
        fileHandler.writeFile(filePath: metaLoc, contentText: MetaHandler.fileContent(appName: appName, short: HashMeta.getShortDesc(appName: appName), full: HashMeta.getFullDesc(appName: appName), category: AppCategory.app_tools.rawValue), fileName: MetaHandler.fileName)
        
        fileHandler.writeFile(filePath: gradlePaths.projectGradlePath, contentText: MBHashGen.gradle(packageName).projectBuildGradle.content, fileName: MBHashGen.gradle(packageName).projectBuildGradle.name)
        fileHandler.writeFile(filePath: gradlePaths.moduleGradlePath, contentText: MBHashGen.gradle(packageName).moduleBuildGradle.content, fileName: MBHashGen.gradle(packageName).moduleBuildGradle.name)
        fileHandler.writeFile(filePath: gradlePaths.dependenciesPath, contentText: MBHashGen.gradle(packageName).dependencies.content, fileName: MBHashGen.gradle(packageName).dependencies.name)
    }
    
    func createSerials(appName: String, path: String, packageName: String, uiSettings: UISettings, metaLoc: String, gradlePaths: GradlePaths) {
        fileHandler.writeFile(filePath: path, contentText: MBSerials.fileContent(packageName: packageName, uiSettings: uiSettings), fileName: MBSerials.fileName)
        
        fileHandler.writeFile(filePath: gradlePaths.projectGradlePath, contentText: MBSerials.gradle(packageName).projectBuildGradle.content, fileName: MBSerials.gradle(packageName).projectBuildGradle.name)
        fileHandler.writeFile(filePath: gradlePaths.moduleGradlePath, contentText: MBSerials.gradle(packageName).moduleBuildGradle.content, fileName: MBSerials.gradle(packageName).moduleBuildGradle.name)
        fileHandler.writeFile(filePath: gradlePaths.dependenciesPath, contentText: MBSerials.gradle(packageName).dependencies.content, fileName: MBSerials.gradle(packageName).dependencies.name)
        
    }
}

//protocol MBAppProtocol {
//    func createMBApp(path: String, packageName: String, uiSettings: UISettings)
//    func createMBApp(path: String, packageName: String, resPath: String, uiSettings: UISettings)
//}
