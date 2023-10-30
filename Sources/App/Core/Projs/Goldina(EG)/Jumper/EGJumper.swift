//
//  File.swift
//  
//
//  Created by admin on 30.10.2023.
//

import Foundation

struct EGJumper: FileProviderProtocol {
    static var fileName: String = "\(NamesManager.shared.fileName).kt"
    
    static func fileContent(packageName: String, uiSettings: UISettings) -> String {
        return """
package \(packageName).presentation.fragments.main_fragment

import android.content.res.Resources
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.graphics.Paint
import android.graphics.Rect
import android.view.MotionEvent
import androidx.annotation.DrawableRes
import androidx.compose.foundation.Canvas
import androidx.compose.foundation.Image
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.LinearProgressIndicator
import androidx.compose.material3.Button
import androidx.compose.material3.ButtonDefaults
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.material3.Typography
import androidx.compose.material3.lightColorScheme
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.ui.Alignment
import androidx.compose.ui.ExperimentalComposeUiApi
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.geometry.Offset
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.ImageBitmap
import androidx.compose.ui.graphics.asImageBitmap
import androidx.compose.ui.graphics.drawscope.DrawScope
import androidx.compose.ui.graphics.drawscope.drawIntoCanvas
import androidx.compose.ui.graphics.nativeCanvas
import androidx.compose.ui.graphics.toArgb
import androidx.compose.ui.input.pointer.pointerInteropFilter
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.TextStyle
import androidx.compose.ui.text.font.FontFamily
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.hilt.navigation.compose.hiltViewModel
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import androidx.navigation.NavHostController
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import androidx.navigation.compose.rememberNavController
import \(packageName).R
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.Job
import kotlinx.coroutines.SupervisorJob
import kotlinx.coroutines.delay
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.launch
import javax.inject.Inject
import kotlin.random.Random

val primaryColor = Color(0xFF\(uiSettings.primaryColor ?? "FFFFFF"))
val textColorPrimary = Color(0xFF\(uiSettings.textColorPrimary ?? "FFFFFF"))
val buttonTextColorPrimary = Color(0xFF\(uiSettings.buttonTextColorPrimary ?? "FFFFFF"))
val surfaceColor = Color(0xFF\(uiSettings.surfaceColor ?? "FFFFFF"))

private val LightColorPalette = lightColorScheme(
    primary = primaryColor,
)
@Composable
fun JumperTheme(
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
        fontFamily = FontFamily.Monospace,
        fontWeight = FontWeight.W600,
        fontSize = 15.sp,
        lineHeight = 15.sp,
        letterSpacing = 0.4.sp,
    ),
)

sealed class Screens(val route: String) {
    object MainScreen : Screens(route = "main_screen")
    object GameScreen : Screens(route = "game_screen")
}

@ExperimentalComposeUiApi
@Composable
fun Navigation(viewModel: GameViewModel = hiltViewModel()) {
    val navController = rememberNavController()

    NavHost(navController = navController, startDestination = Screens.MainScreen.route) {

        composable(route = Screens.MainScreen.route) {
            MainScreen(navController)
        }

        composable(route = Screens.GameScreen.route)
        {
            GameScreen(viewModel.state.collectAsState().value,viewModel::initGame)
        }

    }
}

@ExperimentalComposeUiApi
@Composable
fun GameScene(
    block: List<Asteroid>,
    player: Player,
    score: Long,
    background: Background
){
    val textPaint = remember {
        Paint().apply {
            color = textColorPrimary.toArgb()
            textSize = 100f
            textAlign = Paint.Align.CENTER
        }
    }
    Canvas(
        modifier = Modifier
            .fillMaxSize()
            .pointerInteropFilter { event ->
                when (event.action) {
                    MotionEvent.ACTION_DOWN -> {
                        player.startMoving(event.x > BitmapsHandler.screenWidth / 2)
                    }

                    MotionEvent.ACTION_UP -> {
                        player.stopMoving()
                    }
                }
                true
            }
    ) {
        drawBackground(background)
        drawBlock(block)
        drawPlayer(player)
        drawIntoCanvas { canvas ->
            canvas.nativeCanvas.drawText(
                score.toString(),
                100f,
                180f,
                textPaint
            )
        }
    }
    Text(text = score.toString())
}

@Composable
fun GameOverDialog(
    onRestart: () -> Unit,
    score: Long
) {
    BackgroundStatic()
    Column(
        modifier = Modifier
            .clip(shape = RoundedCornerShape(10))
            .background(surfaceColor)
            .padding(20.dp),
        horizontalAlignment = Alignment.CenterHorizontally,
        verticalArrangement = Arrangement.Center
    ) {
        androidx.compose.material.Text(
            text = stringResource(R.string.game_over, score),
            color = primaryColor,
            style = MaterialTheme.typography.displayLarge,
            modifier = Modifier.padding(bottom = 24.dp)
        )
        CustomButton(onRestart)
    }
}

@Composable
fun CustomButton( onClick: () -> Unit) {
    Button(
        modifier = Modifier
            .clip(RoundedCornerShape(16.dp))
            .fillMaxWidth(0.8f),
        onClick = onClick,
        colors = ButtonDefaults.buttonColors(
            containerColor = primaryColor,
            contentColor = buttonTextColorPrimary
        )
    ) {
        Text(
            text = stringResource(R.string.btn_play),
            style = MaterialTheme.typography.displayMedium
        )
    }
}

@Composable
fun BackgroundStatic() {
    val res = LocalContext.current.resources
    val back by remember {
        mutableStateOf(
            Bitmap.createScaledBitmap(
                BitmapFactory.decodeResource(
                    res,
                    R.drawable.back
                ),
                BitmapsHandler.screenWidth,
                BitmapsHandler.screenHeight,
                false
            ).asImageBitmap()
        )
    }

    Image(
        modifier = Modifier.fillMaxSize(),
        bitmap = back,
        contentDescription = null,
        contentScale = ContentScale.FillHeight,
        alignment = Alignment.TopStart
    )
}
data class UiGameState(
    var score: Long = 0,
    val player: Player,
    val asteroids: List<Asteroid>,
    val background: Background,
    val gameState: GameState = GameState.Loading,
) {
    sealed interface GameState {
        object Running : GameState
        object Loading : GameState
        object Finished : GameState
    }
}

@ExperimentalComposeUiApi
@Composable
fun MainScreen(
    navController: NavHostController
) {
    val context = LocalContext.current
    LaunchedEffect(key1 = Unit) {
        BitmapsHandler(context.resources)
    }

    Box(modifier = Modifier.fillMaxSize()) {
        BackgroundStatic()
        Column(
            modifier = Modifier.fillMaxSize(),
            horizontalAlignment = Alignment.CenterHorizontally,
            verticalArrangement = Arrangement.spacedBy(80.dp, Alignment.CenterVertically)
        ) {
            Text(
                text = stringResource(id = R.string.app_name),
                color = primaryColor,
                style = MaterialTheme.typography.displayLarge
            )
            CustomButton { navController.navigate(Screens.GameScreen.route) }
        }
    }
}

@HiltViewModel
class GameViewModel @Inject constructor(
) : ViewModel() {
    private var job: Job? = null

    private var startTime: Long = 0
    private var frameTime: Long = 0
    private val neededFrameTime: Int = (1000.0 / 60.0).toInt()
    private var startBlockPosY:Float = BitmapsHandler.screenHeight -200f

    private val _state = MutableStateFlow(
        UiGameState(
            player = Player(),
            asteroids = listOf(),
            background = Background()
        )
    )
    val state = _state.asStateFlow()

    private fun play() {
        if (job?.isActive != true) {
            job = viewModelScope.launch(Dispatchers.Default + SupervisorJob()) {
                drawGameObjects()
                _state.value = _state.value.copy(gameState = UiGameState.GameState.Running)

                while (_state.value.gameState is UiGameState.GameState.Running) {
                    startTime = System.currentTimeMillis()
                    moveBlock()
                    moveBackground()
                    hasLanding()
                    _state.value = _state.value.copy(
                        score = _state.value.score+1,
                        gameState = if(movePlayer()) UiGameState.GameState.Running else UiGameState.GameState.Finished
                    )

                    frameTime = System.currentTimeMillis() - startTime
                    if (frameTime < neededFrameTime) {
                        delay(neededFrameTime - frameTime)
                    }
                }
            }
        }
    }

    fun initGame() = with(_state.value) {
        _state.value = copy(
            background = background.apply {
                initialize()
            },
            player = player.apply {
                initialize()
            },
            score = 0
        )
        repeat(8) {
            spawnBlock()
        }
        play()
    }

    private fun drawGameObjects() = with(_state.value) {
        player.setRect()
        asteroids.forEach{
            it.setRect()
        }
        background.background.forEach{
            it.setRect()
        }
    }

    private fun moveBlock() = with(_state.value){
        asteroids.forEach {
            if(it.frame()) {
                _state.value =  copy(
                    asteroids = asteroids.toMutableList().apply {
                        remove(it)
                    })
                spawnBlock()
            }
        }
    }

    private fun movePlayer() : Boolean{
        return !_state.value.player.frame()
    }

    private fun moveBackground() {
        _state.value.background.frame()
    }

    private fun spawnBlock() = with(_state.value) {
        _state.value = copy(
            asteroids = asteroids.toMutableList().apply {
                add(
                    Asteroid().apply {
                        startBlockPosY = initialize(startBlockPosY)
                    }
                )
            }
        )
    }

    private fun hasLanding()= with(_state.value){
        asteroids.forEach{ block ->
            if ( player.hasLanding(block)){
                player.jump()
            }
        }
    }
}

@ExperimentalComposeUiApi
@Composable
fun GameScreen(
    state: UiGameState,
    onStart: () -> Unit,
) {
    LaunchedEffect(key1 = Unit) {
        launch(Dispatchers.Default) { onStart() }
    }

    Box(
        modifier = Modifier.fillMaxSize(),
        contentAlignment = Alignment.Center
    ) {
        when (state.gameState) {
            is UiGameState.GameState.Loading -> {
                LinearProgressIndicator(color = primaryColor)
            }
            is UiGameState.GameState.Running -> {
               GameScene(
                    block = state.asteroids,
                    player = state.player,
                    score = state.score,
                    background = state.background
                )
            }
            is UiGameState.GameState.Finished -> {
               GameOverDialog(
                    onRestart = onStart,
                    score = state.score
                )
            }
        }
    }
}

class Player : GameObject() {
    private var isGoingUp: Boolean = true
    private val velocityUnit = 5
    private var isMoving: Boolean = false
    private var directionRight: Boolean = true
    private val maxUpVelocity = velocityUnit * 8
    private val maxDownVelocity = velocityUnit * -8
    private var upVelocity = 0
    private var currentPosYOffset = BitmapsHandler.screenHeight.toFloat()

    fun initialize() {
        bitmap = BitmapsHandler.player
        bitmap?.let { bitmap ->
            width = bitmap.width
            height = bitmap.height
        }
        x = BitmapsHandler.screenWidth / 2 - width / 2f
        y = BitmapsHandler.screenHeight - height.toFloat()
        currentPosYOffset = y
        speed = 16f
        isGoingUp = true
        upVelocity = 0
        setRect()
    }

    fun frame(): Boolean {
        movePosY()
        movePosX(directionRight)
        setRect()
        return hasFall()
    }

    private fun movePosX(directionRight: Boolean) {
        if (isMoving) {
            if (directionRight) {
                if (x < BitmapsHandler.screenWidth - width)
                    x += speed
            } else {
                if (x > 0)
                    x -= speed
            }
        }
    }

    private fun movePosY() {
        if (isGoingUp) {
            if (upVelocity > maxUpVelocity) {
                isGoingUp = false
            } else {
                upVelocity += velocityUnit
            }
        } else {
            upVelocity -= velocityUnit
            if (upVelocity < maxDownVelocity) {
                upVelocity = maxDownVelocity
            }
        }
        currentPosYOffset -= upVelocity
        y = currentPosYOffset
    }

    fun startMoving(directionRight: Boolean) {
        this.directionRight = directionRight
        isMoving = true
    }

    fun stopMoving() {
        isMoving = false
    }

    fun jump() {
        isGoingUp = true
        upVelocity = 0
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

    open fun hasFall() = rect.bottom > BitmapsHandler.screenHeight + height

    open fun hasLanding(gameObject: GameObject): Boolean {
        val newRect = Rect(rect.left, rect.bottom - gameObject.height, rect.right, rect.bottom)
        return newRect.intersect(gameObject.rect)
    }

    fun getRandomWidth(bound: Int) =
        Random.nextInt(bound, BitmapsHandler.screenWidth)

    fun getRandomHeight(maxDifference: Float, minDifference: Float) =
        Random.nextFloat() * (maxDifference - minDifference) + minDifference
}
class Background {
    val background =
        listOf(BackgroundItem(0f), BackgroundItem(-BitmapsHandler.insetScreenHeight.toFloat()))

    fun initialize() {
        background.forEach { background ->
            background.initialize()
        }
    }

    fun frame() {
        background.forEach { background ->
            background.y = (background.y + background.speed) % BitmapsHandler.insetScreenHeight
            background.increaseSpeed()
        }
    }

    class BackgroundItem(val offset: Float) : GameObject() {

        fun initialize() {
            bitmap = BitmapsHandler.background
            bitmap?.let { bitmap ->
                width = bitmap.width
                height = bitmap.height
            }
            speed = 10f
        }

        fun increaseSpeed() {
            speed += 0.001f
        }

    }
}

class Asteroid : GameObject() {
    private val minDifference = 60f
    private val maxDifference = 70f

    fun initialize(startPosY: Float): Float {
        bitmap = BitmapsHandler.asteroid
        bitmap?.let { bitmap ->
            width = bitmap.width
            height = bitmap.height
        }
        y = -1 * getRandomHeight(maxDifference, minDifference)
        y += startPosY
        x = getRandomWidth(width) - width.toFloat()
        speed = 15f
        setRect()
        return y
    }

    fun frame(): Boolean {
        y += speed
        setRect()
        return isOutOfBound()
    }

    private fun isOutOfBound() = y > BitmapsHandler.insetScreenHeight
}

class BitmapsHandler(private val resources: Resources) {

    init {

        val backgroundWidth = resizeWidth(screenWidth)
        val backgroundHeight = insetScreenHeight + 10

        val playerWidth = resizeWidth(181)
        val playerHeight = resizeHeight(181)
        val enemyWidth = resizeWidth(200)
        val enemyHeight = resizeHeight(40)

        background = initBitmap(
            R.drawable.back,
            backgroundWidth,
            backgroundHeight,
        )

        player = initBitmap(
            R.drawable.player,
            playerWidth,
            playerHeight
        )

        asteroid = initBitmap(
            R.drawable.platform,
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
        var asteroid: ImageBitmap? = null
        var background: ImageBitmap? = null

        val screenWidth = Resources.getSystem().displayMetrics.widthPixels
        val screenHeight = Resources.getSystem().displayMetrics.heightPixels

        var insetScreenHeight: Int = 0

        private const val INIT_WIDTH = 1080
        private const val INIT_HEIGHT = 2040

        private fun resizeWidth(size: Int) = screenWidth * size / INIT_WIDTH
        fun resizeHeight(size: Int) = insetScreenHeight * size / INIT_HEIGHT
    }
}

fun DrawScope.drawPlayer(player: Player) =
    player.bitmap?.let {
        drawImage(it, Offset(player.x, player.y))
    }

fun DrawScope.drawBlock(blocks: List<Asteroid>) = blocks.forEach { block ->
    block.bitmap?.let { drawImage(it, Offset(block.x, block.y)) }
}

fun DrawScope.drawBackground(background: Background) = background.background.forEach { back ->
    back.bitmap?.let { drawImage(it, Offset(0f, back.y + back.offset)) }
}
"""
    }
    
