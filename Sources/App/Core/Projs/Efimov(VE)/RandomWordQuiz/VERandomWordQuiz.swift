//
//  File.swift
//  
//
//  Created by admin on 8/21/23.
//

import Foundation

struct VERandomWordQuiz: FileProviderProtocol {
    static var fileName = "\(NamesManager.shared.fileName).kt"
    
    static func fileContent(packageName: String, uiSettings: UISettings) -> String {
        """
package \(packageName).presentation.fragments.main_fragment

import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.lazy.LazyRow
import androidx.compose.foundation.lazy.grid.GridCells
import androidx.compose.foundation.lazy.grid.LazyVerticalGrid
import androidx.compose.foundation.lazy.grid.items
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.EmojiSymbols
import androidx.compose.material.icons.filled.Refresh
import androidx.compose.material3.AlertDialog
import androidx.compose.material3.Card
import androidx.compose.material3.CardDefaults
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.LinearProgressIndicator
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.MutableState
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.mutableStateOf
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.hilt.navigation.compose.hiltViewModel
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.ramcosta.composedestinations.annotation.Destination
import com.ramcosta.composedestinations.annotation.RootNavGraph
import com.ramcosta.composedestinations.navigation.DestinationsNavigator
import com.ramcosta.composedestinations.navigation.popUpTo
import \(packageName).R
import \(packageName).presentation.fragments.main_fragment.destinations.RandomWordScreenDestination
import \(packageName).presentation.fragments.main_fragment.destinations.SplashScreenDestination
import dagger.Module
import dagger.Provides
import dagger.hilt.InstallIn
import dagger.hilt.android.lifecycle.HiltViewModel
import dagger.hilt.components.SingletonComponent
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.delay
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import retrofit2.HttpException
import retrofit2.Retrofit
import retrofit2.converter.gson.GsonConverterFactory
import retrofit2.http.GET
import retrofit2.http.Query
import java.io.IOException
import javax.inject.Inject
import javax.inject.Singleton


val textColorPrimary = Color(0xFF\(uiSettings.textColorPrimary ?? "FFFFFF"))
val backColorPrimary = Color(0xFF\(uiSettings.backColorPrimary ?? "FFFFFF"))
val surfaceColor = Color(0xFF\(uiSettings.surfaceColor ?? "FFFFFF"))

object Endpoints {
    const val BASE_URL = "https://random-word-api.herokuapp.com/"
    const val WORD_ENDPOINT = "/word"
}

interface RandomWordApi {

    @GET(Endpoints.WORD_ENDPOINT)
    suspend fun fetchWord(
        @Query("length") length: Int = 5,
        @Query("lang") lang: String = "en"
    ): List<String>

}

class RandomWordRepositoryImpl(
    private val api: RandomWordApi
): RandomWordRepository {
    override suspend fun fetchRandomWord(): String {
        return api.fetchWord().first()
    }
}

@Module
@InstallIn(SingletonComponent::class)
class DataModule {

    @[Provides Singleton]
    fun provideRandomWordApi(): RandomWordApi {
        return Retrofit.Builder()
            .baseUrl(Endpoints.BASE_URL)
            .addConverterFactory(GsonConverterFactory.create())
            .build()
            .create(RandomWordApi::class.java)
    }

    @[Provides Singleton]
    fun provideRandomWordRepository(api: RandomWordApi): RandomWordRepository {
        return RandomWordRepositoryImpl(api)
    }
}

data class CharBox(
    val char: Char,
    var isEnabled: Boolean = true,
    var isCharacterVisible: Boolean = false
)

interface RandomWordRepository {
    suspend fun fetchRandomWord(): String
}

class FetchRandomWordUseCase @Inject constructor(
    private val repository: RandomWordRepository
) {
    suspend operator fun invoke() =
        kotlin.runCatching {
            withContext(Dispatchers.IO) {
                repository.fetchRandomWord()
            }
        }
}

@HiltViewModel
class RandomWordViewModel @Inject constructor(
    private val fetchRandomWordUseCase: FetchRandomWordUseCase
): ViewModel() {
    private val keyboardChars = "qwertyuiopasdfghjklzxcvbnm".toList().map { CharBox(it) }

    private val _uiState = MutableStateFlow(UiRandomWordState(enabledKeyboardButtons = mutableStateOf(keyboardChars.toMutableList())))
    val uiState = _uiState.asStateFlow()

    init {
        fetchRandomWord()
    }

    fun fetchRandomWord() {
        _uiState.value = _uiState.value.copy(
            state = RandomWordState.Loading
        )

        viewModelScope.launch {
            fetchRandomWordUseCase()
                .onSuccess { wordString ->
                    _uiState.value = _uiState.value.copy(
                        wordParts = mutableStateOf(wordString.toList().map { CharBox(char = it) }.toMutableList()),
                        state = RandomWordState.Success
                    )
                }
                .onFailure { throwable ->
                    val resId = when(throwable) {
                        is IOException -> R.string.user_error
                        is HttpException -> R.string.http_error
                        else -> R.string.unxpected_error
                    }
                    _uiState.value = UiRandomWordState(state = RandomWordState.Error(resId))
                }
        }
    }

    fun restartGame() {
        _uiState.value = UiRandomWordState(enabledKeyboardButtons = mutableStateOf(keyboardChars.toMutableList()))
        fetchRandomWord()
    }

    fun checkCorrectCharacter(charBox: CharBox) {
        if(_uiState.value.wordParts.value.contains(charBox)) {
            val updatedItems = _uiState.value.wordParts.value
            updatedItems.map { item ->
                if(item.char == charBox.char)
                    item.isCharacterVisible = true
            }

            _uiState.value = _uiState.value.copy(
                wordParts = mutableStateOf(updatedItems)
            )

            checkWin()
        } else {
            _uiState.value = _uiState.value.copy(
                missingCount = _uiState.value.missingCount + 1
            )

            checkMissingCount()
        }

        val updatedKeyboardCharBox = charBox.copy(isEnabled = false)
        val keyboardCharBoxIndex = _uiState.value.enabledKeyboardButtons.value.indexOf(charBox)
        val updatedItems = _uiState.value.enabledKeyboardButtons.value
        updatedItems[keyboardCharBoxIndex] = updatedKeyboardCharBox

        _uiState.value = _uiState.value.copy(
            enabledKeyboardButtons = mutableStateOf(updatedItems)
        )
    }

    private fun checkMissingCount() {
        if(_uiState.value.missingCount == 5) {
            _uiState.value = uiState.value.copy(
                state = RandomWordState.Lost
            )
        }
    }

    private fun checkWin() {
        val filtered = _uiState.value.wordParts.value.filter { !it.isCharacterVisible }
        if (filtered.isEmpty())
            _uiState.value = _uiState.value.copy(state = RandomWordState.Win)
    }
}

data class UiRandomWordState(
    val wordParts: MutableState<MutableList<CharBox>> = mutableStateOf(mutableListOf()),
    val state: RandomWordState = RandomWordState.Loading,
    val enabledKeyboardButtons: MutableState<MutableList<CharBox>> = mutableStateOf(mutableListOf()),
    val missingCount: Int = 0
)
sealed class RandomWordState {
    object Loading: RandomWordState()
    class Error(val resId: Int): RandomWordState()
    object Success: RandomWordState()
    object Lost: RandomWordState()
    object Win: RandomWordState()
}

@Composable
fun ErrorMessage(
    resId: Int,
    onTryAgainClick: () -> Unit
) {
    Column(
        modifier = Modifier.fillMaxSize(),
        horizontalAlignment = Alignment.CenterHorizontally,
        verticalArrangement = Arrangement.spacedBy(10.dp, Alignment.CenterVertically)
    ) {
        Text(
            text = stringResource(id = resId),
            color = textColorPrimary,
            fontSize = 25.sp
        )
        Box(
            modifier = Modifier
                .size(100.dp)
                .clip(shape = RoundedCornerShape(10))
                .clickable { onTryAgainClick() }
                .background(surfaceColor),
            contentAlignment = Alignment.Center
        ) {
            Icon(
                modifier = Modifier.size(40.dp),
                imageVector = Icons.Default.Refresh,
                contentDescription = null,
                tint = textColorPrimary
            )
        }
    }
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun Keyboard(
    enabledKeyboardButtons: List<CharBox>,
    onCharacterClick: (CharBox) -> Unit
) {
    LazyVerticalGrid(
        modifier = Modifier.fillMaxWidth(),
        columns = GridCells.Adaptive(40.dp),
        horizontalArrangement = Arrangement.spacedBy(10.dp),
        verticalArrangement = Arrangement.spacedBy(10.dp),
        contentPadding = PaddingValues(10.dp),
    ) {
        items(enabledKeyboardButtons) { charBox ->
            Card(
                modifier = Modifier.size(50.dp),
                onClick = { onCharacterClick(charBox) },
                shape = RoundedCornerShape(10),
                colors = CardDefaults.cardColors(
                    containerColor = surfaceColor,
                    disabledContainerColor = backColorPrimary
                ),
                enabled = charBox.isEnabled
            ) {
                Box(
                    modifier = Modifier.fillMaxSize(),
                    contentAlignment = Alignment.Center
                ) {
                    Text(
                        text = charBox.char.toString(),
                        color = textColorPrimary,
                        fontSize = 20.sp
                    )
                }
            }
        }
    }
}

@Destination
@Composable
fun RandomWordScreen(
    viewModel: RandomWordViewModel = hiltViewModel()
) {
    val uiState = viewModel.uiState.collectAsState().value

    Column(
        modifier = Modifier
            .fillMaxSize()
            .background(backColorPrimary),
        horizontalAlignment = Alignment.CenterHorizontally,
        verticalArrangement = Arrangement.SpaceBetween
    ) {
        when(uiState.state) {
            is RandomWordState.Loading -> LinearProgressIndicator(color = surfaceColor)
            is RandomWordState.Error -> ErrorMessage(
                resId = uiState.state.resId,
                onTryAgainClick = viewModel::fetchRandomWord
            )
            is RandomWordState.Success -> {
                RandomWordGame(wordParts = uiState.wordParts.value)
                Keyboard(
                    onCharacterClick = viewModel::checkCorrectCharacter,
                    enabledKeyboardButtons = uiState.enabledKeyboardButtons.value
                )
            }
            is RandomWordState.Win -> GameResult(
                resId = R.string.win,
                onDismiss = viewModel::restartGame
            )
            is RandomWordState.Lost ->  GameResult(
                resId = R.string.lost,
                onDismiss = viewModel::restartGame,
                word = uiState.wordParts.value
                    .map { it.char }
                    .joinToString(separator = "")
            )
        }
    }
}

@Composable
private fun GameResult(
    resId: Int,
    word: String? = null,
    onDismiss: () -> Unit
) {
    AlertDialog(
        title = {
            Text(
                text = stringResource(id = resId),
                color = textColorPrimary,
                fontSize = 20.sp
            )
        },
        text = {
            word?.let {
                Text(
                    text = stringResource(id = R.string.win_word, word),
                    color = textColorPrimary,
                    fontSize = 20.sp
                )
            }
        },
        onDismissRequest = onDismiss,
        confirmButton = {
            IconButton(onClick = onDismiss) {
                Icon(
                    imageVector = Icons.Default.Refresh,
                    contentDescription = null,
                    tint = textColorPrimary
                )
            }
        }, containerColor = backColorPrimary
    )
}

@Composable
private fun RandomWordGame(
    wordParts: List<CharBox>
) {
    LazyRow(
        modifier = Modifier.fillMaxWidth(),
        horizontalArrangement = Arrangement.SpaceEvenly,
        verticalAlignment = Alignment.CenterVertically,
        contentPadding = PaddingValues(vertical = 50.dp)
    ) {
        items(wordParts) { charBox ->
            Card(
                shape = RoundedCornerShape(10),
                colors = CardDefaults.cardColors(
                    containerColor = surfaceColor
                ),
            ) {
                Box(
                    modifier = Modifier.size(70.dp),
                    contentAlignment = Alignment.Center
                ) {
                    if(charBox.isCharacterVisible) {
                        Text(
                            text = charBox.char.toString(),
                            color = textColorPrimary,
                            fontSize = 30.sp
                        )
                    }
                }
            }
        }
    }
}


const val SPLASH_DELAY = 2000L

@RootNavGraph(start = true)
@Destination
@Composable
fun SplashScreen(navigator: DestinationsNavigator) {

    LaunchedEffect(key1 = Unit) {
        delay(SPLASH_DELAY)
        navigator.navigate(RandomWordScreenDestination) {
            popUpTo(SplashScreenDestination) { inclusive = true }
        }
    }

    Box(
        modifier = Modifier
            .fillMaxSize()
            .background(backColorPrimary),
        contentAlignment = Alignment.Center
    ) {
        Icon(
            modifier = Modifier.size(200.dp),
            imageVector = Icons.Default.EmojiSymbols,
            contentDescription = null,
            tint = textColorPrimary
        )
    }
}


"""
    }
    
