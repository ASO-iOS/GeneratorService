//
//  File.swift
//  
//
//  Created by admin on 11/13/23.
//

import Foundation

struct KDAffirmations: FileProviderProtocol {

    static var fileName: String = "\(NamesManager.shared.fileName).kt"
    
    static func fileContent(packageName: String, uiSettings: UISettings) -> String {
        return """
package \(packageName).presentation.fragments.main_fragment

import android.content.Context
import android.util.Log
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.verticalScroll
import androidx.compose.material3.CircularProgressIndicator
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.SideEffect
import androidx.compose.runtime.collectAsState
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.res.stringArrayResource
import androidx.compose.ui.text.TextStyle
import androidx.compose.ui.text.font.Font
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.font.toFontFamily
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.datastore.preferences.core.edit
import androidx.datastore.preferences.core.stringPreferencesKey
import androidx.datastore.preferences.preferencesDataStore
import androidx.hilt.navigation.compose.hiltViewModel
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import androidx.navigation.NavController
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import androidx.navigation.compose.rememberNavController
import \(packageName).R
import com.google.accompanist.systemuicontroller.rememberSystemUiController
import dagger.Module
import dagger.Provides
import dagger.hilt.InstallIn
import dagger.hilt.android.lifecycle.HiltViewModel
import dagger.hilt.android.qualifiers.ApplicationContext
import dagger.hilt.components.SingletonComponent
import kotlinx.coroutines.channels.Channel
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.flow.firstOrNull
import kotlinx.coroutines.flow.map
import kotlinx.coroutines.flow.receiveAsFlow
import kotlinx.coroutines.launch
import java.text.SimpleDateFormat
import java.util.Date
import java.util.Locale
import javax.inject.Inject
import javax.inject.Singleton

val backColorPrimary = Color(0xFF\(uiSettings.backColorPrimary ?? "FFFFFF"))
val textColorPrimary = Color(0xFF\(uiSettings.textColorPrimary ?? "FFFFFF"))

val defaultStyle = TextStyle(
    fontWeight = FontWeight.Normal,
    fontSize = 27.sp
)
sealed interface UIState{

    object Success: UIState
    object Error: UIState
    object Empty: UIState
    object Loading: UIState
    object None: UIState

}
abstract class BaseViewModel<State, Effect>(initState: State) : ViewModel() {

    private val _viewState: MutableStateFlow<State> = MutableStateFlow(initState)
    val viewState = _viewState.asStateFlow()

    private val _effects: Channel<Effect> = Channel()
    val effects: Flow<Effect> = _effects.receiveAsFlow()

    fun sendEffect(effect: Effect) = viewModelScope.launch {
        _effects.send(effect)
    }

    protected val state: State
        get() = viewState.value

    protected fun updateState(changeState: State.() -> State) {
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

interface DataStoreRepository {

    suspend fun readAffirmation(): String?

    suspend fun writeAffirmation(affirmation: String)

    fun getAllAffirmations(): Flow<List<String>>

}

@Module
@InstallIn(SingletonComponent::class)
class RepositoryModule {

    @Provides
    @Singleton
    fun provideDataStoreRepository(@ApplicationContext context: Context): DataStoreRepository {
        return DataStoreRepositoryImpl(context)
    }


}
const val APP = "App"

class DataStoreRepositoryImpl @Inject constructor(private val context: Context) :
    DataStoreRepository {

    private val Context.dataStore by preferencesDataStore(APP)
    private val currentDate = run {
        val date = SimpleDateFormat("yyyy-MM-dd", Locale.getDefault()).format(Date())
        stringPreferencesKey(date)
    }

    override suspend fun readAffirmation(): String? {
        return context.dataStore.data.map { preferences ->
            preferences[currentDate]
        }.firstOrNull()
    }

    override suspend fun writeAffirmation(affirmation: String) {
        context.dataStore.edit { mutablePreferences ->
            mutablePreferences[currentDate] = affirmation
        }
    }

    override fun getAllAffirmations(): Flow<List<String>> {
        return context.dataStore.data.map { preferences ->
            preferences.logDebug()
            val allData = mutableMapOf<String, String>()
            preferences.asMap().forEach { entry ->
                allData[entry.key.name] = entry.value.toString()
            }
            allData.map { it.value }.distinct()
        }
    }
}
@Composable
fun MainContent(
    modifier: Modifier = Modifier,
    viewModel: MainViewModel,
    viewState: MainState
) {
    Box(modifier = modifier, contentAlignment = Alignment.Center) {
        when (viewState.uiState) {
            UIState.Success -> Text(
                text = viewState.affirmation,
                color = textColorPrimary,
                style = defaultStyle,
                textAlign = TextAlign.Center
            )
            else -> {
                CircularProgressIndicator(
                    modifier = Modifier.size(50.dp),
                    strokeWidth = 4.dp,
                    color = textColorPrimary,
                )
            }
        }
    }
}
data class MainState(
    val affirmation: String = "Аффирмация",
    val uiState: UIState = UIState.Loading
)
sealed interface MainEffect {

    class ChoosingAffirmation(val usedAffirmations: List<String>): MainEffect

}

@HiltViewModel
class MainViewModel @Inject constructor(private val datastoreRepository: DataStoreRepository) :
    BaseViewModel<MainState, MainEffect>(MainState()) {


    init {
        loadAffirmation()
    }

    private fun loadAffirmation() = viewModelScope.launch {
        when (val affirmation = datastoreRepository.readAffirmation()) {
            null -> {
                datastoreRepository.getAllAffirmations().collect { allAffirmations ->
                    sendEffect(MainEffect.ChoosingAffirmation(allAffirmations))
                }
            }

            else -> {
                updateAffirmation(affirmation)
            }
        }
    }


    fun writeAffirmation(affirmation: String) = viewModelScope.launch {
        updateAffirmation(affirmation)
        datastoreRepository.writeAffirmation(affirmation)
    }

    private fun updateAffirmation(newAffirmation: String) = viewModelScope.launch {
        updateState {
            copy(
                affirmation = newAffirmation,
                uiState = UIState.Success
            )
        }
    }


}
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
                .verticalScroll(rememberScrollState())
                .padding(30.dp),
            viewModel = viewModel,
            viewState = viewState
        )
    }
    val allAffirmations = stringArrayResource(id = R.array.affirmations)
    LaunchedEffect(Unit) {
        viewModel.effects.collect { effect ->
            when (effect) {
                is MainEffect.ChoosingAffirmation -> {
                    chooseAffirmation(
                        allAffirmations = allAffirmations,
                        usedAffirmations = effect.usedAffirmations,
                        onWrite = { affirmation ->
                            viewModel.writeAffirmation(affirmation)
                        }
                    )
                }
            }
        }
    }
}

private fun chooseAffirmation(
    allAffirmations: Array<String>,
    usedAffirmations: List<String>,
    onWrite: (String) -> Unit
) {
    val noUsedAffirmations = allAffirmations.toSet() - usedAffirmations.toSet()
    if (noUsedAffirmations.isEmpty()) {
        val randomAffirmation = allAffirmations.random()
        onWrite(randomAffirmation)
    } else {
        val randomAffirmation = noUsedAffirmations.random()
        onWrite(randomAffirmation)
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
"""
    }
    
