//
//  File.swift
//  
//
//  Created by admin on 14.06.2023.
//

import SwiftUI

struct MBController {
    @ObservedObject var fileHandler: FileHandler
    
    func boot(
        id: String,
        path: String,
        pathRes: String,
        packageName: String,
        backColorPrimary : String,
        backColorSecondary : String,
        surfaceColor : String,
        onSurfaceColor : String,
        primaryColor : String,
        onPrimaryColor: String,
        errorColor : String,
        textColorPrimary : String,
        textColorSecondary : String,
        buttonColorPrimary : String,
        buttonColorSecondary : String,
        buttonTextColorPrimary : String,
        buttonTextColorSecondary : String,
        paddingPrimary: Int,
        paddingSecondary: Int,
        textSizePrimary: Int,
        textSizeSecondary: Int
    ) {
        switch id {
        case AppIDs.MB_STOPWATCH:
            createStopwatch(
                path: path,
                packageName: packageName,
                backColor: backColorPrimary,
                mainTextColor: textColorPrimary,
                mainTextSize: textSizePrimary,
                secondaryTextSize: textSizeSecondary,
                mainPadding: paddingPrimary,
                secondaryPadding: paddingSecondary,
                tertiaryPadding: paddingSecondary
            )
        case AppIDs.MB_SPEED_TEST:
            createSpeedTest(
                path: path,
                packageName: packageName,
                backColor: backColorPrimary,
                mainTextColor: textColorPrimary,
                mainButtonColor: buttonColorPrimary,
                lapTextColor: buttonTextColorSecondary,
                mainTextSize: textSizePrimary,
                buttonsBottomPadding: paddingPrimary
            )
        case AppIDs.MB_PING_TEST:
            createPingTest(
                path: path,
                packageName: packageName,
                backColor: backColorPrimary,
                mainTextColor: textColorPrimary,
                mainButtonColor: buttonColorPrimary,
                mainTextSize: textSizePrimary,
                buttonsBottomPadding: paddingPrimary
            )
        case AppIDs.MB_ALARM:
            createAlarm(
                path: path,
                resPath: pathRes,
                packageName: packageName,
                backColor: backColorPrimary,
                mainTextColor: textColorPrimary,
                mainButtonColor: buttonColorPrimary,
                mainTextSize: textSizePrimary,
                buttonsBottomPadding: paddingPrimary
            )
        case AppIDs.MB_FACTS:
            createFacts(
                path: path,
                packageName: packageName,
                backColorPrimary: backColorPrimary,
                backColorSecondary: backColorSecondary,
                textColor: textColorPrimary
            )
        case AppIDs.MB_TORCH:
            createTorch(
                path: path,
                packageName: packageName,
                backColorPrimary: backColorPrimary,
                backColorSecondary: backColorSecondary,
                surfaceColor: surfaceColor,
                onSurfaceColor: onSurfaceColor,
                primaryColor: primaryColor,
                onPrimaryColor: onPrimaryColor,
                errorColor: errorColor,
                textColorPrimary: textColorPrimary,
                textColorSecondary: textColorSecondary
            )
        case AppIDs.MB_LUCKY_NUMBER:
            createLuckyNumber(
                path: path,
                packageName: packageName,
                backColorPrimary: backColorPrimary,
                backColorSecondary: backColorSecondary,
                surfaceColor: surfaceColor,
                onSurfaceColor: onSurfaceColor,
                primaryColor: primaryColor,
                onPrimaryColor: onPrimaryColor,
                errorColor: errorColor,
                textColorPrimary: textColorPrimary,
                textColorSecondary: textColorSecondary
            )
        case AppIDs.MB_RACE:
            createRace(
                path: path,
                resPath: pathRes,
                packageName: packageName,
                backColorPrimary: backColorPrimary,
                backColorSecondary: backColorSecondary,
                textColorPrimary: textColorPrimary,
                buttonColor: buttonColorPrimary,
                buttonTextColor: buttonTextColorPrimary
            )
        case AppIDs.MB_CATCHER:
            createCatcher(
                path: path,
                resPath: pathRes,
                packageName: packageName,
                backColorPrimary: backColorPrimary,
                textColorPrimary: textColorPrimary,
                buttonColorPrimary: buttonColorPrimary,
                buttonColorSecondary: buttonColorSecondary,
                buttonTextColorPrimary: buttonTextColorPrimary
            )
        case AppIDs.MB_BMI_CALC_ID:
            createBmi(
                path: path,
                packageName: packageName,
                backColorPrimary: backColorPrimary,
                backColorSecondary: backColorSecondary,
                textColorPrimary: textColorPrimary,
                textColorSecondary: textColorSecondary,
                buttonColorPrimary: buttonColorPrimary,
                buttonTextColorPrimary: buttonTextColorPrimary
            )
        case AppIDs.MB_SPACE_FIGHTER:
            createSpaceFighter(
                path: path,
                packageName: packageName,
                resPath: pathRes,
                textColorPrimary: textColorPrimary,
                buttonTextColorPrimary: buttonTextColorPrimary,
                buttonColorPrimary: buttonColorPrimary
            )
        default:
            return
        }
    }
    
