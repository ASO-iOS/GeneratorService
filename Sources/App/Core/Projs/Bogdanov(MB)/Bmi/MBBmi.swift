//
//  File.swift
//  
//
//  Created by admin on 28.06.2023.
//

import Foundation

struct MBBmi: FileProviderProtocol {
    static func gradle(_ packageName: String) -> GradleFilesData {
        let projectGradle = """
                import dependencies.Versions
                import dependencies.Build

                buildscript {
                    ext {
                        compose_version = Versions.compose
                        kotlin_version = Versions.kotlin
                    }

                    repositories {
                        gradlePluginPortal()
                        google()
                        mavenCentral()
                    }
                    dependencies {
                        classpath Build.build_tools
                        classpath Build.kotlin_gradle_plugin
                        classpath Build.hilt_plugin
                    }
                }

                task clean(type: Delete) {
                    delete rootProject.buildDir
                }
                """
        let projectGradleName = "build.gradle"
        let moduleGradle = """
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
                                        minifyEnabled true
                            shrinkResources true
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
                    
                }
                """
        let moduleGradleName = "build.gradle"
        let dependencies = """
                package dependencies

                object Application {
                    const val id = "\(packageName)"
                    const val version_code = 1
                    const val version_name = "1.0"
                }

                object Build {
                    const val build_tools = "com.android.tools.build:gradle:${Versions.gradle}"
                    const val kotlin_gradle_plugin = "org.jetbrains.kotlin:kotlin-gradle-plugin:${Versions.kotlin}"
                    const val hilt_plugin = "com.google.dagger:hilt-android-gradle-plugin:${Versions.hilt}"
                }

                object Versions {
                    const val gradle = "8.0.0"
                    const val compilesdk = 33
                    const val minsdk = 24
                    const val targetsdk = 33
                    const val kotlin = "1.8.10"
                    const val kotlin_coroutines = "1.6.3"
                    const val hilt = "2.43.2"
                    const val hilt_viewmodel_compiler = "1.0.0"

                    const val ktx = "1.10.0"
                    const val lifecycle = "2.6.1"
                    const val fragment_ktx = "1.5.7"
                    const val appcompat = "1.6.1"
                    const val material = "1.9.0"
                    const val accompanist = "0.31.1-alpha"

                    const val compose = "1.4.3"
                    const val compose_navigation = "2.5.0-beta01"
                    const val activity_compose = "1.7.1"
                    const val compose_hilt_nav = "1.0.0"

                    const val oneSignal = "4.6.7"
                    const val glide = "4.14.2"
                    const val swipe = "0.19.0"
                    const val glide_skydoves = "1.3.9"
                    const val retrofit = "2.9.0"
                    const val okhttp = "4.10.0"
                    const val room = "2.5.0"
                    const val coil = "2.2.2"
                    const val exp = "0.4.8"
                    const val calend = "0.5.1"
                    const val paging_version = "3.1.1"
                }

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
                }
                """
        let dependenciesName = "Dependencies.kt"
        return GradleFilesData(
            projectBuildGradle: GradleFileInfoData(
                content: projectGradle,
                name: projectGradleName
            ),
            moduleBuildGradle: GradleFileInfoData(
                content: moduleGradle,
                name: moduleGradleName
            ),
            dependencies: GradleFileInfoData(
                content: dependencies,
                name: dependenciesName
            ))
    }
    
    static func dependencies(_ mainData: MainData) -> ANDData {
        return ANDData(
            mainFragmentData: ANDMainFragment(
                imports: "",
                content: """
            MBBmi()
        """
            ),
            mainActivityData: ANDMainActivity(
                imports: "",
                extraFunc: "",
                content: ""
            ),
            themesData: ANDThemesData(isDefault: true, content: ""),
            stringsData: ANDStringsData(additional: ""),
            colorsData: ANDColorsData(additional: "")
        )
    }
    
