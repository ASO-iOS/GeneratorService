//
//  File.swift
//  
//
//  Created by admin on 23.06.2023.
//

import Foundation

struct RequestDto: Codable {
    let appName: String
    let applicationName: String
    let packageName: String
    let gradleWrapper: String?
    let gradleVersion: String?
    let compileSdk: String?
    let minSdk: String?
    let targetSdk: String?
    let kotlin: String?
    let kotlinCoroutines: String?
    let hilt: String?
    let hiltViewmodelCompiler: String?
    let ktx: String?
    let lifecycle: String?
    let fragmentKtx: String?
    let appcompat: String?
    let material: String?
    let compose: String?
    let composeNavigation: String?
    let activityCompose: String?
    let composeHiltNav: String?
    let oneSignal: String?
    let glide: String?
    let swipe: String?
    let glideSkydoves: String?
    let retrofit: String?
    let okhttp: String?
    let room: String?
    let coil: String?
    let exp: String?
    let calend: String?
    let paging: String?
    let accompanist: String?
    let appBarColor: String?
    let screenOrientation: String?
    let prefix: String?
    let appId: String?
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
        case appName = "app_name"
        case applicationName = "application_name"
        case packageName = "package_name"
        case gradleWrapper = "gradle_wrapper"
        case gradleVersion = "gradle_version"
        case compileSdk = "compile_sdk"
        case minSdk = "min_sdk"
        case targetSdk = "target_sdk"
        case kotlin = "kotlin"
        case kotlinCoroutines = "kotlin_coroutines"
        case hilt = "hilt"
        case hiltViewmodelCompiler = "hilt_viewmodel_compiler"
        case ktx = "ktx"
        case lifecycle = "life_cycle"
        case fragmentKtx = "fragment_ktx"
        case appcompat = "appcompat"
        case material = "material"
        case compose = "compose"
        case composeNavigation = "compose_navigation"
        case activityCompose = "activity_compose"
        case composeHiltNav = "compose_hilt_nav"
        case oneSignal = "one_signal"
        case glide = "glide"
        case swipe = "swipe"
        case glideSkydoves = "glide_skydoves"
        case retrofit = "retrofit"
        case okhttp = "okhttp"
        case room = "room"
        case coil = "coil"
        case exp = "exp"
        case calend = "calend"
        case paging = "paging"
        case accompanist = "accompanist"
        case appBarColor = "app_bar_color"
        case screenOrientation = "screen_orientation"
        case prefix = "prefix"
        case appId = "app_id"
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
