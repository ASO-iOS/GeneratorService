//
//  File.swift
//  
//
//  Created by admin on 03.08.2023.
//

import Foundation

struct ITDeviceInfo: CMFFileProviderProtocol {
    static var fileName: String = "ITDeviceInfo.kt"
    
    static func fileContent(packageName: String, uiSettings: UISettings) -> String {
        return """
package \(packageName).presentation.fragments.main_fragment

import android.os.Build
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.width
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.State
import androidx.compose.runtime.mutableStateOf
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.unit.dp
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import \(packageName).R
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.delay
import kotlinx.coroutines.launch
import javax.inject.Inject

val buttonColorPrimary = Color(0xFF\(uiSettings.buttonColorPrimary ?? "FFFFFF"))
val buttonTextColorPrimary = Color(0xff\(uiSettings.buttonTextColorPrimary ?? "FFFFFF"))
val textColorPrimary = Color(0xff\(uiSettings.textColorPrimary ?? "FFFFFF"))
val backColorPrimary = Color(0xff\(uiSettings.backColorPrimary ?? "FFFFFF"))

@Composable
fun DeviceInfo(
    info: Map<Int, String>,
    availMemory: Double,
    totalMemory: Double,
    height: Int,
    width: Int,
    density: Float,
    size: Float,
) {
    Column(
        modifier = Modifier
            .fillMaxWidth()
            .background(backColorPrimary)
            .padding(30.dp),
        verticalArrangement = Arrangement.Center,
    ) {

        info.entries.forEach { entity ->
            Row {
                Text(text = stringResource(id = entity.key), color = textColorPrimary)
                Spacer(modifier = Modifier.width(5.dp))
                Text(text = entity.value , color = textColorPrimary)
            }
            Spacer(modifier = Modifier.height(5.dp))
        }

        Spacer(modifier = Modifier.height(15.dp))
        Text(text = stringResource(id = R.string.available, availMemory), color = textColorPrimary)
        Text(text = stringResource(id = R.string.total, totalMemory), color = textColorPrimary)
        Spacer(modifier = Modifier.height(15.dp))
        Text(text = stringResource(id = R.string.size, size), color = textColorPrimary)
        Text(text = stringResource(id = R.string.resolution, height, width), color = textColorPrimary)
        Text(text = stringResource(id = R.string.density,density), color = textColorPrimary)
    }
}

sealed class DeviceInfoState {
    object Loading: DeviceInfoState()
    class Success(val infoList: Map<Int, String>): DeviceInfoState()
}

@HiltViewModel
class DeviceInfoViewModel @Inject constructor() : ViewModel() {

    private val _state = mutableStateOf<DeviceInfoState>(DeviceInfoState.Loading)
    val state: State<DeviceInfoState> = _state

    private var info: Map<Int, String> = mapOf()

    init {
        load()
    }

    fun load(){
        _state.value = DeviceInfoState.Loading
        viewModelScope.launch {
            delay(3000)
            info = getDeviceInfoMap()
            _state.value = DeviceInfoState.Success(info)
        }
    }

    private fun getDeviceInfoMap(): Map<Int, String> {
        return mapOf(
            R.string.manufacturer to Build.MANUFACTURER,
            R.string.brand to Build.BRAND,
            R.string.model to Build.MODEL,
            R.string.product to Build.PRODUCT,
            R.string.device to Build.DEVICE,
            R.string.board to Build.BOARD,
            R.string.hardware to Build.HARDWARE,
            R.string.sdk to Build.VERSION.SDK_INT.toString(),
            R.string.codename to Build.VERSION.CODENAME,
            R.string.host to Build.HOST,
            R.string.id to Build.ID,
            R.string.display to Build.DISPLAY,
            R.string.fingerprint to Build.FINGERPRINT
        )
    }
}


"""
    }
    
    static func dependencies(_ mainData: MainData) -> ANDData {
        return ANDData(mainFragmentData: ANDMainFragment(imports: "", content: ""), mainActivityData: ANDMainActivity(imports: "", extraFunc: "", content: ""), themesData: ANDThemesData(isDefault: true, content: ""), stringsData: ANDStringsData(additional: """
    <string name="check">Check</string>
    <string name="manufacturer">Manufacturer:</string>
    <string name="brand">Brand:</string>
    <string name="model">Model:</string>
    <string name="product">Product:</string>
    <string name="device">Device:</string>
    <string name="board">Board:</string>
    <string name="hardware">Hardware:</string>
    <string name="sdk">SDK:</string>
    <string name="codename">Codename:</string>
    <string name="host">Host:</string>
    <string name="id">ID:</string>
    <string name="display">Display:</string>
    <string name="fingerprint">Fingerprint:</string>
    <string name="collect">Collect information</string>
    <string name="available">Available memory: "%.1f" GB</string>
    <string name="total">Total memory: "%.1f" GB</string>
    <string name="size">Screen size: "%.1f" Inches</string>
    <string name="resolution">Resolution: "%1$s" * "%2$s" Pixels</string>
    <string name="density">Density: "%1$s" dpi</string>
"""), colorsData: ANDColorsData(additional: ""))
    }
    
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
import dependencies.Application
import dependencies.Dependencies
import dependencies.Versions

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
    implementation Dependencies.compose_splash
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
    const val gradle = "8.0.2"
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
    const val compose_navigation = "2.5.3"
    const val activity_compose = "1.7.1"
    const val compose_hilt_nav = "1.0.0"

