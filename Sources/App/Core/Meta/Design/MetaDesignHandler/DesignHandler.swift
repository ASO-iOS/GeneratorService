//
//  File.swift
//  
//
//  Created by admin on 10.07.2023.
//

import Foundation

struct DesignHandler {
    
    static func getDesign(_ design: MetaDesignProtocol) -> DesignData {
        return DesignData(
            uiSettings: UISettings(
                backColorPrimary: design.backColorPrimary,
                backColorSecondary: design.backColorSecondary,
                surfaceColor: design.surfaceColor,
                onSurfaceColor: design.onSurfaceColor,
                primaryColor: design.primaryColor,
                onPrimaryColor: design.onPrimaryColor,
                errorColor: design.errorColor,
                textColorPrimary: design.textColorPrimary,
                textColorSecondary: design.textColorSecondary,
                buttonColorPrimary: design.buttonColorPrimary,
                buttonColorSecondary: design.buttonColorSecondary,
                buttonTextColorPrimary: design.buttonTextColorPrimary,
                buttonTextColorSecondary: design.buttonTextColorSecondary,
                paddingPrimary: design.paddingPrimary,
                paddingSecondary: design.paddingSecondary,
                textSizePrimary: design.textSizePrimary,
                textSizeSecondary: design.textSizeSecondary
            ),
            designLocation: MetaDesignLocation(
                iconLocation: design.iconLocation,
                bannerLocation: design.bannerLocation,
                screen1Location: design.screen1Location,
                screen2Location: design.screen2Location,
                screen3Location: design.screen3Location
            )
        )
    }
}

struct DesignData {
    var uiSettings: UISettings
    var designLocation: MetaDesignLocation
}

struct MetaDesignLocation {
    var iconLocation: String
    var bannerLocation: String
    var screen1Location: String
    var screen2Location: String
    var screen3Location: String
}
