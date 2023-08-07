//
//  File.swift
//  
//
//  Created by admin on 07.08.2023.
//

import Foundation

struct EGPhoneChecker: CMFFileProviderProtocol {
    static var fileName: String = "EGPhoneChecker.kt"
    
    static func fileContent(packageName: String, uiSettings: UISettings) -> String {
        return """
package \(packageName).presentation.fragments.main_fragment

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.text.KeyboardOptions
import androidx.compose.material.CircularProgressIndicator
import androidx.compose.material.Divider
import androidx.compose.material.Icon
import androidx.compose.material.MaterialTheme
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.rounded.Done
import androidx.compose.material.icons.rounded.Error
import androidx.compose.material3.Button
import androidx.compose.material3.ButtonDefaults
import androidx.compose.material3.Card
import androidx.compose.material3.CardDefaults
import androidx.compose.material3.OutlinedTextField
import androidx.compose.material3.OutlinedTextFieldDefaults
import androidx.compose.material3.Text
import androidx.compose.material3.TextFieldDefaults
import androidx.compose.runtime.Composable
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.TextStyle
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.input.KeyboardType
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
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.flow.flow
import kotlinx.coroutines.launch
import okhttp3.Interceptor
import okhttp3.OkHttpClient
import okhttp3.logging.HttpLoggingInterceptor
import retrofit2.Response
import retrofit2.Retrofit
import retrofit2.converter.gson.GsonConverterFactory
import retrofit2.http.GET
import retrofit2.http.Query
import java.io.IOException
import java.util.concurrent.TimeUnit
import javax.inject.Inject
import javax.inject.Singleton

//generate
val backColorPrimary = Color(0xFF\(uiSettings.backColorPrimary ?? "FFFFFF"))
val primaryColor = Color(0xFF\(uiSettings.primaryColor ?? "FFFFFF"))
val buttonColorPrimary = Color(0xFF\(uiSettings.buttonColorPrimary ?? "FFFFFF"))
val buttonTextColorPrimary = Color(0xFF\(uiSettings.buttonTextColorPrimary ?? "FFFFFF"))
val textColorPrimary = Color(0xFF\(uiSettings.textColorPrimary ?? "FFFFFF"))
val surfaceColor = Color(0xff\(uiSettings.surfaceColor ?? "FFFFFF"))

//const
val errorColor = Color(0xFFFFB3B3)
val colorSuccess = Color(0xFF99E699)
val colorTransparent = Color(0x00FFFFFF)

sealed class ResultState<out R> {
    data class Success<out T>(val data: T) : ResultState<T>()
    data class Exception(val exception: IOException) : ResultState<Nothing>()
    data class Error(val errorCode: Int) : ResultState<Nothing>()
    object Loading : ResultState<Nothing>()
    object Empty : ResultState<Nothing>()
}


object Constants {
    const val API_KEY = "LazA/0fej14xuOmn2UfD1g==0lU5Q2yhj3evz7uq"
    const val END_POINT = "v1/validatephone"
    const val BASE_URL = "https://api.api-ninjas.com/"
}

interface ValidatePhoneApi {
    @GET(Constants.END_POINT)
    suspend fun getValidation(@Query("number") number: String): Response<ValidatePhoneResponseDto>
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
    fun provideOkHttpClient(logging: HttpLoggingInterceptor): OkHttpClient {
        return OkHttpClient.Builder()
            .addInterceptor(Interceptor { chain ->
                val newRequest = chain.request().newBuilder()
                    .addHeader("X-Api-Key", Constants.API_KEY)
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
    fun provideRetrofit(okHttp: OkHttpClient): Retrofit {
        return Retrofit.Builder().apply {
            addConverterFactory(GsonConverterFactory.create())
            client(okHttp)
            baseUrl(Constants.BASE_URL)
        }.build()
    }

    @Singleton
    @Provides
    fun provideValidatePhoneApi(retrofit: Retrofit): ValidatePhoneApi {
        return retrofit.create(ValidatePhoneApi::class.java)
    }

    @Singleton
    @Provides
    fun provideValidatePhoneRepository(validatePhoneApi: ValidatePhoneApi): ValidatePhoneRepository {
        return ValidateRepositoryImpl(validatePhoneApi)
    }

}

data class ValidatePhoneResponseDto(
    @SerializedName("is_valid") val isValid: Boolean,
    @SerializedName("is_formatted_properly") val isFormattedProperly: Boolean,
    @SerializedName("country") val country: String,
    @SerializedName("location") val location: String,
    @SerializedName("format_national") val formatNational: String,
    @SerializedName("format_international") val formatInternational: String
)

class ValidateRepositoryImpl @Inject constructor(
    private val validatePhoneApi: ValidatePhoneApi
) : ValidatePhoneRepository {
    override suspend fun getValidationResult(number: String): Flow<ResultState<ValidatePhoneEntity>> {
        return flow {
            emit(ResultState.Loading)
            try {
                val response = validatePhoneApi.getValidation(number)
                if (response.isSuccessful) {
                    response.body()?.let {
                        val validatePhoneEntity = ValidatePhoneEntity(
                            isValid = it.isValid,
                            isFormattedProperly = it.isFormattedProperly,
                            country = it.country,
                            location = it.location,
                            timezones = null,
                            formatNational = it.formatNational,
                            formatInternational = it.formatInternational,
                            formatE164 = null,
                            countryCode = null
                        )
                        emit(ResultState.Success(validatePhoneEntity))
                    }
                } else {
                    emit(ResultState.Error(response.code()))
                }
            } catch (exp: IOException) {
                emit(ResultState.Exception(exp))
            }
        }
    }
}

data class ValidatePhoneEntity(
    val isValid: Boolean,
    val isFormattedProperly: Boolean,
    val country: String,
    val location: String,
    val timezones: List<String>?,
    val formatNational: String,
    val formatInternational: String,
    val formatE164: String?,
    val countryCode: Int?
)

interface ValidatePhoneRepository {
    suspend fun getValidationResult(number: String): Flow<ResultState<ValidatePhoneEntity>>
}

class GetValidationResultUseCase @Inject constructor(private val repository: ValidatePhoneRepository) {
    suspend operator fun invoke(number: String) = repository.getValidationResult(number)
}


@Composable
fun MainScreen(viewModel: MainFragmentViewModel = hiltViewModel()) {
    Column(
        horizontalAlignment = Alignment.CenterHorizontally,
        modifier = Modifier
            .fillMaxSize()
            .background(color = backColorPrimary)
    ) {
        var textState by remember { mutableStateOf("") }

        val onTextChange = { text: String ->
            textState = text
        }
        InputRaw(textState = textState, onTextChange = onTextChange)

        Button(
            onClick = {
                viewModel.getValidation(textState)
            },
            colors = ButtonDefaults.buttonColors(
                containerColor = buttonColorPrimary
            )
        ) {
            Text(
                text = stringResource(R.string.btn_check),
                color = buttonTextColorPrimary
            )
        }
        ShowResult(viewModel)
    }
}


@Composable
fun ShowResult(viewModel: MainFragmentViewModel) {
    when (val result = viewModel.state.collectAsState().value) {
        is ResultState.Error -> {
            ShowCardResult(
                errorColor, stringResource(id = R.string.error_unspecified),
                Icons.Rounded.Error
            )
        }

        ResultState.Loading -> {
            Box(modifier = Modifier.fillMaxSize(), contentAlignment = Alignment.Center) {
                CircularProgressIndicator(color = primaryColor)
            }
        }

        is ResultState.Success -> {
            if (result.data.isValid) {
                val info = with(result.data) {
                    stringResource(
                        id = R.string.main_info,
                        location, formatNational, formatInternational
                    )
                }
                ShowCardResult(colorSuccess, info, Icons.Rounded.Done)
            } else {
                ShowCardResult(
                    errorColor,
                    stringResource(R.string.error_invalid),
                    Icons.Rounded.Error
                )
            }
        }

        ResultState.Empty -> {
            ShowCardResult(
                surfaceColor,
                stringResource(R.string.default_info),
                Icons.Rounded.Done
            )
        }

        is ResultState.Exception -> {
            ShowCardResult(errorColor, stringResource(R.string.error_internet), Icons.Rounded.Error)
        }
    }
}

@Composable
fun ShowCardResult(color: Color, info: String, icon: ImageVector) {
    Card(
        modifier = Modifier
            .padding(vertical = 20.dp)
            .fillMaxSize()
            .padding(horizontal = 20.dp),
        shape = RoundedCornerShape(10.dp),
        colors = CardDefaults.cardColors(containerColor = color),
        elevation = CardDefaults.cardElevation()
    ) {
        Column(
            modifier = Modifier
                .fillMaxSize()
                .padding(20.dp),
            verticalArrangement = Arrangement.Center,
            horizontalAlignment = Alignment.CenterHorizontally
        ) {
            Icon(imageVector = icon, contentDescription = "icon_result", tint = textColorPrimary)
            Divider(
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(vertical = 10.dp, horizontal = 30.dp)
                    .width(1.dp),
                color = textColorPrimary
            )
            Text(
                text = info,
                style = Typography.displayLarge,
                modifier = Modifier.padding(5.dp),
                color = textColorPrimary
            )
        }
    }
}

@Composable
fun InputRaw(
    textState: String,
    onTextChange: (String) -> Unit
) {
    Row(verticalAlignment = Alignment.CenterVertically) {
        OutlinedTextField(
            value = textState,
            onValueChange = {
                onTextChange(it)
            },
            keyboardOptions = KeyboardOptions(
                keyboardType = KeyboardType.Phone
            ),
            singleLine = true,
            label = { Text(stringResource(id = R.string.phone_number), color = textColorPrimary) },
            shape = RoundedCornerShape(10.dp),
            modifier = Modifier.padding(15.dp),
            textStyle = TextStyle(
                fontWeight = FontWeight.Normal,
                fontSize = 20.sp
            ),
            colors = OutlinedTextFieldDefaults.colors(
                cursorColor = primaryColor,
                focusedTextColor = textColorPrimary,
                disabledTextColor = textColorPrimary
            ),
            trailingIcon = {
                Icon(
                    painter = painterResource(R.drawable.baseline_phone_24),
                    contentDescription = "icon_phone",
                    modifier = Modifier
                        .size(40.dp)
                        .padding(5.dp),
                    tint = primaryColor
                )
            }
        )
    }
}

@HiltViewModel
class MainFragmentViewModel @Inject constructor(
    private val getValidationResultUseCase: GetValidationResultUseCase
) : ViewModel() {

    private val _state =
        MutableStateFlow<ResultState<ValidatePhoneEntity>>(ResultState.Empty)
    val state = _state.asStateFlow()

    fun getValidation(number: String) {
        viewModelScope.launch {
            getValidationResultUseCase(number)
                .collect { result ->
                    _state.value = result
                }
        }
    }

}

"""
    }
    
