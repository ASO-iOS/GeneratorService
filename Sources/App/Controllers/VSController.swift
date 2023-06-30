//
//  File.swift
//  
//
//  Created by admin on 06.06.2023.
//

import SwiftUI

struct VSController {
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
        buttonTextColorPrimaty : String,
        buttonTextColorSecondary : String,
        paddingPrimary: Int,
        paddingSecondary: Int,
        textSizePrimary: Int,
        textSizeSecondary: Int
    ) {
        switch id {
        case AppIDs.VS_STOPWATCH_ID:
            createStopwatch(
                path: path,
                packageName: packageName,
                backColor: backColorPrimary,
                buttonColor: buttonColorPrimary,
                buttonTextColor: buttonTextColorPrimaty,
                mainTextColor: textColorPrimary
            )
        case AppIDs.VS_TORCH_ID:
            createTorch(
                path: path,
                pathRes: pathRes,
                packageName: packageName,
                backColor: backColorPrimary,
                buttonColor: buttonColorPrimary,
                buttonTextColor: buttonTextColorPrimaty,
                outlineButtonColor: buttonColorSecondary
            )
        case AppIDs.VS_PHONE_INFO_ID:
            createPhoneInfo(
                path: path,
                packageName: packageName,
                pathRes: pathRes,
                backColorPrimary : backColorPrimary,
                backColorSecondary : backColorSecondary,
                surfaceColor : surfaceColor,
                onSurfaceColor : onSurfaceColor,
                primaryColor : primaryColor,
                onPrimaryColor: onPrimaryColor,
                errorColor : errorColor,
                textColorPrimary : textColorPrimary,
                textColorSecondary : textColorSecondary,
                buttonColorPrimary : buttonColorPrimary,
                buttonColorSecondary : buttonColorSecondary,
                buttonTextColorPrimaty : buttonTextColorPrimaty,
                buttonTextColorSecondary : buttonTextColorSecondary
                )
        default:
            return
        }
    }
    
    func createStopwatch(
        path: String,
        packageName: String,
        backColor: String,
        buttonColor: String,
        buttonTextColor: String,
        mainTextColor: String
    ) {
        fileHandler.writeFile(filePath: path, contentText: VSStopwatch.fileContent(
            packageName: packageName,
            backColor: backColor,
            buttonColor: buttonColor,
            buttonTextColor: buttonTextColor,
            mainTextColor: mainTextColor
        ), fileName: VSStopwatch.fileName)
    }
    
    func createTorch(
        path: String,
        pathRes: String,
        packageName: String,
        backColor: String,
        buttonColor: String,
        buttonTextColor: String,
        outlineButtonColor: String
    ) {
        fileHandler.writeFile(filePath: path, contentText: VSTorch.fileContent(
            packageName: packageName,
            backColor: backColor,
            buttonColor: buttonColor,
            outlineButtonBorderColor: outlineButtonColor
        ), fileName: VSTorch.fileName)
        fileHandler.writeFile(filePath: pathRes, contentText: VSTorchXmlRes.onIconFileText(buttonColor: buttonColor), fileName: VSTorchXmlRes.onIconFileName)
        fileHandler.writeFile(filePath: pathRes, contentText: VSTorchXmlRes.off1FileText(backColor: buttonTextColor, buttonColor: buttonColor), fileName: VSTorchXmlRes.off1FileName)
        fileHandler.writeFile(filePath: pathRes, contentText: VSTorchXmlRes.off3FileText(backColor: buttonTextColor, buttonColor: buttonColor), fileName: VSTorchXmlRes.off3FileName)
        fileHandler.writeFile(filePath: pathRes, contentText: VSTorchXmlRes.on1FileText(backColor: buttonTextColor, buttonColor: buttonColor), fileName: VSTorchXmlRes.on1FileName)
        fileHandler.writeFile(filePath: pathRes, contentText: VSTorchXmlRes.on3FileText(backColor: buttonTextColor, buttonColor: buttonColor), fileName: VSTorchXmlRes.on3FileName)
    }
    
    func createPhoneInfo(
        path: String,
        packageName: String,
        pathRes: String,
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
        buttonTextColorPrimaty : String,
        buttonTextColorSecondary : String
    ) {
        fileHandler.writeFile(filePath: path, contentText: VSPhoneInfo.fileContent(
            packageName: packageName,
            backColorLight: backColorPrimary,
            primaryColorLight: primaryColor,
            onPrimaryColorLight: primaryColor,
            secondaryColorLight: primaryColor,
            onSecondaryColorLight: primaryColor,
            tertiaryColorLight: primaryColor,
            onTertiaryColorLight: primaryColor,
            surfaceColorLight: surfaceColor,
            onSurfaceColorLight: onSurfaceColor,
            onBackgroundColorLight: backColorPrimary,
            backColorDark: backColorSecondary,
            primaryColorDark: primaryColor,
            onPrimaryColorDark: primaryColor,
            secondaryColorDark: primaryColor,
            onSecondaryColorDark: primaryColor,
            tertiaryColorDark: primaryColor,
            onTertiaryColorDark: primaryColor,
            surfaceColorDark: surfaceColor,
            onSurfaceColorDark: onSurfaceColor,
            onBackgroundColorDark: backColorPrimary
        ), fileName: VSPhoneInfo.fileName)
        fileHandler.writeFile(filePath: pathRes, contentText: VSPhoneInfoRes.nothingFoundText(color: onSurfaceColor), fileName: VSPhoneInfoRes.nothingFoundName)
        fileHandler.writeFile(filePath: pathRes, contentText: VSPhoneInfoRes.imgPhoneText(color: onSurfaceColor), fileName: VSPhoneInfoRes.imgPhoneName)
    }
}
