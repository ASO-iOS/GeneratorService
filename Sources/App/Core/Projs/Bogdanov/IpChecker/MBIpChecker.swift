//
//  File.swift
//  
//
//  Created by admin on 20.06.2023.
//

import Foundation

struct MBIpChecker: FileProviderProtocol {
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
            MBCheckIp()
        """
            ),
            mainActivityData: ANDMainActivity(
                imports: "",
                extraFunc: "",
                content: ""
            ),
            themesData: ANDThemesData(isDefault: true, content: ""),
            stringsData: ANDStringsData(additional: """
            <string name="no_data">No data</string>
            <string name="country">Country: %1$s</string>
            <string name="city">City: %1$s</string>
            <string name="timezone">Timezone: %1$s</string>
            <string name="query">Query: %1$s</string>
            <string name="launch">Launch</string>
            <string name="enter_ip">Enter ip</string>
            <string name="main">Main</string>
            <string name="history">History</string>
        """),
            colorsData: ANDColorsData(additional: "")
        )
    }
    
    static var fileName = "MBIpChecker.kt"
    
    static func fileContent(
        packageName: String,
        uiSettings: UISettings
    ) -> String {
        return """
package \(packageName).presentation.fragments.main_fragment

import androidx.annotation.Keep
import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.text.BasicTextField
import androidx.compose.foundation.text.KeyboardActions
import androidx.compose.foundation.text.KeyboardOptions
import androidx.compose.material3.ButtonDefaults
import androidx.compose.material3.CircularProgressIndicator
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.scale
import androidx.compose.ui.focus.FocusDirection
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.SolidColor
import androidx.compose.ui.graphics.StrokeCap
import androidx.compose.ui.platform.LocalFocusManager
import androidx.compose.ui.text.TextStyle
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.input.ImeAction
import androidx.compose.ui.text.input.KeyboardType
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import androidx.lifecycle.viewmodel.compose.viewModel
import \(packageName).presentation.fragments.main_fragment.ErrorResolver.toHttpErrorType
import \(packageName).presentation.fragments.main_fragment.ErrorResolver.toIOErrorType
import dagger.Module
import dagger.Provides
import dagger.hilt.InstallIn
import dagger.hilt.android.lifecycle.HiltViewModel
import dagger.hilt.components.SingletonComponent
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import retrofit2.HttpException
import retrofit2.Retrofit
import retrofit2.converter.gson.GsonConverterFactory
import retrofit2.http.GET
import retrofit2.http.Path
import java.io.IOException
import java.net.ConnectException
import java.net.SocketTimeoutException
import java.net.UnknownHostException
import javax.inject.Inject
import javax.inject.Singleton
import kotlin.math.min

val backColorPrimary = Color(0xFF\(uiSettings.backColorPrimary ?? "FFFFFF"))
val textColorPrimary = Color(0xFF\(uiSettings.textColorPrimary ?? "FFFFFF"))
val buttonColorPrimary = Color(0xFF\(uiSettings.buttonColorPrimary ?? "FFFFFF"))
val buttonTextColorPrimary = Color(0xFF\(uiSettings.buttonTextColorPrimary ?? "FFFFFF"))

enum class StatusResult(
    val message: String
) {
    SUCCESS("success"), FAILURE("fail")
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

    private val _mainState = MutableStateFlow(MainState())
    val mainState = _mainState.asStateFlow()

    fun updateQuery(index: Int, newHost: String) {
        val newOctets = _mainState.value.octets
        while (newOctets.size < index + 1)
            newOctets.add("")
        newOctets[index] = newHost
        _mainState.value = _mainState.value.copy(
            octets = newOctets
        )
    }

    fun getInfo() {
        viewModelScope.launch {
            try {
                val query = _mainState.value.octets.reduce { query, next ->
                    "$query.$next"
                }
                _mainState.value = _mainState.value.copy(
                    screenState = remoteRepository.getData(query)
                )
            } catch (e: Exception) {
                e.printStackTrace()
            }

        }
    }

    fun navigateReadyScreen() {
        _mainState.value = _mainState.value.copy(
            screenState = ScreenState.Ready
        )
    }

}

@Keep
data class PlaceInfoModel(
    val city: String,
    val country: String,
    val lat: Double,
    val lon: Double,
    val status: String,
    val message: String?
)

@Keep
data class MainState(
    val octets: MutableList<String> = mutableListOf(),
    val screenState: ScreenState = ScreenState.Ready
)

sealed interface ScreenState {

