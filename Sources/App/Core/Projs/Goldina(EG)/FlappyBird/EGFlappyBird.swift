//
//  File.swift
//  
//
//  Created by admin on 27.10.2023.
//

import Foundation

struct EGFlappyBird: FileProviderProtocol {
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
import androidx.compose.animation.core.Animatable
import androidx.compose.animation.core.LinearEasing
import androidx.compose.animation.core.RepeatMode
import androidx.compose.animation.core.infiniteRepeatable
import androidx.compose.animation.core.tween
import androidx.compose.foundation.Canvas
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.material3.Text
import androidx.compose.material3.TextButton
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.MutableState
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.ui.ExperimentalComposeUiApi
import androidx.compose.ui.Modifier
import androidx.compose.ui.geometry.Offset
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.ImageBitmap
import androidx.compose.ui.graphics.asImageBitmap
import androidx.compose.ui.graphics.drawscope.DrawScope
import androidx.compose.ui.graphics.drawscope.withTransform
import androidx.compose.ui.input.pointer.pointerInteropFilter
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.hilt.navigation.compose.hiltViewModel
import androidx.lifecycle.ViewModel
import \(packageName).R
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.asStateFlow
import javax.inject.Inject

val textColorPrimary = Color(0xFF\(uiSettings.textColorPrimary ?? "FFFFFF"))

@ExperimentalComposeUiApi
@Composable
fun BirdMainScreen(viewModel: GameViewModel = hiltViewModel()) {
    val context = LocalContext.current
    LaunchedEffect(key1 = Unit) {
        BitmapsHandler(context.resources)
        viewModel.initGame()
    }
    GameScreen()
    Text(
        modifier = Modifier.fillMaxWidth().padding(top =20.dp),
        fontSize = 48.sp,
        text = viewModel.gameScore.collectAsState().value.toString(),
        textAlign = TextAlign.Center,
        color = textColorPrimary
    )
    Toggle(modifier = Modifier.fillMaxSize(), onToggle = {
        if (it) {
            viewModel.changeGameState(GameState.Status.RUNNING)
        } else
            viewModel.changeGameState(GameState.Status.STOPPED)
    })
}

@Composable
fun Toggle(
    modifier: Modifier = Modifier,
    onToggle: (Boolean) -> Unit,
    viewModel: GameViewModel = hiltViewModel()
) {
    val toggleState: MutableState<Boolean> = remember{ mutableStateOf(false) }
    val status  = viewModel.gameState.collectAsState().value
    if (status.isFinished()) {
        TextButton(modifier = modifier, onClick = {
            toggleState.value = !status.isRunning()
            onToggle(toggleState.value)
        }) {
            Text(
                fontSize = 32.sp,
                text = stringResource(R.string.btn_start),
                color = textColorPrimary
            )
        }
    }
}

@ExperimentalComposeUiApi
@Composable
fun GameScreen(
    viewModel: GameViewModel = hiltViewModel()
){
    viewModel.initGame()
    val gameState = viewModel.gameState.collectAsState().value
    val enabled = remember { mutableStateOf(true) }
    val animatedFloat = remember {
        Animatable(0f)
    }

    LaunchedEffect(enabled.value) {
        animatedFloat.snapTo(0f)
        animatedFloat.animateTo(
            targetValue = if (enabled.value) 1f else 0f,
            animationSpec = infiniteRepeatable(
                animation = tween(durationMillis = 250, easing = LinearEasing),
                repeatMode = RepeatMode.Restart
            ),
        )
    }

    Canvas(
        modifier = Modifier
            .fillMaxSize()
            .pointerInteropFilter {
                when (it.action) {
                    MotionEvent.ACTION_DOWN -> {
                        viewModel.makeJump()
                    }
                }
                true
            }
    ) {
        if (enabled.value  && gameState.isFinished()) {
            enabled.value = false
        } else if (!enabled.value  && gameState.isRunning()) {
            enabled.value=true
            viewModel.resetScore()
        }
        animatedFloat.value

        if (gameState.isRunning()) {
            viewModel.movingGameObject()
        }
        viewModel.drawGameObject(this)
        viewModel.checkFalling()
    }
}


data class GameState(
    private val status: Status = Status.STOPPED,
    val background: Background = Background(),
    val bird: Bird = Bird(),
    val pipePairs: PipePairs = PipePairs()
) {
    enum class Status {
        RUNNING,
        ENDING,
        STOPPED
    }

    fun isRunning() = status == Status.RUNNING
    fun isEnding() = status == Status.ENDING
    fun isFinished() = status == Status.STOPPED
}

@HiltViewModel
class GameViewModel @Inject constructor() : ViewModel() {
    private val _gameState = MutableStateFlow(GameState())
    val gameState = _gameState.asStateFlow()

