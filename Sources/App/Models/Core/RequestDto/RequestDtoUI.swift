//
//  File.swift
//  
//
//  Created by admin on 29.06.2023.
//

import Foundation

struct RequestDtoUI: Codable {
    
    let appBarColor: String?
    let screenOrientation: String?
    let backColorPrimary: String?
    let backColorSecondary: String?
    let surfaceColor: String?
    let onSurfaceColor: String?
    let primaryColor: String?
    let onPrimaryColor: String?
    let errorColor: String?
    let textColorPrimary: String?
    let textColorSecondary: String?
    let buttonColorPrimary: String?
    let buttonColorSecondary: String?
    let buttonTextColorPrimaty: String?
    let buttonTextColorSecondary: String?
    let paddingPrimary: Int?
    let paddingSecondary: Int?
    let textSizePrimary: Int?
    let textSizeSecondary: Int?
    
    enum CodingKeys: String, CodingKey {
        case appBarColor = "app_bar_color"
        case screenOrientation = "screen_orientation"
        case backColorPrimary = "back_color_primary"
        case backColorSecondary = "back_color_secondary"
        case textColorPrimary = "text_color_primary"
        case textColorSecondary = "text_color_secondary"
        case buttonColorPrimary = "button_color_primary"
        case buttonColorSecondary = "button_color_secondary"
        case buttonTextColorPrimaty = "button_text_color_primaty"
        case buttonTextColorSecondary = "button_text_color_secondary"
        case paddingPrimary = "padding_primary"
        case paddingSecondary = "padding_secondary"
        case textSizePrimary = "text_size_primary"
        case textSizeSecondary = "text_size_secondary"
        case surfaceColor = "surface_color"
        case onSurfaceColor = "on_surface_color"
        case primaryColor = "primary_color"
        case onPrimaryColor = "on_primary_color"
        case errorColor = "error_color"
    }
}