    static func dependencies(_ mainData: MainData) -> ANDData {
        return ANDData(
            mainFragmentData: ANDMainFragment(imports: """
import com.ramcosta.composedestinations.DestinationsNavHost
""", content: """
    DestinationsNavHost(navGraph = NavGraphs.root)
"""),
            mainActivityData: ANDMainActivity(imports: "", extraFunc: "", content: ""),
            themesData: ANDThemesData(isDefault: true, content: ""),
            stringsData: ANDStringsData(additional: """
    <string name="user_error">Check your internet connection!</string>
    <string name="http_error">Something wrong with server(</string>
    <string name="unxpected_error">Unexpected error</string>
    <string name="win">You win!</string>
    <string name="lost">You lose</string>
    <string name="ok">OK</string>
    <string name="win_word">Word: %s</string>
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

plugins {
    id 'com.google.devtools.ksp' version '1.8.10-1.0.9'
}
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
    implementation Dependencies.compose_destinations_core
    ksp Dependencies.compose_destinations_ksp
    implementation Dependencies.calendar_compose
    implementation Dependencies.room_ktx
    implementation Dependencies.room_runtime
    implementation Dependencies.retrofit
    implementation Dependencies.converter_gson

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

    const val compose_destination = "1.8.42-beta"
    const val moshi = "1.15.0"

    const val kotlin_serialization = "1.5.1"
    const val datastore_preferences = "1.0.0"

    const val calendar_compose = "2.3.0"

    const val desugar_version = "1.1.8"
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

    const val compose_destinations_core = "io.github.raamcosta.compose-destinations:core:${Versions.compose_destination}"
    const val compose_destinations_ksp = "io.github.raamcosta.compose-destinations:ksp:${Versions.compose_destination}"

    const val moshi = "com.squareup.moshi:moshi-kotlin:${Versions.moshi}"

    const val kotlinx_serialization = "org.jetbrains.kotlinx:kotlinx-serialization-json:${Versions.kotlin_serialization}"

    const val data_store = "androidx.datastore:datastore-preferences:${Versions.datastore_preferences}"

    const val calendar_compose = "com.kizitonwose.calendar:compose:${Versions.calendar_compose}"

    const val desugar = "com.android.tools:desugar_jdk_libs:${Versions.desugar_version}"
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
