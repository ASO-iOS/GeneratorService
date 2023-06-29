//
//  File.swift
//  
//
//  Created by admin on 26.05.2023.
//

import Foundation

struct BuildSrc {
    static func bSrcApplication(packageName: String) -> String {
        return """
package dependencies

object Application {
    const val id = "\(packageName)"
    const val version_code = 1
    const val version_name = "1.0"
}
"""
    }
    
    static func bSrcBuild() -> String {
        return """
package dependencies

object Build {
    const val build_tools = "com.android.tools.build:gradle:${Versions.gradle}"
    const val kotlin_gradle_plugin = "org.jetbrains.kotlin:kotlin-gradle-plugin:${Versions.kotlin}"
    const val hilt_plugin = "com.google.dagger:hilt-android-gradle-plugin:${Versions.hilt}"
}
"""
    }
    
    static func bSrcDependencies() -> String {
        return """
package dependencies

object Dependencies {
    const val core_ktx = "androidx.core:core-ktx:${Versions.ktx}"
    const val appcompat = "androidx.appcompat:appcompat:${Versions.appcompat}"
    const val material = "com.google.android.material:material:${Versions.material}"

    const val compose_ui = "androidx.compose.ui:ui:${Versions.compose}"
    const val compose_material = "androidx.compose.material:material:${Versions.compose}"
    const val compose_preview = "androidx.compose.ui:ui-tooling-preview:${Versions.compose}"
    const val compose_activity = "androidx.activity:activity-compose:${Versions.activity_compose}"
    const val compose_ui_tooling = "androidx.compose.ui:ui-tooling:${Versions.compose}"
    const val compose_navigation = "androidx.navigation:navigation-compose:${Versions.compose_navigation}"
    const val compose_hilt_nav = "androidx.hilt:hilt-navigation-compose:${Versions.compose_hilt_nav}"
    const val compose_foundation = "androidx.compose.foundation:foundation:${Versions.compose}"
    const val compose_runtime = "androidx.compose.runtime:runtime:${Versions.compose}"
    const val compose_material3 = "androidx.compose.material3:material3:1.1.0-rc01"
    const val compose_runtime_livedata = "androidx.compose.runtime:runtime-livedata:${Versions.compose}"
    const val compose_mat_icons_core = "androidx.compose.material:material-icons-core:${Versions.compose}"
    const val compose_mat_icons_core_extended = "androidx.compose.material:material-icons-extended:${Versions.compose}"

    const val coroutines = "org.jetbrains.kotlinx:kotlinx-coroutines-android:${Versions.kotlin_coroutines}"
    const val fragment_ktx = "androidx.fragment:fragment-ktx:${Versions.fragment_ktx}"
    const val compose_system_ui_controller = "com.google.accompanist:accompanist-systemuicontroller:${Versions.accompanist}"
    const val compose_permissions = "com.google.accompanist:accompanist-permissions:${Versions.accompanist}"

    const val lifecycle_viewmodel = "androidx.lifecycle:lifecycle-viewmodel-ktx:${Versions.lifecycle}"
    const val lifecycle_runtime = "androidx.lifecycle:lifecycle-runtime-ktx:${Versions.lifecycle}"

    const val retrofit = "com.squareup.retrofit2:retrofit:${Versions.retrofit}"
    const val converter_gson = "com.squareup.retrofit2:converter-gson:${Versions.retrofit}"
    const val okhttp = "com.squareup.okhttp3:okhttp:${Versions.okhttp}"
    const val okhttp_login_interceptor = "com.squareup.okhttp3:logging-interceptor:${Versions.okhttp}"

    const val room_runtime = "androidx.room:room-runtime:${Versions.room}"
    const val room_compiler = "androidx.room:room-compiler:${Versions.room}"
    const val room_ktx = "androidx.room:room-ktx:${Versions.room}"
    const val roomPaging = "androidx.room:room-paging:${Versions.room}"

    const val onesignal = "com.onesignal:OneSignal:${Versions.oneSignal}"
    
    const val swipe_to_refresh = "com.google.accompanist:accompanist-swiperefresh:${Versions.swipe}"

    const val glide = "com.github.bumptech.glide:glide:${Versions.glide}"
    const val glide_skydoves = "com.github.skydoves:landscapist-glide:${Versions.glide_skydoves}"

    const val dagger_hilt = "com.google.dagger:hilt-android:${Versions.hilt}"
    const val dagger_hilt_compiler = "com.google.dagger:hilt-android-compiler:${Versions.hilt}"
    const val hilt_viewmodel_compiler = "androidx.hilt:hilt-compiler:${Versions.hilt_viewmodel_compiler}"
    const val coil_compose = "io.coil-kt:coil-compose:${Versions.coil}"
    const val coil_svg = "io.coil-kt:coil-svg:${Versions.coil}"
    const val expression = "net.objecthunter:exp4j:${Versions.exp}"
    const val calendar = "io.github.boguszpawlowski.composecalendar:composecalendar:${Versions.calend}"
    const val calendar_date = "io.github.boguszpawlowski.composecalendar:kotlinx-datetime:${Versions.calend}"
    const val paging = "androidx.paging:paging-runtime:${Versions.paging_version}"
    const val pagingCommon = "androidx.paging:paging-common:${Versions.paging_version}"
    const val pagingCompose = "androidx.paging:paging-compose:1.0.0-alpha18"
}
"""
    }
    
