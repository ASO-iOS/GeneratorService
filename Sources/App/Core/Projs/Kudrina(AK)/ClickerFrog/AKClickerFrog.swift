//
//  File.swift
//  
//
//  Created by admin on 20.09.2023.
//

import SwiftUI

struct AKClickerFrog: FileProviderProtocol {
    static var fileName: String = "\(NamesManager.shared.fileName).kt"
    
    static func fileContent(packageName: String, uiSettings: UISettings) -> String {
        return """
package \(packageName).presentation.fragments.main_fragment

import android.content.Context
import android.widget.Toast
import androidx.compose.animation.core.Animatable
import androidx.compose.animation.core.tween
import androidx.compose.foundation.Image
import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.interaction.MutableInteractionSource
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.Button
import androidx.compose.material3.ButtonDefaults
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.MutableState
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.rememberCoroutineScope
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.scale
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.style.TextAlign
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
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import androidx.navigation.compose.rememberNavController
import \(packageName).R
import dagger.hilt.android.lifecycle.HiltViewModel
import dagger.hilt.android.qualifiers.ApplicationContext
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.delay
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.flow.map
import kotlinx.coroutines.flow.onEach
import kotlinx.coroutines.launch
import javax.inject.Inject
import javax.inject.Singleton

val textColorSecondary = Color(0xFF\(uiSettings.textColorSecondary ?? "FFFFFF"))
val buttonColorPrimary = Color(0xFF\(uiSettings.buttonColorPrimary ?? "FFFFFF"))
val textColorPrimary = Color(0xFF\(uiSettings.textColorPrimary ?? "FFFFFF"))
val backColorPrimary = Color(0xFF\(uiSettings.backColorPrimary ?? "FFFFFF"))

val Context.dataStore: DataStore<Preferences> by preferencesDataStore(name = "user_prefs")


val timer = (29 downTo 0)
    .asSequence()
    .asFlow()
    .onEach {
        delay(1_000)
    }


val timerForCountDown = (2 downTo 0)
    .asSequence()
    .asFlow()
    .onEach {
        delay(1_000)
    }

fun showWarningToast(context: Context, stringRes: Int) {
    Toast.makeText(
        context,
        context.getText(stringRes),
        Toast.LENGTH_SHORT
    ).show()
}

@Composable
fun Navigation(gameViewModel: GameViewModel = hiltViewModel()) {
    val navController = rememberNavController()
    val navigateToGameScreen: () -> Unit = {
        navController.navigate(Screen.GameScreen.route)
    }

    val navigateToStartScreen: () -> Unit = {
        navController.navigate(Screen.StartScreen.route) {
            popUpTo(0)
        }
    }

    NavHost(navController = navController, startDestination = Screen.StartScreen.route) {

        composable(Screen.StartScreen.route) {
            StartScreen(
                navigateToGameScreen = navigateToGameScreen,
                gameViewModel = gameViewModel
            )
        }

        composable(Screen.GameScreen.route) {
            ClickerScreen(
                gameViewModel = gameViewModel,
                navigateToStartScreen = navigateToStartScreen
            )
        }

    }
}


sealed class Screen(val route: String) {
    object StartScreen : Screen(route = "start_screen")
    object GameScreen : Screen(route = "qame_screen")
}


@Singleton
class GameRepository @Inject constructor(@ApplicationContext private val context: Context) {

    suspend fun storeScore(score: Int) {
        context.dataStore.edit {
            it[USER_MAX_SCORE] = score
        }
    }

    val userScoreFlow: Flow<Int?> = context.dataStore.data.map {
        it[USER_MAX_SCORE]
    }

    suspend fun storeCurrentMaxLevel(level: Int) {
        context.dataStore.edit {
            it[CURRENT_MAX_LEVEL] = level
        }
    }

    val currentMaxLevel: Flow<Int?> = context.dataStore.data.map {
        it[CURRENT_MAX_LEVEL]
    }

    companion object {
        val USER_MAX_SCORE = intPreferencesKey("USER_MAX_SCORE")
        val CURRENT_MAX_LEVEL = intPreferencesKey("CURRENT_MAX_LEVEL")
    }

}

@HiltViewModel
class GameViewModel @Inject constructor(private val gameRepository: GameRepository) : ViewModel() {

    private val _screenState = MutableStateFlow<ScreenState>(NotChosen)
    val screenState = _screenState.asStateFlow()
    fun setScreenState(newScreenState: ScreenState) {
        _screenState.value = newScreenState
    }


    // DataStore

    // Score
    fun saveScoreToDataStore(score: Int) {
        viewModelScope.launch(Dispatchers.IO) {
            gameRepository.storeScore(score)
        }
    }

    private val _dataStoreScore = MutableStateFlow(0)
    val dataStoreScore = _dataStoreScore.asStateFlow()

    fun getScoreFromDataStore() {
        viewModelScope.launch {
            gameRepository.userScoreFlow.collect {
                _dataStoreScore.value = it ?: 0

            }
        }
    }


    // Level
    fun openNextLevel(screenState: ScreenState) {
        when (screenState) {
            Level1 -> storeCurrentMaxLevel(2)
            Level2 -> storeCurrentMaxLevel(3)
            Level3 -> storeCurrentMaxLevel(4)
            Level4 -> storeCurrentMaxLevel(5)
            Level5 -> storeCurrentMaxLevel(5)
            else -> storeCurrentMaxLevel(1)
        }
    }

    private fun storeCurrentMaxLevel(level: Int) {
        viewModelScope.launch {
            gameRepository.storeCurrentMaxLevel(level = level)
        }
    }

    private val _currentMaxLevel = MutableStateFlow(1)
    val currentMaxLevel = _currentMaxLevel.asStateFlow()

    fun getCurrentMaxLevel() {
        viewModelScope.launch {
            gameRepository.currentMaxLevel.collect { level ->
                _currentMaxLevel.value = level ?: 1
            }
        }
    }

    fun levelIsOpen(
        screenState: ScreenState,
        currentMaxLevel: Int = this.currentMaxLevel.value
    ): Boolean {
        getCurrentMaxLevel()
        return when (screenState) {
            Level1 -> currentMaxLevel >= 1
            Level2 -> currentMaxLevel >= 2
            Level3 -> currentMaxLevel >= 3
            Level4 -> currentMaxLevel >= 4
            Level5 -> currentMaxLevel == 5
            else -> false
        }
    }
}

sealed class ScreenState

object NotChosen : ScreenState()

object Level1 : ScreenState()

object Level2 : ScreenState()

object Level3 : ScreenState()

object Level4 : ScreenState()

object Level5 : ScreenState()

fun getScreenStateValue(screenState: ScreenState): Int {
    return when (screenState) {
        Level1 -> R.string.level1_text
        Level2 -> R.string.level2_text
        Level3 -> R.string.level3_text
        Level4 -> R.string.level4_text
        Level5 -> R.string.level5_text
        else -> R.string.level_not_chosen
    }
}

fun getScreenStateValueInt(screenState: ScreenState): Int {
    return when (screenState) {
        Level1 -> 1
        Level2 -> 2
        Level3 -> 3
        Level4 -> 4
        Level5 -> 5
        else -> 1
    }
}

fun getScreenStateMinScore(screenState: ScreenState): Int {
    return when (screenState) {
        Level1 -> 60
        Level2 -> 90
        Level3 -> 120
        Level4 -> 150
        Level5 -> 200
        else -> 0
    }
}

fun getNextScreenState(screenState: ScreenState): ScreenState {
    return when (screenState) {
        Level1 -> Level2
        Level2 -> Level3
        Level3 -> Level4
        Level4 -> Level5
        else -> Level1
    }
}


@Composable
fun StartScreen(navigateToGameScreen: () -> Unit, gameViewModel: GameViewModel) {


    Column(
        modifier = Modifier
            .fillMaxSize().background(backColorPrimary),
        horizontalAlignment = Alignment.CenterHorizontally,
        verticalArrangement = Arrangement.spacedBy(16.dp, Alignment.CenterVertically)
    ) {

        ClickerText(gameViewModel = gameViewModel)


        LevelButton(
            screenState = Level1,
            navigateToGameScreen = navigateToGameScreen,
            gameViewModel = gameViewModel
        )

        LevelButton(
            screenState = Level2,
            navigateToGameScreen = navigateToGameScreen,
            gameViewModel = gameViewModel
        )

        LevelButton(
            screenState = Level3,
            navigateToGameScreen = navigateToGameScreen,
            gameViewModel = gameViewModel
        )

        LevelButton(
            screenState = Level4,
            navigateToGameScreen = navigateToGameScreen,
            gameViewModel = gameViewModel
        )

        LevelButton(
            screenState = Level5,
            navigateToGameScreen = navigateToGameScreen,
            gameViewModel = gameViewModel
        )
    }
}

@Composable
fun LevelButton(
    screenState: ScreenState,
    navigateToGameScreen: () -> Unit,
    gameViewModel: GameViewModel
) {

    val context = LocalContext.current
    val currentButtonColor = remember {
        mutableStateOf(buttonColorPrimary)
    }

    LaunchedEffect(key1 = Unit) {
        gameViewModel.getCurrentMaxLevel()
    }

    val currentMaxLevel = gameViewModel.currentMaxLevel.collectAsState().value

    val levelIsOpen = gameViewModel.levelIsOpen(screenState, currentMaxLevel)

    if (levelIsOpen) currentButtonColor.value = buttonColorPrimary
    else currentButtonColor.value = textColorPrimary

    Button(
        onClick = {
            if (levelIsOpen) {
                gameViewModel.setScreenState(screenState)
                navigateToGameScreen()
            } else {
                showWarningToast(context = context, stringRes = R.string.toast_text_finish_previous)
            }
        },
        colors = ButtonDefaults.buttonColors(containerColor = currentButtonColor.value),
        elevation = ButtonDefaults.buttonElevation(
            defaultElevation = 10.dp,
            pressedElevation = 20.dp
        )
    ) {
        Text(
            text = stringResource(id = getScreenStateValue(screenState)),
            color = textColorSecondary,
            fontSize = 18.sp
        )
    }
}

@Composable
fun ClickerText(gameViewModel: GameViewModel) {

    LaunchedEffect(key1 = Unit) {
        gameViewModel.getScoreFromDataStore()
    }
    val currentScore = gameViewModel.dataStoreScore.collectAsState().value

    Text(
        text = stringResource(id = R.string.max_score_text, currentScore),
        color = buttonColorPrimary,
        fontSize = 22.sp,
        textAlign = TextAlign.Center
    )
}

@Composable
fun ClickerScreen(
    viewModel: ClickerScreenViewModel = hiltViewModel(),
    gameViewModel: GameViewModel,
    navigateToStartScreen: () -> Unit
) {

    val countDownFinished = viewModel.countDownFinished.collectAsState().value
    val gameFinished = viewModel.gameFinished.collectAsState().value

    val timesClicked = remember {
        mutableStateOf(0)
    }

    Column(
        modifier = Modifier
            .fillMaxSize().background(backColorPrimary),
        horizontalAlignment = Alignment.CenterHorizontally,
        verticalArrangement = Arrangement.spacedBy(22.dp, Alignment.CenterVertically)
    ) {
        if (!countDownFinished) {
            CountDownText(gameViewModel = gameViewModel)
            timesClicked.value = 0
        } else {
            TimerText()

            ClickedTimesText(timesClicked = timesClicked)

            ClickableImage(timesClicked = timesClicked, gameViewModel = gameViewModel)

            if (gameFinished) BottomButtons(
                gameViewModel = gameViewModel,
                navigateToStartScreen = navigateToStartScreen
            )
        }
    }
}

@HiltViewModel
class ClickerScreenViewModel @Inject constructor() : ViewModel() {

    private val _timerDone = MutableStateFlow(false)
    val timerDone: StateFlow<Boolean> get() = _timerDone
    fun setTimerDone(timerDoneInput: Boolean) {
        _timerDone.value = timerDoneInput
    }

    private val _gameFinished = MutableStateFlow(false)
    val gameFinished: StateFlow<Boolean> get() = _gameFinished
    fun setGameFinished(gameFinishedInput: Boolean) {
        _gameFinished.value = gameFinishedInput
    }

    private val _countDownFinished = MutableStateFlow(false)
    val countDownFinished: StateFlow<Boolean> get() = _countDownFinished
    fun setCountDownFinished(newCountDownFinished: Boolean) {
        _countDownFinished.value = newCountDownFinished
    }

    private val _currentImageRes = MutableStateFlow(R.drawable.is_waiting)
    val currentImageRes: StateFlow<Int> get() = _currentImageRes
    fun setCurrentImageRes(newCurrentImageRes: Int) {
        _currentImageRes.value = newCurrentImageRes
    }

    fun restartGame() {
        _countDownFinished.value = false
        _timerDone.value = false
        _currentImageRes.value = R.drawable.is_waiting
        _gameFinished.value = false
    }
}

@Composable
fun TimerText(viewModel: ClickerScreenViewModel = hiltViewModel()) {

    val time = timer.collectAsState(initial = 30).value
    if (time == 0) {
        viewModel.setTimerDone(true)
    }

    Text(
        text = stringResource(id = R.string.timer, time),
        color = textColorPrimary,
        fontSize = 36.sp
    )
}

@Composable
fun CountDownText(
    viewModel: ClickerScreenViewModel = hiltViewModel(),
    gameViewModel: GameViewModel
) {
    val screenState = gameViewModel.screenState.collectAsState().value
    val time = timerForCountDown.collectAsState(initial = 3).value
    val minScore = remember {
        mutableStateOf(getScreenStateMinScore(screenState))
    }


    if (time == 0) viewModel.setCountDownFinished(true)

    Text(
        text = stringResource(
            id = R.string.timer_countdown,
            time.toString(),
            minScore.value.toString()
        ),
        color = buttonColorPrimary,
        fontSize = 42.sp,
        textAlign = TextAlign.Center
    )
}

@Composable
fun ClickedTimesText(timesClicked: MutableState<Int>) {
    Text(
        text = timesClicked.value.toString(),
        color = buttonColorPrimary,
        fontSize = 30.sp
    )
}

@Composable
fun ClickableImage(
    viewModel: ClickerScreenViewModel = hiltViewModel(),
    timesClicked: MutableState<Int>,
    gameViewModel: GameViewModel
) {

    val timerDone = viewModel.timerDone.collectAsState().value
    val currentImageRes = viewModel.currentImageRes.collectAsState().value

    val screenState = gameViewModel.screenState.collectAsState().value
    val minScore = remember { mutableStateOf(getScreenStateMinScore(screenState)) }

    // For image clicked effects
    val interactionSource = remember { MutableInteractionSource() }
    val coroutineScope = rememberCoroutineScope()
    val scale = remember { Animatable(1f) }

    // Score from datastore
    LaunchedEffect(key1 = Unit) {
        gameViewModel.getScoreFromDataStore()
        gameViewModel.getCurrentMaxLevel()
    }
    val currentScore = gameViewModel.dataStoreScore.collectAsState().value
    val currentMaxLevel = gameViewModel.currentMaxLevel.collectAsState().value

    if (timerDone) {
        when {
            timesClicked.value >= minScore.value -> {
                viewModel.setCurrentImageRes(R.drawable.won)
                if (currentMaxLevel < getScreenStateValueInt(getNextScreenState(screenState))) gameViewModel.openNextLevel(
                    screenState
                )
            }

            else -> viewModel.setCurrentImageRes(R.drawable.lost)
        }
        if (timesClicked.value > currentScore) gameViewModel.saveScoreToDataStore(timesClicked.value)
        viewModel.setGameFinished(true)
    }

    Image(
        modifier = Modifier
            .size(150.dp)
            .scale(scale = scale.value)
            .clickable(
                interactionSource = interactionSource,
                indication = null
            ) {
                if (!timerDone) {
                    timesClicked.value++

                    // Animation + image change
                    coroutineScope.launch {
                        viewModel.setCurrentImageRes(R.drawable.clicked)
                        scale.animateTo(
                            1.2f,
                            animationSpec = tween(100),
                        )
                        scale.animateTo(
                            1f,
                            animationSpec = tween(100),
                        )
                        viewModel.setCurrentImageRes(R.drawable.is_waiting)
                    }
                }
            },
        painter = painterResource(id = currentImageRes),
        contentDescription = stringResource(id = R.string.image_desc)
    )
}

@Composable
fun BottomButtons(
    gameViewModel: GameViewModel,
    viewModel: ClickerScreenViewModel = hiltViewModel(),
    navigateToStartScreen: () -> Unit
) {

    val context = LocalContext.current

    // Next Level
    val screenState = gameViewModel.screenState.collectAsState().value
    val nextScreen = remember {
        mutableStateOf(getNextScreenState(screenState))
    }

    LaunchedEffect(key1 = Unit) {
        gameViewModel.getCurrentMaxLevel()
    }
    val currentMaxLevel = gameViewModel.currentMaxLevel.collectAsState().value
    val nextLevelIsOpen =
        gameViewModel.levelIsOpen(getNextScreenState(screenState), currentMaxLevel)

    Row(
        modifier = Modifier
            .fillMaxWidth(),
        verticalAlignment = Alignment.Bottom,
        horizontalArrangement = Arrangement.SpaceEvenly
    ) {

        Button(
            onClick = {
                navigateToStartScreen()
                gameViewModel.setScreenState(NotChosen)
            },
            colors = ButtonDefaults.buttonColors(containerColor = buttonColorPrimary),
            elevation = ButtonDefaults.buttonElevation(
                defaultElevation = 10.dp,
                pressedElevation = 20.dp
            )
        ) {
            Text(
                text = stringResource(id = R.string.go_to_menu_button_text),
                color = textColorSecondary,
                fontSize = 18.sp
            )
        }

        IconButton(
            modifier = Modifier
                .background(color = buttonColorPrimary, shape = RoundedCornerShape(50)),
            onClick = {
                viewModel.restartGame()
            },
        ) {
            Icon(
                modifier = Modifier
                    .padding(4.dp),
                painter = painterResource(id = R.drawable.baseline_refresh_24),
                contentDescription = stringResource(id = R.string.icon_restart_desc),
                tint = textColorSecondary
            )
        }

        if (screenState != Level5) {
            Button(
                onClick = {
                    if (nextLevelIsOpen) {
                        gameViewModel.setScreenState(nextScreen.value)
                        viewModel.restartGame()
                    } else {
                        showWarningToast(
                            context = context,
                            stringRes = R.string.toast_text_win_level
                        )
                    }

                },
                colors = ButtonDefaults.buttonColors(containerColor = buttonColorPrimary),
                elevation = ButtonDefaults.buttonElevation(
                    defaultElevation = 10.dp,
                    pressedElevation = 20.dp
                )
            ) {
                Text(
                    text = stringResource(id = R.string.go_to_next_button_text),
                    color = textColorSecondary,
                    fontSize = 18.sp
                )
            }
        }
    }
}
"""
    }
    
    static func dependencies(_ mainData: MainData) -> ANDData {
        return ANDData(mainFragmentData: ANDMainFragment(imports: "", content: """
    Navigation()
"""), mainActivityData: ANDMainActivity(imports: "", extraFunc: "", content: ""), themesData: ANDThemesData(isDefault: true, content: ""), stringsData: ANDStringsData(additional: """
    <string name="level1_text">Level 1</string>
    <string name="level2_text">Level 2</string>
    <string name="level3_text">Level 3</string>
    <string name="level4_text">Level 4</string>
    <string name="level5_text">Level 5</string>
    <string name="level_not_chosen">Not Chosen</string>
    <string name="image_desc">click</string>
    <string name="go_to_menu_button_text">Go to menu</string>
    <string name="go_to_next_button_text">Next</string>
    <string name="icon_restart_desc">restart</string>
    <string name="timer">%1$s sec</string>
    <string name="timer_countdown">Start in %1$s\\n\\n Click at least %2$s times!</string>
    <string name="max_score_text">Your max score: %1$s</string>
    <string name="toast_text_finish_previous">Finish previous levels</string>
    <string name="toast_text_win_level">You need to win this level first</string>
    <string name="background_image_res">background</string>
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
