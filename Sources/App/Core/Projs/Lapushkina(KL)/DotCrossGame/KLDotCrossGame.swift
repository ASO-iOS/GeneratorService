//
//  File.swift
//  
//
//  Created by admin on 22.08.2023.
//

import Foundation

struct KLDotCrossGame: FileProviderProtocol {
    static var fileName: String = "KLDotCrossGame.kt"
    
    static func fileContent(packageName: String, uiSettings: UISettings) -> String {
        return """
package \(packageName).presentation.fragments.main_fragment

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.BoxWithConstraints
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.offset
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.KeyboardArrowDown
import androidx.compose.material.icons.filled.KeyboardArrowLeft
import androidx.compose.material.icons.filled.KeyboardArrowRight
import androidx.compose.material.icons.filled.KeyboardArrowUp
import androidx.compose.material3.Button
import androidx.compose.material3.ButtonDefaults
import androidx.compose.material3.Icon
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.OutlinedButton
import androidx.compose.material3.Text
import androidx.compose.material3.Typography
import androidx.compose.runtime.Composable
import androidx.compose.runtime.collectAsState
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.TextStyle
import androidx.compose.ui.text.font.FontFamily
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.Dp
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.hilt.navigation.compose.hiltViewModel
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import \(packageName).R
import \(packageName).presentation.fragments.main_fragment.Constants.MAZE_HEIGHT
import \(packageName).presentation.fragments.main_fragment.Constants.MAZE_WIDTH
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.delay
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.launch
import kotlinx.coroutines.sync.Mutex
import kotlinx.coroutines.sync.withLock
import javax.inject.Inject
import androidx.compose.foundation.BorderStroke

//generator
val backColorPrimary = Color(0xFF\(uiSettings.backColorPrimary ?? "FFFFFF"))
val surfaceColor = Color(0xFF\(uiSettings.surfaceColor ?? "FFFFFF"))
val primaryColor = Color(0xFF\(uiSettings.primaryColor ?? "FFFFFF"))
val buttonColorPrimary = Color(0xFF\(uiSettings.buttonColorPrimary ?? "FFFFFF"))
val buttonTextColorPrimary = Color(0xFF\(uiSettings.buttonTextColorPrimary ?? "FFFFFF"))
val buttonColorSecondary = Color(0xFF\(uiSettings.buttonColorSecondary ?? "FFFFFF"))
val textColorPrimary = Color(0xFF\(uiSettings.textColorPrimary ?? "FFFFFF"))

val textSizePrimary = 20.sp
val textSizeSecondary = 40.sp

//other
val columnPadding = 16.dp
val textPadding = 24.dp
val buttonHeight = 60.dp
val buttonWidth = 220.dp
val gameBoxHeight = 400.dp
val dotPadding = 2.dp
val dotSize = 24.dp
val buttonPadding = 16.dp
val fontFamily = FontFamily.Monospace

val typography = Typography(
    displayMedium = TextStyle(
        fontFamily = fontFamily, fontSize = textSizePrimary
    ),
    displayLarge = TextStyle(
        fontFamily = fontFamily, fontSize = textSizeSecondary, fontWeight = FontWeight.Medium
    )
)

@Composable
fun DotCrossTheme(
    content: @Composable () -> Unit
) {
    MaterialTheme(
        typography = typography,
        content = content
    )
}

@Composable
fun MainScreen(
) {
    val viewModel = hiltViewModel<MainViewModel>()
    val gameState = viewModel.gameState.collectAsState().value

    when(gameState) {
        is GameState.Start -> {
            StartScreen(
                R.string.play,
                onStartClick = viewModel::startGame
            )
        }
        is GameState.Process -> {
            GameScreen(gameState, viewModel::moveDot)
        }
        is GameState.End -> {
            StartScreen(
                R.string.play_again,
                onStartClick = viewModel::startGame
            )
        }
    }
}

@Composable
fun StartScreen(
    textRes: Int,
    onStartClick: () -> Unit
) {
    Column(
        modifier = Modifier
            .background(backColorPrimary)
            .fillMaxSize(),
        verticalArrangement = Arrangement.Center,
        horizontalAlignment = Alignment.CenterHorizontally
    ) {
        Text(
            text = stringResource(id = R.string.app_name),
            style = MaterialTheme.typography.displayLarge,
            modifier = Modifier.padding(textPadding),
            color = textColorPrimary
        )
        Button(
            onClick = onStartClick,
            modifier = Modifier
                .height(buttonHeight)
                .width(buttonWidth),
            colors = ButtonDefaults.buttonColors(
                containerColor = buttonColorPrimary
            )
        ) {
            Text(text = stringResource(id = textRes), style = MaterialTheme.typography.displayMedium, color = buttonTextColorPrimary)
        }
    }
}

@Composable
fun GameScreen(
    gameState: GameState.Process,
    onMoveChange: (Int, Int) -> Unit
) {
    Column(
        modifier = Modifier
            .background(backColorPrimary)
            .padding(columnPadding)
            .fillMaxSize(),
        verticalArrangement = Arrangement.spacedBy(16.dp),
        horizontalAlignment = Alignment.CenterHorizontally
    ) {
        BoxWithConstraints(
            Modifier
                .weight(1f)
                .height(gameBoxHeight)
        ) {
            val tileWidth = maxWidth / MAZE_WIDTH
            val tileHeight = maxHeight / MAZE_HEIGHT

            Maze(tileWidth, tileHeight, gameState.maze)
            DotItem(tileWidth, tileHeight, gameState.dot)
        }
        Buttons(
            onMoveChange = onMoveChange
        )
    }
}

@Composable
fun DotItem(
    tileWidth: Dp,
    tileHeight: Dp,
    dot: Dot
) {
    Box(
        modifier = Modifier
            .offset(x = tileWidth * dot.x, y = tileHeight * dot.y)
            .padding(dotPadding)
            .clip(CircleShape)
            .size(dotSize)
            .background(primaryColor)
    )
}

@Composable
fun Maze(
    tileWidth: Dp,
    tileHeight: Dp,
    maze: List<Cell>
) {
    Box(
        Modifier
            .fillMaxSize()
    ) {
        maze.forEach { cell ->
            if (cell.isWall) {
                Box(
                    Modifier
                        .offset(x = tileWidth * cell.x, y = tileHeight * cell.y)
                        .height(tileHeight + 1.dp)
                        .width(tileWidth + 1.dp)
                        .background(surfaceColor)
                )
            }
        }
    }
}

@Composable
fun Buttons(onMoveChange: (Int, Int) -> Unit) {
    Column(
        horizontalAlignment = Alignment.CenterHorizontally
    ) {
        OutlinedButton(onClick = { onMoveChange(0, -1) }, shape = RoundedCornerShape(8.dp), border = BorderStroke(width = 4.dp, color = buttonColorSecondary)) {
            Icon(Icons.Default.KeyboardArrowUp, null, tint = buttonColorSecondary)
        }
        Row(
            horizontalArrangement = Arrangement.spacedBy(buttonPadding)
        ) {
            OutlinedButton(onClick = { onMoveChange(-1, 0) }, shape = RoundedCornerShape(8.dp), border = BorderStroke(width = 4.dp, color = buttonColorSecondary)) {
                Icon(Icons.Default.KeyboardArrowLeft, null, tint = buttonColorSecondary)
            }
            OutlinedButton(onClick = { onMoveChange(1, 0) }, shape = RoundedCornerShape(8.dp), border = BorderStroke(width = 4.dp, color = buttonColorSecondary)) {
                Icon(Icons.Default.KeyboardArrowRight, null, tint = buttonColorSecondary)
            }
        }
        OutlinedButton(onClick = { onMoveChange(0, 1) }, shape = RoundedCornerShape(8.dp), border = BorderStroke(width = 4.dp, color = buttonColorSecondary)) {
            Icon(Icons.Default.KeyboardArrowDown, null, tint = buttonColorSecondary)
        }
    }
}

@HiltViewModel
class MainViewModel @Inject constructor() : ViewModel() {

    private val mutex = Mutex()

    private val _gameState = MutableStateFlow<GameState>(GameState.Start)
    val gameState = _gameState.asStateFlow()

    fun startGame() {
        viewModelScope.launch(Dispatchers.Default) {
            try {
                val maze = generateMaze()
                val startDotPosition = maze.first { !it.isWall }
                _gameState.value = GameState.Process(
                    maze = maze,
                    dot = Dot(
                        x = startDotPosition.x,
                        y = startDotPosition.y
                    )
                )
            } catch (e: Exception) {
                e.printStackTrace()
            }

        }
    }

    fun moveDot(moveX: Int, moveY: Int) {
        val gameState = _gameState.value as? GameState.Process
        gameState?.let {
            val x = gameState.dot.x + moveX
            val y = gameState.dot.y + moveY
            if (checkIfBeyondStart(x) || checkIfWall(x, y, gameState.maze)) return
            viewModelScope.launch {
                mutex.withLock {
                    _gameState.value = gameState.copy(
                        dot = Dot(
                            x = gameState.dot.x + moveX,
                            y = gameState.dot.y + moveY
                        )
                    )
                    if (checkIfEnd(x)) {
                        delay(50L)
                        _gameState.value = GameState.End
                    }
                }
            }
        }
    }

    private fun checkIfBeyondStart(x: Int): Boolean {
        return x < 0
    }

    private fun checkIfEnd(x: Int): Boolean {
        return x >= MAZE_WIDTH - 1
    }

    private fun checkIfWall(x: Int, y: Int, maze: List<Cell>): Boolean {
        return maze.first { it.x == x && it.y == y }.isWall
    }

    private fun generateMaze(): List<Cell> {
        val maze = mutableListOf<Cell>()

        for (i in 0 until MAZE_WIDTH) {
            for (j in 0 until MAZE_HEIGHT) {
                maze.add(Cell(x = i, y = j))
            }
        }

        val start = Pair(0, (1 until MAZE_HEIGHT).random())
        var current = maze.first { it.x == start.first && it.y == start.second }.apply {
            isWall = false
        }

        while (current.x < MAZE_WIDTH - 1) {
            val neighbours = getNeighbours(current, maze)

            val list = neighbours.filter {
                it.isWall && (it.x >= current.x) && (it.y < MAZE_HEIGHT) && (allWallNeighbours(
                    getNeighbours(it, maze)
                ) || it.x == MAZE_WIDTH - 1)
            }
            current = list.random().apply {
                isWall = false
            }
        }

        return maze
    }

    private fun allWallNeighbours(list: List<Cell>): Boolean {
        return list.count { it.isWall } == 3
    }

    private fun getNeighbours(current: Cell, maze: List<Cell>): List<Cell> {
        return listOfNotNull(
            maze.firstOrNull { (it.x == current.x - 1) && (it.y == current.y) },
            maze.firstOrNull { (it.x == current.x + 1) && (it.y == current.y) },
            maze.firstOrNull { (it.x == current.x) && (it.y == current.y - 1) },
            maze.firstOrNull { (it.x == current.x) && (it.y == current.y + 1) }
        )
    }
}

sealed class GameState {
    object Start: GameState()
    data class Process(var maze: List<Cell>, var dot: Dot) : GameState()
    object End: GameState()
}

data class Cell(
    var x: Int = 0,
    var y: Int = 0,
    var isWall: Boolean = true
)

object Constants {
    const val MAZE_HEIGHT = 20
    const val MAZE_WIDTH = 10
}

data class Dot(
    var x: Int = 0,
    var y: Int = 0
)

"""
    }
    
    static func dependencies(_ mainData: MainData) -> ANDData {
        return ANDData(mainFragmentData: ANDMainFragment(imports: "", content: """
                DotCrossTheme {
                    MainScreen()
                }
"""), mainActivityData: ANDMainActivity(imports: "", extraFunc: "", content: ""), themesData: ANDThemesData(isDefault: true, content: ""), stringsData: ANDStringsData(additional: """
    <string name="play">Play</string>
    <string name="play_again">Play Again</string>
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
