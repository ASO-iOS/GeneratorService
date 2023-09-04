//
//  File.swift
//  
//
//  Created by admin on 01.09.2023.
//

import Foundation

struct AKSpaceAttacker: FileProviderProtocol {
    static var fileName: String = "AKSpaceAttacker.kt"
    
    static func fileContent(packageName: String, uiSettings: UISettings) -> String {
        return """
package \(packageName).presentation.fragments.main_fragment

import android.content.Context
import androidx.compose.foundation.Image
import androidx.compose.foundation.background
import androidx.compose.foundation.gestures.detectTapGestures
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
import androidx.compose.material.Text
import androidx.compose.material3.Button
import androidx.compose.material3.ButtonDefaults
import androidx.compose.material3.Card
import androidx.compose.material3.CardDefaults
import androidx.compose.material3.CircularProgressIndicator
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.MutableState
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.rememberCoroutineScope
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.input.pointer.pointerInput
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.platform.LocalConfiguration
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.Dp
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.datastore.core.DataStore
import androidx.datastore.preferences.core.Preferences
import androidx.datastore.preferences.core.edit
import androidx.datastore.preferences.core.intPreferencesKey
import androidx.datastore.preferences.preferencesDataStore
import androidx.hilt.navigation.compose.hiltViewModel
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import androidx.navigation.NamedNavArgument
import androidx.navigation.NavController
import androidx.navigation.NavType
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import androidx.navigation.compose.rememberNavController
import androidx.navigation.navArgument
import \(packageName).R
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.cancel
import kotlinx.coroutines.delay
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.map
import kotlinx.coroutines.isActive
import kotlinx.coroutines.launch
import javax.inject.Inject

val backColorPrimary = Color(0xFF\(uiSettings.backColorPrimary ?? "FFFFFF"))
val buttonColorSecondary = Color(0xFF\(uiSettings.buttonColorSecondary ?? "FFFFFF"))
val buttonColorPrimary = Color(0xFF\(uiSettings.buttonColorPrimary ?? "FFFFFF"))
val textColorPrimary = Color(0xFF\(uiSettings.textColorPrimary ?? "FFFFFF"))

const val easyLevel = "EASY"
const val mediumLevel = "MEDIUM"
const val hardLevel = "HARD"

@Composable
fun BackgroundImage() {
    Image(
        modifier = Modifier
            .fillMaxSize(),
        painter = painterResource(id = R.drawable.background),
        contentDescription = stringResource(id = R.string.bg_image_desc),
        contentScale = ContentScale.FillBounds
    )
}

@Composable
fun StartScreen(navController: NavController, score: Int?, viewModel: StartViewModel = hiltViewModel()) {

    val context = LocalContext.current
    val dataStore = GameDataStore(context.dataStore)
    val currentData = viewModel.getFromDataStore(dataStore).collectAsState(initial = 0).value

    if (score != null && currentData != null) {
        if (score > currentData) {
            LaunchedEffect(key1 = Unit) {
                viewModel.saveToDataStore(dataStore, score)
            }
        }
    }


    BackgroundImage()

    Column(
        modifier = Modifier
            .fillMaxSize(),
        verticalArrangement = Arrangement.spacedBy(32.dp, Alignment.CenterVertically),
        horizontalAlignment = Alignment.CenterHorizontally
    ) {

        Text(
            text = if (currentData==null) stringResource(id = R.string.max_score, 0) else stringResource(id = R.string.max_score, currentData.toString()),
            fontSize = 22.sp,
            color = textColorPrimary
        )

        LevelButton(
            textResForButton = R.string.button_start_easy_text,
            navController = navController,
            level = easyLevel
        )

        LevelButton(
            textResForButton = R.string.button_start_medium_text,
            navController = navController,
            level = mediumLevel
        )

        LevelButton(
            textResForButton = R.string.button_start_hard_text,
            navController = navController,
            level = hardLevel
        )
    }
}

@Composable
fun LevelButton(textResForButton: Int, navController: NavController, level: String) {
    Button(
        colors = ButtonDefaults.buttonColors(containerColor = buttonColorSecondary),
        onClick = {
            navController.navigate(Screen.GameScreen.createRoute(level))
        }
    ) {
        androidx.compose.material3.Text(
            text = stringResource(id = textResForButton),
            fontSize = 18.sp,
            color = textColorPrimary
        )
    }
}

@HiltViewModel
class StartViewModel @Inject constructor() : ViewModel(){

    fun saveToDataStore(dataStore: GameDataStore, score: Int) {
        viewModelScope.launch(Dispatchers.IO) {
            dataStore.storeScore(score)
        }
    }

    fun getFromDataStore(dataStore: GameDataStore): Flow<Int?> {
        return dataStore.userScoreFlow
    }

}


@Composable
fun SplashScreen(navController: NavController) {
    LaunchedEffect(key1 = true) {
        delay(2000L)
        navController.navigate(Screen.StartScreen.createRoute(0))
    }

    Column(
        modifier = Modifier
            .fillMaxSize()
            .background(backColorPrimary),
        verticalArrangement = Arrangement.Center,
        horizontalAlignment = Alignment.CenterHorizontally,
    ) {

        androidx.compose.material3.Text(
            modifier = Modifier.padding(bottom = 16.dp),
            text = stringResource(id = R.string.app_name),
            color = textColorPrimary,
            fontSize = 24.sp
        )

        CircularProgressIndicator(
            color = buttonColorPrimary
        )
    }
}


@Composable
fun GameScreen(navController: NavController, level: String?) {

    val snackbarHostState = remember { SnackbarHostState() }

    // Screen sizes
    val configuration = LocalConfiguration.current
    val screenWidth = configuration.screenWidthDp
    val screenHeight = configuration.screenHeightDp

    GameConstance

    val playerX = remember { mutableStateOf(screenWidth.dp / 2 - GameConstance.playerSize / 2) }
    val playerY = remember { mutableStateOf(screenHeight.dp - GameConstance.playerSize) }
    val enemyXFun = GameConstance.randomEnemyPosition(screenWidth, GameConstance.enemySizeInt)
    val enemyX = remember { mutableStateOf(enemyXFun) }
    val enemyY = remember { mutableStateOf(0.dp) }

    val ableToMovePlayer = remember { mutableStateOf(true) }

    val score = remember { mutableStateOf(0) }

    Box(
        modifier = Modifier
            .fillMaxSize(),
    ) {

        BackgroundImage()

        // Player
        GameObject(
            size = GameConstance.playerSize,
            x = playerX,
            y = playerY,
            imageRes = R.drawable.player,
            contentDescRes = R.string.player_img_desc
        )

        // Enemy
        GameObject(
            size = GameConstance.enemySize,
            x = enemyX,
            y = enemyY,
            imageRes = R.drawable.enemy,
            contentDescRes = R.string.enemy_img_desc
        )

        // Score
        ScoreText(score = score)

        MovementsLogic(
            enemyY = enemyY,
            playerY = playerY,
            enemyX = enemyX,
            playerX = playerX,
            score = score,
            screenHeight = screenHeight,
            ableToMovePlayer = ableToMovePlayer,
            navController = navController,
            snackbarHostState = snackbarHostState,
            level = level,
            enemySize = GameConstance.enemySizeInt,
            screenWidth = screenWidth
        )

        // Right Button
        Box(
            modifier = Modifier
                .fillMaxSize(),
            contentAlignment = Alignment.BottomEnd
        ) {
            GamepadBox(
                screenWidth = screenWidth,
                ableToMovePlayer = ableToMovePlayer,
                playerX = playerX,
                isRight = true
            )
        }

        // Left Button
        Box(
            modifier = Modifier
                .fillMaxSize(),
            contentAlignment = Alignment.BottomStart
        ) {
            GamepadBox(
                screenWidth = screenWidth,
                ableToMovePlayer =ableToMovePlayer,
                playerX = playerX,
                isRight =false)
        }

        //Message
        MySnackbar(snackbarHostState)
    }
}

@Composable
fun GameObject(size: Dp, x: MutableState<Dp>, y: MutableState<Dp>, imageRes: Int, contentDescRes: Int) {
    Image(
        modifier = androidx.compose.ui.Modifier
            .size(size)
            .offset(x = x.value, y = y.value),
        painter = painterResource(id = imageRes),
        contentDescription = stringResource(id = contentDescRes),
    )
}

@Composable
fun GamepadBox(
    screenWidth: Int,
    ableToMovePlayer: MutableState<Boolean>,
    playerX: MutableState<Dp>,
    isRight: Boolean,
) {

    val playerStep = remember { mutableStateOf(7.dp) }

    val isPressed = remember {
        mutableStateOf(false)
    }

    val scope = rememberCoroutineScope()

    Box(
        modifier = Modifier
            .width((screenWidth / 2).dp)
            .height(GameConstance.playerSize)
            .pointerInput(Unit) {
                detectTapGestures(
                    onPress = {
                        if (ableToMovePlayer.value) {
                            try {
                                isPressed.value = true

                                scope.launch {
                                    while (isPressed.value) {
                                        if (isRight) {
                                            if (playerX.value <= screenWidth.dp - GameConstance.playerSize) {
                                                playerX.value += playerStep.value
                                            }
                                        } else {
                                            if (playerX.value >= 0.dp) {
                                                playerX.value -= playerStep.value
                                            }
                                        }

                                        delay(65)
                                    }
                                }
                                awaitRelease()
                            } finally {
                                isPressed.value = false
                            }
                        }
                    }
                )
            }
    )
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
                    Text(
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
fun ScoreText(score: MutableState<Int>) {
    Box(
        modifier = Modifier
            .fillMaxSize(),
        contentAlignment = Alignment.TopCenter
    ) {
        androidx.compose.material3.Text(
            modifier = Modifier
                .padding(top = 16.dp),
            text = stringResource(id = R.string.score, score.value),
            color = textColorPrimary,
            fontSize = 24.sp
        )
    }
}


@Composable
fun MovementsLogic(
    enemyY: MutableState<Dp>,
    playerY: MutableState<Dp>,
    enemyX: MutableState<Dp>,
    playerX: MutableState<Dp>,
    score: MutableState<Int>,
    screenHeight: Int,
    ableToMovePlayer: MutableState<Boolean>,
    navController: NavController,
    snackbarHostState: SnackbarHostState,
    level: String?,
    enemySize: Int,
    screenWidth: Int
) {
    val composableScope = rememberCoroutineScope()

    val enemyStep = remember {
        GameConstance.getStepForCurrentLevel(level)
    }

    // Enemy movement
    LaunchedEffect(key1 = Unit) {
        composableScope.launch {
            while (enemyY.value < screenHeight.dp + GameConstance.enemySize) {
                enemyY.value += enemyStep.value
                delay(65)
            }
        }
    }

    // Score increase
    LaunchedEffect(key1 = Unit) {
        composableScope.launch {
            while (composableScope.isActive) {
                score.value += 1
                delay(50)
            }
        }
    }



    // Enemy position update when got to the end
    if (enemyY.value >= screenHeight.dp + GameConstance.enemySize) {
        enemyY.value = 0.dp
        enemyX.value = GameConstance.randomEnemyPosition(screenWidth, enemySize)
    }

    // When crashed
    if (
        (playerX.value in enemyX.value..enemyX.value + GameConstance.enemySize - GameConstance.inaccuracy ||
                playerX.value + GameConstance.playerSize - GameConstance.inaccuracy in enemyX.value..enemyX.value + GameConstance.enemySize - GameConstance.inaccuracy)
        &&
        (playerY.value in enemyY.value..enemyY.value + GameConstance.enemySize - GameConstance.inaccuracy ||
                playerY.value + GameConstance.playerSize - GameConstance.inaccuracy in enemyY.value..enemyY.value + GameConstance.enemySize - GameConstance.inaccuracy)

    ) {
        ableToMovePlayer.value = false

        val context = LocalContext.current
        LaunchedEffect(key1 = true) {
            if (score.value >= 1000) {
                snackbarHostState.showSnackbar(context.getString(R.string.won_text))
            } else {
                snackbarHostState.showSnackbar(context.getString(R.string.lost_text))
            }

            navController.navigate(Screen.StartScreen.createRoute(score.value))
        }

        composableScope.cancel()
    }
}

object GameConstance {
    val playerSize = 80.dp

    val enemySize = 100.dp
    val enemySizeInt = 100

    val inaccuracy = 35.dp

    fun randomEnemyPosition(screenWidth: Int, enemySizeInt: Int): Dp {
        val start = 0
        val end = screenWidth - enemySizeInt
        return (start..end).random().dp
    }

    fun getStepForCurrentLevel(level: String?): MutableState<Dp> {
        return when (level) {
            mediumLevel -> mutableStateOf(12.dp)
            hardLevel -> mutableStateOf(14.dp)
            else -> mutableStateOf(10.dp)
        }
    }
}

val Context.dataStore: DataStore<Preferences> by preferencesDataStore(name = "user_prefs")


class GameDataStore(val dataStore: DataStore<Preferences>) {

    companion object {
        val USER_MAX_SCORE = intPreferencesKey("USER_MAX_SCORE")
    }

    suspend fun storeScore(score: Int) {
        dataStore.edit {
            it[USER_MAX_SCORE] = score
        }
    }

    val userScoreFlow: Flow<Int?> = dataStore.data.map {
        it[USER_MAX_SCORE]
    }
}

@Composable
fun Navigation() {
    val navController = rememberNavController()

    NavHost(navController = navController, startDestination = Screen.SplashScreen.route) {

        composable(Screen.SplashScreen.route) {
            SplashScreen(navController)
        }

        composable(
            route = Screen.StartScreen.route,
            arguments = Screen.StartScreen.arguments
        ) { backStackEntry ->
            StartScreen(navController, backStackEntry.arguments?.getInt("score"))
        }

        composable(
            route = Screen.GameScreen.route,
            arguments = Screen.GameScreen.arguments
        ) { backStackEntry ->
            GameScreen(navController, backStackEntry.arguments?.getString("level"))
        }

    }
}


sealed class Screen(val route: String, val arguments: List<NamedNavArgument>) {
    object SplashScreen : Screen(route = "splash_screen", arguments = listOf())
    object StartScreen : Screen(route = "start_screen/{score}",  arguments = listOf(navArgument("score") { type = NavType.IntType })) {
        fun createRoute(score: Int) = "start_screen/$score"
    }
    object GameScreen : Screen(route = "game_screen/{level}", arguments = listOf(navArgument("level") { type = NavType.StringType })) {
        fun createRoute(level: String) = "game_screen/$level"
    }
}
"""
    }
    
    static func dependencies(_ mainData: MainData) -> ANDData {
        return ANDData(mainFragmentData: ANDMainFragment(imports: "", content: """
    Navigation()
"""), mainActivityData: ANDMainActivity(imports: "", extraFunc: "", content: ""), themesData: ANDThemesData(isDefault: true, content: ""), stringsData: ANDStringsData(additional: """
    <string name="bg_image_desc">space</string>
    <string name="button_start_easy_text">Easy</string>
    <string name="button_start_medium_text">Medium</string>
    <string name="button_start_hard_text">Hard</string>
    <string name="player_img_desc">player</string>
    <string name="enemy_img_desc">enemy</string>
    <string name="won_text">You won!</string>
    <string name="lost_text">You lost</string>
    <string name="score">%1$d/1000</string>
    <string name="max_score">Your max score:  %1$s</string>
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


    implementation Dependencies.datastore_preferences
    kapt Dependencies.room_compiler
    implementation Dependencies.room_ktx
    implementation Dependencies.room_runtime
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
    const val datastore_preferences = "androidx.datastore:datastore-preferences:1.0.0-alpha07"

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
