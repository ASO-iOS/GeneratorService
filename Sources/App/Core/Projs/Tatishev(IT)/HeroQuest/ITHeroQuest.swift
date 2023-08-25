//
//  File.swift
//  
//
//  Created by admin on 8/24/23.
//

import Foundation

struct ITHeroQuest: FileProviderProtocol {
    static var fileName: String = "HeroQuest.kt"
    
    static func fileContent(packageName: String, uiSettings: UISettings) -> String {
        """
package \(packageName).presentation.fragments.main_fragment

import android.os.Build
import androidx.annotation.Keep
import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.isSystemInDarkTheme
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.selection.selectable
import androidx.compose.foundation.selection.selectableGroup
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.outlined.CheckCircle
import androidx.compose.material.icons.outlined.RadioButtonUnchecked
import androidx.compose.material.ripple.LocalRippleTheme
import androidx.compose.material.ripple.RippleAlpha
import androidx.compose.material.ripple.RippleTheme
import androidx.compose.material3.AlertDialog
import androidx.compose.material3.Button
import androidx.compose.material3.ButtonDefaults
import androidx.compose.material3.CardDefaults
import androidx.compose.material3.CircularProgressIndicator
import androidx.compose.material3.Icon
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.OutlinedCard
import androidx.compose.material3.Text
import androidx.compose.material3.TextButton
import androidx.compose.material3.Typography
import androidx.compose.material3.darkColorScheme
import androidx.compose.material3.dynamicDarkColorScheme
import androidx.compose.material3.dynamicLightColorScheme
import androidx.compose.material3.lightColorScheme
import androidx.compose.runtime.Composable
import androidx.compose.runtime.CompositionLocalProvider
import androidx.compose.runtime.State
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.semantics.Role
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
import \(packageName).R
import com.google.gson.annotations.SerializedName
import dagger.Module
import dagger.Provides
import dagger.hilt.InstallIn
import dagger.hilt.android.lifecycle.HiltViewModel
import dagger.hilt.components.SingletonComponent
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import okhttp3.OkHttpClient
import okhttp3.logging.HttpLoggingInterceptor
import retrofit2.Response
import retrofit2.Retrofit
import retrofit2.converter.gson.GsonConverterFactory
import retrofit2.http.GET
import javax.inject.Inject
import javax.inject.Singleton
import kotlin.system.exitProcess


val backColorPrimary = Color(0xff\(uiSettings.backColorPrimary ?? "FFFFFF"))
val buttonColorPrimary = Color(0xff\(uiSettings.buttonColorPrimary ?? "FFFFFF"))
val buttonTextColorPrimary = Color(0xff\(uiSettings.buttonTextColorPrimary ?? "FFFFFF"))

val textColorPrimary = Color(0xff\(uiSettings.textColorPrimary ?? "FFFFFF"))
val surfaceColor = Color(0xff\(uiSettings.surfaceColor ?? "FFFFFF"))

private val LightColorScheme = lightColorScheme(
    primary = buttonColorPrimary,
    onPrimary = buttonTextColorPrimary,
    background = backColorPrimary,
)

@Composable
fun HeroQuestTheme(
    content: @Composable () -> Unit
) {

    MaterialTheme(
        colorScheme = LightColorScheme,
        content = content
    )
}


@Composable
fun ScoreDialog(
    showDialog: Boolean,
    onReturn: () -> Unit,
    onDismis: () -> Unit,
    score: String,
) {
    if (showDialog) {
        AlertDialog(
            containerColor = surfaceColor,
            titleContentColor = textColorPrimary,
            onDismissRequest = { onDismis() },
            title = { Text(text = stringResource(id = R.string.score, score)) },
            confirmButton = {
                TextButton(onClick = {
                    onReturn()
                }) {
                    Text(text = stringResource(id = R.string.retry), color = MaterialTheme.colorScheme.primary)
                }
            },
            dismissButton = {
                TextButton(onClick = {
                    onDismis()
                }) {
                    Text(text = stringResource(id = R.string.back), color = MaterialTheme.colorScheme.primary)
                }
            }
        )
    }
}

@Composable
fun OptionGroup(options: List<String>, selectedItem: String, setSelected: (String) -> Unit) {

    Column(modifier = Modifier.selectableGroup()) {
       CompositionLocalProvider(LocalRippleTheme provides NoRippleTheme) {
            options.forEach { option ->
                Row(
                    modifier = Modifier
                        .fillMaxWidth()
                        .selectable(
                            selected = (selectedItem == option),
                            onClick = { setSelected(option) },
                            role = Role.RadioButton
                        )
                        .padding(vertical = 8.dp)
                ) {
                    OptionButton(selectedItem = selectedItem, option)
                }
            }
        }
    }
}

@Composable
fun OptionButton(selectedItem: String, option: String) {
    Box(
        modifier = Modifier
            .fillMaxWidth()
            .border(
                width = 1.dp,
                color =
                if (selectedItem == option)
                    MaterialTheme.colorScheme.primary
                else
                    textColorPrimary,
                shape = RoundedCornerShape(percent = 20)
            )
            .padding(horizontal = 10.dp, vertical = 10.dp)
    ) {
        Row(
            modifier = Modifier
                .fillMaxWidth()
                .padding(start = 6.dp, top = 6.dp, bottom = 6.dp),
            horizontalArrangement = Arrangement.SpaceBetween
        ) {
            Text(text = option, fontSize = MaterialTheme.typography.bodyLarge.fontSize, color = textColorPrimary)
            Icon(
                imageVector =
                if (selectedItem == option)
                    Icons.Outlined.CheckCircle
                else
                    Icons.Outlined.RadioButtonUnchecked,
                contentDescription = null,
                tint =
                if (selectedItem == option)
                    MaterialTheme.colorScheme.primary
                else
                    textColorPrimary
            )
        }
    }
}

object NoRippleTheme : RippleTheme {
    @Composable
    override fun defaultColor() = Color.Unspecified

    @Composable
    override fun rippleAlpha(): RippleAlpha = RippleAlpha(0.0f, 0.0f, 0.0f, 0.0f)
}

@Composable
fun StartScreen(onStartQuizClick: () -> Unit) {
    Box(
        modifier = Modifier
            .fillMaxSize()
            .background(MaterialTheme.colorScheme.background)
    ) {
        Column(
            modifier = Modifier
                .fillMaxSize()
                .background(MaterialTheme.colorScheme.background)
                .padding(30.dp),
            verticalArrangement = Arrangement.Center,
            horizontalAlignment = Alignment.CenterHorizontally
        ) {
            Text(
                text = stringResource(id = R.string.title),
                fontSize = MaterialTheme.typography.headlineMedium.fontSize,
                textAlign = TextAlign.Center,
                lineHeight = 35.sp,
                color = textColorPrimary
            )
            Spacer(modifier = Modifier.height(10.dp))
            Button(
                onClick = {
                    onStartQuizClick()
                },
                Modifier
                    .fillMaxWidth()
                    .padding(horizontal = 30.dp),
                colors = ButtonDefaults.buttonColors(
                    containerColor = MaterialTheme.colorScheme.primary,
                    contentColor = MaterialTheme.colorScheme.onPrimary
                )
            ) {
                Text(stringResource(id = R.string.start))
            }
            Spacer(modifier = Modifier.height(10.dp))
            Button(
                onClick = {
                    exitProcess(0)
                },
                Modifier
                    .fillMaxWidth()
                    .padding(horizontal = 30.dp),
                colors = ButtonDefaults.buttonColors(
                    containerColor = MaterialTheme.colorScheme.primary,
                    contentColor = MaterialTheme.colorScheme.onPrimary
                )
            ) {
                Text(stringResource(id = R.string.exit))
            }
        }
    }
}

@Composable
fun QuizScreen(
    viewModel: QuizScreenViewModel = hiltViewModel(),
    onFinish: () -> Unit,
    onRetry: () -> Unit,
) {

    when (val state = viewModel.state.value) {
        is QuizState.Loading -> {
            LoadingScreen()
        }

        is QuizState.Success -> {
            Quiz(
                state = state,
                score = viewModel.score,
                onNext = { viewModel.nextQuestion() },
                onScoreAdd = { viewModel.score++ },
                onDialogDismiss = {
                    viewModel.onDialogDismiss()
                    onFinish()
                },
                onDialogConfirm = {
                    onRetry()
                },
            )
        }

        is QuizState.Error -> {
            ErrorScreen(state.message)
        }
    }
}

@Composable
fun Quiz(
    state: QuizState.Success,
    score: Int,
    onNext: () -> Unit,
    onScoreAdd: () -> Unit,
    onDialogDismiss: () -> Unit,
    onDialogConfirm: () -> Unit,
) {
    Box(
        modifier = Modifier
            .fillMaxSize()
            .background(MaterialTheme.colorScheme.background)
    ) {
        Column(
            modifier = Modifier
                .fillMaxSize()
                .background(MaterialTheme.colorScheme.background)
                .padding(30.dp),
            verticalArrangement = Arrangement.Center,
            horizontalAlignment = Alignment.CenterHorizontally
        ) {
            OutlinedCard(
                elevation = CardDefaults.cardElevation(4.dp),
                modifier = Modifier.fillMaxWidth(),
                colors = CardDefaults.cardColors(containerColor = surfaceColor, contentColor = textColorPrimary)
            ) {
                state.currentQuestion?.let {
                    Text(
                        text = it.question,
                        Modifier
                            .fillMaxWidth()
                            .padding(20.dp),
                        textAlign = TextAlign.Center,
                        fontStyle = MaterialTheme.typography.headlineMedium.fontStyle,
                        fontSize = MaterialTheme.typography.headlineMedium.fontSize,
                        lineHeight = 35.sp
                    )
                }
            }
            Spacer(modifier = Modifier.height(10.dp))

            val (selected, setSelected) = remember { mutableStateOf("") }
            state.currentQuestion?.let {
                OptionGroup(
                    it.options,
                    selected,
                    setSelected
                )
            }

            Spacer(modifier = Modifier.height(10.dp))
            Button(
                onClick = {
                    if (selected == state.currentQuestion?.answer)
                        onScoreAdd()
                    onNext()
                },
                Modifier
                    .fillMaxWidth()
                    .padding(10.dp),
                colors = ButtonDefaults.buttonColors(
                    containerColor = MaterialTheme.colorScheme.primary,
                    contentColor = MaterialTheme.colorScheme.onPrimary
                )
            ) {
                Text(text = stringResource(id = R.string.next))
            }
            ScoreDialog(
                showDialog = state.isDialogShown,
                onReturn = {
                    onDialogConfirm()
                },
                score = score.toString(),
                onDismis = {
                    onDialogDismiss()
                }
            )
        }
    }
}

@Composable
fun LoadingScreen() {
    Box(
        modifier = Modifier
            .fillMaxSize()
            .background(MaterialTheme.colorScheme.background)
    ) {
        CircularProgressIndicator(modifier = Modifier.align(Alignment.Center))
    }
}

@Composable
fun ErrorScreen(error: String) {
    Box(
        modifier = Modifier
            .fillMaxSize()
            .background(MaterialTheme.colorScheme.background)
    ) {
        Text(
            text = error,
            color = MaterialTheme.colorScheme.error,
            textAlign = TextAlign.Center,
            modifier = Modifier
                .fillMaxWidth()
                .padding(horizontal = 20.dp)
                .align(Alignment.Center)
        )
    }
}

sealed class QuizState {
    object Loading : QuizState()
    class Success(val currentQuestion: Question? = null, val isDialogShown: Boolean = false) :
        QuizState()

    class Error(val message: String) : QuizState()
}

@HiltViewModel
class QuizScreenViewModel @Inject constructor(val repository: QuizRepository) : ViewModel() {

    private var questionList: List<Question> = emptyList()
    private var index = 0
    var score: Int = 0

    private val _state = mutableStateOf<QuizState>(QuizState.Loading)
    val state: State<QuizState> = _state

    init {
        getListQuestions()
    }

    private fun getListQuestions() {

        viewModelScope.launch(Dispatchers.IO) {
            when (val result = repository.getQuestions()) {
                is Resource.Success -> {
                    questionList = result.data ?: emptyList()
                    _state.value = QuizState.Success(currentQuestion = questionList[index], false)
                }

                is Resource.Error -> _state.value =
                    QuizState.Error(message = result.message.toString())
            }
        }
    }

    fun nextQuestion() {
        if (index < questionList.size - 1) {
            index++
            _state.value = QuizState.Success(currentQuestion = questionList[index])
        } else {
            _state.value =
                QuizState.Success(currentQuestion = questionList[index], isDialogShown = true)
        }
    }

    fun onDialogDismiss() {
        _state.value = QuizState.Success(isDialogShown = false)
    }
}

@Composable
fun NavGraph() {
    val navController = rememberNavController()
    NavHost(navController = navController, startDestination = Screen.StartScreen.route) {
        navigateStart(navController)
        navigateQuiz(navController)
    }
}

fun NavGraphBuilder.navigateStart(navController: NavController) {
    composable(route = Screen.StartScreen.route) {
        StartScreen(onStartQuizClick = {
            navController.navigate(Screen.QuizScreen.route)
        })
    }
}

fun NavGraphBuilder.navigateQuiz(navController: NavController) {
    composable(route = Screen.QuizScreen.route) {
        QuizScreen(onFinish = {
            navController.navigate(Screen.StartScreen.route)
        },
            onRetry = {
                navController.navigate(Screen.QuizScreen.route) {
                    popUpTo(0) {
                        inclusive = true
                    }
                }
            })
    }
}

sealed class Screen(val route: String) {
    object StartScreen : Screen("start_screen")
    object QuizScreen : Screen("quiz_screen")
}

data class Question(
    val question: String,
    val answer: String,
    val options: List<String>,
)

class QuizRepository @Inject constructor(private val quizApi: QuizApiService) {

    suspend fun getQuestions(): Resource<List<Question>> {
        val response = try {
            quizApi.getListQuestions()
        } catch (e: Exception) {
            return Resource.Error(message = e.toString())
        }
        return if (response.body()?.result == 1 || response.body()?.questions.isNullOrEmpty()) {
            Resource.Error(message = "Empty list")
        } else {
            Resource.Success(
                response.body()?.questions?.map { question ->
                    question.toQuestionView()
                })
        }
    }
}

@Keep
data class QuestionList(
    @SerializedName("response_code")
    val result: Int,
    @SerializedName("results")
    val questions: List<QuestionDto>,
)

@Keep
data class QuestionDto(
    @SerializedName("correct_answer")
    val answer: String,
    @SerializedName("incorrect_answers")
    val options: List<String>,
    val question: String,
)

interface QuizApiService {

    @GET("api.php?amount=10&category=29")
    suspend fun getListQuestions(): Response<QuestionList>
}

fun QuestionDto.toQuestionView() = Question(
    question = question
        .replace("&quot;", "\\" ")
        .replace("&eacute;", "e")
        .replace("&amp;", "&")
        .replace("&#039;", "' "),
    answer = answer,
    options = options.toMutableList().also {
        it.add(answer)
        it.map { item ->
            item.replace("&amp;", "&")
                .replace("&quot;", "\\" ")
                .replace("&#039;", "' ")
                .replace("&eacute;", "e")
        }
        it.shuffle()
    }
)

sealed class Resource<T>(val data: T? = null, val message: String? = null) {
    class Success<T>(data: T?) : Resource<T>(data)
    class Error<T>(data: T? = null, message: String) : Resource<T>(data, message)
}

@Module
@InstallIn(SingletonComponent::class)
object ApiModule {

    private const val BASE_URL = "https://opentdb.com/"

    @Singleton
    @Provides
    fun providesHttpLoginInterceptor() =
        HttpLoggingInterceptor().apply {
            level = HttpLoggingInterceptor.Level.BODY
        }

    @Singleton
    @Provides
    fun providesOkHttpClient(httpLoggingInterceptor: HttpLoggingInterceptor) =
        OkHttpClient.Builder()
            .addInterceptor(httpLoggingInterceptor)
            .build()

    @Singleton
    @Provides
    fun providesRetrofit(okHttpClient: OkHttpClient) = Retrofit.Builder()
        .baseUrl(BASE_URL)
        .client(okHttpClient)
        .addConverterFactory(GsonConverterFactory.create())
        .build()

    @Singleton
    @Provides
    fun providesQuizApiService(retrofit: Retrofit) = retrofit.create(QuizApiService::class.java)

    @Provides
    @Singleton
    fun providesQiuzRepository(quizApiService: QuizApiService) = QuizRepository(quizApiService)
}
"""
    }
    
