//
//  File.swift
//  
//
//  Created by admin on 8/23/23.
//
import Foundation

struct ITQuickCacl: FileProviderProtocol {
    
    static var fileName: String = "Calculator.kt"
    
    static func fileContent(packageName: String, uiSettings: UISettings) -> String {
        """
package \(packageName).presentation.fragments.main_fragment

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.aspectRatio
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.Card
import androidx.compose.material3.CardDefaults
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.TextStyle
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.hilt.navigation.compose.hiltViewModel
import androidx.lifecycle.ViewModel
import \(packageName).R
import dagger.hilt.android.lifecycle.HiltViewModel
import javax.inject.Inject

val backColorPrimary = Color(0xff\(uiSettings.backColorPrimary ?? "FFFFFF"))
val buttonColorPrimary = Color(0xff\(uiSettings.buttonColorPrimary ?? "FFFFFF"))
val buttonTextColorPrimary = Color(0xff\(uiSettings.buttonTextColorPrimary ?? "FFFFFF"))
val buttonColorSecondary = Color(0xff\(uiSettings.buttonColorSecondary ?? "FFFFFF"))
val primaryColor = Color(0xff\(uiSettings.primaryColor ?? "FFFFFF"))

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun CalcButton(
    symbol: String,
    modifier: Modifier = Modifier,
    color: Color = buttonColorPrimary,
    textStyle: TextStyle = TextStyle(),
    onClick: () -> Unit
) {
    Card(
        shape = RoundedCornerShape(15.dp),
        modifier = modifier,
        onClick = onClick,
        colors = CardDefaults.cardColors(containerColor = color, contentColor = buttonTextColorPrimary),
    ) {
        Box(Modifier.fillMaxSize(), Alignment.Center){
            Text(
                text = symbol,
                style = textStyle,
                fontSize = 36.sp,
            )
        }
    }
}

@Composable
fun CalcScreen(viewModel: CalcViewModel = hiltViewModel()) {

    val state = viewModel.state

    Box(
        modifier = Modifier
            .fillMaxSize()
            .background(backColorPrimary)
            .padding(16.dp)
    ) {
        Column(
            modifier = Modifier
                .fillMaxWidth()
                .align(Alignment.BottomCenter),
            verticalArrangement = Arrangement.spacedBy(8.dp),
        ) {

            Text(
                text = state.number1 + (state.operation?.symbol ?: "") + state.number2,
                textAlign = TextAlign.End,
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(vertical = 32.dp),
                fontWeight = FontWeight.Light,
                fontSize = 80.sp,
                color = buttonTextColorPrimary,
                maxLines = 2
            )

            Row(
                modifier = Modifier
                    .fillMaxWidth(),
                horizontalArrangement = Arrangement.spacedBy(8.dp)
            ) {
                CalcButton(
                    symbol = stringResource(id = R.string.clear),
                    color = buttonColorSecondary,
                    modifier = Modifier
                        .aspectRatio(2f)
                        .weight(2f)
                ) {
                    viewModel.onEvent(CalcEvent.Clear)
                }
                CalcButton(
                    symbol = stringResource(id = R.string.delete),
                    color = buttonColorSecondary,
                    modifier = Modifier
                        .aspectRatio(1f)
                        .weight(1f)
                ) {
                    viewModel.onEvent(CalcEvent.Delete)
                }
                CalcButton(
                    symbol = stringResource(id = R.string.divide),
                    color = primaryColor,
                    modifier = Modifier
                        .aspectRatio(1f)
                        .weight(1f)
                ) {
                    viewModel.onEvent(CalcEvent.Operation(CalcOperation.Divide))
                }
            }

            Row(
                modifier = Modifier
                    .fillMaxWidth(),
                horizontalArrangement = Arrangement.spacedBy(8.dp)
            ) {
                CalcButton(
                    symbol = stringResource(id = R.string.seven),
                    modifier = Modifier
                        .aspectRatio(1f)
                        .weight(1f)
                ) {
                    viewModel.onEvent(CalcEvent.Number(7))
                }
                CalcButton(
                    symbol = stringResource(id = R.string.eight),
                    modifier = Modifier
                        .aspectRatio(1f)
                        .weight(1f)
                ) {
                    viewModel.onEvent(CalcEvent.Number(8))
                }
                CalcButton(
                    symbol = stringResource(id = R.string.nine),
                    modifier = Modifier
                        .aspectRatio(1f)
                        .weight(1f)
                ) {
                    viewModel.onEvent(CalcEvent.Number(9))
                }
                CalcButton(
                    symbol = stringResource(id = R.string.multiply),
                    color = primaryColor,
                    modifier = Modifier
                        .aspectRatio(1f)
                        .weight(1f)
                ) {
                    viewModel.onEvent(CalcEvent.Operation(CalcOperation.Multiply))
                }
            }

            Row(
                modifier = Modifier
                    .fillMaxWidth(),
                horizontalArrangement = Arrangement.spacedBy(8.dp)
            ) {
                CalcButton(
                    symbol = stringResource(id = R.string.four),
                    modifier = Modifier
                        .aspectRatio(1f)
                        .weight(1f)
                ) {
                    viewModel.onEvent(CalcEvent.Number(4))
                }
                CalcButton(
                    symbol = stringResource(id = R.string.five),
                    modifier = Modifier
                        .aspectRatio(1f)
                        .weight(1f)
                ) {
                    viewModel.onEvent(CalcEvent.Number(5))
                }
                CalcButton(
                    symbol = stringResource(id = R.string.six),
                    modifier = Modifier
                        .aspectRatio(1f)
                        .weight(1f)
                ) {
                    viewModel.onEvent(CalcEvent.Number(6))
                }
                CalcButton(
                    symbol = stringResource(id = R.string.sub),
                    color = primaryColor,
                    modifier = Modifier
                        .aspectRatio(1f)
                        .weight(1f)
                ) {
                    viewModel.onEvent(CalcEvent.Operation(CalcOperation.Subtract))
                }
            }

            Row(
                modifier = Modifier
                    .fillMaxWidth(),
                horizontalArrangement = Arrangement.spacedBy(8.dp)
            ) {
                CalcButton(
                    symbol = stringResource(id = R.string.one),
                    modifier = Modifier
                        .aspectRatio(1f)
                        .weight(1f)
                ) {
                    viewModel.onEvent(CalcEvent.Number(1))
                }
                CalcButton(
                    symbol = stringResource(id = R.string.two),
                    modifier = Modifier
                        .aspectRatio(1f)
                        .weight(1f)
                ) {
                    viewModel.onEvent(CalcEvent.Number(2))
                }
                CalcButton(
                    symbol = stringResource(id = R.string.three),
                    modifier = Modifier
                        .aspectRatio(1f)
                        .weight(1f)
                ) {
                    viewModel.onEvent(CalcEvent.Number(3))
                }
                CalcButton(
                    symbol = stringResource(id = R.string.add),
                    color = primaryColor,
                    modifier = Modifier
                        .aspectRatio(1f)
                        .weight(1f)
                ) {
                    viewModel.onEvent(CalcEvent.Operation(CalcOperation.Add))
                }
            }

            Row(
                modifier = Modifier
                    .fillMaxWidth(),
                horizontalArrangement = Arrangement.spacedBy(8.dp)
            ) {
                CalcButton(
                    symbol = stringResource(id = R.string.zero),
                    modifier = Modifier
                        .aspectRatio(2f)
                        .weight(2f)
                ) {
                    viewModel.onEvent(CalcEvent.Number(0))
                }
                CalcButton(
                    symbol = stringResource(id = R.string.point),
                    color = buttonColorSecondary,
                    modifier = Modifier
                        .aspectRatio(1f)
                        .weight(1f)
                ) {
                    viewModel.onEvent(CalcEvent.Decimal)
                }
                CalcButton(
                    symbol = stringResource(id = R.string.equals),
                    color = buttonColorSecondary,
                    modifier = Modifier
                        .aspectRatio(1f)
                        .weight(1f)
                ) {
                    viewModel.onEvent(CalcEvent.Calculate)
                }
            }
        }
    }
}

data class CalcState(
    val number1: String = "",
    val number2: String = "",
    val operation: CalcOperation? = null
)

sealed class CalcEvent {
    data class Number(val number: Int): CalcEvent()
    object Clear: CalcEvent()
    object Delete: CalcEvent()
    data class Operation(val operation: CalcOperation): CalcEvent()
    object Calculate: CalcEvent()
    object Decimal: CalcEvent()
}

sealed class CalcOperation(val symbol: String) {
    object Add: CalcOperation("+")
    object Subtract: CalcOperation("-")
    object Multiply: CalcOperation("x")
    object Divide: CalcOperation("/")
}

@HiltViewModel
class CalcViewModel @Inject constructor() : ViewModel() {

    var state by mutableStateOf(CalcState())

    private fun calculate() {

        val number1 = state.number1.toDoubleOrNull()
        val number2 = state.number2.toDoubleOrNull()

        if (number1 != null && number2 != null) {
            val result = when (state.operation) {
                is CalcOperation.Add -> number1 + number2
                is CalcOperation.Subtract -> number1 - number2
                is CalcOperation.Multiply -> number1 * number2
                is CalcOperation.Divide -> number1 / number2
                null -> return
            }
            state = state.copy(
                number1 = result.toString().take(15),
                number2 = "",
                operation = null
            )
        }
    }

    fun onEvent(event: CalcEvent) {
        when (event) {
            is CalcEvent.Number -> setNumber(event.number)
            is CalcEvent.Delete -> delete()
            is CalcEvent.Clear -> state = CalcState()
            is CalcEvent.Operation -> setOperation(event.operation)
            is CalcEvent.Decimal -> setDecimal()
            is CalcEvent.Calculate -> calculate()
        }
    }

    private fun setOperation(operation: CalcOperation) {
        if (state.number1.isNotBlank()) {
            state = state.copy(operation = operation)
        }
    }

    private fun delete() {
        when {
            state.number2.isNotBlank() -> state = state.copy(
                number2 = state.number2.dropLast(1)
            )

            state.operation != null -> state = state.copy(
                operation = null
            )

            state.number1.isNotBlank() -> state = state.copy(
                number1 = state.number1.dropLast(1)
            )
        }
    }

    private fun setDecimal() {
        if (state.operation == null && !state.number1.contains(".") && state.number1.isNotBlank()) {
            state = state.copy(
                number1 = state.number1 + "."
            )
            return
        } else if (!state.number2.contains(".") && state.number2.isNotBlank()) {
            state = state.copy(
                number2 = state.number2 + "."
            )
        }
    }

    private fun setNumber(number: Int) {
        if (state.operation == null) {
            if (state.number1.length >= 8) {
                return
            }
            state = state.copy(
                number1 = state.number1 + number
            )
            return
        }
        if (state.number2.length >= 8) {
            return
        }
        state = state.copy(
            number2 = state.number2 + number
        )
    }
}


"""
    }
    
