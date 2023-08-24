//
//  File.swift
//  
//
//  Created by admin on 8/24/23.
//

import Foundation

struct ITCinemaScope: FileProviderProtocol {
    static var fileName: String = "CinemaScope.kt"
    
    static func fileContent(packageName: String, uiSettings: UISettings) -> String {
        """
package \(packageName).presentation.fragments.main_fragment

import androidx.annotation.Keep
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.LazyListScope
import androidx.compose.material3.Card
import androidx.compose.material3.CardDefaults
import androidx.compose.material3.CircularProgressIndicator
import androidx.compose.material3.Divider
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.State
import androidx.compose.runtime.mutableStateOf
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.hilt.navigation.compose.hiltViewModel
import androidx.lifecycle.SavedStateHandle
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import coil.compose.AsyncImage
import coil.request.ImageRequest
import \(packageName).R
import com.google.gson.annotations.SerializedName
import \(packageName).presentation.fragments.main_fragment.destinations.ReviewsScreenDestination
import com.ramcosta.composedestinations.annotation.Destination
import com.ramcosta.composedestinations.annotation.RootNavGraph
import com.ramcosta.composedestinations.navigation.DestinationsNavigator
import dagger.Module
import dagger.Provides
import dagger.hilt.InstallIn
import dagger.hilt.android.lifecycle.HiltViewModel
import dagger.hilt.components.SingletonComponent
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.flow
import kotlinx.coroutines.flow.flowOn
import kotlinx.coroutines.flow.launchIn
import kotlinx.coroutines.flow.onEach
import okhttp3.Interceptor
import okhttp3.OkHttpClient
import okhttp3.logging.HttpLoggingInterceptor
import retrofit2.HttpException
import retrofit2.Response
import retrofit2.Retrofit
import retrofit2.converter.gson.GsonConverterFactory
import retrofit2.http.GET
import retrofit2.http.Query
import java.io.IOException
import javax.inject.Inject
import javax.inject.Singleton

val buttonColorPrimary = Color(0xff\(uiSettings.buttonColorPrimary ?? "FFFFFF"))
val backColorPrimary = Color(0xFF\(uiSettings.backColorPrimary ?? "FFFFFF"))
val textColorPrimary = Color(0xFF\(uiSettings.textColorPrimary ?? "FFFFFF"))
val surfaceColor = Color(0xff\(uiSettings.surfaceColor ?? "FFFFFF"))

@Composable
fun ErrorScreen(error: String) {
    Box(
        modifier = Modifier
            .fillMaxSize()
            .background(backColorPrimary)
    ) {
        Text(
            text = error,
            color = androidx.compose.material.MaterialTheme.colors.error,
            textAlign = TextAlign.Center,
            modifier = Modifier
                .fillMaxWidth()
                .padding(horizontal = 20.dp)
                .align(Alignment.Center)
        )
    }
}

@Composable
fun LoadingScreen() {
    Box(
        modifier = Modifier
            .fillMaxSize()
            .background(MaterialTheme.colorScheme.surface)
    ) {
        CircularProgressIndicator(modifier = Modifier.align(Alignment.Center), color = buttonColorPrimary)
    }
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun FilmItem(film: Film, onClick: () -> Unit) {

    Card(
        onClick = onClick,
        elevation = CardDefaults.cardElevation(5.dp),
        modifier = Modifier.padding(horizontal = 20.dp),
        colors = CardDefaults.cardColors(containerColor = Color.Transparent)
    ) {

        Box(
            modifier = Modifier
                .fillMaxSize()
                .background(buttonColorPrimary)
        ){
            Row(
                Modifier
                    .fillMaxSize()
                    .padding(10.dp)) {

                AsyncImage(
                    model = ImageRequest.Builder(LocalContext.current)
                        .data(film.poster.previewUrl)
                        .crossfade(true)
                        .build(),
                    contentDescription = null,
                    alignment = Alignment.TopStart
                )

                Column(
                    modifier = Modifier
                        .fillMaxWidth()
                        .padding(start = 15.dp),
                    horizontalAlignment = Alignment.Start,
                    verticalArrangement = Arrangement.spacedBy(5.dp)
                ) {

                    Text(text = film.name, fontWeight = FontWeight.Bold, color = textColorPrimary)
                    Text(text = stringResource(R.string.length, film.movieLength), color = textColorPrimary)
                    Text(text = stringResource(R.string.year, film.year), color = textColorPrimary)

                    Column {
                        Text(text = stringResource(R.string.genres), color = textColorPrimary)
                        Row {
                            film.genres.take(2).forEach { Text(stringResource(id = R.string.genre,it.name), color = textColorPrimary) }
                        }
                    }

                    Column {
                        Text(text = stringResource(R.string.countries), color = textColorPrimary)
                        Row {
                            film.countries.take(2).forEach { Text(stringResource(id = R.string.country,it.name), color = textColorPrimary) }
                        }
                    }

                    Column {
                        Text(text = stringResource(R.string.ratings), color = textColorPrimary)
                        Row {
                            Text(text = stringResource(R.string.kp, film.rating.kp), color = textColorPrimary)
                            Spacer(Modifier.width(10.dp))
                            Text(text = stringResource(R.string.imdb, film.rating.imdb), color = textColorPrimary)
                        }
                    }
                }
            }
        }
    }
}

@Composable
fun ReviewItem(review: Review) {
    Card(
        modifier = Modifier.padding(horizontal = 20.dp, vertical = 5.dp),
        colors = CardDefaults.cardColors(containerColor = surfaceColor)
    ) {
        Column(
            Modifier.fillMaxSize().padding(15.dp), verticalArrangement = Arrangement.spacedBy(5.dp)
        ) {
            review.title?.let {
                Text(
                    text = it,
                    fontWeight = FontWeight.Bold,
                    fontSize = 16.sp,
                    color = textColorPrimary
                )
            }
            Divider(color = Color.Black)
            review.author?.let { Text(text = it, fontSize = 16.sp, color = textColorPrimary) }
            Divider(color = Color.Black)
            review.type?.let { Text(text = it, fontSize = 16.sp, color = textColorPrimary) }
            Divider(color = Color.Black)
            review.review?.let { Text(text = it, fontSize = 16.sp, color = textColorPrimary) }
        }
    }
}

@RootNavGraph(start = true)
@Destination
@Composable
fun FilmsScreen(
    viewModel: FilmsViewModel = hiltViewModel(),
    navigator: DestinationsNavigator,
) {

    when (val state = viewModel.state.value) {
        is FilmsScreenState.Loading -> {
            LoadingScreen()
        }

        is FilmsScreenState.Success -> {
            LazyColumn(modifier = Modifier.fillMaxSize()) {
                state.films.forEach { film ->
                    boxItem(
                        film
                    ) {
                        navigator.navigate(ReviewsScreenDestination(film.id))
                    }
                }
            }
        }

        is FilmsScreenState.Error -> {
            ErrorScreen(state.message)
        }
    }

}

fun LazyListScope.boxItem(film: Film, onClick: () -> Unit) {
    item {
        FilmItem(film = film, onClick)
        Spacer(modifier = Modifier.height(16.dp))
    }
}

@Destination
@Composable
fun ReviewsScreen(movieId: Int, viewModel: ReviewsViewModel = hiltViewModel()) {

    when (val state = viewModel.state.value) {
        is ReviewsScreenState.Loading -> {
            LoadingScreen()
        }

        is ReviewsScreenState.Success -> {
            LazyColumn(modifier = Modifier.fillMaxSize()) {
                state.reviews.forEach { review ->
                    boxItem(review)
                }
            }
        }

        is ReviewsScreenState.Error -> {
            ErrorScreen(state.message)
        }
    }

}

fun LazyListScope.boxItem(review: Review) {
    item {
        ReviewItem(review = review)
    }
}

sealed class FilmsScreenState {
    object Loading : FilmsScreenState()
    class Success(val films: List<Film>) : FilmsScreenState()
    class Error(val message: String) : FilmsScreenState()
}

@HiltViewModel
class FilmsViewModel @Inject constructor(private val getFilmsUseCase: GetFilms): ViewModel() {

    private val _state = mutableStateOf<FilmsScreenState>(FilmsScreenState.Loading)
    val state: State<FilmsScreenState> = _state

    init {
        getFilms()
    }

    private fun getFilms() {
        getFilmsUseCase().onEach { result ->
            when(result) {
                is Resource.Success -> {
                    _state.value = FilmsScreenState.Success(result.data?.films ?: emptyList())
                }
                is Resource.Error -> {
                    _state.value = FilmsScreenState.Error(result.message.toString())
                }
            }
        }.launchIn(viewModelScope)
    }

}

sealed class ReviewsScreenState{
    object Loading : ReviewsScreenState()
    class Success(val reviews: List<Review>) : ReviewsScreenState()
    class Error(val message: String) : ReviewsScreenState()
}

@HiltViewModel
class ReviewsViewModel @Inject constructor(
    private val getReviewsUseCase: GetReviews,
    savedStateHandle: SavedStateHandle,
) : ViewModel() {

    private val _state = mutableStateOf<ReviewsScreenState>(ReviewsScreenState.Loading)
    val state: State<ReviewsScreenState> = _state

    init {
        savedStateHandle.get<Int>("movieId")?.let { id ->
            getReviews(id)
        }
    }

    private fun getReviews(id: Int) {
        getReviewsUseCase(id).onEach { result ->
            when (result) {
                is Resource.Success -> {
                    _state.value = ReviewsScreenState.Success(result.data?.reviews ?: emptyList())
                }

                is Resource.Error -> {
                    _state.value = ReviewsScreenState.Error(result.message.toString())
                }
            }
        }.launchIn(viewModelScope)
    }
}

class GetFilms @Inject constructor(private val repository: CinemaRepository){
    operator fun invoke(): Flow<Resource<Films>> = flow {
        emit(repository.getFilms())
    }.flowOn(Dispatchers.IO)
}

class GetReviews @Inject constructor(private val repository: CinemaRepository){
    operator fun invoke(id: Int): Flow<Resource<Reviews>> = flow {
        emit(repository.getReviews(id))
    }.flowOn(Dispatchers.IO)
}

interface CinemaRepository {
    suspend fun getFilms() : Resource<Films>
    suspend fun getReviews(id: Int): Resource<Reviews>
}

@Keep
data class Films(
    @SerializedName("docs")
    val films: List<Film>,
    val limit: Int,
    val page: Int,
    val pages: Int,
    val total: Int
)

@Keep
data class Film(
    val id: Int,
    val name: String,
    val movieLength: Int,
    val year: Int,
    val countries: List<Country>,
    val genres: List<Genre>,
    val poster: Poster,
    val rating: Rating,
)

@Keep
data class Rating(
    val imdb: Double,
    val kp: Double,
)

@Keep
data class Poster(
    val previewUrl: String,
    val url: String
)

@Keep
data class Genre(
    val name: String
)

@Keep
data class Country(
    val name: String
)

@Keep
data class Reviews(
    @SerializedName("docs")
    val reviews: List<Review>,
    val limit: Int,
    val page: Int,
    val pages: Int,
    val total: Int
)

@Keep
data class Review(
    val id: Int,
    val author: String?,
    val review: String?,
    val title: String?,
    val type: String?
)

@Module
@InstallIn(SingletonComponent::class)
object ApiModule {

    private const val BASE_URL = "https://api.kinopoisk.dev/"

    @Singleton
    @Provides
    fun providesHttpLoginInterceptor() =
        HttpLoggingInterceptor().apply {
            level = HttpLoggingInterceptor.Level.BODY
        }

    @Singleton
    @Provides
    fun providesAuthInterceptor() = Interceptor.invoke { chain ->
        val request = chain
            .request()
            .newBuilder()
            .addHeader("X-API-KEY", "SEXAPE3-DNH47AJ-GK9BR9Z-SQKXQCX")
            .build()
        chain.proceed(request)
    }


    @Singleton
    @Provides
    fun providesOkHttpClient(httpLoggingInterceptor: HttpLoggingInterceptor, authInterceptor: Interceptor) = OkHttpClient.Builder()
        .addInterceptor(authInterceptor)
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
    fun providesCinemaApi(retrofit: Retrofit) = retrofit.create(CinemaApi::class.java)

    @Provides
    @Singleton
    fun provideCinemaRepository(cinemaApi: CinemaApi): CinemaRepository {
        return CinemaImpl(cinemaApi)
    }
}

class CinemaImpl @Inject constructor(private val api: CinemaApi): CinemaRepository, BaseRepository() {
    override suspend fun getFilms(): Resource<Films> = safeApiCall { api.getFilms() }

    override suspend fun getReviews(id: Int): Resource<Reviews> = safeApiCall { api.getReviews(id) }

}

interface CinemaApi {

    @GET("v1.3/movie?page=1&type=movie&year=2022-2023&limit=50$fields")
    suspend fun getFilms(): Response<Films>

    @GET("v1/review?page=1&limit=10")
    suspend fun getReviews( @Query("movieId") movieId: Int): Response<Reviews>

}

const val fields = "&selectFields=id%20name%20alternativeName%20movieLength%20year%20countries%20genres%20poster%20rating"
sealed class Resource<T>(val data: T? = null, val message: String? = null) {
    class Success<T>(data: T?): Resource<T>(data)
    class Error<T>(data: T? = null, message: String): Resource<T>(data, message)
}

abstract class BaseRepository {
    suspend fun <T> safeApiCall(api: suspend () -> Response<T>): Resource<T> {
        try {
            val response = api()
            if (response.isSuccessful) {
                val body = response.body()
                body?.let {
                    return Resource.Success(body)
                } ?: return Resource.Error(message = "Body is empty")
            } else {
                return Resource.Error(message = "${response.code()} ${response.message()}")
            }
        } catch (throwable: Throwable) {
            return when (throwable) {
                is HttpException -> Resource.Error(message = "${throwable.code()} - ${throwable.message()}")
                is IOException -> Resource.Error(message = throwable.message.toString())
                else -> Resource.Error(message = throwable.message.toString())
            }
        }
    }
}


"""
    }
    
