//
//  File.swift
//  
//
//  Created by admin on 09.08.2023.
//

import Foundation

struct EGLearnSlang: FileProviderProtocol {
    static var fileName = "\(NamesManager.shared.fileName).kt"
    
    static func fileContent(packageName: String, uiSettings: UISettings) -> String {
        return """
package \(packageName).presentation.fragments.main_fragment

import androidx.annotation.Keep
import androidx.compose.foundation.BorderStroke
import androidx.compose.foundation.border
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.text.KeyboardOptions
import androidx.compose.material.CircularProgressIndicator
import androidx.compose.material.TextField
import androidx.compose.material.TextFieldDefaults
import androidx.compose.material3.CardDefaults
import androidx.compose.material3.Divider
import androidx.compose.material3.ElevatedCard
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.material3.Typography
import androidx.compose.material3.lightColorScheme
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.TextStyle
import androidx.compose.ui.text.font.FontFamily
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.input.KeyboardType
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.hilt.navigation.compose.hiltViewModel
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.google.gson.annotations.SerializedName
import \(packageName).R
import dagger.Module
import dagger.Provides
import dagger.hilt.InstallIn
import dagger.hilt.android.lifecycle.HiltViewModel
import dagger.hilt.components.SingletonComponent
import kotlinx.coroutines.FlowPreview
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.flow.collect
import kotlinx.coroutines.flow.debounce
import kotlinx.coroutines.flow.flow
import kotlinx.coroutines.flow.onEach
import kotlinx.coroutines.launch
import okhttp3.Interceptor
import okhttp3.OkHttpClient
import okhttp3.logging.HttpLoggingInterceptor
import retrofit2.HttpException
import retrofit2.Response
import retrofit2.Retrofit
import retrofit2.converter.gson.GsonConverterFactory
import retrofit2.http.GET
import retrofit2.http.Query
import java.net.ConnectException
import java.net.SocketTimeoutException
import java.net.UnknownHostException
import java.util.concurrent.TimeUnit
import javax.inject.Inject
import javax.inject.Singleton


val primaryColor = Color(0xFF\(uiSettings.primaryColor ?? "FFFFFF"))
val textColorPrimary = Color(0xFF\(uiSettings.textColorPrimary ?? "FFFFFF"))
val backColorPrimary = Color(0xFF\(uiSettings.backColorPrimary ?? "FFFFFF"))
val textColorSecondary = Color(0xFF\(uiSettings.textColorSecondary ?? "FFFFFF"))

private val LightColorPalette = lightColorScheme(
    primary = primaryColor,
    background = backColorPrimary,
    surface = backColorPrimary,
)


@Composable
fun LearnSlangTheme(
    content: @Composable () -> Unit
) {
    MaterialTheme(
        colorScheme = LightColorPalette,
        typography = Typography,
        content = content
    )
}

val Typography = Typography(
    displayLarge = TextStyle(
        fontFamily = FontFamily.SansSerif,
        fontWeight = FontWeight.W800,
        fontSize =28.sp,
        lineHeight = 28.sp,
        letterSpacing = 0.4.sp,
    ),
    displayMedium = TextStyle(
        fontFamily = FontFamily.SansSerif,
        fontWeight = FontWeight.W600,
        fontSize = 20.sp,
        lineHeight = 20.sp,
        letterSpacing = 0.4.sp,
    ),
    displaySmall = TextStyle(
        fontFamily = FontFamily.SansSerif,
        fontWeight = FontWeight.Light,
        fontSize = 20.sp,
        lineHeight = 20.sp,
    )
)

object Constants {
    const val END_POINT_SEARCH = "v0/define"
    const val END_POINT_RANDOM = "v0/words_of_the_day"
    const val BASE_URL = "https://urban-dictionary7.p.rapidapi.com/"
}

fun Int.toHttpErrorType() : ErrorType {
    return when(this) {
        401 -> ErrorType.Unauthorized
        403 -> ErrorType.Forbidden
        404 -> ErrorType.NotFound
        else -> ErrorType.Unknown
    }
}

fun Throwable.toIOErrorType(): ErrorType {
    return when(this) {
        is ConnectException -> ErrorType.NoInternetConnection
        is UnknownHostException -> ErrorType.BadInternetConnection
        is SocketTimeoutException -> ErrorType.SocketTimeOut
        else -> ErrorType.Unknown
    }
}

enum class ErrorType{
    Unauthorized,
    Forbidden,
    NotFound,
    Unknown,
    NoInternetConnection,
    BadInternetConnection,
    SocketTimeOut,
    CustomError,
}

fun ErrorType.toMessage(): Int{
    return when(this){
        ErrorType.Unauthorized -> R.string.error_unauthorizied
        ErrorType.Forbidden ->R.string.error_forbidden
        ErrorType.NotFound -> R.string.error_notfound
        ErrorType.Unknown -> R.string.error_unknown
        ErrorType.NoInternetConnection -> R.string.error_no_internet_connection
        ErrorType.BadInternetConnection -> R.string.error_bad_internet_connection
        ErrorType.SocketTimeOut -> R.string.error_socket_time_out
        ErrorType.CustomError -> R.string.error_custom
    }
}
sealed class ResultState<out R> {
    data class Success<out T>(val data: T) : ResultState<T>()
    data class Error(val error: ErrorType) : ResultState<Nothing>()
    object Loading : ResultState<Nothing>()
    object Empty : ResultState<Nothing>()

}
interface DictionaryApi {
    @GET(Constants.END_POINT_SEARCH)
    suspend fun getSearch(
        @Query("term") term: String,
    ): Response<CommonResponseDto>

    @GET(Constants.END_POINT_RANDOM)
    suspend fun getRandom(): Response<CommonResponseDto>

}

@Module
@InstallIn(SingletonComponent::class)
object NetworkModule {

    @Singleton
    @Provides
    fun provideLoggingInterceptor(): HttpLoggingInterceptor {
        return HttpLoggingInterceptor()
            .setLevel(HttpLoggingInterceptor.Level.BODY)
    }

    @Singleton
    @Provides
    fun provideOkHttpClient(logging: HttpLoggingInterceptor) : OkHttpClient {
        return OkHttpClient.Builder()
            .addInterceptor(Interceptor { chain ->
                val newRequest = chain.request().newBuilder()
                    .addHeader("X-RapidAPI-Key", "1a8e706a00msh6ef324eb00d2a91p1e39abjsn904247a99b34")
                    .addHeader("X-RapidAPI-Host", "urban-dictionary7.p.rapidapi.com")
                    .build()
                chain.proceed(newRequest)
            })
            .addInterceptor(logging)
            .connectTimeout(60, TimeUnit.SECONDS)
            .readTimeout(60, TimeUnit.SECONDS)
            .build()
    }

    @Singleton
    @Provides
    fun provideRetrofit(okHttp: OkHttpClient) : Retrofit {
        return Retrofit.Builder().apply {
            addConverterFactory(GsonConverterFactory.create())
            client(okHttp)
            baseUrl(Constants.BASE_URL)
        }.build()
    }

    @Singleton
    @Provides
    fun provideValidatePhoneApi(retrofit: Retrofit) : DictionaryApi {
        return retrofit.create(DictionaryApi::class.java)
    }

    @Singleton
    @Provides
    fun provideValidatePhoneRepository(dictionaryApi: DictionaryApi) : DictionaryNetworkRepository {
        return DictionaryNetworkRepositoryImpl(dictionaryApi)
    }

}

@Keep
data class CommonResponseDto(
    @SerializedName("list") val words: List<WordsResponseDto>,
)

fun WordsResponseDto.toEntity() = WordEntity(
    word = word,
    definition = definition,
    example = example,
)

@Keep
data class WordsResponseDto(
    @SerializedName("word") val word: String,
    @SerializedName("definition") val definition: String,
    @SerializedName("example") val example: String,
)

class DictionaryNetworkRepositoryImpl @Inject constructor(
    private val dictionaryApi: DictionaryApi
) : DictionaryNetworkRepository {

    override suspend fun getRandomResult(): Flow<ResultState<WordEntity>> {
        return flow {
            emit(ResultState.Loading)
            try {
                val response = dictionaryApi.getRandom()
                if (response.isSuccessful) {
                    response.body()?.let {
                        it.words.firstOrNull()?.let { item ->
                            emit(ResultState.Success(item.toEntity()))
                        }
                    }
                } else {
                    emit(ResultState.Error(ErrorType.CustomError))
                }
            } catch (ex: Throwable) {
                emit(ResultState.Error(ex.toIOErrorType()))
            } catch (ex: HttpException) {
                emit(ResultState.Error(ex.code().toHttpErrorType()))
            }
        }
    }

    override suspend fun getSearchResult(term: String): Flow<ResultState<List<WordEntity>>> {
        return flow {
            emit(ResultState.Loading)
            try {
                val response = dictionaryApi.getSearch(term)
                if (response.isSuccessful) {
                    response.body()?.let {
                        val listWordEntity = it.words.map { item ->
                            item.toEntity()
                        }
                        emit(ResultState.Success(listWordEntity))
                    }
                } else {
                    emit(ResultState.Error(ErrorType.CustomError))
                }
            } catch (ex: Throwable) {
                emit(ResultState.Error(ex.toIOErrorType()))
            } catch (ex: HttpException) {
                emit(ResultState.Error(ex.code().toHttpErrorType()))
            }
        }
    }
}

data class WordEntity(
    val word:String,
    val definition: String,
    val example: String,
)

interface DictionaryNetworkRepository {
    suspend fun getRandomResult(): Flow<ResultState<WordEntity>>
    suspend fun getSearchResult(term:String): Flow<ResultState<List<WordEntity>>>
}
class GetRandomResultUseCase @Inject constructor(private val repository: DictionaryNetworkRepository) {
    suspend operator fun invoke() = repository.getRandomResult()
}
class GetSearchResultUseCase @Inject constructor(private val repository: DictionaryNetworkRepository) {
    suspend operator fun invoke(term:String) = repository.getSearchResult(term)
}

@HiltViewModel
class MainViewModel @Inject constructor(
    private val getRandomResultUseCase: GetRandomResultUseCase,
    private val getSearchResultUseCase: GetSearchResultUseCase
) : ViewModel() {

    private val _searchWords =
        MutableStateFlow<ResultState<List<WordEntity>>>(ResultState.Empty)
    val searchWords = _searchWords.asStateFlow()

    private val _randomWord =
        MutableStateFlow<ResultState<WordEntity>>(ResultState.Loading)
    val randomWord = _randomWord.asStateFlow()


    fun getRandomWord() {
        viewModelScope.launch {
            getRandomResultUseCase()
                .collect { result ->
                    _randomWord.value = result
                }
        }
    }

    @FlowPreview
    fun getSearchWord(term: String) {
        viewModelScope.launch {
            getSearchResultUseCase(term)
                .debounce(2000)
                .onEach { resultStateValue ->
                    _searchWords.value = resultStateValue
                }
                .collect()
        }
    }

}
@OptIn(FlowPreview::class)
@Composable
fun MainScreen(viewModel: MainViewModel = hiltViewModel()) {
    val searchText = remember {
        mutableStateOf("")
    }
    Column(
        modifier = Modifier
            .fillMaxSize()
            .padding(16.dp),
        horizontalAlignment = Alignment.CenterHorizontally
    ) {
        InputRow(
            label = stringResource(R.string.search),
            txtField = searchText.value,
            inputType = KeyboardType.Text,
            onValueChange = {
                searchText.value = it
                viewModel.getSearchWord(it)
            }
        )
        Spacer(modifier = Modifier.height(16.dp))
        when (val result = viewModel.searchWords.collectAsState().value) {
            ResultState.Empty -> {
                ShowWordOfDay()
            }

            ResultState.Loading -> {
                LoadingProgressBar()
            }

            is ResultState.Success -> {
                ShowSearchSuccess(result.data)
            }

            is ResultState.Error -> {
                TextResult(text = stringResource(id = result.error.toMessage()))
            }
        }
    }
}

@Composable
fun TextResult(text:String){
    Text(
        modifier = Modifier.padding(vertical = 60.dp),
        text = text,
        style = MaterialTheme.typography.displayMedium,
        color = textColorPrimary,
        textAlign = TextAlign.Center
    )
}
@Composable
fun InputRow(
    label: String,
    txtField: String,
    inputType: KeyboardType,
    onValueChange: (String) -> Unit
) {
    TextField(
        modifier =
        Modifier
            .fillMaxWidth()
            .padding(vertical = 10.dp)
            .border(
                BorderStroke(
                    width = 2.dp,
                    color = MaterialTheme.colorScheme.primary
                ),
                shape = RoundedCornerShape(50.dp)
            ),
        colors = TextFieldDefaults.textFieldColors(
            textColor = textColorPrimary,
            cursorColor = textColorPrimary,
            backgroundColor = backColorPrimary,
            focusedIndicatorColor = backColorPrimary,
            unfocusedIndicatorColor = backColorPrimary
        ),
        textStyle = MaterialTheme.typography.displayMedium,
        placeholder = { Text(text = label) },
        value = txtField,
        keyboardOptions = KeyboardOptions(keyboardType = inputType),
        onValueChange = onValueChange
    )
}

@Composable
fun LoadingProgressBar() {
    CircularProgressIndicator(
        modifier = Modifier.padding(vertical = 60.dp),
        color = MaterialTheme.colorScheme.primary
    )
}

@Composable
fun ShowSearchSuccess(data: List<WordEntity>) {
    LazyColumn(
        modifier = Modifier.fillMaxSize()
    ) {
        items(data) { item ->
            Spacer(modifier = Modifier.height(8.dp))
            WordItem(word = item)
            Divider(color = MaterialTheme.colorScheme.primary)
        }
    }
}

@Composable
fun WordItem(
    word: WordEntity,
    modifier: Modifier = Modifier
) {
    Column(modifier = modifier) {
        Text(
            text = word.word,
            style = MaterialTheme.typography.displayLarge,
            color = textColorPrimary
        )
        Text(
            text = word.definition,
            style = MaterialTheme.typography.displaySmall,
            color = textColorSecondary
        )
        Spacer(modifier = Modifier.height(16.dp))
    }
}

@Composable
fun ShowWordOfDay(viewModel: MainViewModel = hiltViewModel()) {
    LaunchedEffect(key1 = Unit) {
        viewModel.getRandomWord()
    }
    ElevatedCard(
        modifier = Modifier
            .padding(vertical = 20.dp)
            .fillMaxWidth(),
        shape = RoundedCornerShape(20.dp),
        colors = CardDefaults.elevatedCardColors(primaryColor),
        elevation = CardDefaults.cardElevation(5.dp)
    ) {
        Column(
            modifier = Modifier
                .fillMaxSize()
                .padding(20.dp),
            horizontalAlignment = Alignment.CenterHorizontally,
            verticalArrangement = Arrangement.Center
        ) {
            when (val result = viewModel.randomWord.collectAsState().value) {
                ResultState.Empty -> {
                    ShowWordOfDay()
                }

                ResultState.Loading -> {
                    LoadingProgressBar()
                }

                is ResultState.Success -> {
                    Text(
                        text = result.data.word,
                        style = MaterialTheme.typography.displayLarge,
                        color = textColorPrimary
                    )
                    Text(
                        text = result.data.definition,
                        style = MaterialTheme.typography.displaySmall,
                        color = textColorSecondary
                    )
                }

                is ResultState.Error -> {
                    TextResult(text = stringResource(id = result.error.toMessage()))
                }
            }
        }
    }
}

"""
    }
    
