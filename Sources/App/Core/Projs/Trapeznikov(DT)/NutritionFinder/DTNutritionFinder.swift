//
//  File.swift
//  
//
//  Created by admin on 9/6/23.
//

import Foundation

struct DTNutritionFinder: SFFileProviderProtocol {
    static func mainFragmentCMF(_ mainData: MainData) -> ANDMainFragmentCMF {
        ANDMainFragmentCMF(content: """
package \(mainData.packageName).presentation.fragments.main_fragment

import android.app.Application
import android.content.Context
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.compose.foundation.Image
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.text.KeyboardActions
import androidx.compose.foundation.text.KeyboardOptions
import androidx.compose.material3.Card
import androidx.compose.material3.CardDefaults
import androidx.compose.material3.CircularProgressIndicator
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.OutlinedTextField
import androidx.compose.material3.OutlinedTextFieldDefaults
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.saveable.rememberSaveable
import androidx.compose.ui.Alignment
import androidx.compose.ui.ExperimentalComposeUiApi
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.ColorFilter
import androidx.compose.ui.platform.ComposeView
import androidx.compose.ui.platform.LocalFocusManager
import androidx.compose.ui.platform.LocalSoftwareKeyboardController
import androidx.compose.ui.res.dimensionResource
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.input.ImeAction
import androidx.compose.ui.text.input.KeyboardType
import androidx.compose.ui.unit.dp
import androidx.fragment.app.Fragment
import androidx.hilt.navigation.compose.hiltViewModel
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import \(mainData.packageName).R
import com.google.gson.annotations.SerializedName
import dagger.Module
import dagger.Provides
import dagger.hilt.InstallIn
import dagger.hilt.android.AndroidEntryPoint
import dagger.hilt.android.lifecycle.HiltViewModel
import dagger.hilt.components.SingletonComponent
import kotlinx.coroutines.FlowPreview
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.flow.debounce
import kotlinx.coroutines.flow.distinctUntilChanged
import kotlinx.coroutines.flow.filter
import kotlinx.coroutines.flow.flow
import kotlinx.coroutines.flow.map
import kotlinx.coroutines.launch
import okhttp3.Interceptor
import okhttp3.OkHttpClient
import okhttp3.Response
import retrofit2.HttpException
import retrofit2.Retrofit
import retrofit2.converter.gson.GsonConverterFactory
import retrofit2.http.GET
import retrofit2.http.Query
import java.io.IOException
import javax.inject.Inject
import javax.inject.Singleton

@AndroidEntryPoint
class MainFragment : Fragment() {

    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View {
        return ComposeView(requireContext()).apply {
            setContent {
                MainScreen()
            }
        }
    }
}

@Composable
fun MainScreen() {
    MaterialTheme {
        NutritionScreen()
    }
}

sealed class Resource<T> {
    class Success<T>(val data: T) : Resource<T>()
    class Error<T>(val message: String) : Resource<T>()
    class Loading<T> : Resource<T>()
}

fun NutritionDto.toDomain(): Nutrition {
    return Nutrition(
        name = this.name.replaceFirstChar { it.uppercase() },
        servingSizeG = this.servingSizeG,
        calories = this.calories,
        carbohydratesTotalG = this.carbohydratesTotalG,
        fatTotalG = this.fatTotalG,
        proteinG = this.proteinG
    )
}

data class NutritionDto(
    @SerializedName("calories")
    val calories: Double,
    @SerializedName("carbohydrates_total_g")
    val carbohydratesTotalG: Double,
    @SerializedName("cholesterol_mg")
    val cholesterolMg: Double,
    @SerializedName("fat_saturated_g")
    val fatSaturatedG: Double,
    @SerializedName("fat_total_g")
    val fatTotalG: Double,
    @SerializedName("fiber_g")
    val fiberG: Double,
    @SerializedName("name")
    val name: String,
    @SerializedName("potassium_mg")
    val potassiumMg: Double,
    @SerializedName("protein_g")
    val proteinG: Double,
    @SerializedName("serving_size_g")
    val servingSizeG: Double,
    @SerializedName("sodium_mg")
    val sodiumMg: Double,
    @SerializedName("sugar_g")
    val sugarG: Double
)

class AuthInterceptor : Interceptor {

    override fun intercept(chain: Interceptor.Chain): Response {
        val request = chain.request().newBuilder()
            .addHeader("X-Api-Key", "zOevlY5qtngRacRnWBdJSA==8YDMqZkhD4IS9sxC")
            .build()
        return chain.proceed(request)
    }
}

interface NutritionService {

    @GET("v1/nutrition")
    suspend fun getNutrition(@Query("query") text: String): retrofit2.Response<List<NutritionDto>>
}

class NutritionRepositoryImpl(
    private val nutritionService: NutritionService,
    private val context: Context
) : NutritionRepository {

    override suspend fun getNutritionFromText(text: String): Flow<Resource<List<Nutrition>>> =
        flow {
            emit(Resource.Loading())
            try {
                val response = nutritionService.getNutrition(text)
                val body = response.body()
                if (response.isSuccessful && body != null) {
                    if (body.isNotEmpty()) {
                        emit(Resource.Success(body.map { it.toDomain() }))
                    } else {
                        emit(Resource.Error(context.getString(R.string.unable_recognize)))
                    }
                } else {
                    emit(Resource.Error(context.getString(R.string.unexpected_error)))
                }
            } catch (e: Throwable) {
                when (e) {
                    is HttpException -> emit(Resource.Error(context.getString(R.string.server_error)))
                    is IOException -> emit(Resource.Error(context.getString(R.string.connection_lost)))
                    else -> emit(Resource.Error(context.getString(R.string.unexpected_error)))
                }
                e.printStackTrace()
            }
        }
}

@Module
@InstallIn(SingletonComponent::class)
class DataModule {

    @Singleton
    @Provides
    fun provideNutritionService(): NutritionService {
        val httpClient = OkHttpClient.Builder()
            .addInterceptor(AuthInterceptor())
            .build()

        val retrofit = Retrofit.Builder()
            .client(httpClient)
            .baseUrl("https://api.api-ninjas.com/")
            .addConverterFactory(GsonConverterFactory.create())
            .build()

        return retrofit.create(NutritionService::class.java)
    }

    @Singleton
    @Provides
    fun provideNutritionRepository(
        nutritionService: NutritionService,
        app: Application
    ): NutritionRepository {
        return NutritionRepositoryImpl(nutritionService, app)
    }
}

data class Nutrition(
    val name: String,
    val servingSizeG: Double,
    val calories: Double,
    val carbohydratesTotalG: Double,
    val fatTotalG: Double,
    val proteinG: Double,
)

interface NutritionRepository {

    suspend fun getNutritionFromText(text: String): Flow<Resource<List<Nutrition>>>
}

@HiltViewModel
class NutritionViewModel @Inject constructor(
    private val nutritionRepository: NutritionRepository
) : ViewModel() {

    private val _state = MutableStateFlow(NutritionState())
    val state = _state.asStateFlow()

    private val userInput = MutableStateFlow("")

    init {
        observeUserInput()
    }

    fun onUserInputChanged(input: String) {
        userInput.value = input
    }

    @OptIn(FlowPreview::class)
    private fun observeUserInput() {
        viewModelScope.launch {
            userInput
                .filter { it.isNotBlank() }
                .map { it.trim() }
                .debounce(2000)
                .distinctUntilChanged()
                .collect {
                    getNutritionByText(it)
                }
        }
    }

    private suspend fun getNutritionByText(text: String) {
        nutritionRepository.getNutritionFromText(text).collect {
            when (it) {
                is Resource.Success -> _state.value = NutritionState(nutrition = it.data)
                is Resource.Loading -> _state.value = NutritionState(isLoading = true)
                is Resource.Error -> _state.value = NutritionState(error = it.message)
            }
        }
    }
}

data class NutritionState(
    val nutrition: List<Nutrition> = emptyList(),
    val isLoading: Boolean = false,
    val error: String = ""
)

val backColorPrimary = Color(0xFF\(mainData.uiSettings.backColorPrimary ?? "FFFFFF"))
val textColorPrimary = Color(0xFF\(mainData.uiSettings.textColorPrimary ?? "FFFFFF"))
val buttonColorPrimary = Color(0xFF\(mainData.uiSettings.buttonColorPrimary ?? "FFFFFF"))
val surfaceColor = Color(0xFF\(mainData.uiSettings.surfaceColor ?? "FFFFFF"))

@Composable
fun NutritionItem(nutrition: Nutrition, modifier: Modifier = Modifier) {
    Card(
        modifier = modifier,
        colors = CardDefaults.cardColors(containerColor = surfaceColor),
        elevation = CardDefaults.cardElevation(dimensionResource(id = R.dimen.card_elevation))
    ) {
        Column(
            modifier = Modifier
                .padding(dimensionResource(id = R.dimen.primary_padding))
                .background(color = surfaceColor)
                .fillMaxWidth()
        ) {
            Text(
                text = nutrition.name,
                style = MaterialTheme.typography.headlineMedium,
                color = textColorPrimary
            )
            Spacer(modifier = Modifier.height(dimensionResource(id = R.dimen.primary_margin)))
            RowServingSize(
                servingSize = nutrition.servingSizeG.toString(),
                verticalAlignment = Alignment.Bottom
            )
            Spacer(modifier = Modifier.height(dimensionResource(id = R.dimen.primary_margin)))
            RowCalories(
                calories = nutrition.calories.toString(),
                verticalAlignment = Alignment.Bottom
            )
            Spacer(modifier = Modifier.height(dimensionResource(id = R.dimen.primary_margin)))
            RowNutrition(
                carbohydrates = nutrition.carbohydratesTotalG.toString(),
                fats = nutrition.fatTotalG.toString(),
                protein = nutrition.proteinG.toString(),
                verticalAlignment = Alignment.Bottom
            )
        }
    }
}

@Composable
fun RowServingSize(servingSize: String, verticalAlignment: Alignment.Vertical) {
    Row(
        verticalAlignment = verticalAlignment,
        modifier = Modifier.background(color = surfaceColor)
    ) {
        Text(
            text = stringResource(R.string.serving_size),
            style = MaterialTheme.typography.titleLarge,
            color = textColorPrimary
        )
        Text(
            text = String.format(
                stringResource(id = R.string.text_grams),
                servingSize
            ),
            style = MaterialTheme.typography.titleLarge,
            color = textColorPrimary
        )
    }
}

@Composable
fun RowCalories(calories: String, verticalAlignment: Alignment.Vertical) {
    Row(verticalAlignment = verticalAlignment) {
        Text(
            text = stringResource(R.string.calories),
            style = MaterialTheme.typography.titleLarge,
            color = textColorPrimary
        )
        Text(
            text = calories,
            style = MaterialTheme.typography.titleLarge,
            color = textColorPrimary
        )
    }
}

@Composable
fun RowNutrition(
    carbohydrates: String,
    fats: String,
    protein: String,
    verticalAlignment: Alignment.Vertical
) {
    Row(modifier = Modifier.background(color = surfaceColor)) {
        Spacer(modifier = Modifier.width(dimensionResource(id = R.dimen.primary_margin)))
        Column(modifier = Modifier.background(color = surfaceColor)) {
            RowTitleGramsValue(
                title = stringResource(R.string.total_carbohydrates),
                value = carbohydrates,
                verticalAlignment = verticalAlignment
            )
            Spacer(modifier = Modifier.height(dimensionResource(id = R.dimen.primary_margin)))
            RowTitleGramsValue(
                title = stringResource(R.string.total_fats),
                value = fats,
                verticalAlignment = verticalAlignment
            )
            Spacer(modifier = Modifier.height(dimensionResource(id = R.dimen.primary_margin)))
            RowTitleGramsValue(
                title = stringResource(R.string.protein),
                value = protein,
                verticalAlignment = verticalAlignment
            )
        }
    }
}

@Composable
fun RowTitleGramsValue(title: String, value: String, verticalAlignment: Alignment.Vertical) {
    Row(
        verticalAlignment = verticalAlignment,
        modifier = Modifier.background(color = surfaceColor)
    ) {
        Text(
            text = title,
            style = MaterialTheme.typography.titleMedium,
            color = textColorPrimary
        )
        Text(
            text = String.format(
                stringResource(id = R.string.text_grams),
                value
            ),
            style = MaterialTheme.typography.bodyLarge,
            color = textColorPrimary
        )
    }
}

@Composable
fun NutritionScreen(viewModel: NutritionViewModel = hiltViewModel()) {
    val state = viewModel.state.collectAsState()
    Scaffold(modifier = Modifier
        .background(backColorPrimary)
        .fillMaxSize()) { paddingValues ->
        Box(
            modifier = Modifier
                .background(color = backColorPrimary)
                .fillMaxSize()
                .padding(paddingValues)
                .padding(
                    start = dimensionResource(id = R.dimen.primary_padding),
                    end = dimensionResource(id = R.dimen.primary_padding)
                )
        ) {
            LazyColumn(
                verticalArrangement = Arrangement.spacedBy(dimensionResource(id = R.dimen.primary_margin)),
                contentPadding = PaddingValues(
                    top = dimensionResource(id = R.dimen.primary_padding),
                    bottom = dimensionResource(id = R.dimen.primary_padding)
                ),
                modifier = Modifier.background(color = backColorPrimary)
            ) {
                item {
                    Header(modifier = Modifier.fillMaxWidth()) {
                        viewModel.onUserInputChanged(it)
                    }
                }
                items(state.value.nutrition) { nutrition ->
                    NutritionItem(nutrition = nutrition)
                }
            }
            when {
                state.value.isLoading -> {
                    CircularProgressIndicator(
                        modifier = Modifier.align(Alignment.Center),
                        color = buttonColorPrimary
                    )
                }

                state.value.error.isNotEmpty() -> {
                    Text(
                        text = state.value.error,
                        modifier = Modifier.align(Alignment.Center),
                        color = textColorPrimary
                    )
                }

                state.value.nutrition.isEmpty() -> {
                    Image(
                        painter = painterResource(id = R.drawable.ic_dining),
                        contentDescription = stringResource(R.string.dinning),
                        modifier = Modifier
                            .align(Alignment.Center)
                            .size(100.dp),
                        colorFilter = ColorFilter.tint(surfaceColor)
                    )
                }
            }
        }
    }
}

@OptIn(ExperimentalComposeUiApi::class)
@Composable
fun Header(modifier: Modifier = Modifier, onUserInputChange: (String) -> Unit) {
    val keyboardController = LocalSoftwareKeyboardController.current
    val focusManager = LocalFocusManager.current
    val textFieldState = rememberSaveable { mutableStateOf("") }
    Column(
        modifier = modifier.background(color = backColorPrimary),
        horizontalAlignment = Alignment.CenterHorizontally
    ) {
        Text(
            text = stringResource(R.string.nutrition_finder),
            style = MaterialTheme.typography.titleLarge,
            modifier = Modifier.align(Alignment.Start),
            color = textColorPrimary
        )
        Spacer(modifier = Modifier.height(dimensionResource(id = R.dimen.primary_margin)))
        OutlinedTextField(
            modifier = Modifier.fillMaxWidth(),
            value = textFieldState.value,
            placeholder = { Text(text = stringResource(R.string.input_a_text)) },
            singleLine = true,
            colors = OutlinedTextFieldDefaults.colors(
                focusedTextColor = textColorPrimary,
                unfocusedTextColor = textColorPrimary,
                cursorColor = buttonColorPrimary,
                focusedBorderColor = buttonColorPrimary,
                unfocusedBorderColor = textColorPrimary,
                focusedContainerColor = backColorPrimary,
                unfocusedContainerColor = backColorPrimary
            ),
            keyboardOptions = KeyboardOptions.Default.copy(
                keyboardType = KeyboardType.Text,
                imeAction = ImeAction.Done
            ),
            keyboardActions = KeyboardActions(onDone = {
                keyboardController?.hide()
                focusManager.clearFocus(true)
            }),
            onValueChange = {
                textFieldState.value = it
                if (it.isNotBlank()) onUserInputChange(it)
            }
        )
    }
}
""", fileName: "MainFragment.kt")
    }
    
