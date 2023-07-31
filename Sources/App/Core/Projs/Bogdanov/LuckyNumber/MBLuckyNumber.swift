//
//  File.swift
//  
//
//  Created by admin on 28.06.2023.
//

import Foundation

struct MBLuckyNumber: FileProviderProtocol {
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
                implementation "com.touchlane:gridpad:1.1.0"
            implementation "androidx.compose.animation:animation:1.5.0-beta01"
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
            MyappTheme {
                MBLuckyNumber()
            }
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
    
    static var fileName = "MBLuckyNumber.kt"
    
    static func fileContent(packageName: String, uiSettings: UISettings) -> String {
        return """
package \(packageName).presentation.fragments.main_fragment

import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.aspectRatio
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.Button
import androidx.compose.material3.ButtonDefaults
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableIntStateOf
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.hilt.navigation.compose.hiltViewModel
import androidx.lifecycle.ViewModel
import com.touchlane.gridpad.GridPad
import com.touchlane.gridpad.GridPadCells
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.asStateFlow
import java.util.Random

val backColorPrimary = Color(0xFF\(uiSettings.backColorPrimary ?? "FFFFFF"))
val buttonColorPrimary = Color(0xFF\(uiSettings.buttonColorPrimary ?? "FFFFFF"))
val buttonColorSecondary = Color(0xFF\(uiSettings.buttonColorSecondary ?? "FFFFFF"))
val buttonTextColorPrimary = Color(0xFF\(uiSettings.buttonTextColorPrimary ?? "FFFFFF"))
val textColorPrimary = Color(0xFF\(uiSettings.textColorPrimary ?? "FFFFFF"))


@Composable
fun MBLuckyNumber(appViewModel: AppViewModel = hiltViewModel()) {

    Column(
        modifier = Modifier
            .fillMaxSize()
            .background(
                color = backColorPrimary
            ),
        verticalArrangement = Arrangement.SpaceBetween,
        horizontalAlignment = Alignment.CenterHorizontally
    ) {
        IOScreen(appViewModel)
        Keyboard(appViewModel)
    }
}

class AppViewModel : ViewModel() {

    var ioText by mutableStateOf("")
        private set

    var attempts by mutableIntStateOf(10)
        private set

    private val _gameState = MutableStateFlow<GameState>(GameState.Greeting)
    val gameState = _gameState.asStateFlow()

    fun addSymbol(newSymbol: String) {
        if (ioText.length < 2)
            ioText += newSymbol
    }

    fun deleteSymbol() {
        if (ioText.isNotEmpty()) {
            val lastSymbol = ioText[ioText.length - 1]
            ioText = ioText.removeSuffix(lastSymbol.toString())
        }
    }

    fun restart() {
        GameHandler.restart()
        attempts = 10
        ioText = ""
        _gameState.value = GameState.Playing
    }

    fun done() {
        if (ioText.toIntOrNull() != null) {
            val result = GameHandler.check(ioText.toInt())
            attempts--
            if (result) {
                _gameState.value = GameState.Win
                return
            }
            if (attempts == 0)
                _gameState.value = GameState.Lose
            ioText = ""
        }
    }

}

sealed class GameState {
    object Lose : GameState()

    object Win : GameState()

    object Playing : GameState()

    object Greeting : GameState()
}

object Constants {

    val keyboardSymbols = listOf(
        "1", "2", "3", "4", "5", "6", "7", "8", "9", "✓", "0", "⌫"
    )

}

object GameHandler {

    private var guessedNumber = random()

    private fun random() = Random(System.currentTimeMillis()).nextInt(51)

    fun restart() {
        guessedNumber = random()
    }

    fun check(inputNumber: Int) = inputNumber == guessedNumber
}

@Composable
fun KeyboardButton(index: Int, appViewModel: AppViewModel) {
    val gameState = appViewModel.gameState.collectAsState()
    Button(
        modifier = Modifier
            .aspectRatio(1f)
            .padding(4.dp),
        onClick = {
            if (gameState.value == GameState.Playing) {
                when (index) {
                    11 -> appViewModel.deleteSymbol()
                    9 -> appViewModel.done()
                    else -> appViewModel.addSymbol(Constants.keyboardSymbols[index])
                }
            }

        },
        shape = RoundedCornerShape(8.dp),
        colors = ButtonDefaults.buttonColors(
            containerColor = if (gameState.value == GameState.Playing) buttonColorPrimary else buttonColorSecondary,
        )
    ) {
        Text(
            text = Constants.keyboardSymbols[index],
            color = buttonTextColorPrimary,
            fontSize = 32.sp
        )
    }
}

@Composable
fun Keyboard(appViewModel: AppViewModel) {
    val gameState = appViewModel.gameState.collectAsState()
    GridPad(
        modifier = Modifier
            .fillMaxWidth()
            .aspectRatio(0.75f)
            .clickable(
                enabled = gameState.value != GameState.Playing,
                onClick = {
                    appViewModel.restart()
                }
            ),
        cells = GridPadCells(
            rowCount = 4,
            columnCount = 3
        )
    ) {
        repeat(Constants.keyboardSymbols.size) { index ->
            item {
                KeyboardButton(index = index, appViewModel)
            }
        }
    }
}

@Composable
fun IOScreen(appViewModel: AppViewModel) {
    val state = appViewModel.gameState.collectAsState().value
    Column(
        modifier = Modifier
            .fillMaxWidth()
            .padding(8.dp)
            .background(
                color = backColorPrimary
            ),
        horizontalAlignment = Alignment.CenterHorizontally,
        verticalArrangement = Arrangement.Center
    ) {
        AttemptsDisplay(appViewModel)
        IODisplay(appViewModel)
        Spacer(modifier = Modifier.padding(2.dp))
        when (state) {
            GameState.Playing -> {}
            GameState.Greeting -> {
                Button(
                    onClick = { appViewModel.restart() },
                    colors = ButtonDefaults.buttonColors(containerColor = buttonColorPrimary)
                ) {
                    Text(
                        text = "Start",
                        color = buttonTextColorPrimary,
                        fontSize = 20.sp
                    )
                }
            }

            GameState.Lose -> {
                Button(
                    onClick = { appViewModel.restart() },
                    colors = ButtonDefaults.buttonColors(containerColor = buttonColorPrimary)
                ) {
                    Text(
                        text = "Restart",
                        color = buttonTextColorPrimary,
                        fontSize = 20.sp
                    )
                }
            }

            GameState.Win -> {
                Button(
                    onClick = { appViewModel.restart() },
                    colors = ButtonDefaults.buttonColors(containerColor = buttonColorPrimary)
                ) {
                    Text(
                        text = "Play Again",
                        color = buttonTextColorPrimary,
                        fontSize = 20.sp
                    )
                }
            }
        }

    }
}

@Composable
fun IODisplay(appViewModel: AppViewModel) {
    val gameState = appViewModel.gameState.collectAsState()
    Text(
        modifier = Modifier
            .fillMaxWidth()
            .padding(top = 16.dp)
            .background(
                color = backColorPrimary
            )
            .border(
                width = 2.dp,
                color = buttonColorPrimary,
                shape = RoundedCornerShape(4.dp)
            )
            .padding(12.dp),
        text = when (gameState.value) {
            GameState.Greeting -> "Hi! I guessed a number! Try to guess it!"
            GameState.Lose -> "You lost! Try Again?"
            GameState.Playing -> appViewModel.ioText
            GameState.Win -> "You won! Play Again?"
            else -> "Error"
        }, color = textColorPrimary, fontSize = 26.sp
    )
}

@Composable
fun AttemptsDisplay(appViewModel: AppViewModel) {
    Box(
        modifier = Modifier
            .fillMaxWidth()
            .background(
                color = backColorPrimary
            ),
        contentAlignment = Alignment.CenterEnd
    ) {
        Text(
            color = textColorPrimary,
            fontSize = 16.sp,
            text = "Attempts: ${appViewModel.attempts}"
        )
    }
}
"""

    }
}
