
//  File.swift
//  
//
//  Created by admin on 8/23/23.
//

import Foundation

struct ITNextPaper: FileProviderProtocol {
    static var fileName = "\(NamesManager.shared.fileName).kt"
    
    static func fileContent(packageName: String, uiSettings: UISettings) -> String {
        """
package \(packageName).presentation.fragments.main_fragment

import androidx.annotation.Keep
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.LazyListScope
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Newspaper
import androidx.compose.material3.Card
import androidx.compose.material3.CardDefaults
import androidx.compose.material3.CircularProgressIndicator
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.Icon
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.ModalBottomSheet
import androidx.compose.material3.Text
import androidx.compose.material3.lightColorScheme
import androidx.compose.material3.rememberModalBottomSheetState
import androidx.compose.runtime.Composable
import androidx.compose.runtime.State
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import androidx.hilt.navigation.compose.hiltViewModel
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import coil.compose.SubcomposeAsyncImage
import coil.request.ImageRequest
import \(packageName).R
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
import java.io.IOException
import javax.inject.Inject
import javax.inject.Singleton
import androidx.compose.foundation.layout.size
import androidx.compose.ui.res.painterResource

val backColorPrimary = Color(0xff\(uiSettings.backColorPrimary ?? "FFFFFF"))
val textColorPrimary = Color(0xff\(uiSettings.textColorPrimary ?? "FFFFFF"))
val surfaceColor = Color(0xff\(uiSettings.surfaceColor ?? "FFFFFF"))

private val LightColorScheme = lightColorScheme(
    primary = surfaceColor,
    background = backColorPrimary,
)

@Composable
fun NextPaperTheme(
    content: @Composable () -> Unit
) {

    MaterialTheme(
        colorScheme = LightColorScheme,
        content = content
    )
}

@Composable
fun ErrorScreen(message: String?, resId: Int?) {
    Box(
        modifier = Modifier
            .fillMaxSize()
            .background(MaterialTheme.colorScheme.background)
    ) {
        message?.let {
            Text(
                text = it,
                color = MaterialTheme.colorScheme.error,
                textAlign = TextAlign.Center,
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(horizontal = 20.dp)
                    .align(Alignment.Center)
            )
        }
        resId?.let {
            Text(
                text = stringResource(id = it),
                color = MaterialTheme.colorScheme.error,
                textAlign = TextAlign.Center,
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(horizontal = 20.dp)
                    .align(Alignment.Center)
            )
        }

    }
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun NewsItem(article: Article, onClick: () -> Unit) {
    Card(
        onClick = onClick,
        elevation = CardDefaults.cardElevation(5.dp),
        modifier = Modifier.padding(horizontal = 20.dp),
        colors = CardDefaults.cardColors(containerColor = surfaceColor)
    ) {
        Column(
            Modifier
                .fillMaxSize()
                .padding(10.dp),
            horizontalAlignment = Alignment.CenterHorizontally
        ) {
            SubcomposeAsyncImage(
                model = ImageRequest.Builder(LocalContext.current)
                    .data(article.urlToImage)
                    .crossfade(true)
                    .build(),
                contentDescription = null,
                error = {
                    Icon(
                        imageVector = Icons.Default.Newspaper,
                        contentDescription = null
                    )
                },
                loading = {
                    CircularProgressIndicator()
                }
            )

            Text(
                text = article.title, fontWeight = FontWeight.Bold,
                modifier = Modifier
                    .padding(10.dp)
                    .align(Alignment.Start),
                color = textColorPrimary
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
        Icon(painter = painterResource(id = R.drawable.icon_news), contentDescription = null, modifier = Modifier.size(300.dp).align(
                    Alignment.Center), tint = Color.White)
    }
}

@Composable
fun SheetContent(article: Article) {
    Column(Modifier.padding(15.dp), verticalArrangement = Arrangement.spacedBy(5.dp)) {
        SubcomposeAsyncImage(
            model = ImageRequest.Builder(LocalContext.current)
                .data(article.urlToImage)
                .crossfade(true)
                .build(),
            contentDescription = null,
            error = {
                Icon(
                    imageVector = Icons.Default.Newspaper,
                    contentDescription = null
                )
            },
            loading = {
                CircularProgressIndicator()
            },
            modifier = Modifier
                .align(Alignment.CenterHorizontally)
                .padding(bottom = 10.dp)
        )
        article.description?.let { Text(text = it, color = textColorPrimary) }
        Spacer(modifier = Modifier.height(10.dp))
        article.content?.let { Text(text = it, color = textColorPrimary)  }
        Spacer(modifier = Modifier.height(10.dp))
        article.source.name?.let { Text(text = it, fontWeight = FontWeight.Bold, color = textColorPrimary) }
        article.author?.let { Text(text = it, fontWeight = FontWeight.Bold, color = textColorPrimary) }
    }
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun NewsScreen(
    viewModel: NewsViewModel = hiltViewModel(),
) {

    when (val state = viewModel.state.value) {
        is NewsScreenState.Loading -> {
            LoadingScreen()
        }

        is NewsScreenState.Success -> {

            var sheetState = rememberModalBottomSheetState(skipPartiallyExpanded = true)
            var isSheetShow by remember { mutableStateOf(false) }

            LazyColumn(modifier = Modifier.fillMaxSize()) {
                state.news.forEach { article ->
                    boxItem(
                        article
                    ) {
                        isSheetShow = true
                        viewModel.setArticle(article)
                    }
                }
            }

            if (isSheetShow){
                ModalBottomSheet(
                    onDismissRequest = {
                        isSheetShow = false
                    },
                    sheetState = sheetState,
                    content = {
                        state.selectArticle?.let { SheetContent(it) }
                    },
                    containerColor = surfaceColor
                )
            }
        }

        is NewsScreenState.Error -> {
            ErrorScreen(state.message, state.resId)
        }
    }

}

fun LazyListScope.boxItem(article: Article, onClick: () -> Unit) {
    item {
        NewsItem(article = article, onClick)
        Spacer(modifier = Modifier.height(16.dp))
    }
}

sealed class NewsScreenState {
    object Loading : NewsScreenState()
    class Success(val news: List<Article> = emptyList(), val selectArticle: Article? = null) : NewsScreenState()
    class Error(val message: String? = null, val resId: Int? = null) : NewsScreenState()
}

@HiltViewModel
class NewsViewModel @Inject constructor(private val getNewsUseCase: GetNews): ViewModel() {

    private val _state = mutableStateOf<NewsScreenState>(NewsScreenState.Loading)
    val state: State<NewsScreenState> = _state

    private var newsList: List<Article> = emptyList()

    init {
        getNews()
    }

    private fun getNews() {
        getNewsUseCase().onEach { result ->
            when(result) {
                is Resource.Success -> {
                    newsList = result.data?.articles ?: emptyList()
                    _state.value = NewsScreenState.Success(news = newsList)
                }
                is Resource.Error -> {
                    _state.value = NewsScreenState.Error(result.message.toString(), resId = result.data as Int?)
                }
            }
        }.launchIn(viewModelScope)
    }

    fun setArticle(article: Article){
        _state.value = NewsScreenState.Success(selectArticle = article, news = newsList)
    }
}

class GetNews @Inject constructor(private val repository: NewsRepository){
    operator fun invoke(): Flow<Resource<News>> = flow {
        emit(repository.getNews())
    }.flowOn(Dispatchers.IO)
}

interface NewsRepository {
    suspend fun getNews() : Resource<News>
}

@Keep
data class News(
    val articles: List<Article>,
    val status: String,
    val totalResults: Int
)

@Keep
data class Article(
    val author: String?,
    val content: String?,
    val description: String?,
    val source: Source,
    val title: String,
    val urlToImage: Any
)

@Keep
data class Source(
    val id: String?,
    val name: String?
)

class NewsImpl @Inject constructor(private val api: NewsApi): NewsRepository {
    override suspend fun getNews(): Resource<News> = safeApiCall { api.getNews() }

}

interface NewsApi {

    @GET("top-headlines?country=us")
    suspend fun getNews(): Response<News>
}

@Module
@InstallIn(SingletonComponent::class)
object ApiModule {

    private const val BASE_URL = "https://newsapi.org/v2/"

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
            .addHeader("X-Api-Key", "97fb2f9e81ef40fc9889e3a65ecf08ad")
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
    fun providesCinemaApi(retrofit: Retrofit) = retrofit.create(NewsApi::class.java)

    @Provides
    @Singleton
    fun provideCinemaRepository(newsApi: NewsApi): NewsRepository {
        return NewsImpl(newsApi)
    }
}

sealed class Resource<T>(val data: T? = null, val message: String? = null) {
    class Success<T>(data: T?): Resource<T>(data)
    class Error<T>(data: T? = null, message: String? = null): Resource<T>(data, message)
}

suspend fun <T> safeApiCall(api: suspend () -> Response<T>): Resource<T> {
    try {
        val response = api()
        if (response.isSuccessful) {
            val body = response.body()
            body?.let { return Resource.Success(body) }
                ?: return Resource.Error(message = "Body is empty")
        } else {
            return Resource.Error(message = "${response.code()} ${response.message()}")
        }
    } catch (throwable: Throwable) {
        return when (throwable) {
            is HttpException -> {
                val error = StatusCode.from(throwable.code())
                Resource.Error(data = error.resId as T)
            }

            is IOException -> Resource.Error(message = throwable.message.toString())
            else -> Resource.Error(message = throwable.message.toString())
        }
    }
}


enum class StatusCode(val code: Int, val resId: Int) {

    BadRequest(400, R.string.badrequest),
    Unauthorized(401, R.string.unauthorized),
    PaymentRequired(402, R.string.paymentRequired),
    Forbidden(403, R.string.forbidden),
    NotFound(404, R.string.notFound),

    InternalServerError(500, R.string.internalServerError),
    NotImplemented(501, R.string.notImplemented),
    BadGateway(502, R.string.badGateway),
    ServiceUnavailable(503, R.string.serviceUnavailable),
    GatewayTimeout(504, R.string.gatewayTimeout),

    Unknown(0, R.string.unknown);

    companion object {
        fun from(code: Int): StatusCode {
            return StatusCode.values().find {
                it.code == code
            } ?: Unknown
        }
    }
}
"""
    }
    
    static func dependencies(_ mainData: MainData) -> ANDData {
        return ANDData(
            mainFragmentData: ANDMainFragment(imports: """
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Surface
""", content: """
                NextPaperTheme {
                    Surface(color = MaterialTheme.colorScheme.background) {
                        NewsScreen()
                    }
                }
"""),
            mainActivityData: ANDMainActivity(imports: "", extraFunc: "", content: ""),
            themesData: ANDThemesData(isDefault: true, content: ""),
            stringsData: ANDStringsData(additional: """
    <string name="badrequest">BadRequest</string>
    <string name="unauthorized">Unauthorized</string>
    <string name="paymentRequired">PaymentRequired</string>
    <string name="forbidden">Forbidden</string>
    <string name="notFound">NotFound</string>
    <string name="internalServerError">InternalServerError</string>
    <string name="notImplemented">NotImplemented</string>
    <string name="badGateway">BadGateway</string>
    <string name="serviceUnavailable">ServiceUnavailable</string>
    <string name="gatewayTimeout">GatewayTimeout</string>
    <string name="unknown">Unknown</string>
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
        buildConfig = true
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

    const val compose_splash = "androidx.core:core-splashscreen:${Versions.splash}"
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
