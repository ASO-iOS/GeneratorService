//
//  File.swift
//  
//
//  Created by admin on 11/14/23.
//

import Foundation

struct KDSearchMusic: FileProviderProtocol {
    
    static var fileName: String = "\(NamesManager.shared.fileName).kt"
    
    static func fileContent(packageName: String, uiSettings: UISettings) -> String {
        return """
package \(packageName).presentation.fragments.main_fragment

import android.util.Log
import androidx.annotation.Keep
import androidx.compose.foundation.background
import androidx.compose.foundation.interaction.MutableInteractionSource
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.aspectRatio
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.text.BasicTextField
import androidx.compose.foundation.text.KeyboardActions
import androidx.compose.foundation.text.KeyboardOptions
import androidx.compose.material3.CircularProgressIndicator
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Text
import androidx.compose.material3.TextFieldDefaults
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.SideEffect
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.remember
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.draw.shadow
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.RectangleShape
import androidx.compose.ui.graphics.SolidColor
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.TextStyle
import androidx.compose.ui.text.font.Font
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.font.toFontFamily
import androidx.compose.ui.text.input.ImeAction
import androidx.compose.ui.text.input.VisualTransformation
import androidx.compose.ui.text.style.TextOverflow
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.hilt.navigation.compose.hiltViewModel
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import androidx.navigation.NavController
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import androidx.navigation.compose.rememberNavController
import coil.compose.SubcomposeAsyncImage
import com.google.accompanist.systemuicontroller.rememberSystemUiController
import com.google.gson.Gson
import com.google.gson.GsonBuilder
import com.google.gson.annotations.SerializedName
import dagger.Binds
import dagger.Module
import dagger.Provides
import dagger.hilt.InstallIn
import dagger.hilt.android.lifecycle.HiltViewModel
import dagger.hilt.components.SingletonComponent
import kotlinx.coroutines.CoroutineDispatcher
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.channels.Channel
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.flow.receiveAsFlow
import kotlinx.coroutines.launch
import okhttp3.OkHttpClient
import okhttp3.logging.HttpLoggingInterceptor
import okhttp3.logging.HttpLoggingInterceptor.Logger
import retrofit2.Retrofit
import retrofit2.converter.gson.GsonConverterFactory
import retrofit2.http.GET
import retrofit2.http.Header
import retrofit2.http.Headers
import retrofit2.http.Query
import javax.inject.Inject
import javax.inject.Singleton
import \(packageName).R


@Module
@InstallIn(SingletonComponent::class)
object NetworkModule {
    @Provides
    @Singleton
    fun provideInterceptor(): OkHttpClient {
        val httpLoggingInterceptor = HttpLoggingInterceptor(Logger.DEFAULT).also { interceptor ->
            interceptor.level = HttpLoggingInterceptor.Level.BODY
        }
        return OkHttpClient.Builder().addInterceptor(httpLoggingInterceptor).build()
    }

    @Provides
    @Singleton
    fun provideGson(): Gson = GsonBuilder().setLenient().create()

    @Provides
    @Singleton
    fun provideApi(okHttpClient: OkHttpClient, gson: Gson): API {
        return Retrofit.Builder()
            .baseUrl(BASE_URL)
            .addConverterFactory(GsonConverterFactory.create(gson))
            .client(okHttpClient)
            .build()
            .create(API::class.java)
    }
}


@Module
@InstallIn(SingletonComponent::class)
abstract class RepositoryModule {

    @Binds
    abstract fun provideApiRepository(apiRepositoryImpl: ApiRepositoryImpl): ApiRepository

}


abstract class BaseViewModel<State, Effect>(initState: State) : ViewModel() {

    private val _viewState: MutableStateFlow<State> = MutableStateFlow(initState)
    val viewState = _viewState.asStateFlow()

    private val _effects: Channel<Effect> = Channel()
    val effects: Flow<Effect> = _effects.receiveAsFlow()

    protected val state: State
        get() = viewState.value

    protected fun updateState(changeState: State.() -> State) {
        _viewState.value = viewState.value.changeState()
    }


}


abstract class AsyncUseCase(
    private val dispatcher: CoroutineDispatcher = Dispatchers.IO
) : UseCase


interface UseCase


const val APP_DEBUG = "AppDebug"

fun Any?.logDebug(prefix: String = "", postfix: String = "") {
    val debugMessage = "$prefix $this $postfix"
    if (this is Throwable?) {
        Log.e(APP_DEBUG, debugMessage)
    } else {
        Log.i(APP_DEBUG, debugMessage)
    }
}


object DebugMessage {
    const val LOADING = "Loading"
    const val SUCCESS = "Success: "
    const val ERROR = "Error: "
    const val EMPTY = "Empty"
}


suspend inline fun <T> (suspend () -> Result<T>).loadAndHandleData(
    haveDebug: Boolean = false,
    crossinline onSuccess: (T) -> Unit = {},
    onEmpty: () -> Unit = {},
    onError: (Throwable) -> Unit = {},
    onLoading: () -> Unit = {}
) {
    onLoading()
    if (haveDebug) DebugMessage.LOADING.logDebug()
    val resultHandler = this().resultHandler(
        onSuccess = { result ->
            if (haveDebug) (DebugMessage.SUCCESS + result).logDebug()
            onSuccess(result)
        },
        onEmpty = {
            if (haveDebug) DebugMessage.EMPTY.logDebug()
            onEmpty()
        },
        onError = { error ->
            if (haveDebug) (DebugMessage.ERROR + error.message).logDebug()
            onError(error)
        }
    )
}


inline fun <T> Result<T>.resultHandler(
    onSuccess: (T) -> Unit,
    onError: (Throwable) -> Unit,
    onEmpty: () -> Unit
) {
    onSuccess { value ->
        if (value is Collection<*>) {
            if (value.isEmpty()) onEmpty()
            else onSuccess(value)
        } else if (value is Map<*, *>) {
            if (value.isEmpty()) onEmpty()
            else onSuccess(value)
        } else if (value is Array<*>) {
            if (value.isEmpty()) onEmpty()
            else onSuccess(value)
        } else if (value.toString().isEmpty()) {
            onEmpty()
        } else {
            onSuccess(value)
        }
    }
    onFailure { error ->
        onError(error)
    }
}


class ApiRepositoryImpl @Inject constructor(private val api: API) : ApiRepository {
    override suspend fun searchSongs(q: String): Result<List<SongMy>> = kotlin.runCatching {
        api.getMusic(q = q).mapToSongs()
    }


}


fun SongsResponse.mapToSongs(): List<SongMy> {
    return response.hits.map { hit ->
        with(hit.resultCastom) {
            SongMy(
                id = id,
                title = fullTitle,
                date = releaseDateComponents.run {
                    "$day.$month.$year"
                },
                artist = Artist(
                    name = artistNames,
                    imageUrl = primaryArtist.imageUrl
                ),
                imageUrl = headerImageUrl
            )
        }
    }
}


interface API {

    @Headers(
        "User-Agent: CompuServe Classic/1.22",
        "Accept: application/json",
        "Host: api.genius.com"
    )
    @GET(Endpoints.GET_SEARCH)
    suspend fun getMusic(
        @Header(Attributes.ACCESS_TOKEN) accessToken: String = accessKey,
        @Query(Attributes.Q) q: String
    ): SongsResponse

}


@Keep
data class Stats(
    @SerializedName("hot")
    val hot: Boolean,
    @SerializedName("pageviews")
    val pageviews: Int,
    @SerializedName("unreviewed_annotations")
    val unreviewedAnnotations: Int
)


@Keep
data class PrimaryArtist(
    @SerializedName("api_path")
    val apiPath: String,
    @SerializedName("header_image_url")
    val headerImageUrl: String,
    @SerializedName("id")
    val id: Int,
    @SerializedName("image_url")
    val imageUrl: String,
    @SerializedName("iq")
    val iq: Int,
    @SerializedName("is_meme_verified")
    val isMemeVerified: Boolean,
    @SerializedName("is_verified")
    val isVerified: Boolean,
    @SerializedName("name")
    val name: String,
    @SerializedName("url")
    val url: String
)


@Keep
data class ResultCastom(
    @SerializedName("annotation_count")
    val annotationCount: Int,
    @SerializedName("api_path")
    val apiPath: String,
    @SerializedName("artist_names")
    val artistNames: String,
    @SerializedName("featured_artists")
    val featuredArtists: List<FeaturedArtist>,
    @SerializedName("full_title")
    val fullTitle: String,
    @SerializedName("header_image_thumbnail_url")
    val headerImageThumbnailUrl: String,
    @SerializedName("header_image_url")
    val headerImageUrl: String,
    @SerializedName("id")
    val id: Int,
    @SerializedName("lyrics_owner_id")
    val lyricsOwnerId: Int,
    @SerializedName("lyrics_state")
    val lyricsState: String,
    @SerializedName("path")
    val path: String,
    @SerializedName("primary_artist")
    val primaryArtist: PrimaryArtist,
    @SerializedName("pyongs_count")
    val pyongsCount: Int,
    @SerializedName("relationships_index_url")
    val relationshipsIndexUrl: String,
    @SerializedName("release_date_components")
    val releaseDateComponents: ReleaseDateComponents,
    @SerializedName("release_date_for_display")
    val releaseDateForDisplay: String,
    @SerializedName("release_date_with_abbreviated_month_for_display")
    val releaseDateWithAbbreviatedMonthForDisplay: String,
    @SerializedName("song_art_image_thumbnail_url")
    val songArtImageThumbnailUrl: String,
    @SerializedName("song_art_image_url")
    val songArtImageUrl: String,
    @SerializedName("stats")
    val stats: Stats,
    @SerializedName("title")
    val title: String,
    @SerializedName("title_with_featured")
    val titleWithFeatured: String,
    @SerializedName("url")
    val url: String
)


@Keep
data class FeaturedArtist(
    @SerializedName("api_path")
    val apiPath: String,
    @SerializedName("header_image_url")
    val headerImageUrl: String,
    @SerializedName("id")
    val id: Int,
    @SerializedName("image_url")
    val imageUrl: String,
    @SerializedName("iq")
    val iq: Int,
    @SerializedName("is_meme_verified")
    val isMemeVerified: Boolean,
    @SerializedName("is_verified")
    val isVerified: Boolean,
    @SerializedName("name")
    val name: String,
    @SerializedName("url")
    val url: String
)


@Keep
data class Hit(
    @SerializedName("highlights")
    val highlights: List<Any>,
    @SerializedName("index")
    val index: String,
    @SerializedName("result")
    val resultCastom: ResultCastom,
    @SerializedName("type")
    val type: String
)


@Keep
data class Meta(
    @SerializedName("status")
    val status: Int
)


@Keep
data class ReleaseDateComponents(
    @SerializedName("day")
    val day: Int,
    @SerializedName("month")
    val month: Int,
    @SerializedName("year")
    val year: Int
)


@Keep
data class Response(
    @SerializedName("hits")
    val hits: List<Hit>
)


@Keep
data class SongsResponse(
    @SerializedName("meta")
    val meta: Meta,
    @SerializedName("response")
    val response: Response
)


const val BASE_URL = "https://api.genius.com/"
val accessKey: String
    get() = getApiKey()

 fun getApiKey(): String = "Bearer 2GyWZwyhbfYsNOCiIPexH_SwBCjWvev0TmsEJSpm5P2IwFs8QI59zWccaJs7vI-S"

object Endpoints {

    const val GET_SEARCH = "search"

}

const val GENIUS_HEADER =
    "Accept: application/json\\n" +
            "Host: api.genius.com"

object Attributes {

    const val ACCESS_TOKEN = "Authorization"
    const val Q = "q"

}


interface ApiRepository {

    suspend fun searchSongs(q: String): Result<List<SongMy>>

}


data class SongMy(
    val id: Int,
    val title: String,
    val date: String,
    val artist: Artist,
    val imageUrl: String
)

data class Artist(
    val name: String,
    val imageUrl: String
)


sealed interface UIState {

    object Success : UIState
    object Error : UIState
    object Empty : UIState
    object Loading : UIState
    object None : UIState

}


val backColorPrimary = Color(0xFF\(uiSettings.backColorPrimary ?? "FFFFFF"))
val backColorSecondary = Color(0xFF\(uiSettings.backColorSecondary ?? "FFFFFF"))
val primaryColor = Color(0xFF\(uiSettings.primaryColor ?? "FFFFFF"))
val textColorPrimary = Color(0xFF\(uiSettings.textColorPrimary ?? "FFFFFF"))


val searchField = TextStyle(
    fontSize = 20.sp,
    fontWeight = FontWeight.Medium,
)

val placeholderField = TextStyle(
    fontSize = 18.sp,
    fontWeight = FontWeight.Medium,
)

val header = TextStyle(
    fontSize = 21.sp,
    fontWeight = FontWeight.Bold,
)

val shapePrimary = RoundedCornerShape(30.dp)


@Composable
fun AppNavigation() {
    val systemUiController = rememberSystemUiController()
    val navController = rememberNavController()

    NavHost(
        modifier = Modifier
            .fillMaxSize()
            .background(color = backColorPrimary),
        navController = navController,
        startDestination = Destinations.Main.route
    ) {
        composable(Destinations.Main.route) { MainDest(navController) }
    }

    SideEffect {
        systemUiController.setSystemBarsColor(
            color = backColorPrimary,
            darkIcons = false
        )
    }
}


sealed class Destinations(val route: String) {

    object Main : Destinations(Routes.MAIN) {

        fun templateRoute(): String {
            return route
        }

        fun requestRoute(): String {
            return route
        }

    }

}

object Routes {

    const val MAIN = "main"

}


@HiltViewModel
class MainViewModel @Inject constructor(
    private val apiRepository: ApiRepository
) : BaseViewModel<MainState, MainEffect>(MainState()) {


    fun searchSong() = viewModelScope.launch {
        val call = suspend {
            apiRepository.searchSongs(state.searchQuery)
        }
        call.loadAndHandleData(
            onSuccess = { songList ->
                updateState {
                    copy(
                        songs = songList,
                        uiState = UIState.Success
                    )
                }
            },
            onLoading = {
                updateState {
                    copy(
                        uiState = UIState.Loading
                    )
                }
            },
            haveDebug = true
        )
    }

    fun searchChange(text: String) = viewModelScope.launch {
        updateState {
            copy(
                searchQuery = text
            )
        }
    }

}


@Composable
fun SongCard(
    modifier: Modifier = Modifier,
    song: SongMy
) {
    Column(modifier = modifier) {
        Row(
            modifier = Modifier
                .fillMaxWidth()
                .padding(10.dp),
            horizontalArrangement = Arrangement.SpaceBetween,
            verticalAlignment = Alignment.CenterVertically
        ) {
            Text(
                modifier = Modifier.weight(1f),
                text = song.artist.name,
                maxLines = 2,
                overflow = TextOverflow.Ellipsis,
                style = searchField,
                color = textColorPrimary
            )
            DefaultAsyncImage(
                modifier = Modifier
                    .padding(horizontal = 4.dp)
                    .size(40.dp)
                    .clip(CircleShape),
                imageUrl = song.artist.imageUrl
            )
        }
        DefaultAsyncImage(
            imageUrl = song.imageUrl,
            modifier = Modifier
                .fillMaxWidth()
                .aspectRatio(1.40f),
        )
        Row(
            modifier = Modifier
                .fillMaxWidth()
                .padding(10.dp),
            horizontalArrangement = Arrangement.SpaceBetween,
            verticalAlignment = Alignment.CenterVertically
        ) {
            Text(
                modifier = Modifier.weight(1f),
                text = song.title,
                maxLines = 2,
                overflow = TextOverflow.Ellipsis,
                style = header,
                color = textColorPrimary
            )
            Text(
                text = song.date,
                modifier = Modifier.padding(horizontal = 4.dp),
                style = placeholderField,
                color = textColorPrimary
            )
        }
    }
}


@Composable
fun LoadingBox(
    modifier: Modifier = Modifier,
) {
    Box(modifier = modifier, contentAlignment = Alignment.Center) {
        CircularProgressIndicator(
            color = backColorSecondary,
            strokeWidth = 5.dp,
            modifier = Modifier.size(40.dp)
        )
    }
}


@Composable
fun DefaultAsyncImage(
    modifier: Modifier = Modifier,
    imageUrl: String,
) {
    SubcomposeAsyncImage(
        modifier = modifier,
        model = imageUrl,
        contentDescription = null,
        contentScale = ContentScale.Crop,
    )
}


@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun SearchField(
    modifier: Modifier = Modifier,
    value: String,
    onValueChange: (String) -> Unit,
    onSearch: () -> Unit,
    textStyle: TextStyle,
    contentPadding: PaddingValues
) {
    val interactionSource = remember { MutableInteractionSource() }
    BasicTextField(
        modifier = modifier,
        value = value,
        onValueChange = onValueChange,
        interactionSource = interactionSource,
        textStyle = textStyle,
        cursorBrush = SolidColor(textColorPrimary),
        maxLines = 1,
        keyboardActions = KeyboardActions(
            onSearch = {
                onSearch()
            }
        ),
        keyboardOptions = KeyboardOptions(
            imeAction = ImeAction.Search
        )
    ) { innerTextField ->
        TextFieldDefaults.DecorationBox(
            value = value,
            innerTextField = innerTextField,
            enabled = true,
            singleLine = false,
            visualTransformation = VisualTransformation.None,
            interactionSource = interactionSource,
            colors = TextFieldDefaults.colors(
                unfocusedTextColor = textColorPrimary,
                focusedTextColor = textColorPrimary,
                unfocusedIndicatorColor = textColorPrimary,
                focusedIndicatorColor = textColorPrimary,
                unfocusedContainerColor = backColorSecondary,
                focusedContainerColor = backColorSecondary
            ),
            shape = RectangleShape,
            contentPadding = contentPadding,
            placeholder = {
                Text(
                    text = stringResource(R.string.placeholder),
                    maxLines = 1,
                    overflow = TextOverflow.Ellipsis,
                    style = placeholderField
                )
            }
        )
    }

}


@Composable
fun LazySongColumn(
    modifier: Modifier = Modifier,
    songs: List<SongMy>
) {
    LazyColumn(
        modifier = modifier,
        contentPadding = PaddingValues(horizontal = 12.dp, vertical = 10.dp),
        verticalArrangement = Arrangement.spacedBy(12.dp),
        horizontalAlignment = Alignment.CenterHorizontally
    ) {
        items(songs) { song ->
            SongCard(
                song = song,
                modifier = Modifier
                    .shadow(2.dp, shape = shapePrimary)
                    .fillMaxWidth()
                    .background(color = primaryColor, shape = shapePrimary)
            )
        }
    }
}


@Composable
fun MainContent(
    modifier: Modifier = Modifier,
    viewModel: MainViewModel,
    viewState: MainState
) {
    Column(
        modifier = modifier,
        horizontalAlignment = Alignment.CenterHorizontally,
        verticalArrangement = Arrangement.spacedBy(16.dp)
    ) {
        SearchField(
            value = viewState.searchQuery,
            onValueChange = { newText ->
                viewModel.searchChange(newText)
            },
            textStyle = searchField,
            contentPadding = PaddingValues(horizontal = 10.dp, vertical = 14.dp),
            modifier = Modifier
                .padding(horizontal = 30.dp, vertical = 20.dp)
                .fillMaxWidth(),
            onSearch = {
                viewModel.searchSong()
            }
        )
        val baseModifier = Modifier.fillMaxSize()
        when (viewState.uiState) {
            UIState.Loading -> LoadingBox(modifier = baseModifier)
            UIState.Success -> LazySongColumn(songs = viewState.songs, modifier = baseModifier)
            else -> {}
        }
    }
}


sealed interface MainEffect {

}


data class MainState(
    val songs: List<SongMy> = emptyList(),
    val uiState: UIState = UIState.None,
    val searchQuery: String = ""
)


@Composable
fun MainDest(navController: NavController) {
    val mainViewModel = hiltViewModel<MainViewModel>()
    val viewState = mainViewModel.viewState.collectAsState().value
    MainScreen(viewModel = mainViewModel, viewState = viewState)
}


@Composable
fun MainScreen(viewModel: MainViewModel, viewState: MainState) {
    Scaffold(
        containerColor = backColorPrimary
    ) { paddingValues ->
        MainContent(
            modifier = Modifier
                .padding(paddingValues)
                .fillMaxSize(),
            viewModel = viewModel,
            viewState = viewState
        )
    }
    LaunchedEffect(Unit) {
        viewModel.effects.collect { effect ->
            effect
        }
    }
}


"""
    }
    
