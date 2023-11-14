//
//  File.swift
//  
//
//  Created by admin on 11/13/23.
//

import Foundation

struct KDCanvas: FileProviderProtocol {
    
    static var fileName: String = "\(NamesManager.shared.fileName).kt"
    
    static func fileContent(packageName: String, uiSettings: UISettings) -> String {
        return """
package \(packageName).presentation.fragments.main_fragment


import android.util.Log
import androidx.compose.foundation.Canvas
import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.gestures.detectDragGestures
import androidx.compose.foundation.gestures.detectTapGestures
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.ColumnScope
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.outlined.Token
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.Icon
import androidx.compose.material3.ModalBottomSheet
import androidx.compose.material3.Scaffold
import androidx.compose.material3.SheetState
import androidx.compose.material3.rememberModalBottomSheetState
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.SideEffect
import androidx.compose.runtime.Stable
import androidx.compose.runtime.collectAsState
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.drawWithCache
import androidx.compose.ui.geometry.CornerRadius
import androidx.compose.ui.geometry.Offset
import androidx.compose.ui.geometry.Rect
import androidx.compose.ui.geometry.Size
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.drawscope.DrawScope
import androidx.compose.ui.input.pointer.pointerInput
import androidx.compose.ui.platform.LocalConfiguration
import androidx.compose.ui.platform.LocalDensity
import androidx.compose.ui.text.TextStyle
import androidx.compose.ui.unit.Dp
import androidx.compose.ui.unit.dp
import androidx.hilt.navigation.compose.hiltViewModel
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import androidx.navigation.NavController
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import androidx.navigation.compose.rememberNavController
import com.google.accompanist.systemuicontroller.rememberSystemUiController
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.channels.Channel
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.flow.receiveAsFlow
import kotlinx.coroutines.launch
import javax.inject.Inject

val backColorPrimary = Color(0xFF\(uiSettings.backColorPrimary ?? "FFFFFF"))
val onSurfaceColor = Color(0xFF\(uiSettings.onSurfaceColor ?? "FFFFFF"))
val primaryColor = Color(0xFF\(uiSettings.primaryColor ?? "FFFFFF"))

abstract class BaseViewModel<State, Effect>(initState: State): ViewModel() {

    private val _viewState: MutableStateFlow<State> = MutableStateFlow(initState)
    val viewState = _viewState.asStateFlow()

    private val _effects: Channel<Effect> = Channel()
    val effects: Flow<Effect> = _effects.receiveAsFlow()

    protected val state: State
        get() = viewState.value

    protected fun updateState(changeState: State.() -> State){
        synchronized(this) {
            _viewState.value = viewState.value.changeState()
        }
    }



}
const val DEBUG = "AppDebug"

fun Any?.logDebug(prefix: String = "", postfix: String = "") {
    val debugMessage = "$prefix $this $postfix"
    if (this is Throwable?) {
        Log.e(DEBUG, debugMessage)
    } else {
        Log.i(DEBUG, debugMessage)
    }
}


object DebugMessage {
    const val LOADING = "Loading"
    const val SUCCESS = "Success: "
    const val ERROR = "Error: "
    const val EMPTY = "Empty"
}


suspend inline fun <T> (suspend () -> Result<T>).loadAndHandleData(
    haveDebug: Boolean = false,
    onSuccess: (T) -> Unit = {},
    onEmpty: () -> Unit = {},
    onError: (Throwable) -> Unit = {},
    onLoading: () -> Unit = {}
) {
    onLoading()
    if (haveDebug) DebugMessage.LOADING.logDebug()
    this().resultHandler(
        onSuccess = { result ->
            if (haveDebug) (DebugMessage.SUCCESS + result).logDebug()
            onSuccess(result)
        },
        onEmpty = {
            if (haveDebug) DebugMessage.EMPTY.logDebug()
            onEmpty()
        },
        onError = { error ->
            if (haveDebug) (DebugMessage.ERROR + error.message).logDebug()
            onError(error)
        }
    )
}

inline fun <T> Result<T>.resultHandler(
    onSuccess: (T) -> Unit,
    onError: (Throwable) -> Unit,
    onEmpty: () -> Unit
) {
    onSuccess { value ->
        if (value is Collection<*>) {
            if (value.isEmpty()) onEmpty()
            else onSuccess(value)
        } else if (value is Map<*, *>) {
            if (value.isEmpty()) onEmpty()
            else onSuccess(value)
        } else if (value is Array<*>) {
            if (value.isEmpty()) onEmpty()
            else onSuccess(value)
        } else if (value.toString().isEmpty()) {
            onEmpty()
        } else {
            onSuccess(value)
        }
    }
    onFailure { error ->
        onError(error)
    }
}

sealed class Destinations(val route: String){

    object Main: Destinations(Routes.MAIN){

        fun templateRoute(): String{
            return route
        }

        fun requestRoute(): String{
            return route
        }

    }

}

object Routes {

    const val MAIN = "main"

}

@Composable
fun AppNavigation() {
    val systemUiController = rememberSystemUiController()
    val navController = rememberNavController()

    NavHost(
        modifier = Modifier.fillMaxSize().background(color = backColorPrimary),
        navController = navController,
        startDestination = Destinations.Main.route
    ){
        composable(Destinations.Main.route){ MainDest(navController) }
    }

    SideEffect {
        systemUiController.setSystemBarsColor(
            color = backColorPrimary,
            darkIcons = false
        )
    }
}
@Composable
fun TopBar(modifier: Modifier = Modifier, showFigures: () -> Unit) {
    Row(modifier = modifier, horizontalArrangement = Arrangement.End) {
        val iconPadding = 14.dp
        Icon(
            modifier = Modifier
                .padding(horizontal = iconPadding, vertical = iconPadding/2)
                .size(40.dp)
                .clickable {
                    showFigures()
                },
            imageVector = Icons.Outlined.Token, contentDescription = null,
            tint = onSurfaceColor
        )
    }
}
@Composable
fun MainContent(
    modifier: Modifier = Modifier,
    viewModel: MainViewModel,
    viewState: MainState
) {
    Canvas(modifier = modifier) {
        viewState.lines.forEach { line ->
            drawLine(
                color = line.color,
                start = line.start,
                end = line.end,
                strokeWidth = line.strokeWidth.toPx()
            )
        }
        drawFigures(
            figures = viewState.canvasFigures,
            onCircle = { offset ->
                drawCircle(color = primaryColor, radius = radius, center = offset)
            },
            onOval = { offset ->
                drawOval(color = primaryColor, size = size, topLeft = offset)
            },
            onRectangle = { offset ->
                drawRect(color = primaryColor, size = size, topLeft = offset)
            },
            onRoundedRectangle = { offset ->
                drawRoundRect(
                    color = primaryColor,
                    size = size,
                    topLeft = offset,
                    cornerRadius = CornerRadius(50F, 50F)
                )
            },
            onSquare = { offset ->
                drawRect(color = primaryColor, size = Size(length, length), topLeft = offset)
            }
        )
    }
}

inline fun DrawScope.drawFigures(
    figures: List<FigureController>,
    onCircle: Circle.(offset: Offset) -> Unit,
    onRectangle: Rectangle.(offset: Offset) -> Unit,
    onRoundedRectangle: RoundedRectangle.(offset: Offset) -> Unit,
    onSquare: Square.(offset: Offset) -> Unit,
    onOval: Oval.(offset: Offset) -> Unit,
) {
    figures.forEach { figureController ->
        when (figureController.figure) {
            is Circle -> {
                onCircle(figureController.figure, figureController.offset)
            }

            is Rectangle -> {
                onRectangle(figureController.figure, figureController.offset)
            }

            is Oval -> {
                onOval(figureController.figure, figureController.offset)
            }

            is RoundedRectangle -> {
                onRoundedRectangle(figureController.figure, figureController.offset)
            }

            is Square -> {
                onSquare(figureController.figure, figureController.offset)
            }

        }
    }
}
@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun FiguresBottomSheet(
    modifier: Modifier = Modifier,
    onDismiss: () -> Unit,
    bottomSheetState: SheetState,
    onFigureClick: (CanvasFigure) -> Unit
) {
    ModalBottomSheet(onDismissRequest = { onDismiss() }, sheetState = bottomSheetState) {
        Column(
            modifier = modifier,
            horizontalAlignment = Alignment.CenterHorizontally,
            verticalArrangement = Arrangement.spacedBy(14.dp)
        ) {
            CanvasFigure.entities.forEach { figure ->
                DrawModelFigure(
                    canvasFigure = figure,
                    color = primaryColor,
                    onClick = {
                        onFigureClick(figure)
                    }
                )
            }
        }
    }
}

@Composable
fun ColumnScope.DrawModelFigure(canvasFigure: CanvasFigure, color: Color, onClick: () -> Unit) {
    var rect: Rect? = null
    fun Modifier.figureModifier() = drawWithCache {
        onDrawBehind {
            rect = drawFigure(canvasFigure = canvasFigure, color = color)
        }
    }
    Box(
        modifier = Modifier
            .fillMaxWidth()
            .weight(1f)
            .pointerInput(Unit) {
                detectTapGestures { offset: Offset ->
                    if (rect?.isInsideRect(offset) == true) {
                        onClick()
                    }
                }
            }
            .figureModifier()
    )
}

fun DrawScope.drawFigure(canvasFigure: CanvasFigure, color: Color): Rect {
    val widthDividedTwo = size.width / 2
    val height = size.height

    val freeSpaceUnequal = size.width - widthDividedTwo
    val unequalSidesOffset = Offset.Zero.copy(x = freeSpaceUnequal / 2)

    val rectangleSize = Size(widthDividedTwo, height)

    return when (canvasFigure) {
        is Circle -> {
            drawCircle(
                color = color,
                radius = height / 2,
            )
            Rect(center, radius = height / 2)
        }

        is Rectangle -> {
            drawRect(
                color = color,
                size = rectangleSize,
                topLeft = unequalSidesOffset
            )
            Rect(unequalSidesOffset, rectangleSize)
        }

        is RoundedRectangle -> {
            drawRoundRect(
                color = color,
                size = rectangleSize,
                topLeft = unequalSidesOffset,
                cornerRadius = CornerRadius(height / 3, height / 3)
            )
            Rect(unequalSidesOffset, rectangleSize)
        }

        is Oval -> {
            drawOval(
                color = color,
                size = Size(widthDividedTwo, height),
                topLeft = unequalSidesOffset
            )
            Rect(unequalSidesOffset, rectangleSize)
        }

        is Square -> {
            val squareSize = size.copy(width = height)
            val squareOffset = Offset(x = (size.width - height) / 2, y = 0f)
            drawRect(color = color, size = squareSize, topLeft = squareOffset)
            Rect(squareOffset, rectangleSize)
        }
    }
}

fun Rect.isInsideRect(offset: Offset): Boolean {
    return contains(offset)
}


data class MainState(
    val screen: Screen = Screen(),
    val openBottomSheet: Boolean = false,
    val canvasFigures: List<FigureController> = emptyList(),
    val selectedFigure: Selected = Selected.None,
    val lines: List<Line> = listOf()
)

data class Line(
    val start: Offset,
    val end: Offset,
    val color: Color = primaryColor,
    val strokeWidth: Dp = 5.dp
)

sealed interface Selected {
    object None : Selected
    class Figure(val index: Int) : Selected
}

data class Screen(
    val size: Size = Size.Zero
)


@Stable
data class FigureController(
    val offset: Offset,
    val figure: CanvasFigure
)

@Stable
data class RoundedRectangle(
    val size: Size = Size.Zero
) : CanvasFigure()

@Stable
data class Oval(
    val size: Size = Size.Zero
) : CanvasFigure()

@Stable
data class Rectangle(
    val size: Size = Size.Zero
) : CanvasFigure()

@Stable
data class Circle(
    val radius: Float = 0f
) : CanvasFigure()

@Stable
data class Square(
    val length: Float = 0f
) : CanvasFigure() {

    val size = Size(length, length)

}

@Stable
sealed class CanvasFigure {
    companion object {
        val entities = listOf(
            Square(), Oval(), Circle(), Rectangle(), RoundedRectangle()
        )
    }
}

fun getRect(figureController: FigureController): Rect{
    return when (val figure = figureController.figure) {
        is Circle -> {
            Rect(figureController.offset, figure.radius)
        }

        is Oval -> {
            Rect(figureController.offset, figure.size)
        }

        is Rectangle -> {
            Rect(figureController.offset, figure.size)
        }

        is RoundedRectangle -> {
            Rect(figureController.offset, figure.size)
        }

        is Square -> {
            Rect(figureController.offset, figure.size)
        }
    }
}
sealed interface MainEffect {

}

@HiltViewModel
class MainViewModel @Inject constructor() : BaseViewModel<MainState, MainEffect>(MainState()) {
    fun dismissBottomSheet() = viewModelScope.launch {
        updateState {
            copy(
                openBottomSheet = false
            )
        }
    }

    fun showFigures() = viewModelScope.launch {
        updateState {
            copy(
                openBottomSheet = !openBottomSheet
            )
        }
    }

    fun init(size: Size) = viewModelScope.launch {
        updateState {
            copy(
                screen = Screen(size)
            )
        }
    }

    fun createFigure(figure: CanvasFigure) = viewModelScope.launch {

        val figureController = FigureController(
            offset = if (figure is Circle) Offset(100f, 100f) else Offset.Zero,
            figure = setFigureSize(figure)
        )
        addFigureController(figureController)
        dismissBottomSheet()
    }

    private fun setFigureSize(figure: CanvasFigure): CanvasFigure {
        val screenSize = state.screen.size
        val figureHeight = screenSize.width / 4.5f
        val figuresSize = Size(width = figureHeight * 2, height = figureHeight)
        return when (figure) {
            is Circle -> {
                figure.figureChanges {
                    copy(radius = figureHeight / 2)
                }
            }

            is Oval -> {
                figure.figureChanges {
                    copy(
                        size = figuresSize
                    )
                }
            }

            is Rectangle -> {
                figure.figureChanges {
                    copy(
                        size = figuresSize
                    )
                }
            }

            is RoundedRectangle -> {
                figure.figureChanges {
                    copy(
                        size = figuresSize
                    )
                }
            }

            is Square -> {
                figure.figureChanges {
                    copy(
                        length = figureHeight / 2
                    )
                }
            }
        }
    }

    private inline fun <T : CanvasFigure> T.figureChanges(newFigureBuilder: T.() -> T): T {
        return newFigureBuilder()
    }

    private fun addFigureController(figure: FigureController) {
        updateState {
            copy(
                canvasFigures = canvasFigures + figure
            )
        }
    }

    fun tappingScreen(tapOffset: Offset) {
        val nullableFigure = state.canvasFigures.firstOrNull { figure ->
            val rect: Rect = getRect(figure)
            rect.isInsideRect(tapOffset)
        }
        nullableFigure?.let { f ->
            val fIndex = state.canvasFigures.indexOf(f)
            updateState {
                copy(
                    selectedFigure = Selected.Figure(fIndex)
                )
            }
        } ?: updateState {
            copy(selectedFigure = Selected.None)
        }
        state.selectedFigure.logDebug()
    }

    fun dragFigure(dragAmount: Offset) {
        val selectedFigure = state.selectedFigure
        updateState {
            when (selectedFigure) {
                is Selected.Figure -> {
                    val oldFigureController = canvasFigures[selectedFigure.index]
                    val newFigureController = oldFigureController.copy(
                        offset = oldFigureController.offset + dragAmount
                    )
                    val mutableVersion = canvasFigures.toMutableList()
                    mutableVersion[selectedFigure.index] = newFigureController
                    copy(
                        canvasFigures = mutableVersion
                    )
                }

                Selected.None -> {
                    copy()
                }
            }
        }
    }


}
@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun MainScreen(viewModel: MainViewModel, viewState: MainState) {
    val bottomSheetState = rememberModalBottomSheetState()

    Scaffold(
        containerColor = backColorPrimary,
        topBar = {
            TopBar(
                modifier = Modifier.fillMaxWidth(),
                showFigures = {
                    viewModel.showFigures()
                }
            )
        }
    ) { paddingValues ->
        MainContent(
            modifier = Modifier
                .padding(paddingValues)
                .fillMaxSize()
                .pointerInput(Unit) {
                    detectTapGestures(
                        onPress = { tapOffset ->
                            viewModel.tappingScreen(tapOffset)
                        }
                    )
                }
                .pointerInput(Unit) {
                    detectDragGestures { _, dragAmount ->
                        viewModel.dragFigure(
                            dragAmount
                        )
                    }
                },
            viewModel = viewModel,
            viewState = viewState
        )
        if (viewState.openBottomSheet) {
            FiguresBottomSheet(
                modifier = Modifier
                    .padding(20.dp)
                    .fillMaxSize()
                    .verticalScroll(rememberScrollState()),
                onDismiss = {
                    viewModel.dismissBottomSheet()
                },
                bottomSheetState = bottomSheetState,
                onFigureClick = { figure ->
                    viewModel.createFigure(figure)
                }
            )
        }
    }
    LaunchedEffect(Unit) {
        viewModel.effects.collect { effect ->
            when (effect) {
                else -> {}
            }
        }
    }
}
@Composable
fun MainDest(navController: NavController){
    val configuration = LocalConfiguration.current
    val density = LocalDensity.current

    val mainViewModel = hiltViewModel<MainViewModel>()
    val viewState = mainViewModel.viewState.collectAsState().value
    MainScreen(viewModel = mainViewModel, viewState = viewState)

    LaunchedEffect(true) {
        val screen = with(density) {
            val heightPx = configuration.screenHeightDp.dp.roundToPx()
            val widthPx = configuration.screenWidthDp.dp.roundToPx()
            Size(width = widthPx.toFloat(), height = heightPx.toFloat())
        }
        mainViewModel.init(screen)
    }
}
"""
    }
    
