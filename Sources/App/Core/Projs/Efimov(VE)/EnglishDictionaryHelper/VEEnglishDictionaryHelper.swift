//
//  File.swift
//  
//
//  Created by admin on 8/22/23.
//

import Foundation

struct VEEnglishDictionaryHelper: FileProviderProtocol {
    static var fileName: String = "EnglishDictionaryHelper.kt"
    
    static func fileContent(packageName: String, uiSettings: UISettings) -> String {
        """
package \(packageName).presentation.fragments.main_fragment

import android.widget.Toast
import androidx.annotation.Keep
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Book
import androidx.compose.material.icons.filled.Search
import androidx.compose.material3.CircularProgressIndicator
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.ModalBottomSheet
import androidx.compose.material3.SheetState
import androidx.compose.material3.Text
import androidx.compose.material3.TextField
import androidx.compose.material3.TextFieldDefaults
import androidx.compose.material3.rememberModalBottomSheetState
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.collectAsState
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.TextStyle
import androidx.compose.ui.text.font.FontStyle
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.hilt.navigation.compose.hiltViewModel
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.google.gson.annotations.SerializedName
import com.ramcosta.composedestinations.annotation.Destination
import com.ramcosta.composedestinations.annotation.RootNavGraph
import com.ramcosta.composedestinations.navigation.DestinationsNavigator
import com.ramcosta.composedestinations.navigation.popUpTo
import \(packageName).R
import \(packageName).presentation.fragments.main_fragment.destinations.SearchScreenDestination
import \(packageName).presentation.fragments.main_fragment.destinations.SplashScreenDestination
import dagger.Module
import dagger.Provides
import dagger.hilt.InstallIn
import dagger.hilt.android.lifecycle.HiltViewModel
import dagger.hilt.components.SingletonComponent
import kotlinx.coroutines.CoroutineDispatcher
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.delay
import kotlinx.coroutines.flow.MutableSharedFlow
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.asSharedFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.flow.collectLatest
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import retrofit2.HttpException
import retrofit2.Retrofit
import retrofit2.converter.gson.GsonConverterFactory
import retrofit2.http.GET
import retrofit2.http.Path
import java.io.IOException
import javax.inject.Inject
import javax.inject.Singleton

val textColorPrimary = Color(0xFF\(uiSettings.textColorPrimary ?? "FFFFFF"))
val textColorSecondary = Color(0xFF\(uiSettings.textColorSecondary ?? "FFFFFF"))
val backColorPrimary = Color(0xFF\(uiSettings.backColorPrimary ?? "FFFFFF"))
val surfaceColor = Color(0xFF\(uiSettings.surfaceColor ?? "FFFFFF"))

fun Throwable.refineHttpError(): Errors {
    return when(this) {
        is IOException -> Errors.ErrorIO
        is HttpException -> this.refineHttpError()
        else -> Errors.ErrorUnexpected
    }
}

private fun HttpException.refineHttpError(): Errors {
    return when(this.code()) {
        404 -> Errors.ErrorHttpNotFound
        else -> Errors.ErrorHttp
    }
}

@Keep
data class WordInfoDto(
    @SerializedName("word") val word: String,
    @SerializedName("phonetic") val phonetic: String,
    @SerializedName("meanings") val meanings: List<MeaningDto>,
)

@Keep
data class MeaningDto(
    @SerializedName("partOfSpeech") val partOfSpeech: String,
    @SerializedName("definitions") val definitions: List<DefinitionDto>
)

@Keep
data class DefinitionDto(
    @SerializedName("definition") val definition: String,
    @SerializedName("example") val example: String?,
)

class DictionaryRepositoryImpl @Inject constructor(
    private val api: DictionaryApi
): DictionaryRepository {

    override suspend fun searchInfoByWord(word: String): WordInfo {
        return api.searchInfoByWord(word).first().toWordInfo()
    }
}

fun WordInfoDto.toWordInfo() = WordInfo(
    word = word,
    phonetic = phonetic,
    meanings = meanings.map { it.toMeaning() }
)

fun MeaningDto.toMeaning() = Meaning(
    partOfSpeech = partOfSpeech,
    definitions = definitions.map { it.toDefinition() }
)

fun DefinitionDto.toDefinition() = Definition(
    definition = definition,
    example = example
)

interface DictionaryApi {

    @GET(Endpoints.searchEndpoint)
    suspend fun searchInfoByWord(
        @Path("word") word: String
    ): List<WordInfoDto>

}

object Endpoints {
    const val baseUrl = "https://api.dictionaryapi.dev/"
    const val searchEndpoint = "/api/v2/entries/en/{word}"
}

@Module
@InstallIn(SingletonComponent::class)
class DataModule {

    @[Provides Singleton]
    fun provideDictionaryApi(): DictionaryApi {
        return Retrofit.Builder()
            .baseUrl(Endpoints.baseUrl)
            .addConverterFactory(GsonConverterFactory.create())
            .build()
            .create(DictionaryApi::class.java)
    }

    @[Provides Singleton]
    fun provideDictionaryRepository(api: DictionaryApi): DictionaryRepository {
        return DictionaryRepositoryImpl(api = api)
    }

    @[Provides Singleton]
    fun provideDispatcherIO() = Dispatchers.IO

}

enum class Errors {
    ErrorIO,
    ErrorHttp,
    ErrorHttpNotFound,
    ErrorUnexpected
}

data class WordInfo(
    val word: String,
    val phonetic: String,
    val meanings: List<Meaning>,
)

data class Meaning(
    val partOfSpeech: String,
    val definitions: List<Definition>
)

data class Definition(
    val definition: String,
    val example: String?
)

interface DictionaryRepository {

    suspend fun searchInfoByWord(word: String): WordInfo

}

class SearchByWordUseCase @Inject constructor(
    private val repository: DictionaryRepository,
    private val dispatcher: CoroutineDispatcher
) {
    suspend operator fun invoke(word: String) = runCatching {
        withContext(dispatcher) {
            repository.searchInfoByWord(word)
        }
    }
}

fun Throwable.toStringResource(): Int {
    return when(this.refineHttpError()) {
        Errors.ErrorIO -> R.string.io_error
        Errors.ErrorHttp -> R.string.http_other_error
        Errors.ErrorHttpNotFound -> R.string.not_found_error
        Errors.ErrorUnexpected -> R.string.unxp_error
    }
}

interface SearchEvent {
    object DoSearch: SearchEvent
    class ShowBottomSheet(val wordInfo: WordInfo): SearchEvent

    object HideBottomSheet: SearchEvent
    class TextChanged(val newValue: String): SearchEvent
}

@HiltViewModel
class SearchViewModel @Inject constructor(
    private val searchByWordUseCase: SearchByWordUseCase
): ViewModel() {

    private val _uiState = MutableStateFlow(UiSplashState())
    val uiState = _uiState.asStateFlow()

    private val _sideEffects = MutableSharedFlow<SideEffect>()
    val sideEffect = _sideEffects.asSharedFlow()

    fun handleEvent(event: SearchEvent) {
        when(event) {
            is SearchEvent.DoSearch -> fetchWordInfo()
            is SearchEvent.TextChanged -> changeText(event.newValue)
            is SearchEvent.HideBottomSheet -> hideBottomSheet()
            is SearchEvent.ShowBottomSheet -> showBottomSheet(event.wordInfo)
        }
    }

    private fun fetchWordInfo() {
        viewModelScope.launch {
            searchByWordUseCase(_uiState.value.currentQuery)
                .onSuccess { emitSideEffect(SideEffect.ShowBottomSheet(it)) }
                .onFailure {
                    emitSideEffect(SideEffect.ShowError(it.toStringResource()))
                }
        }
    }

    private fun changeText(newValue: String) {
        _uiState.value = _uiState.value.copy(currentQuery = newValue)
    }


    private fun showBottomSheet(wordInfo: WordInfo) {
        _uiState.value = _uiState.value.copy(
            isBottomSheetVisible = true,
            wordInfo = wordInfo
        )
    }

    private fun hideBottomSheet() {
        _uiState.value = _uiState.value.copy(wordInfo = null)
    }

    private fun emitSideEffect(effect: SideEffect) {
        viewModelScope.launch {
            _sideEffects.emit(effect)
        }
    }
}

interface SideEffect {
    class ShowBottomSheet(val wordInfo: WordInfo): SideEffect
    class ShowError(val resId: Int): SideEffect
}

data class UiSplashState(
    val isBottomSheetVisible: Boolean = false,
    val state: SplashState = SplashState.Default,
    val currentQuery: String = "",
    val wordInfo: WordInfo? = null
)

sealed interface SplashState {
    object Default: SplashState
    object Loading: SplashState

}

@OptIn(ExperimentalMaterial3Api::class)
@Destination
@Composable
fun SearchScreen(
    viewModel: SearchViewModel = hiltViewModel()
) {
    val uiState = viewModel.uiState.collectAsState().value
    val sheetState = rememberModalBottomSheetState(
        skipPartiallyExpanded = true
    )

    val context = LocalContext.current

    LaunchedEffect(key1 = Unit) {
        viewModel.sideEffect.collectLatest { effect ->
            when(effect) {
                is SideEffect.ShowBottomSheet -> {
                    viewModel.handleEvent(SearchEvent.ShowBottomSheet(effect.wordInfo))
                    sheetState.show()
                }
                is SideEffect.ShowError -> {
                    Toast.makeText(context, effect.resId, Toast.LENGTH_SHORT).show()
                }
            }
        }
    }

    uiState.wordInfo?.let { info ->
        WordInfoLayoutSheet(
            wordInfo = info,
            onDismiss = { viewModel.handleEvent(SearchEvent.HideBottomSheet) },
            sheetState
        )
    }

    Box(
        modifier = Modifier
            .fillMaxSize()
            .background(backColorPrimary),
        contentAlignment = Alignment.Center
    ) {
        when(uiState.state) {
            is SplashState.Default -> SearchLayout(
                textState = uiState.currentQuery,
                onTextValueChanged = { viewModel.handleEvent(SearchEvent.TextChanged(it)) },
                onSearchClick = { viewModel.handleEvent(SearchEvent.DoSearch) }
            )
            is SplashState.Loading -> CircularProgressIndicator(color = textColorPrimary)
        }
    }
}

@Composable
private fun SearchLayout(
    textState: String,
    onTextValueChanged: (String) -> Unit,
    onSearchClick: () -> Unit
) {
    TextField(
        value = textState,
        onValueChange = onTextValueChanged,
        colors = TextFieldDefaults.colors(
            unfocusedIndicatorColor = Color.Transparent,
            focusedIndicatorColor = Color.Transparent,
            unfocusedContainerColor = surfaceColor,
            focusedContainerColor = surfaceColor
        ),
        textStyle = TextStyle(
            color = textColorPrimary,
            textAlign = TextAlign.Center
        ),
        trailingIcon = {
            IconButton(onClick = onSearchClick) {
                Icon(
                    imageVector = Icons.Default.Search,
                    contentDescription = null,
                    tint = textColorPrimary
                )
            }
        },
        singleLine = true,
        shape = RoundedCornerShape(10),
        label = {
            Text(
                text = stringResource(id = R.string.type_placeholder),
                color = textColorPrimary,
                fontSize = 20.sp
            )
        }
    )
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
private fun WordInfoLayoutSheet(
    wordInfo: WordInfo,
    onDismiss: () -> Unit,
    sheetState: SheetState
) {
    ModalBottomSheet(
        onDismissRequest = onDismiss,
        containerColor = surfaceColor,
        sheetState = sheetState
    ) {
        LazyColumn(
            modifier = Modifier.fillMaxSize(),
            contentPadding = PaddingValues(10.dp),
            horizontalAlignment = Alignment.CenterHorizontally,
            verticalArrangement = Arrangement.spacedBy(10.dp, Alignment.Top)
        ) {
            item {
                Text(
                    text = wordInfo.word,
                    color = textColorPrimary,
                    fontSize = 30.sp
                )
            }
            item {
                Text(
                    text = stringResource(id = R.string.phonetic_format, wordInfo.phonetic),
                    color = textColorSecondary,
                    fontSize = 20.sp,
                    fontStyle = FontStyle.Italic
                )
            }
            items(wordInfo.meanings) { meaning ->
                Column(
                    modifier = Modifier
                        .fillMaxWidth()
                        .clip(shape = RoundedCornerShape(20.dp))
                        .background(backColorPrimary.copy(alpha = 0.7f))
                        .padding(10.dp),
                    horizontalAlignment = Alignment.CenterHorizontally,
                    verticalArrangement = Arrangement.spacedBy(5.dp)
                ) {
                    Text(
                        text = meaning.partOfSpeech,
                        color = textColorPrimary,
                        fontSize = 20.sp,
                        fontStyle = FontStyle.Italic
                    )
                    meaning.definitions.forEach { definition ->
                        Text(
                            modifier = Modifier.align(Alignment.Start),
                            text = definition.definition,
                            color = textColorPrimary,
                            fontSize = 20.sp
                        )
                        definition.example?.let {
                            Text(
                                modifier = Modifier.align(Alignment.Start),
                                text = stringResource(id = R.string.example_placeholder, it),
                                color = textColorSecondary,
                                fontSize = 16.sp
                            )
                        }
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
        navigator.navigate(SearchScreenDestination()) {
            popUpTo(SplashScreenDestination) { inclusive = true }
        }
    }

    Column(
        modifier = Modifier
            .fillMaxSize()
            .background(backColorPrimary),
        horizontalAlignment = Alignment.CenterHorizontally,
        verticalArrangement = Arrangement.spacedBy(30.dp, Alignment.CenterVertically)
    ) {
        Icon(
            modifier = Modifier.size(200.dp),
            imageVector = Icons.Default.Book,
            contentDescription = null,
            tint = textColorPrimary
        )

        Text(
            text = stringResource(id = R.string.app_name),
            color = textColorPrimary,
            fontSize = 30.sp
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
    <string name="phonetic_format">[%s]</string>
    <string name="type_placeholder">Search your word!</string>
    <string name="example_placeholder">- %s</string>
    <string name="io_error">Check your internet!</string>
    <string name="unxp_error">Unexpected error</string>
    <string name="not_found_error">Not found</string>
    <string name="http_other_error">Something wrong</string>
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
    id "com.google.devtools.ksp" version '1.8.10-1.0.9'
    id "com.android.application"
    id "org.jetbrains.kotlin.android"
    id "kotlin-kapt"
    id "dagger.hilt.android.plugin"
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
    implementation Dependencies.converter_gson
    implementation Dependencies.retrofit
    implementation Dependencies.compose_destinations_core
    ksp Dependencies.compose_destinations_ksp
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
    const val coil = "2.4.0"
    const val exp = "0.4.8"
    const val calend = "0.5.1"
    const val paging_version = "3.1.1"

    const val compose_destination = "1.8.42-beta"
    const val moshi = "1.15.0"

    const val kotlin_serialization = "1.5.1"
    const val datastore_preferences = "1.0.0"

    const val calendar_compose = "2.3.0"

    const val desugar_version = "1.1.8"

    const val koin_version = "3.4.3"
    const val koin_ksp_version = "1.2.2"


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

    const val koin_android = "io.insert-koin:koin-android:${Versions.koin_version}"
    const val koin_compose = "io.insert-koin:koin-androidx-compose:${Versions.koin_version}"
    const val koin_annotations = "io.insert-koin:koin-annotations:${Versions.koin_ksp_version}"
    const val koin_ksp_compiler = "io.insert-koin:koin-ksp-compiler:${Versions.koin_ksp_version}"
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