    static func dependencies(_ mainData: MainData) -> ANDData {
        return ANDData(
            mainFragmentData: ANDMainFragment(imports: """
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Surface
import androidx.compose.ui.Modifier
""", content: """
    HeroQuestTheme {
        Surface(
            modifier = Modifier
                .fillMaxSize(),
            color = MaterialTheme.colorScheme.background
        ) {
            NavGraph()
        }
    }
"""),
            mainActivityData: ANDMainActivity(imports: "", extraFunc: "", content: ""),
            themesData: ANDThemesData(isDefault: true, content: ""),
            stringsData: ANDStringsData(additional: """
    <string name="start">Start</string>
    <string name="exit">Exit</string>
    <string name="next">Next</string>
    <string name="score">Your score: %1$s</string>
    <string name="back">Return to menu</string>
    <string name="retry">Test again</string>
    <string name="title">How well do you know comics?</string>
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
    import dependencies.Application
    import dependencies.Dependencies
    import dependencies.Versions

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
        implementation Dependencies.compose_splash
        implementation Dependencies.retrofit
        implementation Dependencies.converter_gson
        implementation Dependencies.okhttp
        implementation Dependencies.okhttp_login_interceptor
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
        const val gradle = "8.0.2"
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
        const val compose_navigation = "2.5.3"
        const val activity_compose = "1.7.1"
        const val compose_hilt_nav = "1.0.0"

        const val oneSignal = "4.6.7"
        const val glide = "4.12.0"
        const val swipe = "0.19.0"
        const val glide_skydoves = "1.3.9"
        const val retrofit = "2.9.0"
        const val okhttp = "4.10.0"
        const val room = "2.5.0"
        const val coil = "2.3.0"
        const val exp = "0.4.8"
        const val calend = "0.5.1"
        const val paging_version = "3.1.1"
        const val splash = "1.0.1"
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
        const val compose_splash = "androidx.core:core-splashscreen:${Versions.splash}"

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
    
    
}