    static func bSrcVersions(
        gradleVersion: String,
        compileSdk: String,
        minsdk: String,
        targetsdk: String,
        kotlin: String,
        kotlin_coroutines: String,
        hilt: String,
        hilt_viewmodel_compiler: String,
        ktx: String,
        lifecycle: String,
        fragment_ktx: String,
        appcompat: String,
        material: String,
        compose: String,
        compose_navigation: String,
        activity_compose: String,
        compose_hilt_nav: String,
        oneSignal: String,
        glide: String,
        swipe: String,
        glide_skydoves: String,
        retrofit: String,
        okhttp: String,
        room: String,
        coil: String,
        exp: String,
        calend: String,
        paging: String,
        accompanist: String
    ) -> String {
        return """
package dependencies

object Versions {
    const val gradle = "\(gradleVersion)"
    const val compilesdk = \(compileSdk)
    const val minsdk = \(minsdk)
    const val targetsdk = \(targetsdk)
    const val kotlin = "\(kotlin)"
    const val kotlin_coroutines = "\(kotlin_coroutines)"
    const val hilt = "\(hilt)"
    const val hilt_viewmodel_compiler = "\(hilt_viewmodel_compiler)"

    const val ktx = "\(ktx)"
    const val lifecycle = "\(lifecycle)"
    const val fragment_ktx = "\(fragment_ktx)"
    const val appcompat = "\(appcompat)"
    const val material = "\(material)"
    const val accompanist = "\(accompanist)"

    const val compose = "\(compose)"
    const val compose_navigation = "\(compose_navigation)"
    const val activity_compose = "\(activity_compose)"
    const val compose_hilt_nav = "\(compose_hilt_nav)"

    const val oneSignal = "\(oneSignal)"
    const val glide = "\(glide)"
    const val swipe = "\(swipe)"
    const val glide_skydoves = "\(glide_skydoves)"
    const val retrofit = "\(retrofit)"
    const val okhttp = "\(okhttp)"
    const val room = "\(room)"
    const val coil = "\(coil)"
    const val exp = "\(exp)"
    const val calend = "\(calend)"
    const val paging_version = "\(paging)"
}
"""
    }
    
    static func bSrcKts() -> String {
        return """
import org.gradle.kotlin.dsl.`kotlin-dsl`

plugins{
    `kotlin-dsl`
}

repositories{
    google()
    mavenCentral()
}
"""
    }
}
