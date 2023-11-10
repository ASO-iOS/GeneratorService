//
//  File.swift
//  
//
//  Created by admin on 11/10/23.
//

import Foundation

struct KDCats: FileProviderProtocol {
    
    static var fileName: String = "\(NamesManager.shared.fileName).kt"
    
    
    static func fileContent(packageName: String, uiSettings: UISettings) -> String {
        return """
package \(packageName).presentation.fragments.main_fragment

import android.util.Log
import androidx.annotation.Keep
import androidx.annotation.StringRes
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
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.CenterAlignedTopAppBar
import androidx.compose.material3.CircularProgressIndicator
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Text
import androidx.compose.material3.TopAppBarDefaults
import androidx.compose.runtime.Composable
import androidx.compose.runtime.SideEffect
import androidx.compose.runtime.collectAsState
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.TextStyle
import androidx.compose.ui.text.font.Font
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.font.toFontFamily
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
import \(packageName).R
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
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.flow.catch
import kotlinx.coroutines.flow.flow
import kotlinx.coroutines.flow.flowOn
import kotlinx.coroutines.launch
import okhttp3.OkHttpClient
import okhttp3.logging.HttpLoggingInterceptor
import okhttp3.logging.HttpLoggingInterceptor.Logger
import retrofit2.Retrofit
import retrofit2.converter.gson.GsonConverterFactory
import retrofit2.http.GET
import retrofit2.http.Header
import retrofit2.http.Query
import javax.inject.Inject
import javax.inject.Singleton

val backColorPrimary = Color(0xFF\(uiSettings.backColorPrimary ?? "FFFFFF"))
val backColorSecondary = Color(0xFF\(uiSettings.backColorSecondary ?? "FFFFFF"))
val textColorPrimary = Color(0xFF\(uiSettings.textColorPrimary ?? "FFFFFF"))
val textColorSecondary = Color(0xFF\(uiSettings.textColorSecondary ?? "FFFFFF"))

val header = TextStyle(
    fontWeight = FontWeight.Bold,
    fontSize = 32.sp
)

val cardName = TextStyle(
    fontWeight = FontWeight.Bold,
    fontSize = 24.sp
)

val catParam = TextStyle(
    fontWeight = FontWeight.Light,
    fontSize = 18.sp
)

val titleParam = TextStyle(
    fontWeight = FontWeight.Normal,
    fontSize = 20.sp
)

val catOrigin = TextStyle(
    fontWeight = FontWeight.Bold,
    fontSize = 16.sp
)

val catShape = RoundedCornerShape(topStart = 40.dp, topEnd = 40.dp)
sealed interface UIState{

    object Success: UIState
    object Error: UIState
    object Empty: UIState
    object Loading: UIState
    object None: UIState

}
abstract class BaseViewModel<State>(initState: State): ViewModel() {

    private val _viewState: MutableStateFlow<State> = MutableStateFlow(initState)
    val viewState = _viewState.asStateFlow()

    protected val stateValue: State
        get() = viewState.value

    protected fun updateState(changeState: State.() -> State){
        _viewState.value = viewState.value.changeState()
    }



}
abstract class AsyncUseCase(
    private val dispatcher: CoroutineDispatcher = Dispatchers.IO
): UseCase
interface UseCase

const val DEBUG = "AppDebug"

fun Any?.logDebug(prefix: String = "", postfix: String = "") {
    if (this is Throwable?) {
        Log.e(DEBUG, toString())
    } else {
        Log.i(DEBUG, toString())
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
    onSuccess: (T) -> Unit = {},
    onEmpty: () -> Unit = {},
    onError: (Throwable) -> Unit = {},
    onLoading: () -> Unit = {}
) {
    onLoading()
    if (haveDebug) DebugMessage.LOADING.logDebug()
    this().resultHandler(
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


fun CatsResponse.mapToCats(): List<Cat> {
    val cats = map { catResponse ->
        with(catResponse) {
            Cat(
                name = name,
                origin = origin,
                familyFriendly = familyFriendly.separateGradation(),
                otherPetsFriendly = otherPetsFriendly.separateGradation(),
                childrenFriendly = childrenFriendly.separateGradation(),
                intelligence = intelligence.separateGradation(),
                imageUrl = imageLink,
                minWeight = minWeight.toInt(),
                maxWeight = maxWeight.toInt(),
                minLife = minLifeExpectancy.toInt(),
                maxLife = maxLifeExpectancy.toInt()
            )
        }

    }
    return cats
}

fun Int.separateGradation(): Int {
    return when (this) {
        1 -> R.string.low
        2 -> R.string.below_average
        3 -> R.string.average
        4 -> R.string.above_average
        5 -> R.string.high
        else -> R.string.is_unknown
    }
}
class LoadCatsUseCase(private val apiRepository: ApiRepository) : AsyncUseCase() {

    operator fun invoke(): Flow<List<CatsResponseItem>> = flow {
        for (letter in 'a'..'e') {
            emit(apiRepository.getCats(letter.toString()))
        }
    }.flowOn(Dispatchers.IO)

}
interface ApiRepository {

    suspend fun getCats(name: String): List<CatsResponseItem>

}
@Keep
data class CatsResponseItem(
    @SerializedName("children_friendly")
    val childrenFriendly: Int,
    @SerializedName("family_friendly")
    val familyFriendly: Int,
    @SerializedName("general_health")
    val generalHealth: Int,
    @SerializedName("grooming")
    val grooming: Int,
    @SerializedName("image_link")
    val imageLink: String,
    @SerializedName("intelligence")
    val intelligence: Int,
    @SerializedName("length")
    val length: String,
    @SerializedName("max_life_expectancy")
    val maxLifeExpectancy: Double,
    @SerializedName("max_weight")
    val maxWeight: Double,
    @SerializedName("min_life_expectancy")
    val minLifeExpectancy: Double,
    @SerializedName("min_weight")
    val minWeight: Double,
    @SerializedName("name")
    val name: String,
    @SerializedName("origin")
    val origin: String,
    @SerializedName("other_pets_friendly")
    val otherPetsFriendly: Int,
    @SerializedName("playfulness")
    val playfulness: Int,
    @SerializedName("shedding")
    val shedding: Int
)

typealias CatsResponse = List<CatsResponseItem>

@Module
@InstallIn(SingletonComponent::class)
object UseCaseModule {

    @Provides
    @Singleton
    fun provideUseCase(apiRepository: ApiRepository): LoadCatsUseCase =
        LoadCatsUseCase(apiRepository)

}

@Module
@InstallIn(SingletonComponent::class)
abstract class RepositoryModule {

    @Binds
    abstract fun provideApiRepository(apiRepositoryImpl: ApiRepositoryImpl): ApiRepository


}

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

class ApiRepositoryImpl @Inject constructor(private val api: API): ApiRepository {
    override suspend fun getCats(name: String): List<CatsResponseItem> {
        return api.getCats(name = name)
    }


}
interface API {


    @GET(Endpoints.GET_CATS)
    suspend fun getCats(
        @Header(Attributes.ACCESS_TOKEN) accessToken: String = accessKey,
        @Query(Attributes.NAME) name: String
    ): CatsResponse

}

const val BASE_URL = "https://api.api-ninjas.com/v1/"
val accessKey: String
    get() = getApiKey()

 fun getApiKey(): String = "bKe9rRxKekxT/m1+RLSNAg==SGmk5un9bGeb8FTY"

object Endpoints {

    const val EMPTY = "."
    const val GET_CATS = "cats"

}

object Attributes {

    const val ACCESS_TOKEN = "X-Api-Key"
    const val NAME = "name"

}
sealed class Destinations(val route: String){

    object Main: Destinations(Routes.MAIN){

        fun templateRoute(): String{
            return route
        }

        fun requestRoute(): String{
            return route
        }

    }

}

object Routes {

    const val MAIN = "main"

}

@Composable
fun AppNavigation() {
    val systemUiController = rememberSystemUiController()
    val navController = rememberNavController()

    NavHost(
        modifier = Modifier.fillMaxSize().background(color = backColorPrimary),
        navController = navController,
        startDestination = Destinations.Main.route
    ){
        composable(Destinations.Main.route){ MainDest(navController) }
    }

    SideEffect {
        systemUiController.apply {
            setStatusBarColor(
                color = backColorSecondary,
                darkIcons = false
            )
            setNavigationBarColor(
                color = backColorPrimary,
                darkIcons = true
            )
        }
    }
}

@Composable
fun CatsCard(modifier: Modifier = Modifier, cat: Cat) {
    @Composable
    fun HeightSpacer(value: Int) {
        Spacer(modifier = Modifier.height(value.dp))
    }

    Column(modifier = modifier) {
        CatImage(url = cat.imageUrl)
        HeightSpacer(value = 8)
        Text(
            text = cat.name,
            color = textColorPrimary, style = cardName,
            maxLines = 1,
            overflow = TextOverflow.Ellipsis,
            modifier = Modifier
                .padding(horizontal = 20.dp)
                .align(Alignment.CenterHorizontally)
        )
        Column(
            modifier = Modifier
                .padding(horizontal = 12.dp)
                .fillMaxWidth()
        ) {
            HeightSpacer(value = 8)
            Text(
                text = stringResource(R.string.friendliness),
                color = textColorPrimary, style = titleParam,
                maxLines = 1,
                overflow = TextOverflow.Ellipsis,
                modifier = Modifier
            )
            HeightSpacer(value = 2)
            CatFriendliness(
                nameParam = stringResource(R.string.children),
                score = stringResource(id = cat.childrenFriendly)
            )
            CatFriendliness(
                nameParam = stringResource(R.string.family),
                score = stringResource(id = cat.familyFriendly)
            )
            CatFriendliness(
                nameParam = stringResource(R.string.intelligence),
                score = stringResource(id = cat.intelligence)
            )
            CatFriendliness(
                nameParam = stringResource(R.string.other_pets),
                score = stringResource(id = cat.otherPetsFriendly)
            )
            HeightSpacer(value = 8)
            Text(
                text = stringResource(R.string.specifications),
                color = textColorPrimary, style = titleParam,
                maxLines = 1,
                overflow = TextOverflow.Ellipsis,
                modifier = Modifier
            )
            HeightSpacer(value = 2)
            CatSpecification(
                nameParam = stringResource(R.string.weight),
                param1 = cat.minWeight,
                param2 = cat.maxWeight
            )
            CatSpecification(
                nameParam = stringResource(R.string.life),
                param1 = cat.minLife,
                param2 = cat.maxLife
            )
            HeightSpacer(value = 4)
            Text(
                text = cat.origin,
                color = textColorSecondary, style = catOrigin,
                maxLines = 1,
                overflow = TextOverflow.Ellipsis,
                modifier = Modifier
                    .align(Alignment.End)
            )
        }
    }
}

@Composable
fun CatFriendliness(nameParam: String, score: String) {
    Text(
        text = stringResource(R.string.dash, nameParam, score),
        color = textColorPrimary, style = catParam,
        maxLines = 1,
        overflow = TextOverflow.Ellipsis,
        modifier = Modifier
    )
}

@Composable
fun CatSpecification(nameParam: String, param1: Int, param2: Int) {
    Text(
        text = stringResource(
            id = R.string.specifications_text,
            nameParam, param1, param2
        ),
        color = textColorPrimary, style = catParam,
        maxLines = 1,
        overflow = TextOverflow.Ellipsis,
        modifier = Modifier
    )
}


@Composable
fun CatImage(url: String) {
    SubcomposeAsyncImage(
        modifier = Modifier
            .fillMaxWidth()
            .height(200.dp)
            .clip(catShape),
        model = url,
        contentDescription = null,
        contentScale = ContentScale.Crop,
        loading = {
            Box(modifier = Modifier.fillMaxSize(), contentAlignment = Alignment.Center) {
                CircularProgressIndicator(
                    modifier = Modifier
                        .size(20.dp),
                    color = backColorPrimary,
                    strokeWidth = 2.dp
                )
            }
        }
    )
}
@Composable
fun CatsColumn(modifier: Modifier = Modifier, cats: List<Cat>) {
    LazyColumn(
        modifier = modifier,
        horizontalAlignment = Alignment.CenterHorizontally,
        verticalArrangement = Arrangement.spacedBy(14.dp),
        contentPadding = PaddingValues(vertical = 20.dp, horizontal = 12.dp)
    ) {
        items(cats.size) { index ->
            CatsCard(
                cat = cats[index],
                modifier = Modifier
                    .fillMaxWidth()
                    .background(
                        color = backColorSecondary,
                        shape = catShape
                    )
                    .padding(bottom = 14.dp)
            )
        }
    }
}
@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun CatsTopBar(modifier: Modifier = Modifier) {
    CenterAlignedTopAppBar(
        modifier = modifier,
        title = {
            Text(
                text = stringResource(R.string.cats),
                color = textColorPrimary, style = header,
                maxLines = 1,
                overflow = TextOverflow.Ellipsis
            )
        },
        colors = TopAppBarDefaults.centerAlignedTopAppBarColors(
            containerColor = backColorSecondary
        )
    )
}
@Composable
fun MainContent(
    modifier: Modifier = Modifier,
    viewModel: MainViewModel,
    viewState: MainState
) {
    when (viewState.uiState) {
        UIState.Empty, UIState.Error, UIState.Loading -> {
            Box(modifier = modifier, contentAlignment = Alignment.Center) {
                CircularProgressIndicator(
                    modifier = Modifier.size(50.dp),
                    color = backColorSecondary,
                    strokeWidth = 7.dp
                )
            }
        }

        UIState.None -> {}
        UIState.Success -> {
            CatsColumn(
                modifier = modifier,
                cats = viewState.cats.toList()
            )
        }
    }
}
data class Cat(
    val origin: String,
    val name: String,
    @StringRes
    val familyFriendly: Int,
    @StringRes
    val otherPetsFriendly: Int,
    @StringRes
    val childrenFriendly: Int,
    @StringRes
    val intelligence: Int,
    val imageUrl: String,
    val minWeight: Int,
    val maxWeight: Int,
    val minLife: Int,
    val maxLife: Int,
)

data class MainState(
    val cats: List<Cat> = listOf(),
    val uiState: UIState = UIState.None
)
@Composable
fun MainDest(navController: NavController){
    val mainViewModel = hiltViewModel<MainViewModel>()
    val viewState = mainViewModel.viewState.collectAsState().value
    MainScreen(
        viewModel = mainViewModel,
        viewState = viewState
    )
}
@Composable
fun MainScreen(viewModel: MainViewModel, viewState: MainState) {
    Scaffold(
        containerColor = backColorPrimary,
        topBar = {
            CatsTopBar()
        }
    ) {
        MainContent(
            modifier = Modifier.fillMaxSize().padding(it),
            viewModel = viewModel,
            viewState = viewState
        )
    }
}

@HiltViewModel
class MainViewModel @Inject constructor(private val loadCatsUseCase: LoadCatsUseCase) :
    BaseViewModel<MainState>(MainState()) {

    init {
        loadCats()
    }

    private fun loadCats() = viewModelScope.launch(Dispatchers.Main) {
        updateState {
            copy(
                uiState = UIState.Loading
            )
        }
        loadCatsUseCase()
            .catch {
                updateState {
                    copy(
                        uiState = UIState.Error
                    )
                }
            }
            .collect { listCats ->
                updateState {
                    copy(
                        cats = (cats + listCats.mapToCats()).distinct(),
                        uiState = UIState.Success
                    )
                }
            }
    }

}
"""
    }
    
    
    static func dependencies(_ mainData: MainData) -> ANDData {
        return ANDData(
            mainFragmentData: .init(
                imports: "",
                content: """
            AppNavigation()
"""
            ),
            mainActivityData: .empty,
            themesData: .def,
            stringsData: .init(additional: """
    <string name="low">low</string>
    <string name="below_average">below average</string>
    <string name="average">average</string>
    <string name="above_average">above average</string>
    <string name="high">high</string>
    <string name="is_unknown">is unknown</string>
    <string name="cats">Cats</string>
    <string name="children">Children</string>
    <string name="family">Family</string>
    <string name="intelligence">Intelligence</string>
    <string name="other_pets">Other pets</string>
    <string name="friendliness">Friendliness:</string>
    <string name="specifications">Specifications:</string>
    <string name="specifications_text">%s - from %s to %s</string>
    <string name="weight">weight</string>
    <string name="life">life</string>
    <string name="dash">%1$s - %2$s</string>
""")
            ,
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

plugins{
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

    implementation Dependencies.coil_compose

    //Other
    implementation Dependencies.coroutines
    implementation Dependencies.fragment_ktx
    implementation Dependencies.lifecycle_viewmodel
    implementation Dependencies.lifecycle_runtime

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