    static func dependencies(_ mainData: MainData) -> ANDData {
        return ANDData(mainFragmentData: ANDMainFragment(imports: "", content: ""), mainActivityData: ANDMainActivity(imports: "", extraFunc: "", content: ""), themesData: ANDThemesData(isDefault: true, content: ""), stringsData: ANDStringsData(additional: """
    <string name="phone_number">Phone Number</string>
    <string name="main_info">Location: %1$s\nNational: %2$s\nInternational: %3$s</string>
    <string name="error_internet">No internet connection</string>
    <string name="default_info">Check the validity of phone number</string>
    <string name="error_invalid">This number is invalid</string>
    <string name="btn_check">Check</string>
    <string name="error_unspecified">Check that the number is entered correctly and try again</string>
"""), colorsData: ANDColorsData(additional: ""))
    }
    
    static func gradle(_ packageName: String) -> GradleFilesData {
        let projectGradleContent = """
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
        let moduleGradleContent = """
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
        let dependenciesContaent = """
package dependencies

object Application {
    const val id = "\(packageName)"
    const val version_code = 1
    const val version_name = "1.0"
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
"""
        let dependenciesName = "Dependencies.kt"
        return GradleFilesData(projectBuildGradle: GradleFileInfoData(content: projectGradleContent, name: projectGradleName), moduleBuildGradle: .init(content: moduleGradleContent, name: moduleGradleName), dependencies: .init(content: dependenciesContaent, name: dependenciesName))
    }
    
    static func cmfHandler(_ packageName: String) -> ANDMainFragmentCMF {
        return ANDMainFragmentCMF(content: """
package \(packageName).presentation.fragments.main_fragment

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.compose.material3.Typography
import androidx.compose.ui.platform.ComposeView
import androidx.compose.ui.text.TextStyle
import androidx.compose.ui.text.font.FontFamily
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.sp
import androidx.fragment.app.Fragment
import dagger.hilt.android.AndroidEntryPoint

val Typography = Typography(
    displayLarge = TextStyle(
        fontFamily = FontFamily.Default,
        fontWeight = FontWeight.W500,
        fontSize = 20.sp,
        lineHeight = 20.sp,
        letterSpacing = 0.4.sp,
        textAlign = TextAlign.Center,
    )
)
@AndroidEntryPoint
class MainFragment : Fragment() {
    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View {
        super.onCreateView(inflater, container, savedInstanceState)
    return ComposeView(requireContext()).apply {
            setContent {
                MainScreen()
            }
        }
    }
}
""", fileName: "MainFragment.kt")
    }
    
}
