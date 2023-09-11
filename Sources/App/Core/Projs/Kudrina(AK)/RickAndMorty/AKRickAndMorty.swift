//
//  File.swift
//  
//
//  Created by admin on 09.08.2023.
//

import Foundation

struct AKRickAndMorty: CMFFileProviderProtocol {
    static var fileName = "\(NamesManager.shared.fileName).kt"
    
    static func fileContent(packageName: String, uiSettings: UISettings) -> String {
        return """
package \(packageName).presentation.fragments.main_fragment

import android.app.Activity
import android.content.Context
import android.content.ContextWrapper
import android.content.pm.ActivityInfo
import android.util.Log
import androidx.annotation.Keep
import androidx.compose.foundation.Image
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.layout.wrapContentSize
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.grid.GridCells
import androidx.compose.foundation.lazy.grid.GridItemSpan
import androidx.compose.foundation.lazy.grid.LazyVerticalGrid
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.Button
import androidx.compose.material3.ButtonDefaults
import androidx.compose.material3.Card
import androidx.compose.material3.CardDefaults
import androidx.compose.material3.CircularProgressIndicator
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.DisposableEffect
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.platform.LocalLifecycleOwner
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.font.Font
import androidx.compose.ui.text.font.FontFamily
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel
import androidx.navigation.NavController
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import androidx.navigation.compose.rememberNavController
import coil.compose.AsyncImage
import coil.request.ImageRequest
import \(packageName).R
import com.google.gson.annotations.SerializedName
import dagger.Module
import dagger.Provides
import dagger.hilt.InstallIn
import dagger.hilt.android.lifecycle.HiltViewModel
import dagger.hilt.components.SingletonComponent
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.Job
import kotlinx.coroutines.delay
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import retrofit2.Retrofit
import retrofit2.converter.gson.GsonConverterFactory
import retrofit2.http.GET
import retrofit2.http.Path
import javax.inject.Inject
import javax.inject.Named
import javax.inject.Singleton

val backColorPrimary = Color(0xFF\(uiSettings.backColorPrimary ?? "FFFFFF"))
val backColorSecondary = Color(0xFF\(uiSettings.backColorSecondary ?? "FFFFFF"))
val surfaceColor = Color(0xFF\(uiSettings.surfaceColor ?? "FFFFFF"))
val textColorSecondary = Color(0xFF\(uiSettings.textColorSecondary ?? "FFFFFF"))
val textColorPrimary = Color(0xFF\(uiSettings.textColorPrimary ?? "FFFFFF"))
val onPrimaryColor = Color(0xFF\(uiSettings.onPrimaryColor ?? "FFFFFF"))

val paddingSecondary = 24.dp
val paddingPrimary = 16.dp

@Composable
fun LockScreenOrientation(orientation: Int) {
    val context = LocalContext.current
    DisposableEffect(orientation) {
        val activity = context.findActivity() ?: return@DisposableEffect onDispose {}
        val originalOrientation = activity.requestedOrientation
        activity.requestedOrientation = orientation
        onDispose {
            activity.requestedOrientation = originalOrientation
        }
    }
}

fun Context.findActivity(): Activity? = when (this) {
    is Activity -> this
    is ContextWrapper -> baseContext.findActivity()
    else -> null
}

fun String.getSeasonAndEpisode(): String {
    var season = ""
    var episode = ""

    if (this.length == 6) {
        season = if (this[1] == '0') {
            this[2].toString()
        } else {
            this.substring(1, 2)
        }

        episode = if (this[4] == '0') {
            this[5].toString()
        } else {
            this.substring(4, 6)
        }
    }

    return "$season сезон - $episode серия"
}

fun getCharacterIds(characters: List<String>): String {
    var res = ""

    characters.forEach {
        res += it.substringAfterLast('/') + ','
    }

    return res
}


@HiltViewModel
class MainViewModel @Inject constructor(val repository: MainRepository) : ViewModel(){

    val data = MutableLiveData<CartoonData>()

    // Current clicked card on the MainScreen
    val currentElement = MutableLiveData<Int>(1)

    // Our data from api for DetailScreen (characters)
    val characterData = MutableLiveData<List<CharacterData>>()

    var job: Job? = null

    fun getData() {

        job = CoroutineScope(Dispatchers.IO).launch {
            try {
                val response = repository.getData()
                Log.v("responseFromApiData", response.toString())

                withContext(Dispatchers.Main) {
                    data.value = response

                }

            } catch (e: Exception) {
                e.printStackTrace()
            }

        }
    }

    fun getCharacter(id: String) {

        job = CoroutineScope(Dispatchers.IO).launch {
            try {
                val response = repository.getCharacter(id)
                Log.v("responseFromApiCharacter", response.toString())

                withContext(Dispatchers.Main) {
                    characterData.value = response

                }
            } catch (e: Exception) {
                e.printStackTrace()
            }
        }
    }


    override fun onCleared() {
        super.onCleared()
        job?.cancel()
    }

}


@Keep
data class CharacterData(
    @SerializedName("name")
    val name: String? = null,

    @SerializedName("image")
    val image: String? = null,
)

@Keep
data class CartoonData(
    @SerializedName("info")
    val info: Info? = Info(),

    @SerializedName("results")
    val results: List<Results> = listOf()
)

@Keep
data class Info(
    @SerializedName("next")
    val next: String? = null,

    @SerializedName("prev")
    val prev: String? = null
)

@Keep
data class Results(
    @SerializedName("id")
    val id: Int? = null,

    @SerializedName("name")
    val name: String? = null,

    @SerializedName("air_date")
    val airDate: String? = null,

    @SerializedName("episode")
    val episode: String? = null,

    @SerializedName("characters")
    val characters: ArrayList<String> = arrayListOf()
)

@Singleton
class MainRepository @Inject constructor(
    private val remoteData : MainRemoteData
) {

    suspend fun getData() = remoteData.getData()

    suspend fun getCharacter(id: String) = remoteData.getCharacter(id)
}

interface MainService {

    @GET("episode")
    suspend fun getData(): CartoonData

    @GET("character/{id}")
    suspend fun getCharacter(
        @Path(value = "id") id: String
    ): List<CharacterData>
}

class MainRemoteData @Inject constructor(private val mainService : MainService) {
    suspend fun getData() = mainService.getData()
    suspend fun getCharacter(id: String) = mainService.getCharacter(id)
}

@Module
@InstallIn(SingletonComponent::class)
object AppModule {


    @Provides
    @Named("main_url")
    fun providesBaseUrl() : String =  "https://rickandmortyapi.com/api/"


    @Provides
    @Singleton

    fun provideRetrofit(@Named("main_url") BASE_URL : String) : Retrofit = Retrofit.Builder()
        .addConverterFactory(GsonConverterFactory.create())
        .baseUrl(BASE_URL)
        .build()

    @Provides
    @Singleton
    fun provideMainService(retrofit : Retrofit) : MainService = retrofit.create(MainService::class.java)

    @Provides
    @Singleton
    fun provideMainRemoteData(mainService : MainService) : MainRemoteData = MainRemoteData(mainService)
}

@Composable
fun Navigation(viewModel: MainViewModel) {
    val navController = rememberNavController()

    NavHost(navController = navController, startDestination = "splash_screen") {

        composable("splash_screen") {
            SplashScreen(navController)
        }

        composable("main_screen") {
            MainScreen(navController, viewModel)
        }

        composable(route = "detail_screen") {
            DetailScreen(navController, viewModel)
        }

    }
}

@Composable
fun SplashScreen(navController: NavController) {
    LockScreenOrientation(ActivityInfo.SCREEN_ORIENTATION_PORTRAIT)

    LaunchedEffect(key1 = true) {

        delay(2000L)

        navController.navigate("main_screen") {
            popUpTo(0)
        }
    }

    Column(
        modifier = Modifier
            .padding(start = 29.dp, end = 29.dp),
        verticalArrangement = Arrangement.spacedBy(80.dp, Alignment.CenterVertically),
        horizontalAlignment = Alignment.CenterHorizontally,
    ) {

        Image(
            modifier = Modifier
                .width(302.dp)
                .height(90.dp),
            painter = painterResource(id = R.drawable.logo),
            contentDescription = stringResource(id = R.string.logo_desc),
        )

        CircularProgressIndicator(
            color = surfaceColor
        )

    }
}

@Composable
fun MainScreen(navController: NavController, viewModel: MainViewModel) {

    val dataList = remember {
        mutableStateOf(listOf<Results>())
    }

    viewModel.data.observe(LocalLifecycleOwner.current) {
        dataList.value = it.results
    }

    Column(
        verticalArrangement = Arrangement.spacedBy(24.dp, Alignment.Top),
        horizontalAlignment = Alignment.CenterHorizontally,
    ) {


        Image(
            modifier = Modifier
                .padding(top = paddingSecondary)
                .width(166.dp)
                .height(50.dp),
            painter = painterResource(id = R.drawable.logo),
            contentDescription = stringResource(id = R.string.logo_desc)
        )

        LazyColumn(
            modifier = Modifier.padding(start = paddingPrimary, end = paddingPrimary),
            verticalArrangement = Arrangement.spacedBy(8.dp, Alignment.Top),
            horizontalAlignment = Alignment.CenterHorizontally,
        ) {

            dataList.value.forEach {
                item {
                    Card(
                        modifier = Modifier
                            .fillMaxWidth(),
                        colors = CardDefaults.cardColors(containerColor = backColorSecondary),
                        shape = RoundedCornerShape(16.dp),

                        ) {
                        Row(
                            modifier = Modifier
                                .fillMaxWidth()
                                .padding(8.dp)
                        ) {

                            Column(
                                modifier = Modifier.weight(1f),
                                verticalArrangement = Arrangement.spacedBy(4.dp, Alignment.Top)
                            ) {

                                Card(
                                    colors = CardDefaults.cardColors(containerColor = surfaceColor),
                                    shape = RoundedCornerShape(8.dp)
                                ) {
                                    Text(
                                        modifier = Modifier.padding(5.dp),
                                        text = it.episode?.getSeasonAndEpisode() ?: stringResource(id = R.string.no_data),
                                        color = textColorSecondary,
                                        fontSize = 16.sp,
                                        fontFamily = FontFamily(Font(R.font.gilroy_medium))
                                    )
                                }

                                Text(
                                    text = it.name ?: stringResource(id = R.string.no_data),
                                    color = textColorPrimary,
                                    fontSize = 16.sp,
                                    fontFamily = FontFamily(Font(R.font.gilroy))
                                )

                                Text(
                                    text = it.airDate ?: stringResource(id = R.string.no_data),
                                    color = textColorPrimary,
                                    fontSize = 10.sp,
                                    fontFamily = FontFamily(Font(R.font.gilroy))
                                )

                            }

                            Image(
                                modifier = Modifier
                                    .size(40.dp)
                                    .align(Alignment.CenterVertically)
                                    .clickable {
                                        viewModel.currentElement.value = it.id?.minus(1)
                                        viewModel.getCharacter(
                                            getCharacterIds(
                                                viewModel.data.value?.results?.get(
                                                    it.id ?: 0
                                                )?.characters
                                                    ?: arrayListOf()
                                            )
                                        )
                                        navController.navigate("detail_screen")
                                    },
                                painter = painterResource(id = R.drawable.arrow),
                                contentDescription = stringResource(id = R.string.arrow)
                            )
                        }
                    }
                }
            }
        }
    }
}

@Composable
fun DetailScreen(navController: NavController, viewModel: MainViewModel) {


    val characterList = remember {
        mutableStateOf(listOf<CharacterData>())
    }

    val currentName = remember {
        mutableStateOf(
            viewModel.data.value?.results?.get(viewModel.currentElement.value ?: 0)?.name

        )
    }

    val currentDate = remember {
        mutableStateOf(
            viewModel.data.value?.results?.get(
                viewModel.currentElement.value ?: 0
            )?.airDate ?: "Нет данных"
        )
    }

    val currentSeasonAndEpisode = remember {
        mutableStateOf(
            viewModel.data.value?.results?.get(
                viewModel.currentElement.value ?: 0
            )?.episode?.getSeasonAndEpisode()
        )
    }

    viewModel.characterData.observe(LocalLifecycleOwner.current) {
        characterList.value = it
    }

    LazyVerticalGrid(
        modifier = Modifier.padding(start = paddingPrimary, end = paddingPrimary),
        columns = GridCells.Fixed(count = 2),
        verticalArrangement = Arrangement.spacedBy(10.dp),
        horizontalArrangement = Arrangement.spacedBy(10.dp)
    ) {


        item(span = { GridItemSpan(2) }) {
            Image(
                modifier = Modifier
                    .padding(top = paddingSecondary)
                    .width(166.dp)
                    .height(50.dp),
                painter = painterResource(id = R.drawable.logo),
                contentDescription = stringResource(id = R.string.logo_desc)
            )
        }

        item(span = { GridItemSpan(2) }) {
            Row(
                modifier = Modifier
                    .fillMaxWidth(),
                horizontalArrangement = Arrangement.SpaceBetween,
                verticalAlignment = Alignment.CenterVertically,
            ) {

                Button(
                    modifier = Modifier.wrapContentSize(),
                    colors = ButtonDefaults.outlinedButtonColors(containerColor = surfaceColor),
                    shape = RoundedCornerShape(8.dp),
                    onClick = {
                        navController.navigate("main_screen") {
                            viewModel.characterData.value = listOf()
                            popUpTo(0)
                        }
                    }
                ) {

                    Image(
                        modifier = Modifier
                            .size(24.dp)
                            .align(Alignment.CenterVertically),
                        painter = painterResource(id = R.drawable.arrow_back),
                        contentDescription = stringResource(id = R.string.arrow)
                    )

                    Text(
                        modifier = Modifier,
                        text = stringResource(id = R.string.to_main),
                        color = textColorSecondary,
                        fontFamily = FontFamily(Font(R.font.gilroy_medium)),
                        fontSize = 13.sp
                    )

                }
            }
        }

        item(span = { GridItemSpan(2) }) {
            Column(
                modifier = Modifier
                    .fillMaxWidth(),
                verticalArrangement = Arrangement.spacedBy(8.dp, Alignment.Top)
            ) {

                Card(
                    shape = RoundedCornerShape(8.dp),
                    colors = CardDefaults.cardColors(containerColor = onPrimaryColor)
                ) {
                    Text(
                        modifier = Modifier.padding(12.dp),
                        text = currentSeasonAndEpisode.value
                            ?: stringResource(id = R.string.no_data),
                        fontFamily = FontFamily(Font(R.font.gilroy_medium)),
                        fontSize = 13.sp,
                        color = surfaceColor
                    )
                }

                Text(
                    text = currentName.value ?: stringResource(id = R.string.no_data),
                    color = textColorPrimary,
                    fontSize = 18.sp,
                    fontFamily = FontFamily(Font(R.font.gilroy_medium))
                )
                Text(
                    text = currentDate.value,
                    color = textColorPrimary,
                    fontSize = 12.sp,
                    fontFamily = FontFamily(Font(R.font.gilroy))
                )


            }
        }


        characterList.value.forEach {
            item {
                Card(
                    shape = RoundedCornerShape(12.dp),
                    colors = CardDefaults.cardColors(containerColor = backColorSecondary),
                ) {
                    Column(

                    ) {
                        AsyncImage(
                            model = ImageRequest.Builder(LocalContext.current)
                                .data(
                                    it.image
                                )
                                .crossfade(true)
                                .build(),
                            placeholder = painterResource(R.drawable.baseline_portrait_24),
                            error = painterResource(id = R.drawable.baseline_portrait_24),
                            contentDescription = it.name ?: stringResource(id = R.string.no_data),
                            contentScale = ContentScale.Crop,
                            modifier = Modifier
                                .fillMaxWidth()
                                .clip(RoundedCornerShape(12.dp)),
                        )

                        Text(
                            modifier = Modifier.padding(8.dp),
                            text = it.name ?: stringResource(id = R.string.no_data),
                            color = textColorPrimary
                        )
                    }
                }
            }
        }

    }

}



"""
    }
    
