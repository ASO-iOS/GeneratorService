//
//  File.swift
//  
//
//  Created by admin on 06.06.2023.
//

import Foundation

struct VSStopwatch: FileProviderProtocol {
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
            V1StopwatchScreen()
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
    
    static var fileName = "VSStopwatch.kt"
    static func fileContent(
        packageName: String,
        uiSettings: UISettings
    ) -> String {
        return """
package \(packageName).presentation.fragments.main_fragment

import android.content.res.Configuration
import androidx.compose.foundation.BorderStroke
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.itemsIndexed
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.Button
import androidx.compose.material.ButtonDefaults
import androidx.compose.material.OutlinedButton
import androidx.compose.material.Scaffold
import androidx.compose.material.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.collectAsState
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Brush
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.platform.LocalConfiguration
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.hilt.navigation.compose.hiltViewModel
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.Job
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.launch
import javax.inject.Inject

val backColor = Color(0xFF\(uiSettings.backColorPrimary ?? "FFFFFF"))
val buttonColor = Color(0xFF\(uiSettings.buttonColorPrimary ?? "FFFFFF"))
val buttonTextColor = Color(0xFF\(uiSettings.buttonTextColorPrimary ?? "FFFFFF"))
val outlineButtonColor = Color(0xFF\(uiSettings.buttonColorPrimary ?? "FFFFFF"))
val outlineButtonBorderColor = Color(0xFF\(uiSettings.buttonColorPrimary ?? "FFFFFF"))
val mainTextColor = Color(0xFF\(uiSettings.textColorPrimary ?? "FFFFFF"))
val lapTextColor = Color(0xFF\(uiSettings.textColorPrimary ?? "FFFFFF"))
val buttonRadius = 24.dp
val buttonsBottomPadding = 18.dp

@Composable
fun ButtonBar(
    timerState: TimerUiState.TimerState,
    viewModel: MainViewModel
) {
    Row(
        horizontalArrangement = Arrangement.spacedBy(14.dp),
        modifier = Modifier.padding(start = 14.dp, end = 14.dp, bottom = buttonsBottomPadding)
    ) {
        when (timerState) {
            is TimerUiState.TimerState.Init -> {
                Button(
                    modifier = Modifier.fillMaxWidth(0.5f),
                    shape = RoundedCornerShape(buttonRadius),
                    colors = ButtonDefaults.buttonColors(contentColor = buttonTextColor, backgroundColor = buttonColor),
                    onClick = { viewModel.start() }
                ) {
                    Text(
                        text = "Start",
                        fontSize = 28.sp,
                        fontWeight = FontWeight.Bold
                    )
                }
            }

            is TimerUiState.TimerState.Running -> {
                OutlinedButton(
                    modifier = Modifier.weight(1f),
                    shape = RoundedCornerShape(buttonRadius),
                    border = BorderStroke(2.dp, outlineButtonBorderColor),
                    colors = ButtonDefaults.buttonColors(backgroundColor = outlineButtonColor),
                    onClick = { viewModel.lap() }
                ) {
                    Text(
                        text = "Lap",
                        fontSize = 28.sp,
                        color = buttonTextColor,
                        fontWeight = FontWeight.Bold
                    )
                }
                Button(
                    modifier = Modifier.weight(1f),
                    shape = RoundedCornerShape(buttonRadius),
                    colors = ButtonDefaults.buttonColors(contentColor = buttonTextColor, backgroundColor = buttonColor),
                    onClick = { viewModel.pause() }
                ) {
                    Text(
                        text = "Pause",
                        fontSize = 28.sp,
                        fontWeight = FontWeight.Bold
                    )
                }
            }

            is TimerUiState.TimerState.Paused -> {
                OutlinedButton(
                    modifier = Modifier.weight(1f),
                    shape = RoundedCornerShape(buttonRadius),
                    border = BorderStroke(2.dp, outlineButtonBorderColor),
                    colors = ButtonDefaults.buttonColors(backgroundColor = outlineButtonColor),
                    onClick = { viewModel.reset() }
                ) {
                    Text(
                        text = "Reset",
                        fontSize = 28.sp,
                        color = buttonTextColor,
                        fontWeight = FontWeight.Bold
                    )
                }
                Button(
                    modifier = Modifier.weight(1f),
                    shape = RoundedCornerShape(buttonRadius),
                    colors = ButtonDefaults.buttonColors(contentColor = buttonTextColor, backgroundColor = buttonColor),
                    onClick = {
                        viewModel.start()
                    }
                ) {
                    Text(
                        text = "Resume",
                        fontSize = 28.sp,
                        fontWeight = FontWeight.Bold
                    )
                }
            }
        }
    }
}

data class TimerUiState(
    val time: Long = 0L,
    val laps: MutableList<Long> = mutableListOf(),
    val timerState: TimerState = TimerState.Init
) {
    sealed interface TimerState {
        object Init : TimerState
        object Running : TimerState
        object Paused : TimerState
    }
}

@HiltViewModel
class MainViewModel @Inject constructor() : ViewModel() {

    private val _state = MutableStateFlow(TimerUiState())
    val state = _state.asStateFlow()

    private var job: Job? = null

    private var startMillis: Long = 0
    private var isRunning: Boolean = false
    private var time: Long = 0

    fun pause() {
        isRunning = false
    }

    fun reset() {
        time = 0

        updateState {
            TimerUiState()
        }
    }

    fun start() {
        if (job?.isActive != true) {
            job = viewModelScope.launch(Dispatchers.Default) {
                isRunning = true
                startMillis = System.currentTimeMillis() - time

                updateState { state ->
                    state.copy(timerState = TimerUiState.TimerState.Running)
                }

                while (isRunning) {
                    time = System.currentTimeMillis() - startMillis

                    updateState { state ->
                        state.copy(time = time)
                    }
                }

                updateState { state ->
                    state.copy(timerState = TimerUiState.TimerState.Paused)
                }
            }
        }
    }

    fun lap() {
        _state.value.laps.add(time)
    }

    private fun updateState(stateScope: (TimerUiState) -> TimerUiState) {
        _state.value = stateScope(_state.value)
    }
}


@Composable
fun V1StopwatchScreen(viewModel: MainViewModel = hiltViewModel()) {

    val state = viewModel.state.collectAsState()
    val orientation = LocalConfiguration.current.orientation

    Scaffold { paddingValues ->
        Column(
            horizontalAlignment = Alignment.CenterHorizontally,
            modifier = Modifier
                .fillMaxSize()
                .padding(paddingValues)
                    .background(color = backColor)
        ) {

            Text(
                text = state.value.time.format(),
                color = mainTextColor,
                fontSize = 80.sp,
                modifier = Modifier.padding(top = if (orientation == Configuration.ORIENTATION_LANDSCAPE) 0.dp else 32.dp)
            )

            LazyColumn(
                horizontalAlignment = Alignment.CenterHorizontally,
                modifier = Modifier
                    .weight(1f)
                    .fillMaxWidth()
                    .padding(bottom = 16.dp)
            ) {
                itemsIndexed(state.value.laps) { index, time ->
                    Row(modifier = Modifier
                        .fillMaxWidth()
                        .padding(horizontal = 12.dp, vertical = 1.dp), horizontalArrangement = Arrangement.SpaceBetween, verticalAlignment = Alignment.CenterVertically) {
                        Text(
                            text = (index + 1).toString(),
                            fontSize = 24.sp,
                            textAlign = TextAlign.End,
                            color = lapTextColor
                        )
                        Text(
                            modifier = Modifier.fillMaxWidth(),
                            text = time.format(),
                            fontSize = 40.sp,
                            textAlign = TextAlign.End,
                            color = lapTextColor
                        )
                    }
                }
            }
            ButtonBar(timerState = state.value.timerState, viewModel = viewModel)
        }
    }
}

fun Long.format(): String {
    val timeMM = (this / 10 % 100).toString().padStart(2, '0')
    val timeS = (this / 1000 % 60).toString().padStart(2, '0')
    val timeM = (this / 60000).toString().padStart(2, '0')
//    return context.getString(R.string.mm_ss_time, timeM, timeS, timeMM)
    return "$timeM:$timeS.$timeMM"
}
"""
    }
}
