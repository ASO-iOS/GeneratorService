//
//  File.swift
//  
//
//  Created by admin on 8/20/23.
//

import Foundation

struct VELuckySpan: FileProviderProtocol {
    static var fileName: String = "LuckySpan.kt"
    
    static func fileContent(packageName: String, uiSettings: UISettings) -> String {
        """
package \(packageName).presentation.fragments.main_fragment

import android.content.Context
import android.content.ContextWrapper
import androidx.appcompat.app.AppCompatActivity
import androidx.compose.animation.core.Animatable
import androidx.compose.animation.core.FastOutLinearInEasing
import androidx.compose.animation.core.tween
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.width
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.ArrowBack
import androidx.compose.material.icons.filled.Pin
import androidx.compose.material3.AlertDialog
import androidx.compose.material3.Button
import androidx.compose.material3.ButtonDefaults
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Text
import androidx.compose.material3.TextButton
import androidx.compose.material3.TextField
import androidx.compose.material3.TextFieldDefaults
import androidx.compose.material3.TopAppBar
import androidx.compose.material3.TopAppBarDefaults
import androidx.compose.material3.Typography
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.graphicsLayer
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.TextStyle
import androidx.compose.ui.text.font.FontFamily
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.hilt.navigation.compose.hiltViewModel
import androidx.lifecycle.ViewModel
import androidx.navigation.NavController
import androidx.navigation.NavGraphBuilder
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import androidx.navigation.compose.rememberNavController
import \(packageName).R
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.asStateFlow
import javax.inject.Inject
import kotlin.random.Random
import kotlin.random.nextInt

val backColorPrimary = Color(0xFF\(uiSettings.backColorPrimary ?? "FFFFFF"))
val surfaceColor = Color(0xFF\(uiSettings.surfaceColor ?? "FFFFFF"))
val textColorPrimary = Color(0xFF\(uiSettings.textColorPrimary ?? "FFFFFF"))
val buttonColorPrimary = Color(0xFF\(uiSettings.buttonColorPrimary ?? "FFFFFF"))

val Typography = Typography(
    bodyLarge = TextStyle(
        fontFamily = FontFamily.Default,
        fontWeight = FontWeight.Normal,
        fontSize = 16.sp,
        lineHeight = 24.sp,
        letterSpacing = 0.5.sp
    )
)

@Composable
fun LuckySpanTheme(
    content: @Composable () -> Unit
) {
    MaterialTheme(
        typography = Typography,
        content = content
    )
}

const val QUESTION_DEFAULT = "?"

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun LuckySpanScreen(
    uiState: UiLuckyState,
    onBackPressed: () -> Unit,
    onPlayPressed: (lower: Int, top: Int) -> Unit
) {
    var lowerBound: Int by remember { mutableStateOf(0) }
    var topBound: Int by remember { mutableStateOf(100) }
    var text: String by remember { mutableStateOf(QUESTION_DEFAULT) }
    var isDialogShown by remember { mutableStateOf(false) }

    LaunchedEffect(key1 = uiState) {
        text = when(uiState) {
            is UiLuckyState.Error -> QUESTION_DEFAULT
            is UiLuckyState.Win -> uiState.randomValue.toString()
            is UiLuckyState.Lose -> uiState.randomValue.toString()
            is UiLuckyState.Default -> QUESTION_DEFAULT
        }
        isDialogShown = true
    }

    when(uiState) {
        is UiLuckyState.Error -> MessageDialog(
            resId = R.string.error_message,
            isDialogShown = isDialogShown,
            onDismiss = { isDialogShown = false }
        )
        is UiLuckyState.Win -> MessageDialog(
            resId = R.string.win_message,
            isDialogShown = isDialogShown,
            onDismiss = { isDialogShown = false }
        )
        is UiLuckyState.Lose -> MessageDialog(
            resId = R.string.lose_message,
            isDialogShown = isDialogShown,
            onDismiss = { isDialogShown = false }
        )
        is UiLuckyState.Default -> {}
    }

    Scaffold(
        topBar = {
            TopAppBar(
                colors = TopAppBarDefaults.centerAlignedTopAppBarColors(
                    containerColor = backColorPrimary
                ),
                title = {  },
                navigationIcon = {
                    IconButton(onClick = onBackPressed) {
                        Icon(
                            imageVector = Icons.Default.ArrowBack,
                            contentDescription = null,
                            tint = textColorPrimary
                        )
                    }
                }
            )
        },
        containerColor = backColorPrimary
    ) {
        Column(
            modifier = Modifier
                .fillMaxSize()
                .padding(it),
            horizontalAlignment = Alignment.CenterHorizontally,
            verticalArrangement = Arrangement.spacedBy(50.dp, Alignment.CenterVertically)
        ) {
            Text(
                text = text,
                style = MaterialTheme.typography.titleLarge,
                color = textColorPrimary,
                fontSize = 70.sp
            )

            Row(
                modifier = Modifier.fillMaxWidth(),
                verticalAlignment = Alignment.CenterVertically,
                horizontalArrangement = Arrangement.SpaceAround
            ) {
                TextField(
                    modifier = Modifier.width(100.dp),
                    value = lowerBound.toString(),
                    onValueChange = { text ->
                        text.toIntOrNull()?.let { value ->
                            lowerBound = value
                        }
                        if(text.isEmpty()) { lowerBound = 0 }
                    },
                    textStyle = TextStyle(
                        textAlign = TextAlign.Center
                    ),
                    colors = TextFieldDefaults.colors(
                        unfocusedContainerColor = surfaceColor,
                        focusedContainerColor = surfaceColor,
                        focusedTextColor = textColorPrimary,
                        unfocusedTextColor = textColorPrimary
                    )
                )

                TextField(
                    modifier = Modifier.width(100.dp),
                    value = topBound.toString(),
                    onValueChange = { text ->
                        text.toIntOrNull()?.let { value ->
                            topBound = value
                        }
                        if(text.isEmpty()) { topBound = 0 }
                    },
                    textStyle = TextStyle(
                        textAlign = TextAlign.Center
                    ),
                    colors = TextFieldDefaults.colors(
                        unfocusedContainerColor = surfaceColor,
                        focusedContainerColor = surfaceColor,
                        focusedTextColor = textColorPrimary,
                        unfocusedTextColor = textColorPrimary
                    )
                )
            }
            TextButton(onClick = { onPlayPressed(lowerBound, topBound) }) {
                Text(
                    text = stringResource(id = R.string.play),
                    style = MaterialTheme.typography.titleLarge,
                    color = textColorPrimary,
                    fontSize = 30.sp
                )
            }
        }
    }
}

@Composable
private fun MessageDialog(
    resId: Int,
    onDismiss: () -> Unit,
    isDialogShown: Boolean
) {
    if(isDialogShown) {
        AlertDialog(
            onDismissRequest = {  },
            title = {
                Text(
                    text = stringResource(id = resId),
                    textAlign = TextAlign.Center,
                    color = textColorPrimary
                )
            },
            confirmButton = {
                TextButton(onClick = onDismiss) {
                    Text(
                        text = stringResource(id = R.string.ok),
                        color = textColorPrimary
                    )
                }
            },
            containerColor = surfaceColor
        )
    }
}

@HiltViewModel
class LuckyViewModel @Inject constructor(): ViewModel() {
    private val _uiState = MutableStateFlow<UiLuckyState>(UiLuckyState.Default)
    val uiState = _uiState.asStateFlow()

    fun play(lower: Int, top: Int) {
        try {
            val luckyNumber = Random.nextInt(lower..(top * 2))

            if(luckyNumber in lower..top)
                _uiState.value = UiLuckyState.Win(luckyNumber)
            else
                _uiState.value = UiLuckyState.Lose(luckyNumber)
        } catch (e: Exception) {
            _uiState.value = UiLuckyState.Error
        }
    }
}

sealed class UiLuckyState {
    object Default: UiLuckyState()
    object Error: UiLuckyState()
    class Win(val randomValue: Int): UiLuckyState()
    class Lose(val randomValue: Int): UiLuckyState()
}

@Composable
fun MenuScreen(
    onExitPressed: () -> Unit,
    onStartPressed: () -> Unit
) {
    Column(
        modifier = Modifier
            .fillMaxSize()
            .background(backColorPrimary)
            .padding(horizontal = 30.dp),
        horizontalAlignment = Alignment.CenterHorizontally,
        verticalArrangement = Arrangement.spacedBy(20.dp, Alignment.CenterVertically)
    ) {
        Button(
            modifier = Modifier.fillMaxWidth(),
            onClick = onStartPressed,
            colors = ButtonDefaults.buttonColors(
                containerColor = buttonColorPrimary
            )
        ) {
            Text(
                text = stringResource(id = R.string.start),
                style = MaterialTheme.typography.titleLarge,
                color = textColorPrimary
            )
        }

        Button(
            modifier = Modifier.fillMaxWidth(),
            onClick = onExitPressed,
            colors = ButtonDefaults.buttonColors(
                containerColor = buttonColorPrimary
            )
        ) {
            Text(
                text = stringResource(id = R.string.exit),
                style = MaterialTheme.typography.titleLarge,
                color = textColorPrimary
            )
        }
    }
}

@Composable
fun Router() {
    val navController = rememberNavController()
    NavHost(
        navController = navController,
        startDestination = Screen.Splash.route
    ) {
        splashScreen(navController)
        menuScreen(navController)
        luckySpanScreen(navController)
    }
}

fun NavGraphBuilder.splashScreen(navController: NavController) {
    composable(route = Screen.Splash.route) {
        SplashScreen(
            onNextScreen = {
                navController.navigate(Screen.Menu.route) {
                    popUpTo(Screen.Splash.route) { inclusive = true }
                }
            }
        )
    }
}

fun Context.findActivity(): AppCompatActivity? = when (this) {
    is AppCompatActivity -> this
    is ContextWrapper -> baseContext.findActivity()
    else -> null
}

fun NavGraphBuilder.menuScreen(navController: NavController) {
    composable(route = Screen.Menu.route) {
        val context = LocalContext.current

        MenuScreen(
            onExitPressed = { context.findActivity()?.finishAndRemoveTask() },
            onStartPressed = { navController.navigate(Screen.LuckySpan.route) }
        )
    }
}

fun NavGraphBuilder.luckySpanScreen(navController: NavController) {
    composable(route = Screen.LuckySpan.route) {
        val viewModel = hiltViewModel<LuckyViewModel>()
        val uiState = viewModel.uiState.collectAsState().value

        LuckySpanScreen(
            onBackPressed = navController::popBackStack,
            uiState = uiState,
            onPlayPressed = viewModel::play
        )
    }
}

sealed class Screen(val route: String) {
    object Splash: Screen(route = "splash_screen")
    object LuckySpan: Screen(route = "lucky_span_screen")
    object Menu: Screen(route = "menu_screen")
}

@Composable
fun SplashScreen(onNextScreen: () -> Unit) {
    val animation = remember { Animatable(initialValue = 0f) }

    LaunchedEffect(key1 = Unit) {
        animation.animateTo(
            targetValue = 360f,
            animationSpec = tween(
                durationMillis = 2000,
                easing = FastOutLinearInEasing
            )
        )
        onNextScreen()
    }
    Column(
        modifier = Modifier
            .fillMaxSize()
            .background(backColorPrimary)
            .graphicsLayer {
                rotationY = animation.value
                cameraDistance = 20 * density
            },
        horizontalAlignment = Alignment.CenterHorizontally,
        verticalArrangement = Arrangement.Center
    ) {
        Icon(
            modifier = Modifier.size(200.dp),
            imageVector = Icons.Default.Pin,
            contentDescription = null,
            tint = textColorPrimary
        )
        Text(
            text = stringResource(id = R.string.app_name),
            style = MaterialTheme.typography.titleLarge,
            color = textColorPrimary,
            fontSize = 30.sp
        )
    }
}



"""
    }
    
    static func dependencies(_ mainData: MainData) -> ANDData {
        return ANDData(mainFragmentData: ANDMainFragment(imports: "", content: """
    LuckySpanTheme {
        Router()
    }
"""),
                       mainActivityData: ANDMainActivity(imports: "", extraFunc: "", content: ""),
                       themesData: ANDThemesData(isDefault: true, content: ""),
                       stringsData: ANDStringsData(additional: """
    <string name="start">Start</string>
    <string name="exit">Exit</string>
    <string name="play">Play</string>
    <string name="ok">Ok</string>
    <string name="error_message">Incorrect values for bounds</string>
    <string name="win_message">You win!</string>
    <string name="lose_message">You lose</string>
"""),
                       colorsData: ANDColorsData(additional: ""))
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
