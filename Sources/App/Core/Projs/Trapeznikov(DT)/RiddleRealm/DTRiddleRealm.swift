//
//  File.swift
//  
//
//  Created by admin on 9/4/23.
//

import SwiftUI

struct DTRiddleRealm: SFFileProviderProtocol {
    
    static func mainFragmentCMF(_ mainData: MainData) -> ANDMainFragmentCMF {
        ANDMainFragmentCMF(content: """
package \(mainData.packageName).presentation.fragments.main_fragment

import android.app.Application
import android.content.Context
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.verticalScroll
import androidx.compose.material3.Button
import androidx.compose.material3.ButtonDefaults
import androidx.compose.material3.Card
import androidx.compose.material3.CardDefaults
import androidx.compose.material3.CircularProgressIndicator
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.platform.ComposeView
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import androidx.fragment.app.Fragment
import androidx.hilt.navigation.compose.hiltViewModel
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import \(mainData.packageName).BuildConfig
import \(mainData.packageName).R
import com.google.gson.annotations.SerializedName
import dagger.Module
import dagger.Provides
import dagger.hilt.InstallIn
import dagger.hilt.android.AndroidEntryPoint
import dagger.hilt.android.lifecycle.HiltViewModel
import dagger.hilt.components.SingletonComponent
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.flow.flow
import kotlinx.coroutines.launch
import okhttp3.Interceptor
import okhttp3.OkHttpClient
import okhttp3.Response
import retrofit2.HttpException
import retrofit2.Retrofit
import retrofit2.converter.gson.GsonConverterFactory
import retrofit2.http.GET
import retrofit2.http.Query
import java.io.IOException
import javax.inject.Inject
import javax.inject.Singleton

@AndroidEntryPoint
class MainFragment : Fragment() {

    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View {
        return ComposeView(requireContext()).apply {
            setContent {
                MainScreen()
            }
        }
    }
}

@Composable
fun MainScreen() {
    MaterialTheme {
        RiddleScreen()
    }
}

sealed class Resource<T> {
    class Success<T>(val data: T) : Resource<T>()
    class Error<T>(val message: String) : Resource<T>()
    class Loading<T> : Resource<T>()
}

fun RiddleDto.toDomain(): Riddle {
    return Riddle(
        answer = this.answer,
        question = this.question,
        title = this.title
    )
}

class AuthInterceptor(private val apiKey: String) : Interceptor {

    override fun intercept(chain: Interceptor.Chain): Response {
        val request = chain.request().newBuilder().addHeader("X-Api-Key", apiKey).build()
        return chain.proceed(request)
    }
}

data class RiddleDto(
    @SerializedName("answer")
    val answer: String,
    @SerializedName("question")
    val question: String,
    @SerializedName("title")
    val title: String
)

interface RiddleService {

    @GET("v1/riddles")
    suspend fun getRiddles(@Query("limit") limit: Int = 1): retrofit2.Response<List<RiddleDto>>
}

class RiddleRepositoryImpl(
    private val riddleService: RiddleService,
    private val context: Context
) : RiddleRepository {

    override suspend fun getRiddles(limit: Int): Flow<Resource<List<Riddle>>> = flow {
        try {
            emit(Resource.Loading())
            val response = riddleService.getRiddles()
            val body = response.body()
            if (response.isSuccessful && !body.isNullOrEmpty()) {
                emit(Resource.Success(body.map { it.toDomain() }))
            } else {
                emit(Resource.Error(context.getString(R.string.unexpected_error)))
            }
        } catch (e: Exception) {
            when (e) {
                is HttpException -> emit(Resource.Error(context.getString(R.string.server_error)))
                is IOException -> emit(Resource.Error(context.getString(R.string.connection_lost)))
                else -> emit(Resource.Error(context.getString(R.string.unexpected_error)))
            }
        }
    }
}

@Module
@InstallIn(SingletonComponent::class)
class DataModule {

    @Provides
    @Singleton
    fun provideRiddleService(): RiddleService {
        val httpClient = OkHttpClient.Builder()
            .addInterceptor(AuthInterceptor(BuildConfig.API_KEY))
            .build()

        val retrofit = Retrofit.Builder()
            .client(httpClient)
            .baseUrl(BuildConfig.BASE_URL)
            .addConverterFactory(GsonConverterFactory.create())
            .build()

        return retrofit.create(RiddleService::class.java)
    }

    @Provides
    @Singleton
    fun provideRiddleRepository(riddleService: RiddleService, app: Application): RiddleRepository {
        return RiddleRepositoryImpl(riddleService, app)
    }
}

data class Riddle(
    val answer: String,
    val question: String,
    val title: String
)

interface RiddleRepository {

    suspend fun getRiddles(limit: Int = 1): Flow<Resource<List<Riddle>>>
}

@HiltViewModel
class RiddleViewModel @Inject constructor(
    private val riddleRepository: RiddleRepository
) : ViewModel() {

    private val _state = MutableStateFlow(RiddleState())
    val state = _state.asStateFlow()

    init {
        getRiddle()
    }

    fun getRiddle(limit: Int = 1) {
        viewModelScope.launch {
            riddleRepository.getRiddles(limit).collect {
                when (it) {
                    is Resource.Success -> _state.value = RiddleState(riddles = it.data)
                    is Resource.Loading -> _state.value = RiddleState(isLoading = true)
                    is Resource.Error -> _state.value = RiddleState(error = it.message)
                }
            }
        }
    }
}

data class RiddleState(
    val riddles: List<Riddle> = emptyList(),
    val isLoading: Boolean = false,
    val error: String = ""
)

val backColorPrimary = Color(0xFF\(mainData.uiSettings.backColorPrimary ?? "FFFFFF"))
val textColorPrimary = Color(0xFF\(mainData.uiSettings.textColorPrimary ?? "FFFFFF"))
val buttonTextColorPrimary = Color(0xFF\(mainData.uiSettings.buttonTextColorPrimary ?? "FFFFFF"))
val buttonColorPrimary = Color(0xFF\(mainData.uiSettings.buttonColorPrimary ?? "FFFFFF"))
val surfaceColor = Color(0xFF\(mainData.uiSettings.surfaceColor ?? "FFFFFF"))
val paddingPrimary = 16

@Composable
fun RiddleScreen(viewModel: RiddleViewModel = hiltViewModel()) {
    val state = viewModel.state.collectAsState()
    val riddleState = state.value
    Scaffold(
        modifier = Modifier.background(backColorPrimary),
        topBar = {
            Text(
                text = stringResource(R.string.riddle_realm),
                modifier = Modifier.padding(paddingPrimary.dp),
                style = MaterialTheme.typography.titleLarge,
                color = textColorPrimary
            )
        },
        containerColor = backColorPrimary
    ) { paddingValues ->
        Box(
            modifier = Modifier
                .padding(paddingValues)
                .padding(paddingPrimary.dp)
                .background(backColorPrimary)
                .fillMaxSize()
        ) {
            when {
                riddleState.riddles.isNotEmpty() -> {
                    RiddleContent(
                        riddles = riddleState.riddles,
                        modifier = Modifier.fillMaxSize(),
                        onNextClick = { viewModel.getRiddle() }
                    )
                }

                riddleState.isLoading -> {
                    CircularProgressIndicator(
                        modifier = Modifier.align(Alignment.Center),
                        color = buttonColorPrimary
                    )
                }

                riddleState.error.isNotEmpty() -> {
                    ErrorState(
                        modifier = Modifier.align(Alignment.Center),
                        error = riddleState.error,
                        onRetryClick = { viewModel.getRiddle() })
                }
            }
        }
    }
}

@Composable
fun RiddleContent(riddles: List<Riddle>, modifier: Modifier = Modifier, onNextClick: () -> Unit) {
    Column(
        modifier = modifier.background(backColorPrimary),
        horizontalAlignment = Alignment.CenterHorizontally,
        verticalArrangement = Arrangement.Center
    ) {
        Box(
            modifier = Modifier
                .fillMaxSize()
                .weight(1f)
                .background(backColorPrimary)
        ) {
            RiddleQuestionCard(riddles = riddles, modifier = Modifier.align(Alignment.Center))
        }
        Spacer(modifier = Modifier.height(16.dp))
        Box(
            modifier = Modifier
                .fillMaxSize()
                .weight(1f)
                .background(backColorPrimary)
        ) {
            RiddleAnswerState(
                riddles = riddles,
                modifier = Modifier.align(Alignment.Center),
                onNextClick = onNextClick
            )
        }
    }
}

@Composable
fun RiddleQuestionCard(riddles: List<Riddle>, modifier: Modifier = Modifier) {
    val scroll = rememberScrollState(0)
    Card(modifier = modifier, colors = CardDefaults.cardColors(containerColor = surfaceColor)) {
        Column(
            modifier = Modifier
                .fillMaxWidth()
                .padding(paddingPrimary.dp)
                .background(surfaceColor),
            horizontalAlignment = Alignment.CenterHorizontally,
            verticalArrangement = Arrangement.Center
        ) {
            riddles.forEach { riddle ->
                Text(
                    text = riddle.title,
                    style = MaterialTheme.typography.headlineMedium,
                    modifier = Modifier.align(Alignment.Start),
                    color = textColorPrimary
                )
                Spacer(modifier = Modifier.height(16.dp))
                Text(
                    text = riddle.question,
                    modifier = Modifier.verticalScroll(scroll),
                    style = MaterialTheme.typography.bodyLarge,
                    textAlign = TextAlign.Center,
                    color = textColorPrimary
                )
            }
        }
    }
}

@Composable
fun RiddleAnswerState(
    riddles: List<Riddle>,
    modifier: Modifier = Modifier,
    onNextClick: () -> Unit
) {
    val showAnswerState = remember { mutableStateOf(false) }
    when (showAnswerState.value) {
        false -> {
            Button(
                modifier = modifier,
                onClick = { showAnswerState.value = true },
                colors = ButtonDefaults.buttonColors(
                    containerColor = buttonColorPrimary,
                    contentColor = buttonTextColorPrimary
                )
            ) {
                Text(text = stringResource(R.string.show_answer), color = buttonTextColorPrimary)
            }
        }

        true -> {
            RiddleAnswerCard(
                riddles = riddles,
                modifier = modifier,
                onNextClick = onNextClick
            )
        }
    }
}

@Composable
fun RiddleAnswerCard(
    riddles: List<Riddle>,
    modifier: Modifier = Modifier,
    onNextClick: () -> Unit
) {
    Column(
        modifier = modifier
            .fillMaxSize()
            .background(backColorPrimary),
        horizontalAlignment = Alignment.CenterHorizontally,
        verticalArrangement = Arrangement.Center
    ) {
        val scroll = rememberScrollState(0)
        Card(colors = CardDefaults.cardColors(containerColor = surfaceColor)) {
            Box(
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(paddingPrimary.dp)
                    .background(surfaceColor)
            ) {
                riddles.forEach { riddle ->
                    Text(
                        text = riddle.answer,
                        modifier = Modifier
                            .align(Alignment.Center)
                            .verticalScroll(scroll),
                        textAlign = TextAlign.Center,
                        style = MaterialTheme.typography.bodyLarge,
                        color = textColorPrimary
                    )
                }
            }
        }
        Spacer(modifier = Modifier.height(16.dp))
        Button(
            onClick = { onNextClick() },
            colors = ButtonDefaults.buttonColors(
                containerColor = buttonColorPrimary,
                contentColor = buttonTextColorPrimary
            )
        ) {
            Text(text = stringResource(R.string.next_riddle), color = buttonTextColorPrimary)
        }
    }
}

@Composable
fun ErrorState(modifier: Modifier = Modifier, error: String, onRetryClick: () -> Unit) {
    Column(
        modifier = modifier.background(backColorPrimary),
        horizontalAlignment = Alignment.CenterHorizontally,
        verticalArrangement = Arrangement.Center
    ) {
        Text(text = error, style = MaterialTheme.typography.bodyLarge, color = textColorPrimary)
        Spacer(modifier = Modifier.height(16.dp))
        Button(
            onClick = { onRetryClick() },
            colors = ButtonDefaults.buttonColors(
                containerColor = buttonColorPrimary,
                contentColor = buttonTextColorPrimary
            )
        ) {
            Text(text = stringResource(R.string.retry), color = buttonTextColorPrimary)
        }
    }
}
""", fileName: "MainFragment.kt")
    }
    
