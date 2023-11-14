//
//  File.swift
//  
//
//  Created by admin on 11/13/23.
//

import Foundation

struct KDCalculator: FileProviderProtocol {
    
    static var fileName: String = "\(NamesManager.shared.fileName).kt"
    
    static func fileContent(packageName: String, uiSettings: UISettings) -> String {
        return """
package \(packageName).presentation.fragments.main_fragment


import android.util.Log
import androidx.annotation.StringRes
import androidx.compose.foundation.background
import androidx.compose.foundation.interaction.MutableInteractionSource
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.lazy.grid.GridCells
import androidx.compose.foundation.lazy.grid.LazyVerticalGrid
import androidx.compose.foundation.lazy.grid.items
import androidx.compose.foundation.text.BasicTextField
import androidx.compose.material3.ButtonDefaults
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.FilledTonalButton
import androidx.compose.material3.OutlinedTextFieldDefaults
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.SideEffect
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.remember
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.RectangleShape
import androidx.compose.ui.graphics.SolidColor
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.TextStyle
import androidx.compose.ui.text.font.Font
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.font.toFontFamily
import androidx.compose.ui.text.input.VisualTransformation
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.text.style.TextOverflow
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.hilt.navigation.compose.hiltViewModel
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import androidx.navigation.NavController
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import androidx.navigation.compose.rememberNavController
import \(packageName).R
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
val textColorPrimary = Color(0xFF\(uiSettings.textColorPrimary ?? "FFFFFF"))
val buttonColorPrimary = Color(0xFF\(uiSettings.buttonColorPrimary ?? "FFFFFF"))

val calcButton = TextStyle(
    fontSize = 30.sp,
    fontWeight = FontWeight.Bold,
)

val calcField = TextStyle(
    fontSize = 38.sp,
    fontWeight = FontWeight.Bold,
)

abstract class BaseViewModel<State, Effect>(initState: State): ViewModel() {

    private val _viewState: MutableStateFlow<State> = MutableStateFlow(initState)
    val viewState = _viewState.asStateFlow()

    private val _effects: Channel<Effect> = Channel()
    val effects: Flow<Effect> = _effects.receiveAsFlow()

    protected val state: State
        get() = viewState.value

    protected fun updateState(changeState: State.() -> State){
        _viewState.value = viewState.value.changeState()
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
fun CalculatorButton(
    modifier: Modifier = Modifier,
    element: CalculatorOperation,
    onClick: () -> Unit
) {

    @Composable
    fun LocalText(text: String) = Text(
        text = text,
        color = textColorPrimary,
        style = calcButton,
        maxLines = 1,
        overflow = TextOverflow.Ellipsis
    )
    FilledTonalButton(
        onClick = {
            onClick()
        },
        modifier = modifier,
        shape = RectangleShape,
        colors = ButtonDefaults.filledTonalButtonColors(
            containerColor = buttonColorPrimary,
            disabledContainerColor = buttonColorPrimary,
            contentColor = textColorPrimary,
            disabledContentColor = textColorPrimary
        ),
        contentPadding = PaddingValues(0.dp)
    )
    {
        if (element is CalculatorOperation.Operation) {
            LocalText(text = stringResource(element.text))
        } else if (element is CalculatorOperation.Digit) {
            LocalText(text = element.text.toString())
        }
    }
}
@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun CalculatorField(
    modifier: Modifier = Modifier,
    value: String,
    onValueChange: (String) -> Unit,
    textStyle: TextStyle,
    contentPadding: PaddingValues
) {
    val interactionSource = remember { MutableInteractionSource() }
    BasicTextField(
        modifier = modifier,
        value = value,
        onValueChange = onValueChange,
        interactionSource = interactionSource,
        textStyle = textStyle,
        cursorBrush = SolidColor(textColorPrimary),
        maxLines = 1,
        readOnly = true
    ) { innerTextField ->
        OutlinedTextFieldDefaults.DecorationBox(
            value = value,
            innerTextField = innerTextField,
            enabled = true,
            singleLine = false,
            visualTransformation = VisualTransformation.None,
            interactionSource = interactionSource,
            colors = OutlinedTextFieldDefaults.colors(
                unfocusedTextColor = textColorPrimary,
                focusedTextColor = textColorPrimary,
                cursorColor = textColorPrimary,
                unfocusedContainerColor = backColorPrimary,
                focusedContainerColor = backColorPrimary,
                unfocusedBorderColor = buttonColorPrimary,
                focusedBorderColor = buttonColorPrimary,

                ),
            contentPadding = contentPadding,
        )
    }

}
@Composable
fun MainContent(
    modifier: Modifier = Modifier,
    viewModel: MainViewModel,
    viewState: MainState
) {
    Column(modifier = modifier, verticalArrangement = Arrangement.Center) {
        CalculatorField(
            modifier = Modifier.fillMaxWidth(),
            value = viewState.calculatorField,
            onValueChange = { newText ->
                viewModel.changeField(newText)
            },
            textStyle = calcField.copy(color = textColorPrimary, textAlign = TextAlign.End),
            contentPadding = PaddingValues(horizontal = 12.dp, vertical = 26.dp)
        )
        LazyVerticalGrid(
            columns = GridCells.Fixed(4),
            contentPadding = PaddingValues(4.dp),
            verticalArrangement = Arrangement.spacedBy(3.dp),
            horizontalArrangement = Arrangement.spacedBy(3.dp)
        ) {
            items(viewState.calculatorOperations) { calculatorOperation ->
                CalculatorButton(
                    modifier = Modifier
                        .height(64.dp)
                        .weight(1f),
                    element = calculatorOperation, onClick = {
                        viewModel.handleCalcOperation(calculatorOperation)
                    }
                )
            }
        }
    }
}
sealed interface CalculatorOperation {

    enum class Digit(val text: Int) : CalculatorOperation {
        One(1), TWO(2), THREE(3),
        FOUR(4), Six(6), Seven(7),
        Eight(8), Nine(9), Zero(0)
    }

    enum class Operation(@StringRes val text: Int) : CalculatorOperation {
        Plus(text = R.string.plus), Minus(text = R.string.minus),
        Calculate(text = R.string.equality), Multiplication(R.string.multi),
        Division(R.string.division), Delete(R.string.ac), DeleteOne(R.string.delete_one)

    }

}

sealed interface MainEffect {

}

val baseOperations: List<CalculatorOperation> = CalculatorOperation.Operation.values()
    .toList() + CalculatorOperation.Digit.values().toList()

data class MainState(
    val calculatorOperations: List<CalculatorOperation> = baseOperations,
    val num1: Double = Double.NaN,
    val num2: Double = Double.NaN,
    val calculatorField: String = "",
    val lastOperation: Operators = Operators.None
)



@Composable
fun MainDest(navController: NavController){
    val mainViewModel = hiltViewModel<MainViewModel>()
    val viewState = mainViewModel.viewState.collectAsState().value
    MainScreen(
        viewModel = mainViewModel,
        viewState = viewState
    )
}
@Composable
fun MainScreen(viewModel: MainViewModel, viewState: MainState) {
    Scaffold(
        containerColor = backColorPrimary
    ) { paddingValues ->
        MainContent(
            modifier = Modifier
                .padding(paddingValues)
                .fillMaxSize()
                .padding(horizontal = 10.dp, vertical = 30.dp),
            viewModel = viewModel,
            viewState = viewState
        )
    }
    LaunchedEffect(Unit) {
        viewModel.effects.collect { effect ->
            when (effect) {
                else -> {}
            }
        }
    }
}

@HiltViewModel
class MainViewModel @Inject constructor() : BaseViewModel<MainState, MainEffect>(MainState()) {
    fun changeField(newText: String) = viewModelScope.launch {
        updateState {
            copy(
                calculatorField = newText
            )
        }
    }

    private fun clickedCalculate() = viewModelScope.launch {
        val num1 = state.num1
        val num2 = state.calculatorField.toDoubleOrNull() ?: 1.0
        val result = when (state.lastOperation) {
            Operators.Add -> num1 + num2
            Operators.Minus -> num1 - num2
            Operators.Multiply -> num1 * num2
            Operators.Divide -> num1 / num2
            else -> {
                0.0
            }
        }
        updateState {
            copy(
                calculatorField = result.toString(),
                num1 = Double.NaN,
                num2 = Double.NaN,
                lastOperation = Operators.None
            )
        }
    }

    private fun addMathOperation(operator: Operators) {
        if (state.lastOperation == Operators.None) {
            updateState {
                copy(
                    lastOperation = operator,
                    num1 = calculatorField.toDoubleOrNull() ?: 1.0,
                    calculatorField = ""
                )
            }
        } else {
            updateState {
                copy(
                    lastOperation = operator,
                )
            }
        }
    }

    fun handleCalcOperation(operation: CalculatorOperation) = viewModelScope.launch {
        val calculatorField = state.calculatorField
        when (operation) {
            is CalculatorOperation.Digit -> {
                updateState {
                    copy(
                        calculatorField = calculatorField + operation.text.toString(),
                    )
                }
            }

            CalculatorOperation.Operation.Plus -> {
                addMathOperation(Operators.Add)
            }

            CalculatorOperation.Operation.Minus -> {
                addMathOperation(Operators.Minus)
            }

            CalculatorOperation.Operation.Calculate -> {
                clickedCalculate()
            }

            CalculatorOperation.Operation.Multiplication -> {
                addMathOperation(Operators.Multiply)
            }

            CalculatorOperation.Operation.Division -> {
                addMathOperation(Operators.Divide)
            }

            CalculatorOperation.Operation.Delete -> {
                clearData()
            }

            CalculatorOperation.Operation.DeleteOne -> {
                deleteOne(calculatorField)
            }
        }
    }

    private fun clearData() {
        updateState {
            copy(
                calculatorField = "",
                num1 = Double.NaN,
                num2 = Double.NaN,
                lastOperation = Operators.None
            )
        }
    }

    private fun deleteOne(calculatorField: String) {
        if (calculatorField.isEmpty()) {
            updateState {
                copy(
                    lastOperation = Operators.None,
                    calculatorField = if (num1.isNaN()) "" else num1.toString()
                )
            }
        } else {
            updateState {
                copy(
                    calculatorField = calculatorField.dropLast(1),
                )
            }
        }
    }


}

enum class Operators {
    Add,
    None,
    Minus,
    Multiply,
    Divide,
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
            stringsData: .init(additional: """
    <string name="plus">+</string>
    <string name="minus">-</string>
    <string name="equality">=</string>
    <string name="multi">*</string>
    <string name="division">/</string>
    <string name="ac">AC</string>
    <string name="delete_one">&lt;-</string>
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