    static func dependencies(_ mainData: MainData) -> ANDData {
        ANDData(
            mainFragmentData: ANDMainFragment(imports: "", content: ""),
            mainActivityData: ANDMainActivity(imports: "", extraFunc: "", content: ""),
            themesData: ANDThemesData(isDefault: true, content: ""),
            stringsData: ANDStringsData(additional: """
    <string name="connection_lost">Connection lost</string>
    <string name="server_error">Server error</string>
    <string name="unexpected_error">Unexpected error</string>
    <string name="text_grams">%1$sg</string>
    <string name="total_carbohydrates">"• Total Carbohydrates "</string>
    <string name="total_fats">"• Total Fats "</string>
    <string name="protein">"• Protein "</string>
    <string name="calories">"Calories "</string>
    <string name="nutrition_finder">\(mainData.appName)</string>
    <string name="input_a_text">Input a text with nutrition information</string>
    <string name="unable_recognize">Unable to recognize nutrition from text</string>
    <string name="serving_size">"Serving size "</string>
    <string name="dinning">dinning</string>
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
apply plugin: 'dagger.hilt.android.plugin'
apply plugin: 'kotlin-kapt'

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
    implementation Dependencies.retrofit
    implementation Dependencies.converter_gson
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
    const val gradle = "8.1.0"
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
    
    
    
    
    
    static var fileName: String = ""
    
    static func fileContent(packageName: String, uiSettings: UISettings) -> String {
        return ""
    }
    
    
}
