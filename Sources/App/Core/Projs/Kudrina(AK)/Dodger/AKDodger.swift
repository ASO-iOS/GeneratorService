//
//  File.swift
//  
//
//  Created by admin on 19.09.2023.
//

import Foundation

struct AKDodger: FileProviderProtocol {
    static var fileName: String = "\(NamesManager.shared.fileName).kt"
    
    static func fileContent(packageName: String, uiSettings: UISettings) -> String {
        return """
package \(packageName).presentation.fragments.main_fragment

import android.content.res.Resources
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.graphics.Rect
import android.view.MotionEvent
import androidx.annotation.DrawableRes
import androidx.compose.foundation.Canvas
import androidx.compose.foundation.Image
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.BoxScope
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.material3.Button
import androidx.compose.material3.ButtonDefaults
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.collectAsState
import androidx.compose.ui.Alignment
import androidx.compose.ui.ExperimentalComposeUiApi
import androidx.compose.ui.Modifier
import androidx.compose.ui.geometry.Offset
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.ImageBitmap
import androidx.compose.ui.graphics.asImageBitmap
import androidx.compose.ui.input.pointer.pointerInteropFilter
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.hilt.navigation.compose.hiltViewModel
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import \(packageName).R
import \(packageName).presentation.fragments.main_fragment.BitmapsHandler.Companion.screenHeight
import \(packageName).presentation.fragments.main_fragment.BitmapsHandler.Companion.screenWidth
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.Job
import kotlinx.coroutines.SupervisorJob
import kotlinx.coroutines.delay
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.launch
import javax.inject.Inject
import javax.inject.Singleton
import kotlin.random.Random

val textColorPrimary = Color(0xFF\(uiSettings.textColorPrimary ?? "FFFFFF"))
val buttonTextColorPrimary = Color(0xFF\(uiSettings.buttonTextColorPrimary ?? "FFFFFF"))
val buttonColorPrimary = Color(0xFF\(uiSettings.buttonColorPrimary ?? "FFFFFF"))
val backColorPrimary = Color(0xFF\(uiSettings.backColorPrimary ?? "FFFFFF"))

fun Rect.intersects(rect: Rect): Boolean {
    return intersects(rect.left, rect.top, rect.right, rect.bottom)
}

val time: Long = System.currentTimeMillis()


@HiltViewModel
class GameViewModel @Inject constructor(
    private val gameThread: GameThread,
    private val gameRepository: GameRepository
) : ViewModel() {

    private val _gameState = MutableStateFlow(GameState())
    val gameState = _gameState.asStateFlow()

    private val _screenState = MutableStateFlow<ScreenState>(ScreenState.MainMenu)
    val screenState = _screenState.asStateFlow()



    init {
        viewModelScope.launch {
            gameThread.threadState.collect {
                frame()
            }
        }
    }


    fun restartGame() = with(_gameState.value) {
        _gameState.value = copy(
            player = player.apply {
                x = gameRepository.playerDefaultPosition
            },
            enemies = listOf(),
            score = 0
        )
        gameThread.start()
        _screenState.value = ScreenState.Running
    }

    fun startGame() = with(_gameState.value) {
        _gameState.value = copy(
            player = player.apply {
                initialize()
            },
            enemies = enemies.onEach { enemy ->
                enemy.initialize(score)
            }
        )
        gameThread.start()
        _screenState.value = ScreenState.Running
    }


    private fun frame() = with(_gameState.value) {
        _gameState.value = copy(
            player = player.apply {
                frame()
            },
            enemies = enemies.onEach { enemy ->
                enemy.frame()
            },
            score = score+1
        )
        gameRepository.scoreCheck(
            score = score,
            checkCollision = ::checkCollision,
            spawnEnemy = ::spawnEnemy,
            clear = ::clear,
            increaseEnemySpawnRate = ::increaseEnemySpawnRate
        )
    }

    fun startMovingPlayer(directionRight: Boolean) = with(_gameState.value) {
        _gameState.value = copy(
            player = player.apply {
                startMoving(directionRight)
            }
        )
    }

    fun stopMovingPlayer() = with(_gameState.value) {
        _gameState.value = copy(
            player = player.apply {
                stopMoving()
            }
        )
    }

    private fun checkCollision() = with(_gameState.value) {
        enemies.forEach { enemy ->
            if (enemy.hasCollision(player))
                lose()
        }
    }

    private fun lose() {
        gameThread.pause()
        _screenState.value = ScreenState.Lost
    }

    private fun increaseEnemySpawnRate() {
        gameRepository.enemiesSpawnBoost++
    }

    private fun clear() = with(_gameState.value) {
        _gameState.value = copy(
            enemies = enemies.filterNot { enemy ->
                enemy.isOutOfBound()
            }
        )

        _gameState.value = copy(
            enemies = enemies.toMutableList().apply {
                addAll(
                    listOf(
                        Enemy().apply { initialize(score) },
                        Enemy().apply { initialize(score) },
                        Enemy().apply { initialize(score) },
                        Enemy().apply { initialize(score) },
                        Enemy().apply { initialize(score) },
                        Enemy().apply { initialize(score) },
                        Enemy().apply { initialize(score) },
                        Enemy().apply { initialize(score) },
                        Enemy().apply { initialize(score) },
                        Enemy().apply { initialize(score) },
                        Enemy().apply { initialize(score) }
                    )
                )
            }
        )
    }

    private fun spawnEnemy() = with(_gameState.value) {
        _gameState.value = copy(
            enemies = enemies.toMutableList().apply {
                addAll(
                    listOf(
                        Enemy().apply { initialize(score) },
                        Enemy().apply { initialize(score) },
                        Enemy().apply { initialize(score) },
                        Enemy().apply { initialize(score) },
                        Enemy().apply { initialize(score) },
                        Enemy().apply { initialize(score) },
                        Enemy().apply { initialize(score) },
                        Enemy().apply { initialize(score) },
                        Enemy().apply { initialize(score) },
                        Enemy().apply { initialize(score) },
                        Enemy().apply { initialize(score) },
                        Enemy().apply { initialize(score) },
                        Enemy().apply { initialize(score) }
                    )
                )
            }
        )
    }
}


@Composable
fun DodgerGame(viewModel: GameViewModel = hiltViewModel()) {
    val screenState = viewModel.screenState.collectAsState()
    val context = LocalContext.current

    LaunchedEffect(key1 = Unit) {
        BitmapsHandler(context.resources)
    }

    when (screenState.value) {
        ScreenState.Running -> RunningScreen()
        ScreenState.MainMenu -> StartScreen()
        ScreenState.Lost -> LoseScreen()
    }
}

@Composable
fun StartScreen(viewModel: GameViewModel = hiltViewModel()) {

    Column(
        modifier = Modifier
            .fillMaxSize()
            .background(backColorPrimary),
        verticalArrangement = Arrangement.SpaceAround,
        horizontalAlignment = Alignment.CenterHorizontally
    ) {
        Text(
            text = stringResource(id = R.string.app_name),
            color = textColorPrimary,
            fontSize = 30.sp,
            textAlign = TextAlign.Center
        )
        Image(painter = painterResource(id = R.drawable.player), contentDescription = null, contentScale = ContentScale.FillBounds, modifier = Modifier.size(200.dp))

        Button(
            onClick = {
                viewModel.startGame()
            },
            colors = ButtonDefaults.buttonColors(containerColor = buttonColorPrimary),
        ) {
            Text(
                text = stringResource(id = R.string.start_button_text),
                color = buttonTextColorPrimary,
                fontSize = 30.sp
            )
        }
    }
}

@Composable
fun RunningScreen() {
    Box(
        modifier = Modifier
            .fillMaxSize()
            .background(backColorPrimary),
        contentAlignment = Alignment.Center
    ) {
        GameCanvas()
        ScoreDisplay()
    }
}

@Composable
fun BoxScope.ScoreDisplay(viewModel: GameViewModel = hiltViewModel()) {
    val gameState = viewModel.gameState.collectAsState().value.score/10
    Text(
        modifier = Modifier
            .padding(top = 24.dp)
            .align(Alignment.TopCenter),
        style = MaterialTheme.typography.displayLarge,
        text = gameState.toString(),
        color = textColorPrimary
    )
}

@OptIn(ExperimentalComposeUiApi::class)
@Composable
fun GameCanvas(viewModel: GameViewModel = hiltViewModel()) {
    val gameState = viewModel.gameState.collectAsState()
    Canvas(modifier = Modifier
        .fillMaxSize()
        .pointerInteropFilter { event ->
            when (event.action) {
                MotionEvent.ACTION_DOWN -> {
                    viewModel.startMovingPlayer(event.x > BitmapsHandler.screenWidth / 2)
                    true
                }

                MotionEvent.ACTION_UP -> {
                    viewModel.stopMovingPlayer()
                    false
                }

                else -> false
            }
        }
    ) {

        gameState.value.player.apply {
            bitmap?.let { bitmap ->
                drawImage(bitmap, Offset(x, y))
            }
        }

        gameState.value.enemies.forEach { enemy ->
            enemy.bitmap?.let { bitmap ->
                drawImage(bitmap, Offset(enemy.x, enemy.y))
            }
        }
    }
}

@Composable
fun LoseScreen(viewModel: GameViewModel = hiltViewModel()) {
    val gameState = viewModel.gameState.collectAsState()
    Column(
        modifier = Modifier
            .fillMaxSize()
            .background(backColorPrimary),
        verticalArrangement = Arrangement.SpaceAround,
        horizontalAlignment = Alignment.CenterHorizontally
    ) {
        Text(
            text = stringResource(id = R.string.result_text, gameState.value.score / 10),
            color = textColorPrimary,
            fontSize = 30.sp,
            textAlign = TextAlign.Center
        )

        Button(
            onClick = {
                viewModel.restartGame()
            },
            colors = ButtonDefaults.buttonColors(buttonColorPrimary)
        ) {
            Text(
                text = stringResource(id = R.string.restart_button_text),
                color = buttonTextColorPrimary,
                fontSize = 30.sp
            )
        }
    }
}

class GameThread @Inject constructor() {

    private val _threadState = MutableStateFlow(time)
    val threadState = _threadState.asStateFlow()

    private var startTime: Long = 0
    private var frameTime: Long = 0
    private val neededFrameTime: Int = (1000.0 / 60.0).toInt()

    private var job: Job? = null

    private var running: Boolean = false

    init {
        initialize()
    }

    private fun initialize() {
        job = CoroutineScope(
            Dispatchers.Default + SupervisorJob()
        ).launch {
            loop()
        }
    }

    private suspend fun loop() {
        while (running) {
            startTime = System.currentTimeMillis()

            frame()

            frameTime = System.currentTimeMillis() - startTime
            if (frameTime < neededFrameTime) {
                delay(neededFrameTime - frameTime)
            }
        }
    }

    private fun frame() {
        _threadState.value = System.currentTimeMillis()
    }

    fun pause() {
        job = null
        running = false
    }

    fun start() {
        running = true
        initialize()
    }
}

class BitmapsHandler(private val resources: Resources) {

    init {


        val playerWidth = resizeWidth(200)
        val playerHeight = resizeHeight(200)

        val enemyWidth = resizeWidth(100)
        val enemyHeight = resizeHeight(100)


        player = initBitmap(
            R.drawable.player,
            playerWidth,
            playerHeight
        )

        enemy = initBitmap(
            R.drawable.enemy,
            enemyWidth,
            enemyHeight
        )

    }

    private fun initBitmap(
        @DrawableRes res: Int,
        width: Int,
        height: Int
    ): ImageBitmap {
        return Bitmap.createScaledBitmap(
            BitmapFactory.decodeResource(resources, res),
            width,
            height,
            false
        ).asImageBitmap()
    }

    companion object {
        var player: ImageBitmap? = null
        var enemy: ImageBitmap? = null

        val screenWidth = Resources.getSystem().displayMetrics.widthPixels
        val screenHeight = Resources.getSystem().displayMetrics.heightPixels

        private const val INIT_WIDTH = 1080
        private const val INIT_HEIGHT = 2040

        private fun resizeWidth(size: Int) = screenWidth * size / INIT_WIDTH
        private fun resizeHeight(size: Int) = screenHeight * size / INIT_HEIGHT
    }
}

data class GameState(
    val player: Player = Player(),
    val enemies: List<Enemy> = listOf(),
    val score: Int = 0
)

sealed class ScreenState {
    object Running : ScreenState()
    object MainMenu : ScreenState()
    object Lost : ScreenState()
}

@Singleton
class GameRepository @Inject constructor(){

    val playerDefaultPosition = BitmapsHandler.screenWidth / 2f

    var enemiesSpawnBoost = 0

    fun scoreCheck(
        score: Int,
        checkCollision:() -> Unit,
        spawnEnemy: () -> Unit,
        clear: () -> Unit,
        increaseEnemySpawnRate: () -> Unit,
    ) {
        if (score % 5 == 0)
            checkCollision()
        when {
            score % (180 - enemiesSpawnBoost) == 0 -> spawnEnemy()
            score % 250 == 0 -> clear()
            score % 475 == 0 -> increaseEnemySpawnRate()
            else -> {
                /*nothing*/
            }
        }
    }
}

class Player : GameObject() {

    private var isMoving: Boolean = false
    private var directionRight: Boolean = true

    fun initialize() {
        bitmap = BitmapsHandler.player
        bitmap?.let { bitmap ->
            width = bitmap.width
            height = bitmap.height
        }
        x = screenWidth / 2 - width / 2f
        y = screenHeight - height.toFloat() * 1.3f
        speed = 16f
        setRect()
    }

    fun frame() {
        if (isMoving)
            move()
        setRect()
    }

    private fun move() {
        if (directionRight) {
            if (x < screenWidth - width)
                x += speed
        } else {
            if (x > 0)
                x -= speed
        }
    }

    fun startMoving(directionRight: Boolean) {
        this.directionRight = directionRight
        isMoving = true
    }

    fun stopMoving() {
        isMoving = false
    }

}

open class GameObject {
    var x = 0f
    var y = 0f
    var speed = 0f
    var bitmap: ImageBitmap? = null
    var width = 0
    var height = 0
    var rect: Rect = Rect()

    open fun setRect() {
        rect.set(x.toInt(), y.toInt(), (x + width).toInt(), (y + height).toInt())
    }

    open fun hasCollision(gameObject: GameObject) = rect.intersects(gameObject.rect)

    fun getRandom(bound: Int, upperBound: Int) =
        Random(System.currentTimeMillis()).nextInt(bound, upperBound)
}

class Enemy : GameObject() {
    fun initialize(boost: Int) {
        bitmap = BitmapsHandler.enemy
        bitmap?.let { bitmap ->
            width = bitmap.width
            height = bitmap.height
        }
        y = -getRandom(height, screenHeight).toFloat()
        x = getRandom(width, screenWidth) - width.toFloat()
        speed = 20f + boost / 450f
        setRect()
    }

    fun frame() {
        y += speed
        setRect()
    }

    fun isOutOfBound() = y > screenHeight
}
"""
    }
    
    static func dependencies(_ mainData: MainData) -> ANDData {
        return ANDData(mainFragmentData: ANDMainFragment(imports: "", content: """
    DodgerGame()
"""), mainActivityData: ANDMainActivity(imports: "", extraFunc: "", content: ""), themesData: ANDThemesData(isDefault: true, content: ""), stringsData: ANDStringsData(additional: """
    <string name="restart_button_text">Restart</string>
    <string name="start_button_text">Start</string>
    <string name="result_text">Game Over\\nScore: %1$d</string>
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

    const val compose_ui = "androidx.compose.ui:ui:1.0.0-alpha05"
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