    static func dependencies(_ mainData: MainData) -> ANDData {
        return ANDData(
            mainFragmentData: ANDMainFragment(imports: """
import androidx.compose.material3.Surface
import com.ramcosta.composedestinations.DestinationsNavHost
""", content: """
                Surface(color = backColorPrimary) {
                    DestinationsNavHost(navGraph = NavGraphs.root)
                }
"""),
            mainActivityData: ANDMainActivity(imports: "", extraFunc: "", content: ""),
            themesData: ANDThemesData(isDefault: true, content: ""),
            stringsData: ANDStringsData(additional: """
    <string name="genres">Genres: </string>
    <string name="countries">Countries: </string>
    <string name="ratings">Ratings: </string>
    <string name="length">Length: %1s min</string>
    <string name="year">Year: %1s</string>
    <string name="kp">kp: %1s</string>
    <string name="imdb">imdb: %1s</string>
    <string name="genre">%1s\\u0020</string>
    <string name="country">%1s\\u0020</string>
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
    implementation Dependencies.compose_splash
    implementation Dependencies.retrofit
    implementation Dependencies.converter_gson
    implementation Dependencies.okhttp
    implementation Dependencies.okhttp_login_interceptor
    ksp Dependencies.kspdestinations
    implementation Dependencies.destinations
    implementation Dependencies.coil_compose
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
    const val coil = "2.3.0"
    const val exp = "0.4.8"
    const val calend = "0.5.1"
    const val paging_version = "3.1.1"
    const val splash = "1.0.1"

    const val destinations = "1.8.42-beta"
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

    const val destinations = "io.github.raamcosta.compose-destinations:core:${Versions.destinations}"
    const val kspdestinations = "io.github.raamcosta.compose-destinations:ksp:${Versions.destinations}"
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
