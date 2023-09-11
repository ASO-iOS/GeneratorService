//
//  File.swift
//  
//
//  Created by admin on 8/20/23.
//

import Foundation

struct VEFactsAboutDogs: FileProviderProtocol {
    static var fileName = "\(NamesManager.shared.fileName).kt"
    
    static func fileContent(packageName: String, uiSettings: UISettings) -> String {
        """
package \(packageName).presentation.fragments.main_fragment

import androidx.compose.animation.core.Animatable
import androidx.compose.animation.core.tween
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
import androidx.compose.foundation.lazy.rememberLazyListState
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.ArrowForward
import androidx.compose.material.icons.filled.Pets
import androidx.compose.material.icons.filled.Refresh
import androidx.compose.material3.BottomAppBar
import androidx.compose.material3.Card
import androidx.compose.material3.CardDefaults
import androidx.compose.material3.CircularProgressIndicator
import androidx.compose.material3.FloatingActionButton
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Text
import androidx.compose.material3.Typography
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.remember
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.TextStyle
import androidx.compose.ui.text.font.FontFamily
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.Dp
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
import \(packageName).presentation.fragments.main_fragment.destinations.FactsScreenDestination
import \(packageName).presentation.fragments.main_fragment.destinations.SplashScreenDestination
import dagger.Module
import dagger.Provides
import dagger.hilt.InstallIn
import dagger.hilt.android.lifecycle.HiltViewModel
import dagger.hilt.components.SingletonComponent
import kotlinx.coroutines.CoroutineDispatcher
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import retrofit2.Retrofit
import retrofit2.converter.gson.GsonConverterFactory
import retrofit2.http.GET
import retrofit2.http.Query
import java.io.IOException
import javax.inject.Inject
import javax.inject.Singleton

val backColorPrimary = Color(0xFF\(uiSettings.backColorPrimary ?? "FFFFFF"))
val textColorPrimary = Color(0xFF\(uiSettings.textColorPrimary ?? "FFFFFF"))
val buttonColorPrimary = Color(0xFF\(uiSettings.buttonColorPrimary ?? "FFFFFF"))
val surfaceColor = Color(0xFF\(uiSettings.surfaceColor ?? "FFFFFF"))

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
fun FactsAboutDogsTheme(
    content: @Composable () -> Unit
) {
    MaterialTheme(
        typography = Typography,
        content = content
    )
}

data class FactsResult(
    val facts: List<String>,
    val success: Boolean
)

interface DogsApi {

    @GET(Endpoints.FACTS_ENDPOINT)
    suspend fun fetchFacts(
        @Query("number") number: Int = 5
    ): FactsResult

}

object Endpoints {
    const val BASE_URL = "http://dog-api.kinduff.com/"
    const val FACTS_ENDPOINT = "/api/facts"
}

class FactsRepositoryImpl @Inject constructor(
    private val api: DogsApi
): FactsRepository {

    override suspend fun fetchFacts(): List<Fact> {
        return api.fetchFacts().facts.map { Fact(it) }
    }
}

@Module
@InstallIn(SingletonComponent::class)
class DataModule {

    @Provides
    @Singleton
    fun provideDogsApi(): DogsApi {
        return Retrofit.Builder()
            .baseUrl(Endpoints.BASE_URL)
            .addConverterFactory(GsonConverterFactory.create())
            .build()
            .create(DogsApi::class.java)
    }

    @Provides
    @Singleton
    fun provideFactsRepository(api: DogsApi): FactsRepository {
        return FactsRepositoryImpl(api)
    }

    @Provides
    @Singleton
    fun provideCoroutineDispatcher() = Dispatchers.IO

}

data class Fact(
    val fact: String
)

interface FactsRepository {
    suspend fun fetchFacts(): List<Fact>
}

class FetchFactsDogsUseCase @Inject constructor(
    private val repository: FactsRepository,
    private val dispatcher: CoroutineDispatcher
) {
    suspend operator fun invoke(): Result<List<Fact>> =
        kotlin.runCatching {
            withContext(dispatcher) {
                repository.fetchFacts()
            }
        }
}

@Composable
fun FactCard(
    fact: Fact
) {
    Card(
        shape = RoundedCornerShape(10),
        colors = CardDefaults.cardColors(
            containerColor = surfaceColor
        ),
        elevation = CardDefaults.elevatedCardElevation(
            defaultElevation = 10.dp
        )
    ) {
        Text(
            modifier = Modifier
                .align(Alignment.CenterHorizontally)
                .padding(horizontal = 20.dp, vertical = 10.dp),
            text = fact.fact,
            style = MaterialTheme.typography.titleLarge,
            color = textColorPrimary,
            textAlign = TextAlign.Center
        )
    }
}

@Destination
@Composable
fun FactsScreen(
    viewModel: FactsViewModel = hiltViewModel()
) {
    val state = viewModel.state.collectAsState().value

    Scaffold(
        bottomBar = {
            BottomAppBar(
                modifier = Modifier.fillMaxWidth(),
                containerColor = backColorPrimary,
                floatingActionButton = {
                    FloatingActionButton(
                        onClick = viewModel::fetchNext,
                        containerColor = buttonColorPrimary
                    ) {
                        Icon(
                            modifier = Modifier.size(25.dp),
                            imageVector = Icons.Default.ArrowForward,
                            contentDescription = null,
                            tint = textColorPrimary
                        )
                    }
                },
                actions = {}
            )
        },
        containerColor = backColorPrimary
    ) { paddingsScaffold ->
        Box(
            modifier = Modifier
                .fillMaxSize()
                .padding(paddingsScaffold),
            contentAlignment = Alignment.Center
        ) {
            when(state) {
                is UiFactsScreenState.Loading -> CircularProgressIndicator()
                is UiFactsScreenState.Error -> ShowError(
                    resId = state.resId,
                    onTryPressed = viewModel::fetchFacts
                )
                is UiFactsScreenState.Success -> ShowMain(
                    facts = state.facts
                )
            }
        }
    }
}

@Composable
private fun ShowMain(facts: List<Fact>) {
    val scrollState = rememberLazyListState()
    LaunchedEffect(key1 = facts) {
        scrollState.animateScrollToItem(facts.size)
    }

    LazyColumn(
        modifier = Modifier.fillMaxSize(),
        contentPadding = PaddingValues(vertical = 10.dp, horizontal = 10.dp),
        horizontalAlignment = Alignment.CenterHorizontally,
        verticalArrangement = Arrangement.spacedBy(20.dp),
        state = scrollState
    ) {
        items(facts) { factItem ->
            FactCard(fact = factItem)
        }
    }
}

@Composable
private fun ShowError(
    resId: Int,
    onTryPressed: () -> Unit
) {
    Column(
        modifier = Modifier
            .fillMaxSize()
            .padding(horizontal = 30.dp),
        horizontalAlignment = Alignment.CenterHorizontally,
        verticalArrangement = Arrangement.Center
    ) {
        IconButton(onClick = onTryPressed) {
            Icon(
                modifier = Modifier.size(200.dp),
                imageVector = Icons.Default.Refresh,
                contentDescription = null,
                tint = textColorPrimary
            )
        }
        Text(
            text = stringResource(id = resId),
            style = MaterialTheme.typography.titleLarge,
            color = textColorPrimary,
            textAlign = TextAlign.Center
        )
    }
}

@HiltViewModel
class FactsViewModel @Inject constructor(
    private val fetchFactsDogsUseCase: FetchFactsDogsUseCase
): ViewModel() {

    private val _factsState = MutableStateFlow<List<Fact>>(emptyList())
    private var factIndex = 0

    private val _state = MutableStateFlow<UiFactsScreenState>(UiFactsScreenState.Loading)
    val state = _state.asStateFlow()

    init {
        fetchFacts()
    }

    fun fetchFacts() {
        _state.value = UiFactsScreenState.Loading
        viewModelScope.launch {
            fetchFactsDogsUseCase()
                .onSuccess {
                    _factsState.value = it
                    fetchNext()
                }
                .onFailure { throwable ->
                    val errorMessageRes = when(throwable) {
                        is IOException -> R.string.internet_error
                        else -> R.string.unexpected_error
                    }
                    _state.value = UiFactsScreenState.Error(errorMessageRes)
                }
        }
    }

    fun fetchNext() {
        factIndex++
        if(factIndex <= _factsState.value.size) {
            _state.value = UiFactsScreenState.Success(_factsState.value.subList(0, factIndex))
        } else {
            factIndex = 0
            fetchFacts()
        }
    }
}

sealed class UiFactsScreenState {
    object Loading: UiFactsScreenState()
    class Error(val resId: Int): UiFactsScreenState()
    class Success(val facts: List<Fact>): UiFactsScreenState()
}

@RootNavGraph(start = true)
@Destination
@Composable
fun SplashScreen(navigator: DestinationsNavigator) {
    val scale = remember { Animatable(initialValue = 20f) }

    LaunchedEffect(key1 = Unit) {
        scale.animateTo(
            targetValue = 200f,
            animationSpec = tween(durationMillis = 2000)
        )

        navigator.navigate(FactsScreenDestination()) {
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
            modifier = Modifier.size(Dp(scale.value)),
            imageVector = Icons.Default.Pets,
            contentDescription = null,
            tint = textColorPrimary
        )
    }
}

"""
    }
    