    static func dependencies(_ mainData: MainData) -> ANDData {
        return ANDData(
            mainFragmentData: ANDMainFragment(
                imports: """
import androidx.compose.ui.ExperimentalComposeUiApi
""",
                content: """
    JumperTheme {
        Navigation()
    }
""",
                mainScreenAnnotation: """
@OptIn(ExperimentalComposeUiApi::class)
"""
            ),
            mainActivityData: ANDMainActivity(
                imports: """
import android.graphics.Rect
import android.os.Build
import androidx.core.view.WindowCompat
import androidx.core.view.WindowInsetsCompat
import \(mainData.packageName).presentation.fragments.main_fragment.BitmapsHandler.Companion.insetScreenHeight
import \(mainData.packageName).presentation.fragments.main_fragment.BitmapsHandler.Companion.screenHeight
""",
                extraFunc: """
        initInset()
""",
                content: """
    private fun initInset() {
        WindowCompat.setDecorFitsSystemWindows(window, false)

        val statusBarHeight: Int
        val navigationBarHeight: Int

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
            val insets = windowManager.currentWindowMetrics.windowInsets
            statusBarHeight = insets.getInsets(WindowInsetsCompat.Type.statusBars()).top
            navigationBarHeight =
                insets.getInsets(WindowInsetsCompat.Type.navigationBars()).bottom
        } else {
            val rect = Rect()
            window.decorView.getWindowVisibleDisplayFrame(rect)

            statusBarHeight = rect.top
            navigationBarHeight = screenHeight - rect.top - rect.height()
        }

        insetScreenHeight = screenHeight + statusBarHeight + navigationBarHeight
    }
"""
            ),
            themesData: .def,
            stringsData: ANDStringsData(
                additional: """
    <string name="btn_play">Play</string>
    <string name="game_over">Your score: %d</string>
"""
            ),
            colorsData: .empty
        )
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
