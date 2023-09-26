//
//  File.swift
//  
//
//  Created by admin on 19.09.2023.
//

import Foundation

struct AKQuiz: FileProviderProtocol {
    static var fileName: String = "\(NamesManager.shared.fileName).kt"
    
    static func fileContent(packageName: String, uiSettings: UISettings) -> String {
        return """
package \(packageName).presentation.fragments.main_fragment

import androidx.annotation.Keep
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.wrapContentHeight
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.material.CircularProgressIndicator
import androidx.compose.material.RadioButton
import androidx.compose.material.RadioButtonDefaults
import androidx.compose.material3.Button
import androidx.compose.material3.ButtonDefaults
import androidx.compose.material3.Card
import androidx.compose.material3.CardDefaults
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.saveable.rememberSaveable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.hilt.navigation.compose.hiltViewModel
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import androidx.navigation.NamedNavArgument
import androidx.navigation.NavController
import androidx.navigation.NavHostController
import androidx.navigation.NavType
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import androidx.navigation.compose.rememberNavController
import androidx.navigation.navArgument
import \(packageName).R
import com.google.gson.annotations.SerializedName
import dagger.Module
import dagger.Provides
import dagger.hilt.InstallIn
import dagger.hilt.android.lifecycle.HiltViewModel
import dagger.hilt.components.SingletonComponent
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.flow
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import retrofit2.HttpException
import retrofit2.Retrofit
import retrofit2.converter.gson.GsonConverterFactory
import retrofit2.http.GET
import retrofit2.http.Query
import java.io.EOFException
import java.io.IOException
import java.net.SocketException
import java.net.UnknownHostException
import javax.inject.Inject
import javax.inject.Qualifier
import javax.inject.Singleton

val backColorPrimary = Color(0xFF\(uiSettings.backColorPrimary ?? "FFFFFF"))
val buttonColorSecondary = Color(0xFF\(uiSettings.buttonColorSecondary ?? "FFFFFF"))
val buttonColorPrimary = Color(0xFF\(uiSettings.buttonColorPrimary ?? "FFFFFF"))
val textColorPrimary = Color(0xFF\(uiSettings.textColorPrimary ?? "FFFFFF"))
val textColorSecondary = Color(0xFF\(uiSettings.textColorSecondary ?? "FFFFFF"))

sealed class NetworkResult<T> {
    data class IOException<T>(val errorMessage: Int): NetworkResult<T>()
    data class HttpException<T>(val errorMessage: Int): NetworkResult<T>()
    data class Success<T>(val data: T): NetworkResult<T>()
}

fun Int.httpCodeToErrorMessage() = when(this) {
    400 -> R.string.http_400
    403 -> R.string.http_403
    404 -> R.string.http_404
    500 -> R.string.http_500
    502 -> R.string.http_502
    504 -> R.string.http_504
    else ->  R.string.error
}

fun IOException.ioExceptionToNetworkResult() = when(this) {
    is EOFException -> R.string.io_eof
    is SocketException -> R.string.io_socket
    is UnknownHostException -> R.string.io_unknown
    else ->  R.string.bad_connection
}


fun String.cleanText(): String {
    return this
        .replace("&#039;", "`")
        .replace("&quot;", "'")
        .replace("&rsquo;", "'")
        .replace("&eacute;", "e")
        .replace("&uuml;", "u")
        .replace("&ldquo;", "'")
        .replace("&rdquo;", "'")
        .replace("&amp;", "&")
}

@Composable
fun StartScreen(navController: NavController) {

    Column(
        modifier = Modifier
            .fillMaxSize()
            .background(backColorPrimary),
        verticalArrangement = Arrangement.Center,
        horizontalAlignment = Alignment.CenterHorizontally
    ) {
        Button(
            onClick = {
                navController.navigate(Screen.QuizScreen.route)
            },
            colors = ButtonDefaults.buttonColors(containerColor = buttonColorPrimary),
            elevation = ButtonDefaults.buttonElevation(defaultElevation = 10.dp, pressedElevation = 20.dp)
        ) {
            Text(
                text = stringResource(id = R.string.start_button_text),
                fontSize = 24.sp,
                color = backColorPrimary
            )
        }
    }
}

@Composable
fun ResultScreen(navController: NavHostController, result: String?) {
    Column(
        modifier = Modifier
            .fillMaxSize()
            .background(backColorPrimary),
        verticalArrangement = Arrangement.spacedBy(16.dp, Alignment.CenterVertically),
        horizontalAlignment = Alignment.CenterHorizontally
    ) {
        Text(
            text = stringResource(id = R.string.result_text, result ?: R.string.error),
            fontSize = 18.sp,
            color = textColorPrimary
        )

        Button(
            onClick = {
                navController.navigate(Screen.QuizScreen.route) {
                    popUpTo(0)
                }
            },
            colors = ButtonDefaults.buttonColors(containerColor = buttonColorPrimary),
            elevation = ButtonDefaults.buttonElevation(defaultElevation = 10.dp)
        ) {
            Text(
                text = stringResource(id = R.string.restart_button_text),
                fontSize = 18.sp,
                color = backColorPrimary
            )
        }
    }
}

@Composable
fun QuizScreen(navController: NavController, viewModel: QuizViewModel = hiltViewModel()) {
    val quizData = viewModel.data.collectAsState().value
    val errorTextId = viewModel.errorForDisplay.collectAsState().value

    val listOfAnswers = remember {
        MutableList(10){false}
    }

    LazyColumn(
        modifier = Modifier
            .fillMaxSize()
            .background(buttonColorPrimary)
            .padding(16.dp),
        verticalArrangement = Arrangement.spacedBy(8.dp),
        horizontalAlignment = Alignment.CenterHorizontally
    ) {
        when {
            errorTextId != R.string.empty -> {
                item {
                    ErrorText()
                }
            }

            quizData.quizQuestions.isEmpty() -> {
                item {
                    CircularProgressIndicator(color = backColorPrimary)
                }
            }

            else -> {
                for (i in 0 until quizData.quizQuestions.size) {
                    item {
                        QuestionCard(questionPosition = i, question = quizData.quizQuestions[i], listOfAnswers)
                    }
                }
                item {
                    DoneButton(listOfAnswers, navController)
                }
            }
        }
    }
}

@Composable
fun AnswerText(answer: String?, selectedOption: String?, onOptionSelected: (String?) -> Unit) {

    Row(
        verticalAlignment = Alignment.CenterVertically,
    ) {
        RadioButton(
            modifier = Modifier.size(40.dp),
            selected = (answer == selectedOption),
            onClick = {
                onOptionSelected(answer)
            },
            colors = RadioButtonDefaults.colors(selectedColor = buttonColorPrimary, unselectedColor = buttonColorSecondary)
        )

        androidx.compose.material.Text(
            modifier = Modifier.wrapContentHeight(),
            text = answer?.cleanText() ?: stringResource(id = R.string.error),
            fontSize = 16.sp,
            color = buttonColorPrimary
        )
    }

}

@Composable
fun DoneButton(
    listOfAnswers: MutableList<Boolean>,
    navController: NavController,
    viewModel: QuizViewModel = hiltViewModel()
) {

    val context = LocalContext.current
    val amountOfQuestions = viewModel.data.collectAsState().value.quizQuestions.size

    Button(
        modifier = Modifier.fillMaxWidth(),
        onClick = {
            val rightAnswers = listOfAnswers.count { it }
            navController.navigate(
                Screen.ResultScreen.createRoute(
                    context.getString(
                        R.string.result_text_number,
                        rightAnswers.toString(),
                        amountOfQuestions.toString()
                    )
                )
            ) {
                popUpTo(0)
            }
        },
        colors = ButtonDefaults.buttonColors(containerColor = backColorPrimary),
        elevation = ButtonDefaults.buttonElevation(
            defaultElevation = 10.dp,
            pressedElevation = 20.dp
        )
    ) {
        androidx.compose.material.Text(
            text = stringResource(id = R.string.done_button_text),
            color = buttonColorPrimary,
            fontSize = 20.sp
        )
    }
}

@Composable
fun ErrorText(viewModel: QuizViewModel = hiltViewModel()) {

    val errorTextID = viewModel.errorForDisplay.collectAsState().value

    androidx.compose.material.Text(
        modifier = Modifier.wrapContentHeight(),
        text = stringResource(id = errorTextID),
        fontSize = 16.sp,
        color = textColorSecondary
    )
}

@Composable
fun QuestionCard(questionPosition: Int, question: QuizQuestion, listOfAnswers: MutableList<Boolean> ) {

    val allAnswers = question.answers
    if (allAnswers.isNotEmpty()) {
        val (selectedOption, onOptionSelected) = rememberSaveable { mutableStateOf(allAnswers[0]) }
        if (questionPosition<listOfAnswers.size) {
            listOfAnswers[questionPosition] = selectedOption==question.correctAnswer
        }


        Card(
            modifier = Modifier
                .fillMaxWidth(),
            elevation = CardDefaults.cardElevation(defaultElevation = 10.dp),
            colors = CardDefaults.cardColors(containerColor = backColorPrimary)
        ) {
            Column(
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(8.dp)
            ) {
                QuestionText(question)

                allAnswers.forEach { answer ->
                    AnswerText(answer, selectedOption, onOptionSelected)
                }
            }
        }
    }
}

@Composable
fun QuestionText(question: QuizQuestion) {
    androidx.compose.material.Text(
        text = question.question?.cleanText() ?: stringResource(id = R.string.error),
        fontSize = 18.sp,
        color = textColorPrimary
    )
}

@HiltViewModel
class QuizViewModel @Inject constructor(private val quizUseCase: GetQuizUseCase) : ViewModel() {

    private val _data = MutableStateFlow<QuizQuestionList>(QuizQuestionList())
    val data: StateFlow<QuizQuestionList> = _data
    fun changeData(newData: QuizQuestionList) {
        _data.value = newData
    }

    private val _errorForDisplay = MutableStateFlow<Int>(R.string.empty)
    val errorForDisplay: StateFlow<Int> = _errorForDisplay
    fun changeErrorForDisplay(newErrorForDisplay: Int) {
        _errorForDisplay.value = newErrorForDisplay
    }


    init {
        viewModelScope.launch {
            quizUseCase().collect { result ->
                when (result) {
                    is NetworkResult.Success -> {
                        changeErrorForDisplay(R.string.empty)
                        changeData(result.data)
                    }

                    is NetworkResult.IOException -> {
                        changeErrorForDisplay(result.errorMessage)
                    }

                    is NetworkResult.HttpException -> {
                        changeErrorForDisplay(result.errorMessage)
                    }
                }
            }
        }
    }
}

@Composable
fun Navigation() {
    val navController = rememberNavController()

    NavHost(navController = navController, startDestination = Screen.StartScreen.route) {


        composable(Screen.StartScreen.route) {
            StartScreen(navController)
        }

        composable(Screen.QuizScreen.route) {
            QuizScreen(navController)
        }

        composable(
            route = Screen.ResultScreen.route,
            arguments = Screen.ResultScreen.arguments
        ) { backStackEntry ->
            ResultScreen(navController, backStackEntry.arguments?.getString("result"))
        }

    }
}


sealed class Screen(val route: String, val arguments: List<NamedNavArgument>) {
    object StartScreen : Screen(route = "start_screen", arguments = listOf())
    object QuizScreen : Screen(route = "quiz_screen", arguments = listOf())
    object ResultScreen : Screen(route = "result_screen/{result}", arguments = listOf(navArgument("result") { type = NavType.StringType })) {
        fun createRoute(result: String) = "result_screen/$result"
    }
}

class GetQuizUseCase @Inject constructor(private val quizRepository: QuizRepository) {
    suspend operator fun invoke() = withContext(Dispatchers.IO) {
        quizRepository.fetchQuizData()
    }
}

interface QuizRemoteRepository {
    fun fetchQuizData(): Flow<NetworkResult<QuizQuestionList>>
}

@Keep
data class QuizQuestionList(
    val quizQuestions: List<QuizQuestion> = listOf()
)

@Keep
data class QuizQuestion(
    val question: String? = null,
    val answers: List<String?> = listOf(),
    val correctAnswer: String? = null
)

fun mapQuiz(input: Results): QuizQuestion {

    val allAnswers = mutableListOf(input.correctAnswer)
    allAnswers.addAll(input.incorrectAnswers)

    return QuizQuestion(
        question = input.question,
        correctAnswer = input.correctAnswer,
        answers = allAnswers.shuffled()
    )
}

fun mapQuizList(input: QuizData): QuizQuestionList {

    val newList = mutableListOf<QuizQuestion>()

    input.results.forEach { inputQuizQuestion ->
        newList.add(
            mapQuiz(inputQuizQuestion)
        )
    }

    return QuizQuestionList(
        quizQuestions = newList
    )
}

@Module
@InstallIn(SingletonComponent::class)
object AppModule {


    @Provides
    @BaseUrl
    fun providesBaseUrl() : String =  "https://opentdb.com/"


    @Provides
    @Singleton
    fun provideRetrofit(@BaseUrl BASE_URL : String) : Retrofit = Retrofit.Builder()
        .addConverterFactory(GsonConverterFactory.create())
        .baseUrl(BASE_URL)
        .build()

    @Provides
    @Singleton
    fun provideMainService(retrofit : Retrofit) : QuizService = retrofit.create(QuizService::class.java)

}

@Singleton
class QuizRepository @Inject constructor(private val quizService: QuizService):
    QuizRemoteRepository {

    override fun fetchQuizData(): Flow<NetworkResult<QuizQuestionList>> = flow {
        try {
            val response = mapQuizList(quizService.getQuizData())
            emit(NetworkResult.Success(response))
        } catch (e: Throwable) {
            when (e) {
                is HttpException -> {
                    emit(
                        NetworkResult.HttpException(
                            errorMessage = e.code().httpCodeToErrorMessage()
                        )
                    )
                }
                is IOException -> {
                    emit(NetworkResult.IOException(errorMessage = e.ioExceptionToNetworkResult()))
                }
            }
        }
    }
}

@Qualifier
@Retention(AnnotationRetention.RUNTIME)
annotation class BaseUrl

interface QuizService {
    @GET("api.php")
    suspend fun getQuizData(
        @Query("amount") amount: String = "10",
        @Query("category") category: String = "25"
    ): QuizData
}


@Keep
data class QuizData(
    @SerializedName("response_code") val responseCode: Int? = null,
    @SerializedName("results") val results: List<Results> = listOf()
)

@Keep
data class Results(
    @SerializedName("category") val category: String? = null,
    @SerializedName("type") val type: String? = null,
    @SerializedName("difficulty") val difficulty: String? = null,
    @SerializedName("question") val question: String? = null,
    @SerializedName("correct_answer") val correctAnswer: String? = null,
    @SerializedName("incorrect_answers") val incorrectAnswers: List<String> = listOf()
)


"""
    }
    
