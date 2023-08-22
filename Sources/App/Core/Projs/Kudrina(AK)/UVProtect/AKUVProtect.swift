//
//  File.swift
//  
//
//  Created by admin on 14.08.2023.
//

import Foundation

struct AKUVProtect: FileProviderProtocol {
    static var fileName: String = "AKUVProtect.kt"
    
    static func fileContent(packageName: String, uiSettings: UISettings) -> String {
        return """
package \(packageName).presentation.fragments.main_fragment

import androidx.annotation.Keep
import androidx.compose.foundation.Image
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.Button
import androidx.compose.material.ButtonDefaults
import androidx.compose.material3.Card
import androidx.compose.material3.CardDefaults
import androidx.compose.material3.Text
import androidx.compose.material3.TextField
import androidx.compose.material3.TextFieldDefaults
import androidx.compose.runtime.Composable
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.saveable.rememberSaveable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.platform.LocalLifecycleOwner
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.TextStyle
import androidx.compose.ui.text.font.Font
import androidx.compose.ui.text.font.FontFamily
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.hilt.navigation.compose.hiltViewModel
import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.google.gson.annotations.SerializedName
import \(packageName).R
import dagger.Module
import dagger.Provides
import dagger.hilt.InstallIn
import dagger.hilt.android.lifecycle.HiltViewModel
import dagger.hilt.components.SingletonComponent
import kotlinx.coroutines.flow.flow
import kotlinx.coroutines.launch
import retrofit2.HttpException
import retrofit2.Retrofit
import retrofit2.converter.gson.GsonConverterFactory
import retrofit2.http.GET
import retrofit2.http.Query
import java.io.IOException
import javax.inject.Inject
import javax.inject.Qualifier
import javax.inject.Singleton

val Green = Color(0xFF22AA00)
val Yellow = Color(0xFFFFC700)
val Orange = Color(0xFFFF6B00)
val Red = Color(0xFFFF0F00)
val Purple = Color(0xFFAD00FF)
val NoColor = Color(0x00FFFFFF)

val backColorPrimary = Color(0xFF\(uiSettings.backColorPrimary ?? "FFFFFF"))
val buttonColorPrimary = Color(0xFF\(uiSettings.buttonColorPrimary ?? "FFFFFF"))
val surfaceColor = Color(0xFF\(uiSettings.surfaceColor ?? "FFFFFF"))
val errorColor = Color(0xFF\(uiSettings.errorColor ?? "FFFFFF"))



val MainFont = FontFamily(
    Font(R.font.unbounded_font)
)

val MainFontNormal = FontFamily(
    Font(R.font.unbounded_normal_font)
)

fun getRecommendationsAndColor(uv: Int, viewModel: MainViewModel) {
    when (uv) {
        in 1..2 -> {
            viewModel.setRecommendations(R.string.uv1)
            viewModel.setColor(Green)
        }
        in 3..5 -> {
            viewModel.setRecommendations(R.string.uv2)
            viewModel.setColor(Yellow)
        }
        in 6..7 -> {
            viewModel.setRecommendations(R.string.uv3)
            viewModel.setColor(Orange)
        }
        in 8..10 -> {
            viewModel.setRecommendations(R.string.uv4)
            viewModel.setColor(Red)
        }
        in 11..15 -> {
            viewModel.setRecommendations(R.string.uv5)
            viewModel.setColor(Purple)
        }
        else -> {
            viewModel.setRecommendations(R.string.empty)
            viewModel.setColor(NoColor)
        }
    }
}

@HiltViewModel
class MainViewModel @Inject constructor(val mainRepository: MainRepository) : ViewModel() {

    val dataForDisplay = MutableLiveData<MainData?>()
    val errorForDisplay = MutableLiveData(R.string.empty)

    fun getData(city: String) {
        viewModelScope.launch {

            mainRepository.getData(city = city).collect{ result ->
                when (result) {
                    is NetworkResult.Success -> {
                        errorForDisplay.value = R.string.empty
                        dataForDisplay.value = result.data
                        getRecommendationsAndColor(result.data.current?.uv ?: 0, this@MainViewModel)
                    }
                    is NetworkResult.HttpException -> errorForDisplay.value = result.errorMessage
                    is NetworkResult.IOException -> errorForDisplay.value = result.errorMessage
                }

            }

        }
    }


    private val _recommendations = MutableLiveData(R.string.empty)
    val recommendations: LiveData<Int> get() = _recommendations

    fun setRecommendations(recommendationsInput: Int) {
        _recommendations.value = recommendationsInput
    }

    private val _color = MutableLiveData(NoColor)
    val color: LiveData<Color> get() = _color

    fun setColor(colorInput: Color) {
        _color.value = colorInput
    }

}


@Composable
fun MainLayout() {

    BackgroundImage()

    Column(
        modifier = Modifier
            .fillMaxSize(),
        verticalArrangement = Arrangement.SpaceAround,
        horizontalAlignment = Alignment.CenterHorizontally
    ) {
        Header()

        UVCard()

        TextRec()
    }
}

@Composable
fun UVCard(viewModel: MainViewModel = hiltViewModel()) {

    val uvText = remember {
        mutableStateOf(0)
    }

    viewModel.dataForDisplay.observe(LocalLifecycleOwner.current) {
        uvText.value = it?.current?.uv ?: 0
    }

    val colorForCard = remember {
        mutableStateOf(NoColor)
    }

    viewModel.color.observe(LocalLifecycleOwner.current) {
        colorForCard.value = it
    }

    Card(
        modifier = Modifier
            .width(120.dp)
            .height(108.dp),
        shape = RoundedCornerShape(32.dp),
        colors = CardDefaults.cardColors(containerColor = colorForCard.value)
    ) {

        Column(
            modifier = Modifier
                .fillMaxSize(),
            verticalArrangement = Arrangement.Center,
        ) {
            Text(
                modifier = Modifier.fillMaxWidth(),
                text = if (uvText.value==0) "" else uvText.value.toString(),
                color = Color.White,
                fontSize = 36.sp,
                fontFamily = MainFont,
                textAlign = TextAlign.Center
            )
        }
    }
}

@Composable
fun TextRec(viewModel: MainViewModel = hiltViewModel()) {

    val resForRec = remember {
        mutableStateOf(R.string.empty)
    }

    viewModel.recommendations.observe(LocalLifecycleOwner.current) {
        resForRec.value = it
    }

    androidx.compose.material.Text(
        modifier = Modifier
            .padding(start = 16.dp, end = 16.dp),
        text = stringResource(id = resForRec.value),
        color = surfaceColor,
        fontFamily = MainFontNormal,
        fontSize = 14.sp
    )
}

@Composable
fun Header(viewModel: MainViewModel = hiltViewModel()) {

    val errorText = remember {
        mutableStateOf(R.string.empty)
    }

    viewModel.errorForDisplay.observe(LocalLifecycleOwner.current) {
        errorText.value = it
    }

    Column(
        horizontalAlignment = Alignment.CenterHorizontally,
        verticalArrangement = Arrangement.spacedBy(16.dp)
    ) {

        if (errorText.value != R.string.empty) {
            androidx.compose.material.Text(
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(start = 16.dp, end = 16.dp),
                text = stringResource(id = errorText.value),
                fontSize = 14.sp,
                fontFamily = MainFontNormal,
                color = errorColor,
                textAlign = TextAlign.Center
            )
        }


        Image(
            modifier = Modifier
                .width(140.dp)
                .height(76.dp),
            painter = painterResource(id = R.drawable.uv_index_logo),
            contentDescription = stringResource(id = R.string.logo_image_description)
        )

        val textFromInput = rememberSaveable { mutableStateOf("") }

        Row(
            modifier = Modifier
                .fillMaxWidth()
                .padding(start = 16.dp, end = 16.dp),
            verticalAlignment = Alignment.CenterVertically,
        ) {
            TextField(
                modifier = Modifier
                    .padding(end = 8.dp)
                    .weight(1f),
                value = textFromInput.value,
                onValueChange = { newText ->
                    textFromInput.value = newText
                },
                colors = TextFieldDefaults.colors(
                    unfocusedContainerColor = surfaceColor,
                    focusedContainerColor = surfaceColor,
                    focusedIndicatorColor = NoColor,
                    unfocusedIndicatorColor = NoColor,
                    cursorColor = backColorPrimary
                ),
                shape = RoundedCornerShape(20.dp),
                textStyle = TextStyle(
                    fontSize = 12.sp,
                    fontFamily = MainFontNormal,
                    color = backColorPrimary
                ),
                label = {
                    androidx.compose.material.Text(
                        text = stringResource(id = R.string.hint),
                        fontSize = 11.sp,
                        fontFamily = MainFontNormal,
                        color = buttonColorPrimary
                    )
                }
            )

            Button(
                shape = RoundedCornerShape(40),
                onClick = {
                    viewModel.getData(textFromInput.value.trim())
                },
                colors = ButtonDefaults.buttonColors(
                    backgroundColor = buttonColorPrimary
                )
            ) {
                androidx.compose.material.Text(
                    text = stringResource(id = R.string.ok_button),
                    fontSize = 12.sp,
                    fontFamily = MainFont,
                    color = surfaceColor
                )
            }
        }
    }
}

@Composable
fun BackgroundImage() {
    Image(
        modifier = Modifier
            .fillMaxSize()
            .background(backColorPrimary),
        painter = painterResource(id = R.drawable.bg_colors_image),
        contentDescription = stringResource(id = R.string.bg_image_description),
        contentScale = ContentScale.FillBounds
    )
}

const val MY_KEY = "50957b1e318c47aaa68144503232707"

interface MainService {
    @GET("current.json")
    suspend fun getMainData(
        @Query("key") key: String = MY_KEY,
        @Query("q") city: String,
        @Query("aqi") aqi: String = "no"
    ): MainData
}

@Singleton
class MainRepository @Inject constructor(private val mainService: MainService) {

    suspend fun getData(city: String) = flow {
        try {
            val response = mainService.getMainData(city = city)
            emit(NetworkResult.Success(response))
        } catch (e: Throwable) {
            when (e) {
                is HttpException -> {
                    emit(NetworkResult.HttpException(errorMessage = R.string.wrong_input))
                }
                is IOException -> {
                    emit(NetworkResult.HttpException(errorMessage = R.string.bad_connection))
                }
            }
        }
    }
}

@Keep
data class MainData(
    @SerializedName("current") val current: Current? = Current()
)

@Keep
data class Current(
    @SerializedName("uv") val uv: Int? = null
)

data class MainDataResponse(
    val item: MainData,
    val errorMessage: Int
)

sealed class NetworkResult<T> {
    data class HttpException<T>(val errorMessage: Int): NetworkResult<T>()
    data class IOException<T>(val errorMessage: Int): NetworkResult<T>()
    data class Success<T>(val data: T): NetworkResult<T>()
}

@Module
@InstallIn(SingletonComponent::class)
object AppModule {


    @Qualifier
    @MustBeDocumented
    @Retention(AnnotationRetention.RUNTIME)
    annotation class MyUrl

    @Provides
    @MyUrl
    fun providesBaseUrl() : String =  "https://api.weatherapi.com/v1/"


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

"""
    }
    
