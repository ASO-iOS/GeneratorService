//
//  File.swift
//  
//
//  Created by admin on 09.11.2023.
//

import Foundation

struct KDPedometer: FileProviderProtocol {
    static var fileName: String = "\(NamesManager.shared.fileName).kt"
    
    static func fileContent(packageName: String, uiSettings: UISettings) -> String {
        return """
package \(packageName).presentation.fragments.main_fragment

import androidx.lifecycle.viewModelScope
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.launch
import javax.inject.Inject
import kotlinx.coroutines.Dispatchers
import androidx.compose.runtime.Composable
import androidx.compose.runtime.collectAsState
import androidx.hilt.navigation.compose.hiltViewModel
import androidx.navigation.NavController
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.material3.Button
import androidx.compose.material3.ButtonDefaults
import androidx.compose.material3.Card
import androidx.compose.material3.CardDefaults
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Text
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import \(packageName).R
import android.content.Context
import android.hardware.Sensor
import android.hardware.SensorEvent
import android.hardware.SensorEventListener
import android.hardware.SensorManager
import dagger.hilt.android.qualifiers.ApplicationContext
import androidx.compose.runtime.LaunchedEffect
import com.google.accompanist.systemuicontroller.rememberSystemUiController
import android.os.Build
import androidx.activity.result.contract.ActivityResultContracts
import androidx.compose.foundation.layout.size
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.rounded.DoNotStep
import androidx.compose.material3.Icon
import androidx.compose.ui.unit.sp
import android.Manifest.permission.ACTIVITY_RECOGNITION
import com.google.accompanist.permissions.ExperimentalPermissionsApi
import com.google.accompanist.permissions.PermissionState
import com.google.accompanist.permissions.isGranted
import com.google.accompanist.permissions.rememberPermissionState
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import androidx.navigation.compose.rememberNavController
import androidx.datastore.preferences.core.booleanPreferencesKey
import androidx.datastore.preferences.core.edit
import androidx.datastore.preferences.preferencesDataStore
import kotlinx.coroutines.flow.firstOrNull
import kotlinx.coroutines.flow.map
import dagger.Module
import dagger.Provides
import dagger.hilt.InstallIn
import dagger.hilt.components.SingletonComponent
import javax.inject.Singleton
import androidx.lifecycle.ViewModel
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.asStateFlow
import android.util.Log
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.TextStyle
import androidx.compose.ui.text.font.Font
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.font.toFontFamily

val backColorPrimary = Color(0xFF\(uiSettings.backColorPrimary ?? "FFFFFF"))
val primaryColor = Color(0xFF\(uiSettings.primaryColor ?? "FFFFFF"))
val onPrimaryColor = Color(0xFF\(uiSettings.onPrimaryColor ?? "FFFFFF"))
val textColorPrimary = Color(0xFF\(uiSettings.textColorPrimary ?? "FFFFFF"))

val welcomeDesc = TextStyle(
    fontWeight = FontWeight.Medium,
    fontSize = 22.sp
)

val welcome = TextStyle(
    fontWeight = FontWeight.Medium,
    fontSize = 30.sp
)

val button = TextStyle(
    fontWeight = FontWeight.Medium,
    fontSize = 30.sp
)

val steps = TextStyle(
    fontWeight = FontWeight.Normal,
    fontSize = 80.sp
)

val baseShape = RoundedCornerShape(20.dp)


const val DEBUG = "AppDebug"

fun Any?.logDebug(){
    if(this is Throwable?){
        Log.e(DEBUG, toString())
    }else{
        Log.i(DEBUG, toString())
    }
}


object DebugMessage {
    const val LOADING = "Loading"
    const val SUCCESS = "Success: "
    const val ERROR = "Error: "
    const val EMPTY = "Empty"
}



suspend inline fun<T> Result<T>.loadAndHandleData(
    haveDebug: Boolean = false,
    onSuccess: (T) -> Unit = {},
    onEmpty: () -> Unit = {},
    onError: (Throwable) -> Unit = {},
    onLoading: () -> Unit = {}
) {
    onLoading()
    if(haveDebug) DebugMessage.LOADING.logDebug()
    resultHandler(
        onSuccess = {result ->
            if(haveDebug) (DebugMessage.SUCCESS + result).logDebug()
            onSuccess(result)
        },
        onEmpty = {
            if(haveDebug) DebugMessage.EMPTY.logDebug()
            onEmpty()
        },
        onError = {error ->
            if(haveDebug) (DebugMessage.ERROR + error.message).logDebug()
            onError(error)
        }
    )
}

inline fun<T> Result<T>.resultHandler(
    onSuccess: (T) -> Unit,
    onError: (Throwable) -> Unit,
    onEmpty: () -> Unit
){
    onSuccess { value ->
        if(value is Collection<*>){
            if(value.isEmpty()) onEmpty()
        }
        else if(value is Map<*,*>){
            if(value.isEmpty()) onEmpty()
        }
        else if(value is Array<*>){
            if(value.isEmpty()) onEmpty()
        }
        else if(value.toString().isEmpty()){
            onEmpty()
        }
        else{
            onSuccess(value)
        }
    }
    onFailure { error ->
        onError(error)
    }
}


abstract class BaseViewModel<State>(initState: State): ViewModel() {

    private val _viewState: MutableStateFlow<State> = MutableStateFlow(initState)
    val viewState = _viewState.asStateFlow()

    protected val stateValue: State
        get() = viewState.value

    protected fun updateState(changeState: State.() -> State){
        _viewState.value = viewState.value.changeState()
    }



}

@Module
@InstallIn(SingletonComponent::class)
object DataStoreModule {


    @Singleton
    @Provides
    fun provideDataStore(@ApplicationContext context: Context): MyDataStore {
        return MyDataStore(context)
    }

}

const val APP = "App"
const val WELCOME = "welcome"


class MyDataStore(private val context: Context) {

    private val Context.dataStore by preferencesDataStore(APP)
    private val welcomeKey = booleanPreferencesKey(WELCOME)
    suspend fun readWelcome(): Boolean = context.dataStore.data.map { preferences ->
        preferences[welcomeKey]
    }.firstOrNull() ?: true

    suspend fun writeWelcome(haveWelcome: Boolean) {
        context.dataStore.edit { mutablePreferences ->
            mutablePreferences[welcomeKey] = haveWelcome
        }
    }
}
sealed class Destinations(val route: String){

    object Main: Destinations(Routes.MAIN)
    object Welcome: Destinations(Routes.WELCOME)

}

object Routes {

    const val MAIN = "main"
    const val WELCOME = "welcome"

}

@Composable
fun AppNavigation(modifier: Modifier = Modifier, haveWelcome: Boolean) {
    val systemUiController = rememberSystemUiController()
    val navController = rememberNavController()
    val startDestination = if (haveWelcome) Destinations.Welcome.route else Destinations.Main.route

    NavHost(
        modifier = modifier,
        navController = navController,
        startDestination = startDestination
    ) {
        composable(Destinations.Main.route) { MainDest(navController) }
        composable(Destinations.Welcome.route) { WelcomeDest(navController) }
    }

    LaunchedEffect(key1 = Unit) {
        systemUiController.setSystemBarsColor(
            color = primaryColor,
            darkIcons = false
        )
    }
}
data class MainState(
    val steps: Int = 0
)
@OptIn(ExperimentalPermissionsApi::class)
@Composable
fun MainScreen(viewModel: MainViewModel, viewState: MainState) {
    ActivityResultContracts.RequestPermission()
    val permission: PermissionState = rememberPermissionState(ACTIVITY_RECOGNITION)
    if(permission.status.isGranted || Build.VERSION.SDK_INT < Build.VERSION_CODES.Q) {
        Scaffold(
            containerColor = backColorPrimary
        ) { paddingValues ->
            Column(
                modifier = Modifier
                    .padding(paddingValues)
                    .fillMaxSize()
                    .padding(horizontal = 30.dp),
                verticalArrangement = Arrangement.Center,
                horizontalAlignment = Alignment.CenterHorizontally
            ) {
                Icon(
                    imageVector = Icons.Rounded.DoNotStep, contentDescription = null,
                    tint = primaryColor,
                    modifier = Modifier.size(300.dp)
                )
                Text(
                    text = viewState.steps.toString(),
                    color = primaryColor,
                    style = steps
                )
                Text(
                    text = stringResource(R.string.steps),
                    color = primaryColor,
                    style = steps.copy(fontSize = 100.sp)
                )
            }
        }
    }else{
        LaunchedEffect(key1 = Unit) {
            permission.launchPermissionRequest()
        }
    }
}
@Composable
fun MainDest(navController: NavController){
    val systemUiController = rememberSystemUiController()
    val mainViewModel = hiltViewModel<MainViewModel>()
    val viewState = mainViewModel.viewState.collectAsState().value
    MainScreen(viewModel = mainViewModel, viewState = viewState)
    LaunchedEffect(key1 = Unit) {
        systemUiController.setSystemBarsColor(
            color = onPrimaryColor,
            darkIcons = false
        )
    }
}

@HiltViewModel
class MainViewModel @Inject constructor(@ApplicationContext context: Context) :
    BaseViewModel<MainState>(MainState()), SensorEventListener {

    private var sensorManager: SensorManager =
        context.getSystemService(Context.SENSOR_SERVICE) as SensorManager

    init {
        sensorManager.registerListener(
            this@MainViewModel,
            sensorManager.getDefaultSensor(Sensor.TYPE_STEP_COUNTER),
            SensorManager.SENSOR_DELAY_UI
        )
    }

    override fun onSensorChanged(p0: SensorEvent?) {
        val totalSteps = p0?.values?.get(0) ?: 0
        updateState {
            copy(
                steps = totalSteps.toInt()
            )
        }
    }

    override fun onAccuracyChanged(p0: Sensor?, p1: Int) {

    }

}
data class WelcomeState(
    val data: Any = Any()
)

@Composable
fun WelcomeScreen(
    viewModel: WelcomeViewModel,
    viewState: WelcomeState,
    navController: NavController
) {
    Scaffold(
        containerColor = primaryColor
    ) { paddingValues ->
        Column(
            modifier = Modifier
                .fillMaxSize()
                .padding(paddingValues),
            horizontalAlignment = Alignment.CenterHorizontally,
            verticalArrangement = Arrangement.Center,

            ) {
            Card(
                modifier = Modifier.padding(horizontal = 20.dp),
                shape = baseShape,
                colors = CardDefaults.cardColors(
                    containerColor = onPrimaryColor,
                    disabledContainerColor = onPrimaryColor
                ),
                elevation = CardDefaults.cardElevation(
                    defaultElevation = 3.dp
                )
            ) {
                Text(
                    modifier = Modifier
                        .padding(top = 30.dp)
                        .align(Alignment.CenterHorizontally),
                    text = stringResource(R.string.welcome),
                    color = textColorPrimary, style = welcome.copy(textAlign = TextAlign.Center)
                )
                Text(
                    modifier = Modifier
                        .padding(horizontal = 20.dp)
                        .padding(top = 10.dp),
                    text = stringResource(R.string.welcome_desc),
                    color = textColorPrimary, style = welcomeDesc.copy(textAlign = TextAlign.Center)
                )
                Spacer(modifier = Modifier.height(20.dp))
                Button(
                    modifier = Modifier
                        .padding(horizontal = 40.dp)
                        .padding(bottom = 30.dp)
                        .height(80.dp)
                        .fillMaxWidth(),
                    onClick = {
                        viewModel.writeToDatastore()
                        navController.navigate(Destinations.Main.route)
                    },
                    shape = baseShape,
                    contentPadding = PaddingValues(14.dp),
                    colors = ButtonDefaults.buttonColors(
                        containerColor = primaryColor,
                        disabledContainerColor = primaryColor
                    )
                ) {
                    Text(
                        text = stringResource(R.string.Сontinue),
                        style = button,
                        color = textColorPrimary
                    )
                }

            }

        }
    }
}
@Composable
fun WelcomeDest(navController: NavController) {
    val viewModel = hiltViewModel<WelcomeViewModel>()
    val viewState = viewModel.viewState.collectAsState().value
    WelcomeScreen(viewModel = viewModel, viewState = viewState, navController = navController)
}
@HiltViewModel
class WelcomeViewModel @Inject constructor(private val myDataStore: MyDataStore) :
    BaseViewModel<WelcomeState>(WelcomeState()) {

    fun writeToDatastore() = viewModelScope.launch(Dispatchers.IO) {
        myDataStore.writeWelcome(false)
    }

}
sealed interface UIState{

    interface Success: UIState
    interface Error: UIState
    interface Empty: UIState
    interface Loading: UIState
    interface None: UIState

}
data class ActivityModel(
    val welcome: Boolean = true,
    val dataUploaded: Boolean = false
)


@HiltViewModel
class ActivityViewModel @Inject constructor(private val myDataStore: MyDataStore) :
    BaseViewModel<ActivityModel>(ActivityModel()) {

    init {
        loadHaveWelcome()
    }

    private fun loadHaveWelcome() = viewModelScope.launch {
        val welcome = myDataStore.readWelcome()
        updateState {
            copy(
                welcome = welcome,
                dataUploaded = true
            )
        }
    }

}
"""
    }
    