    private val _gameScore = MutableStateFlow(0)
    val gameScore = _gameScore.asStateFlow()

    fun makeJump() {
        if (_gameState.value.isRunning()) {
            _gameState.value = _gameState.value.copy(
                bird = _gameState.value.bird.apply {
                    jump()
                }
            )
        }
    }

    fun changeGameState(status: GameState.Status) {
        _gameState.value = _gameState.value.copy(
            status = status
        )
    }

    fun resetScore() {
        _gameScore.value =0
    }

    private fun changeScore() = with(_gameState.value) {
        _gameScore.value = pipePairs.countCross
    }

    fun initGame() = with(_gameState.value) {
        _gameState.value = copy(
            background = background.apply {
                initialize()
            },
            bird = bird.apply {
                initialize()
            },
            pipePairs = pipePairs.apply {
                initialize()
            }
        )
    }

    fun movingGameObject() = with(_gameState.value) {
        _gameState.value = copy(
            background = background.apply {
                move()
            },
            bird = bird.apply {
                move()
            },
            pipePairs = pipePairs.apply {
                move()
            }
        )
    }

    private fun checkCollision(rectsPipe: List<Rect>, rectBird: Rect) = with(_gameState.value) {
        if (!background.rect.intersect(rectBird)) {
            gameOver()
        }
        rectsPipe.forEach {
            if (it.intersect(rectBird)) {
                gameOver()
            }
        }
    }

    private fun gameOver() = with(_gameState.value) {
        _gameState.value = copy(
            bird = bird.apply {
                dying()
            })
        changeGameState(GameState.Status.ENDING)
    }

    fun drawGameObject(drawScope: DrawScope) = with(_gameState.value) {
        var rectsPipe: List<Rect>
        var rectBird: Rect
        _gameState.value = copy(
            background = background.apply {
                drawScope.draw()
            },
            bird = bird.apply {
                rectBird = drawScope.draw(_gameState.value)
            },
            pipePairs = pipePairs.apply {
                rectsPipe = drawScope.draw()
            }
        )
        if (_gameState.value.isRunning()) {
            checkCollision(rectsPipe, rectBird)
            changeScore()
        }
    }

    fun checkFalling()= with(_gameState.value) {
        if(isEnding()){
            _gameState.value = copy(
                bird = bird.apply {
                    move()
                })
            if (bird.isOutOfBound()) {
                changeGameState(GameState.Status.STOPPED)
            }
        }
    }

}

class BitmapsHandler(private val resources: Resources) {

