//
//  File.swift
//  
//
//  Created by admin on 26.05.2023.
//

import Foundation

struct BuildGradleApp {
    static let fileName = "build.gradle"
    static func fileContent(
        appId: String
    ) -> String {
        return """
import dependencies.Versions
import dependencies.Application
import dependencies.Dependencies

apply plugin: 'com.android.application'
apply plugin: 'org.jetbrains.kotlin.android'
apply plugin: 'kotlin-kapt'
apply plugin: 'dagger.hilt.android.plugin'

android {
    namespace Application.id
    compileSdk Versions.compilesdk

    defaultConfig {
        applicationId Application.id
        minSdk Versions.minsdk
        targetSdk Versions.targetsdk
        versionCode Application.version_code
        versionName Application.version_name

        testInstrumentationRunner "androidx.test.runner.AndroidJUnitRunner"
        vectorDrawables {
            useSupportLibrary true
        }
    }

    buildTypes {
        release {
            \(useObfuscation(appId))
            proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'), 'proguard-rules.pro'
        }
    }
    compileOptions {
        sourceCompatibility JavaVersion.VERSION_17
        targetCompatibility JavaVersion.VERSION_17
    }
    kotlinOptions {
        jvmTarget = '17'
    }
    buildFeatures {
        compose true
        dataBinding true
        viewBinding true
    }
    composeOptions {
        kotlinCompilerExtensionVersion compose_version
    }
    bundle {
        storeArchive {
            enable = false
        }
    }
}

dependencies {

    implementation Dependencies.core_ktx
    implementation Dependencies.appcompat
    implementation Dependencies.material
    implementation Dependencies.compose_ui
    implementation Dependencies.compose_material
    implementation Dependencies.compose_preview
    implementation Dependencies.compose_material3
    implementation Dependencies.compose_activity
    implementation Dependencies.compose_ui_tooling
    implementation Dependencies.compose_navigation
    implementation Dependencies.compose_hilt_nav
    implementation Dependencies.compose_foundation
    implementation Dependencies.compose_runtime
    implementation Dependencies.compose_runtime_livedata
    implementation Dependencies.compose_mat_icons_core
    implementation Dependencies.compose_mat_icons_core_extended
    implementation Dependencies.coroutines
    implementation Dependencies.fragment_ktx
    implementation Dependencies.lifecycle_viewmodel
    implementation Dependencies.lifecycle_runtime
    implementation Dependencies.dagger_hilt
    kapt Dependencies.dagger_hilt_compiler
    kapt Dependencies.hilt_viewmodel_compiler
    implementation Dependencies.compose_system_ui_controller
    implementation Dependencies.compose_permissions
    implementation 'androidx.work:work-runtime-ktx:2.8.1'
    implementation 'androidx.navigation:navigation-fragment:2.6.0'
    \(depsById(appId))
}
"""
    }
    
    static func depsById(_ id: String) -> String {
        switch id {
        case AppIDs.VS_STOPWATCH_ID:
            return ""
        case AppIDs.VS_TORCH_ID, AppIDs.VS_PHONE_INFO_ID:
            return """
    implementation 'io.github.g00fy2.quickie:quickie-bundled:1.6.0'
    implementation 'androidx.datastore:datastore-preferences:1.0.0'
    coreLibraryDesugaring 'com.android.tools:desugar_jdk_libs:2.0.3'
"""
        case AppIDs.MB_ALARM:
            return """
    implementation Dependencies.room_runtime
    kapt Dependencies.room_compiler
    implementation Dependencies.room_ktx
"""
        case AppIDs.MB_FACTS:
            return """
    implementation Dependencies.okhttp
    implementation Dependencies.okhttp_login_interceptor
    implementation Dependencies.retrofit
    implementation Dependencies.converter_gson
"""
        case AppIDs.VS_PHONE_INFO_ID:
            return """
    implementation Dependencies.okhttp
    implementation Dependencies.okhttp_login_interceptor
    implementation Dependencies.retrofit
    implementation Dependencies.converter_gson
"""
        default:
            return ""
        }
    }
    
    static func useObfuscation(_ id: String) -> String {
        switch id {
        case AppIDs.MB_FACTS:
            return ""
        default:
            return """
            minifyEnabled true
            shrinkResources true
"""
        }
    }
}


//\(useRetrofit ? "implementation Dependencies.retrofit" : "")
//\(useRetrofit ? "implementation Dependencies.converter_gson" : "")
//\(useRetrofit ? "implementation Dependencies.okhttp" : "")
//\(useRetrofit ? "implementation Dependencies.okhttp_login_interceptor" : "")
//\(useRoom ? "implementation Dependencies.room_runtime" : "")
//\(useRoom ? "kapt Dependencies.room_compiler" : "")
//\(useRoom ? "implementation Dependencies.room_ktx" : "")
//\(useRoom ? "implementation Dependencies.roomPaging" : "")
//\(useOneSignal ? "implementation Dependencies.onesignal" : "")
//\(useGlide ? "implementation Dependencies.glide" : "")
//\(useGlide ? "implementation Dependencies.glide_compiler" : "")
//\(useGlide ? "implementation Dependencies.glide_skydoves" : "")
//\(useSwipeToRefresh ? "implementation Dependencies.swipe_to_refresh" : "")
//\(useCoil ? "implementation Dependencies.coil_compose" : "")
//\(useCoil ? "implementation Dependencies.coil_svg" : "")
//\(useExpression ? "implementation Dependencies.expression" : "")
//\(useCalendar ? "implementation Dependencies.calendar" : "")
//\(useCalendar ? "implementation Dependencies.calendar_date" : "")
//\(useReferrer ? "implementation(\"com.android.installreferrer:installreferrer:2.2\")" : "")
//\(useAppsflyer ? "implementation 'com.appsflyer:af-android-sdk:6.9.0'" : "")
//\(useRemoteConfig ? "implementation platform('com.google.firebase:firebase-bom:31.2.0')" : "")
//\(useRemoteConfig ? "implementation 'com.google.firebase:firebase-config-ktx'" : "")
//\(useRemoteConfig ? "implementation 'com.google.firebase:firebase-analytics-ktx'" : "")
//\(usePaging ? """
//implementation Dependencies.paging
//implementation Dependencies.pagingCommon
//implementation Dependencies.pagingCompose
//""" : "")
//\(useQr ? """
//implementation 'io.github.g00fy2.quickie:quickie-bundled:1.6.0'
//coreLibraryDesugaring 'com.android.tools:desugar_jdk_libs:2.0.3'
//""" : "")