    static func dependencies(_ mainData: MainData) -> ANDData {
        return ANDData(mainFragmentData: ANDMainFragment(imports: """
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Surface
import androidx.compose.ui.Modifier
import com.ramcosta.composedestinations.DestinationsNavHost
""", content: """
    FactsAboutDogsTheme {
        Surface(
            modifier = Modifier.fillMaxSize(),
            color = MaterialTheme.colorScheme.background
        ) {
            DestinationsNavHost(navGraph = NavGraphs.root)
        }
    }
"""),
                       mainActivityData: ANDMainActivity(imports: "", extraFunc: "", content: ""),
                       themesData: ANDThemesData(isDefault: true, content: ""),
                       stringsData: ANDStringsData(additional: """
    <string name="internet_error">Check your internet connection!</string>
    <string name="unexpected_error">Unexpected error</string>
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
    implementation Dependencies.compose_destinations_core
    ksp Dependencies.compose_destinations_ksp
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
    const val hilt = "2.45"
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

    const val compose_destination = "1.8.42-beta"
    const val moshi = "1.15.0"

    const val kotlin_serialization = "1.5.1"
    const val datastore_preferences = "1.0.0"
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

    const val compose_destinations_core = "io.github.raamcosta.compose-destinations:core:${Versions.compose_destination}"
    const val compose_destinations_ksp = "io.github.raamcosta.compose-destinations:ksp:${Versions.compose_destination}"

    const val moshi = "com.squareup.moshi:moshi-kotlin:${Versions.moshi}"

    const val kotlinx_serialization = "org.jetbrains.kotlinx:kotlinx-serialization-json:${Versions.kotlin_serialization}"

    const val data_store = "androidx.datastore:datastore-preferences:${Versions.datastore_preferences}"

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
