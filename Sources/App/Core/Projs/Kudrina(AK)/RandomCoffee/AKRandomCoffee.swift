//
//  File.swift
//  
//
//  Created by admin on 14.08.2023.
//

import Foundation

struct AKRandomCoffee: FileProviderProtocol {
    static var fileName = "\(NamesManager.shared.fileName).kt"
    
    static func fileContent(packageName: String, uiSettings: UISettings) -> String {
        return """
package \(packageName).presentation.fragments.main_fragment

import androidx.annotation.Keep
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.Button
import androidx.compose.material3.ButtonDefaults
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.collectAsState
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.hilt.navigation.compose.hiltViewModel
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import coil.compose.AsyncImage
import coil.request.ImageRequest
import com.google.gson.annotations.SerializedName
import \(packageName).R
import dagger.Module
import dagger.Provides
import dagger.hilt.InstallIn
import dagger.hilt.android.lifecycle.HiltViewModel
import dagger.hilt.components.SingletonComponent
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.flow
import kotlinx.coroutines.launch
import retrofit2.HttpException
import retrofit2.Retrofit
import retrofit2.converter.gson.GsonConverterFactory
import retrofit2.http.GET
import java.io.EOFException
import java.io.IOException
import java.net.SocketException
import java.net.UnknownHostException
import javax.inject.Inject
import javax.inject.Qualifier
import javax.inject.Singleton

val backColorPrimary = Color(0xFF\(uiSettings.backColorPrimary ?? "FFFFFF"))
val buttonColorPrimary = Color(0xFF\(uiSettings.buttonColorPrimary ?? "FFFFFF"))
val textColorPrimary = Color(0xFF\(uiSettings.textColorPrimary ?? "FFFFFF"))

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

interface MainService {
    @GET("random.json")
    suspend fun getMainData(): ImageFromApi
}

@Singleton
class MainRepository @Inject constructor(private val mainService: MainService) {

    suspend fun getData() = flow {
        try {
            val response = mainService.getMainData()
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

@Keep
data class ImageFromApi(
    @SerializedName("file") val file: String
)

sealed class NetworkResult<T> {
    data class IOException<T>(val errorMessage: Int): NetworkResult<T>()
    data class HttpException<T>(val errorMessage: Int): NetworkResult<T>()
    data class Success<T>(val data: T): NetworkResult<T>()
}

@Module
@InstallIn(SingletonComponent::class)
object AppModule {

    @Qualifier
    @Retention(AnnotationRetention.RUNTIME)
    annotation class MyUrl

    @Provides
    @MyUrl
    fun providesBaseUrl() : String =  "https://coffee.alexflipnote.dev/"


    @Provides
    @Singleton
    fun provideRetrofit(@MyUrl BASE_URL : String) : Retrofit = Retrofit.Builder()
        .addConverterFactory(GsonConverterFactory.create())
        .baseUrl(BASE_URL)
        .build()

    @Provides
    @Singleton
    fun provideMainService(retrofit : Retrofit) : MainService = retrofit.create(MainService::class.java)

}


@HiltViewModel
class MainViewModel @Inject constructor(val mainRepository: MainRepository) : ViewModel() {


    private val _data = MutableStateFlow<ImageFromApi>(ImageFromApi(""))
    val data: StateFlow<ImageFromApi> = _data
    fun changeData(newData: ImageFromApi) {
        _data.value = newData
    }

    private val _errorForDisplay = MutableStateFlow<Int>(R.string.empty)
    val errorForDisplay: StateFlow<Int> = _errorForDisplay
    fun changeErrorForDisplay(newErrorForDisplay: Int) {
        _errorForDisplay.value = newErrorForDisplay
    }

    private val _buttonClicked = MutableStateFlow<Boolean>(false)
    val buttonClicked: StateFlow<Boolean> = _buttonClicked
    fun changeButtonClicked(newButtonClicked: Boolean) {
        _buttonClicked.value = newButtonClicked
    }

    fun getData() {
        viewModelScope.launch {

            mainRepository.getData().collect{ result ->
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
fun MainUI(viewModel: MainViewModel = hiltViewModel()) {

    val errorTextId = viewModel.errorForDisplay.collectAsState().value
    val buttonClicked = viewModel.buttonClicked.collectAsState().value

    Column(
        modifier = Modifier
            .fillMaxSize()
            .background(backColorPrimary),
        verticalArrangement = Arrangement.Top,
        horizontalAlignment = Alignment.CenterHorizontally
    ) {

        Text(
            text = stringResource(id = errorTextId),
            color = textColorPrimary,
            fontSize = 14.sp
        )

        Button(
            onClick = {
                viewModel.changeButtonClicked(true)
                viewModel.getData()
            },
            colors = ButtonDefaults.buttonColors(containerColor = buttonColorPrimary)
        ) {
            Text(
                text = stringResource(id = R.string.button_text),
                color = textColorPrimary,
                fontSize = 16.sp
            )
        }

        if (buttonClicked) {
            Column(
                modifier = Modifier
                    .fillMaxSize()
                    .background(backColorPrimary),
                verticalArrangement = Arrangement.Center,
                horizontalAlignment = Alignment.CenterHorizontally
            ) {

                AsyncImage(
                    model = ImageRequest.Builder(LocalContext.current)
                        .data(viewModel.data.collectAsState().value.file)
                        .crossfade(true)
                        .build(),
                    placeholder = painterResource(R.drawable.baseline_image_24),
                    error = painterResource(id = R.drawable.baseline_error_outline_24),
                    contentDescription = stringResource(id = R.string.image_desc),
                    contentScale = ContentScale.Fit,
                    modifier = Modifier
                        .fillMaxWidth()
                        .padding(16.dp)
                        .clip(RoundedCornerShape(12.dp)),
                )
            }
        }
    }
}

"""
    }
    
    static func dependencies(_ mainData: MainData) -> ANDData {
        return ANDData(mainFragmentData: ANDMainFragment(imports: "", content: """
    MainUI()
"""), mainActivityData: ANDMainActivity(imports: "", extraFunc: "", content: ""), themesData: ANDThemesData(isDefault: true, content: ""), stringsData: ANDStringsData(additional: """
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

    <string name="image_desc">coffee</string>
    <string name="button_text">get random image</string>
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

    implementation Dependencies.core_ktx
    implementation Dependencies.coil_compose
    implementation Dependencies.retrofit
    implementation Dependencies.converter_gson
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
    const val coil_compose = "io.coil-kt:coil-compose:2.3.0"
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
