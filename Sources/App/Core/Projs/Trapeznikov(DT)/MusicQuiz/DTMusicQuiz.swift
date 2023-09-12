//
//  File.swift
//  
//
//  Created by admin on 9/12/23.
//
import SwiftUI

struct DTMusicQuiz: SFFileProviderProtocol {
    static func mainFragmentCMF(_ mainData: MainData) -> ANDMainFragmentCMF {
        ANDMainFragmentCMF(content: """
package \(mainData.packageName).presentation.fragments.main_fragment

import android.os.Bundle
import android.text.Html
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.Button
import android.widget.Toast
import androidx.core.os.bundleOf
import androidx.fragment.app.Fragment
import androidx.fragment.app.viewModels
import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import androidx.navigation.fragment.findNavController
import \(mainData.packageName).R
import \(mainData.packageName).databinding.FragmentMainBinding
import \(mainData.packageName).databinding.FragmentQuizBinding
import \(mainData.packageName).databinding.FragmentResultBinding
import com.google.gson.annotations.SerializedName
import dagger.Module
import dagger.Provides
import dagger.hilt.InstallIn
import dagger.hilt.android.AndroidEntryPoint
import dagger.hilt.android.lifecycle.HiltViewModel
import dagger.hilt.components.SingletonComponent
import kotlinx.coroutines.launch
import retrofit2.HttpException
import retrofit2.Response
import retrofit2.Retrofit
import retrofit2.converter.gson.GsonConverterFactory
import retrofit2.http.GET
import retrofit2.http.Query
import java.io.IOException
import javax.inject.Inject
import javax.inject.Singleton

@AndroidEntryPoint
class MainFragment : Fragment() {

    private var _binding: FragmentMainBinding? = null
    private val binding get() = _binding!!

    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View {
        _binding = FragmentMainBinding.inflate(inflater, container, false)
        return binding.root
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        binding.startButton.setOnClickListener {
            findNavController().navigate(R.id.action_mainFragment_to_quizFragment)
        }
    }

    override fun onDestroyView() {
        super.onDestroyView()
        _binding = null
    }
}

sealed class Resource<T>(val data: T? = null, val message: String? = null) {
    class Success<T>(data: T) : Resource<T>(data)
    class Error<T>(message: String?, data: T? = null) : Resource<T>(data, message)
    class Loading<T> : Resource<T>()
}

data class QuizDto(
    @SerializedName("category")
    val category: String,
    @SerializedName("correct_answer")
    val correctAnswer: String,
    @SerializedName("difficulty")
    val difficulty: String,
    @SerializedName("incorrect_answers")
    val incorrectAnswers: List<String>,
    @SerializedName("question")
    val question: String,
    @SerializedName("type")
    val type: String
)

data class ResponseDto(
    @SerializedName("response_code")
    val responseCode: Int,
    @SerializedName("results")
    val quizList: List<QuizDto>
)

interface QuizService {
    @GET("api.php")
    suspend fun getTrivia(
        @Query("amount") amount: Int = 10,
        @Query("category") category: Int = 12,
        @Query("type") type: String = "multiple"
    ): Response<ResponseDto>

    companion object {
        const val BASE_URL = "https://opentdb.com/"
    }
}

@Module
@InstallIn(SingletonComponent::class)
class DataModule {

    @Provides
    @Singleton
    fun provideQuizRepository(quizService: QuizService): QuizRepository {
        return QuizRepositoryImpl(quizService)
    }

    @Provides
    @Singleton
    fun provideQuizService(): QuizService {
        val retrofit = Retrofit.Builder()
            .baseUrl(QuizService.BASE_URL)
            .addConverterFactory(GsonConverterFactory.create())
            .build()
        return retrofit.create(QuizService::class.java)
    }
}

data class Quiz(
    val question: String,
    val answers: List<String>,
    val correctAnswer: String
)

interface QuizRepository {
    suspend fun getQuiz(): Resource<List<Quiz>>
}

class QuizRepositoryImpl(private val quizService: QuizService) : QuizRepository {

    override suspend fun getQuiz(): Resource<List<Quiz>> = try {
        val response = quizService.getTrivia()
        val body = response.body()
        if (response.isSuccessful && body != null && body.responseCode == 0) {
            Resource.Success(body.quizList.map { it.toDomain() })
        } else {
            Resource.Error(response.message())
        }
    } catch (e: IOException) {
        Resource.Error(e.message)
    } catch (e: HttpException) {
        Resource.Error(e.message)
    }

    private fun QuizDto.toDomain(): Quiz {
        return Quiz(
            question = Html.fromHtml(this.question, Html.FROM_HTML_MODE_LEGACY).toString(),
            answers = this.incorrectAnswers.plus(this.correctAnswer).shuffled().map {
                Html.fromHtml(
                    it,
                    Html.FROM_HTML_MODE_LEGACY
                ).toString()
            },
            correctAnswer = Html.fromHtml(this.correctAnswer, Html.FROM_HTML_MODE_LEGACY)
                .toString(),
        )
    }
}

@AndroidEntryPoint
class QuizFragment : Fragment() {

    private var _binding: FragmentQuizBinding? = null
    private val binding get() = _binding!!
    private val quizViewModel: QuizFragmentViewModel by viewModels()

    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View {
        _binding = FragmentQuizBinding.inflate(inflater, container, false)
        return binding.root
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)

        val listener = View.OnClickListener {
            val button = it as Button
            checkAnswer(button.text.toString())
            quizViewModel.nextQuiz()
        }

        with(binding) {
            optionOneButton.setOnClickListener(listener)
            optionTwoButton.setOnClickListener(listener)
            optionThreeButton.setOnClickListener(listener)
            optionFourButton.setOnClickListener(listener)
        }

        quizViewModel.quiz.observe(viewLifecycleOwner) {
            when (it) {
                is Resource.Loading -> {
                    binding.loadLayout.visibility = View.VISIBLE
                }

                is Resource.Success -> {
                    binding.connectionLostText.visibility = View.GONE
                    it.data?.let { quiz ->
                        initUi(quiz)
                    }
                    binding.loadLayout.visibility = View.GONE
                }

                is Resource.Error -> {
                    binding.connectionLostText.visibility = View.VISIBLE
                }
            }
        }

        quizViewModel.isLastQuiz.observe(viewLifecycleOwner) {
            findNavController().navigate(
                R.id.action_quizFragment_to_resultFragment,
                bundleOf(SCORE_KEY to quizViewModel.correctAnswers())
            )
        }
    }

    private fun initUi(quiz: Quiz) {
        with(binding) {
            questionText.text = quiz.question
            progressIndicator.incrementProgressBy(1)
            progressText.text = String.format(
                getString(R.string.progress),
                quizViewModel.currentIndex() + 1
            )
            optionOneButton.text = quiz.answers.getOrElse(0) { getString(R.string.not_available) }
            optionTwoButton.text = quiz.answers.getOrElse(1) { getString(R.string.not_available) }
            optionThreeButton.text = quiz.answers.getOrElse(2) { getString(R.string.not_available) }
            optionFourButton.text = quiz.answers.getOrElse(3) { getString(R.string.not_available) }
        }
    }

    override fun onDestroyView() {
        super.onDestroyView()
        _binding = null
    }

    private fun checkAnswer(option: String) {
        if (quizViewModel.checkAnswer(option)) {
            correctAnswer()
        } else {
            incorrectAnswer()
        }
    }

    private fun correctAnswer() {
        quizViewModel.incCorrectAnswers()
        Toast.makeText(context, getString(R.string.you_are_right), Toast.LENGTH_SHORT).show()
    }

    private fun incorrectAnswer() {
        Toast.makeText(context, getString(R.string.you_made_a_mistake), Toast.LENGTH_SHORT).show()
    }

    companion object {
        const val SCORE_KEY = "score"
    }
}

@HiltViewModel
class QuizFragmentViewModel @Inject constructor(
    private val quizRepository: QuizRepository
) : ViewModel() {

    private var quizzes = listOf<Quiz>()
    private var curIndex = 0
    private var correctAnswers = 0

    private val _quiz = MutableLiveData<Resource<Quiz>>()
    val quiz: LiveData<Resource<Quiz>> = _quiz

    private val _isLastQuiz = MutableLiveData<Boolean>()
    val isLastQuiz: LiveData<Boolean> = _isLastQuiz

    init {
        viewModelScope.launch {
            _quiz.value = Resource.Loading()
            when (val response = quizRepository.getQuiz()) {
                is Resource.Success -> {
                    response.data?.let { quizList ->
                        quizzes = quizList
                    }
                    _quiz.value = Resource.Success(quizzes[curIndex])
                }

                is Resource.Error -> {
                    _quiz.value = Resource.Error(response.message)
                }

                is Resource.Loading -> {
                    _quiz.value = Resource.Loading()
                }
            }
        }
    }

    fun nextQuiz() {
        if (curIndex < quizzes.lastIndex) {
            curIndex++
            _quiz.value = Resource.Success(quizzes[curIndex])
        } else {
            _isLastQuiz.value = true
        }
    }

    fun checkAnswer(option: String): Boolean {
        val correctAnswer = quizzes[curIndex].correctAnswer
        return option == correctAnswer
    }

    fun incCorrectAnswers() {
        correctAnswers++
    }

    fun currentIndex() = curIndex

    fun correctAnswers() = correctAnswers
}

class ResultFragment : Fragment() {

    private var _binding: FragmentResultBinding? = null
    private val binding get() = _binding!!

    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View {
        _binding = FragmentResultBinding.inflate(inflater, container, false)
        return binding.root
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)

        binding.scoreText.text =
            String.format(getString(R.string.progress), arguments?.getInt(QuizFragment.SCORE_KEY))

        binding.noButton.setOnClickListener {
            requireActivity().finish()
        }

        binding.yesButton.setOnClickListener {
            findNavController().navigate(R.id.action_resultFragment_to_quizFragment)
        }
    }

    override fun onDestroyView() {
        super.onDestroyView()
        _binding = null
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
    <string name="welcome">Welcome</string>
    <string name="start_when_you_are_ready">Start when you are ready</string>
    <string name="start">Start</string>
    <string name="submit">Submit</string>
    <string name="you_are_right">You are right!</string>
    <string name="you_made_a_mistake">You made a mistake!</string>
    <string name="progress">%1$d // 10</string>
    <string name="connection_is_lost">Connection is lost</string>
    <string name="your_score_is">Your score is</string>
    <string name="one_more_quiz">One more quiz?</string>
    <string name="no">No</string>
    <string name="yes">Yes</string>
    <string name="not_available">N/A</string>
"""),
            colorsData: ANDColorsData(additional: """
    <color name="backColorPrimary">#FF\(mainData.uiSettings.backColorPrimary ?? "FFFFFF")</color>
    <color name="textColorPrimary">#FF\(mainData.uiSettings.textColorPrimary ?? "FFFFFF")</color>
    <color name="textColorSecondary">#FF\(mainData.uiSettings.textColorSecondary ?? "FFFFFF")</color>
    <color name="buttonColorPrimary">#FF\(mainData.uiSettings.buttonColorPrimary ?? "FFFFFF")</color>
    <color name="buttonTextColorPrimary">#FF\(mainData.uiSettings.buttonTextColorPrimary ?? "FFFFFF")</color>
    <color name="surfaceColor">#FF\(mainData.uiSettings.surfaceColor ?? "FFFFFF")</color>
"""))
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
    implementation Dependencies.retrofit
    implementation Dependencies.converter_gson
    implementation Dependencies.jetpack_navigation_fragment
    implementation Dependencies.jetpack_navigation_ui
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
    const val jetpack_navigation = "2.6.0"
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

    const val jetpack_navigation_fragment = "androidx.navigation:navigation-fragment-ktx:${Versions.jetpack_navigation}"
    const val jetpack_navigation_ui = "androidx.navigation:navigation-ui-ktx:${Versions.jetpack_navigation}"
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
