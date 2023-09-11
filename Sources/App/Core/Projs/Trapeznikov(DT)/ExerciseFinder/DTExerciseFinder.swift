//
//  File.swift
//  
//
//  Created by admin on 9/7/23.
//

import Foundation


struct DTExerciseFinder: SFFileProviderProtocol {
    static func mainFragmentCMF(_ mainData: MainData) -> ANDMainFragmentCMF {
        ANDMainFragmentCMF(content: """
package \(mainData.packageName).presentation.fragments.main_fragment

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.compose.foundation.Image
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.text.KeyboardActions
import androidx.compose.foundation.text.KeyboardOptions
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Circle
import androidx.compose.material.icons.filled.FitnessCenter
import androidx.compose.material3.Card
import androidx.compose.material3.CardDefaults
import androidx.compose.material3.CircularProgressIndicator
import androidx.compose.material3.Icon
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.OutlinedTextField
import androidx.compose.material3.OutlinedTextFieldDefaults
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.saveable.rememberSaveable
import androidx.compose.ui.Alignment
import androidx.compose.ui.ExperimentalComposeUiApi
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.ColorFilter
import androidx.compose.ui.platform.ComposeView
import androidx.compose.ui.platform.LocalFocusManager
import androidx.compose.ui.platform.LocalSoftwareKeyboardController
import androidx.compose.ui.res.dimensionResource
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.input.ImeAction
import androidx.compose.ui.text.input.KeyboardType
import androidx.compose.ui.text.style.TextAlign
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
import kotlinx.coroutines.FlowPreview
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.flow.debounce
import kotlinx.coroutines.flow.distinctUntilChanged
import kotlinx.coroutines.flow.filter
import kotlinx.coroutines.flow.flow
import kotlinx.coroutines.flow.map
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
import java.net.ConnectException
import java.net.SocketTimeoutException
import java.net.UnknownHostException
import javax.inject.Inject
import javax.inject.Singleton
import javax.net.ssl.SSLHandshakeException

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
        ExerciseScreen()
    }
}

sealed class Resource<T> {
    class Success<T>(val data: T) : Resource<T>()
    class Error<T>(val error: ResponseError) : Resource<T>()
    class Loading<T> : Resource<T>()
}

enum class ResponseError {
    BAD_REQUEST,
    UNAUTHORIZED,
    FORBIDDEN,
    NOT_FOUND,
    INTERNAL_SERVER,
    CONNECTION,
    UNKNOWN_HOST,
    SOCKET_TIMEOUT,
    SSL,
    UNEXPECTED,
    EMPTY_BODY
}

fun ExerciseDto.toDomain(): Exercise {
    return Exercise(
        name = this.name,
        muscle = this.muscle.replaceFirstChar { it.uppercase() },
        instructions = this.instructions,
        difficulty = this.difficulty
    )
}

fun Throwable.toResponseError(): ResponseError {
    return when (this) {
        is ConnectException -> ResponseError.CONNECTION
        is UnknownHostException -> ResponseError.UNKNOWN_HOST
        is SocketTimeoutException -> ResponseError.SOCKET_TIMEOUT
        is SSLHandshakeException -> ResponseError.SSL
        else -> ResponseError.UNEXPECTED
    }
}

fun Int.toResponseError(): ResponseError {
    return when (this) {
        400 -> ResponseError.BAD_REQUEST
        401 -> ResponseError.UNAUTHORIZED
        403 -> ResponseError.FORBIDDEN
        404 -> ResponseError.NOT_FOUND
        500 -> ResponseError.INTERNAL_SERVER
        else -> ResponseError.UNEXPECTED
    }
}

data class ExerciseDto(
    @SerializedName("difficulty")
    val difficulty: String,
    @SerializedName("equipment")
    val equipment: String,
    @SerializedName("instructions")
    val instructions: String,
    @SerializedName("muscle")
    val muscle: String,
    @SerializedName("name")
    val name: String,
    @SerializedName("type")
    val type: String
)

class AuthInterceptor : Interceptor {

    override fun intercept(chain: Interceptor.Chain): Response {
        val request = chain.request().newBuilder()
            .addHeader("X-Api-Key", "zOevlY5qtngRacRnWBdJSA==8YDMqZkhD4IS9sxC")
            .build()
        return chain.proceed(request)
    }
}

interface ExerciseService {

    @GET("v1/exercises")
    suspend fun getExercisesByName(@Query("name") name: String): retrofit2.Response<List<ExerciseDto>>
}

class ExerciseRepositoryImpl(
    private val exerciseService: ExerciseService
) : ExerciseRepository {

    override suspend fun getExercisesByName(name: String): Flow<Resource<List<Exercise>>> =
        flow {
            emit(Resource.Loading())
            try {
                val response = exerciseService.getExercisesByName(name)
                val body = response.body()
                if (response.isSuccessful && body != null) {
                    if (body.isNotEmpty()) {
                        emit(Resource.Success(body.map { it.toDomain() }))
                    } else {
                        emit(Resource.Error(ResponseError.EMPTY_BODY))
                    }
                } else {
                    emit(Resource.Error(ResponseError.UNEXPECTED))
                }
            } catch (e: Throwable) {
                when (e) {
                    is HttpException -> emit(Resource.Error(e.code().toResponseError()))
                    is IOException -> emit(Resource.Error(e.toResponseError()))
                    else -> emit(Resource.Error(ResponseError.UNEXPECTED))
                }
                e.printStackTrace()
            }
        }
}

@Module
@InstallIn(SingletonComponent::class)
class DataModule {

    @Singleton
    @Provides
    fun provideNutritionService(): ExerciseService {
        val httpClient = OkHttpClient.Builder()
            .addInterceptor(AuthInterceptor())
            .build()

        val retrofit = Retrofit.Builder()
            .client(httpClient)
            .baseUrl("https://api.api-ninjas.com/")
            .addConverterFactory(GsonConverterFactory.create())
            .build()

        return retrofit.create(ExerciseService::class.java)
    }

    @Singleton
    @Provides
    fun provideNutritionRepository(
        exerciseService: ExerciseService
    ): ExerciseRepository {
        return ExerciseRepositoryImpl(exerciseService)
    }
}

@HiltViewModel
class ExerciseViewModel @Inject constructor(
    private val exerciseRepository: ExerciseRepository
) : ViewModel() {

    private val _state = MutableStateFlow(ExerciseState())
    val state = _state.asStateFlow()

    private val userInput = MutableStateFlow("")

    init {
        observeUserInput()
    }

    fun onUserInputChanged(input: String) {
        userInput.value = input
    }

    @OptIn(FlowPreview::class)
    private fun observeUserInput() {
        viewModelScope.launch {
            userInput
                .filter { it.isNotBlank() }
                .map { it.trim() }
                .debounce(2000)
                .distinctUntilChanged()
                .collect {
                    getExerciseByName(it)
                }
        }
    }

    private suspend fun getExerciseByName(text: String) {
        exerciseRepository.getExercisesByName(text).collect {
            when (it) {
                is Resource.Success -> _state.value = ExerciseState(exercises = it.data)
                is Resource.Loading -> _state.value = ExerciseState(isLoading = true)
                is Resource.Error -> _state.value = ExerciseState(error = it.error)
            }
        }
    }
}

data class ExerciseState(
    val exercises: List<Exercise> = emptyList(),
    val isLoading: Boolean = false,
    val error: ResponseError? = null
)

val backColorPrimary = Color(0xFF\(mainData.uiSettings.backColorPrimary ?? "FFFFFF"))
val textColorPrimary = Color(0xFF\(mainData.uiSettings.textColorPrimary ?? "FFFFFF"))
val buttonColorPrimary = Color(0xFF\(mainData.uiSettings.buttonColorPrimary ?? "FFFFFF"))
val surfaceColor = Color(0xFF\(mainData.uiSettings.surfaceColor ?? "FFFFFF"))

@Composable
fun ExerciseItem(exercise: Exercise, modifier: Modifier = Modifier) {
    Card(
        modifier = modifier,
        colors = CardDefaults.cardColors(containerColor = surfaceColor),
        elevation = CardDefaults.cardElevation(dimensionResource(id = R.dimen.card_elevation))
    ) {
        Column(
            modifier = Modifier
                .padding(dimensionResource(id = R.dimen.primary_padding))
                .fillMaxWidth()
        ) {
            Row(modifier = Modifier.background(surfaceColor)) {
                Text(
                    text = exercise.name,
                    style = MaterialTheme.typography.headlineLarge,
                    modifier = Modifier.weight(1f),
                    color = textColorPrimary
                )
                Spacer(modifier = Modifier.width(dimensionResource(id = R.dimen.primary_margin)))
                Icon(
                    imageVector = Icons.Default.Circle,
                    contentDescription = null,
                    tint = when (exercise.difficulty) {
                        "expert" -> Color.Red
                        "intermediate" -> Color.Yellow
                        "beginner" -> Color.Green
                        else -> Color.Unspecified
                    }
                )
            }
            Spacer(modifier = Modifier.height(dimensionResource(id = R.dimen.primary_margin)))
            Text(
                text = exercise.muscle,
                style = MaterialTheme.typography.headlineMedium,
                color = textColorPrimary
            )
            Spacer(modifier = Modifier.height(dimensionResource(id = R.dimen.primary_margin)))
            Text(
                text = exercise.instructions,
                style = MaterialTheme.typography.bodyLarge,
                color = textColorPrimary
            )
        }
    }
}

@Composable
fun ExerciseScreen(viewModel: ExerciseViewModel = hiltViewModel()) {
    val state = viewModel.state.collectAsState().value
    Scaffold(
        modifier = Modifier
            .background(color = backColorPrimary)
            .fillMaxSize()
    ) { paddingValues ->
        Box(
            modifier = Modifier
                .background(color = backColorPrimary)
                .fillMaxSize()
                .padding(paddingValues)
                .padding(
                    start = dimensionResource(id = R.dimen.primary_padding),
                    end = dimensionResource(id = R.dimen.primary_padding)
                )
        ) {
            LazyColumn(
                modifier = Modifier.background(color = backColorPrimary),
                verticalArrangement = Arrangement.spacedBy(dimensionResource(id = R.dimen.primary_margin)),
                contentPadding = PaddingValues(
                    top = dimensionResource(id = R.dimen.primary_padding),
                    bottom = dimensionResource(id = R.dimen.primary_padding)
                )
            ) {
                item {
                    Header(
                        modifier = Modifier
                            .background(color = backColorPrimary)
                            .fillMaxWidth()
                    ) {
                        viewModel.onUserInputChanged(it)
                    }
                }
                items(state.exercises) { exercise ->
                    ExerciseItem(exercise = exercise)
                }
            }
            when {
                state.isLoading -> {
                    CircularProgressIndicator(
                        modifier = Modifier.align(Alignment.Center),
                        color = buttonColorPrimary
                    )
                }

                state.error != null -> {
                    ErrorText(error = state.error, modifier = Modifier.align(Alignment.Center))
                }

                state.exercises.isEmpty() -> {
                    Image(
                        imageVector = Icons.Default.FitnessCenter,
                        contentDescription = null,
                        modifier = Modifier
                            .align(Alignment.Center)
                            .size(dimensionResource(id = R.dimen.back_image)),
                        colorFilter = ColorFilter.tint(MaterialTheme.colorScheme.surfaceVariant)
                    )
                }
            }
        }
    }
}

@Composable
fun ErrorText(error: ResponseError, modifier: Modifier = Modifier) {
    val text = when (error) {
        ResponseError.BAD_REQUEST -> stringResource(id = R.string.http_bad_request)
        ResponseError.UNAUTHORIZED -> stringResource(id = R.string.http_unauthorized)
        ResponseError.FORBIDDEN -> stringResource(id = R.string.http_forbidden)
        ResponseError.NOT_FOUND -> stringResource(id = R.string.http_not_found)
        ResponseError.INTERNAL_SERVER -> stringResource(id = R.string.http_internal_server_error)
        ResponseError.CONNECTION -> stringResource(id = R.string.connection_exception)
        ResponseError.UNKNOWN_HOST -> stringResource(id = R.string.host_exception)
        ResponseError.SOCKET_TIMEOUT -> stringResource(id = R.string.socket_exception)
        ResponseError.SSL -> stringResource(id = R.string.ssl_exception)
        ResponseError.UNEXPECTED -> stringResource(id = R.string.unexpected_error)
        ResponseError.EMPTY_BODY -> stringResource(id = R.string.couldnt_find)
    }
    Text(
        text = text,
        textAlign = TextAlign.Center,
        modifier = modifier,
        color = textColorPrimary
    )
}

@OptIn(ExperimentalComposeUiApi::class)
@Composable
fun Header(modifier: Modifier = Modifier, onUserInputChange: (String) -> Unit) {
    val keyboardController = LocalSoftwareKeyboardController.current
    val focusManager = LocalFocusManager.current
    val textFieldState = rememberSaveable { mutableStateOf("") }
    Column(
        modifier = modifier.background(color = backColorPrimary),
        horizontalAlignment = Alignment.CenterHorizontally
    ) {
        Text(
            text = stringResource(R.string.exercise_finder),
            style = MaterialTheme.typography.titleLarge,
            modifier = Modifier.align(Alignment.Start),
            color = textColorPrimary
        )
        Spacer(modifier = Modifier.height(dimensionResource(id = R.dimen.primary_margin)))
        OutlinedTextField(
            modifier = Modifier.fillMaxWidth(),
            value = textFieldState.value,
            placeholder = { Text(text = stringResource(R.string.input_a_text)) },
            singleLine = true,
            colors = OutlinedTextFieldDefaults.colors(
                focusedTextColor = textColorPrimary,
                unfocusedTextColor = textColorPrimary,
                cursorColor = buttonColorPrimary,
                focusedBorderColor = buttonColorPrimary,
                unfocusedBorderColor = textColorPrimary,
                focusedContainerColor = backColorPrimary,
                unfocusedContainerColor = backColorPrimary
            ),
            keyboardOptions = KeyboardOptions.Default.copy(
                keyboardType = KeyboardType.Text,
                imeAction = ImeAction.Done
            ),
            keyboardActions = KeyboardActions(onDone = {
                keyboardController?.hide()
                focusManager.clearFocus(true)
            }),
            onValueChange = {
                textFieldState.value = it
                if (it.isNotBlank()) onUserInputChange(it)
            }
        )
    }
}

data class Exercise(
    val name: String,
    val muscle: String,
    val instructions: String,
    val difficulty: String,
)

interface ExerciseRepository {

    suspend fun getExercisesByName(name: String): Flow<Resource<List<Exercise>>>
}
""", fileName: "MainFragment.kt")
    }
    
