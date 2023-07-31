//
//  File.swift
//  
//
//  Created by admin on 14.06.2023.
//

import Foundation

struct MBSpeedTest: FileProviderProtocol {
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
                imports: """
import androidx.compose.ui.platform.LocalContext
""",
                content: """
            val context = LocalContext.current
            SpeedTestTheme {
                MainScreen(
                    downSpeed = ConnectManager.getDownloadSpeed(context),
                    upSpeed = ConnectManager.getUploadSpeed(context)
                )
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
    
    static var fileName = "MBSpeedTest.kt"
    static func fileContent(
        packageName: String,
        uiSettings: UISettings
    ) -> String {
        return """
package \(packageName).presentation.fragments.main_fragment

import android.content.Context
import android.net.ConnectivityManager
import android.net.NetworkCapabilities
import androidx.compose.animation.core.Animatable
import androidx.compose.animation.core.AnimationVector1D
import androidx.compose.animation.core.tween
import androidx.compose.foundation.Canvas
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.aspectRatio
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Typography
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.remember
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.geometry.Offset
import androidx.compose.ui.geometry.Size
import androidx.compose.ui.graphics.Brush
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.drawscope.DrawScope
import androidx.compose.ui.text.ExperimentalTextApi
import androidx.compose.ui.text.TextMeasurer
import androidx.compose.ui.text.TextStyle
import androidx.compose.ui.text.drawText
import androidx.compose.ui.text.font.FontFamily
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.rememberTextMeasurer
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp

val backColor = Color(0xFF\(uiSettings.backColorPrimary ?? "FFFFFF"))
val mainTextColor = Color(0xFF\(uiSettings.textColorPrimary ?? "FFFFFF"))
val mainButtonColor = Color(0xFF\(uiSettings.buttonColorPrimary ?? "FFFFFF"))
val lapTextColor = Color(0xFF\(uiSettings.buttonColorSecondary ?? "FFFFFF"))
val mainTextSize = \(uiSettings.textSizePrimary ?? 24)
val mainPadding = \(uiSettings.paddingPrimary ?? 12)

val Typography = Typography(
    bodyLarge = TextStyle(
        fontFamily = FontFamily.Default,
        fontWeight = FontWeight.Normal,
        fontSize = mainTextSize.sp,
        lineHeight = 24.sp,
        letterSpacing = 0.5.sp
    ),
    displayMedium = TextStyle(
        fontFamily = FontFamily.Default,
        fontSize = mainTextSize.sp,
        lineHeight = 24.sp,
        letterSpacing = 1.sp
    ),
    displaySmall = TextStyle(
        fontFamily = FontFamily.Default,
        fontWeight = FontWeight.W300,
        fontSize = mainTextSize.sp,
        lineHeight = 24.sp,
        letterSpacing = 0.4.sp,
        textAlign = TextAlign.Center
    ),
    displayLarge = TextStyle(
        fontFamily = FontFamily.Default,
        fontWeight = FontWeight.W500,
        fontSize = mainTextSize.sp,
        lineHeight = 24.sp,
        letterSpacing = 0.4.sp,
        textAlign = TextAlign.Center
    )
)

@Composable
fun SpeedTestTheme(
    content: @Composable () -> Unit
) {
    MaterialTheme(
        typography = Typography,
        content = content
    )
}

@Composable
fun MainScreen(downSpeed: Float, upSpeed: Float) {
    Column(
        modifier = Modifier
            .fillMaxSize()
                    .background(color = backColor),
        verticalArrangement = Arrangement.SpaceEvenly,
        horizontalAlignment = Alignment.CenterHorizontally
    ) {
        val loadFactor = upSpeed / downSpeed
        val downLoadFactor = if (loadFactor > 1f) loadFactor else 1f
        val upLoadFactor = if (loadFactor > 1f) 1f else loadFactor
        Column(
            modifier = Modifier
                .padding(mainPadding.dp)
                    .background(color = backColor),
            horizontalAlignment = Alignment.CenterHorizontally,
            verticalArrangement = Arrangement.Center
        ) {
            val angle = remember {
                Animatable(0f)
            }
            LaunchedEffect(Unit) {
                angle.animateTo(
                    targetValue = 180f * upLoadFactor,
                    animationSpec = tween(5000)
                )
            }
            SpeedCanvas(
                angle = angle,
                textMeasurer = rememberTextMeasurer(),
                speed = upSpeed.toInt(),
                secondArcBackgroundColor = mainButtonColor,
                speedType = "Upload"
            )
        }
        Column(
            modifier = Modifier
                .padding(mainPadding.dp)
                    .background(color = backColor),
            horizontalAlignment = Alignment.CenterHorizontally,
            verticalArrangement = Arrangement.Center
        ) {
            val angle = remember {
                Animatable(0f)
            }
            LaunchedEffect(Unit) {
                angle.animateTo(
                    targetValue = 180f * downLoadFactor,
                    animationSpec = tween(5000)
                )
            }
            SpeedCanvas(
                angle = angle,
                textMeasurer = rememberTextMeasurer(),
                speed = downSpeed.toInt(),
                secondArcBackgroundColor = mainButtonColor,
                speedType = "Download"
            )
        }
    }
}

@Composable
fun SpeedCanvas(
    angle: Animatable<Float, AnimationVector1D>,
    textMeasurer: TextMeasurer,
    speed: Int,
    secondArcBackgroundColor: Color,
    speedType: String
) {
    Canvas(
        modifier = Modifier
            .fillMaxWidth(0.9f)
            .aspectRatio(1f)
                    .background(color = backColor)
    ) {
        val firstArcSize = size.width
        val firstArcOffset = (size.width - firstArcSize) / 2
        val secondArcSize = firstArcSize - 100
        val secondArcOffset = firstArcOffset + (firstArcSize - secondArcSize) / 2

        drawProgressLine(
            brush = Brush.verticalGradient(colors = listOf(lapTextColor, lapTextColor)),
            angle = angle,
            firstArcSize = firstArcSize,
            firstArcOffset = firstArcOffset,
            secondArcBackgroundColor = secondArcBackgroundColor,
            secondArcSize = secondArcSize,
            secondArcOffset = secondArcOffset
        )
        drawInfo(
            textMeasurer = textMeasurer,
            speed = "${speed}mbps",
            firstArcSize = firstArcSize,
            firstArcOffset = firstArcOffset,
            textStyle = TextStyle(
                fontFamily = FontFamily.Default,
                fontWeight = FontWeight.W500,
                fontSize = mainTextSize.sp,
                lineHeight = 24.sp,
                letterSpacing = 0.4.sp,
                textAlign = TextAlign.Center,
                color = mainTextColor,
            ),
            speedType = speedType
        )
    }
}

fun DrawScope.drawProgressLine(
    brush: Brush,
    angle: Animatable<Float, AnimationVector1D>,
    firstArcSize: Float,
    firstArcOffset: Float,
    secondArcBackgroundColor: Color?,
    secondArcSize: Float,
    secondArcOffset: Float
) {
    drawArc(
        brush = brush,
        startAngle = -180f,
        sweepAngle = angle.value,
        useCenter = true,
        size = Size(firstArcSize, firstArcSize),
        topLeft = Offset(
            firstArcOffset,
            firstArcOffset
        )
    )
    secondArcBackgroundColor?.let { backgroundColor ->
        drawArc(
            color = backgroundColor,
            startAngle = -180f,
            sweepAngle = 180f,
            useCenter = true,
            size = Size(secondArcSize, secondArcSize),
            topLeft = Offset(
                secondArcOffset,
                secondArcOffset + 1 // +1 because the second arc appears a little higher than the first
            )
        )
    }
}

@OptIn(ExperimentalTextApi::class)
fun DrawScope.drawInfo(
    textMeasurer: TextMeasurer,
    speed: String,
    firstArcSize: Float,
    firstArcOffset: Float,
    textStyle: TextStyle,
    speedType: String
) {
    drawText(
        textMeasurer = textMeasurer,
        text = speed,
        size = Size(firstArcSize, firstArcSize),
        topLeft = Offset(
            x = firstArcOffset,
            y = firstArcOffset + firstArcSize / 3
        ),
        style = textStyle
    )
    drawText(
        textMeasurer = textMeasurer,
        text = speedType,
        size = Size(firstArcSize, firstArcSize),
        topLeft = Offset(
            x = firstArcOffset,
            y = firstArcOffset + firstArcSize / 2
        ),
        style = textStyle
    )
}

object ConnectManager {

    private lateinit var connectivityManager: ConnectivityManager
    private var networkCapabilities: NetworkCapabilities? = null

    private fun initialize(context: Context){
        connectivityManager = context.getSystemService(Context.CONNECTIVITY_SERVICE) as ConnectivityManager
        networkCapabilities = connectivityManager.getNetworkCapabilities(connectivityManager.activeNetwork)
    }

    fun getUploadSpeed(context: Context): Float{
        if (networkCapabilities == null)
            initialize(context)
        return (networkCapabilities?.linkUpstreamBandwidthKbps?.toFloat() ?: 0.1f) / 125f
    }

    fun getDownloadSpeed(context: Context): Float{
        if (networkCapabilities == null)
            initialize(context)
        return (networkCapabilities?.linkDownstreamBandwidthKbps?.toFloat() ?: 0.1f) / 125f
    }
}
"""
    }
}
