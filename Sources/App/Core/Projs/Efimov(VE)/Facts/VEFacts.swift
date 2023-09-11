//
//  File.swift
//  
//
//  Created by admin on 01.08.2023.
//

import Foundation

struct VEFacts: FileProviderProtocol {
    static var fileName = "\(NamesManager.shared.fileName).kt"
    
    static func fileContent(packageName: String, uiSettings: UISettings) -> String {
        return """
package \(packageName).presentation.fragments.main_fragment

import android.content.Context
import android.os.Build
import androidx.annotation.Keep
import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.clickable
import androidx.compose.foundation.isSystemInDarkTheme
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.lazy.LazyRow
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.ArrowBack
import androidx.compose.material.icons.filled.ArrowForward
import androidx.compose.material.icons.filled.QuestionMark
import androidx.compose.material.icons.filled.Refresh
import androidx.compose.material.icons.filled.Settings
import androidx.compose.material3.Button
import androidx.compose.material3.ButtonDefaults
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.LinearProgressIndicator
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.material3.Typography
import androidx.compose.material3.darkColorScheme
import androidx.compose.material3.dynamicDarkColorScheme
import androidx.compose.material3.dynamicLightColorScheme
import androidx.compose.material3.lightColorScheme
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.State
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.toArgb
import androidx.compose.ui.graphics.vector.ImageVector
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
import androidx.lifecycle.viewModelScope
import androidx.navigation.NavController
import androidx.navigation.NavGraphBuilder
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import androidx.navigation.compose.rememberNavController
import com.google.gson.annotations.SerializedName
import \(packageName).R
import dagger.Module
import dagger.Provides
import dagger.hilt.InstallIn
import dagger.hilt.android.lifecycle.HiltViewModel
import dagger.hilt.android.qualifiers.ApplicationContext
import dagger.hilt.components.SingletonComponent
import kotlinx.coroutines.CoroutineDispatcher
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.delay
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import retrofit2.Retrofit
import retrofit2.converter.gson.GsonConverterFactory
import retrofit2.http.GET
import java.io.IOException
import javax.inject.Inject
import javax.inject.Singleton

val backColorPrimary = Color(0xFF\(uiSettings.backColorPrimary ?? "FFFFFF"))
val backColorSecondary = Color(0xFF\(uiSettings.backColorSecondary ?? "FFFFFF"))
val textColorPrimary = Color(0xFF\(uiSettings.textColorPrimary ?? "FFFFFF"))
val surfaceColor = Color(0xFF\(uiSettings.surfaceColor ?? "FFFFFF"))

//other app colors
val Grey = Color(0xFF7A7A7A)
val PurpleGrey80 = Color(0xFFCCC2DC)
val Purple = Color(0xFFE800FF)

val LightGreen = Color(0xFF9CCC65)
val LightOrange = Color(0xFFFFCA28)
val LightRed = Color(0xFFEF5350)

val BoxColors = listOf(LightGreen, LightOrange, LightRed)
val TextColors = listOf(Grey, PurpleGrey80, Color.Black, Purple)

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
fun EverydayFactsTheme(
    content: @Composable () -> Unit
) {
    MaterialTheme(
        typography = Typography,
        content = content
    )
}

data class AppConfiguration(
    val colorsConfig: ColorsConfiguration,
    val todayFact: Fact?
)

class AppConfigurationProvider @Inject constructor(
    @ApplicationContext val context: Context
) {
    private val sharedPrefs = context.getSharedPreferences(Keys.sharedPrefsKey, Context.MODE_PRIVATE)

    private val backgroundColorValue get() = sharedPrefs.getInt(Keys.backgroundKey, Defaults.defaultBackgroundKey)
    private val textColorValue get() = sharedPrefs.getInt(Keys.textColorKey, Defaults.defaultTextColorKey)
    private val todayFactValue get() = sharedPrefs.getString(Keys.todayFactKey, null)

    val configuration get() = AppConfiguration(
        colorsConfig = ColorsConfiguration(
            backgroundColor = Color(backgroundColorValue),
            textColor = Color(textColorValue),
        ),
        todayFact = todayFactValue?.let { Fact(it) }
    )

    fun saveConfiguration(
        newBackgroundColor: Color? = null,
        newTextColor: Color? = null
    ) {
        newBackgroundColor?.let {
            sharedPrefs.edit()
                .putInt(Keys.backgroundKey, it.toArgb())
                .apply()
        }

        newTextColor?.let {
            sharedPrefs.edit()
                .putInt(Keys.textColorKey, it.toArgb())
                .apply()
        }
    }

    fun saveTodayFact(fact: Fact) {
        sharedPrefs.edit()
            .putString(Keys.todayFactKey, fact.fact)
            .apply()
    }

    private object Keys {
        const val backgroundKey = "background_key"
        const val textColorKey = "text_key"
        const val sharedPrefsKey = "sharedPrefs"
        const val todayFactKey = "todayFact"
    }

    object Defaults {
        val defaultBackgroundKey = LightGreen.toArgb()
        val defaultTextColorKey = Color.Black.toArgb()
    }
}

data class ColorsConfiguration(
    val backgroundColor: Color = Color(AppConfigurationProvider.Defaults.defaultBackgroundKey),
    val textColor: Color = Color(AppConfigurationProvider.Defaults.defaultTextColorKey)
)

@Keep
data class FactDto(
    @SerializedName(value = "fact") val fact: String,
    @SerializedName(value = "length") val length: Int
)

class FactRepositoryImpl(
    private val api: FactApi
): FactRepository {

    override suspend fun fetchRandomFact(): Fact {
        return api.fetchRandomFact().toFact()
    }
}

fun FactDto.toFact() = Fact(fact = fact)

object Endpoints {
    const val BASE_URL = "https://catfact.ninja/"
    const val FACT_ENDPOINT = "/fact"
}

interface FactApi {

    @GET(Endpoints.FACT_ENDPOINT)
    suspend fun fetchRandomFact(): FactDto


}

@Module
@InstallIn(SingletonComponent::class)
class DataModule {

    @Provides
    @Singleton
    fun provideFactApi(): FactApi {
        return Retrofit.Builder()
            .baseUrl(Endpoints.BASE_URL)
            .addConverterFactory(GsonConverterFactory.create())
            .build()
            .create(FactApi::class.java)
    }

    @Provides
    @Singleton
    fun provideFactRepository(api: FactApi): FactRepository {
        return FactRepositoryImpl(api = api)
    }

    @Provides
    @Singleton
    fun provideCoroutineDispatcher() = Dispatchers.IO
}

data class Fact(
    val fact: String
)

interface FactRepository {
    suspend fun fetchRandomFact(): Fact
}

class FetchRandomFactUseCase @Inject constructor(
    private val repository: FactRepository,
    private val dispatcher: CoroutineDispatcher
) {

    suspend operator fun invoke(): Result<Fact> =
        kotlin.runCatching {
            withContext(dispatcher) {
                repository.fetchRandomFact()
            }
        }
}

class FetchTodayFactUseCase @Inject constructor(
    private val appConfigurationProvider: AppConfigurationProvider,
    private val dispatcher: CoroutineDispatcher
) {
    suspend operator fun invoke(): Result<Fact?> =
        kotlin.runCatching { withContext(dispatcher) { appConfigurationProvider.configuration.todayFact } }
}

class SaveTodayFactUseCase @Inject constructor(
    private val appConfigurationProvider: AppConfigurationProvider,
    private val dispatcher: CoroutineDispatcher
) {
    suspend operator fun invoke(fact: Fact) {
        withContext(dispatcher) { appConfigurationProvider.saveTodayFact(fact) }
    }
}

class FetchColorsUseCase @Inject constructor(
    private val appConfigurationProvider: AppConfigurationProvider,
    private val dispatcher: CoroutineDispatcher
) {
    suspend operator fun invoke(): Result<ColorsConfiguration> =
        kotlin.runCatching {
            withContext(dispatcher) {
                appConfigurationProvider.configuration.colorsConfig
            }
        }
}

class UpdateColorsUseCase @Inject constructor(
    private val appConfigurationProvider: AppConfigurationProvider,
    private val dispatcher: CoroutineDispatcher
) {
    suspend operator fun invoke(
        newBackgroundColor: Color? = null,
        newTextColor: Color? = null
    ) {
        withContext(dispatcher) {
            appConfigurationProvider.saveConfiguration(
                newBackgroundColor = newBackgroundColor,
                newTextColor = newTextColor
            )
        }
    }
}

fun NavGraphBuilder.splashScreen(navController: NavController) {
    composable(route = Screen.Splash.route) {
        SplashScreen {
            navController.navigate(Screen.FactScreen.route) {
                popUpTo(0) { inclusive = true}
            }
        }
    }
}

fun NavGraphBuilder.factScreen(navController: NavController) {
    composable(route = Screen.FactScreen.route) {
        val viewModel = hiltViewModel<FactViewModel>()

        FactScreen(
            uiState = viewModel.state.value,
            configuration = viewModel.colorsState.value,
            onSettingsPressed = {
                navController.navigate(Screen.Settings.route) {
                    popUpTo(Screen.FactScreen.route) { inclusive = true }
                }
            },
            onNextFactPressed = viewModel::fetchRandomFact,
            onRefreshPressed = viewModel::fetchRandomFact
        )
    }
}

fun NavGraphBuilder.settingsScreen(navController: NavController) {
    composable(route = Screen.Settings.route) {
        val viewModel = hiltViewModel<SettingsViewModel>()

        SettingsScreen(
            colorConfiguration = viewModel.colorState.value,
            onBackPressed = {
                navController.navigate(Screen.FactScreen.route) {
                    popUpTo(0) { inclusive = true }
                }
            },
            onTextColorChanged = { viewModel.updateColors(textColor = it) },
            onBackgroundChanged = { viewModel.updateColors(backgroundColor = it) }
        )
    }
}

@Composable
fun Router() {
    EverydayFactsTheme {
        Surface(
            modifier = Modifier.fillMaxSize(),
            color = backColorPrimary
        ) {
            val navController = rememberNavController()

            NavHost(
                navController = navController,
                startDestination = Screen.Splash.route
            ) {
                splashScreen(navController)
                factScreen(navController)
                settingsScreen(navController)
            }
        }
    }
}

sealed class Screen(val route: String) {
    object Splash: Screen(route = "splash_screen")
    object FactScreen: Screen(route = "fact_screen")
    object Settings: Screen(route = "settings_screen")
}

@Composable
fun MaterialButton(
    action: () -> Unit,
    resId: Int? = null,
    icon: ImageVector,
    configuration: ColorsConfiguration
) {
    Button(
        onClick = action,
        colors = ButtonDefaults.buttonColors(
            containerColor = surfaceColor
        ),
        contentPadding = ButtonDefaults.ButtonWithIconContentPadding
    ) {
        resId?.let {
            Text(
                text = stringResource(id = it),
                style = MaterialTheme.typography.titleLarge,
                color = textColorPrimary
            )
            Spacer(modifier = Modifier.width(ButtonDefaults.IconSpacing))
        }

        Icon(
            modifier = Modifier.size(20.dp),
            imageVector = icon,
            contentDescription = null,
            tint = textColorPrimary
        )
    }
}

@Composable
fun FactScreen(
    uiState: UiFactState,
    configuration: ColorsConfiguration,
    onNextFactPressed: () -> Unit,
    onSettingsPressed: () -> Unit,
    onRefreshPressed: () -> Unit
) {
    Column(
        modifier = Modifier
            .fillMaxSize()
            .background(backColorPrimary)
            .padding(5.dp),
        horizontalAlignment = Alignment.CenterHorizontally,
        verticalArrangement = Arrangement.spacedBy(10.dp, Alignment.CenterVertically)
    ) {
        when(uiState) {
            is UiFactState.Loading -> ShowLoader()
            is UiFactState.Error -> ShowErrorMessage(
                idRes = uiState.messageResId,
                configuration = configuration,
                onRefreshPressed = onRefreshPressed
            )
            is UiFactState.Success -> ShowFact(
                fact = uiState.fact,
                configuration = configuration,
                onNextFactPressed = onNextFactPressed
            )
        }

        MaterialButton(
            action = onSettingsPressed,
            configuration = configuration,
            resId = R.string.settings,
            icon = Icons.Default.Settings
        )
    }
}

@Composable
private fun ShowFact(
    fact: Fact,
    configuration: ColorsConfiguration,
    onNextFactPressed: () -> Unit
) {
    Column(
        modifier = Modifier
            .fillMaxWidth()
            .padding(horizontal = 5.dp),
        horizontalAlignment = Alignment.CenterHorizontally,
        verticalArrangement = Arrangement.spacedBy(10.dp, Alignment.CenterVertically)
    ) {
        Text(
            modifier = Modifier
                .clip(shape = RoundedCornerShape(20))
                .background(surfaceColor)
                .padding(vertical = 30.dp, horizontal = 5.dp),
            text = fact.fact,
            style = MaterialTheme.typography.titleLarge,
            color = textColorPrimary,
            textAlign = TextAlign.Center
        )

        MaterialButton(
            action = onNextFactPressed,
            resId = R.string.next,
            icon = Icons.Default.ArrowForward,
            configuration = configuration
        )
    }
}

@Composable
private fun ShowLoader() {
    LinearProgressIndicator()
}

@Composable
private fun ShowErrorMessage(
    configuration: ColorsConfiguration,
    idRes: Int,
    onRefreshPressed: () -> Unit
) {
    Column(
        modifier = Modifier
            .clip(shape = RoundedCornerShape(20))
            .background(configuration.backgroundColor)
            .padding(10.dp),
        horizontalAlignment = Alignment.CenterHorizontally,
        verticalArrangement = Arrangement.spacedBy(10.dp)
    ) {
        Text(
            modifier = Modifier.padding(horizontal = 20.dp),
            text = stringResource(id = idRes),
            style = MaterialTheme.typography.titleLarge,
            color = textColorPrimary
        )
        IconButton(onClick = onRefreshPressed) {
            Icon(
                modifier = Modifier.size(60.dp),
                imageVector = Icons.Default.Refresh,
                contentDescription = null,
                tint = textColorPrimary
            )
        }
    }
}

@HiltViewModel
class FactViewModel @Inject constructor(
    private val fetchRandomFactUseCase: FetchRandomFactUseCase,
    private val fetchTodayFactUseCase: FetchTodayFactUseCase,
    private val saveTodayFactUseCase: SaveTodayFactUseCase,
    private val fetchColorsUseCase: FetchColorsUseCase
): ViewModel() {
    private val _state = mutableStateOf<UiFactState>(UiFactState.Loading)
    val state: State<UiFactState> = _state

    private val _colorsState = mutableStateOf(ColorsConfiguration())
    val colorsState: State<ColorsConfiguration> = _colorsState

    init {
        fetchTodayFact()
        fetchColors()
    }

    private fun fetchTodayFact() {
        viewModelScope.launch {
            fetchTodayFactUseCase()
                .onSuccess {  todayFact ->
                    if(todayFact != null)
                        _state.value = UiFactState.Success(todayFact)
                    else
                        fetchRandomFact()
                }
                .onFailure { throwable ->
                    val idRes = when(throwable) {
                        is IOException -> R.string.internet_error
                        else -> R.string.unexpected_error
                    }

                    _state.value = UiFactState.Error(messageResId = idRes)
                }
        }
    }

    private fun fetchColors() {
        viewModelScope.launch {
            fetchColorsUseCase()
                .onSuccess { _colorsState.value = it }
        }
    }

    fun fetchRandomFact() {
        viewModelScope.launch {
            fetchRandomFactUseCase()
                .onSuccess {
                    saveTodayFactUseCase(it)
                    _state.value = UiFactState.Success(it)
                }
                .onFailure { throwable ->
                    val idRes = when(throwable) {
                        is IOException -> R.string.internet_error
                        else -> R.string.unexpected_error
                    }
                    _state.value = UiFactState.Error(messageResId = idRes)
                }
        }
    }
}

sealed class UiFactState {
    object Loading: UiFactState()
    class Error(val messageResId: Int): UiFactState()
    class Success(val fact: Fact): UiFactState()
}

@Composable
fun ColorPicker(
    modifier: Modifier = Modifier,
    colors: List<Color>,
    selectedColor: Color,
    onColorChanged: (color: Color) -> Unit
) {
    var currentColor by remember { mutableStateOf(selectedColor) }
    LaunchedEffect(key1 = selectedColor) { currentColor = selectedColor }

    LazyRow(
        modifier = modifier.padding(10.dp),
        verticalAlignment = Alignment.CenterVertically,
        horizontalArrangement = Arrangement.spacedBy(5.dp)
    ) {
        items(colors) { color ->
            val isBorderVisible = currentColor == color

            val borderModifier = if(isBorderVisible)
                Modifier.border(
                    width = 2.dp,
                    color = surfaceColor,
                    shape = RoundedCornerShape(10)
                )
            else
                Modifier

            Box(
                modifier = Modifier
                    .then(borderModifier)
                    .size(40.dp)
                    .clip(shape = RoundedCornerShape(10))
                    .background(color)
                    .clickable {
                        currentColor = color
                        onColorChanged(currentColor)
                    }
            )
        }
    }
}

@Composable
fun SettingsScreen(
    colorConfiguration: ColorsConfiguration,
    onBackPressed: () -> Unit,
    onBackgroundChanged: (backgroundColor: Color) -> Unit,
    onTextColorChanged: (textColor: Color) -> Unit
) {
    var backgroundColor by remember { mutableStateOf(colorConfiguration.backgroundColor) }
    var textColor by remember { mutableStateOf(colorConfiguration.textColor) }

    LaunchedEffect(key1 = colorConfiguration) {
        backgroundColor = colorConfiguration.backgroundColor
        textColor = colorConfiguration.textColor
    }

    Box(
        modifier = Modifier
            .fillMaxSize()
            .background(backColorPrimary),
        contentAlignment = Alignment.Center
    ) {
        Column(
            modifier = Modifier
                .clip(shape = RoundedCornerShape(10))
                .background(backColorSecondary)
                .padding(20.dp),
            horizontalAlignment = Alignment.CenterHorizontally,
            verticalArrangement = Arrangement.spacedBy(20.dp, Alignment.CenterVertically)
        ) {
            Text(
                text = stringResource(id = R.string.choose_background_color),
                style = MaterialTheme.typography.titleMedium,
                color = textColorPrimary
            )
            ColorPicker(
                colors = BoxColors,
                selectedColor = colorConfiguration.backgroundColor,
                onColorChanged = {
                    backgroundColor = it
                    onBackgroundChanged(backgroundColor)
                }
            )
            Spacer(modifier = Modifier.height(5.dp))
            Text(
                text = stringResource(id = R.string.choose_text_color),
                style = MaterialTheme.typography.titleMedium,
                color = textColorPrimary
            )
            ColorPicker(
                colors = TextColors,
                selectedColor = colorConfiguration.textColor,
                onColorChanged = {
                    textColor = it
                    onTextColorChanged(textColor)
                }
            )
            MaterialButton(
                action = onBackPressed,
                icon = Icons.Default.ArrowBack,
                configuration = colorConfiguration
            )
        }
    }
}

@HiltViewModel
class SettingsViewModel @Inject constructor(
    private val fetchColorsUseCase: FetchColorsUseCase,
    private val updateColorsUseCase: UpdateColorsUseCase
): ViewModel() {
    private val _colorState = mutableStateOf(ColorsConfiguration())
    val colorState: State<ColorsConfiguration> = _colorState

    init {
        fetchColors()
    }

    fun updateColors(backgroundColor: Color? = null, textColor: Color? = null) {
        viewModelScope.launch {
            updateColorsUseCase(
                newBackgroundColor = backgroundColor,
                newTextColor = textColor
            )
        }
    }

    private fun fetchColors() {
        viewModelScope.launch {
            fetchColorsUseCase()
                .onSuccess { colorConfig -> _colorState.value = colorConfig }
        }
    }
}

@Composable
fun SplashScreen(
    onNextScreen: () -> Unit
) {
    LaunchedEffect(key1 = Unit) {
        delay(2000)
        onNextScreen()
    }

    Column(
        modifier = Modifier
            .fillMaxSize()
            .background(backColorPrimary),
        horizontalAlignment = Alignment.CenterHorizontally,
        verticalArrangement = Arrangement.spacedBy(10.dp, Alignment.CenterVertically)
    ) {
        Icon(
            modifier = Modifier.size(300.dp),
            imageVector = Icons.Default.QuestionMark,
            contentDescription = null,
            tint = textColorPrimary
        )
        Text(
            text = stringResource(id = R.string.app_name),
            style = MaterialTheme.typography.titleLarge,
            color = textColorPrimary
        )
    }
}

"""
    }
    
    static func dependencies(_ mainData: MainData) -> ANDData {
        return ANDData(mainFragmentData: ANDMainFragment(imports: "", content: """
        Router()
        """), mainActivityData: ANDMainActivity(imports: "", extraFunc: "", content: ""), themesData: ANDThemesData(isDefault: true, content: ""), stringsData: ANDStringsData(additional: """
            <string name="internet_error">Check your internet connection</string>
            <string name="unexpected_error">Unexpected error</string>
            <string name="settings">Settings</string>
            <string name="next">Next</string>
            <string name="choose_background_color">Choose background color</string>
            <string name="choose_text_color">Choose text color</string>
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
            signingConfig signingConfigs.debug
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
    implementation Dependencies.compose_navigation
    implementation Dependencies.retrofit
    implementation Dependencies.converter_gson
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
