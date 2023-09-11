//
//  File.swift
//  
//
//  Created by admin on 26.06.2023.
//

import Foundation

struct MBRace: FileProviderProtocol {
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
            MBRace()
        """
            ),
            mainActivityData: ANDMainActivity(
                imports: """
import androidx.core.view.WindowCompat
import androidx.core.view.WindowInsetsCompat
import android.graphics.Rect
import android.os.Build
import \(mainData.packageName).presentation.fragments.main_fragment.BitmapsInitializer.Companion.insetScreenHeight
import \(mainData.packageName).presentation.fragments.main_fragment.BitmapsInitializer.Companion.screenHeight
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

import android.content.Context
import android.content.res.Resources
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.graphics.Rect
import android.hardware.Sensor
import android.hardware.SensorEvent
import android.hardware.SensorEventListener
import android.hardware.SensorManager
import androidx.annotation.DrawableRes
import androidx.compose.foundation.Canvas
import androidx.compose.foundation.Image
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Pause
import androidx.compose.material.icons.filled.PlayArrow
import androidx.compose.material.icons.filled.Refresh
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.scale
import androidx.compose.ui.geometry.Offset
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.ImageBitmap
import androidx.compose.ui.graphics.asImageBitmap
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import androidx.lifecycle.viewmodel.compose.viewModel
import \(packageName).R
import dagger.Module
import dagger.Provides
import dagger.hilt.InstallIn
import dagger.hilt.android.lifecycle.HiltViewModel
import dagger.hilt.android.qualifiers.ApplicationContext
import dagger.hilt.components.SingletonComponent
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.CoroutineStart
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
val buttonColor = Color(0xFF\(uiSettings.buttonColorPrimary ?? "FFFFFF"))
val buttonTextColor = Color(0xFF\(uiSettings.buttonTextColorPrimary ?? "FFFFFF"))

val enterText = "Start Game"

@Composable
fun MBRace(appViewModel: AppViewModel = viewModel()) {
    val context = LocalContext.current
    LaunchedEffect(key1 = Unit) {
        BitmapsInitializer(context.resources)
    }
    val screenState = appViewModel.screenState.collectAsState()

    when (screenState.value) {
        ScreenState.Running -> GameCanvas()
        ScreenState.Paused -> PauseScreen()
        ScreenState.Finished -> FinishScreen()
        ScreenState.FirstEnter -> FirstEnterScreen()
    }
}

@Composable
fun FinishScreen(appViewModel: AppViewModel = viewModel()) {
    ComposeBack(image = R.drawable.background)
    val gameState = appViewModel.gameState.collectAsState()
    Column(
        modifier = Modifier
            .fillMaxSize(),
        verticalArrangement = Arrangement.Center,
        horizontalAlignment = Alignment.CenterHorizontally
    ) {
        Text(
            text = "Game Over",
            style = MaterialTheme.typography.displayLarge,
            color = textColorPrimary,
            fontSize = 50.sp
        )
        Text(
            text = "Score: ${gameState.value.score}",
            style = MaterialTheme.typography.displayLarge,
            color = textColorPrimary,
            fontSize = 38.sp
        )
        Spacer(
            modifier = Modifier
                .padding(vertical = 16.dp)
                .background(buttonColor)
        )
        IconButton(
            onClick = {
                appViewModel.restartGame()
            }, modifier = Modifier.size(130.dp)
        ) {
            Icon(
                imageVector = Icons.Default.Refresh,
                contentDescription = "Restart",
                modifier = Modifier
                    .size(130.dp)
                    .background(buttonColor),
                tint = buttonTextColor
            )
        }
    }
}

@Composable
fun GameCanvas(appViewModel: AppViewModel = viewModel()) {
    val gameState = appViewModel.gameState.collectAsState()
    Box(
        modifier = Modifier
            .fillMaxSize()
            .background(buttonColor),
        contentAlignment = Alignment.Center
    ) {
        Canvas(
            modifier = Modifier
                .fillMaxSize()
                .background(buttonColor)
        ) {

            gameState.value.background.backgrounds.forEach { background ->
                background.bitmap?.let { bitmap ->
                    drawImage(bitmap, Offset(0f, background.y + background.offset))
                }
            }
            gameState.value.player.also { player ->
                player.bitmap?.let { bitmap ->
                    drawImage(bitmap, Offset(player.x, player.y))
                }
            }
            gameState.value.enemies.forEach { enemy ->
                enemy.bitmap?.let { bitmap ->
                    drawImage(bitmap, Offset(enemy.x, enemy.y))
                }
            }
        }
        IconButton(
            modifier = Modifier
                .scale(2f)
                .padding(24.dp)
                .align(Alignment.TopEnd),
            onClick = { appViewModel.pauseGame() }
        ) {
            Icon(
                imageVector = Icons.Default.Pause,
                contentDescription = "Pause game",
                modifier = Modifier
                    .background(Color.Transparent),
                tint = buttonTextColor
            )
        }
        Text(
            text = gameState.value.score.toString(),
            style = MaterialTheme.typography.displayLarge,
            modifier = Modifier
                .padding(top = 24.dp)
                .align(Alignment.TopCenter),
            color = textColorPrimary,
            fontSize = 24.sp
        )
    }
}

@Composable
fun PauseScreen(appViewModel: AppViewModel = viewModel()) {
    ComposeBack(image = R.drawable.background)
    Column(
        modifier = Modifier
            .fillMaxSize(),
        verticalArrangement = Arrangement.Center,
        horizontalAlignment = Alignment.CenterHorizontally
    ) {
        Text(
            text = "Game paused",
            style = MaterialTheme.typography.displayLarge,
            color = textColorPrimary,
            fontSize = 50.sp
        )
        Spacer(
            modifier = Modifier
                .padding(vertical = 16.dp)
                .background(buttonColor)
        )
        IconButton(
            onClick = {
                appViewModel.resumeGame()
            }, modifier = Modifier.size(130.dp)
        ) {
            Icon(
                imageVector = Icons.Default.PlayArrow,
                contentDescription = "Resume",
                modifier = Modifier
                    .size(130.dp)
                    .background(buttonColor),
                tint = buttonTextColor
            )
        }
    }
}

@Composable
fun FirstEnterScreen(appViewModel: AppViewModel = viewModel()) {
    ComposeBack(image = R.drawable.background)
    Column(
        modifier = Modifier
            .fillMaxSize(),
        verticalArrangement = Arrangement.Center,
        horizontalAlignment = Alignment.CenterHorizontally
    ) {
        Text(
            text = enterText,
            style = MaterialTheme.typography.displayLarge,
            color = textColorPrimary,
            fontSize = 38.sp,
            textAlign = TextAlign.Center
        )
        Spacer(
            modifier = Modifier
                .padding(vertical = 16.dp)
                .background(buttonColor)
        )
        IconButton(
            onClick = {
                appViewModel.startGame()
            }, modifier = Modifier.size(130.dp)
        ) {
            Icon(
                imageVector = Icons.Default.PlayArrow,
                contentDescription = "Start",
                modifier = Modifier
                    .size(130.dp)
                    .background(buttonColor),
                tint = buttonTextColor
            )
        }
    }
}

class AccelerometerHandler @Inject constructor(
    private val gameThread: GameThread
) : SensorEventListener {
    override fun onSensorChanged(p0: SensorEvent) {
        val currentRotation = p0.values[0]
        gameThread.registerRotation(currentRotation * 4)
    }

    override fun onAccuracyChanged(p0: Sensor?, p1: Int) {

    }
}

@Module
@InstallIn(SingletonComponent::class)
object AppModule {

