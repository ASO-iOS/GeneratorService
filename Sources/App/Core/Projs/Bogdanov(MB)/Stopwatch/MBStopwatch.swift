//
//  File.swift
//  
//
//  Created by admin on 14.06.2023.
//

import Foundation

struct MBStopwatch: FileProviderProtocol {
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
            StopwatchTheme() {
                MBStopwatch()
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
    
    static var fileName = "MBStopwatch.kt"
    static func fileContent(
        packageName: String,
        uiSettings: UISettings
    ) -> String {
        return """
package \(packageName).presentation.fragments.main_fragment

import android.os.Build
import androidx.compose.foundation.background
import androidx.compose.foundation.isSystemInDarkTheme
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Flag
import androidx.compose.material.icons.filled.Pause
import androidx.compose.material.icons.filled.PlayArrow
import androidx.compose.material.icons.filled.Stop
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.material3.Typography
import androidx.compose.material3.darkColorScheme
import androidx.compose.material3.dynamicDarkColorScheme
import androidx.compose.material3.dynamicLightColorScheme
import androidx.compose.material3.lightColorScheme
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.scale
import androidx.compose.ui.graphics.Brush
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.text.TextStyle
import androidx.compose.ui.text.font.FontFamily
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.lifecycle.viewmodel.compose.viewModel
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.setValue
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import kotlinx.coroutines.CoroutineStart
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.Job
import kotlinx.coroutines.delay
import kotlinx.coroutines.launch

val backColor = Color(0xFF\(uiSettings.backColorPrimary ?? "FFFFFF"))
val mainTextColor = Color(0xFF\(uiSettings.textColorPrimary ?? "FFFFFF"))

val mainTextSize = \(uiSettings.textSizePrimary ?? 22)
val secondaryTextSize = \(uiSettings.textSizeSecondary ?? 16)

val mainPadding = \(uiSettings.paddingPrimary ?? 12)
val secondaryPadding = \(uiSettings.paddingSecondary ?? 8)
val tertiaryPadding = \(uiSettings.paddingSecondary ?? 8)

@Composable
fun MBStopwatch(viewModel: MainViewModel = viewModel()) {
    Column(
        modifier = Modifier
            .fillMaxSize()
                    .background(color = backColor)
            .padding(mainPadding.dp),
        horizontalAlignment = Alignment.CenterHorizontally
    ) {
        val currentTime = viewModel.allTime
        val loops = viewModel.loops
        val stopwatchState = viewModel.stopwatchState
        Spacer(modifier = Modifier.padding(secondaryPadding.dp))
        Column(
            Modifier
                .fillMaxWidth()
                    .background(color = backColor)
                .padding(mainPadding.dp),
            horizontalAlignment = Alignment.CenterHorizontally,
            verticalArrangement = Arrangement.Center
        ) {
            Text(
                modifier = Modifier
                    .padding(tertiaryPadding.dp)
                    .align(Alignment.CenterHorizontally),
                text = TimeConverters.convertMillisToNormal(currentTime),
                style = MaterialTheme.typography.displayLarge
            )
            Spacer(modifier = Modifier.padding(48.dp))
            Row(
                modifier = Modifier
                    .fillMaxWidth()
                    .background(color = backColor)
                    .padding(mainPadding.dp),
                horizontalArrangement = Arrangement.SpaceEvenly,
                verticalAlignment = Alignment.CenterVertically
            ) {
                when (stopwatchState) {
                    StopwatchState.Started -> {
                        IconButton(
                            modifier = Modifier.size(80.dp),
                            onClick = { viewModel.loop() }
                        ) {
                            Icon(
                                imageVector = Icons.Filled.Flag,
                                contentDescription = "Loop",
                                modifier = Modifier.size(80.dp),
                                tint = Color.White
                            )
                        }
                        IconButton(
                            modifier = Modifier.size(80.dp),
                            onClick = { viewModel.pauseTimer() }
                        ) {
                            Icon(
                                imageVector = Icons.Filled.Pause,
                                contentDescription = "Pause timer",
                                modifier = Modifier.size(80.dp),
                                tint = Color.White
                            )
                        }
                    }

                    StopwatchState.Paused -> {
                        IconButton(
                            modifier = Modifier.size(80.dp),
                            onClick = { viewModel.stopTimer() }
                        ) {
                            Icon(
                                imageVector = Icons.Filled.Stop,
                                contentDescription = "Stop timer",
                                modifier = Modifier.size(80.dp),
                                tint = Color.White
                            )
                        }
                        IconButton(
                            modifier = Modifier.size(80.dp),
                            onClick = { viewModel.startTimer() }
                        ) {
                            Icon(
                                imageVector = Icons.Filled.PlayArrow,
                                contentDescription = "Start timer",
                                modifier = Modifier.size(80.dp),
                                tint = Color.White
                            )
                        }
                    }
                }
            }
        }
        Spacer(modifier = Modifier.padding(16.dp))
        Row(
            modifier = Modifier
                .fillMaxWidth()
                    .background(color = backColor),
            verticalAlignment = Alignment.CenterVertically,
            horizontalArrangement = Arrangement.SpaceBetween
        ) {
            Text(
                modifier = Modifier
                    .weight(1f)
                    .padding(tertiaryPadding.dp)
                    .align(Alignment.CenterVertically),
                text = "№",
                style = MaterialTheme.typography.displayMedium
            )
            Text(
                modifier = Modifier
                    .weight(1f)
                    .padding(tertiaryPadding.dp)
                    .align(Alignment.CenterVertically),
                text = "Loop time",
                style = MaterialTheme.typography.displayMedium
            )
            Text(
                modifier = Modifier
                    .weight(1f)
                    .padding(tertiaryPadding.dp)
                    .align(Alignment.CenterVertically),
                text = "Time",
                style = MaterialTheme.typography.displayMedium
            )
        }
        LazyColumn(
            modifier = Modifier
                .fillMaxWidth()
                    .background(color = backColor)
                .weight(1f),
            verticalArrangement = Arrangement.Top,
            horizontalAlignment = Alignment.CenterHorizontally
        ) {
            items(
                items = loops,
                key = { loop ->
                    loop.number
                }
            ) { loop ->
                Row(
                    Modifier
                        .fillMaxWidth()
                    .background(color = backColor)
                        .padding(mainPadding.dp),
                    verticalAlignment = Alignment.CenterVertically,
                    horizontalArrangement = Arrangement.SpaceBetween
                ) {
                    Text(
                        modifier = Modifier
                            .weight(1f)
                            .padding(tertiaryPadding.dp)
                            .align(Alignment.CenterVertically),
                        text = loop.number.toString(),
                        style = MaterialTheme.typography.displaySmall
                    )

                    Text(
                        modifier = Modifier
                            .weight(1f)
                            .padding(tertiaryPadding.dp)
                            .align(Alignment.CenterVertically),
                        text = TimeConverters.convertMillisToSecondsWithPlus(
                            loop.loopTime
                        ),
                        style = MaterialTheme.typography.displayMedium
                    )
                    Text(
                        modifier = Modifier
                            .weight(1f)
                            .padding(tertiaryPadding.dp)
                            .align(Alignment.CenterVertically),
                        text = TimeConverters.convertMillisToSeconds(
                            loop.allTime
                        ),
                        style = MaterialTheme.typography.displayMedium
                    )
                }
            }
        }
    }
}

val Purple80 = Color(0xFFD0BCFF)
val PurpleGrey80 = Color(0xFFCCC2DC)
val Pink80 = Color(0xFFEFB8C8)

val Purple40 = Color(0xFF6650a4)
val PurpleGrey40 = Color(0xFF625b71)
val Pink40 = Color(0xFF7D5260)

private val DarkColorScheme = darkColorScheme(
    primary = Purple80,
    secondary = PurpleGrey80,
    tertiary = Pink80
)

private val LightColorScheme = lightColorScheme(
    primary = Purple40,
    secondary = PurpleGrey40,
    tertiary = Pink40
)

@Composable
fun StopwatchTheme(
    darkTheme: Boolean = isSystemInDarkTheme(),
    dynamicColor: Boolean = true,
    content: @Composable () -> Unit
) {
    val colorScheme = when {
        dynamicColor && Build.VERSION.SDK_INT >= Build.VERSION_CODES.S -> {
            val context = LocalContext.current
            if (darkTheme) dynamicDarkColorScheme(context) else dynamicLightColorScheme(context)
        }

        darkTheme -> DarkColorScheme
        else -> LightColorScheme
    }
    MaterialTheme(
        colorScheme = colorScheme,
        typography = Typography,
        content = content
    )
}

val Typography = Typography(
    bodyLarge = TextStyle(
        fontFamily = FontFamily.Default,
        fontWeight = FontWeight.Normal,
        fontSize = mainTextSize.sp,
        lineHeight = 24.sp,
        letterSpacing = 0.5.sp,
        color = mainTextColor
    ),
    displayMedium = TextStyle(
        fontSize = mainTextSize.sp,
        fontWeight = FontWeight.W300,
        textAlign = TextAlign.Center,
        color = mainTextColor
    ),
    displayLarge = TextStyle(
        fontSize = 52.sp,
        fontWeight = FontWeight.W300,
        textAlign = TextAlign.Center,
        color = mainTextColor
    ),
    displaySmall = TextStyle(
        fontSize = mainTextSize.sp,
        fontWeight = FontWeight.W700,
        textAlign = TextAlign.Center,
        color = mainTextColor
    )
)

data class Loop(
    val number: Int,
    val loopTime: Long,
    val allTime: Long
)

sealed class StopwatchState {
    object Paused : StopwatchState()
    object Started : StopwatchState()
}


class MainViewModel : ViewModel() {

    var allTime by mutableStateOf(0L)
        private set

    var stopwatchState: StopwatchState by mutableStateOf(StopwatchState.Paused)
        private set

    var loops: MutableList<Loop> = mutableListOf()
        private set

    private var timer: Job? = null

    private var lastLoop = 0L

    private fun timerBody() =
        viewModelScope.launch(start = CoroutineStart.LAZY, context = Dispatchers.IO) {
            while (true) {
                val timeBefore = System.currentTimeMillis()
                delay(75)
                allTime += System.currentTimeMillis() - timeBefore
            }
        }

    fun startTimer() {
        timer = timerBody()
        timer?.start()
        stopwatchState = StopwatchState.Started
    }

    fun stopTimer() {
        allTime = 0L
        lastLoop = 0L
        loops.clear()
    }

    fun pauseTimer() {
        timer?.cancel()
        stopwatchState = StopwatchState.Paused
    }

    fun loop() {
        loops += Loop(
            number = loops.size,
            loopTime = allTime - lastLoop,
            allTime = allTime
        )
        lastLoop = allTime
    }
}

object TimeConverters {

    fun convertMillisToNormal(timeInMillis: Long): String {
        var result = ""
        val millis = timeInMillis % 1000L
        val hours = timeInMillis / 1000L / 60L / 60L
        val minutes = (timeInMillis / 1000L / 60L) % 60L
        val seconds = (timeInMillis / 1000L) % 60L
        result += when (hours) {
            0L -> "00:"
            in 1L..9L -> "0$hours:"
            else -> "$hours:"
        }
        result += when (minutes) {
            0L -> "00:"
            in 1L..9L -> "0$minutes:"
            else -> "$minutes:"
        }
        result += when (seconds) {
            0L -> "00:"
            in 1L..9L -> "0$seconds:"
            else -> "$seconds:"
        }
        result += when (millis) {
            0L -> "000"
            in 1L..9L -> "00$millis"
            in 10L..99L -> "0$millis"
            else -> millis.toString()
        }
        return result
    }

    fun convertMillisToSecondsWithPlus(timeInMillis: Long): String {
        var result = ""
        val millis = timeInMillis % 1000L
        val hours = timeInMillis / 1000L / 60L / 60L
        val minutes = (timeInMillis / 1000L / 60L) % 60L
        val seconds = (timeInMillis / 1000L) % 60L
        result += when (hours) {
            0L -> ""
            in 1L..9L -> "0$hours:"
            else -> "$hours:"
        }
        result += when (minutes) {
            0L -> ""
            in 1L..9L -> "0$minutes:"
            else -> "$minutes:"
        }
        result += when (seconds) {
            0L -> ""
            in 1L..9L -> "0$seconds:"
            else -> "$seconds:"
        }
        result += when (millis) {
            0L -> "000"
            in 1L..9L -> "00$millis"
            in 10L..99L -> "0$millis"
            else -> millis.toString()
        }
        return "+$result"
    }

    fun convertMillisToSeconds(timeInMillis: Long): String {
        var result = ""
        val millis = timeInMillis % 1000L
        val hours = timeInMillis / 1000L / 60L / 60L
        val minutes = (timeInMillis / 1000L / 60L) % 60L
        val seconds = (timeInMillis / 1000L) % 60L
        result += when (hours) {
            0L -> ""
            in 1L..9L -> "0$hours:"
            else -> "$hours:"
        }
        result += when (minutes) {
            0L -> ""
            in 1L..9L -> "0$minutes:"
            else -> "$minutes:"
        }
        result += when (seconds) {
            0L -> "00:"
            in 1L..9L -> "0$seconds:"
            else -> "$seconds:"
        }
        result += when (millis) {
            0L -> "000"
            in 1L..9L -> "00$millis"
            in 10L..99L -> "0$millis"
            else -> millis.toString()
        }
        return result
    }
}
"""
    }
}