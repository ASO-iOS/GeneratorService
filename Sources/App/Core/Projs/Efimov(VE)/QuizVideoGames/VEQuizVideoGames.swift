//
//  File.swift
//  
//
//  Created by admin on 8/20/23.
//

import Foundation
struct VEQuizVideoGames: FileProviderProtocol {
    static var fileName = "\(NamesManager.shared.fileName).kt"
    
    static func fileContent(packageName: String, uiSettings: UISettings) -> String {
        """
package \(packageName).presentation.fragments.main_fragment

import android.text.Html
import android.util.Log
import androidx.compose.animation.core.FastOutSlowInEasing
import androidx.compose.animation.core.RepeatMode
import androidx.compose.animation.core.animateFloat
import androidx.compose.animation.core.animateFloatAsState
import androidx.compose.animation.core.infiniteRepeatable
import androidx.compose.animation.core.rememberInfiniteTransition
import androidx.compose.animation.core.tween
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.material.ButtonDefaults
import androidx.compose.material.TextButton
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Refresh
import androidx.compose.material.icons.outlined.VideogameAsset
import androidx.compose.material3.AlertDialog
import androidx.compose.material3.Button
import androidx.compose.material3.Card
import androidx.compose.material3.CardDefaults
import androidx.compose.material3.Icon
import androidx.compose.material3.LinearProgressIndicator
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.material3.Typography
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.rotate
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.graphicsLayer
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.TextStyle
import androidx.compose.ui.text.font.FontFamily
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.compose.ui.window.DialogProperties
import androidx.hilt.navigation.compose.hiltViewModel
import androidx.lifecycle.SavedStateHandle
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.google.gson.annotations.SerializedName
import com.ramcosta.composedestinations.annotation.Destination
import com.ramcosta.composedestinations.annotation.RootNavGraph
import com.ramcosta.composedestinations.navigation.DestinationsNavigator
import com.ramcosta.composedestinations.navigation.popUpTo
import \(packageName).R
import \(packageName).presentation.fragments.main_fragment.destinations.MenuScreenDestination
import \(packageName).presentation.fragments.main_fragment.destinations.QuizScreenDestination
import \(packageName).presentation.fragments.main_fragment.destinations.SplashScreenDestination
import dagger.Module
import dagger.Provides
import dagger.hilt.InstallIn
import dagger.hilt.android.lifecycle.HiltViewModel
import dagger.hilt.components.SingletonComponent
import kotlinx.coroutines.CoroutineDispatcher
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.delay
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
import kotlin.math.absoluteValue

val textColorPrimary = Color(0xFF\(uiSettings.textColorPrimary ?? "FFFFFF"))
val backColorPrimary = Color(0xFF\(uiSettings.backColorPrimary ?? "FFFFFF"))
val surfaceColor = Color(0xFF\(uiSettings.surfaceColor ?? "FFFFFF"))

@Composable
fun QuizVideoGamesTheme(
    content: @Composable () -> Unit
) {
    MaterialTheme(
        typography = Typography,
        content = content
    )
}

val Typography = Typography(
    bodyLarge = TextStyle(
        fontFamily = FontFamily.Default,
        fontWeight = FontWeight.Normal,
        fontSize = 16.sp,
        lineHeight = 24.sp,
        letterSpacing = 0.5.sp
    )
)
data class QuizDto(
    @SerializedName("category") val category: String,
    @SerializedName("type") val type: String,
    @SerializedName("difficulty") val difficulty: String,
    @SerializedName("question") val question: String,
    @SerializedName("correct_answer") val correctAnswer: String,
    @SerializedName("incorrect_answers") val incorrectAnswers: List<String>,
)

data class QuizResult(
    @SerializedName("response_code") val responseCode: Int,
    @SerializedName("results") val results: List<QuizDto>
)

fun QuizDto.toQuiz(): Question {
    val shuffledList = mutableListOf(correctAnswer)
    shuffledList.addAll(incorrectAnswers)
    shuffledList.replaceAll { it.decodeFromHtml() }

    return Question(
        question = question.decodeFromHtml(),
        correctAnswer = correctAnswer.decodeFromHtml(),
        answers = shuffledList.shuffled()
    )
}

private fun String.decodeFromHtml() =
    Html.fromHtml(this, Html.FROM_HTML_MODE_COMPACT).toString()

object Endpoints {
    const val BASE_URL = "https://opentdb.com/"
    const val API_ENDPOINT = "/api.php"
}

interface QuizApi {

    @GET(Endpoints.API_ENDPOINT)
    suspend fun getQuizList(
        @Query("amount") amount: Int = 10,
        @Query("category") category: Int = 15,
        @Query("difficulty") difficulty: String,
        @Query("type") type: String = "multiple"
    ): QuizResult

}

class QuizRepositoryImpl(
    private val api: QuizApi
): QuizRepository {
    override suspend fun getQuizList(difficulty: String): List<Question> {
        return api.getQuizList(difficulty = difficulty).results.map { it.toQuiz() }
    }
}

object QuizDifficult {
    const val EASY = "easy"
    const val MEDIUM = "medium"
    const val HARD = "hard"
}

@Module
@InstallIn(SingletonComponent::class)
class DataModule {

    @Provides
    @Singleton
    fun provideQuizApi(): QuizApi {
        return Retrofit.Builder()
            .baseUrl(Endpoints.BASE_URL)
            .addConverterFactory(GsonConverterFactory.create())
            .build()
            .create(QuizApi::class.java)
    }

    @Provides
    @Singleton
    fun provideQuizRepository(api: QuizApi): QuizRepository {
        return QuizRepositoryImpl(api = api)
    }

    @Provides
    @Singleton
    fun provideCoroutineDispatcher() = Dispatchers.IO
}

data class Question(
    val question: String,
    val answers: List<String>,
    val correctAnswer: String
)

interface QuizRepository {
    suspend fun getQuizList(difficulty: String): List<Question>
}

class GetQuizListUseCase @Inject constructor(
    private val repository: QuizRepository,
    private val dispatcher: CoroutineDispatcher
) {
    suspend operator fun invoke(difficulty: String): Result<List<Question>> =
        kotlin.runCatching {
            withContext(dispatcher) {
                repository.getQuizList(difficulty)
            }
        }
}

@Destination
@Composable
fun MenuScreen(navigator: DestinationsNavigator) {
    Column(
        modifier = Modifier
            .fillMaxSize()
            .background(backColorPrimary),
        horizontalAlignment = Alignment.CenterHorizontally,
        verticalArrangement = Arrangement.spacedBy(20.dp, Alignment.CenterVertically)
    ) {
        Column(
            modifier = Modifier.weight(2f),
            horizontalAlignment = Alignment.CenterHorizontally,
            verticalArrangement = Arrangement.spacedBy(20.dp, Alignment.CenterVertically)
        ) {
            Icon(
                modifier = Modifier.size(100.dp),
                imageVector = Icons.Outlined.VideogameAsset,
                contentDescription = null,
                tint = textColorPrimary
            )
            Text(
                text = stringResource(id = R.string.title_difficulty),
                style = MaterialTheme.typography.titleLarge,
                color = textColorPrimary,
                fontSize = 35.sp
            )
        }
        Spacer(modifier = Modifier.height(30.dp))
        Column(
            modifier = Modifier.weight(4f),
            horizontalAlignment = Alignment.CenterHorizontally,
            verticalArrangement = Arrangement.Center
        ) {
            TextButtonWithResource(
                resId = R.string.easy,
                onClick = { navigator.navigate(QuizScreenDestination(difficulty = QuizDifficult.EASY)) }
            )
            TextButtonWithResource(
                resId = R.string.medium,
                onClick = { navigator.navigate(QuizScreenDestination(difficulty = QuizDifficult.MEDIUM)) }
            )
            TextButtonWithResource(
                resId = R.string.hard,
                onClick = { navigator.navigate(QuizScreenDestination(difficulty = QuizDifficult.HARD)) }
            )
        }
    }
}

@Destination
@Composable
fun QuizScreen(
    difficulty: String,
    viewModel: QuizViewModel = hiltViewModel()
) {
    Box(
        modifier = Modifier
            .background(backColorPrimary)
    ) {
        when(val state = viewModel.state.collectAsState().value) {
            is UiQuizState.Loading -> Loading()
            is UiQuizState.Error -> ErrorLayout(
                resId = state.resId,
                onTryAgain = { viewModel.getQuizList(difficulty) }
            )
            is UiQuizState.SuccessQuestion -> QuestionsWithAnswers(
                questionItem = state.question,
                onAnswerClick = viewModel::getNextQuestion
            )
            is UiQuizState.QuizEnds -> QuizResult(
                correctCount = state.correctAnswerCount,
                correctMaxCount = state.maxCorrectCount,
                onRetry = { viewModel.resetProgressAndRetryAgain(difficulty) }
            )
        }
    }
}

@Composable
private fun QuestionsWithAnswers(
    questionItem: Question,
    onAnswerClick: (answer: String) -> Unit
) {
    var answerState: String? by remember { mutableStateOf(null) }

    var isRotated by remember { mutableStateOf(false) }
    val alphaAnimation = animateFloatAsState(
        targetValue = if(isRotated) 1f else 0f,
        animationSpec = tween(
            durationMillis = 600,
            easing = FastOutSlowInEasing
        )
    )

    var isOpenAnimation by remember { mutableStateOf(false) }
    val rotateFloat = animateFloatAsState(
        targetValue = if(isOpenAnimation) 0f else -180f,
        animationSpec = tween(
            durationMillis = 600,
            easing = FastOutSlowInEasing
        )
    ) {
        if(!isOpenAnimation)
            answerState?.let { onAnswerClick(it) }
    }

    LaunchedEffect(key1 = answerState) { isOpenAnimation = false }

    LaunchedEffect(key1 = questionItem) { isOpenAnimation = true }

    LaunchedEffect(key1 = rotateFloat.value.absoluteValue) {
        isRotated = rotateFloat.value.absoluteValue in 0.0..120.0
    }

    LazyColumn(
        modifier = Modifier
            .fillMaxSize()
            .graphicsLayer {
                rotationY = rotateFloat.value
                cameraDistance = 20 * density
                alpha = alphaAnimation.value
            },
        contentPadding = PaddingValues(10.dp),
        horizontalAlignment = Alignment.CenterHorizontally,
        verticalArrangement = Arrangement.spacedBy(20.dp, Alignment.CenterVertically)
    ) {
        item {
            Card(
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(horizontal = 10.dp),
                colors = CardDefaults.cardColors(
                    containerColor = surfaceColor
                )
            ) {
                Text(
                    modifier = Modifier.padding(horizontal = 20.dp, vertical = 40.dp),
                    text = questionItem.question,
                    style = MaterialTheme.typography.titleLarge,
                    color = textColorPrimary,
                    textAlign = TextAlign.Center
                )
            }
        }

        items(questionItem.answers) { answer ->
            TextButton(
                onClick = { answerState = answer }
            ) {
                Text(
                    text = answer,
                    style = MaterialTheme.typography.titleLarge,
                    color = textColorPrimary,
                    textAlign = TextAlign.Center
                )
            }
        }
    }
}

@Composable
private fun QuizResult(
    correctCount: Int,
    correctMaxCount: Int,
    onRetry: () -> Unit
) {
    AlertDialog(
        title = {
            androidx.compose.material.Text(
                text = stringResource(id = R.string.result_score, correctCount, correctMaxCount),
                style = MaterialTheme.typography.titleLarge,
                color = textColorPrimary
            )
        },
        onDismissRequest = {  },
        confirmButton = {
            Button(onClick = onRetry) {
                Text(
                    text = stringResource(id = R.string.try_again),
                    style = MaterialTheme.typography.titleLarge,
                    color = textColorPrimary
                )
                Spacer(modifier = Modifier.size(ButtonDefaults.IconSpacing))
                Icon(
                    modifier = Modifier.size(30.dp),
                    imageVector = Icons.Default.Refresh,
                    contentDescription = null,
                    tint = textColorPrimary
                )
            }
        },
        icon = {  },
        properties = DialogProperties(
            dismissOnBackPress = false,
            dismissOnClickOutside = false
        )
    )
}

@Composable
private fun ErrorLayout(
    resId: Int,
    onTryAgain: () -> Unit
) {
    Column(
        modifier = Modifier.fillMaxSize(),
        horizontalAlignment = Alignment.CenterHorizontally,
        verticalArrangement = Arrangement.spacedBy(20.dp, Alignment.CenterVertically)
    ) {
        Text(
            text = stringResource(id = resId),
            style = MaterialTheme.typography.titleLarge,
            color = textColorPrimary,
            fontSize = 25.sp
        )
        Button(onClick = onTryAgain) {
            Text(
                text = stringResource(id = R.string.try_again),
                style = MaterialTheme.typography.titleLarge,
                color = textColorPrimary
            )
            Spacer(modifier = Modifier.size(ButtonDefaults.IconSpacing))
            Icon(
                modifier = Modifier.size(30.dp),
                imageVector = Icons.Default.Refresh,
                contentDescription = null,
                tint = textColorPrimary
            )
        }
    }
}

@Composable
private fun Loading() {
    Column(
        modifier = Modifier.fillMaxSize(),
        horizontalAlignment = Alignment.CenterHorizontally,
        verticalArrangement = Arrangement.spacedBy(10.dp, Alignment.CenterVertically)
    ) {
        Text(
            text = stringResource(id = R.string.loading),
            style = MaterialTheme.typography.titleLarge,
            color = textColorPrimary,
            fontSize = 25.sp
        )
        LinearProgressIndicator(
            color = textColorPrimary,
            trackColor = backColorPrimary
        )
    }
}

@HiltViewModel
class QuizViewModel @Inject constructor(
    private val getQuizListUseCase: GetQuizListUseCase,
    savedStateHandle: SavedStateHandle
): ViewModel() {
    private val _state = MutableStateFlow<UiQuizState>(UiQuizState.Loading)
    val state = _state.asStateFlow()

    private val _questions = MutableStateFlow<List<Question>>(emptyList())
    private var questionIndex = 0
    private var correctAnswerCount = 0

    private val difficulty = savedStateHandle.get<String>("difficulty") ?: QuizDifficult.EASY

    init {
        getQuizList(difficulty)
    }

    fun getQuizList(difficulty: String) {
        _state.value = UiQuizState.Loading

        viewModelScope.launch {
            getQuizListUseCase(difficulty)
                .onSuccess { list ->
                    if(list.isNotEmpty()) {
                        _questions.value = list
                        _state.value = UiQuizState.SuccessQuestion(_questions.value[questionIndex])
                    }
                    else
                        _state.value = UiQuizState.Error(R.string.internal_error)
                }
                .onFailure { throwable ->
                    val resId = when(throwable) {
                        is IOException -> R.string.io_exception
                        else -> R.string.unexpected
                    }
                    Log.e("TAG", "getQuizList: ", throwable )
                    _state.value = UiQuizState.Error(resId)
                }
        }
    }

    fun resetProgressAndRetryAgain(difficulty: String) {
        questionIndex = 0
        correctAnswerCount = 0
        getQuizList(difficulty)
    }

    fun getNextQuestion(answer: String) {

        if(checkCorrectAnswer(answer)) correctAnswerCount++

        questionIndex++
        if(questionIndex < _questions.value.size) {
            _state.value = UiQuizState.SuccessQuestion(_questions.value[questionIndex])
        } else {
            _state.value = UiQuizState.QuizEnds(
                correctAnswerCount,
                _questions.value.size
            )
        }
    }

    private fun checkCorrectAnswer(answer: String): Boolean {
        return answer == _questions.value[questionIndex].correctAnswer
    }
}

sealed class UiQuizState {
    object Loading: UiQuizState()
    class Error(val resId: Int): UiQuizState()
    class SuccessQuestion(val question: Question): UiQuizState()
    class QuizEnds(val correctAnswerCount: Int, val maxCorrectCount: Int): UiQuizState()
}

@RootNavGraph(start = true)
@Destination
@Composable
fun SplashScreen(
    navigator: DestinationsNavigator
) {
    val infiniteTransition = rememberInfiniteTransition()
    val angle = 20f

    val rotation by infiniteTransition.animateFloat(
        initialValue = -angle,
        targetValue = angle,
        animationSpec = infiniteRepeatable(
            animation = tween(500),
            repeatMode = RepeatMode.Reverse
        )
    )

    LaunchedEffect(key1 = Unit) {
        delay(3000)
        navigator.navigate(MenuScreenDestination()) {
            popUpTo(SplashScreenDestination) { inclusive = true }
        }
    }

    Column(
        modifier = Modifier
            .fillMaxSize()
            .background(backColorPrimary),
        horizontalAlignment = Alignment.CenterHorizontally,
        verticalArrangement = Arrangement.spacedBy(20.dp, Alignment.CenterVertically)
    ) {
        Icon(
            modifier = Modifier
                .size(100.dp)
                .rotate(rotation),
            imageVector = Icons.Outlined.VideogameAsset,
            contentDescription = null,
            tint = textColorPrimary
        )
        Text(
            text = stringResource(id = R.string.app_name),
            style = MaterialTheme.typography.titleLarge,
            color = textColorPrimary,
            fontSize = 30.sp
        )
    }
}

@Composable
fun TextButtonWithResource(
    resId: Int,
    onClick: () -> Unit
) {
    TextButton(onClick = onClick) {
        Text(
            text = stringResource(id = resId),
            style = MaterialTheme.typography.titleLarge,
            color = textColorPrimary,
            fontSize = 40.sp
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
    QuizVideoGamesTheme {
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
    <string name="easy">Easy</string>
    <string name="medium">Medium</string>
    <string name="hard">Hard</string>
    <string name="title_difficulty">Choose quiz difficulty</string>
    <string name="io_exception">Check your internet connection!</string>
    <string name="unexpected">Unexpected error!</string>
    <string name="internal_error">Internal error</string>
    <string name="try_again">Try again</string>
    <string name="loading">Loading…</string>
    <string name="result_score">Your score: %d / %d</string>
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

plugins{
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
