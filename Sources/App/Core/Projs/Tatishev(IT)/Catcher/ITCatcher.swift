//
//  File.swift
//  
//
//  Created by admin on 23.10.2023.
//

import Foundation

struct ITCatcher: FileProviderProtocol {
    static var fileName: String = "\(NamesManager.shared.fileName).kt"
    
    static func fileContent(packageName: String, uiSettings: UISettings) -> String {
        return """
package \(packageName).presentation.fragments.main_fragment

import android.content.Context
import android.content.ContextWrapper
import android.content.res.Resources
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.graphics.Rect
import android.os.Build
import android.view.MotionEvent
import androidx.annotation.DrawableRes
import androidx.appcompat.app.AppCompatActivity
import androidx.compose.foundation.Canvas
import androidx.compose.foundation.isSystemInDarkTheme
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.navigationBarsPadding
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.Button
import androidx.compose.material3.ButtonDefaults
import androidx.compose.material3.LinearProgressIndicator
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.collectAsState
import androidx.compose.ui.Alignment
import androidx.compose.ui.ExperimentalComposeUiApi
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.geometry.Offset
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.ImageBitmap
import androidx.compose.ui.graphics.asImageBitmap
import androidx.compose.ui.input.pointer.pointerInteropFilter
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.TextStyle
import androidx.compose.ui.text.font.FontFamily
import androidx.compose.ui.text.font.FontStyle
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.hilt.navigation.compose.hiltViewModel
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import \(packageName).R
import \(packageName).presentation.fragments.main_fragment.Bitmaps.screenHeight
import \(packageName).presentation.fragments.main_fragment.Bitmaps.screenWidth
import \(packageName).presentation.fragments.main_fragment.destinations.GameScreenDestination
import com.ramcosta.composedestinations.annotation.Destination
import com.ramcosta.composedestinations.annotation.RootNavGraph
import com.ramcosta.composedestinations.navigation.DestinationsNavigator
import com.ramcosta.composedestinations.navigation.popUpTo
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

val backColorPrimary = Color(0xFF\(uiSettings.backColorPrimary ?? "FFFFFF"))
val buttonColorPrimary = Color(0xFF\(uiSettings.buttonColorPrimary ?? "FFFFFF"))
val buttonTextColorPrimary = Color(0xFF\(uiSettings.buttonTextColorPrimary ?? "FFFFFF"))
val textColorPrimary = Color(0xFF\(uiSettings.textColorPrimary ?? "FFFFFF"))

@Destination
@Composable
fun GameScreen(
    gameViewModel: GameViewModel = hiltViewModel(),
    navigator: DestinationsNavigator
) {
    val state = gameViewModel.state.collectAsState()

    val context = LocalContext.current

    LaunchedEffect(key1 = Unit) {
        gameViewModel.setRes(context.resources)
        gameViewModel.play()
    }

    if (!state.value.isLoading) {
        if (state.value.isRunning) {
            GameCanvas(
                viewModel = gameViewModel,
            )
        } else {
            ScoreScreen(
                score = state.value.score,
                onRestart = {
                    navigator.navigate(GameScreenDestination) {
                        popUpTo(GameScreenDestination) { inclusive = true }
                    }
                }
            )
        }
    } else {
        LoadingScreen()
    }
}

@OptIn(ExperimentalComposeUiApi::class)
@Composable
fun GameCanvas(
    viewModel: GameViewModel
) {
    val state = viewModel.state.collectAsState()

    Box(modifier = Modifier.fillMaxSize()) {
        Canvas(
            modifier = Modifier
                .fillMaxSize()
                .pointerInteropFilter { event ->
                    when (event.action) {
                        MotionEvent.ACTION_DOWN -> {
                            viewModel.moveCart(event.x)
                            true
                        }

                        MotionEvent.ACTION_MOVE -> {
                            viewModel.moveCart(event.x)
                            true
                        }

                        else -> false
                    }
                },
        ) {
            state.value.background.bitmap?.let { drawImage(it, Offset(0f, 0f)) }
            state.value.balls.forEach { ball ->
                ball.bitmap?.let { drawImage(it, Offset(ball.x, ball.y)) }
            }
            state.value.basket.bitmap?.let { drawImage(it, Offset(state.value.basket.x, state.value.basket.y)) }
        }
        Text(
            text = stringResource(R.string.score, state.value.score),
            fontStyle = FontStyle.Italic,
            color = textColorPrimary,
            fontSize = 22.sp,
            modifier = Modifier
                .navigationBarsPadding()
                .align(Alignment.TopEnd)
                .padding(top = 32.dp, end = 16.dp)
        )

        Text(
            text = stringResource(R.string.attempts_remaining, state.value.attempts),
            fontStyle = FontStyle.Italic,
            color = textColorPrimary,
            fontSize = 18.sp,
            modifier = Modifier
                .navigationBarsPadding()
                .align(Alignment.TopStart)
                .padding(top = 32.dp, start = 16.dp)
        )
    }
}

@Composable
fun LoadingScreen() {
    Column(
        modifier = Modifier.fillMaxSize(),
        verticalArrangement = Arrangement.Center,
        horizontalAlignment = Alignment.CenterHorizontally
    ) {
        LinearProgressIndicator(color = buttonColorPrimary)
        Spacer(modifier = Modifier.height(10.dp))
        Text(
            text = stringResource(R.string.loading),
            style = TextStyle(
                color = textColorPrimary,
                fontSize = 24.sp
            )
        )
    }
}

@Composable
fun MenuButton(text: String, onClickAction: () -> Unit) {
    Button(
        modifier = Modifier
            .clip(RoundedCornerShape(16.dp))
            .fillMaxWidth(0.8f),
        onClick = onClickAction,
        colors = ButtonDefaults.buttonColors(containerColor = buttonColorPrimary)
    ) {
        androidx.compose.material.Text(text = text, fontSize = 40.sp, color = buttonTextColorPrimary)
    }
}

@Composable
fun ScoreScreen(score: Long, onRestart: () -> Unit) {
    Column(
        modifier = Modifier.fillMaxSize(),
        horizontalAlignment = Alignment.CenterHorizontally,
        verticalArrangement = Arrangement.Center
    ) {
        Text(
            text = stringResource(R.string.score, score),
            color = textColorPrimary,
            fontSize = 40.sp,
            textAlign = TextAlign.Center,
            modifier = Modifier.padding(bottom = 24.dp)
        )
        MenuButton(stringResource(R.string.restart)) {
            onRestart()
        }
    }
}

@RootNavGraph(start = true)
@Destination
@Composable
fun MenuScreen(navigator: DestinationsNavigator) {
    Column(
        modifier = Modifier.fillMaxSize(),
        horizontalAlignment = Alignment.CenterHorizontally,
        verticalArrangement = Arrangement.Center
    ) {
        MenuButton(text = stringResource(id = R.string.play)) {
            navigator.navigate(GameScreenDestination())
        }
        Spacer(modifier = Modifier.height(30.dp))

        val context = LocalContext.current
        MenuButton(text = stringResource(id = R.string.exit)) {
            context.findActivity()?.finishAndRemoveTask()
        }
    }
}

object Bitmaps {

    var res: Resources? = null
    var basket: ImageBitmap? = null
    var ball: ImageBitmap? = null
    var background: ImageBitmap? = null

    fun initialize(resources: Resources) {
        res = resources

        val cartWidth = resizeWidth(200)
        val cartHeight = resizeHeight(200)

        val appleWidth = resizeWidth(120)
        val appleHeight = resizeWidth(120)

        val backgroundWidth = resizeWidth(screenWidth)
        val backgroundHeight = resizeHeight(screenHeight)

        background = initBitmap(
            R.drawable.court,
            backgroundWidth,
            backgroundHeight,
        )
        basket = initBitmap(R.drawable.basket, cartWidth, cartHeight)
        ball = initBitmap(R.drawable.basketball, appleWidth, appleHeight)

    }

    private fun initBitmap(
        @DrawableRes res: Int,
        width: Int,
        height: Int
    ): ImageBitmap {
        return Bitmap.createScaledBitmap(
            BitmapFactory.decodeResource(Bitmaps.res, res),
            width,
            height,
            false
        ).asImageBitmap()
    }

    val screenWidth = Resources.getSystem().displayMetrics.widthPixels
    val screenHeight = Resources.getSystem().displayMetrics.heightPixels

    var insetScreenHeight: Int = 0

    private const val INIT_WIDTH = 1080
    private const val INIT_HEIGHT = 2040

    private fun resizeWidth(size: Int) = screenWidth * size / INIT_WIDTH
    private fun resizeHeight(size: Int) = insetScreenHeight * size / INIT_HEIGHT
}

fun Rect.intersects(rect: Rect): Boolean {
    return intersects(rect.left, rect.top, rect.right, rect.bottom)
}

class Background : GameObject() {
    fun initialize() {
        bitmap = Bitmaps.background
        width = bitmap?.width ?: 0
        height = bitmap?.height ?: 0
    }
}

class Ball : GameObject() {

    fun initialize(){
        bitmap = Bitmaps.ball
        width = bitmap?.width ?: 0
        height = bitmap?.height ?: 0
        x = getRandom(screenWidth - width).toFloat()
        y = 0 - height.toFloat() - getRandom(screenHeight * 10)
        speed = 20f
    }

    fun isOutOfBounds() = y > screenHeight
}

class Basket : GameObject() {

    fun initialize() {
        bitmap = Bitmaps.basket
        width = bitmap?.width ?: 0
        height = bitmap?.height ?: 0
        x = screenWidth / 2f - width / 2f
        y = screenHeight - height * 1.5f
        setRect()
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

    fun getRandom(bound: Int) = Random.nextInt(0, bound)
}

fun Context.findActivity(): AppCompatActivity? = when (this) {
    is AppCompatActivity -> this
    is ContextWrapper -> baseContext.findActivity()
    else -> null
}

@HiltViewModel
class GameViewModel
@Inject constructor() : ViewModel() {

    private var resources: Resources? = null

    private var job: Job? = null

    private var startTime: Long = 0
    private var frameTime: Long = 0
    private val neededFrameTime: Int = (1000.0 / 60.0).toInt()

    private val _state = MutableStateFlow(GameState())
    val state = _state.asStateFlow()

    private var running: Boolean = true
    private var currentScore: Long = 0


    fun setRes(res: Resources){
        resources = res
    }

    fun play() {
        if (job?.isActive != true) {
            job = viewModelScope.launch(Dispatchers.Default + SupervisorJob()) {

                initialize()
                initializeObjects()

                _state.value = _state.value.copy(isLoading = false)

                while (running) {
                    startTime = System.currentTimeMillis()

                    moveballDown()
                    checkCollision()
                    checkballOutOfBounds()

                    _state.value = _state.value.copy(
                        score = currentScore,
                        time = System.currentTimeMillis(),
                        isRunning = running
                    )

                    frameTime = System.currentTimeMillis() - startTime
                    if (frameTime < neededFrameTime) {
                        delay(neededFrameTime - frameTime)
                    }
                }
            }
        }
    }


    private fun initialize(){
        resources?.let { Bitmaps.initialize(resources = it) }
        play()
    }

    private fun initializeObjects() = with(_state.value) {
        _state.value = _state.value.copy(
            basket = basket.also { cart -> cart.initialize() },
            background = background.also { background -> background.initialize() },
        )
        spawnballs()
    }

    private fun spawnballs() = with(_state.value) {
        val ballsFilled = mutableListOf<Ball>()
        repeat(7) {
            val ball = Ball().also { it.initialize() }
            ballsFilled += ball
        }
        _state.value = _state.value.copy(
            balls = ballsFilled.toList()
        )
    }

    private fun moveballDown() = with(_state.value) {
        balls.forEach { ball ->
            balls[balls.indexOf(ball)].y += ball.speed
            balls[balls.indexOf(ball)].setRect()
            _state.value = _state.value.copy(
                balls = balls
            )
        }
    }

    private fun checkCollision() = with(_state.value) {
        balls.forEach { ball ->
            if (basket.hasCollision(ball)) {
                currentScore++
                moveballRandomAndIncreaseSpeed(ball)
            }
        }
    }

    private fun checkballOutOfBounds() = with(_state.value) {
        balls.forEach { ball ->
            if (ball.isOutOfBounds()) {
                val attemptsRemaining = _state.value.attempts - 1
                _state.value = _state.value.copy(
                    attempts = attemptsRemaining
                )
                moveballRandom(ball)
                if (attemptsRemaining <= 0) {
                    running = false
                    job?.cancel()
                }
            }
        }
    }

    private fun moveballRandom(ball: Ball) = with(_state.value){
        balls[balls.indexOf(ball)].y = 0f - ball.height - ball.getRandom(screenHeight * 3)
        balls[balls.indexOf(ball)].x = ball.getRandom(screenWidth - ball.width).toFloat()
        _state.value = _state.value.copy(
            balls = balls
        )
    }

    private fun moveballRandomAndIncreaseSpeed(ball: Ball) = with(_state.value){
        balls[balls.indexOf(ball)].y = 0f - ball.height - ball.getRandom(screenHeight * 3)
        balls[balls.indexOf(ball)].x = ball.getRandom(screenWidth - ball.width).toFloat()
        balls[balls.indexOf(ball)].speed += 0.15f
        _state.value = _state.value.copy(
            balls = balls
        )
    }

    fun moveCart(posX: Float) = with(_state.value){
        _state.value = _state.value.copy(
            basket = basket.also { cart ->
                cart.x = posX - cart.width / 2
                cart.setRect()
            }
        )
    }
}

data class GameState(
    val score: Long = 0,
    val basket: Basket = Basket(),
    val balls: List<Ball> = listOf(),
    val background: Background = Background(),
    val isLoading: Boolean = true,
    val isRunning: Boolean = true,
    val time: Long = System.currentTimeMillis(),
    val attempts: Int = 3
)

"""
    }
    