    static func dependencies(_ mainData: MainData) -> ANDData {
        return ANDData(
            mainFragmentData: .init(
                imports: "",
                content: """
            AppNavigation()
"""),
            mainActivityData: .empty,
            themesData: .def,
            stringsData: .init(additional: ""),
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

plugins{
    id 'com.android.application'
    id 'org.jetbrains.kotlin.android'
    id 'kotlin-kapt'
    id 'dagger.hilt.android.plugin'
}

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
            signingConfig signingConfigs.debug
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
    //Base
    implementation Dependencies.core_ktx
    implementation Dependencies.appcompat
    implementation Dependencies.material
    
    //Compose
    implementation Dependencies.compose_ui
    implementation Dependencies.compose_preview
    implementation Dependencies.compose_material3
    implementation Dependencies.compose_activity
    implementation Dependencies.compose_ui_tooling
    implementation Dependencies.compose_navigation
    implementation Dependencies.compose_foundation
    implementation Dependencies.compose_runtime
    implementation Dependencies.compose_runtime_livedata
    implementation Dependencies.compose_mat_icons_core
    implementation Dependencies.compose_mat_icons_core_extended
    implementation Dependencies.compose_system_ui_controller

    //Other
    implementation Dependencies.coroutines
    implementation Dependencies.fragment_ktx
    implementation Dependencies.lifecycle_viewmodel
    implementation Dependencies.lifecycle_runtime

    //DI
    implementation Dependencies.dagger_hilt
    kapt Dependencies.dagger_hilt_compiler
    kapt Dependencies.hilt_viewmodel_compiler
    implementation Dependencies.compose_hilt_nav

    //Internet
    implementation Dependencies.retrofit
    implementation Dependencies.converter_gson
    implementation Dependencies.okhttp_login_interceptor

    //Room
    kapt Dependencies.room_compiler
    implementation Dependencies.room_runtime
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