    @Provides
    @Singleton
    fun provideGameThread(): GameThread = GameThread()

    @Provides
    @Singleton
    fun provideSensorManager(@ApplicationContext context: Context): SensorManager =
        context.getSystemService(Context.SENSOR_SERVICE) as SensorManager


}

@HiltViewModel
class AppViewModel @Inject constructor(
    private val gameThread: GameThread,
    sensorManager: SensorManager
) : ViewModel() {

    private val _gameState = MutableStateFlow(GameState())
    val gameState = _gameState.asStateFlow()

    private val _screenState = MutableStateFlow<ScreenState>(ScreenState.FirstEnter)
    val screenState = _screenState.asStateFlow()

    init {
        val sensor = sensorManager.getDefaultSensor(Sensor.TYPE_ACCELEROMETER)
        sensorManager.registerListener(
            AccelerometerHandler(gameThread),
            sensor,
            SensorManager.SENSOR_DELAY_GAME
        )
        viewModelScope.launch(Dispatchers.Default) {
            gameThread.gameState.collect { threadGameState ->
                _gameState.value = threadGameState
            }
        }
        viewModelScope.launch(Dispatchers.Default) {
            gameThread.screenState.collect { threadScreenState ->
                _screenState.value = threadScreenState
            }
        }
    }

    fun startGame() = gameThread.startGame()

    fun pauseGame() = gameThread.pauseGame()

    fun resumeGame() = gameThread.resumeGame()

    fun restartGame() = gameThread.restartGame()

}

class Background(val offset: Float) : GameObject() {
    fun initialize() {
        bitmap = BitmapsInitializer.background
        bitmap?.let { bitmap ->
            width = bitmap.width
            height = bitmap.height
        }
        speed = 10f
    }

    fun increaseSpeed() {
        speed += 0.005f
    }
}

class Backgrounds {
    val backgrounds = listOf(Background(0f), Background(-BitmapsInitializer.insetScreenHeight.toFloat()))

    fun initialize() {
        backgrounds.forEach { background ->
            background.initialize()
        }
    }

    fun frame() {
        backgrounds.forEach { background ->
            background.y = (background.y + background.speed) % BitmapsInitializer.insetScreenHeight
            background.increaseSpeed()
        }
    }
}

class BitmapsInitializer(private val resources: Resources) {

