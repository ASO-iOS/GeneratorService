//
//  File.swift
//  
//
//  Created by admin on 22.08.2023.
//

import Foundation

struct VENightBird: FileProviderProtocol {
    static var fileName = "\(NamesManager.shared.fileName).kt"
    
    static func fileContent(packageName: String, uiSettings: UISettings) -> String {
        return """
package \(packageName).presentation.fragments.main_fragment

import android.content.Context
import android.content.ContextWrapper
import android.content.res.Resources
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.graphics.Matrix
import android.graphics.Rect
import android.view.MotionEvent
import androidx.annotation.DrawableRes
import androidx.appcompat.app.AppCompatActivity
import androidx.compose.foundation.Canvas
import androidx.compose.foundation.Image
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.navigationBarsPadding
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.Button
import androidx.compose.material.ButtonDefaults
import androidx.compose.material.Icon
import androidx.compose.material.IconButton
import androidx.compose.material.LinearProgressIndicator
import androidx.compose.material.MaterialTheme
import androidx.compose.material.Shapes
import androidx.compose.material.Text
import androidx.compose.material.Typography
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Refresh
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
import androidx.compose.ui.graphics.asAndroidBitmap
import androidx.compose.ui.graphics.asImageBitmap
import androidx.compose.ui.graphics.drawscope.DrawScope
import androidx.compose.ui.input.pointer.pointerInteropFilter
import androidx.compose.ui.layout.ContentScale
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
import androidx.navigation.NavController
import androidx.navigation.NavGraphBuilder
import androidx.navigation.compose.composable
import \(packageName).R
import dagger.hilt.android.lifecycle.HiltViewModel
import dagger.hilt.android.qualifiers.ApplicationContext
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.Job
import kotlinx.coroutines.SupervisorJob
import kotlinx.coroutines.delay
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.launch
import javax.inject.Inject

val textColorPrimary = Color(0xFF\(uiSettings.textColorPrimary ?? "FFFFFF"))
val buttonColorPrimary = Color(0xFF\(uiSettings.buttonColorPrimary ?? "FFFFFF"))
val surfaceColor = Color(0xFF\(uiSettings.surfaceColor ?? "FFFFFF"))

val Shapes = Shapes(
    small = RoundedCornerShape(4.dp),
    medium = RoundedCornerShape(4.dp),
    large = RoundedCornerShape(0.dp)
)

@Composable
fun NightBirdTheme(
    content: @Composable () -> Unit)
{
    MaterialTheme(
        typography = Typography,
        shapes = Shapes,
        content = content
    )
}
val Typography = Typography(
    body1 = TextStyle(
        fontFamily = FontFamily.Default,
        fontWeight = FontWeight.Normal,
        fontSize = 16.sp
    )
)
fun <T: Number> resizeWidth(size: T): T = (Configuration.SCREEN_WIDTH * size.toFloat() / Configuration.INIT_WIDTH) as T
fun <T: Number> resizeHeight(size: T): T = (Configuration.SCREEN_HEIGHT * size.toFloat() / Configuration.INIT_HEIGHT) as T

fun Context.initBitmap(
    @DrawableRes resId: Int,
    width: Int,
    height: Int
): ImageBitmap {
    return Bitmap.createScaledBitmap(
        BitmapFactory.decodeResource(resources, resId),
        width,
        height,
        false
    ).asImageBitmap()
}

fun ImageBitmap.rotate(degrees: Float): ImageBitmap {
    val bitmap = this.asAndroidBitmap()
    val matrix = Matrix().also { it.setRotate(degrees) }

    return Bitmap.createBitmap(bitmap, 0, 0, bitmap.width, bitmap.height, matrix, false).asImageBitmap()
}

object Configuration {
    var SCREEN_WIDTH = Resources.getSystem().displayMetrics.widthPixels
    var SCREEN_HEIGHT = Resources.getSystem().displayMetrics.heightPixels

    val COLUMN_HEIGHT: Int = resizeHeight(1000)
    val COLUMN_WIDTH: Int = resizeWidth(244)
    val MIN_BLOCKER_DEST = resizeWidth(600)

    val HALF_SCREEN_HEIGHT = SCREEN_HEIGHT / 2

    val BIRD_WIDTH: Int = resizeWidth(126) //640 446
    val BIRD_HEIGHT: Int = resizeHeight(90)
    val BIRD_OFFSET_BY_X = resizeWidth(300)  //bird position by X
    val BIRD_OFFSET_BY_Y = HALF_SCREEN_HEIGHT - BIRD_HEIGHT

    const val INIT_WIDTH = 1024
    const val INIT_HEIGHT = 1920

    const val BLOCKERS_BUFFER_COUNT = 10

    val ACCELERATION_ON_TAP = resizeHeight(-18f)
    val GRAVITY = resizeHeight(0.7f)
    val SPEED_X = resizeWidth(-5f)
}

fun DrawScope.drawPlayer(player: Player) = drawImage(player.bitmap, Offset(player.x, player.y))

fun DrawScope.drawBlockers(blockers: BlockerPath) {
    for (blocker in blockers.blockers) {
        drawColumn(blocker.topColumn)
        drawColumn(blocker.bottomColumn)
    }
}

fun DrawScope.drawColumn(column: Column) = drawImage(column.bitmap, Offset(column.x, column.y))

fun DrawScope.drawBackground(backgroundBitmap: ImageBitmap) = drawImage(backgroundBitmap, Offset(0f, 0f))

class GameObjectsProvider @Inject constructor(
    @ApplicationContext private val context: Context
) {
    private val playerBitmap get() = context.initBitmap(
        resId = R.drawable.bird,
        width = Configuration.BIRD_WIDTH,
        height = Configuration.BIRD_HEIGHT
    )

    val background get() = context.initBitmap(
        resId = R.drawable.background,
        width = Configuration.SCREEN_WIDTH * 3,
        height = Configuration.SCREEN_HEIGHT
    )

    private val blocker get() = context.initBitmap(
        resId = R.drawable.pipe,
        width = Configuration.COLUMN_WIDTH,
        height = Configuration.COLUMN_HEIGHT
    )

    val blockerPath get() = BlockerPath(blocker)
    val player get() = Player(playerBitmap)
}

class Blocker(
    private var x: Float,
    columnBitmap: ImageBitmap
) {
    val topColumn: Column
    val bottomColumn: Column

    init {
        topColumn = Column(isTopPipe = true, x, columnBitmap)
        bottomColumn = Column( isTopPipe = false, x, columnBitmap.rotate(180f))
    }

    fun isOutOfBounds() = x < -Configuration.COLUMN_WIDTH

    fun initialize(x: Float) {
        topColumn.updateCoordinates()
        bottomColumn.updateCoordinates()
        moveX(x)
    }

    fun redraw(player: Player): Boolean {
        if (player.hasCollision(topColumn) || player.hasCollision(bottomColumn))
            return true

        moveX(x + Configuration.SPEED_X)
        return false
    }

    private fun moveX(speedX: Float) {
        x = speedX
        topColumn.x = speedX
        bottomColumn.x = speedX

        topColumn.drawObject()
        bottomColumn.drawObject()
    }
}
class BlockerPath @Inject constructor(
    private val columnBitmap: ImageBitmap
) {
    val blockers = mutableListOf<Blocker>()
    private var currentPath = (Configuration.SCREEN_WIDTH + Configuration.COLUMN_WIDTH).toFloat()

    fun drawBlockerObjects() {
        repeat(Configuration.BLOCKERS_BUFFER_COUNT) {
            val x = currentPath + Configuration.MIN_BLOCKER_DEST + (0..100).random().toFloat()
            blockers.add(Blocker(x, columnBitmap))
            currentPath = x
        }
    }

    fun redraw(player: Player): Boolean {
        for (blocker in blockers) {
            if (blocker.redraw(player))
                return false
            if (blocker.isOutOfBounds()) {
                initialize(blocker)
            }
        }
        currentPath += Configuration.SPEED_X
        return true
    }

    private fun initialize(blocker: Blocker) {
        val x = currentPath + Configuration.MIN_BLOCKER_DEST + (0..100).random().toFloat()

        blocker.initialize(x)
        currentPath = x
    }
}

class Column(
    val isTopPipe: Boolean,
    private val inputX: Float,
    columnBitmap: ImageBitmap
) : DrawnObject(columnBitmap) {
    init {
        updateCoordinates()
    }

    fun updateCoordinates() {
        val gap = (-pipeOffset..0).random()

        y = when(isTopPipe) {
            true -> (gap).toFloat()
            false -> (Configuration.HALF_SCREEN_HEIGHT + gap + minDistanceBetweenPipes).toFloat()
        }

        x = inputX
        drawObject()
    }

    companion object {
        val minDistanceBetweenPipes = resizeHeight(500)
        val pipeOffset = resizeHeight(300)
    }
}
open class DrawnObject(val bitmap: ImageBitmap) {
    private val box: Rect = Rect()
    var x = 0f
    var y = 0f

    open fun drawObject() {
        box.set(x.toInt(), y.toInt(), (x + bitmap.width).toInt(), (y + bitmap.height).toInt())
    }

    open fun hasCollision(drawnObject: DrawnObject): Boolean {
        return box.intersect(drawnObject.box)
    }
}
class Player(birdBitmap: ImageBitmap) : DrawnObject(birdBitmap) {
    private var speedY = 0f

    init {
        x = Configuration.BIRD_OFFSET_BY_X.toFloat()
        y = Configuration.BIRD_OFFSET_BY_Y.toFloat()
    }

    fun accelerate() {
        if (y > 0) speedY = Configuration.ACCELERATION_ON_TAP
    }

    fun redraw(): Boolean {
        speedY += Configuration.GRAVITY
        y += speedY

        if (y > Configuration.SCREEN_HEIGHT) return false

        drawObject()
        return true
    }
}

fun NavGraphBuilder.gameScreen(navController: NavController) {
    composable(route = Screen.GameScreen.route) {
        val viewModel = hiltViewModel<GameViewModel>()
        val state = viewModel.state.collectAsState().value

        GameScreen(
            state = state,
            onPlay = viewModel::play,
            onTryAgain = {
                navController.navigate(Screen.GameScreen.route) {
                    popUpTo(Screen.GameScreen.route) { inclusive = true }
                }
            }
        )
    }
}

fun NavGraphBuilder.menuScreen(navController: NavController) {
    composable(route = Screen.MenuScreen.route) {
        MenuScreen(
            onPlayPressed = { navController.navigate(Screen.GameScreen.route) }
        )
    }
}
sealed class Screen(val route: String) {
    object MenuScreen : Screen(route = "menu_screen")
    object GameScreen : Screen(route = "game_screen")
}

@Composable
fun GameScreen(
    state: UiGameState,
    onPlay: () -> Unit,
    onTryAgain: () -> Unit
) {
    LaunchedEffect(key1 = Unit) {
        launch(Dispatchers.Default) { onPlay() }
    }

    Box(
        modifier = Modifier.fillMaxSize(),
        contentAlignment = Alignment.Center
    ) {
        BackgroundStatic()

        when (state.gameState) {
            is UiGameState.GameState.Loading -> {
                LinearProgressIndicator()
            }
            is UiGameState.GameState.Running -> {
                GameCanvas(
                    blockers = state.blockers,
                    player = state.player,
                    score = state.score,
                    background = state.background
                )
            }
            is UiGameState.GameState.Finished -> {
                EndgameDialog(
                    score = state.score,
                    onTryAgainPressed = onTryAgain
                )
            }
        }
    }
}
@HiltViewModel
class GameViewModel @Inject constructor(
    gameObjectsProvider: GameObjectsProvider
) : ViewModel() {
    private var job: Job? = null

    private var startTime: Long = 0
    private var frameTime: Long = 0
    private val neededFrameTime: Int = (1000.0 / 60.0).toInt()

    private val _state = MutableStateFlow(
        UiGameState(
            player = gameObjectsProvider.player,
            blockers = gameObjectsProvider.blockerPath,
            background = gameObjectsProvider.background
        )
    )
    val state = _state.asStateFlow()

    private var running: Boolean = true
    private var score: Long = 0

    fun play() {
        if (job?.isActive != true) {
            job = viewModelScope.launch(Dispatchers.Default + SupervisorJob()) {
                drawGameObjects()
                _state.value = _state.value.copy(gameState = UiGameState.GameState.Running)
                while (running) {
                    startTime = System.currentTimeMillis()

                    moveBlockers()
                    movePlayer()

                    score++
                    _state.value = _state.value.copy(
                        score = score,
                        gameState = if(running) UiGameState.GameState.Running else UiGameState.GameState.Finished
                    )

                    frameTime = System.currentTimeMillis() - startTime
                    if (frameTime < neededFrameTime) {
                        delay(neededFrameTime - frameTime)
                    }
                }
            }
        }
    }

    private fun drawGameObjects() {
        _state.value.player.drawObject()
        _state.value.blockers.drawBlockerObjects()
    }

    private fun moveBlockers() {
        running = _state.value.blockers.redraw(_state.value.player)
    }

    private fun movePlayer() {
        running = running && _state.value.player.redraw()
    }
}
data class UiGameState(
    var score: Long = 0,
    val player: Player,
    val blockers: BlockerPath,
    val background: ImageBitmap,
    val gameState: GameState = GameState.Loading,
) {
    sealed interface GameState {
        object Running : GameState
        object Loading : GameState
        object Finished : GameState
    }
}
@Composable
fun MenuScreen(
    onPlayPressed: () -> Unit,
) {
    val context = LocalContext.current

    Box(modifier = Modifier.fillMaxSize()) {
        BackgroundStatic()

        Column(
            modifier = Modifier.fillMaxSize(),
            horizontalAlignment = Alignment.CenterHorizontally,
            verticalArrangement = Arrangement.spacedBy(20.dp, Alignment.CenterVertically)
        ) {
            TextButton(
                text = stringResource(R.string.play),
                onClickAction = onPlayPressed,
            )
            TextButton(
                text = stringResource(R.string.exit),
                onClickAction = { context.findActivity()?.finishAndRemoveTask() }
            )
        }
    }
}

fun Context.findActivity(): AppCompatActivity? = when (this) {
    is AppCompatActivity -> this
    is ContextWrapper -> baseContext.findActivity()
    else -> null
}

@Composable
fun BackgroundStatic() {
    val res = LocalContext.current.resources
    val back by remember {
        mutableStateOf(
            Bitmap.createScaledBitmap(
                BitmapFactory.decodeResource(
                    res,
                    R.drawable.background
                ),
                Configuration.SCREEN_WIDTH * 3,
                Configuration.SCREEN_HEIGHT,
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

@Composable
fun EndgameDialog(
    onTryAgainPressed: () -> Unit,
    score: Long
) {
    Column(
        modifier = Modifier
            .clip(shape = RoundedCornerShape(10))
            .background(surfaceColor)
            .padding(20.dp),
        horizontalAlignment = Alignment.CenterHorizontally,
        verticalArrangement = Arrangement.Center
    ) {
        Text(
            text = stringResource(R.string.end_dialog, score),
            color = textColorPrimary,
            fontSize = 40.sp,
            textAlign = TextAlign.Center,
            modifier = Modifier.padding(bottom = 24.dp)
        )
        IconButton(onClick = onTryAgainPressed) {
            Icon(
                modifier = Modifier.size(50.dp),
                imageVector = Icons.Default.Refresh,
                contentDescription = null,
                tint = textColorPrimary
            )
        }
    }
}

@OptIn(ExperimentalComposeUiApi::class)
@Composable
fun GameCanvas(
    background: ImageBitmap,
    blockers: BlockerPath,
    player: Player,
    score: Long
) {
    Box(
        modifier = Modifier
            .fillMaxSize()
            .navigationBarsPadding()
    ) {
        Canvas(
            modifier = Modifier
                .fillMaxSize()
                .pointerInteropFilter { event ->
                    when (event.action) {
                        MotionEvent.ACTION_DOWN -> {
                            player.accelerate()
                            false
                        }

                        else -> false
                    }
                },
        ) {
            drawBackground(background)
            drawPlayer(player)
            drawBlockers(blockers)
        }

        Text(
            text = score.toString(),
            color = textColorPrimary,
            modifier = Modifier
                .align(Alignment.TopCenter)
                .padding(end = 12.dp, bottom = 12.dp),
            fontSize = 40.sp,
            fontStyle = FontStyle.Italic
        )
    }
}
@Composable
fun TextButton(text: String, onClickAction: () -> Unit) {
    Button(
        modifier = Modifier
            .clip(RoundedCornerShape(16.dp))
            .fillMaxWidth(0.8f),
        onClick = onClickAction,
        colors = ButtonDefaults.buttonColors(
            backgroundColor = buttonColorPrimary
        )
    ) {
        Text(
            text = text,
            fontSize = 40.sp,
            color = textColorPrimary
        )
    }
}

"""
    }
    
    static func dependencies(_ mainData: MainData) -> ANDData {
        return ANDData(mainFragmentData: ANDMainFragment(imports: """
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.material.MaterialTheme
import androidx.compose.material.Surface
import androidx.compose.ui.Modifier
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.rememberNavController
""", content: """
    NightBirdTheme {
        Surface(
            modifier = Modifier.fillMaxSize(),
            color = MaterialTheme.colors.background
        ) {
            val navController = rememberNavController()
            NavHost(
                navController = navController,
                startDestination = Screen.MenuScreen.route
            ) {
                menuScreen(navController)
                gameScreen(navController)
            }
        }
    }
"""), mainActivityData: ANDMainActivity(imports: "", extraFunc: "", content: ""), themesData: ANDThemesData(isDefault: true, content: ""), stringsData: ANDStringsData(additional: """
    <string name="again_button">Again</string>
    <string name="end_dialog">Your score: %d</string>
    <string name="score_counter">Score: %d</string>
    <string name="play">Play</string>
    <string name="exit">Exit</string>
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
        implementation Dependencies.room_runtime
    kapt Dependencies.room_compiler
    implementation Dependencies.room_ktx
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
    
    
}