    data class Success(
        val data: PlaceInfoModel
    ) : ScreenState

    object Ready : ScreenState

    object Loading : ScreenState

    data class Failure(
        val errorType: ErrorResolver.ErrorType
    ) : ScreenState
}

@Module
@InstallIn(SingletonComponent::class)
object AppModule {

    @Provides
    @Singleton
    fun provideRetrofitApi(): NetworkApi =
        Retrofit.Builder()
            .addConverterFactory(GsonConverterFactory.create())
            .baseUrl("http://ip-api.com/json/")
            .build()
            .create(NetworkApi::class.java)

    @Provides
    @Singleton
    fun provideRemoteRepository(api: NetworkApi): RemoteRepository = RemoteRepositoryImpl(api)

}

interface NetworkApi {

    @GET("{query}?fields=49361")
    suspend fun getInfoByIp(@Path("query") query: String): PlaceInfoModel

}

interface RemoteRepository {

    suspend fun getData(query: String): ScreenState

}

class RemoteRepositoryImpl @Inject constructor(
    private val networkApi: NetworkApi
) : RemoteRepository {

    override suspend fun getData(query: String) = withContext(Dispatchers.IO) {
        try {
            val response = networkApi.getInfoByIp(query)
            ScreenState.Success(response)
        } catch (ioException: IOException) {
            ScreenState.Failure(ioException.toIOErrorType())
        } catch (httpException: HttpException) {
            ScreenState.Failure(httpException.code().toHttpErrorType())
        }
    }

}

@Composable
fun MBCheckIp(appViewModel: AppViewModel = viewModel()) {
    val mainState = appViewModel.mainState.collectAsState()

    when (val state = mainState.value.screenState) {
        is ScreenState.Failure -> FailureScreen(state.errorType)
        ScreenState.Loading -> LoadingScreen()
        is ScreenState.Success -> SuccessScreen(state.data)
        ScreenState.Ready -> InputScreen()
    }
}

@Composable
fun SuccessScreen(data: PlaceInfoModel, appViewModel: AppViewModel = viewModel()) {
    Column(
        modifier = Modifier
            .fillMaxSize()
            .background(
                backColorPrimary
            ),
        verticalArrangement = Arrangement.SpaceBetween,
        horizontalAlignment = Alignment.CenterHorizontally
    ) {
        Spacer(Modifier)

        when (data.status) {
            StatusResult.SUCCESS.message -> {
                SuccessDisplay(data = data)
            }

            StatusResult.FAILURE.message -> {
                Text(
                    text = "Request exception: ${data.message}",
                    color = textColorPrimary,
                    fontSize = 24.sp
                )
            }
        }

        MainAppButton(buttonText = "Back") {
            appViewModel.navigateReadyScreen()
        }
    }
}

@Composable
fun SuccessDisplay(data: PlaceInfoModel) {
    Column(
        modifier = Modifier
            .fillMaxWidth(0.75f),
        horizontalAlignment = Alignment.CenterHorizontally,
        verticalArrangement = Arrangement.Center
    ) {
        ResponseField("Country", data.country)
        ResponseField("City", data.city)
        ResponseField("Lat", data.lat.toString())
        ResponseField("Lon", data.lon.toString())
    }
}

@Composable
fun ResponseField(fieldName: String, fieldValue: String) {
    Row(
        verticalAlignment = Alignment.CenterVertically,
        horizontalArrangement = Arrangement.Center
    ) {
        Text(
            text = "$fieldName: $fieldValue",
            color = textColorPrimary,
            fontSize = 32.sp
        )
    }
}

@Composable
fun FailureScreen(errorType: ErrorResolver.ErrorType, appViewModel: AppViewModel = viewModel()) {
    val errorText = when (errorType) {
        ErrorResolver.ErrorType.Unauthorized -> "Unauthorized Exception"
        ErrorResolver.ErrorType.Forbidden -> "Forbidden Exception"
        ErrorResolver.ErrorType.NotFound -> "Not found Exception"
        ErrorResolver.ErrorType.NoInternetConnection -> "No internet Connection"
        ErrorResolver.ErrorType.BadInternetConnection -> "Bad internet Connection"
        ErrorResolver.ErrorType.SocketTimeOut -> "Socket Exception"
        ErrorResolver.ErrorType.Unknown -> "Unknown Exception"
    }

    Column(
        modifier = Modifier
            .fillMaxSize()
            .background(
                backColorPrimary
            ),
        verticalArrangement = Arrangement.SpaceBetween,
        horizontalAlignment = Alignment.CenterHorizontally
    ) {
        Spacer(Modifier)

        Text(
            modifier = Modifier.fillMaxWidth(0.9f),
            text = errorText,
            color = textColorPrimary,
            fontSize = 24.sp
        )

        MainAppButton(buttonText = "Retry") {
            appViewModel.navigateReadyScreen()
        }
    }
}

@Composable
fun InputScreen(appViewModel: AppViewModel = viewModel()) {
    Column(
        modifier = Modifier
            .fillMaxSize()
            .background(backColorPrimary),
        verticalArrangement = Arrangement.SpaceBetween,
        horizontalAlignment = Alignment.CenterHorizontally
    ) {
        Spacer(modifier = Modifier)

        InputTextField()

        MainAppButton(buttonText = "Confirm") {
            appViewModel.getInfo()
        }
    }
}

@Composable
fun InputTextField(appViewModel: AppViewModel = viewModel()) {
    val focusManager = LocalFocusManager.current
    Column(modifier = Modifier
        .fillMaxWidth()
        .padding(horizontal = 16.dp), horizontalAlignment = Alignment.CenterHorizontally) {
        Text(text = "Enter ip address", color = textColorPrimary, fontSize = 30.sp)
        Spacer(modifier = Modifier.padding(10.dp))
        Row(
            modifier = Modifier
                .border(
                    width = 2.dp,
                    color = buttonColorPrimary
                ),
            verticalAlignment = Alignment.CenterVertically,
            horizontalArrangement = Arrangement.Center
        ) {
            repeat(4) { index ->

                var inputHost by remember {
                    mutableStateOf("")
                }

                BasicTextField(
                    modifier = Modifier
                        .weight(1f),
                    value = inputHost,
                    onValueChange = { newHost ->
                        inputHost = newHost.toIntOrNull()?.let { newIntHost ->
                            min(newIntHost, 255).toString()
                        } ?: ""
                        appViewModel.updateQuery(index, inputHost)
                        if (newHost.isEmpty() && index > 0)
                            focusManager.moveFocus(FocusDirection.Previous)
                        if (newHost.length > 2 && index < 3)
                            focusManager.moveFocus(FocusDirection.Next)
                    },
                    textStyle = TextStyle(
                        color = textColorPrimary,
                        fontSize = 26.sp,
                        fontWeight = FontWeight.Black
                    ),
                    keyboardOptions = KeyboardOptions(
                        imeAction = ImeAction.Done,
                        autoCorrect = false,
                        keyboardType = KeyboardType.NumberPassword
                    ),
                    singleLine = true,
                    cursorBrush = SolidColor(MaterialTheme.colorScheme.onBackground),
                    keyboardActions = KeyboardActions(
                        onDone = {
                            appViewModel.getInfo()
                            defaultKeyboardAction(ImeAction.Done)
                        }
                    )
                ) { innerTextField ->
                    innerTextField()
                }
            }
        }
    }

}

@Composable
fun LoadingScreen() {
    Column(
        modifier = Modifier
            .fillMaxSize()
            .background(
                backColorPrimary
            ),
        verticalArrangement = Arrangement.SpaceEvenly,
        horizontalAlignment = Alignment.CenterHorizontally
    ) {
        CircularProgressIndicator(
            modifier = Modifier
                .scale(4f),
            color = MaterialTheme.colorScheme.surface,
            strokeCap = StrokeCap.Round,
            strokeWidth = 8.dp
        )
        Text(
            modifier = Modifier
                .scale(1.25f),
            style = MaterialTheme.typography.displayLarge,
            text = "Loading",
            color = MaterialTheme.colorScheme.onBackground
        )
    }
}

@Composable
fun MainAppButton(
    buttonText: String,
    onClick: () -> Unit
) {
    Column(modifier = Modifier.fillMaxWidth(), horizontalAlignment = Alignment.CenterHorizontally) {
        androidx.compose.material3.Button(
            modifier = Modifier
                .fillMaxWidth(0.75f)
                .padding(bottom = 24.dp),
            onClick = onClick,
            shape = RoundedCornerShape(8.dp),
            colors = ButtonDefaults.buttonColors(
                containerColor = buttonColorPrimary,
                contentColor = buttonTextColorPrimary
            )

        ) {
            Text(
                text = buttonText,
                fontSize = 36.sp
            )
        }
        Spacer(modifier = Modifier.padding(6.dp))
    }

}
"""
    }
}
