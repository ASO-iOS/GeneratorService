//
//  File.swift
//  
//
//  Created by admin on 9/1/23.
//

import Foundation

struct DTTextSimilarity: SFFileProviderProtocol {
    
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
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.material3.Button
import androidx.compose.material3.ButtonDefaults
import androidx.compose.material3.CircularProgressIndicator
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.OutlinedTextField
import androidx.compose.material3.OutlinedTextFieldDefaults
import androidx.compose.material3.Scaffold
import androidx.compose.material3.SnackbarDuration
import androidx.compose.material3.SnackbarHost
import androidx.compose.material3.SnackbarHostState
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.platform.ComposeView
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import androidx.fragment.app.Fragment
import androidx.hilt.navigation.compose.hiltViewModel
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
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
import retrofit2.HttpException
import retrofit2.Retrofit
import retrofit2.converter.gson.GsonConverterFactory
import retrofit2.http.Body
import retrofit2.http.POST
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
        SimilarityScreen()
    }
}

sealed class Resource<T> {
    class Success<T>(val data: T) : Resource<T>()
    class Error<T>(val message: String) : Resource<T>()
    class Loading<T> : Resource<T>()
}

data class SimilarityBody(
    @SerializedName("text_1")
    val textFirst: String,
    @SerializedName("text_2")
    val textSecond: String
)

data class SimilarityDto(
    @SerializedName("similarity")
    val similarity: Double
)

class AuthInterceptor(private val apiKey: String) : Interceptor {

    override fun intercept(chain: Interceptor.Chain): okhttp3.Response {
        val request = chain.request().newBuilder()
            .addHeader("X-Api-Key", apiKey)
            .build()
        return chain.proceed(request)
    }
}

interface SimilarityService {

    @POST("v1/textsimilarity")
    suspend fun getSimilarity(@Body similarityBody: SimilarityBody): retrofit2.Response<SimilarityDto>
}

