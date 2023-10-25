//
//  File.swift
//  
//
//  Created by admin on 23.10.2023.
//

import Foundation

struct EGTicTacToe: FileProviderProtocol {
    static var fileName: String = "\(NamesManager.shared.fileName).kt"
    
    static func fileContent(packageName: String, uiSettings: UISettings) -> String {
        return """
package \(packageName).presentation.fragments.main_fragment

import android.content.Context
import androidx.compose.animation.AnimatedVisibility
import androidx.compose.animation.ExperimentalAnimationApi
import androidx.compose.animation.core.tween
import androidx.compose.animation.fadeIn
import androidx.compose.animation.scaleIn
import androidx.compose.foundation.BorderStroke
import androidx.compose.foundation.Canvas
import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.interaction.MutableInteractionSource
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.aspectRatio
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.lazy.grid.GridCells
import androidx.compose.foundation.lazy.grid.LazyVerticalGrid
import androidx.compose.foundation.lazy.grid.itemsIndexed
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.Button
import androidx.compose.material3.ButtonDefaults
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.OutlinedButton
import androidx.compose.material3.Text
import androidx.compose.material3.Typography
import androidx.compose.material3.lightColorScheme
import androidx.compose.runtime.Composable
import androidx.compose.runtime.collectAsState
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.draw.shadow
import androidx.compose.ui.geometry.Offset
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.StrokeCap
import androidx.compose.ui.graphics.drawscope.Stroke
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.TextStyle
import androidx.compose.ui.text.font.FontFamily
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.hilt.navigation.compose.hiltViewModel
import androidx.lifecycle.SavedStateHandle
import androidx.lifecycle.ViewModel
import androidx.navigation.NamedNavArgument
import androidx.navigation.NavHostController
import androidx.navigation.NavType
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import androidx.navigation.compose.rememberNavController
import androidx.navigation.navArgument
import \(packageName).R
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.asStateFlow
import javax.inject.Inject

val backColorPrimary = Color(0xFF\(uiSettings.backColorPrimary ?? "FFFFFF"))
val primaryColor = Color(0xFF\(uiSettings.primaryColor ?? "FFFFFF"))
val textColorSecondary = Color(0xFF\(uiSettings.textColorSecondary ?? "FFFFFF"))
val textColorPrimary = Color(0xFF\(uiSettings.textColorPrimary ?? "FFFFFF"))
val buttonTextColorPrimary = Color(0xFF\(uiSettings.buttonTextColorPrimary ?? "FFFFFF"))
val errorColor = Color(0xFF\(uiSettings.errorColor ?? "FFFFFF"))
val surfaceColor = Color(0xFF\(uiSettings.surfaceColor ?? "FFFFFF"))

private val LightColorPalette = lightColorScheme(
    primary =primaryColor,
    background = backColorPrimary,
)
@Composable
fun TicTacToeTheme(
    content: @Composable () -> Unit
) {
    MaterialTheme(
        colorScheme = LightColorPalette,
        typography = Typography,
        content = content
    )
}

val Typography = Typography(
    displayLarge = TextStyle(
        fontFamily = FontFamily.Monospace,
        fontWeight = FontWeight.Bold,
        fontSize =30.sp,
        lineHeight = 30.sp,
        letterSpacing = 0.4.sp,
    ),
    displayMedium = TextStyle(
        fontFamily = FontFamily.SansSerif,
        fontWeight = FontWeight.W600,
        fontSize = 20.sp,
        lineHeight = 20.sp,
        letterSpacing = 0.4.sp,
    ),
    displaySmall = TextStyle(
        fontFamily = FontFamily.SansSerif,
        fontWeight = FontWeight.Light,
        fontSize = 15.sp,
        lineHeight = 15.sp,
    )
)

@Composable
fun BoardBase() {
    Canvas(
        modifier = Modifier
            .size(300.dp)
            .padding(10.dp),
    ) {
        drawLine(
            color = surfaceColor,
            strokeWidth = 5f,
            cap = StrokeCap.Round,
            start = Offset(x = size.width / 3, y = 0f),
            end = Offset(x = size.width / 3, y = size.height)
        )
        drawLine(
            color = surfaceColor,
            strokeWidth = 5f,
            cap = StrokeCap.Round,
            start = Offset(x = size.width * 2 / 3, y = 0f),
            end = Offset(x = size.width * 2 / 3, y = size.height)
        )
        drawLine(
            color = surfaceColor,
            strokeWidth = 5f,
            cap = StrokeCap.Round,
            start = Offset(x = 0f, y = size.height / 3),
            end = Offset(x = size.width, y = size.height / 3)
        )
        drawLine(
            color = surfaceColor,
            strokeWidth = 5f,
            cap = StrokeCap.Round,
            start = Offset(x = 0f, y = size.height * 2 / 3),
            end = Offset(x = size.width, y = size.height * 2 / 3)
        )
    }
}

@Composable
fun DrawVictoryLine(victoryType: VictoryType) {
    Canvas(modifier = Modifier.size(300.dp)) {
        var start = Offset(0f, 0f)
        var end = Offset(0f, 0f)
        when (victoryType) {
            VictoryType.HORIZONTAL1 -> {
                start = Offset(x = 0f, y = size.height * 1 / 6)
                end = Offset(x = size.width, y = size.height * 1 / 6)
            }

            VictoryType.HORIZONTAL2 -> {
                start = Offset(x = 0f, y = size.height * 3 / 6)
                end = Offset(x = size.width, y = size.height * 3 / 6)
            }

            VictoryType.HORIZONTAL3 -> {
                start = Offset(x = 0f, y = size.height * 5 / 6)
                end = Offset(x = size.width, y = size.height * 5 / 6)
            }

            VictoryType.VERTICAL1 -> {
                start = Offset(x = size.width * 1 / 6, y = 0f)
                end = Offset(x = size.width * 1 / 6, y = size.height)
            }

            VictoryType.VERTICAL2 -> {
                start = Offset(x = size.width * 3 / 6, y = 0f)
                end = Offset(x = size.width * 3 / 6, y = size.height)
            }

            VictoryType.VERTICAL3 -> {
                start = Offset(x = size.width * 5 / 6, y = 0f)
                end = Offset(x = size.width * 5 / 6, y = size.height)
            }

            VictoryType.DIAGONAL1 -> {
                end = Offset(x = size.width, y = size.height)
            }

            VictoryType.DIAGONAL2 -> {
                start = Offset(x = 0f, y = size.height)
                end = Offset(x = size.width, y = 0f)
            }

            VictoryType.NONE -> {}
        }
        drawLine(
            color = errorColor,
            strokeWidth = 10f,
            cap = StrokeCap.Round,
            start = start,
            end = end
        )
    }
}

@Composable
fun CustomButton(modifier: Modifier, text: String, onClick: () -> Unit) {
    OutlinedButton(
        modifier = modifier,
        shape = RoundedCornerShape(20.dp),
        border = BorderStroke(width = 2.dp, color = MaterialTheme.colorScheme.primary),
        colors = ButtonDefaults.buttonColors(
            containerColor = backColorPrimary,
            contentColor = primaryColor
        ),
        onClick = onClick
    ) {
        Text(
            text = text,
            style = MaterialTheme.typography.displayMedium
        )
    }
}

@Composable
fun Circle() {
    Canvas(
        modifier = Modifier
            .size(60.dp)
            .padding(5.dp)
    ) {
        drawCircle(
            color = textColorSecondary,
            style = Stroke(width = 20f)
        )
    }
}

@Composable
fun Cross() {
    Canvas(
        modifier = Modifier
            .size(60.dp)
            .padding(5.dp)
    ) {
        drawLine(
            color = textColorPrimary,
            strokeWidth = 20f,
            cap = StrokeCap.Round,
            start = Offset(x = 0f, y = 0f),
            end = Offset(x = size.width, y = size.height)
        )
        drawLine(
            color = textColorPrimary,
            strokeWidth = 20f,
            cap = StrokeCap.Round,
            start = Offset(x = 0f, y = size.height),
            end = Offset(x = size.width, y = 0f)
        )
    }
}

@ExperimentalAnimationApi
@Composable
fun PlayGrid(gameViewModel: GameViewModel = hiltViewModel()) {
    val board = gameViewModel.state.collectAsState().value.boardCurrent
    LazyVerticalGrid(
        modifier = Modifier
            .fillMaxWidth(0.9f)
            .aspectRatio(1f),
        columns = GridCells.Fixed(3)
    ) {
        itemsIndexed(board) { index, item ->
            Box(
                modifier = Modifier
                    .fillMaxWidth()
                    .aspectRatio(1f)
                    .clickable(
                        interactionSource = MutableInteractionSource(),
                        indication = null
                    ) {
                        gameViewModel.addValueToBoard(index)
                    },
                contentAlignment = Alignment.Center,
            ) {
                AnimatedVisibility(
                    visible = item != BoardCellValue.NONE,
                    enter = scaleIn(tween(200))
                ) {
                    when(item){
                        BoardCellValue.CIRCLE -> Circle()
                        BoardCellValue.CROSS -> Cross()
                        BoardCellValue.NONE -> {}
                    }
                }
            }
        }
    }
}

@ExperimentalAnimationApi
@Composable
fun Navigation() {
    val navController = rememberNavController()

    NavHost(navController = navController, startDestination = Screens.MainScreen.route) {

        composable(route = Screens.MainScreen.route) {
            MainScreen(navController)
        }

        composable(
            route = Screens.GameScreen.route,
            arguments = Screens.GameScreen.listArg
        )
        { entry ->
            val singlePlayer = entry.arguments?.getInt(Screens.singlePlayer)
            singlePlayer?.let {
                GameScreen()
            }

        }
    }

}
sealed class  Screens(val route: String, val listArg: List<NamedNavArgument>) {
    companion object {
        const val singlePlayer = "single_player"
    }

    object MainScreen : Screens(
        route = "main_screen",
        listArg = emptyList()
    )

    object GameScreen : Screens(
        route = "game_screen/{$singlePlayer}",
        listArg = listOf(
            navArgument(singlePlayer) {
                type = NavType.BoolType
            }
        )
    ) {
        fun createArg(singlePlayer: Boolean) = "game_screen/$singlePlayer"
    }
}
enum class BoardCellValue {
    CIRCLE,
    CROSS,
    NONE
}

enum class GameStatus {
    CONTINUE,
    WIN,
    TIE
}
fun BoardCellValue.toSign ():String{
    return when(this){
        BoardCellValue.CIRCLE -> "O"
        BoardCellValue.CROSS -> "X"
        BoardCellValue.NONE -> ""
    }
}

enum class VictoryType {
    HORIZONTAL1,
    HORIZONTAL2,
    HORIZONTAL3,
    VERTICAL1,
    VERTICAL2,
    VERTICAL3,
    DIAGONAL1,
    DIAGONAL2,
    NONE
}

object ComputerPlayer {

    private val victoryLines: List<Triple<Int,Int,Int>> = listOf(
        Triple(0, 1, 2),
        Triple(3, 4, 5),
        Triple(6, 7, 8),
        Triple(0, 3, 6),
        Triple(1, 4, 7),
        Triple(2, 5, 8),
        Triple(0, 4, 8),
        Triple(2, 4, 6),
    )

    fun computerMove(board: List<BoardCellValue>): Int {
        var indexCell = checkVictoryLine(2, 0, board)
        if (indexCell > -1) {
            return indexCell
        }
        indexCell = checkVictoryLine(0, 2, board)
        if (indexCell > -1) {
            return indexCell
        }
        indexCell = checkVictoryLine(1, 0, board)
        if (indexCell > -1) {
            return indexCell
        }
        if (board[4] == BoardCellValue.NONE) return 4
        return 0
    }

    private fun checkVictoryLine(
        amountComputer: Int,
        amountPlayer: Int,
        board: List<BoardCellValue>
    ): Int {
        var sumComputer: Int
        var sumPlayer: Int
        var indexCell:Int
        victoryLines.forEach { line ->
            sumComputer = 0
            sumPlayer = 0
            indexCell = 0
            line.toList().forEach { index ->
                when (board[index]) {
                    BoardCellValue.CIRCLE -> {
                        sumComputer++
                    }

                    BoardCellValue.CROSS -> {
                        sumPlayer++
                    }

                    BoardCellValue.NONE -> {
                        indexCell = index
                    }
                }
            }
            if (sumComputer == amountComputer && sumPlayer == amountPlayer)
                return indexCell
        }
        return -1
    }

}

@ExperimentalAnimationApi
@Composable
fun GameScreen (gameViewModel: GameViewModel = hiltViewModel()) {
    val context = LocalContext.current
    Column(
        modifier = Modifier
            .fillMaxSize()
            .padding(horizontal = 30.dp),
        horizontalAlignment = Alignment.CenterHorizontally,
        verticalArrangement = Arrangement.SpaceEvenly
    ) {
        val gameState = gameViewModel.state.collectAsState().value
        Text(
            text = checkResult(gameState,context),
            style = MaterialTheme.typography.displayMedium,
            color = primaryColor
        )
        Box(
            modifier = Modifier
                .fillMaxWidth()
                .aspectRatio(1f)
                .shadow(
                    elevation = 10.dp,
                    shape = RoundedCornerShape(20.dp)
                )
                .clip(RoundedCornerShape(20.dp))
                .background(backColorPrimary),
            contentAlignment = Alignment.Center
        ) {
            BoardBase()
            PlayGrid()
            Column(
                modifier = Modifier
                    .fillMaxWidth()
                    .aspectRatio(1f),
                horizontalAlignment = Alignment.CenterHorizontally,
                verticalArrangement = Arrangement.Center
            ) {
                AnimatedVisibility(
                    visible = gameState.status == GameStatus.WIN,
                    enter = fadeIn(tween(400))
                ) {
                    DrawVictoryLine(gameState.victoryType)
                }
            }
        }
        Button(
            onClick = {
                gameViewModel.gameReset()
            },
            shape = RoundedCornerShape(5.dp),
            elevation = ButtonDefaults.buttonElevation(5.dp),
            colors = ButtonDefaults.buttonColors(containerColor = primaryColor)
        ) {
            Text(
                text = stringResource(R.string.btn_play_again),
                style = MaterialTheme.typography.displayMedium,
                color = buttonTextColorPrimary
            )
        }
    }
}

fun checkResult(gameState: GameState, context: Context): String {
    return when (gameState.status) {
        GameStatus.CONTINUE -> context.getString(R.string.result_continue, gameState.currentTurn.toSign())
        GameStatus.WIN -> context.getString(R.string.result_win, gameState.currentTurn.toSign())
        GameStatus.TIE -> context.getString(R.string.result_tie)
    }
}
data class GameState(
    val status: GameStatus = GameStatus.CONTINUE,
    val singlePlayer: Boolean =true,
    val drawCount: Int = 0,
    val currentTurn: BoardCellValue = BoardCellValue.CROSS,
    val victoryType: VictoryType = VictoryType.NONE,
    val boardCurrent:List<BoardCellValue> = List(9){BoardCellValue.NONE}
)
@HiltViewModel
class GameViewModel @Inject constructor(
    savedStateHandle: SavedStateHandle
) : ViewModel() {

    private val _state =
        MutableStateFlow(GameState())
    val state = _state.asStateFlow()

    init {
        val singlePlayer = savedStateHandle.get<Boolean>(Screens.singlePlayer)
        singlePlayer?.let{
            _state.value = _state.value.copy(
                singlePlayer = singlePlayer
            )
        }

    }
    fun gameReset() {
        _state.value = _state.value.copy(
            currentTurn = BoardCellValue.CROSS,
            victoryType = VictoryType.NONE,
            status = GameStatus.CONTINUE,
            boardCurrent = List(9) {BoardCellValue.NONE},
            drawCount = 0
        )
    }

    fun addValueToBoard(cellIndex: Int) {
        _state.value.apply {
            if (boardCurrent[cellIndex] !== BoardCellValue.NONE || status == GameStatus.WIN) return
            val copyBoard = boardCurrent.toMutableList()
            copyBoard[cellIndex] = currentTurn
            _state.value = copy(
                drawCount = drawCount + 1,
                boardCurrent = copyBoard,
            )
            checkGameOver(currentTurn)
            if(singlePlayer && currentTurn == BoardCellValue.CROSS){
                addValueToBoard(ComputerPlayer.computerMove(copyBoard))
            }
        }
    }

    private fun checkGameOver(currentTurn: BoardCellValue): Boolean {
        if (checkForVictory(currentTurn)) {
            _state.value = _state.value.copy(
                status = GameStatus.WIN,
            )
            return true
        } else {
            _state.value = _state.value.copy(
                currentTurn = if (currentTurn == BoardCellValue.CIRCLE) BoardCellValue.CROSS else BoardCellValue.CIRCLE,
            )
        }
        return checkForTie()
    }

    private fun checkForTie(): Boolean {
        return if(_state.value.drawCount == 9){
            _state.value = _state.value.copy(status = GameStatus.TIE)
            true
        } else false
    }

    private fun checkForVictory(boardValue: BoardCellValue): Boolean {
        with(_state.value) {
            when {
                boardCurrent[0] == boardValue && boardCurrent[1] == boardValue && boardCurrent[2] == boardValue -> {
                    _state.value = copy(victoryType = VictoryType.HORIZONTAL1)
                    return true
                }

                boardCurrent[3] == boardValue && boardCurrent[4] == boardValue && boardCurrent[5] == boardValue -> {
                    _state.value = copy(victoryType = VictoryType.HORIZONTAL2)
                    return true
                }

                boardCurrent[6] == boardValue && boardCurrent[7] == boardValue && boardCurrent[8] == boardValue -> {
                    _state.value = copy(victoryType = VictoryType.HORIZONTAL3)
                    return true
                }

                boardCurrent[0] == boardValue && boardCurrent[3] == boardValue && boardCurrent[6] == boardValue -> {
                    _state.value = copy(victoryType = VictoryType.VERTICAL1)
                    return true
                }

                boardCurrent[1] == boardValue && boardCurrent[4] == boardValue && boardCurrent[7] == boardValue -> {
                    _state.value = copy(victoryType = VictoryType.VERTICAL2)
                    return true
                }

                boardCurrent[2] == boardValue && boardCurrent[5] == boardValue && boardCurrent[8] == boardValue -> {
                    _state.value = copy(victoryType = VictoryType.VERTICAL3)
                    return true
                }

                boardCurrent[0] == boardValue && boardCurrent[4] == boardValue && boardCurrent[8] == boardValue -> {
                    _state.value = copy(victoryType = VictoryType.DIAGONAL1)
                    return true
                }

                boardCurrent[2] == boardValue && boardCurrent[4] == boardValue && boardCurrent[6] == boardValue -> {
                    _state.value = copy(victoryType = VictoryType.DIAGONAL2)
                    return true
                }

                else -> return false
            }
        }
    }
}

@Composable
fun MainScreen(navController: NavHostController) {
    Column(
        modifier = Modifier
            .fillMaxSize()
            .padding(horizontal = 30.dp),
        horizontalAlignment = Alignment.CenterHorizontally,
        verticalArrangement = Arrangement.Center
    ) {
        Text(
            modifier = Modifier
                .padding(bottom = 40.dp),
            text = stringResource(id = R.string.app_name),
            style = MaterialTheme.typography.displayLarge,
            color = primaryColor
        )
        CustomButton(
            modifier = Modifier
                .fillMaxWidth()
                .padding(bottom = 20.dp),
            text = stringResource(R.string.btn_single_player)
        ) {
            navController.navigate(Screens.GameScreen.createArg(true))
        }
        CustomButton(
            modifier = Modifier
                .fillMaxWidth()
                .padding(bottom = 20.dp),
            text = stringResource(R.string.btn_two_players)
        ) {
            navController.navigate(Screens.GameScreen.createArg(false))
        }
    }
}

"""
    }
    
    static func dependencies(_ mainData: MainData) -> ANDData {
        return ANDData(
            mainFragmentData: ANDMainFragment(imports: """
import androidx.compose.animation.ExperimentalAnimationApi
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Surface
import androidx.compose.ui.Modifier
""", content: """
                TicTacToeTheme {
                    Surface(
                        modifier = Modifier
                            .fillMaxSize()
                            .background(MaterialTheme.colorScheme.background)
                    ){
                        Navigation()
                    }
                }
""", annotation: """
@ExperimentalAnimationApi
"""),
            mainActivityData: .empty,
            themesData: .def,
            stringsData: ANDStringsData(additional: """
    <string name="btn_play_again">Play Again</string>
    <string name="result_tie">It is a tie!</string>
    <string name="result_win">"Player '%s' won!"</string>
    <string name="result_continue">"Player '%s' turn"</string>
    <string name="btn_single_player">Single Player</string>
    <string name="btn_two_players">Two Players</string>
"""), 
            colorsData: .empty)
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
            signingConfig signingConfigs.debug
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