    static func dependencies(_ mainData: MainData) -> ANDData {
        return ANDData(
            mainFragmentData: .init(imports: "", content: """
            AppNavigation()
"""),
            mainActivityData: .empty,
            themesData: .def,
            stringsData: .init(additional: """
    <string name="placeholder">Enter the text in the search</string>
"""),
            colorsData: .empty
        )
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
    id 'com.android.application'
    id 'org.jetbrains.kotlin.android'
    id 'kotlin-kapt'
    id 'dagger.hilt.android.plugin'
}

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
            signingConfig signingConfigs.debug
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
    //Base
    implementation Dependencies.core_ktx
    implementation Dependencies.appcompat
    implementation Dependencies.material

    //Compose
    implementation Dependencies.compose_ui
    implementation Dependencies.compose_preview
    implementation Dependencies.compose_material3
    implementation Dependencies.compose_activity
    implementation Dependencies.compose_ui_tooling
    implementation Dependencies.compose_navigation
    implementation Dependencies.compose_foundation
    implementation Dependencies.compose_runtime
    implementation Dependencies.compose_runtime_livedata
    implementation Dependencies.compose_mat_icons_core
    implementation Dependencies.compose_mat_icons_core_extended

    implementation Dependencies.compose_system_ui_controller

    //Other
    implementation Dependencies.coroutines
    implementation Dependencies.fragment_ktx
    implementation Dependencies.lifecycle_viewmodel
    implementation Dependencies.lifecycle_runtime

    implementation Dependencies.coil_compose

    //DI
    implementation Dependencies.dagger_hilt
    kapt Dependencies.dagger_hilt_compiler
    kapt Dependencies.hilt_viewmodel_compiler
    implementation Dependencies.compose_hilt_nav

    //Internet
    implementation Dependencies.retrofit
    implementation Dependencies.converter_gson
    implementation Dependencies.okhttp_login_interceptor

    //Room
    kapt Dependencies.room_compiler
    implementation Dependencies.room_runtime
    implementation Dependencies.room_ktx


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
    const val coil = "2.4.0"
    const val exp = "0.4.8"
    const val calend = "0.5.1"
    const val paging_version = "3.1.1"
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