class SimilarityRepositoryImpl(
    private val similarityService: SimilarityService,
    private val context: Context
) : SimilarityRepository {

    override suspend fun calcSimilarity(text1: String, text2: String): Flow<Resource<Double>> =
        flow {
            try {
                emit(Resource.Loading())
                val response = similarityService.getSimilarity(SimilarityBody(text1, text2))
                val body = response.body()
                if (response.isSuccessful && body != null) {
                    emit(Resource.Success(body.similarity))
                } else {
                    emit(Resource.Error(response.message()))
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

    @Singleton
    @Provides
    fun provideSimilarityService(): SimilarityService {
        val httpClient = OkHttpClient.Builder()
            .addInterceptor(AuthInterceptor("zOevlY5qtngRacRnWBdJSA==8YDMqZkhD4IS9sxC"))
            .build()

        val retrofit = Retrofit.Builder()
            .baseUrl("https://api.api-ninjas.com/")
            .client(httpClient)
            .addConverterFactory(GsonConverterFactory.create())
            .build()

        return retrofit.create(SimilarityService::class.java)

    }

    @Singleton
    @Provides
    fun provideSimilarityRepository(
        similarityService: SimilarityService,
        app: Application
    ): SimilarityRepository {
        return SimilarityRepositoryImpl(similarityService, app)
    }
}

interface SimilarityRepository {
    suspend fun calcSimilarity(text1: String, text2: String): Flow<Resource<Double>>
}

val backColorPrimary = Color(0xFF\(mainData.uiSettings.backColorPrimary ?? "FFFFFF"))
val textColorPrimary = Color(0xFF\(mainData.uiSettings.textColorPrimary ?? "FFFFFF"))
val buttonTextColorPrimary = Color(0xFF\(mainData.uiSettings.buttonTextColorPrimary ?? "FFFFFF"))
val buttonColorPrimary = Color(0xFF\(mainData.uiSettings.buttonColorPrimary ?? "FFFFFF"))
val paddingPrimary = 16

@Composable
fun SimilarityScreen(viewModel: SimilarityViewModel = hiltViewModel()) {
    val snackbarHostState = remember { SnackbarHostState() }
    val showSnackbar = remember { mutableStateOf(false) }
    val context = LocalContext.current
    LaunchedEffect(key1 = showSnackbar.value) {
        if (showSnackbar.value) {
            snackbarHostState.showSnackbar(
                message = context.getString(R.string.max_characters),
                duration = SnackbarDuration.Short
            )
            showSnackbar.value = false
        }
    }
    Scaffold(
        modifier = Modifier
            .fillMaxSize()
            .background(backColorPrimary),
        snackbarHost = { SnackbarHost(snackbarHostState) },
    ) { paddingValues ->
        val firstTextState = remember { mutableStateOf("") }
        val secondTextState = remember { mutableStateOf("") }
        Column(
            modifier = Modifier
                .fillMaxSize()
                .background(backColorPrimary)
                .padding(paddingValues)
                .padding(paddingPrimary.dp),
            horizontalAlignment = Alignment.CenterHorizontally
        ) {
            Text(
                text = stringResource(R.string.text_similarity),
                style = MaterialTheme.typography.titleLarge,
                modifier = Modifier.align(Alignment.Start),
                color = textColorPrimary
            )
            Spacer(modifier = Modifier.height(16.dp))
            OutlinedTextField(
                modifier = Modifier.fillMaxWidth(),
                value = firstTextState.value,
                placeholder = { Text(text = stringResource(R.string.input_a_first_text)) },
                colors = OutlinedTextFieldDefaults.colors(
                    focusedTextColor = textColorPrimary,
                    unfocusedTextColor = textColorPrimary,
                    cursorColor = buttonColorPrimary,
                    focusedBorderColor = buttonColorPrimary,
                    unfocusedBorderColor = textColorPrimary,
                    focusedContainerColor = backColorPrimary,
                    unfocusedContainerColor = backColorPrimary
                ),
                maxLines = 10,
                onValueChange = { firstTextState.value = it }
            )
            Spacer(modifier = Modifier.height(16.dp))
            OutlinedTextField(
                modifier = Modifier.fillMaxWidth(),
                value = secondTextState.value,
                placeholder = { Text(text = stringResource(R.string.input_a_second_text)) },
                colors = OutlinedTextFieldDefaults.colors(
                    focusedTextColor = textColorPrimary,
                    unfocusedTextColor = textColorPrimary,
                    cursorColor = buttonColorPrimary,
                    focusedBorderColor = buttonColorPrimary,
                    unfocusedBorderColor = textColorPrimary,
                    focusedContainerColor = backColorPrimary,
                    unfocusedContainerColor = backColorPrimary
                ),
                maxLines = 10,
                onValueChange = { secondTextState.value = it },
            )
            Spacer(modifier = Modifier.height(16.dp))
            Button(
                modifier = Modifier.fillMaxWidth(),
                colors = ButtonDefaults.buttonColors(
                    containerColor = buttonColorPrimary,
                    contentColor = buttonTextColorPrimary
                ),
                onClick = {
                    if (firstTextState.value.length > 5000 || secondTextState.value.length > 5000) {
                        showSnackbar.value = true
                    } else {
                        viewModel.calcSimilarity(
                            firstTextState.value,
                            secondTextState.value
                        )
                    }
                }
            ) {
                Text(
                    text = stringResource(R.string.calculate_similarity),
                    color = buttonTextColorPrimary
                )
            }
            Spacer(modifier = Modifier.height(16.dp))
            SimilarityStateContent(viewModel = viewModel)
        }
    }
}

@Composable
fun SimilarityStateContent(viewModel: SimilarityViewModel, modifier: Modifier = Modifier) {
    val state = viewModel.state.collectAsState()
    when {
        state.value.similarity.isNotEmpty() -> {
            Text(
                modifier = modifier,
                text = String.format(
                    stringResource(id = R.string.similarity_of_texts),
                    state.value.similarity
                ),
                textAlign = TextAlign.Center,
                style = MaterialTheme.typography.bodyLarge,
                color = textColorPrimary
            )
        }

        state.value.isLoading -> {
            CircularProgressIndicator(modifier = modifier, color = buttonColorPrimary)
        }

        state.value.error.isNotEmpty() -> {
            Text(
                modifier = modifier,
                text = state.value.error,
                textAlign = TextAlign.Center,
                style = MaterialTheme.typography.bodyLarge,
                color = textColorPrimary
            )
        }
    }
}

data class SimilarityState(
    val similarity: String = "",
    val isLoading: Boolean = false,
    val error: String = ""
)

@HiltViewModel
class SimilarityViewModel @Inject constructor(
    private val repository: SimilarityRepository
) : ViewModel() {

    private val _state = MutableStateFlow(SimilarityState())
    val state = _state.asStateFlow()

    fun calcSimilarity(text1: String, text2: String) {
        viewModelScope.launch {
            repository.calcSimilarity(text1, text2).collect {
                when (it) {
                    is Resource.Success -> _state.value =
                        SimilarityState(similarity = (it.data * 100).toInt().toString())

                    is Resource.Loading -> _state.value = SimilarityState(isLoading = true)
                    is Resource.Error -> _state.value = SimilarityState(error = it.message)
                }
            }
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
    <string name="similarity_of_texts">Similarity of texts: %1$s%%</string>
    <string name="calculate_similarity">Calculate similarity</string>
    <string name="text_similarity">\(mainData.appName)</string>
    <string name="input_a_first_text">Input a first text</string>
    <string name="input_a_second_text">Input a second text</string>
    <string name="max_characters">Maximum 5000 characters for text!</string>
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
        classpath Build.hilt_plugin
        classpath Build.kotlin_gradle_plugin
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
