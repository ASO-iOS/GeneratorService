//
//  File.swift
//  
//
//  Created by admin on 28.06.2023.
//

import Foundation

struct MBCatcher: FileProviderProtocol {
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
                imports: """
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.collectAsState
import androidx.compose.ui.platform.LocalContext
import androidx.hilt.navigation.compose.hiltViewModel
""",
                content: """
            val viewModel: MainViewModel = hiltViewModel()
            val res = LocalContext.current.resources
            LaunchedEffect(key1 = Unit) {

                viewModel.initialize(res)
            }

            val state = viewModel.state.collectAsState()

            when (state.value.screen) {
                Screen.Finished -> EndGameScreen(viewModel = viewModel, state = state)
                Screen.Loading -> LoadingScreen()
                Screen.Running -> GameCanvas(viewModel = viewModel)
            }
        """
            ),
            mainActivityData: ANDMainActivity(
                imports: """
import androidx.core.view.WindowCompat
import androidx.core.view.WindowInsetsCompat
import android.graphics.Rect
import android.os.Build
import \(mainData.packageName).presentation.fragments.main_fragment.Bitmaps.insetScreenHeight
import \(mainData.packageName).presentation.fragments.main_fragment.Bitmaps.screenHeight
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
            stringsData: ANDStringsData(additional: """
                    <string name="score_counter">Score: %s</string>
                    <string name="you_lost">Game Over</string>
                    <string name="restart">Restart</string>
                    <string name="attempts_remaining">"Attempts remaining: %d"</string>
                    <string name="score">"Score: %d"</string>
                    <string name="restart_description">Restart</string>
                    <string name="loading">Loading…</string>
        """),
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
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.navigationBarsPadding
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Refresh
import androidx.compose.material3.Button
import androidx.compose.material3.ButtonDefaults
import androidx.compose.material3.CircularProgressIndicator
import androidx.compose.material3.Icon
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.State
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
import androidx.compose.ui.input.pointer.pointerInteropFilter
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.TextStyle
import androidx.compose.ui.text.font.FontStyle
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import \(packageName).R
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.Job
import kotlinx.coroutines.SupervisorJob
import kotlinx.coroutines.delay
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.launch
import kotlin.random.Random

val textColorPrimary = Color(0xFF\(uiSettings.textColorPrimary ?? "FFFFFF"))
val buttonColorPrimary = Color(0xFF\(uiSettings.buttonColorPrimary ?? "FFFFFF"))
val buttonTextColorPrimary = Color(0xFF\(uiSettings.buttonTextColorPrimary ?? "FFFFFF"))

@Composable
fun LoadingScreen() {
    ComposeBack(image = R.drawable.background)
    Column(modifier = Modifier
        .fillMaxSize()
        .padding(4.dp),
        verticalArrangement = Arrangement.Center,
        horizontalAlignment = Alignment.CenterHorizontally
    ) {
        CircularProgressIndicator(modifier = Modifier.padding(8.dp), color = textColorPrimary)
        Text(
            text = stringResource(R.string.loading),
            style = TextStyle(
                color = textColorPrimary,
                fontSize = 24.sp
            )
        )
    }
}

@OptIn(ExperimentalComposeUiApi::class)
@Composable
fun GameCanvas(
    viewModel: MainViewModel
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
            drawImage(state.value.background.bitmap, Offset(0f, 0f))
            state.value.apples.forEach { apple ->
                drawImage(apple.bitmap, Offset(apple.x, apple.y))
            }
            drawImage(state.value.cart.bitmap, Offset(state.value.cart.x, state.value.cart.y))
        }

        Text(
            text = stringResource(R.string.score_counter, state.value.score),
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
fun EndGameScreen(viewModel: MainViewModel, state: State<GameState>) {
    ComposeBack(image = R.drawable.background)
    Column(
        modifier = Modifier
            .fillMaxSize()
            .padding(8.dp),
        verticalArrangement = Arrangement.SpaceAround,
        horizontalAlignment = Alignment.CenterHorizontally
    ) {
        Column(
            verticalArrangement = Arrangement.Center,
            horizontalAlignment = Alignment.CenterHorizontally
        ) {
            Text(
                modifier = Modifier.padding(4.dp),
                text = stringResource(R.string.you_lost),
                style = TextStyle(
                    color = textColorPrimary,
                    fontSize = 42.sp,
                    fontWeight = FontWeight.Black
                )
            )
            Text(
                modifier = Modifier.padding(4.dp),
                text = stringResource(R.string.score, state.value.score),
                style = TextStyle(
                    color = textColorPrimary,
                    fontSize = 36.sp,
                    fontWeight = FontWeight.Black
                )
            )
        }
        Button(
            modifier = Modifier
                .scale(1.25f)
            ,
            shape = RoundedCornerShape(8.dp),
            colors = ButtonDefaults.buttonColors(containerColor = buttonColorPrimary),
            onClick = { viewModel.restart() }
        ) {
            Text(
                text = stringResource(R.string.restart),
                color = buttonTextColorPrimary,
                        fontSize = 20.sp
            )
        }
    }
}

class Apple : GameObject() {

    fun initialize(){
        bitmap = Bitmaps.apple
        width = bitmap.width
        height = bitmap.height
        x = getRandom(Bitmaps.screenWidth - width).toFloat()
        y = 0 - height.toFloat() - getRandom(Bitmaps.screenHeight * 10)
        speed = 20f
    }

    fun isOutOfBounds() = y > Bitmaps.screenHeight
}

class Background : GameObject() {
    fun initialize() {
        bitmap = Bitmaps.background
        width = bitmap.width
        height = bitmap.height
    }
}

object Bitmaps {
    lateinit var res: Resources
    lateinit var cart: ImageBitmap
    lateinit var apple: ImageBitmap
    lateinit var background: ImageBitmap

    fun initialize(resources: Resources) {
        res = resources

        val cartWidth = resizeWidth(230)
        val cartHeight = resizeHeight(230)

        val appleWidth = resizeWidth(130)
        val appleHeight = resizeWidth(130)

        val backgroundWidth = resizeWidth(screenWidth)
        val backgroundHeight = resizeHeight(screenHeight)

        background = initBitmap(
            R.drawable.background,
            backgroundWidth,
            backgroundHeight,
        )
        cart = initBitmap(R.drawable.cart, cartWidth, cartHeight)
        apple = initBitmap(R.drawable.`object`, appleWidth, appleHeight)

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
    private fun resizeWidth(size: Float) = screenWidth * size / INIT_WIDTH
    private fun resizeHeight(size: Float) = insetScreenHeight * size / INIT_HEIGHT
}

class Cart : GameObject() {

    fun initialize() {
        bitmap = Bitmaps.cart
        width = bitmap.width
        height = bitmap.height

        x = Bitmaps.screenWidth / 2f - width / 2f
        y = Bitmaps.screenHeight - height * 1.5f

        setRect()
    }
}

fun Rect.intersects(rect: Rect): Boolean {
    return intersects(rect.left, rect.top, rect.right, rect.bottom)
}

open class GameObject {
    var x = 0f
    var y = 0f
    var speed = 0f
    lateinit var bitmap: ImageBitmap
    var width = 0
    var height = 0
    var rect: Rect = Rect()

    open fun setRect() {
        rect.set(x.toInt(), y.toInt(), (x + width).toInt(), (y + height).toInt())
    }

    open fun hasCollision(gameObject: GameObject) = rect.intersects(gameObject.rect)

    fun getRandom(bound: Int) = Random.nextInt(0, bound)
}

data class GameState(
    val score: Long = 0,
    val cart: Cart = Cart(),
    val apples: List<Apple> = listOf(),
    val background: Background = Background(),
    val screen: Screen = Screen.Loading,
    val time: Long = System.currentTimeMillis(),
    val attempts: Int = 3
)

class MainViewModel : ViewModel() {

    private var job: Job? = null

    private var startTime: Long = 0
    private var frameTime: Long = 0
    private val neededFrameTime: Int = (1000.0 / 60.0).toInt()

    private val _state = MutableStateFlow(GameState())
    val state = _state.asStateFlow()

    private var running: Boolean = true
    private var currentScore: Long = 0

    private fun play() {
        if (job?.isActive != true) {
            job = viewModelScope.launch(Dispatchers.Default + SupervisorJob()) {
                initializeObjects()
                _state.value = _state.value.copy(screen = Screen.Running)

                while (running) {
                    startTime = System.currentTimeMillis()

                    moveAppleDown()
                    checkCollision()
                    checkAppleOutOfBounds()

                    _state.value = _state.value.copy(
                        score = currentScore,
                        time = System.currentTimeMillis(),
                        screen = if (running) Screen.Running else Screen.Finished
                    )

                    frameTime = System.currentTimeMillis() - startTime
                    if (frameTime < neededFrameTime) {
                        delay(neededFrameTime - frameTime)
                    }
                }
            }
        }
    }


    fun initialize(res: Resources){
        viewModelScope.launch(Dispatchers.Default) {
            Bitmaps.initialize(resources = res)
            play()
        }
    }

    private fun initializeObjects() = with(_state.value) {
        _state.value = _state.value.copy(
            cart = cart.also { cart -> cart.initialize() },
            background = background.also { background -> background.initialize() },
        )
        spawnApples()
    }

    fun restart() {
        _state.value = _state.value.copy(
            apples = arrayListOf(),
            background = Background(),
            cart = Cart(),
            score = 0L,
            attempts = 3,
            screen = Screen.Loading
        )
        currentScore = 0
        running = true
        play()
    }

    private fun spawnApples() = with(_state.value) {
        val applesFilled = mutableListOf<Apple>()
        repeat(7) {
            val apple = Apple().also { it.initialize() }
            applesFilled += apple
        }
        _state.value = _state.value.copy(
            apples = applesFilled.toList()
        )
    }

    private fun moveAppleDown() = with(_state.value) {
        apples.forEach { apple ->
            apples[apples.indexOf(apple)].y += apple.speed
            apples[apples.indexOf(apple)].setRect()
            _state.value = _state.value.copy(
                apples = apples
            )
        }
    }

    private fun checkCollision() = with(_state.value) {
        apples.forEach { apple ->
            if (cart.hasCollision(apple)) {
                currentScore++
                moveAppleRandomAndIncreaseSpeed(apple)
            }
        }
    }

    private fun checkAppleOutOfBounds() = with(_state.value) {
        apples.forEach { apple ->
            if (apple.isOutOfBounds()) {
                val attemptsRemaining = _state.value.attempts - 1
                _state.value = _state.value.copy(
                    attempts = attemptsRemaining
                )
                moveAppleRandom(apple)
                if (attemptsRemaining <= 0) {
                    _state.value = _state.value.copy(
                        screen = Screen.Finished
                    )
                    running = false
                    job?.cancel()
                }
            }
        }
    }

    private fun moveAppleRandom(apple: Apple) = with(_state.value){
        apples[apples.indexOf(apple)].y = 0f - apple.height - apple.getRandom(Bitmaps.screenHeight * 3)
        apples[apples.indexOf(apple)].x = apple.getRandom(Bitmaps.screenWidth - apple.width).toFloat()
        _state.value = _state.value.copy(
            apples = apples
        )
    }

    private fun moveAppleRandomAndIncreaseSpeed(apple: Apple) = with(_state.value){
        apples[apples.indexOf(apple)].y = 0f - apple.height - apple.getRandom(Bitmaps.screenHeight * 3)
        apples[apples.indexOf(apple)].x = apple.getRandom(Bitmaps.screenWidth - apple.width).toFloat()
        apples[apples.indexOf(apple)].speed += 0.15f
        _state.value = _state.value.copy(
            apples = apples
        )
    }

    fun moveCart(posX: Float) = with(_state.value){
        _state.value = _state.value.copy(
            cart = cart.also { cart ->
                cart.x = posX - cart.width / 2
                cart.setRect()
            }
        )
    }
}

sealed interface Screen {
    object Running : Screen
    object Loading : Screen
    object Finished : Screen
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