    static func cmaHandler(_ mainData: MainData) -> ANDMainFragmentCMF {
        return .init(
            content: """
package \(mainData.packageName).presentation.main_activity

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.viewModels
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.ui.Modifier
import androidx.lifecycle.Lifecycle
import androidx.lifecycle.lifecycleScope
import androidx.lifecycle.repeatOnLifecycle
import dagger.hilt.android.AndroidEntryPoint
import kotlinx.coroutines.launch
import \(mainData.packageName).presentation.fragments.main_fragment.ActivityViewModel
import \(mainData.packageName).presentation.fragments.main_fragment.AppNavigation
import \(mainData.packageName).presentation.fragments.main_fragment.backColorPrimary

@AndroidEntryPoint
class MainActivity : ComponentActivity() {

    private val activityViewModel: ActivityViewModel by viewModels()
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        lifecycleScope.launch {
            repeatOnLifecycle(Lifecycle.State.STARTED) {
                activityViewModel.viewState.collect { activityModel ->
                    if (activityModel.dataUploaded) {
                        setContent {
                            AppNavigation(
                                modifier = Modifier
                                    .fillMaxSize()
                                    .background(color = backColorPrimary),
                                activityModel.welcome
                            )
                        }
                    }
                }
            }
        }

    }
}
""",
            fileName: "MainActivity.kt"
        )
    }
    
    static func dependencies(_ mainData: MainData) -> ANDData {
        return .init(
            mainFragmentData: .empty,
            mainActivityData: .empty,
            themesData: .def,
            stringsData: .init(additional: """
    <string name="welcome_desc">Greetings to you user. This application will help you find out the number of steps completed in a day. In the future, your location data will be needed, if you agree, then click continue.</string>
    <string name="Сontinue">Сontinue</string>
    <string name="welcome">Welcome</string>
    <string name="steps">Steps</string>
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
    //implementation Dependencies.compose_material
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

    implementation Dependencies.compose_permissions

    //Other
    implementation Dependencies.coroutines
    implementation Dependencies.fragment_ktx
    implementation Dependencies.lifecycle_viewmodel
    implementation Dependencies.lifecycle_runtime
    implementation "androidx.datastore:datastore-preferences:1.0.0"

    //DI
    implementation Dependencies.dagger_hilt
    kapt Dependencies.dagger_hilt_compiler
    kapt Dependencies.hilt_viewmodel_compiler
    implementation Dependencies.compose_hilt_nav

    //Internet
    implementation Dependencies.retrofit
    implementation Dependencies.converter_gson

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
