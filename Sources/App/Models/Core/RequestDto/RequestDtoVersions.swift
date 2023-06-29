//
//  File.swift
//  
//
//  Created by admin on 29.06.2023.
//

import Foundation

struct RequestDtoVersions: Codable {
    
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
    
    enum CodingKeys: String, CodingKey {
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
    }
}