    init {

        val backgroundWidth = resizeWidth(screenWidth)
        val backgroundHeight = insetScreenHeight

        val playerWidth = resizeWidth(73*3)
        val playerHeight = resizeHeight(56*3)
        val enemyWidth = resizeWidth(40*4)
        val enemyHeight = resizeHeight(153*8)

        background = initBitmap(
            R.drawable.back,
            backgroundWidth,
            backgroundHeight,
        )

        bird = initBitmap(
            R.drawable.bird,
            playerWidth,
            playerHeight
        )

        pipeUp = initBitmap(
            R.drawable.pipe_up,
            enemyWidth,
            enemyHeight
        )

        pipeDown = initBitmap(
            R.drawable.pipe_down,
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
        var bird: ImageBitmap? = null
        var pipeUp: ImageBitmap? = null
        var pipeDown: ImageBitmap? = null
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

class PipePairs : GameObject() {
    private val halfGap = 400
    private val velocity = 6
    private val pipes: MutableList<Pipe> = mutableListOf()
    private var bitmapSecond: ImageBitmap? = null
    var countCross = 0

    fun initialize() {
        bitmap = BitmapsHandler.pipeUp
        bitmapSecond = BitmapsHandler.pipeDown
        bitmap?.let { bitmap ->
            width = bitmap.width
            height = bitmap.height
        }
        pipes.clear()
        pipes.add(Pipe(BitmapsHandler.screenWidth))
        pipes.add(Pipe((BitmapsHandler.screenWidth * 1.6).toInt()))
    }

    fun move() {
        pipes.forEach {
            it.move(velocity)
        }
    }
    fun DrawScope.draw(): List<Rect> {
        val rects: MutableList<Rect> = mutableListOf()

        pipes
            .filter { it.currentPosX < -width }
            .forEach { it.reset() }


        pipes.forEach { pipe ->

            x = pipe.currentPosX.toFloat()
            y = (pipe.holePos + halfGap - height).toFloat()
            bitmap?.let { bitmap ->
                drawImage(bitmap, Offset(x, y))
            }
            rects.add(Rect(x.toInt(), 0, (x + width).toInt(), (pipe.holePos + halfGap)))

            y = (BitmapsHandler.screenHeight - pipe.holePos - halfGap).toFloat()
            bitmapSecond?.let { bitmap ->
                drawImage(bitmap, Offset(x, y))
            }
            rects.add(Rect(x.toInt(), y.toInt(), (x + width).toInt(), BitmapsHandler.screenHeight))


            if (!pipe.crossHalfWay
                && pipe.currentPosX < (size.width - width) / 2
            ) {
                pipe.crossHalfWay = true
                countCross++
            }
        }

        return rects
    }
}

class Pipe(
    var currentPosX: Int
) {
    var crossHalfWay = false
    var holePos: Int = randomHolePos()

    fun move(velocity: Int) {
        currentPosX -= velocity
    }

    fun reset() {
        currentPosX = BitmapsHandler.screenWidth
        holePos = randomHolePos()
        crossHalfWay = false
    }

    private fun randomHolePos() = (100..350).random()
}

open class GameObject {
    var x = 0f
    var y = 0f
    var bitmap: ImageBitmap? = null
    var width = 0
    var height = 0
    var rect: Rect = Rect()

    open fun setRect() {
        rect.set(x.toInt(), y.toInt(), (x + width).toInt(), (y + height).toInt())
    }
    fun isOutOfBound() = y > BitmapsHandler.screenHeight
}

class Background : GameObject(){
    private var currentPosX = 0f
    fun initialize() {
        bitmap = BitmapsHandler.background
        bitmap?.let { bitmap ->
            width = bitmap.width
            height = bitmap.height
        }
        x=currentPosX
        setRect()
    }
    fun move() {
        currentPosX--
    }

    fun DrawScope.draw() {
        if (currentPosX < - size.width) {
            currentPosX = 0f
        }
        bitmap?.let { bitmap ->
            drawImage(bitmap, Offset(currentPosX, 0f))
            drawImage(bitmap, Offset(currentPosX + size.width, 0f))
        }
        setRect()
    }
}

class Bird : GameObject(){

    private val velocityUnit = 4
    private val maxUpVelocity = velocityUnit * 6
    private val maxDownVelocity = velocityUnit * -6
    private val fallDownVelocity = velocityUnit * -12
    private var isGoingUp = false
    private var currentPosYOffset = 0f
    private var upVelocity = 0
    fun initialize() {
        bitmap = BitmapsHandler.bird
        bitmap?.let { bitmap ->
            width = bitmap.width
            height = bitmap.height
        }
        isGoingUp = false
        currentPosYOffset = 0f
        upVelocity = 0
    }
    fun move() {
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
    }

    fun DrawScope.draw(gameState: GameState): Rect {
        currentPosYOffset += upVelocity


        val center = Offset(
            ((size.width / 2)- width/ 2),
            ((size.width / 2) - currentPosYOffset - width / 2)
        )

        val rotateCenter = Offset(
            (size.width / 2), (size.width / 2) - currentPosYOffset
        )

        val birdRotate = if (gameState.isEnding()) -90 else upVelocity

        withTransform({ rotate(-birdRotate.toFloat(), rotateCenter) }, {
            bitmap?.let { bitmap ->
                drawImage(bitmap, center)
            }
        }
        )
        x=center.x
        y=center.y
        setRect()
        return rect
    }

    fun jump() {
        isGoingUp = true
    }

    fun dying() {
        upVelocity = fallDownVelocity
    }
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
    BirdMainScreen()
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
            stringsData: ANDStringsData(additional: """
    <string name="btn_start">Click to Start</string>
"""),
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
