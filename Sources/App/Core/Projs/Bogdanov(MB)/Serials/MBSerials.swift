//
//  File.swift
//  
//
//  Created by admin on 27.07.2023.
//

import Foundation

struct MBSerials: FileProviderProtocol {
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
                implementation Dependencies.okhttp
            implementation Dependencies.okhttp_login_interceptor
            implementation Dependencies.retrofit
            implementation Dependencies.converter_gson
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
    static func dependencies(_ mainData: MainData) -> ANDData {
        return ANDData(
            mainFragmentData: ANDMainFragment(
                imports: "",
                content: """
            MBSerialsApi()
        """
            ),
            mainActivityData: ANDMainActivity(
                imports: "",
                extraFunc: "",
                content: ""
            ),
            themesData: ANDThemesData(isDefault: true, content: ""),
            stringsData: ANDStringsData(additional: ""),
            colorsData: ANDColorsData(additional: "")
        )
    }
    
    static var fileName: String = "MBSerials.kt"
    
    static func fileContent(packageName: String, uiSettings: UISettings) -> String {
        return """
package \(packageName).presentation.fragments.main_fragment

import android.util.Log
import androidx.annotation.Keep
import androidx.compose.animation.core.Animatable
import androidx.compose.animation.core.tween
import androidx.compose.foundation.ExperimentalFoundationApi
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.pager.VerticalPager
import androidx.compose.foundation.pager.rememberPagerState
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.verticalScroll
import androidx.compose.material3.Button
import androidx.compose.material3.Card
import androidx.compose.material3.LinearProgressIndicator
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.remember
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import androidx.lifecycle.viewmodel.compose.viewModel
import coil.compose.AsyncImage
import com.google.gson.annotations.SerializedName
import \(packageName).presentation.fragments.main_fragment.ErrorResolver.toHttpErrorType
import \(packageName).presentation.fragments.main_fragment.ErrorResolver.toIOErrorType
import dagger.Module
import dagger.Provides
import dagger.hilt.InstallIn
import dagger.hilt.android.lifecycle.HiltViewModel
import dagger.hilt.components.SingletonComponent
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.SupervisorJob
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import okhttp3.Interceptor
import okhttp3.OkHttpClient
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

val backColorPrimary = Color(0xFF\(uiSettings.backColorPrimary ?? "FFFFFF"))
val textColorPrimary = Color(0xFF\(uiSettings.textColorPrimary ?? "FFFFFF"))

@Composable
fun MBSerialsApi(appViewModel: AppViewModel = viewModel()) {
    val mainState = appViewModel.mainState.collectAsState()

    when (val state = mainState.value.screenState) {
        ScreenState.Loading -> LoadingScreen()
        is ScreenState.Failure -> FailureScreen(state)
        is ScreenState.Success -> SuccessScreen(state)
    }
}

interface KinopoiskApi {

    private companion object {
        const val SERIALS_ENDPOINT = "movie"
    }

    @GET(SERIALS_ENDPOINT)
    suspend fun getSerials(
        @Query("type") type: String = "tv-series"
    ): SerialsModel

}

interface RemoteRepository {

    suspend fun getData(): ScreenState

}

class RemoteRepositoryImpl @Inject constructor(
    private val kinopoiskApi: KinopoiskApi
) : RemoteRepository {

    override suspend fun getData(): ScreenState = withContext(Dispatchers.IO + SupervisorJob()) {
        try {
            ScreenState.Success(
                kinopoiskApi.getSerials()
            )
        } catch (httpException: HttpException) {
            ScreenState.Failure(
                httpException.code().toHttpErrorType()
            )
        } catch (ioException: IOException) {
            ScreenState.Failure(
                ioException.toIOErrorType()
            )
        }
    }
}

@Module
@InstallIn(SingletonComponent::class)
object AppModule {

    @Provides
    @Singleton
    fun provideRetrofitApi(): KinopoiskApi {

        val client = OkHttpClient().newBuilder()
            .addInterceptor(RetrofitClientHelper.createApiKeyInterceptor())
            .build()

        return Retrofit.Builder()
            .addConverterFactory(GsonConverterFactory.create())
            .baseUrl("https://api.kinopoisk.dev/v1.3/")
            .client(client)
            .build()
            .create(KinopoiskApi::class.java)
    }


    @Provides
    @Singleton
    fun provideRemoteRepository(
        kinopoiskApi: KinopoiskApi
    ): RemoteRepository = RemoteRepositoryImpl(kinopoiskApi)

}

@Keep
data class Poster(
    val url: String
)

@Keep
data class SerialData(
    val description: String,
    val enName: String,
    val name: String,
    val poster: Poster,
    val shortDescription: String,
    val year: Int
)

@Keep
data class SerialsModel(
    @SerializedName("docs")
    val serialsData: List<SerialData>
)

@Keep
data class MainState(
    val screenState: ScreenState
)

@Composable
fun FailureScreen(failureState: ScreenState.Failure, appViewModel: AppViewModel = viewModel()) {
    val errorText = when (failureState.errorType) {
        ErrorResolver.ErrorType.Unauthorized -> "There is no token in request!\\nTell us by mail please"
        ErrorResolver.ErrorType.Forbidden -> "Daily limit exceeded!"
        ErrorResolver.ErrorType.NotFound -> "Resource not found exception…"
        ErrorResolver.ErrorType.NoInternetConnection -> "You have no internet!\\nCheck your connection"
        ErrorResolver.ErrorType.BadInternetConnection -> "You have too slow internet speed\\ntry to cancel loadings or change your network rate"
        ErrorResolver.ErrorType.SocketTimeOut -> "Socket time out!\\nTry again later"
        ErrorResolver.ErrorType.Unknown -> "There is some unknown error!"
    }
    Column(
        modifier = Modifier
            .fillMaxSize()
            .background(backColorPrimary),
        verticalArrangement = Arrangement.SpaceAround,
        horizontalAlignment = Alignment.CenterHorizontally
    ) {
        Text(
            text = errorText,
            style = MaterialTheme.typography.bodyLarge,
            modifier = Modifier
                .fillMaxWidth()
                .padding(8.dp)
                .background(backColorPrimary),
            textAlign = TextAlign.Center
        )

        Button(
            onClick = {
                appViewModel.getSerialsData()
            }
        ) {
            Text(
                text = "Retry",
                color = textColorPrimary,
                fontSize = 22.sp
            )
        }
    }
}

@Composable
fun LoadingScreen() {
    val progress = remember {
        Animatable(0f)
    }
    LaunchedEffect(key1 = Unit) {
        progress.animateTo(
            targetValue = 1f,
            animationSpec = tween(1500)
        )
    }
    Box(
        modifier = Modifier
            .fillMaxSize()
            .background(backColorPrimary),
        contentAlignment = Alignment.Center
    ) {
        LinearProgressIndicator(
            progress = progress.value
        )
    }
}

@Composable
fun CardBodyTitle(itemData: SerialData) {
    Row(
        modifier = Modifier
            .fillMaxWidth()
            .padding(4.dp)
            .background(backColorPrimary),
        verticalAlignment = Alignment.CenterVertically,
        horizontalArrangement = Arrangement.SpaceEvenly
    ) {
        Column(
            verticalArrangement = Arrangement.Center,
            horizontalAlignment = Alignment.CenterHorizontally
        ) {
            AsyncImage(
                model = itemData.poster.url,
                contentDescription = null
            )
            Text(
                text = itemData.year.toString(),
                color = textColorPrimary,
                fontSize = 18.sp
            )
        }

        Text(
            modifier = Modifier
                .padding(4.dp)
                .background(backColorPrimary),
            text = itemData.shortDescription,
            color = textColorPrimary,
            fontSize = 18.sp
        )
    }
}

@Composable
fun CardTitle(itemData: SerialData) {
    Column(
        modifier = Modifier
            .fillMaxWidth()
            .padding(horizontal = 16.dp, vertical = 4.dp)
            .background(backColorPrimary),
        verticalArrangement = Arrangement.Center,
        horizontalAlignment = Alignment.CenterHorizontally
    ) {
        itemData.name?.let { name ->
            Text(
                text = name,
                color = textColorPrimary,
                fontSize = 26.sp
            )
        }
        itemData.enName?.let { enName ->
            Text(
                text = enName,
                color = textColorPrimary,
                fontSize = 26.sp
            )
        }
    }
}

@Composable
fun SerialItem(itemData: SerialData) {
    Card(
        modifier = Modifier
            .fillMaxSize()
            .background(backColorPrimary)
    ) {
        Column(
            modifier = Modifier
                .fillMaxSize()
                .background(backColorPrimary),
            verticalArrangement = Arrangement.SpaceBetween,
            horizontalAlignment = Alignment.CenterHorizontally
        ) {
            CardTitle(itemData = itemData)
            CardBody(itemData = itemData)
        }
    }
}

@OptIn(ExperimentalFoundationApi::class)
@Composable
fun SuccessScreen(successState: ScreenState.Success) {
    val pagerState = rememberPagerState(initialPage = 0)
    VerticalPager(
        pageCount = successState.data.serialsData.size,
        modifier = Modifier
            .fillMaxSize()
            .background(backColorPrimary),
        state = pagerState,
        pageSpacing = 16.dp,
        key = { index -> index },
        horizontalAlignment = Alignment.CenterHorizontally
    ) { pageIndex ->
        SerialItem(itemData = successState.data.serialsData[pageIndex])
    }
}

@Composable
fun CardBody(itemData: SerialData) {
    Column(
        modifier = Modifier
            .fillMaxWidth()
            .padding(4.dp)
            .background(backColorPrimary),
        verticalArrangement = Arrangement.SpaceBetween,
        horizontalAlignment = Alignment.CenterHorizontally
    ) {
        CardBodyTitle(itemData = itemData)
        Text(
            modifier = Modifier
                .fillMaxWidth()
                .padding(4.dp)
                .verticalScroll(rememberScrollState())
                .background(backColorPrimary),
            text = itemData.description,
            color = textColorPrimary,
            fontSize = 26.sp
        )
    }
}

interface ScreenState {

    object Loading : ScreenState

    data class Failure(
        val errorType: ErrorResolver.ErrorType
    ) : ScreenState

    data class Success(
        val data: SerialsModel
    ) : ScreenState

}

object RetrofitClientHelper {

    fun createApiKeyInterceptor() = Interceptor { chain ->
        val original = chain.request()
        val requestBuilder = original.newBuilder()
            .addHeader("X-API-KEY", "CRFBD55-KHDMFVM-KEPS8NH-PMX5VE9")
        val request = requestBuilder.build()
        chain.proceed(request)
    }

}

object ErrorResolver {
    enum class ErrorType {
        Unauthorized,
        Forbidden,
        NotFound,
        NoInternetConnection,
        BadInternetConnection,
        SocketTimeOut,
        Unknown
    }

    fun Int.toHttpErrorType(): ErrorType {
        return when (this) {
            401 -> ErrorType.Unauthorized
            403 -> ErrorType.Forbidden
            404 -> ErrorType.NotFound
            else -> ErrorType.Unknown
        }
    }

    fun Throwable.toIOErrorType(): ErrorType {
        return when (this) {
            is ConnectException -> ErrorType.NoInternetConnection
            is UnknownHostException -> ErrorType.BadInternetConnection
            is SocketTimeoutException -> ErrorType.SocketTimeOut
            else -> ErrorType.Unknown
        }
    }

}

@HiltViewModel
class AppViewModel @Inject constructor(
    private val remoteRepository: RemoteRepository
) : ViewModel() {

    private val _mainState = MutableStateFlow(MainState(screenState = ScreenState.Loading))
    val mainState = _mainState.asStateFlow()

    init {
        getSerialsData()
    }

    fun getSerialsData() = with(_mainState.value) {
        _mainState.value = copy(
            screenState = ScreenState.Loading
        )
        viewModelScope.launch {
            _mainState.value = copy(
                screenState = remoteRepository.getData()
            )
            Log.d("TAG", "getSerialsData: ${remoteRepository.getData()}")
        }
    }
}
"""
    }
    
    
}