    static func dependencies(_ mainData: MainData) -> ANDData {
        return ANDData(mainFragmentData: ANDMainFragment(imports: """
import androidx.compose.foundation.background
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Surface
import androidx.compose.ui.Modifier
""", content: """
                LearnSlangTheme {
                    Surface(
                        modifier = Modifier
                            .background(MaterialTheme.colorScheme.background),
                    ) {
                        MainScreen()
                    }
                }
"""), mainActivityData: ANDMainActivity(imports: "", extraFunc: "", content: ""), themesData: ANDThemesData(isDefault: true, content: ""), stringsData: ANDStringsData(additional: """
    <string name="default_info">Enter the required data and press the button</string>
    <string name="search">Search…</string>
    <string name="error_unauthorizied">Error 401. You should authenticate before making requests</string>
    <string name="error_forbidden">Error:403. Doesn\\'t have permission to access the resource.</string>
    <string name="error_notfound">Error: 404. The requested URL is not valid.</string>
    <string name="error_unknown">Something went wrong</string>
    <string name="error_no_internet_connection">No internet connection</string>
    <string name="error_bad_internet_connection">Check your internet connection</string>
    <string name="error_socket_time_out">The response timeout has expired, try again</string>
    <string name="error_custom">Check that the city is entered correctly and try again</string>
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
            signingConfig signingConfigs.debug
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
    kapt Dependencies.dagger_hilt_compiler
    kapt Dependencies.hilt_viewmodel_compiler
    implementation Dependencies.retrofit
    implementation Dependencies.okhttp
    implementation Dependencies.okhttp_login_interceptor
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