    static func dependencies(_ mainData: MainData) -> ANDData {
        return ANDData(mainFragmentData: ANDMainFragment(imports: "", content: """
    MainLayout()
"""), mainActivityData: ANDMainActivity(imports: "", extraFunc: "", content: ""), themesData: ANDThemesData(isDefault: true, content: ""), stringsData: ANDStringsData(additional: """
    <string name="bg_image_description">background image</string>
    <string name="logo_image_description">logo</string>
    <string name="uv1">Additional protection is not needed, since the negative risks are minimal.\nIf sunny wear glasses.</string>
    <string name="uv2">With such solar activity, precautions are already necessary, for example, you should not go out under direct sunlight in the lunch time when the sun is at its zenith.\nExperts recommend wearing covering clothes, applying sunscreens.</string>
    <string name="uv3">This indicates that from 10:00 to 16:00 it is not worth spending a lot of time under the sun. Protect your eyes, skin — wear clothes covering your arms, legs, chest, remember about the headdress, sunglasses. Be sure to apply sunscreen products.</string>
    <string name="uv4">Stay in the shade during the day. Wear sunscreen with high spf (spf 50+). Protect your eyes, skin — wear clothes covering your arms, legs, chest, remember about the headdress, sunglasses.</string>
    <string name="uv5">Radiation is very active — the risk of burns is high. From 10:00 to 16:00 it is better not to go outside. If you need to leave the house, first apply the strongest sunscreen, put on light, but maximally covering clothes, glasses, a hat with a brim.</string>
    <string name="empty"></string>
    <string name="bad_connection">Bad connection</string>
    <string name="wrong_input">Wrong input</string>
    <string name="error">Error</string>
    <string name="ok_button">Ok</string>
    <string name="hint">Enter your city</string>
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

    implementation Dependencies.converter_gson
    implementation Dependencies.retrofit
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