    func createStopwatch(
        path: String,
        packageName: String,
        backColor: String,
        mainTextColor: String,
        mainTextSize: Int,
        secondaryTextSize: Int,
        mainPadding: Int,
        secondaryPadding: Int,
        tertiaryPadding: Int
    ) {
        fileHandler.writeFile(filePath: path, contentText: MBStopwatch.fileContent(
            packageName: packageName,
            backColor: backColor,
            mainTextColor: mainTextColor,
            mainTextSize: mainTextSize,
            secondaryTextSize: secondaryTextSize,
            mainPadding: mainPadding,
            secondaryPadding: secondaryPadding,
            tertiaryPadding: tertiaryPadding
        ), fileName: MBStopwatch.fileName)
    }
    
    func createSpeedTest(
        path: String,
        packageName: String,
        backColor: String,
        mainTextColor: String,
        mainButtonColor: String,
        lapTextColor: String,
        mainTextSize: Int,
        buttonsBottomPadding: Int
    ) {
        fileHandler.writeFile(filePath: path, contentText: MBSpeedTest.fileContent(
            packageName: packageName,
            backColor: backColor,
            mainTextColor: mainTextColor,
            mainButtonColor: mainButtonColor,
            lapTextColor: lapTextColor,
            mainTextSize: mainTextSize,
            buttonsBottomPadding: buttonsBottomPadding
        ), fileName: MBSpeedTest.fileName)
    }
    
    func createPingTest(
        path: String,
        packageName: String,
        backColor: String,
        mainTextColor: String,
        mainButtonColor: String,
        mainTextSize: Int,
        buttonsBottomPadding: Int
    ) {
        fileHandler.writeFile(filePath: path, contentText: MBPingTest.fileContent(packageName: packageName, backColor: backColor, mainTextColor: mainTextColor, mainButtonColor: mainButtonColor, mainTextSize: mainTextSize, buttonsBottomPadding: buttonsBottomPadding), fileName: MBPingTest.fileName)
    }
    
    func createAlarm(
        path: String,
        resPath: String,
        packageName: String,
        backColor: String,
        mainTextColor: String,
        mainButtonColor: String,
        mainTextSize: Int,
        buttonsBottomPadding: Int
    ) {
        fileHandler.writeFile(filePath: path, contentText: MBAlarm.fileContent(packageName: packageName, backColor: backColor, mainTextColor: mainTextColor, mainButtonColor: mainButtonColor, mainTextSize: mainTextSize, buttonsBottomPadding: buttonsBottomPadding), fileName: MBAlarm.fileName)
        fileHandler.writeFile(filePath: resPath, contentText: MBAlarmRes.alarmText(), fileName: MBAlarmRes.alarmName)
    }
    
    func createIpChecker() {
        
    }
    
    func createFacts(
        path: String,
        packageName: String,
        backColorPrimary: String,
        backColorSecondary: String,
        textColor: String
    ) {
        fileHandler.writeFile(filePath: path, contentText: MBFacts.fileContent(packageName: packageName, backColorPrimary: backColorPrimary, backColorSecondary: backColorSecondary, textColor: textColor), fileName: MBFacts.fileName)
    }
    
    func createTorch(
        path: String,
        packageName: String,
        backColorPrimary: String,
        backColorSecondary: String,
        surfaceColor: String,
        onSurfaceColor: String,
        primaryColor: String,
        onPrimaryColor: String,
        errorColor: String,
        textColorPrimary: String,
        textColorSecondary: String
    ) {
        fileHandler.writeFile(filePath: path, contentText: MBTorch.fileContent(
            packageName: packageName,
            backColorPrimary: backColorPrimary,
            backColorSecondary: backColorSecondary,
            surfaceColor: surfaceColor,
            onSurfaceColor: onSurfaceColor,
            primaryColor: primaryColor,
            onPrimaryColor: onPrimaryColor,
            errorColor: errorColor,
            textColorPrimary: textColorPrimary,
            textColorSecondary: textColorSecondary
        ), fileName: MBTorch.fileName)
    }
    
