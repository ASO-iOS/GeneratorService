//
//  File.swift
//  
//
//  Created by admin on 9/8/23.
//

import Foundation

struct DTGastronomyGuru: SFFileProviderProtocol {
    
    static func mainFragmentCMF(_ mainData: MainData) -> ANDMainFragmentCMF {
        ANDMainFragmentCMF(content: """
package \(mainData.packageName).presentation.fragments.main_fragment

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
import androidx.compose.material.Scaffold
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.DinnerDining
import androidx.compose.material3.Card
import androidx.compose.material3.CardDefaults
import androidx.compose.material3.CircularProgressIndicator
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.OutlinedTextField
import androidx.compose.material3.OutlinedTextFieldDefaults
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.collectAsState
import androidx.compose.ui.Alignment
import androidx.compose.ui.ExperimentalComposeUiApi
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.ColorFilter
import androidx.compose.ui.platform.ComposeView
import androidx.compose.ui.platform.LocalFocusManager
import androidx.compose.ui.platform.LocalSoftwareKeyboardController
import androidx.compose.ui.res.dimensionResource
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.input.ImeAction
import androidx.compose.ui.text.input.KeyboardType
import androidx.compose.ui.text.style.TextAlign
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
import kotlinx.coroutines.CoroutineDispatcher
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.FlowPreview
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.flow.debounce
import kotlinx.coroutines.flow.distinctUntilChanged
import kotlinx.coroutines.flow.flow
import kotlinx.coroutines.flow.flowOn
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
import java.net.ConnectException
import java.net.SocketTimeoutException
import java.net.UnknownHostException
import javax.inject.Inject
import javax.inject.Qualifier
import javax.inject.Singleton
import javax.net.ssl.SSLHandshakeException

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
        RecipeScreen()
    }
}

fun Throwable.toResponseError(): ResponseError {
    return when (this) {
        is ConnectException -> ResponseError.CONNECTION
        is UnknownHostException -> ResponseError.UNKNOWN_HOST
        is SocketTimeoutException -> ResponseError.SOCKET_TIMEOUT
        is SSLHandshakeException -> ResponseError.SSL
        else -> ResponseError.UNEXPECTED
    }
}

fun Int.toResponseError(): ResponseError {
    return when (this) {
        400 -> ResponseError.BAD_REQUEST
        401 -> ResponseError.UNAUTHORIZED
        403 -> ResponseError.FORBIDDEN
        404 -> ResponseError.NOT_FOUND
        in 500..599 -> ResponseError.INTERNAL_SERVER
        else -> ResponseError.UNEXPECTED
    }
}

sealed class Resource<T> {
    class Success<T>(val data: T) : Resource<T>()
    class Error<T>(val error: ResponseError) : Resource<T>()
    class Loading<T> : Resource<T>()
}

enum class ResponseError {
    BAD_REQUEST,
    UNAUTHORIZED,
    FORBIDDEN,
    NOT_FOUND,
    INTERNAL_SERVER,
    CONNECTION,
    UNKNOWN_HOST,
    SOCKET_TIMEOUT,
    SSL,
    UNEXPECTED,
    EMPTY_BODY
}

fun RecipeDto.toDomain(): Recipe {
    return Recipe(
        ingredients = this.ingredients.split("; ", "|"),
        instructions = this.instructions,
        servings = this.servings,
        title = this.title
    )
}

data class RecipeDto(
    @SerializedName("ingredients")
    val ingredients: String,
    @SerializedName("instructions")
    val instructions: String,
    @SerializedName("servings")
    val servings: String,
    @SerializedName("title")
    val title: String
)

class AuthInterceptor(private val apiKey: String) : Interceptor {

    override fun intercept(chain: Interceptor.Chain): Response {
        val request = chain.request().newBuilder()
            .addHeader(API_KEY_HEADER, apiKey)
            .build()

        return chain.proceed(request)
    }

    private companion object {

        private const val API_KEY_HEADER = "X-Api-Key"
    }
}

interface RecipeService {

    @GET("v1/recipe")
    suspend fun getRecipe(@Query("query") query: String): retrofit2.Response<List<RecipeDto>>
}

class RecipeRepositoryImpl(
    private val recipeService: RecipeService,
    @IoDispatcher private val ioDispatcher: CoroutineDispatcher
) : RecipeRepository {

    override suspend fun getRecipe(query: String): Flow<Resource<List<Recipe>>> = flow {
        emit(Resource.Loading())
        try {
            val response = recipeService.getRecipe(query)
            val body = response.body()
            if (response.isSuccessful && body != null) {
                if (body.isNotEmpty()) {
                    emit(Resource.Success(body.map { it.toDomain() }))
                } else {
                    emit(Resource.Error(ResponseError.EMPTY_BODY))
                }
            } else {
                emit(Resource.Error(response.code().toResponseError()))
            }
        } catch (e: Throwable) {
            when (e) {
                is IOException -> emit(Resource.Error(e.toResponseError()))
                is HttpException -> emit(Resource.Error(e.code().toResponseError()))
                else -> emit(Resource.Error(e.toResponseError()))
            }
            e.printStackTrace()
        }
    }.flowOn(ioDispatcher)
}

@Retention(AnnotationRetention.BINARY)
@Qualifier
annotation class DefaultDispatcher

@Retention(AnnotationRetention.BINARY)
@Qualifier
annotation class IoDispatcher

@Retention(AnnotationRetention.BINARY)
@Qualifier
annotation class MainDispatcher

@Module
@InstallIn(SingletonComponent::class)
class DataModule {

    @Singleton
    @Provides
    fun provideRecipeService(): RecipeService {
        val httpClient = OkHttpClient.Builder()
            .addInterceptor(AuthInterceptor("zOevlY5qtngRacRnWBdJSA==8YDMqZkhD4IS9sxC"))
            .build()

        val retrofit = Retrofit.Builder()
            .client(httpClient)
            .baseUrl("https://api.api-ninjas.com/")
            .addConverterFactory(GsonConverterFactory.create())
            .build()

        return retrofit.create(RecipeService::class.java)
    }

    @Singleton
    @Provides
    fun provideRecipeRepository(
        recipeService: RecipeService,
        @IoDispatcher dispatcher: CoroutineDispatcher
    ): RecipeRepository {
        return RecipeRepositoryImpl(recipeService, dispatcher)
    }
}

@Module
@InstallIn(SingletonComponent::class)
class DispatchersModule {

    @DefaultDispatcher
    @Provides
    fun providesDefaultDispatcher(): CoroutineDispatcher = Dispatchers.Default

    @IoDispatcher
    @Provides
    fun providesIoDispatcher(): CoroutineDispatcher = Dispatchers.IO

    @MainDispatcher
    @Provides
    fun providesMainDispatcher(): CoroutineDispatcher = Dispatchers.Main
}

data class Recipe(
    val ingredients: List<String>,
    val instructions: String,
    val servings: String,
    val title: String
)

interface RecipeRepository {

    suspend fun getRecipe(query: String): Flow<Resource<List<Recipe>>>
}

sealed class RecipeEvent {
    data class OnRecipeInputChange(val query: String) : RecipeEvent()
}

data class RecipeState(
    val recipeInput: String = "",
    val recipes: List<Recipe> = emptyList(),
    val isLoading: Boolean = false,
    val error: ResponseError? = null
)

@HiltViewModel
class RecipeViewModel @Inject constructor(
    private val recipeRepository: RecipeRepository
) : ViewModel() {

    private val _state = MutableStateFlow(RecipeState())
    val state = _state.asStateFlow()

    private val recipeInputState = MutableStateFlow("")

    init {
        observeUserInput()
    }

    @OptIn(FlowPreview::class)
    private fun observeUserInput() {
        viewModelScope.launch {
            recipeInputState
                .map { it.trim() }
                .debounce(1500)
                .distinctUntilChanged()
                .collect {
                    if (it.isNotEmpty()) getRecipes(it)
                }
        }
    }

    fun onEvent(recipeEvent: RecipeEvent) {
        when (recipeEvent) {
            is RecipeEvent.OnRecipeInputChange -> {
                _state.value = _state.value.copy(recipeInput = recipeEvent.query)
                recipeInputState.value = recipeEvent.query
            }
        }
    }

    private suspend fun getRecipes(query: String) {
        recipeRepository.getRecipe(query).collect {
            when (it) {
                is Resource.Loading -> _state.value =
                    _state.value.copy(isLoading = true, recipes = emptyList())

                is Resource.Success -> _state.value =
                    _state.value.copy(isLoading = false, error = null, recipes = it.data)

                is Resource.Error -> _state.value =
                    _state.value.copy(isLoading = false, recipes = emptyList(), error = it.error)
            }
        }
    }
}

val backColorPrimary = Color(0xFF\(mainData.uiSettings.backColorPrimary ?? "FFFFFF"))
val textColorPrimary = Color(0xFF\(mainData.uiSettings.textColorPrimary ?? "FFFFFF"))
val buttonColorPrimary = Color(0xFF\(mainData.uiSettings.buttonColorPrimary ?? "FFFFFF"))
val surfaceColor = Color(0xFF\(mainData.uiSettings.surfaceColor ?? "FFFFFF"))

@Composable
fun RecipeScreen(viewModel: RecipeViewModel = hiltViewModel()) {
    val state = viewModel.state.collectAsState()
    Scaffold(
        modifier = Modifier
            .fillMaxSize()
            .background(color = backColorPrimary),
        topBar = {
            RecipeTopBar(
                modifier = Modifier
                    .fillMaxWidth()
                    .background(color = backColorPrimary)
            )
        }
    ) { paddingValues ->
        Box(
            modifier = Modifier
                .fillMaxSize()
                .background(color = backColorPrimary)
                .padding(paddingValues)
        ) {
            RecipeList(
                modifier = Modifier.background(color = backColorPrimary),
                recipes = state.value.recipes,
                recipeInput = state.value.recipeInput,
                onRecipeInputChange = { viewModel.onEvent(RecipeEvent.OnRecipeInputChange(it)) }
            )
            when {
                state.value.isLoading -> CircularProgressIndicator(
                    modifier = Modifier.align(Alignment.Center),
                    color = buttonColorPrimary
                )

                state.value.error != null -> ErrorText(
                    modifier = Modifier.align(Alignment.Center),
                    error = state.value.error!!
                )

                state.value.recipes.isEmpty() -> RecipeBackImage(
                    modifier = Modifier
                        .align(Alignment.Center)
                        .size(dimensionResource(id = R.dimen.back_image_size))
                )
            }

        }
    }
}

@Composable
fun RecipeTopBar(modifier: Modifier = Modifier) {
    Surface(
        modifier = Modifier.background(color = backColorPrimary),
        shadowElevation = dimensionResource(id = R.dimen.top_bar_elevation)
    ) {
        Text(
            modifier = modifier.padding(
                start = dimensionResource(id = R.dimen.main_padding),
                top = dimensionResource(id = R.dimen.main_padding),
                bottom = dimensionResource(id = R.dimen.main_padding),
            ),
            text = stringResource(id = R.string.app_name),
            style = MaterialTheme.typography.titleLarge,
            color = textColorPrimary
        )
    }
}

@Composable
fun RecipeList(
    modifier: Modifier = Modifier,
    recipes: List<Recipe>,
    recipeInput: String,
    onRecipeInputChange: (String) -> Unit
) {
    LazyColumn(
        modifier = modifier,
        verticalArrangement = Arrangement.spacedBy(dimensionResource(id = R.dimen.main_padding)),
        contentPadding = PaddingValues(
            top = dimensionResource(id = R.dimen.main_padding),
            bottom = dimensionResource(id = R.dimen.main_padding)
        )
    ) {
        item {
            RecipeOutlinedTextField(
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(
                        start = dimensionResource(id = R.dimen.main_padding),
                        end = dimensionResource(id = R.dimen.main_padding)
                    ),
                value = recipeInput,
                onValueChange = { onRecipeInputChange(it) }
            )
        }
        items(recipes) { recipe ->
            RecipeItem(
                modifier = Modifier.padding(
                    start = dimensionResource(id = R.dimen.main_padding),
                    end = dimensionResource(id = R.dimen.main_padding)
                ),
                item = recipe
            )
        }
    }
}

@Composable
fun RecipeItem(modifier: Modifier = Modifier, item: Recipe) {
    Card(
        modifier = modifier,
        elevation = CardDefaults.cardElevation(dimensionResource(id = R.dimen.card_elevation)),
        colors = CardDefaults.cardColors(containerColor = surfaceColor)
    ) {
        Column(
            modifier = Modifier
                .padding(dimensionResource(id = R.dimen.main_padding))
                .background(color = surfaceColor)
        ) {
            Text(
                text = item.title,
                style = MaterialTheme.typography.titleLarge,
                color = textColorPrimary
            )
            Spacer(modifier = Modifier.height(dimensionResource(id = R.dimen.spacer_size)))
            Text(
                text = item.servings,
                style = MaterialTheme.typography.titleMedium,
                color = textColorPrimary
            )
            Spacer(modifier = Modifier.height(dimensionResource(id = R.dimen.spacer_size)))
            Row(modifier = Modifier.background(surfaceColor)) {
                Spacer(modifier = Modifier.width(dimensionResource(id = R.dimen.spacer_size)))
                Column(modifier = Modifier.background(surfaceColor)) {
                    item.ingredients.forEachIndexed { index, ingredient ->
                        Text(
                            text = stringResource(R.string.bulleted_string, ingredient),
                            style = MaterialTheme.typography.bodyLarge,
                            color = textColorPrimary
                        )
                        if (item.ingredients.lastIndex != index) {
                            Spacer(modifier = Modifier.height(dimensionResource(id = R.dimen.bulleted_string_spacer)))
                        }
                    }
                }
            }
            Spacer(modifier = Modifier.height(dimensionResource(id = R.dimen.spacer_size)))
            Text(
                text = item.instructions,
                style = MaterialTheme.typography.bodyLarge,
                color = textColorPrimary
            )
        }
    }
}

@OptIn(ExperimentalComposeUiApi::class)
@Composable
fun RecipeOutlinedTextField(
    modifier: Modifier = Modifier,
    value: String,
    onValueChange: (String) -> Unit
) {
    val keyboardController = LocalSoftwareKeyboardController.current
    val focusManager = LocalFocusManager.current
    OutlinedTextField(
        modifier = modifier,
        value = value,
        onValueChange = {
            onValueChange(it)
        },
        placeholder = { Text(text = stringResource(R.string.input_a_recipe_name)) },
        singleLine = true,
        keyboardOptions = KeyboardOptions.Default.copy(
            keyboardType = KeyboardType.Text,
            imeAction = ImeAction.Done
        ),
        keyboardActions = KeyboardActions(onDone = {
            keyboardController?.hide()
            focusManager.clearFocus(true)
        }),
        colors = OutlinedTextFieldDefaults.colors(
            focusedTextColor = textColorPrimary,
            unfocusedTextColor = textColorPrimary,
            cursorColor = buttonColorPrimary,
            focusedBorderColor = buttonColorPrimary,
            unfocusedBorderColor = textColorPrimary,
            focusedContainerColor = backColorPrimary,
            unfocusedContainerColor = backColorPrimary
        )
    )
}

@Composable
fun RecipeBackImage(modifier: Modifier = Modifier) {
    Image(
        modifier = modifier,
        imageVector = Icons.Default.DinnerDining,
        contentDescription = null,
        colorFilter = ColorFilter.tint(color = surfaceColor)
    )
}

@Composable
fun ErrorText(modifier: Modifier = Modifier, error: ResponseError) {
    val text = when (error) {
        ResponseError.BAD_REQUEST -> stringResource(id = R.string.http_bad_request)
        ResponseError.UNAUTHORIZED -> stringResource(id = R.string.http_unauthorized)
        ResponseError.FORBIDDEN -> stringResource(id = R.string.http_forbidden)
        ResponseError.NOT_FOUND -> stringResource(id = R.string.http_not_found)
        ResponseError.INTERNAL_SERVER -> stringResource(id = R.string.http_internal_server_error)
        ResponseError.CONNECTION -> stringResource(id = R.string.connection_exception)
        ResponseError.UNKNOWN_HOST -> stringResource(id = R.string.host_exception)
        ResponseError.SOCKET_TIMEOUT -> stringResource(id = R.string.socket_exception)
        ResponseError.SSL -> stringResource(id = R.string.ssl_exception)
        ResponseError.UNEXPECTED -> stringResource(id = R.string.unexpected_error)
        ResponseError.EMPTY_BODY -> stringResource(id = R.string.empty_body)
    }
    Text(modifier = modifier, text = text, textAlign = TextAlign.Center, color = textColorPrimary)
}
""", fileName: "MainFragment.kt")
    }
    