    static func dependencies(_ mainData: MainData) -> ANDData {
        ANDData(mainFragmentData: ANDMainFragment(imports: "", content: ""),
                mainActivityData: ANDMainActivity(imports: "", extraFunc: "", content: ""),
                themesData: ANDThemesData(isDefault: true, content: ""),
                stringsData: ANDStringsData(additional: """
    <string name="connection_exception">Connection lost</string>
    <string name="server_error">Server error</string>
    <string name="unexpected_error">Unexpected error</string>
    <string name="couldnt_find">Couldn\\'t find an exercise with that name</string>
    <string name="exercise_finder">\(mainData.appName)</string>
    <string name="input_a_text">Input an exercise name</string>
    <string name="socket_exception">We\\'re sorry, but it seems that the connection is taking longer than expected to establish</string>
    <string name="host_exception">We\\'re having trouble reaching the server at the moment</string>
    <string name="ssl_exception">We\\'re having trouble connecting securely to the server right now</string>
    <string name="http_bad_request">400 Bad Request</string>
    <string name="http_unauthorized">401 Unauthorized</string>
    <string name="http_forbidden">403 Forbidden</string>
    <string name="http_not_found">404 Not Found</string>
    <string name="http_internal_server_error">500 Internal Server Error</string>
    <string name="bad_connection">Slow internet connection</string>
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