    func createLuckyNumber(
        path: String,
        packageName: String,
        backColorPrimary: String,
        backColorSecondary: String,
        surfaceColor: String,
        onSurfaceColor: String,
        primaryColor: String,
        onPrimaryColor: String,
        errorColor: String,
        textColorPrimary: String,
        textColorSecondary: String
    ) {
        fileHandler.writeFile(filePath: path, contentText: MBLuckyNumber.fileContent(
            packageName: packageName,
            backColorPrimary: backColorPrimary,
            backColorSecondary: backColorSecondary,
            surfaceColor: surfaceColor,
            onSurfaceColor: onSurfaceColor,
            primaryColor: primaryColor,
            onPrimaryColor: onPrimaryColor,
            errorColor: errorColor,
            textColorPrimary: textColorPrimary,
            textColorSecondary: textColorSecondary
        ), fileName: MBLuckyNumber.fileName)
    }
    func createRace(
        path: String,
        resPath: String,
        packageName: String,
        backColorPrimary: String,
        backColorSecondary: String,
        textColorPrimary: String,
        buttonColor: String,
        buttonTextColor: String
    ) {
        fileHandler.writeFile(filePath: path, contentText: MBRace.fileContent(
            packageName: packageName,
            backColorPrimary: backColorPrimary,
            backColorSecondary: backColorSecondary,
            textColorPrimary: textColorPrimary,
            buttonColor: buttonColor,
            buttonTextColor: buttonTextColor
        ), fileName: MBRace.fileName)
        let playerImage = Int.random(in: 1...7)
        let enemyImage = Int.random(in: 1...7)
        let backgroundImage = Int.random(in: 1...7)
        fileHandler.copyPaste(from: LocalConst.MBRaceRes + "/\(playerImage)/" + "player.png" , to: resPath + "player.png")
        fileHandler.copyPaste(from: LocalConst.MBRaceRes + "/\(enemyImage)/" + "enemy_car.png" , to: resPath + "enemy_car.png")
        fileHandler.copyPaste(from: LocalConst.MBRaceRes + "/\(backgroundImage)/" + "background.png" , to: resPath + "background.png")
    }
    
    func createCatcher(
        path: String,
        resPath: String,
        packageName: String,
        backColorPrimary: String,
        textColorPrimary: String,
        buttonColorPrimary: String,
        buttonColorSecondary: String,
        buttonTextColorPrimary: String
    ) {
        fileHandler.writeFile(filePath: path, contentText: MBCatcher.fileContent(
            packageName: packageName,
            backColorPrimary: backColorPrimary,
            textColorPrimary: textColorPrimary,
            buttonColorPrimary: buttonColorPrimary,
            buttonColorSecondary: buttonColorSecondary,
            buttonTextColorPrimary: buttonTextColorPrimary
        ), fileName: MBCatcher.fileName)
        let objectImage = Int.random(in: 1...4)
        let cartImage = Int.random(in: 1...4)
        let backgroundImage = Int.random(in: 1...4)
        fileHandler.copyPaste(from: LocalConst.MBCatcherRes + "/\(objectImage)/" + "object.png" , to: resPath + "object.png")
        fileHandler.copyPaste(from: LocalConst.MBCatcherRes + "/\(cartImage)/" + "cart.png" , to: resPath + "cart.png")
        fileHandler.copyPaste(from: LocalConst.MBCatcherRes + "/\(backgroundImage)/" + "background.png" , to: resPath + "background.png")
    }
    
    func createBmi(
        path: String,
        packageName: String,
        backColorPrimary: String,
        backColorSecondary: String,
        textColorPrimary: String,
        textColorSecondary: String,
        buttonColorPrimary: String,
        buttonTextColorPrimary: String
    ) {
        fileHandler.writeFile(filePath: path, contentText: MBBmi.fileContent(
            packageName: packageName,
            backColorPrimary: backColorPrimary,
            backColorSecondary: backColorSecondary,
            textColorPrimary: textColorPrimary,
            textColorSecondary: textColorSecondary,
            buttonColorPrimary: buttonColorPrimary,
            buttonTextColorPrimary: buttonTextColorPrimary
        ), fileName: MBBmi.fileName)
    }
    
    func createSpaceFighter(
        path: String,
        packageName: String,
        resPath: String,
        textColorPrimary: String,
        buttonTextColorPrimary: String,
        buttonColorPrimary: String
    ) {
        fileHandler.writeFile(filePath: path, contentText: MBSpaceFighter.fileContent(
            packageNamw: packageName,
            textColorPrimary: textColorPrimary,
            buttonTextColorPrimary: buttonColorPrimary,
            buttonColorPrimary: buttonColorPrimary
        ), fileName: MBSpaceFighter.fileName)
        let backgroundImage = Int.random(in: 1...20)
        let playerImage = Int.random(in: 1...33)
        let enemyImage = Int.random(in: 1...36)
        fileHandler.copyPaste(from: LocalConst.MBSpaceFighterRes + "/\(playerImage)/player.png", to: resPath + "player.png")
        fileHandler.copyPaste(from: LocalConst.MBSpaceFighterRes + "/\(enemyImage)/enemy.png", to: resPath + "enemy.png")
        fileHandler.copyPaste(from: LocalConst.MBSpaceFighterRes + "/\(backgroundImage)/background.png", to: resPath + "background.png")
    }
}