    static func dependencies(_ mainData: MainData) -> ANDData {
        return ANDData(mainFragmentData: ANDMainFragment(imports: """
import androidx.compose.material3.Surface
import com.ramcosta.composedestinations.DestinationsNavHost
""", content: """
                Surface(color = backColorPrimary) {
                    DestinationsNavHost(navGraph = NavGraphs.root)
                }
"""), mainActivityData: ANDMainActivity(imports: """
import \(mainData.packageName).presentation.fragments.main_fragment.Bitmaps.insetScreenHeight
import \(mainData.packageName).presentation.fragments.main_fragment.Bitmaps.screenHeight
import androidx.core.view.WindowCompat
import androidx.core.view.WindowInsetsCompat
import android.graphics.Rect
import android.os.Build
"""
, extraFunc: """
        initInset()
""", content: """
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
"""), themesData: ANDThemesData(isDefault: true, content: ""), stringsData: ANDStringsData(additional: """
    <string name="play">Play</string>
    <string name="exit">Exit</string>
    <string name="restart">Restart</string>
    <string name="attempts_remaining">"Misses: %d"</string>
    <string name="score">"Score: %d"</string>
    <string name="loading">Loading…</string>
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
import org.apache.tools.ant.taskdefs.optional.depend.Depend

plugins {
    id("com.google.devtools.ksp") version "1.8.10-1.0.9"
}

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

    ksp Dependencies.kspdestinations
    implementation Dependencies.destinations
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

    const val destinations = "1.8.42-beta"
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

    const val destinations = "io.github.raamcosta.compose-destinations:core:${Versions.destinations}"
    const val kspdestinations = "io.github.raamcosta.compose-destinations:ksp:${Versions.destinations}"
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
