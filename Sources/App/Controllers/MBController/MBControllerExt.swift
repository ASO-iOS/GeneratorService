//
//  File.swift
//  
//
//  Created by admin on 02.07.2023.
//

import Foundation

extension MBController {
    func createStopwatch(appName: String, path: String, packageName: String, uiSettings: UISettings, metaLoc: String) {
        fileHandler.writeFile(filePath: path, contentText: MBStopwatch.fileContent(packageName: packageName, uiSettings: uiSettings), fileName: MBStopwatch.fileName)
//        fileHandler.writeFile(filePath: metaLoc, contentText: MetaHandler.fileContent(appName: appName, short: <#T##String#>, full: <#T##String#>, category: <#T##String#>), fileName: "Meta.txt")
    }
    
    func createSpeedTest(appName: String, path: String, packageName: String, uiSettings: UISettings, metaLoc: String) {
        fileHandler.writeFile(filePath: path, contentText: MBSpeedTest.fileContent(packageName: packageName, uiSettings: uiSettings), fileName: MBSpeedTest.fileName)
//        fileHandler.writeFile(filePath: metaLoc, contentText: <#T##String#>, fileName: "Meta.txt")
    }
    
    func createPingTest(appName: String, path: String, packageName: String, uiSettings: UISettings, metaLoc: String) {
        fileHandler.writeFile(filePath: path, contentText: MBPingTest.fileContent(packageName: packageName, uiSettings: uiSettings), fileName: MBPingTest.fileName)
//        fileHandler.writeFile(filePath: metaLoc, contentText: <#T##String#>, fileName: "Meta.txt")
    }
    
    func createAlarm(appName: String, path: String, resPath: String, packageName: String, uiSettings: UISettings, metaLoc: String) {
        fileHandler.writeFile(filePath: path, contentText: MBAlarm.fileContent(packageName: packageName, uiSettings: uiSettings), fileName: MBAlarm.fileName)
        fileHandler.writeFile(filePath: resPath, contentText: MBAlarmRes.alarmText(), fileName: MBAlarmRes.alarmName)
//        fileHandler.writeFile(filePath: metaLoc, contentText: <#T##String#>, fileName: "Meta.txt")
    }
    
    func createIpChecker(appName: String, path: String, packageName: String, uiSettings: UISettings, metaLoc: String) {
        fileHandler.writeFile(filePath: path, contentText: MBIpChecker.fileContent(packageName: packageName, uiSettings: uiSettings), fileName: MBIpChecker.fileName)
        fileHandler.writeFile(filePath: metaLoc, contentText: MetaHandler.fileContent(appName: appName, short: IpCheckerMeta.getShortDesc(), full: IpCheckerMeta.getFullDesc(), category: AppCategory.app_tools.rawValue), fileName: MetaHandler.fileName)
    }
    
    func createFacts(appName: String, path: String, packageName: String, uiSettings: UISettings, metaLoc: String) {
        fileHandler.writeFile(filePath: path, contentText: MBFacts.fileContent(packageName: packageName, uiSettings: uiSettings), fileName: MBFacts.fileName)
//        fileHandler.writeFile(filePath: metaLoc, contentText: <#T##String#>, fileName: "Meta.txt")
    }
    
    func createTorch(appName: String, path: String, packageName: String, uiSettings: UISettings, metaLoc: String) {
        fileHandler.writeFile(filePath: path, contentText: MBTorch.fileContent(packageName: packageName, uiSettings: uiSettings), fileName: MBTorch.fileName)
        fileHandler.writeFile(filePath: metaLoc, contentText: MetaHandler.fileContent(appName: appName, short: TorchMeta.getShortDesc(), full: TorchMeta.getFullDesc(), category: AppCategory.app_tools.rawValue), fileName: MetaHandler.fileName)
    }
    
    func createLuckyNumber(appName: String, path: String, packageName: String, uiSettings: UISettings, metaLoc: String) {
        fileHandler.writeFile(filePath: path, contentText: MBLuckyNumber.fileContent(packageName: packageName, uiSettings: uiSettings), fileName: MBLuckyNumber.fileName)
//        fileHandler.writeFile(filePath: metaLoc, contentText: <#T##String#>, fileName: "Meta.txt")
    }
    func createRace(appName: String, path: String, resPath: String, packageName: String, uiSettings: UISettings, metaLoc: String) {
        fileHandler.writeFile(filePath: path, contentText: MBRace.fileContent(packageName: packageName, uiSettings: uiSettings), fileName: MBRace.fileName)
        let playerImage = Int.random(in: 1...7)
        let enemyImage = Int.random(in: 1...7)
        let backgroundImage = Int.random(in: 1...7)
        fileHandler.copyPaste(from: LocalConst.MBRaceRes + "/\(playerImage)/" + "player.png" , to: resPath + "player.png")
        fileHandler.copyPaste(from: LocalConst.MBRaceRes + "/\(enemyImage)/" + "enemy_car.png" , to: resPath + "enemy_car.png")
        fileHandler.copyPaste(from: LocalConst.MBRaceRes + "/\(backgroundImage)/" + "background.png" , to: resPath + "background.png")
//        fileHandler.writeFile(filePath: metaLoc, contentText: <#T##String#>, fileName: "Meta.txt")
    }
    