    static func dependencies(_ mainData: MainData) -> ANDData {
        return ANDData(mainFragmentData: ANDMainFragment(imports: "", content: """
    Navigation()
"""), mainActivityData: ANDMainActivity(imports: "", extraFunc: "", content: ""), themesData: ANDThemesData(isDefault: true, content: ""), stringsData: ANDStringsData(additional: """
    <string name="start_button_text">Start Quiz</string>
    <string name="restart_button_text">Restart Quiz</string>
    <string name="done_button_text">Done</string>
    <string name="result_text">Your result: %1$s </string>
    <string name="result_text_number">%1$s out of %2$s</string>

    <string name="empty"></string>
    <string name="bad_connection">Bad connection</string>
    <string name="error">Error</string>

    <string name="http_400">Incorrect Request</string>
    <string name="http_403">The server can not find the requested resource</string>
    <string name="http_404">You do not have access rights to the content</string>
    <string name="http_500">Internal Server Error</string>
    <string name="http_502">Bad Gateway</string>
    <string name="http_504">The server is acting as a gateway and cannot get a response in time for a request</string>

    <string name="io_eof">End of file or end of stream has been reached unexpectedly during input</string>
    <string name="io_socket">There is an error creating or accessing a Socket</string>
    <string name="io_unknown">IP address of a host could not be determined</string>
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

    implementation Dependencies.retrofit
    implementation Dependencies.converter_gson
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
    
    
}