    static func dependencies(_ mainData: MainData) -> ANDData {
        return ANDData(
            mainFragmentData: ANDMainFragment(imports: "", content: """
                CalcScreen()
"""),
            mainActivityData: ANDMainActivity(imports: "", extraFunc: "", content: ""),
            themesData: ANDThemesData(isDefault: true, content: ""),
            stringsData: ANDStringsData(additional: """
    <string name="zero">0</string>
    <string name="one">1</string>
    <string name="two">2</string>
    <string name="three">3</string>
    <string name="four">4</string>
    <string name="five">5</string>
    <string name="six">6</string>
    <string name="seven">7</string>
    <string name="eight">8</string>
    <string name="nine">9</string>
    <string name="point">.</string>
    <string name="clear">AC</string>
    <string name="delete">Del</string>
    <string name="divide">/</string>
    <string name="multiply">x</string>
    <string name="sub">-</string>
    <string name="add">+</string>
    <string name="equals">=</string>
"""),
            colorsData: ANDColorsData(additional: ""))
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
    const val glide = "4.12.0"
    const val swipe = "0.19.0"
    const val glide_skydoves = "1.3.9"
    const val retrofit = "2.9.0"
    const val okhttp = "4.10.0"
    const val room = "2.5.0"
    const val coil = "1.3.2"
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
    const val compose_splash = "androidx.core:core-splashscreen:${Versions.splash}"
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
    

    
}

