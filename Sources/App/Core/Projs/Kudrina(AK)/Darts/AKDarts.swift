//
//  File.swift
//  
//
//  Created by admin on 29.08.2023.
//

import Foundation

struct AKDarts: FileProviderProtocol {
    static var fileName = "\(NamesManager.shared.fileName).kt"
    
    static func fileContent(packageName: String, uiSettings: UISettings) -> String {
        return """
package \(packageName).presentation.fragments.main_fragment

import android.view.MotionEvent
import androidx.compose.foundation.Canvas
import androidx.compose.foundation.Image
import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.interaction.MutableInteractionSource
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.offset
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.SnackbarData
import androidx.compose.material.SnackbarHost
import androidx.compose.material.SnackbarHostState
import androidx.compose.material3.Button
import androidx.compose.material3.ButtonDefaults
import androidx.compose.material3.Card
import androidx.compose.material3.CardDefaults
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.MutableState
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.rememberCoroutineScope
import androidx.compose.ui.Alignment
import androidx.compose.ui.ExperimentalComposeUiApi
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.input.pointer.pointerInteropFilter
import androidx.compose.ui.platform.LocalConfiguration
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.platform.LocalDensity
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.Dp
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.navigation.NavController
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import androidx.navigation.compose.rememberNavController
import \(packageName).R
import kotlinx.coroutines.delay
import kotlinx.coroutines.launch
import kotlin.math.absoluteValue

val backColorPrimary = Color(0xFF\(uiSettings.backColorPrimary ?? "FFFFFF"))
val buttonColorPrimary = Color(0xFF\(uiSettings.buttonColorPrimary ?? "FFFFFF"))
val textColorPrimary = Color(0xFF\(uiSettings.textColorPrimary ?? "FFFFFF"))


val firstTarget = Color(0xFFC50707)
val secondTarget = Color(0xFFFFE21F)
val thirdTarget = Color(0xFF3F92EB)
val forthTarget = Color(0xFF04DF1A)
val fifthTarget = Color(0xFFD205E9)

val listOfColors = listOf(firstTarget, secondTarget, thirdTarget, forthTarget, fifthTarget)

@Composable
fun Navigation() {
    val navController = rememberNavController()

    NavHost(navController = navController, startDestination = Screen.StartScreen.route) {

        composable(Screen.StartScreen.route) {
           StartScreen(navController = navController)
        }

        composable(Screen.GameScreen.route) {
            GameScreen(navController)
        }

    }
}


sealed class Screen(val route: String) {
    object StartScreen : Screen(route = "start_screen")

    object GameScreen : Screen(route = "game_screen")
}

@Composable
fun StartScreen(navController: NavController) {

    Column(
        modifier = Modifier
            .fillMaxSize()
            .background(backColorPrimary)
            .padding(20.dp),
        verticalArrangement = Arrangement.Center,
        horizontalAlignment = Alignment.CenterHorizontally
    ) {

        Button(
            onClick = {
                navController.navigate(Screen.GameScreen.route)
            },
            colors = ButtonDefaults.buttonColors(containerColor = buttonColorPrimary)
        ) {
            Text(
                text = stringResource(id = R.string.start_button_text),
                color = textColorPrimary
            )
        }
    }
}


@Composable
fun GameScreen(navController: NavController) {

    val snackbarHostState = remember { SnackbarHostState() }

    // Screen sizes
    val configuration = LocalConfiguration.current
    val density = LocalDensity.current
    val widthInDp = configuration.screenWidthDp
    val heightInDp = configuration.screenHeightDp
    val widthInPx = with(density) { widthInDp.dp.roundToPx() }
    val heightInPx = with(density) { heightInDp.dp.roundToPx() }
    val xModif = widthInDp.toFloat() / widthInPx.toFloat()

    val yPositionForItems = heightInDp / 20
    val stepForTargets = widthInDp / 5
    val sizeForItem = widthInDp / 10

    val toHide = remember { mutableListOf(false, false, false, false, false) }

    Box(
        modifier = Modifier
            .fillMaxSize()
            .background(backColorPrimary)
            .padding(20.dp),
    ) {

        for (i in listOfColors.indices) {
            Target(
                x = stepForTargets.dp * i,
                y = yPositionForItems.dp * 2,
                color = listOfColors[i],
                size = sizeForItem.dp,
                toHide = toHide[i]
            )
        }

        val xPosition = remember { mutableStateOf((widthInDp / 2).dp - sizeForItem.dp / 3 * 2) }
        val yPosition = remember { mutableStateOf((heightInDp - sizeForItem * 3).dp) }

        val isReady = remember { mutableStateOf(false) }

        val actionDownX = remember { mutableStateOf(0f) }
        val actionDownY = remember { mutableStateOf(0f) }
        val actionUpX = remember { mutableStateOf(0f) }
        val actionUpY = remember { mutableStateOf(0f) }

        val metricDif = remember {
            mutableStateOf(widthInPx.toFloat()/heightInPx.toFloat())
        }

        val context = LocalContext.current
        if (!toHide.contains(false)) {
            LaunchedEffect(key1 = true) {
                snackbarHostState.showSnackbar(context.getString(R.string.won))
                navController.navigate(Screen.StartScreen.route) {
                    popUpTo(0)
                }
            }

        }

        if (isReady.value) {
            MoveDart(xPosition, yPosition, actionUpX, actionDownX, actionUpY, actionDownY, sizeForItem, yPositionForItems, xModif, metricDif.value)
        }

        if (
            yPosition.value<=yPositionForItems.dp * 2
            || yPosition.value>heightInDp.dp+100.dp
            || xPosition.value< (-100).dp
            || xPosition.value>widthInDp.dp+100.dp
        ) {
            hitBoll(xPosition, yPosition, sizeForItem, stepForTargets, toHide, isReady, widthInDp, heightInDp)
        }

        Dart(xPosition, yPosition, actionDownX, actionUpX, actionDownY, actionUpY, metricDif, isReady, sizeForItem)
    }

    MySnackbar(snackbarHostState)
}

@OptIn(ExperimentalComposeUiApi::class)
@Composable
fun Dart(
    xPosition: MutableState<Dp>,
    yPosition: MutableState<Dp>,
    actionDownX: MutableState<Float>,
    actionUpX: MutableState<Float>,
    actionDownY: MutableState<Float>,
    actionUpY: MutableState<Float>,
    metricDif: MutableState<Float>,
    isReady: MutableState<Boolean>,
    sizeForItem: Int
) {
    Box(
        modifier = Modifier
            .offset(x = xPosition.value, y = yPosition.value)
            .pointerInteropFilter {
                when (it.action) {
                    MotionEvent.ACTION_DOWN -> {
                        actionDownX.value = it.x
                        actionDownY.value = it.y
                    }

                    MotionEvent.ACTION_UP -> {
                        actionUpX.value = it.x
                        actionUpY.value = it.y
                        metricDif.value =
                            (actionDownX.value - actionUpX.value).absoluteValue / (actionDownY.value + actionUpY.value).absoluteValue
                        isReady.value = true
                    }
                }
                true
            }

    ) {
        Image(
            modifier = Modifier
                .height(sizeForItem.dp * 2)
                .width(sizeForItem.dp / 3 * 2),
            painter = painterResource(id = R.drawable.dart),
            contentDescription = stringResource(id = R.string.dart_img_des)
        )
    }
}

// future x position
fun countX(xPosition: MutableState<Dp>, actionUpX: MutableState<Float>, sizeForItem: Int, actionDownX: MutableState<Float>, xModif: Float): Dp {
    var diff = 0f
    var currentXPosition = xPosition.value
    when {
        actionUpX.value < 0 -> {
            diff = actionUpX.value - sizeForItem / 3 * 2
        }

        actionUpX.value >= 0 -> {
            diff = actionUpX.value - actionDownX.value
        }
    }

    currentXPosition += (diff * xModif).dp
    return currentXPosition
}

fun countY(actionUpY: MutableState<Float>, actionDownY: MutableState<Float>, yPositionForItems: Int): Dp {
    var diff = 0f

    if (actionUpY.value < 0) {
        diff = (actionUpY.value + actionDownY.value).absoluteValue
    }

    when  {
        diff > yPositionForItems && diff <= yPositionForItems*3 -> {
            return 10.dp
        }
        diff > yPositionForItems*3 && diff <= yPositionForItems*6 -> {
            return 12.dp
        }
        diff > yPositionForItems*6 && diff <= yPositionForItems*9 -> {
            return 14.dp
        }
        diff > yPositionForItems*9 && diff <= yPositionForItems*12 -> {
            return 16.dp
        }
        diff > yPositionForItems*12 && diff <= yPositionForItems*15 -> {
            return 18.dp
        }
    }
    return 9.dp
}

@Composable
fun MoveDart(
    xPosition: MutableState<Dp>,
    yPosition: MutableState<Dp>,
    actionUpX: MutableState<Float>,
    actionDownX: MutableState<Float>,
    actionUpY: MutableState<Float>,
    actionDownY: MutableState<Float>,
    sizeForItem: Int,
    yPositionForItems: Int,
    xModif: Float,
    metricDif: Float,
) {
    val composableScope = rememberCoroutineScope()
    val futureX = countX(xPosition, actionUpX, sizeForItem, actionDownX, xModif)
    val speed = countY(actionUpY, actionDownY, yPositionForItems)

    LaunchedEffect(key1 = Unit) {
        composableScope.launch {

            while (yPosition.value >= yPositionForItems.dp * 2) {
                if (xPosition.value <= futureX) {
                    xPosition.value += speed*metricDif*0.5f
                }
                if (xPosition.value >= futureX) {
                    xPosition.value -= speed*metricDif*0.5f
                }
                yPosition.value -= speed
                delay(50)
            }

        }
    }
}

fun hitBoll(
    xPosition: MutableState<Dp>,
    yPosition: MutableState<Dp>,
    sizeForItem: Int,
    stepForTargets: Int,
    toHide: MutableList<Boolean>,
    isReady: MutableState<Boolean>,
    widthInDp: Int,
    heightInDp: Int,
) {
    when {
        xPosition.value >= 0.dp && xPosition.value <= sizeForItem.dp -> {
            toHide[0] = true
        }
        xPosition.value >= stepForTargets.dp && xPosition.value <= stepForTargets.dp+sizeForItem.dp -> {
            toHide[1] = true
        }
        xPosition.value >= stepForTargets.dp*2 && xPosition.value <= stepForTargets.dp*2+sizeForItem.dp-> {
            toHide[2] = true
        }
        xPosition.value >= stepForTargets.dp*3 && xPosition.value <= stepForTargets.dp*3+sizeForItem.dp -> {
            toHide[3] = true
        }
        xPosition.value >= stepForTargets.dp*4 && xPosition.value <= stepForTargets.dp*4+sizeForItem.dp -> {
            toHide[4] = true
        }
    }


    isReady.value = false
    xPosition.value = (widthInDp / 2).dp - sizeForItem.dp / 3 * 2
    yPosition.value = (heightInDp - sizeForItem * 3).dp
}



@Composable
fun MySnackbar(snackbarHostState: SnackbarHostState) {
    SnackbarHost(
        hostState = snackbarHostState,
        snackbar = { snackbarData: SnackbarData ->
            Card(
                modifier = Modifier
                    .padding(16.dp)
                    .fillMaxWidth(),
                shape = RoundedCornerShape(16.dp),
                colors = CardDefaults.cardColors(containerColor = buttonColorPrimary),
            ) {
                Column(
                    modifier = Modifier
                        .padding(16.dp)
                        .fillMaxWidth(),
                ) {
                    androidx.compose.material.Text(
                        modifier = Modifier
                            .fillMaxWidth(),
                        text = snackbarData.message,
                        color = textColorPrimary,
                        fontSize = 20.sp,
                        textAlign = TextAlign.Center
                    )
                }

            }

        }
    )
}

@Composable
fun Target(x: Dp, y: Dp, color: Color, size: Dp, toHide: Boolean) {

    if (!toHide) {
        val interactionSource = remember { MutableInteractionSource() }
        Canvas(
            modifier = Modifier
                .size(size = size)
                .offset(x = x, y = y)
                .clickable(
                    interactionSource = interactionSource,
                    indication = null
                ) {

                }
        ) {
            drawCircle(
                color = color
            )
        }
    }
}

"""
    }
    
    static func dependencies(_ mainData: MainData) -> ANDData {
        return ANDData(mainFragmentData: ANDMainFragment(imports: "", content: """
    Navigation()
"""), mainActivityData: ANDMainActivity(imports: "", extraFunc: "", content: ""), themesData: ANDThemesData(isDefault: true, content: ""), stringsData: ANDStringsData(additional: """
    <string name="dart_img_des">dart</string>
    <string name="start_button_text">Start</string>
    <string name="won">You won!</string>
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
            signingConfig signingConfigs.debug

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

    implementation Dependencies.lifecycle_runtime
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