    const val oneSignal = "4.6.7"
    const val glide = "4.12.0"
    const val swipe = "0.19.0"
    const val glide_skydoves = "1.3.9"
    const val retrofit = "2.9.0"
    const val okhttp = "4.10.0"
    const val room = "2.5.0"
    const val coil = "2.3.0"
    const val exp = "0.4.8"
    const val calend = "0.5.1"
    const val paging_version = "3.1.1"
    const val splash = "1.0.1"
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
    const val compose_splash = "androidx.core:core-splashscreen:${Versions.splash}"

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
    const val glide_compiler = "com.github.bumptech.glide:compiler:${Versions.glide}"

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
    
    static func cmfHandler(_ packageName: String) -> ANDMainFragmentCMF {
        return ANDMainFragmentCMF(content: """
package \(packageName).presentation.fragments.main_fragment

import android.app.ActivityManager
import android.content.Context
import android.os.Bundle
import android.util.DisplayMetrics
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.material3.Button
import androidx.compose.material3.ButtonDefaults
import androidx.compose.material3.LinearProgressIndicator
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.ComposeView
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.unit.dp
import androidx.fragment.app.Fragment
import androidx.hilt.navigation.compose.hiltViewModel
import \(packageName).R
import dagger.hilt.android.AndroidEntryPoint
import kotlin.math.pow
import kotlin.math.sqrt


@AndroidEntryPoint
class MainFragment : Fragment() {

    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?,
    ): View {

        val context = requireActivity()

        val actManager = context.getSystemService(Context.ACTIVITY_SERVICE) as ActivityManager
        val memoryInfo = ActivityManager.MemoryInfo()
        actManager.getMemoryInfo(memoryInfo)
        val availMemory = memoryInfo.availMem.toDouble() / (1024 * 1024 * 1024)
        val totalMemory = memoryInfo.totalMem.toDouble() / (1024 * 1024 * 1024)

        val dm = DisplayMetrics()
        context.windowManager.defaultDisplay.getMetrics(dm)
        val height = dm.heightPixels
        val width = dm.widthPixels
        val density = dm.density * 160f
        val size = sqrt((width / dm.xdpi).pow(2) + (height / dm.ydpi).pow(2))

        return ComposeView(requireContext()).apply {
            setContent {
                MainScreen(
                    availMemory = availMemory,
                    totalMemory = totalMemory,
                    height = height,
                    width = width,
                    density = density,
                    size = size
                )

            }
        }
    }
}

@Composable
fun MainScreen(
    viewModel: DeviceInfoViewModel = hiltViewModel(),
    availMemory: Double,
    totalMemory: Double,
    height: Int,
    width: Int,
    density: Float,
    size: Float,
) {

    Box(
        modifier = Modifier
            .fillMaxSize()
            .background(backColorPrimary)
    ) {

        when (val state = viewModel.state.value) {
            is DeviceInfoState.Loading -> {
                Loading()
            }

            is DeviceInfoState.Success -> {
                DeviceInfo(
                    info = state.infoList,
                    availMemory = availMemory,
                    totalMemory = totalMemory,
                    height = height,
                    width = width,
                    density = density,
                    size = size
                )
            }
        }
        Button(
            onClick = {
                viewModel.load()
            },
            Modifier
                .padding(bottom = 30.dp)
                .align(Alignment.BottomCenter),
            colors = ButtonDefaults.buttonColors(contentColor = buttonTextColorPrimary, containerColor = buttonColorPrimary)
        ) {
            Text(text = stringResource(id = R.string.check))
        }
    }
}

@Composable
fun Loading() {
    Column(
        Modifier.fillMaxSize(),
        verticalArrangement = Arrangement.Center,
        horizontalAlignment = Alignment.CenterHorizontally
    ) {
        Text(text = stringResource(id = R.string.collect), color = textColorPrimary)
        Spacer(modifier = Modifier.height(10.dp))
        LinearProgressIndicator(color = buttonColorPrimary)
    }
}


""", fileName: "MainFragment.kt")
    }
    
    
}