    init {

        val backgroundWidth = resizeWidth(screenWidth)
        val backgroundHeight = insetScreenHeight + 10

        val playerWidth = resizeWidth(183)
        val playerHeight = resizeHeight(320)

        val enemyCarWidth = resizeWidth(201)
        val enemyCarHeight = resizeHeight(358)

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
            R.drawable.enemy_car,
            enemyCarWidth,
            enemyCarHeight
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

class EnemyCar : GameObject() {
    fun initialize() {
        bitmap = BitmapsInitializer.enemyCar
        bitmap?.let { bitmap ->
            width = bitmap.width
            height = bitmap.height
        }
        y = -getRandom(0, BitmapsInitializer.screenHeight * 10).toFloat()
        x = getRandom(width, BitmapsInitializer.screenWidth) - width.toFloat()
        speed = 15f
        setRect()
    }

    fun frame(listCars: MutableList<EnemyCar>) {
        y += speed
        increaseSpeed()
        setRect()
        if (y > BitmapsInitializer.screenHeight * 1.5f)
            reset()
        checkAnotherCarCollision(listCars)
    }

    private fun checkAnotherCarCollision(listCars: MutableList<EnemyCar>) {
        listCars.forEach { enemyCar ->
            if (hasCollision(enemyCar) && enemyCar.rect != rect)
                reset()
        }
    }

    fun reset() {
        y = -getRandom(height, BitmapsInitializer.screenHeight * 10).toFloat()
        setRect()
    }

    fun increaseSpeed() {
        speed += 0.005f
    }
}

fun Rect.intersects(rect: Rect): Boolean {
    return intersects(rect.left, rect.top, rect.right, rect.bottom)
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
        Random(System.nanoTime()).nextInt(bound, upperBound)
}

data class GameState(
    val score: Int = 0,
    val player: Player = Player(),
    val enemies: MutableList<EnemyCar> = mutableListOf(),
    val background: Backgrounds = Backgrounds()
)

class GameThread {

    private val _gameState = MutableStateFlow(GameState())
    val gameState = _gameState.asStateFlow()

    private val _screenState = MutableStateFlow<ScreenState>(ScreenState.FirstEnter)
    val screenState = _screenState.asStateFlow()

    private var startTime: Long = 0
    private var frameTime: Long = 0
    private val neededFrameTime: Int = (1000.0 / 60.0).toInt()

    private var job: Job? = null

    private var running: Boolean = true

    private fun initialize() {
        firstInitialize()
        job = CoroutineScope(Dispatchers.Default + SupervisorJob())
            .launch(start = CoroutineStart.LAZY) {
                loop()
            }
        running = true
        job?.start()
    }

    private fun resume() {
        job = CoroutineScope(Dispatchers.Default + SupervisorJob())
            .launch(start = CoroutineStart.LAZY) {
                loop()
            }
        running = true
        job?.start()
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

    private fun firstInitialize() = with(_gameState.value) {
        _gameState.value = copy(
            player = player.apply { initialize() },
            background = background.apply { initialize() },
            enemies = enemies.apply {
                repeat(8) {
                    add(EnemyCar().apply {
                        initialize()
                    })
                }
            }
        )
    }

    private fun frame() = with(_gameState.value) {
        _gameState.value = copy(
            score = score + 1,
            enemies = enemies.onEach { enemyCar ->
                enemyCar.frame(enemies)
                if (enemyCar.hasCollision(player))
                    end()
            },
            background = background.apply { frame() },
            player = player.apply { frame() }
        )
    }

    fun registerRotation(newSpeed: Float) = with(_gameState.value) {
        _gameState.value = copy(
            player = player.apply {
                speed = newSpeed
            }
        )
    }

    private fun stop() {
        running = false
        job = null
    }

    private fun end() {
        _screenState.value = ScreenState.Finished
        stop()
    }

    fun startGame() {
        _screenState.value = ScreenState.Running
        initialize()
    }

    fun pauseGame() {
        _screenState.value = ScreenState.Paused
        stop()
    }

    fun resumeGame() {
        _screenState.value = ScreenState.Running
        resume()
    }

    fun restartGame() = with(_gameState.value) {
        _gameState.value = copy(
            enemies = enemies.onEach { enemyCar ->
                enemyCar.reset()
            },
            player = player.apply {
                x = BitmapsInitializer.screenWidth / 2 - width / 2f
            },
            score = 0
        )
        _screenState.value = ScreenState.Running
        initialize()
    }
}

class Player : GameObject() {
    fun initialize() {
        bitmap = BitmapsInitializer.player
        bitmap?.let { bitmap ->
            width = bitmap.width
            height = bitmap.height
        }
        x = BitmapsInitializer.screenWidth / 2 - width / 2f
        y = BitmapsInitializer.screenHeight - height.toFloat()
        setRect()
    }

    fun frame() {
        if ((x - speed) > 10 && (x - speed) < (BitmapsInitializer.screenWidth - width - 10)) {
            x -= speed
            setRect()
        }
    }
}

sealed class ScreenState {
    object Running : ScreenState()
    object Paused : ScreenState()
    object Finished : ScreenState()
    object FirstEnter : ScreenState()
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
    
    static func enterText() -> String {
        let list = ["Welcome to street racing", "Start Game", "Start Race", "Race", "Game", "New Race", "New Game"]
        return list.randomElement() ?? list[0]
    }
}
