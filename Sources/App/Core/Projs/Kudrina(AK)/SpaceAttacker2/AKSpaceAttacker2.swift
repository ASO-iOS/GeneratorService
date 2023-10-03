//
//  File.swift
//  
//
//  Created by admin on 30.09.2023.
//

import Foundation

struct AKSpaceAttacker2: FileProviderProtocol {
    static var fileName: String = "\(NamesManager.shared.fileName).kt"
    
    static func fileContent(packageName: String, uiSettings: UISettings) -> String {
        return """
package \(packageName).presentation.fragments.main_fragment

import android.content.Context
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
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.width
import androidx.compose.material3.Button
import androidx.compose.material3.ButtonDefaults
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
import \(packageName).R
import dagger.hilt.android.lifecycle.HiltViewModel
import dagger.hilt.android.qualifiers.ApplicationContext
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.Job
import kotlinx.coroutines.delay
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.flow.flowOn
import kotlinx.coroutines.flow.map
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import javax.inject.Inject
import javax.inject.Singleton
import kotlin.random.Random

val textColorPrimary = Color(0xFF\(uiSettings.textColorPrimary ?? "FFFFFF"))
val buttonColorPrimary = Color(0xFF\(uiSettings.buttonColorPrimary ?? "FFFFFF"))
val backColorPrimary = Color(0xFF\(uiSettings.backColorPrimary ?? "FFFFFF"))

fun Rect.intersects(rect: Rect): Boolean {
    return intersects(rect.left, rect.top, rect.right, rect.bottom)
}

val time: Long = System.currentTimeMillis()

val defaultBackgroundSpeed = BitmapsHandler.screenHeight / 200f

val defaultEnemySpeed = BitmapsHandler.screenHeight / 120

val Context.dataStore: DataStore<Preferences> by preferencesDataStore(name = "user_prefs")

@HiltViewModel
class GameViewModel @Inject constructor(
    private val gameThread: GameThread,
    private val gameRepository: GameRepository,
    private val bitmapsHandler: BitmapsHandler
) : ViewModel() {

    private val _gameState = MutableStateFlow(GameState())
    val gameState = _gameState.asStateFlow()

    private val _screenState = MutableStateFlow<ScreenState>(ScreenState.MainMenu)
    val screenState = _screenState.asStateFlow()

    private val _lives = MutableStateFlow<Int>(3)
    val lives = _lives.asStateFlow()

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
            enemies = listOf(Enemy().apply { initialize(0, bitmapsHandler) }),
            score = 0,
            background = background.apply {
                background.onEach { backgroundItem ->
                    backgroundItem.resetSpeed()
                }
            }
        )
        gameThread.start()
        _lives.value = 3
        _screenState.value = ScreenState.Running
    }

    fun startGame() = with(_gameState.value) {
        _gameState.value = copy(
            background = background.apply {
                initialize(bitmapsHandler)
            },
            player = player.apply {
                initialize(bitmapsHandler)
            },
            fireShoot = fireShoot.apply {
                initialize(bitmapsHandler, player)
            },
            enemies = enemies.toMutableList().apply {
                addAll(
                    listOf(
                        Enemy().apply { initialize(score, bitmapsHandler) },
                    )
                )
            },

            )
        gameThread.start()
        _screenState.value = ScreenState.Running
    }

    private fun frame() = with(_gameState.value) {
        _gameState.value = copy(
            background = background.apply {
                frame()
            },
            player = player.apply {
                frame()
            },
            fireShoot = fireShoot.apply {
                frame(player)
            },
            enemies = enemies.onEach { enemy ->
                enemy.frame()
            },
            score = score + 1
        )
        gameRepository.scoreCheck(
            score = score,
            checkCollision = ::checkCollision,
            clear = ::clear,
            increaseEnemySpawnRate = ::increaseEnemySpawnRate,
            addEnemy = ::addEnemy,
            checkShoot = ::checkShoot

        )
    }

    fun startMovingFireShoot() = with(_gameState.value) {
        _gameState.value = copy(
            fireShoot = fireShoot.apply {
                startMoving(bitmapsHandler, player)
            }
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

    private fun checkShoot() = with(_gameState.value) {
        enemies.forEach { enemy ->
            if (enemy.hasCollision(fireShoot)) {
                enemy.resetEnemyXY(bitmapsHandler)
            }
        }
    }

    private fun checkCollision() = with(_gameState.value) {
        enemies.forEach { enemy ->
            if (enemy.hasCollision(player)) {
                if (lives.value > 1) {
                    enemy.resetEnemyXY(bitmapsHandler)
                    _lives.value--
                } else {
                    lose()
                }
            }
        }
    }


    private fun lose() {
        getFromDataStore()
        if (dataStoreScore.value < gameState.value.score / 10) {
            saveToDataStore(gameState.value.score / 10)
        }
        if (lives.value > 1) {

            _lives.value--


        } else {
            viewModelScope.launch {
                _lives.value--
                gameThread.pause()
                delay(2000)
                _screenState.value = ScreenState.Lost
            }
        }
    }

    private fun increaseEnemySpawnRate() {
        gameRepository.enemiesSpawnBoost++
    }

    private fun clear() = with(_gameState.value) {
        enemies.forEach { enemy ->
            if (enemy.isOutOfBound()) enemy.resetEnemyXY(bitmapsHandler)
        }
        if (fireShoot.isOutOfBound()) {
            fireShoot.stopMoving()
            fireShoot.resetFireShoot(player)
        }
    }

    private fun addEnemy() = with(_gameState.value) {
        _gameState.value = copy(
            enemies = enemies.toMutableList().apply {
                add(
                    Enemy().apply { initialize(score, bitmapsHandler) },
                )
            }
        )
    }


    // DataStore
    fun saveToDataStore(score: Int) {
        viewModelScope.launch {
            gameRepository.storeScore(score)
        }
    }

    private val _dataStoreScore = MutableStateFlow(0)
    val dataStoreScore = _dataStoreScore.asStateFlow()

    fun getFromDataStore() {
        viewModelScope.launch {
            gameRepository.userScoreFlow.collect {
                _dataStoreScore.value = it
            }
        }
    }
}

@Composable
fun SpaceAttackerGame(viewModel: GameViewModel = hiltViewModel()) {
    val screenState = viewModel.screenState.collectAsState()

    when (screenState.value) {
        ScreenState.Running -> RunningScreen()
        ScreenState.MainMenu -> StartScreen()
        ScreenState.Lost -> LoseScreen()
    }
}

@Composable
fun BackgroundImage() {
    Image(
        modifier = Modifier
            .fillMaxSize(),
        painter = painterResource(id = R.drawable.background),
        contentDescription = stringResource(id = R.string.background_image_desc),
        contentScale = ContentScale.FillBounds
    )
}

@Composable
fun StartScreen(viewModel: GameViewModel = hiltViewModel()) {

    LaunchedEffect(key1 = Unit) {
        viewModel.getFromDataStore()
    }
    val dataStoreScore = viewModel.dataStoreScore.collectAsState().value

    BackgroundImage()

    Column(
        modifier = Modifier
            .fillMaxSize(),
        verticalArrangement = Arrangement.SpaceAround,
        horizontalAlignment = Alignment.CenterHorizontally
    ) {
        Text(
            text = stringResource(id = R.string.app_name),
            color = textColorPrimary,
            fontSize = 30.sp,
            textAlign = TextAlign.Center
        )

        Text(
            text = stringResource(id = R.string.max_score_text, dataStoreScore),
            color = textColorPrimary,
            fontSize = 18.sp,
            textAlign = TextAlign.Center
        )

        Button(
            onClick = {
                viewModel.startGame()
            },
            colors = ButtonDefaults.buttonColors(
                containerColor = buttonColorPrimary,
                contentColor = textColorPrimary
            ),
        ) {
            Text(
                text = stringResource(id = R.string.start_button_text),
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
        HeartDisplay()
        ShootButton()
    }
}

@Composable
fun BoxScope.ShootButton(viewModel: GameViewModel = hiltViewModel()) {
    Button(
        modifier = Modifier
            .padding(top = 24.dp, end = 8.dp)
            .align(Alignment.TopStart),
        onClick = {
            viewModel.startMovingFireShoot()
        },
        colors = ButtonDefaults.buttonColors(
            containerColor = buttonColorPrimary,
            contentColor = textColorPrimary
        )
    ) {
        Text(
            text = stringResource(id = R.string.shoot_button_text),
            fontSize = 18.sp
        )
    }
}

@Composable
fun BoxScope.ScoreDisplay(viewModel: GameViewModel = hiltViewModel()) {
    val gameState = viewModel.gameState.collectAsState().value.score / 10
    Text(
        modifier = Modifier
            .padding(top = 24.dp)
            .align(Alignment.TopCenter),
        fontSize = 40.sp,
        text = gameState.toString(),
        color = textColorPrimary
    )
}

@Composable
fun BoxScope.HeartDisplay(viewModel: GameViewModel = hiltViewModel()) {

    val livesAmount = viewModel.lives.collectAsState().value

    Row(
        modifier = Modifier
            .padding(top = 24.dp, end = 8.dp)
            .align(Alignment.TopEnd),
        horizontalArrangement = Arrangement.spacedBy(8.dp),
        verticalAlignment = Alignment.CenterVertically
    ) {
        repeat(livesAmount) {
            Image(
                modifier = Modifier
                    .width(25.dp)
                    .height(21.dp),
                painter = painterResource(id = R.drawable.heart),
                contentDescription = stringResource(id = R.string.heart_image_desc)
            )
        }
    }
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

        gameState.value.background.background.forEach { background ->
            background.bitmap?.let { bitmap ->
                drawImage(bitmap, Offset(0f, background.y + background.offset))
            }
        }


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

        gameState.value.fireShoot.apply {
            bitmap?.let { bitmap ->
                drawImage(bitmap, Offset(x, y))
            }
        }
    }
}

@Composable
fun LoseScreen(viewModel: GameViewModel = hiltViewModel()) {
    val gameState = viewModel.gameState.collectAsState()

    BackgroundImage()

    Column(
        modifier = Modifier
            .fillMaxSize(),
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
            colors = ButtonDefaults.buttonColors(
                containerColor = buttonColorPrimary,
                contentColor = textColorPrimary
            )
        ) {
            Text(
                text = stringResource(id = R.string.restart_button_text),
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
        job = CoroutineScope(Dispatchers.Default).launch {
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

class BitmapsHandler @Inject constructor(@ApplicationContext private val context: Context) {

    companion object {
        val screenWidth = Resources.getSystem().displayMetrics.widthPixels
        val screenHeight = Resources.getSystem().displayMetrics.heightPixels
    }

    private val INIT_WIDTH = 1080
    private val INIT_HEIGHT = 2040

    private fun resizeWidth(size: Int) = screenWidth * size / INIT_WIDTH
    private fun resizeHeight(size: Int) = screenHeight * size / INIT_HEIGHT


    val backgroundWidth = screenWidth
    val backgroundHeight = screenHeight

    val playerWidth = resizeWidth(150)
    val playerHeight = resizeHeight(300)

    val enemyWithFireWidth = resizeWidth(100)
    val enemyWithFireHeight = resizeHeight(200)

    val enemySmallRockWidth = resizeWidth(110)
    val enemySmallRockHeight = resizeHeight(150)

    val enemyBigRockWidth = resizeWidth(200)
    val enemyBigRockHeight = resizeHeight(145)

    val fireShootWidth = resizeWidth(50)
    val fireShootHeight = resizeHeight(100)

    val background: ImageBitmap? by lazy {
        initBitmap(
            R.drawable.background,
            backgroundWidth,
            backgroundHeight
        )
    }

    val player: ImageBitmap? by lazy {
        initBitmap(
            R.drawable.player,
            playerWidth,
            playerHeight
        )
    }

    val enemyWithFire: ImageBitmap? by lazy {
        initBitmap(
            R.drawable.enemy_with_fire,
            enemyWithFireWidth,
            enemyWithFireHeight
        )
    }

    val enemySmallRock: ImageBitmap? by lazy {
        initBitmap(
            R.drawable.enemy_small_rock,
            enemySmallRockWidth,
            enemySmallRockHeight
        )
    }

    val enemyBigRock: ImageBitmap? by lazy {
        initBitmap(
            R.drawable.enemy_big_rock,
            enemyBigRockWidth,
            enemyBigRockHeight
        )
    }

    val fireShoot: ImageBitmap? by lazy {
        initBitmap(
            R.drawable.fire,
            fireShootWidth,
            fireShootHeight
        )
    }


    private fun initBitmap(
        @DrawableRes res: Int,
        width: Int,
        height: Int
    ): ImageBitmap {
        return Bitmap.createScaledBitmap(
            BitmapFactory.decodeResource(context.resources, res),
            width,
            height,
            false
        ).asImageBitmap()
    }
}

sealed class ScreenState {
    object Running : ScreenState()
    object MainMenu : ScreenState()
    object Lost : ScreenState()
}

data class GameState(
    val background: Background = Background(),
    val player: Player = Player(),
    val enemies: List<Enemy> = listOf(),
    val score: Int = 0,
    val fireShoot: FireShoot = FireShoot()
)

@Singleton
class GameRepository @Inject constructor(@ApplicationContext private val context: Context) {

    val playerDefaultPosition = BitmapsHandler.screenWidth / 2f

    var enemiesSpawnBoost = 0

    fun scoreCheck(
        score: Int,
        checkCollision: () -> Unit,
        clear: () -> Unit,
        increaseEnemySpawnRate: () -> Unit,
        addEnemy: () -> Unit,
        checkShoot: () -> Unit,
    ) {

        if (score % 5 == 0) {
            checkShoot()
            checkCollision()
            clear()
        }

        when {
            score % 2500 == 0 && score != 0 -> {
                addEnemy()
            }

            score % 475 == 0 -> increaseEnemySpawnRate()
            else -> {
                /*nothing*/
            }
        }
    }


    // DataStore
    suspend fun storeScore(score: Int) = withContext(Dispatchers.IO) {
        context.dataStore.edit {
            it[USER_MAX_SCORE] = score
        }
    }

    val userScoreFlow: Flow<Int> = context.dataStore.data.map {
        it[USER_MAX_SCORE] ?: 0
    }.flowOn(Dispatchers.IO)

    companion object {
        val USER_MAX_SCORE = intPreferencesKey("USER_MAX_SCORE")
    }
}

class Player : GameObject() {

    private var isMoving: Boolean = false
    private var directionRight: Boolean = true

    fun initialize(bitmapsHandler: BitmapsHandler) {
        bitmap = bitmapsHandler.player
        bitmap?.let { bitmap ->
            width = bitmap.width
            height = bitmap.height
        }
        x = BitmapsHandler.screenWidth / 2 - width / 2f
        y = BitmapsHandler.screenHeight - height.toFloat()
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
            if (x < BitmapsHandler.screenWidth - width)
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

class FireShoot : GameObject() {

    private var isMoving: Boolean = false


    fun initialize(bitmapsHandler: BitmapsHandler, player: Player) {
        bitmap = bitmapsHandler.fireShoot
        bitmap?.let { bitmap ->
            width = bitmap.width
            height = bitmap.height
        }
        y = player.y
        x = player.x + player.width / 2 - width / 2
        speed = defaultEnemySpeed.toFloat()
        setRect()
    }

    fun frame(player: Player) {
        if (isMoving) move()
        else x = player.x + player.width / 2 - width / 2
        setRect()
    }

    private fun move() {
        y -= speed
    }

    fun isOutOfBound() = y < -height.toFloat()

    fun resetFireShoot(player: Player) {
        y = player.y
        x = player.x + player.width / 2 - width / 2
    }

    fun startMoving(bitmapsHandler: BitmapsHandler, player: Player) {
        initialize(bitmapsHandler, player)
        isMoving = true
    }

    fun stopMoving() {
        isMoving = false
    }

}

class Enemy : GameObject() {
    fun initialize(boost: Int, bitmapsHandler: BitmapsHandler) {
        bitmap = listOf(
            bitmapsHandler.enemyWithFire,
            bitmapsHandler.enemySmallRock,
            bitmapsHandler.enemyBigRock
        ).random()
        bitmap?.let { bitmap ->
            width = bitmap.width
            height = bitmap.height
        }
        y = -getRandom(height, BitmapsHandler.screenHeight).toFloat()
        x = getRandom(width, BitmapsHandler.screenWidth) - width.toFloat()
        speed = defaultEnemySpeed + boost / 450f
        setRect()
    }

    fun frame() {
        y += speed
        setRect()
    }

    fun isOutOfBound() = y > BitmapsHandler.screenHeight

    fun resetEnemyXY(bitmapsHandler: BitmapsHandler) {
        this.x = getRandom(width, BitmapsHandler.screenWidth) - width.toFloat()
        this.y = -getRandom(height, BitmapsHandler.screenHeight).toFloat()
        this.bitmap = listOf(
            bitmapsHandler.enemyWithFire,
            bitmapsHandler.enemySmallRock,
            bitmapsHandler.enemyBigRock
        ).random()
    }
}

class Background() {
    val background =
        listOf(BackgroundItem(0f), BackgroundItem(-BitmapsHandler.screenHeight.toFloat()))


    fun initialize(bitmapsHandler: BitmapsHandler) {
        background.forEach { background ->
            background.initialize(bitmapsHandler)
        }
    }

    fun frame() {
        background.forEach { background ->
            background.y = (background.y + background.speed) % BitmapsHandler.screenHeight
            background.increaseSpeed()
        }
    }

    class BackgroundItem(val offset: Float) : GameObject() {

        fun initialize(bitmapsHandler: BitmapsHandler) {
            bitmap = bitmapsHandler.background
            bitmap?.let { bitmap ->
                width = bitmap.width
                height = bitmap.height
            }
            speed = defaultBackgroundSpeed
        }

        fun increaseSpeed() {
            speed += 0.001f
        }

        fun resetSpeed() {
            speed = defaultBackgroundSpeed
        }
    }
}
"""
    }
    
    static func dependencies(_ mainData: MainData) -> ANDData {
        return ANDData(mainFragmentData: ANDMainFragment(imports: "", content: """
    SpaceAttackerGame()
"""), mainActivityData: ANDMainActivity(imports: "", extraFunc: "", content: ""), themesData: ANDThemesData(isDefault: true, content: ""), stringsData: ANDStringsData(additional: """
    <string name="restart_button_text">Restart</string>
    <string name="start_button_text">Start</string>
    <string name="result_text">Game Over\\nScore: %1$d</string>
    <string name="max_score_text">Your max score: %1$d</string>
    <string name="heart_image_desc">heart</string>
    <string name="shoot_button_text">Shoot</string>
    <string name="background_image_desc">Shoot</string>
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
