//
//  File.swift
//  
//
//  Created by admin on 30.06.2023.
//

import Foundation

struct MBSpaceFighter: FileProviderProtocol {
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
                dataBinding true
                viewBinding true
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
            implementation Dependencies.compose_system_ui_controller
            implementation Dependencies.compose_permissions
            implementation 'androidx.work:work-runtime-ktx:2.8.1'
            implementation 'androidx.navigation:navigation-fragment:2.6.0'
            
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
                    const val glide = "4.14.2"
                    const val swipe = "0.19.0"
                    const val glide_skydoves = "1.3.9"
                    const val retrofit = "2.9.0"
                    const val okhttp = "4.10.0"
                    const val room = "2.5.0"
                    const val coil = "2.2.2"
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
    static func dependencies(_ mainData: MainData) -> ANDData {
        return ANDData(
            mainFragmentData: ANDMainFragment(
                imports: "",
                content: """
            MBSpaseFighter()
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
            themesData: ANDThemesData(isDefault: true, content: ""),
            stringsData: ANDStringsData(additional: ""),
            colorsData: ANDColorsData(additional: "")
        )
    }
    
    static var fileName = "\(NamesManager.shared.fileName).kt"
    
    static func fileContent(
        packageName: String,
        uiSettings: UISettings
    ) -> String {
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
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.BoxScope
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.padding
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Pause
import androidx.compose.material.icons.filled.PlayArrow
import androidx.compose.material3.Button
import androidx.compose.material3.ButtonDefaults
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.IconButtonDefaults
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.ui.Alignment
import androidx.compose.ui.ExperimentalComposeUiApi
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.scale
import androidx.compose.ui.geometry.Offset
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.ImageBitmap
import androidx.compose.ui.graphics.asImageBitmap
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.compose.ui.input.pointer.pointerInteropFilter
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.Dp
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import androidx.lifecycle.viewmodel.compose.viewModel
import \(packageName).R
import \(packageName).presentation.fragments.main_fragment.BitmapsHandler.Companion.insetScreenHeight
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
import kotlin.random.Random

val textColorPrimary = Color(0xFF\(uiSettings.textColorPrimary ?? "FFFFFF"))
val buttonTextColorPrimary = Color(0xFF\(uiSettings.buttonTextColorPrimary ?? "FFFFFF"))
val buttonColorPrimary = Color(0xFF\(uiSettings.buttonColorPrimary ?? "FFFFFF"))


fun Rect.intersects(rect: Rect): Boolean {
    return intersects(rect.left, rect.top, rect.right, rect.bottom)
}

@Composable
fun MBSpaseFighter(appViewModel: AppViewModel = viewModel()) {
    val screenState = appViewModel.screenState.collectAsState()
    val context = LocalContext.current
    LaunchedEffect(key1 = Unit) {
        BitmapsHandler(context.resources)
    }
    when (screenState.value) {
        ScreenState.Running -> RunningScreen()
        ScreenState.MainMenu -> StartScreen()
        ScreenState.Paused -> RunningScreen()
        ScreenState.Lost -> LoseScreen()
    }
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

        fun resetSpeed() {
            speed = 20f
        }

    }
}

class BitmapsHandler(private val resources: Resources) {

    init {

        val backgroundWidth = resizeWidth(screenWidth)
        val backgroundHeight = insetScreenHeight + 10

        val playerWidth = resizeWidth(156)
        val playerHeight = resizeHeight(183)

        val enemyWidth = resizeWidth(201)
        val enemyHeight = resizeHeight(400)

        background = initBitmap(
            R.drawable.background,
            backgroundWidth,
            backgroundHeight,
        )

        player = initBitmap(
            R.drawable.player,
            playerWidth,
            playerHeight
        )

        enemyCar = initBitmap(
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
        var enemyCar: ImageBitmap? = null
        var background: ImageBitmap? = null

        val screenWidth = Resources.getSystem().displayMetrics.widthPixels
        val screenHeight = Resources.getSystem().displayMetrics.heightPixels

        var insetScreenHeight: Int = 0

        private const val INIT_WIDTH = 1080
        private const val INIT_HEIGHT = 2040

        private fun resizeWidth(size: Int) = screenWidth * size / INIT_WIDTH
        private fun resizeHeight(size: Int) = insetScreenHeight * size / INIT_HEIGHT
        private fun resizeWidth(size: Float) = screenWidth * size / INIT_WIDTH
        private fun resizeHeight(size: Float) = insetScreenHeight * size / INIT_HEIGHT
    }
}

class Enemy : GameObject() {
    fun initialize(boost: Int) {
        bitmap = BitmapsHandler.enemyCar
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

    fun isOutOfBound() = y > insetScreenHeight

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
        y = screenHeight - height.toFloat()
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

class GameThread @Inject constructor() {

    private val _threadState = MutableStateFlow(ThreadState())
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
        _threadState.value = _threadState.value.copy(
            time = System.currentTimeMillis()
        )
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

data class GameState(
    val background: Background = Background(),
    val player: Player = Player(),
    val enemies: List<Enemy> = listOf(),
    val score: Int = 0
)

sealed class ScreenState {
    object Running : ScreenState()

    object Paused : ScreenState()

    object MainMenu : ScreenState()

    object Lost : ScreenState()
}

data class ThreadState(
    val time: Long = System.currentTimeMillis()
)

@Composable
fun LoseScreen(appViewModel: AppViewModel = viewModel()) {
    val gameState = appViewModel.gameState.collectAsState()
    ComposeBack(image = R.drawable.background)
    Column(
        modifier = Modifier
            .fillMaxSize(),
        verticalArrangement = Arrangement.SpaceAround,
        horizontalAlignment = Alignment.CenterHorizontally
    ) {
        Text(
            text = "Game Over\\n\\nScore: ${gameState.value.score / 10}",
            color = textColorPrimary,
            fontSize = 50.sp,
            textAlign = TextAlign.Center
        )

        Button(
            onClick = {
                appViewModel.restartGame()
            },
            colors = ButtonDefaults.buttonColors(buttonColorPrimary)
        ) {
            Text(
                text = "Restart",
                color = buttonTextColorPrimary,
                fontSize = 36.sp
            )
        }
    }
}

@OptIn(ExperimentalComposeUiApi::class)
@Composable
fun GameCanvas(appViewModel: AppViewModel = viewModel()) {
    val gameState = appViewModel.gameState.collectAsState()
    Canvas(modifier = Modifier
        .fillMaxSize()
        .pointerInteropFilter { event ->
            when (event.action) {
                MotionEvent.ACTION_DOWN -> {
                    appViewModel.startMovingPlayer(event.x > screenWidth / 2)

                    true
                }

                MotionEvent.ACTION_UP -> {
                    appViewModel.stopMovingPlayer()

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
    }
}

@HiltViewModel
class AppViewModel @Inject constructor(
    private val gameThread: GameThread
) : ViewModel() {

    private val _gameState = MutableStateFlow(GameState())
    val gameState = _gameState.asStateFlow()

    private val _screenState = MutableStateFlow<ScreenState>(ScreenState.MainMenu)
    val screenState = _screenState.asStateFlow()

    private var enemiesSpawnBoost = 0

    /**
     * updating game objects when starting a new frame
     */
    init {
        viewModelScope.launch {
            gameThread.threadState.collect {
                frame()
            }
        }
    }

    fun pauseGame() {
        gameThread.pause()
        _screenState.value = ScreenState.Paused
    }

    fun resumeGame() {
        gameThread.start()
        _screenState.value = ScreenState.Running
    }

    fun restartGame() = with(_gameState.value) {
        _gameState.value = copy(
            player = player.apply {
                x = screenWidth / 2f
            },
            enemies = listOf(),
            score = 0,
            background = background.apply {
                background.onEach { backgroundItem ->
                    backgroundItem.resetSpeed()
                }
            }
        )
        gameThread.start()
        _screenState.value = ScreenState.Running
    }

    fun startGame() = with(_gameState.value) {
        _gameState.value = copy(
            background = background.apply {
                initialize()
            },
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
            background = background.apply {
                frame()
            },
            player = player.apply {
                frame()
            },
            enemies = enemies.onEach { enemy ->
                enemy.frame()
            },
            score = score + 1
        )
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
        enemiesSpawnBoost++
    }

    private fun clear() = with(_gameState.value) {
        _gameState.value = copy(
            enemies = enemies.filterNot { enemy ->
                enemy.isOutOfBound()
            }
        )
    }

    private fun spawnEnemy() = with(_gameState.value) {
        _gameState.value = copy(
            enemies = enemies.toMutableList().apply {
                add(
                    Enemy().apply {
                        initialize(score)
                    }
                )
            }
        )
    }
}

@Composable
fun RunningScreen() {
    Box(
        modifier = Modifier
            .fillMaxSize(),
        contentAlignment = Alignment.Center
    ) {
        GameCanvas()
        ScreenControlButtons()
        ScoreDisplay()
    }
}

@Composable
fun BoxScope.ScoreDisplay(appViewModel: AppViewModel = viewModel()) {
    val gameState = appViewModel.gameState.collectAsState()
    Text(
        modifier = Modifier
            .padding(top = 24.dp)
            .align(Alignment.TopCenter),
        style = MaterialTheme.typography.displayLarge,
        text = (gameState.value.score / 10).toString(),
        color = textColorPrimary
    )
}

@Composable
fun BoxScope.ScreenControlButtons(
    appViewModel: AppViewModel = viewModel(),
) {
    val screenState = appViewModel.screenState.collectAsState()
    when (screenState.value) {
        ScreenState.Paused -> {
            ControlButton(
                icon = Icons.Default.PlayArrow,
                alignment = Alignment.Center,
            ) {
                appViewModel.resumeGame()
            }
        }

        ScreenState.Running -> {
            ControlButton(
                icon = Icons.Default.Pause,
                alignment = Alignment.TopEnd,
                endPadding = 4.dp,
                topPadding = 24.dp
            ) {
                appViewModel.pauseGame()
            }
        }

        else -> {
            //nothing
        }
    }
}


@Composable
private fun BoxScope.ControlButton(
    icon: ImageVector,
    alignment: Alignment,
    topPadding: Dp = 0.dp,
    endPadding: Dp = 0.dp,
    onClick: () -> Unit
) {
    IconButton(
        modifier = Modifier
            .scale(3.25f)
            .align(alignment)
            .padding(top = topPadding, end = endPadding),
        onClick = onClick,
        colors = IconButtonDefaults.iconButtonColors(
            contentColor = textColorPrimary
        )
    ) {
        Icon(
            imageVector = icon,
            contentDescription = null
        )
    }
}


@Composable
fun StartScreen(appViewModel: AppViewModel = viewModel()) {
    ComposeBack(image = R.drawable.background)
    Column(
        modifier = Modifier
            .fillMaxSize(),
        verticalArrangement = Arrangement.SpaceAround,
        horizontalAlignment = Alignment.CenterHorizontally
    ) {
        Text(
            text = stringResource(id = R.string.app_name),
            color = textColorPrimary,
            fontSize = 42.sp,
            fontWeight = FontWeight.Black,
            textAlign = TextAlign.Center
        )

        Button(
            onClick = {
                appViewModel.startGame()
            },
            colors = ButtonDefaults.buttonColors(buttonColorPrimary),

            ) {
            Text(
                text = "Start",
                color = buttonTextColorPrimary,
                fontSize = 42.sp
            )
        }
    }
}

@Composable
fun ComposeBack(image: Int) {
    val res = LocalContext.current.resources
    val back by remember {
        mutableStateOf(
            Bitmap.createScaledBitmap(
                BitmapFactory.decodeResource(
                    res,
                    image
                ), res.displayMetrics.widthPixels, res.displayMetrics.heightPixels, false
            ).asImageBitmap()
        )
    }
    Image(bitmap = back, contentDescription = null, contentScale = ContentScale.FillBounds)
}
"""
    }
}