    static func dependencies(_ mainData: MainData) -> ANDData {
        return ANDData(mainFragmentData: ANDMainFragment(imports: "", content: ""), mainActivityData: ANDMainActivity(imports: "", extraFunc: "", content: ""), themesData: ANDThemesData(isDefault: true, content: ""), stringsData: ANDStringsData(additional: """
    <string name="logo_desc">лого</string>
    <string name="arrow">стрелочка</string>
    <string name="to_main">на главную</string>
    <string name="no_data">нет данных</string>
    <string name="def_url">https://rickandmortyapi.com/api/character/avatar/1.jpeg</string>
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
    
    implementation Dependencies.coil
    implementation Dependencies.retrofit
    implementation Dependencies.converter_gson
    implementation Dependencies.coroutines_core
    implementation Dependencies.gson
    implementation Dependencies.navigation_compose
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

    // Coil
    const val coil = "io.coil-kt:coil-compose:2.3.0"

    // Coroutine
    const val coroutines_core = "org.jetbrains.kotlinx:kotlinx-coroutines-core:1.6.4"

    // Networking
    const val gson = "com.google.code.gson:gson:2.8.9"

    // Navigation
    const val navigation_compose = "androidx.navigation:navigation-compose:2.7.0-beta01"


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
    
    static func cmfHandler(_ packageName: String) -> ANDMainFragmentCMF {
        return ANDMainFragmentCMF(content: """
package \(packageName).presentation.fragments.main_fragment

import androidx.compose.runtime.Composable
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.material3.Surface
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.ComposeView
import androidx.fragment.app.Fragment
import androidx.fragment.app.activityViewModels
import androidx.fragment.app.viewModels
import \(packageName).repository.state.StateViewModel
import dagger.hilt.android.AndroidEntryPoint


@AndroidEntryPoint
class MainFragment : Fragment() {

    private val viewModel by viewModels<MainViewModel>()
    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View {
        return ComposeView(requireContext()).apply {
            setContent {
                Surface(modifier = Modifier.fillMaxSize(), color = backColorPrimary) {
                    MainScreen(viewModel)
                }
            }
        }
    }
}

@Composable
fun MainScreen(viewModel: MainViewModel) {
    viewModel.getData()
    Navigation(viewModel)
}
""", fileName: "MainFragment.kt")
    }
}