    static func dependencies(_ mainData: MainData) -> ANDData {
        ANDData(mainFragmentData: ANDMainFragment(imports: "", content: ""),
                mainActivityData: ANDMainActivity(imports: "", extraFunc: "", content: ""),
                themesData: ANDThemesData(isDefault: true, content: ""),
                stringsData: ANDStringsData(additional: """
    <string name="input_a_recipe_name">Input a recipe name</string>
    <string name="bulleted_string">• %1$s</string>
    <string name="unexpected_error">Unexpected error</string>
    <string name="connection_exception">Connection lost</string>
    <string name="socket_exception">We\\'re sorry, but it seems that the connection is taking longer than expected to establish</string>
    <string name="host_exception">We\\'re having trouble reaching the server at the moment</string>
    <string name="ssl_exception">We\\'re having trouble connecting securely to the server right now</string>
    <string name="http_bad_request">400 Bad Request</string>
    <string name="http_unauthorized">401 Unauthorized</string>
    <string name="http_forbidden">403 Forbidden</string>
    <string name="http_not_found">404 Not Found</string>
    <string name="http_internal_server_error">Internal Server Error</string>
    <string name="bad_connection">Slow internet connection</string>
    <string name="empty_body">Could not find a recipe with that name</string>
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
    
    
    
    static var fileName: String = ""
    
    static func fileContent(packageName: String, uiSettings: UISettings) -> String {
        return ""
    }
    
    
}