    static func dependencies(_ mainData: MainData) -> ANDData {
        ANDData(
            mainFragmentData: ANDMainFragment(imports: "", content: ""),
            mainActivityData: ANDMainActivity(imports: "", extraFunc: "", content: ""),
            themesData: ANDThemesData(isDefault: true, content: ""),
            stringsData: ANDStringsData(additional: """
    <string name="connection_lost">Connection lost</string>
    <string name="server_error">Server error</string>
    <string name="unexpected_error">Unexpected error</string>
    <string name="riddle_realm">Riddle Realm</string>
    <string name="retry">Retry</string>
    <string name="next_riddle">Next Riddle</string>
    <string name="show_answer">Show Answer</string>
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
apply plugin: 'dagger.hilt.android.plugin'
apply plugin: 'kotlin-kapt'

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

        buildConfigField "String", "API_KEY", API_KEY
        buildConfigField "String", "BASE_URL", BASE_URL
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
        buildConfig true
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
    implementation Dependencies.retrofit
    implementation Dependencies.converter_gson
    kapt Dependencies.dagger_hilt_compiler
    kapt Dependencies.hilt_viewmodel_compiler
    
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
    const val gradle = "8.1.0"
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
    
    static var fileName: String = ""
    
    static func fileContent(packageName: String, uiSettings: UISettings) -> String {
        return ""
    }
    
    
}