    static var fileName = "\(NamesManager.shared.fileName).kt"
    static func fileContent(
        packageName: String,
        uiSettings: UISettings
    ) -> String {
        return """
package \(packageName).presentation.fragments.main_fragment

import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.text.BasicTextField
import androidx.compose.foundation.text.KeyboardOptions
import androidx.compose.material3.Button
import androidx.compose.material3.ButtonDefaults
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.TextStyle
import androidx.compose.ui.text.font.FontStyle
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.input.ImeAction
import androidx.compose.ui.text.input.KeyboardType
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import kotlin.math.roundToInt

val backColorPrimary = Color(0xFF\(uiSettings.backColorPrimary ?? "FFFFFF"))
val backColorSecondary = Color(0xFF\(uiSettings.backColorSecondary ?? "FFFFFF"))
val textColorPrimary = Color(0xFF\(uiSettings.textColorPrimary ?? "FFFFFF"))
val textColorSecondary = Color(0xFF\(uiSettings.textColorSecondary ?? "FFFFFF"))
val buttonColorPrimary = Color(0xFF\(uiSettings.buttonColorPrimary ?? "FFFFFF"))
val buttonTextColorPrimary = Color(0xFF\(uiSettings.buttonTextColorPrimary ?? "FFFFFF"))

@Composable
fun MBBmi() {
    Column(
        modifier = Modifier
            .fillMaxSize()
            .background(backColorPrimary),
        horizontalAlignment = Alignment.CenterHorizontally,
        verticalArrangement = Arrangement.SpaceAround
    ) {
        var inputHeight by remember {
            mutableStateOf("")
        }
        var inputWeight by remember {
            mutableStateOf("")
        }
        var output by remember {
            mutableStateOf("")
        }
        Text(
            text = output,
            modifier = Modifier
                .fillMaxWidth()
                .padding(horizontal = 64.dp, vertical = 32.dp),
            textAlign = TextAlign.Center,
            fontSize = 42.sp,
            fontStyle = FontStyle.Italic,
            color = textColorPrimary
        )
        Text(
            if (output.isEmpty()) "Enter weight and height" else "",
            modifier = Modifier
                .fillMaxWidth(),
            textAlign = TextAlign.Center,
            fontSize = 30.sp,
            color = textColorPrimary
        )
        Column(
            modifier = Modifier.background(backColorPrimary)
                .padding(8.dp)
        ) {
            BasicTextField(
                modifier = Modifier
                    .background(backColorPrimary)
                    .padding(4.dp),
                value = inputWeight,
                onValueChange = { str ->
                    if (str.isNotEmpty()) {
                        str.toFloatOrNull()?.let {
                            inputWeight = str
                        }
                    } else {
                        inputWeight = str
                    }
                },
                textStyle = TextStyle(
                    fontSize = 20.sp,
                    fontWeight = FontWeight.Medium,
                    color = textColorSecondary
                ),
                keyboardOptions = KeyboardOptions(
                    keyboardType = KeyboardType.Number,
                    imeAction = ImeAction.Done
                ),
                singleLine = true
            ) { innerTextField ->
                Row(
                    modifier = Modifier
                        .padding(8.dp)
                        .background(
                            color = backColorSecondary,
                            shape = RoundedCornerShape(size = 16.dp)
                        )
                        .border(
                            width = 2.dp,
                            color = buttonTextColorPrimary,
                            shape = RoundedCornerShape(size = 16.dp)
                        )
                        .padding(all = 16.dp),
                    verticalAlignment = Alignment.CenterVertically,
                    horizontalArrangement = Arrangement.Center
                ) {
                    Text(
                        text = "Weight: ",
                        modifier = Modifier
                            .padding(4.dp),
                        fontSize = 14.sp,
                        color = textColorSecondary
                    )
                    Spacer(
                        modifier = Modifier
                            .padding(horizontal = 3.dp)
                    )
                    innerTextField()
                }
            }
            BasicTextField(
                modifier = Modifier
                    .background(backColorPrimary)
                    .padding(4.dp),
                value = inputHeight,
                onValueChange = { str ->
                    if (str.isNotEmpty()) {
                        str.toFloatOrNull()?.let {
                            inputHeight = str
                        }
                    } else {
                        inputHeight = str
                    }
                },
                textStyle = TextStyle(
                    fontSize = 20.sp,
                    fontWeight = FontWeight.Medium,
                    color = textColorSecondary
                ),
                keyboardOptions = KeyboardOptions(
                    keyboardType = KeyboardType.Number,
                    imeAction = ImeAction.Done
                ),
                singleLine = true
            ) { innerTextField ->
                Row(
                    modifier = Modifier
                        .padding(8.dp)
                        .background(
                            color = backColorSecondary,
                            shape = RoundedCornerShape(size = 16.dp)
                        )
                        .border(
                            width = 2.dp,
                            color = buttonTextColorPrimary,
                            shape = RoundedCornerShape(size = 16.dp)
                        )
                        .padding(all = 16.dp),
                    verticalAlignment = Alignment.CenterVertically,
                    horizontalArrangement = Arrangement.Center
                ) {
                    Text(
                        text = "Height: ",
                        modifier = Modifier
                            .padding(4.dp),
                        fontSize = 14.sp,
                        color = textColorSecondary
                    )
                    Spacer(
                        modifier = Modifier
                            .padding(horizontal = 3.dp)
                    )
                    innerTextField()
                }
            }
        }
        Button(
            onClick = {
                if (inputWeight.isNotEmpty() && inputHeight.isNotEmpty()) {
                    var outputFloat = calculateBMI(
                        height = inputHeight.toFloatOrNull(),
                        weight = inputWeight.toFloatOrNull()
                    ).toFloatOrNull()
                    outputFloat = outputFloat?.let { float ->
                        (float * 100).roundToInt() / 100.0f
                    }
                    output = outputFloat.toString()
                } else {
                    output = "Empty Fields"
                }

            },
            modifier = Modifier
                .fillMaxWidth()
                .padding(horizontal = 96.dp),
            shape = RoundedCornerShape(8.dp),
            colors = ButtonDefaults.buttonColors(buttonColorPrimary)
        ) {
            Text(text = "CALCULATE", modifier = Modifier.padding(8.dp), color = buttonTextColorPrimary)
        }
    }
}

private fun calculateBMI(height: Float?, weight: Float?) =
    if (height != null && weight != null) {
        val heightInMeters = height / 100
        val result = weight / (heightInMeters * heightInMeters)
        "$result"
    } else {
        "Input data is invalid"
    }

"""
    }
}
