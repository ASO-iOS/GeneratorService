//
//  File.swift
//  
//
//  Created by admin on 05.10.2023.
//

import Foundation

struct KLDodger: FileProviderProtocol {
    static var fileName: String = "\(NamesManager.shared.fileName).kt"
    
    static func fileContent(packageName: String, uiSettings: UISettings) -> String {
        return """
package \(packageName).presentation.fragments.main_fragment

import android.content.Context
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.graphics.Rect
import androidx.compose.foundation.Canvas
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxHeight
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.width
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.KeyboardArrowLeft
import androidx.compose.material.icons.filled.KeyboardArrowRight
import androidx.compose.material3.Button
import androidx.compose.material3.ButtonDefaults
import androidx.compose.material3.Icon
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.material3.Typography
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.paint
import androidx.compose.ui.geometry.Offset
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.RectangleShape
import androidx.compose.ui.graphics.asImageBitmap
import androidx.compose.ui.graphics.drawscope.DrawScope
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.TextStyle
import androidx.compose.ui.text.font.FontFamily
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.hilt.navigation.compose.hiltViewModel
import androidx.lifecycle.SavedStateHandle
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
import dagger.hilt.android.qualifiers.ApplicationContext
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.delay
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import javax.inject.Inject

//generator
val backColorPrimary = Color(0xFF\(uiSettings.backColorPrimary ?? "FFFFFF"))
val textColorPrimary = Color(0xFF\(uiSettings.textColorPrimary ?? "FFFFFF"))
val textColorSecondary = Color(0xFF\(uiSettings.textColorSecondary ?? "FFFFFF"))
val buttonColorPrimary = Color(0xFF\(uiSettings.buttonColorPrimary ?? "FFFFFF"))
val buttonTextColorPrimary = Color(0xFF\(uiSettings.buttonTextColorPrimary ?? "FFFFFF"))
val buttonColorSecondary = Color(0xFF\(uiSettings.buttonColorSecondary ?? "FFFFFF"))

//other
val layoutPadding = 24.dp
val buttonSpacer = 16.dp

val buttonWidth = 180.dp
val buttonHeight = 50.dp

val fontFamily = FontFamily.SansSerif
val smallFontSize = 20.sp
val mediumFontSize = 24.sp
val largeFontSize = 32.sp

val typography = Typography(
    displaySmall = TextStyle(
        fontFamily = fontFamily, fontSize = smallFontSize, color = textColorPrimary
    ),
    displayMedium = TextStyle(
        fontFamily = fontFamily, fontSize = mediumFontSize, color = textColorPrimary
    ),
    displayLarge = TextStyle(
        fontFamily = fontFamily,
        fontSize = largeFontSize,
        color = textColorPrimary,
        fontWeight = FontWeight.Bold
    )
)

@Composable
fun DodgerTheme(
    content: @Composable () -> Unit
) {
    MaterialTheme(
        typography = typography,
        content = content
    )
}

@Composable
fun GameScreen(navController: NavController) {
    val viewModel = hiltViewModel<GameViewModel>()
    GameScreenContent(
        state = viewModel.state,
        onEvent = viewModel::onEvent,
        onGameFinished = {
            navController.navigate(
                Screen.RestartScreen.createArg(viewModel.state.mode, viewModel.state.score)
            ) {
                popUpTo(Screen.MenuScreen.route)
            }
        }

    )
}

@Composable
fun GameScreenContent(
    state: GameState,
    onEvent: (GameEvent) -> Unit,
    onGameFinished: () -> Unit
) {
    LaunchedEffect(key1 = state.gameRunning) {
        if (!state.gameRunning) {
            onGameFinished()
        }
    }

    Column(
        modifier = Modifier
            .fillMaxSize()
            .paint(
                painter = painterResource(id = R.drawable.bg),
                contentScale = ContentScale.Crop
            )
    ) {
        Canvas(
            modifier = Modifier
                .weight(1f)
                .fillMaxSize()
        ) {
            player(state.player)
            acorns(state.acorns)
        }
        Row(
            modifier = Modifier
                .fillMaxWidth()
                .height(100.dp),
            horizontalArrangement = Arrangement.SpaceBetween,
            verticalAlignment = Alignment.CenterVertically
        ) {
            Button(
                onClick = { onEvent(GameEvent.Move(MovementDirection.LEFT)) },
                modifier = Modifier
                    .fillMaxHeight()
                    .width(100.dp),
                colors = ButtonDefaults.buttonColors(
                    containerColor = Color.Transparent
                ),
                shape = RectangleShape
            ) {
                Icon(
                    imageVector = Icons.Default.KeyboardArrowLeft,
                    contentDescription = null,
                    tint = textColorSecondary,
                    modifier = Modifier.fillMaxSize()
                )
            }
            Text(text = state.score.toString(), style = MaterialTheme.typography.displayMedium)
            Button(
                onClick = { onEvent(GameEvent.Move(MovementDirection.RIGHT)) },
                modifier = Modifier
                    .fillMaxHeight()
                    .width(100.dp),
                colors = ButtonDefaults.buttonColors(
                    containerColor = Color.Transparent
                ),
                shape = RectangleShape
            ) {
                Icon(
                    imageVector = Icons.Default.KeyboardArrowRight,
                    contentDescription = null,
                    tint = textColorSecondary,
                    modifier = Modifier.fillMaxSize()
                )
            }
        }
    }

}

fun DrawScope.player(
    player: Player
) {
    drawImage(
        image = Bitmap.createScaledBitmap(
            player.bitmap,
            (this.size.width * player.rect.width() * 0.01f).toInt(),
            (this.size.height * player.rect.height() * 0.01f).toInt(),
            false
        ).asImageBitmap(),
        topLeft = Offset(
            this.size.width * player.rect.left * 0.01f,
            this.size.height * 0.01f * player.rect.top
        )
    )
}

fun DrawScope.acorns(
    acorns: List<Acorn>
) {
    acorns.forEach { acorn ->
        drawImage(
            image = Bitmap.createScaledBitmap(
                acorn.bitmap,
                (this.size.width * acorn.rect.width() * 0.01f).toInt(),
                (this.size.height * acorn.rect.height() * 0.01f).toInt(),
                false
            ).asImageBitmap(),
            topLeft = Offset(
                this.size.width * acorn.rect.left * 0.01f,
                this.size.height * acorn.rect.top * 0.01f
            )
        )
    }
}

sealed class GameEvent {
    data class Move(val direction: MovementDirection) : GameEvent()
}

data class GameState(
    val score: Int = 0,
    val mode: Mode = Mode.EASY,
    val acorns: List<Acorn> = emptyList(),
    val player: Player,
    val gameRunning: Boolean = true
)

@HiltViewModel
class GameViewModel @Inject constructor(
    savedStateHandle: SavedStateHandle,
    private val game: Game
) : ViewModel() {

    var state by mutableStateOf(GameState(player = game.player))
        private set

    init {
        viewModelScope.launch(Dispatchers.Default) {
            val mode = savedStateHandle.get<String>(Screen.mode)
            mode?.let {
                withContext(Dispatchers.Main) {
                    state = state.copy(
                        mode = Mode.valueOf(mode)
                    )
                }
                game.start(Mode.valueOf(it))
                start()
            }
        }
    }

    fun onEvent(event: GameEvent) {
        when (event) {
            is GameEvent.Move -> {
                viewModelScope.launch(Dispatchers.Default) {
                    game.movePlayer(event.direction)
                }
            }
        }
    }

    private fun start() {
        viewModelScope.launch(Dispatchers.Default) {
            while (true) {
                delay(30L)

                game.updateFallingItems()
                game.detectPlayerCollision()

                withContext(Dispatchers.Main) {
                    state = state.copy(
                        player = game.player,
                        acorns = game.acorns,
                        score = game.score,
                        gameRunning = game.isGameRunning
                    )
                }
            }
        }
    }
}

@Composable
fun MenuScreen(navController: NavController) {
    MenuScreenContent(
        onEasyMode = { navController.navigate(Screen.GameScreen.createArg(Mode.EASY)) },
        onNormalMode = { navController.navigate(Screen.GameScreen.createArg(Mode.NORMAL)) },
        onHardMode = { navController.navigate(Screen.GameScreen.createArg(Mode.HARD)) }
    )
}

@Composable
fun MenuScreenContent(
    onEasyMode: () -> Unit,
    onNormalMode: () -> Unit,
    onHardMode: () -> Unit
) {
    Column(
        modifier = Modifier
            .fillMaxSize()
            .paint(
                painter = painterResource(id = R.drawable.bg),
                contentScale = ContentScale.Crop
            )
            .padding(layoutPadding),
        verticalArrangement = Arrangement.SpaceEvenly,
        horizontalAlignment = Alignment.CenterHorizontally
    ) {
        Text(
            text = stringResource(id = R.string.app_name),
            style = MaterialTheme.typography.displayLarge,
            color = textColorPrimary
        )
        Column(
            verticalArrangement = Arrangement.spacedBy(buttonSpacer)
        ) {
            GameButton(textRes = R.string.easy, onClick = onEasyMode)
            GameButton(textRes = R.string.normal, onClick = onNormalMode)
            GameButton(textRes = R.string.hard, onClick = onHardMode)
        }
    }
}

@Composable
fun RestartScreen(navController: NavController) {
    val viewModel = hiltViewModel<RestartViewModel>()
    RestartScreenContent(
        state = viewModel.state,
        onRestart = {
            navController.navigate(Screen.GameScreen.createArg(viewModel.state.mode)) {
                popUpTo(Screen.MenuScreen.route)
            }
        },
        onGoToMenu = {
            navController.navigate(Screen.MenuScreen.route) {
                popUpTo(Screen.MenuScreen.route)
            }
        }
    )
}

@Composable
fun RestartScreenContent(
    state: RestartState,
    onRestart: () -> Unit,
    onGoToMenu: () -> Unit
) {
    Column(
        modifier = Modifier
            .fillMaxSize()
            .paint(
                painter = painterResource(id = R.drawable.bg),
                contentScale = ContentScale.Crop
            )
            .padding(layoutPadding),
        verticalArrangement = Arrangement.SpaceEvenly,
        horizontalAlignment = Alignment.CenterHorizontally
    ) {
        Text(
            text = stringResource(R.string.score, state.score),
            style = MaterialTheme.typography.displayMedium
        )
        Column(
            verticalArrangement = Arrangement.spacedBy(buttonSpacer)
        ) {
            GameButton(textRes = R.string.restart, onClick = onRestart)
            GameButton(textRes = R.string.menu, onClick = onGoToMenu)
        }
    }
}

data class RestartState(
    val mode: Mode = Mode.EASY,
    val score: Int = 0
)

@HiltViewModel
class RestartViewModel @Inject constructor(
    savedStateHandle: SavedStateHandle
) : ViewModel() {
    var state by mutableStateOf(RestartState())
        private set

    init {
        val score = savedStateHandle.get<Int>(Screen.score)
        val mode = savedStateHandle.get<String>(Screen.mode)

        if (score != null && mode != null) {
            state = state.copy(
                mode = Mode.valueOf(mode),
                score = score
            )
        }
    }
}

@Composable
fun GameButton(
    textRes: Int,
    onClick: () -> Unit
) {
    Button(
        modifier = Modifier
            .width(buttonWidth)
            .height(buttonHeight),
        onClick = onClick,
        colors = ButtonDefaults.buttonColors(
            containerColor = buttonColorPrimary,
            contentColor = buttonTextColorPrimary
        )
    ) {
        Text(text = stringResource(textRes))
    }
}

sealed class Screen(val route: String, val listArgs: List<NamedNavArgument>) {
    object MenuScreen : Screen(route = routeMenu, listArgs = emptyList())

    object GameScreen : Screen(
        route = "$routeGame/{$mode}",
        listArgs = listOf(
            navArgument(mode) {
                type = NavType.StringType
            }
        )
    ) {
        fun createArg(mode: Mode) = "$routeGame/${mode.name}"
    }

    object RestartScreen : Screen(
        route = "$routeRestart/{$mode}/{$score}",
        listArgs = listOf(
            navArgument(mode) {
                type = NavType.StringType
            },
            navArgument(score) {
                type = NavType.IntType
            }
        )
    ) {
        fun createArg(mode: Mode, score: Int) = "$routeRestart/${mode.name}/$score"
    }

    companion object {
        const val routeMenu = "menu_screen"
        const val routeGame = "game_screen"
        const val routeRestart = "restart_screen"
        const val mode: String = "mode"
        const val score: String = "score"
    }
}

@Composable
fun Navigation() {
    val navController = rememberNavController()

    NavHost(navController = navController, startDestination = Screen.MenuScreen.route) {
        composable(route = Screen.MenuScreen.route) {
            MenuScreen(navController)
        }
        composable(
            route = Screen.GameScreen.route,
            arguments = Screen.GameScreen.listArgs
        ) {
            GameScreen(navController)
        }
        composable(
            route = Screen.RestartScreen.route,
            arguments = Screen.RestartScreen.listArgs
        ) {
            RestartScreen(navController)
        }
    }
}

data class Acorn(
    val bitmap: Bitmap,
    val rect: Rect = Rect()
)

class Game @Inject constructor(@ApplicationContext val context: Context) {

    private val acornBitmap = BitmapFactory.decodeResource(context.resources, R.drawable.acorn)

    var player: Player = Player(
        bitmap = BitmapFactory.decodeResource(context.resources, R.drawable.player)
    )

    var acorns: MutableList<Acorn> = mutableListOf()
    var newAcornCountDown = 40

    var score = 0
    var isGameRunning = true

    var mode: Mode = Mode.EASY

    init {
        generatePlayer()
    }

    fun start(mode: Mode) {
        this.mode = mode
        generateAcorn()
    }

    fun updateFallingItems() {
        generateAcorn()
        moveFallingItems()
        removeOutOfBoundaryItem()
    }

    private fun generateAcorn() {
        val x = (0..SCREEN_SIZE - ACORN_WIDTH).random()

        if (acorns.count() < mode.acornLimit && newAcornCountDown == 0) {
            acorns = acorns.apply {
                add(
                    Acorn(
                        bitmap = acornBitmap,
                        rect = Rect().apply {
                            set(
                                x,
                                ACORN_INITIAL_Y,
                                x + ACORN_WIDTH,
                                ACORN_INITIAL_Y + ACORN_HEIGHT
                            )
                        }
                    )
                )
            }
        }

        if (newAcornCountDown == 0) {
            newAcornCountDown = (mode.spawnCountDown.first..mode.spawnCountDown.second).random()
        }
        newAcornCountDown--
    }

    private fun generatePlayer() {
        player = player.copy(
            rect = Rect().apply {
                set(
                    PLAYER_INITIAL_X,
                    PLAYER_INITIAL_Y,
                    PLAYER_INITIAL_X + PLAYER_WIDTH,
                    PLAYER_INITIAL_Y + PLAYER_HEIGHT
                )
            }
        )
    }

    private fun moveFallingItems() {
        acorns = acorns.toMutableList().apply {
            replaceAll {
                it.copy(
                    rect = Rect().apply {
                        set(
                            it.rect.left,
                            it.rect.top + ACORN_MOVE,
                            it.rect.right,
                            it.rect.top + ACORN_MOVE + ACORN_HEIGHT
                        )
                    }
                )
            }
        }
    }

    fun movePlayer(direction: MovementDirection) {
        val x = player.rect.left
        val y = player.rect.top

        when (direction) {
            MovementDirection.LEFT -> {
                if (x > 0) {
                    player = player.copy(
                        rect = Rect().apply {
                            set(
                                x - PLAYER_MOVE,
                                y,
                                x - PLAYER_MOVE + PLAYER_WIDTH,
                                y + PLAYER_HEIGHT
                            )
                        }
                    )
                }
            }

            MovementDirection.RIGHT -> {
                if (player.rect.right < 100) {
                    player = player.copy(
                        rect = Rect().apply {
                            set(
                                x + PLAYER_MOVE,
                                y,
                                x + PLAYER_MOVE + PLAYER_WIDTH,
                                y + PLAYER_HEIGHT
                            )
                        }
                    )
                }
            }
        }
    }

    fun detectPlayerCollision() {
        acorns.onEach {
            if (it.rect.intersect(player.rect)) {
                isGameRunning = false
                return
            }
        }
    }

    private fun removeOutOfBoundaryItem() {
        acorns = acorns.apply {
            removeIf { it.rect.bottom >= 100 }.also { if (it) score++ }
        }
    }

    companion object {
        const val ACORN_HEIGHT = 10
        const val ACORN_WIDTH = 16
        const val PLAYER_HEIGHT = 10
        const val PLAYER_WIDTH = 20

        const val PLAYER_MOVE = 10
        const val ACORN_MOVE = 1

        const val PLAYER_INITIAL_X = 50
        const val PLAYER_INITIAL_Y = 88

        const val ACORN_INITIAL_Y = 0

        const val SCREEN_SIZE = 100
    }
}

enum class Mode(val acornLimit: Int, val spawnCountDown: Pair<Int, Int>) {
    EASY(acornLimit = 5, spawnCountDown = Pair(30, 50)),
    NORMAL(acornLimit = 6, spawnCountDown = Pair(20, 30)),
    HARD(acornLimit = 7, spawnCountDown = Pair(10, 25))
}

enum class MovementDirection {
    LEFT,
    RIGHT
}

data class Player(
    val bitmap: Bitmap,
    val rect: Rect = Rect()
)
"""
    }
    
    static func dependencies(_ mainData: MainData) -> ANDData {
        return ANDData(mainFragmentData: ANDMainFragment(imports: "", content: """
                        DodgerTheme {
                            Navigation()
                        }
        """), mainActivityData: ANDMainActivity(imports: "", extraFunc: "", content: ""), themesData: ANDThemesData(isDefault: true, content: ""), stringsData: ANDStringsData(additional: """
            <string name="easy">Easy</string>
            <string name="normal">Normal</string>
            <string name="hard">Hard</string>
            <string name="restart">Restart</string>
            <string name="menu">Menu</string>
            <string name="score">Score: %d</string>
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