    static func dependencies(_ mainData: MainData) -> ANDData {
        return ANDData(
            mainFragmentData: .init(
                imports: "",
                content: """
  AppNavigation()
""")
            ,
            mainActivityData: .empty,
            themesData: .def,
            stringsData: .init(additional: """
    <string-array name="affirmations">
        <item>You are amazing!</item>
        <item>You are capable of great things.</item>
        <item>You have the power to change your life.</item>
        <item>Every day is a new opportunity.</item>
        <item>You are worthy of love and happiness.</item>
        <item>You are strong and resilient.</item>
        <item>Your potential is limitless.</item>
        <item>You radiate positivity.</item>
        <item>You attract success and abundance.</item>
        <item>You are a source of inspiration.</item>
        <item>You are a magnet for positive energy.</item>
        <item>You believe in your abilities and trust yourself.</item>
        <item>You embrace challenges as opportunities for growth.</item>
        <item>You are resilient and bounce back from setbacks.</item>
        <item>Your thoughts are powerful, and you focus on the positive ones.</item>
        <item>You are in control of your happiness and well-being.</item>
        <item>You attract abundance into your life with an open heart.</item>
        <item>You radiate confidence and self-assuredness.</item>
        <item>You are grateful for all the blessings in your life.</item>
        <item>You are kind, compassionate, and full of empathy.</item>
        <item>You let go of things that no longer serve your highest good.</item>
        <item>You are open to receiving love, joy, and success.</item>
        <item>You greet each day with enthusiasm and optimism.</item>
        <item>You are a source of positivity and inspiration to others.</item>
        <item>You visualize your dreams and work diligently to achieve them.</item>
        <item>You are surrounded by loving and supportive people.</item>
        <item>You trust that the universe is conspiring in your favor.</item>
        <item>You are the author of your own success story.</item>
        <item>You embrace change as an opportunity for personal growth.</item>
        <item>You are worthy of all the good things life has to offer.</item>
        <item>You are the architect of your destiny.</item>
        <item>You are constantly evolving and growing.</item>
        <item>You approach challenges with courage and determination.</item>
        <item>Your heart is full of love and compassion.</item>
        <item>You welcome abundance into every aspect of your life.</item>
        <item>You are a beacon of light in the world.</item>
        <item>You choose happiness and positivity every day.</item>
        <item>You trust the journey, even when it s uncertain.</item>
        <item>You are a magnet for success and prosperity.</item>
        <item>You embrace the beauty of the present moment.</item>
        <item>You are a source of strength for those around you.</item>
        <item>You have the wisdom to make the right decisions.</item>
        <item>You are open to new experiences and adventures.</item>
        <item>You radiate inner peace and tranquility.</item>
        <item>You celebrate your uniqueness and individuality.</item>
        <item>You attract loving and supportive relationships.</item>
        <item>You let go of past regrets and forgive yourself.</item>
        <item>You believe in your ability to overcome any obstacle.</item>
        <item>You are a magnet for good health and vitality.</item>
        <item>You trust in the timing of your life s journey.</item>
        <item>You are a channel for creativity and inspiration.</item>
        <item>You see opportunities in every challenge you face.</item>
        <item>You are a positive influence on those you meet.</item>
        <item>You release fear and welcome faith into your life.</item>
        <item>You are deserving of all the love in the world.</item>
        <item>You are a force for positive change in the world.</item>
        <item>You are at peace with your past and excited for your future.</item>
        <item>You are on the path to greatness and success.</item>
        <item>You are a source of joy and happiness to others.</item>
        <item>You are worthy of love and affection.</item>
        <item>You are becoming the best version of yourself.</item>
        <item>You are capable of achieving your goals.</item>
        <item>You attract positive people into your life.</item>
        <item>You radiate confidence and self-assurance.</item>
        <item>You are in control of your thoughts and emotions.</item>
        <item>You are at peace with your past.</item>
        <item>You are grateful for every day and every experience.</item>
        <item>You are open to new opportunities and adventures.</item>
        <item>You believe in your ability to overcome challenges.</item>
        <item>You trust the journey, even when it s difficult.</item>
        <item>You are kind, compassionate, and empathetic.</item>
        <item>You let go of negative thoughts and embrace positivity.</item>
        <item>You are a source of inspiration to others.</item>
        <item>You have a clear vision of your goals and dreams.</item>
        <item>You are resilient and can bounce back from setbacks.</item>
        <item>You are constantly growing and evolving.</item>
        <item>You are a magnet for abundance and success.</item>
        <item>You are surrounded by loving and supportive people.</item>
        <item>You embrace change as a natural part of life.</item>
        <item>You are mindful and live in the present moment.</item>
        <item>You are a beacon of light in the world.</item>
        <item>You attract joy and happiness into your life.</item>
        <item>You are a positive influence on those around you.</item>
        <item>You are the architect of your destiny.</item>
        <item>You are a vessel for creativity and inspiration.</item>
        <item>You are deserving of all the good things in life.</item>
        <item>You are open to receiving love and happiness.</item>
        <item>You are resilient and can handle anything that comes your way.</item>
        <item>You are a force for positive change in the world.</item>
        <item>You are constantly learning and growing.</item>
        <item>You trust your intuition and inner wisdom.</item>
        <item>You let go of fear and embrace faith.</item>
        <item>You are the author of your own success story.</item>
        <item>You are a magnet for good health and vitality.</item>
        <item>You are on the path to greatness and achievement.</item>
        <item>You are surrounded by beauty and abundance.</item>
        <item>You are a source of love and light.</item>
        <item>You believe in the power of your dreams.</item>
        <item>You attract opportunities for personal growth.</item>
        <item>You are grateful for the small moments of joy.</item>
        <item>You are a warrior, and you never give up.</item>
        <item>You are a positive force in the universe.</item>
        <item>You are a reflection of the love you give.</item>
        <item>You are a beacon of hope to those in need.</item>
        <item>You are a magnet for positive energy.</item>
        <item>You embrace the beauty of imperfection.</item>
        <item>You are a source of strength and courage.</item>
        <item>You are a vessel of peace and tranquility.</item>
    </string-array>
"""),
            colorsData: .empty)
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

plugins {
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
    implementation Dependencies.datastore

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

    const val datastore = "androidx.datastore:datastore-preferences:1.0.0"
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