    func createCatcher(appName: String, path: String, resPath: String, packageName: String, uiSettings: UISettings, metaLoc: String) {
        fileHandler.writeFile(filePath: path, contentText: MBCatcher.fileContent(packageName: packageName, uiSettings: uiSettings), fileName: MBCatcher.fileName)
        let objectImage = Int.random(in: 1...4)
        let cartImage = Int.random(in: 1...4)
        let backgroundImage = Int.random(in: 1...4)
        fileHandler.copyPaste(from: LocalConst.MBCatcherRes + "/\(objectImage)/" + "object.png" , to: resPath + "object.png")
        fileHandler.copyPaste(from: LocalConst.MBCatcherRes + "/\(cartImage)/" + "cart.png" , to: resPath + "cart.png")
        fileHandler.copyPaste(from: LocalConst.MBCatcherRes + "/\(backgroundImage)/" + "background.png" , to: resPath + "background.png")
//        fileHandler.writeFile(filePath: metaLoc, contentText: <#T##String#>, fileName: "Meta.txt")
    }
    
    func createBmi(appName: String, path: String, packageName: String, uiSettings: UISettings, metaLoc: String) {
        fileHandler.writeFile(filePath: path, contentText: MBBmi.fileContent(packageName: packageName, uiSettings: uiSettings), fileName: MBBmi.fileName)
//        fileHandler.writeFile(filePath: metaLoc, contentText: <#T##String#>, fileName: "Meta.txt")
    }
    
    func createSpaceFighter(appName: String, path: String, resPath: String, packageName: String, uiSettings: UISettings, metaLoc: String) {
        fileHandler.writeFile(filePath: path, contentText: MBSpaceFighter.fileContent(packageName: packageName, uiSettings: uiSettings), fileName: MBSpaceFighter.fileName)
        let backgroundImage = Int.random(in: 1...20)
        let playerImage = Int.random(in: 1...33)
        let enemyImage = Int.random(in: 1...36)
        fileHandler.copyPaste(from: LocalConst.MBSpaceFighterRes + "/player/\(playerImage)/player.png", to: resPath + "player.png")
        fileHandler.copyPaste(from: LocalConst.MBSpaceFighterRes + "/enemy/\(enemyImage)/enemy.png", to: resPath + "enemy.png")
        fileHandler.copyPaste(from: LocalConst.MBSpaceFighterRes + "/background/\(backgroundImage)/background.png", to: resPath + "background.png")
        fileHandler.writeFile(filePath: metaLoc, contentText: MetaHandler.fileContent(appName: appName, short: SpaceshipAdventureMeta.getShortDesc(), full: SpaceshipAdventureMeta.getFullDesc(), category: AppCategory.game_arcade.rawValue), fileName: MetaHandler.fileName)
    }
    
    func createRickNMorty(appName: String, path: String, packageName: String, uiSettings: UISettings, metaLoc: String) {
        fileHandler.writeFile(filePath: path, contentText: MBRickNMorty.fileContent(packageName: packageName, uiSettings: uiSettings), fileName: MBRickNMorty.fileName)
//        fileHandler.writeFile(filePath: metaLoc, contentText: <#T##String#>, fileName: "Meta.txt")
    }
    
    func createPassGen(appName: String, path: String, packageName: String, uiSettings: UISettings, metaLoc: String) {
        fileHandler.writeFile(filePath: path, contentText: MBPassGen.fileContent(packageName: packageName, uiSettings: uiSettings), fileName: MBPassGen.fileName)
        fileHandler.writeFile(filePath: metaLoc, contentText: MetaHandler.fileContent(appName: appName, short: PassGeneratorMeta.getShortDesc(), full: PassGeneratorMeta.getFullDesc(), category: AppCategory.app_tools.rawValue), fileName: MetaHandler.fileName)
    }
    
    func createDeviceInfo(appName: String, path: String, packageName: String, uiSettings: UISettings, metaLoc: String) {
        fileHandler.writeFile(filePath: path, contentText: MBDeviceInfo.fileContent(packageName: packageName, uiSettings: uiSettings), fileName: MBDeviceInfo.fileName)
//        fileHandler.writeFile(filePath: metaLoc, contentText: MetaHandler.fileContent(appName: appName, short: <#T##String#>, full: <#T##String#>, category: <#T##String#>), fileName: <#T##String#>)
    }
}

//protocol MBAppProtocol {
//    func createMBApp(path: String, packageName: String, uiSettings: UISettings)
//    func createMBApp(path: String, packageName: String, resPath: String, uiSettings: UISettings)
//}
