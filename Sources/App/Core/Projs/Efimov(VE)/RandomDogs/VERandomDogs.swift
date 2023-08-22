//
//  File.swift
//  
//
//  Created by admin on 8/22/23.
//

import Foundation

struct VERandomDogs: FileProviderProtocol {
    static var fileName: String = "RandomDogs.kt"
    
    static func fileContent(packageName: String, uiSettings: UISettings) -> String {
        """
package \(packageName).presentation.fragments.main_fragment

import android.content.Context
import android.content.ContextWrapper
import androidx.activity.compose.BackHandler
import androidx.appcompat.app.AppCompatActivity
import androidx.compose.animation.core.RepeatMode
import androidx.compose.animation.core.TweenSpec
import androidx.compose.animation.core.animateFloat
import androidx.compose.animation.core.infiniteRepeatable
import androidx.compose.animation.core.rememberInfiniteTransition
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.IconButton
import androidx.compose.material.LinearProgressIndicator
import androidx.compose.material.Scaffold
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.ArrowForwardIos
import androidx.compose.material.icons.filled.ExitToApp
import androidx.compose.material.icons.filled.Refresh
import androidx.compose.material3.BottomAppBar
import androidx.compose.material3.Button
import androidx.compose.material3.ButtonDefaults
import androidx.compose.material3.Card
import androidx.compose.material3.CardDefaults
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.FloatingActionButton
import androidx.compose.material3.Icon
import androidx.compose.material3.Text
import androidx.compose.material3.TopAppBar
import androidx.compose.material3.TopAppBarDefaults
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.collectAsState
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.draw.rotate
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.input.nestedscroll.nestedScroll
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.hilt.navigation.compose.hiltViewModel
import androidx.lifecycle.SavedStateHandle
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import androidx.navigation.NavController
import androidx.navigation.NavGraphBuilder
import androidx.navigation.NavType
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import androidx.navigation.compose.rememberNavController
import androidx.navigation.navArgument
import coil.compose.SubcomposeAsyncImage
import com.google.gson.annotations.SerializedName
import \(packageName).R
import dagger.Module
import dagger.Provides
import dagger.hilt.InstallIn
import dagger.hilt.android.lifecycle.HiltViewModel
import dagger.hilt.components.SingletonComponent
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.delay
import kotlinx.coroutines.flow.MutableSharedFlow
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.SharedFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asSharedFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import retrofit2.HttpException
import retrofit2.Retrofit
import retrofit2.converter.gson.GsonConverterFactory
import retrofit2.http.GET
import retrofit2.http.Path
import java.io.IOException
import javax.inject.Inject
import javax.inject.Singleton

val backColorPrimary = Color(0xFF\(uiSettings.backColorPrimary ?? "FFFFFF"))
val textColorPrimary = Color(0xFF\(uiSettings.textColorPrimary ?? "FFFFFF"))
val textColorSecondary = Color(0xFF\(uiSettings.textColorSecondary ?? "FFFFFF"))
val buttonColorPrimary = Color(0xFF\(uiSettings.buttonColorPrimary ?? "FFFFFF"))

data class BreedsDto(
    @SerializedName("message") val breeds: Map<String, List<String>>
)

data class RandomDogImageDto(
    @SerializedName("message") val image: String
)

fun Map<String, List<String>>.toBreeds(): List<Breed> {
    return this.entries.map { Breed(it.key, it.value) }
}

fun RandomDogImageDto.toRandomDogImage() = RandomDogImage(image)

class DogsRepositoryImpl(
    private val api: DogsApi

): DogsRepository {
    override suspend fun fetchBreeds(): List<Breed> {
        return api.fetchBreeds().breeds.toBreeds()
    }

    override suspend fun fetchRandomDogByBreed(name: String): RandomDogImage {
        return api.fetchRandomDogByBreed(name).toRandomDogImage()
    }

    override suspend fun fetchRandomDogBySubbreed(breed: String, subbreed: String): RandomDogImage {
        return api.fetchRandomDogBySubbreed(breed, subbreed).toRandomDogImage()
    }

}

interface DogsApi {

    @GET(Endpoints.randomDogsByBreedEndpoint)
    suspend fun fetchRandomDogByBreed(
        @Path("name") name: String,
    ): RandomDogImageDto

    @GET(Endpoints.listBreedsEndpoint)
    suspend fun fetchBreeds(): BreedsDto

    @GET(Endpoints.randomDogsBySubBreedEndpoint)
    suspend fun fetchRandomDogBySubbreed(
        @Path("breed") name: String,
        @Path("subbreed") subbreed: String
    ): RandomDogImageDto
}

object Endpoints {
    const val baseUrl = "https://dog.ceo/"

    const val randomDogsByBreedEndpoint = "/api/breed/{name}/images/random"
    const val randomDogsBySubBreedEndpoint = "/api/breed/{breed}/{subbreed}/images/random"
    const val listBreedsEndpoint = "/api/breeds/list/all"
}

@[Module InstallIn(SingletonComponent::class)]
class DataModule {

    @[Provides Singleton]
    fun provideDogsApi(): DogsApi {
        return Retrofit.Builder()
            .baseUrl(Endpoints.baseUrl)
            .addConverterFactory(GsonConverterFactory.create())
            .build()
            .create(DogsApi::class.java)
    }

    @[Provides Singleton]
    fun provideDogsRepository(api: DogsApi): DogsRepository {
        return DogsRepositoryImpl(api)
    }

}

data class Breed(
    val name: String,
    val subBreeds: List<String>
)

data class RandomDogImage(
    val image: String
)

interface DogsRepository {
    suspend fun fetchBreeds(): List<Breed>

    suspend fun fetchRandomDogByBreed(name: String): RandomDogImage


    suspend fun fetchRandomDogBySubbreed(breed: String, subbreed: String): RandomDogImage
}

class FetchBreedsUseCase @Inject constructor(
    private val repository: DogsRepository
) {
    suspend operator fun invoke() = safeCall {
        repository.fetchBreeds()
    }
}

class FetchRandomImageByBreedUseCase @Inject constructor(
    private val repository: DogsRepository
) {
    suspend operator fun invoke(name: String) = safeCall {
        repository.fetchRandomDogByBreed(name)
    }
}

class FetchRandomImageBySubbreedUseCase @Inject constructor(
    private val repository: DogsRepository
) {
    suspend operator fun invoke(breed: String, subbreed: String) = safeCall {
        repository.fetchRandomDogBySubbreed(breed, subbreed)
    }
}

interface BaseViewModel<STATE, EVENT, EFFECT> {

    val uiState: StateFlow<STATE>
    val sideEffects: SharedFlow<EFFECT>

    fun handleEvent(event: EVENT)
    fun emitSideEffect(effect: EFFECT)
}

@Composable
fun ErrorMessage(
    modifier: Modifier = Modifier,
    resId: Int,
    onTryClick: () -> Unit
) {
    Column(
        modifier = modifier,
        horizontalAlignment = Alignment.CenterHorizontally,
        verticalArrangement = Arrangement.SpaceEvenly
    ) {
        Text(
            text = stringResource(id = resId),
            color = textColorPrimary,
            fontSize = 20.sp
        )

        Button(
            onClick = onTryClick,
            colors = ButtonDefaults.buttonColors(
                containerColor = buttonColorPrimary
            )
        ) {
            Icon(
                modifier = Modifier.padding(ButtonDefaults.IconSpacing),
                imageVector = Icons.Default.Refresh,
                contentDescription = null,
                tint = textColorPrimary
            )
            Text(
                text = stringResource(id = R.string.try_again),
                color = textColorPrimary,
                fontSize = 16.sp
            )
        }
    }
}

@Composable
fun Router() {
    val navController = rememberNavController()

    NavHost(
        navController = navController,
        startDestination = Screen.Splash.route
    ) {
        splashNavigation(navController)
        listBreedsNavigation(navController)
        dogImageNavigation(navController)
    }
}

fun NavGraphBuilder.splashNavigation(navController: NavController) {
    composable(route = Screen.Splash.route) {
        SplashScreen(
            onNavigate = {
                navController.navigate(Screen.ListBreeds.route) {
                    popUpTo(Screen.Splash.route) { inclusive = true }
                }
            }
        )
    }
}

fun NavGraphBuilder.listBreedsNavigation(navController: NavController) {
    composable(route = Screen.ListBreeds.route) {
        val viewModel = hiltViewModel<BreedsViewModel>()
        val uiState = viewModel.uiState.collectAsState().value
        val context = LocalContext.current

        LaunchedEffect(key1 = Unit) {
            viewModel.sideEffects.collect { effect ->
                when(effect) {
                    is BreedsSides.Exit -> context.findActivity()?.finishAndRemoveTask()
                    is BreedsSides.NavDogImageBreed -> navController.navigate(
                        Screen.DogImage.withArgs(effect.breed, null)
                    )
                    is BreedsSides.NavDogImageSubbreed -> navController.navigate(
                        Screen.DogImage.withArgs(effect.breed, effect.subbreed)
                    )
                }
            }
        }

        BreedsScreen(
            uiState = uiState,
            onExit = { viewModel.handleEvent(BreedsEvents.Exit) },
            onTryClick = { viewModel.handleEvent(BreedsEvents.Load) },
            onBreedClick = { viewModel.handleEvent(BreedsEvents.OnBreedClick(name = it)) },
            onSubbreedClick = { breed, subbreed ->
                viewModel.handleEvent(BreedsEvents.OnSubbreedClick(breed, subbreed))
            }
        )
    }
}

fun NavGraphBuilder.dogImageNavigation(navController: NavController) {
    composable(
        route = "${Screen.DogImage.route}/{${Screen.DogImage.NAME}}/{${Screen.DogImage.SUBBREED}}",
        arguments = listOf(
            navArgument(Screen.DogImage.NAME) { NavType.StringType },
            navArgument(Screen.DogImage.SUBBREED) { NavType.StringType }
        )
    ) {
        val viewModel = hiltViewModel<DogViewModel>()
        val uiState = viewModel.uiState.collectAsState().value

        LaunchedEffect(key1 = Unit) {
            viewModel.sideEffects.collect { effect ->
                when(effect) {
                    DogSide.NavBack -> navController.popBackStack()
                }
            }
        }

        DogImageScreen(
            uiState = uiState,
            onBackPressed = { viewModel.handleEvent(DogEvent.BackPressed) },
            onTryClick = { viewModel.handleEvent(DogEvent.Load) },
            onNextImageClick = { viewModel.handleEvent(DogEvent.NextRandomImage) }
        )
    }
}

sealed class Screen(val route: String) {
    object Splash: Screen(route = "splash")
    object ListBreeds: Screen(route = "list_breeds")
    object DogImage: Screen(route = "dog_image") {
        const val NAME = "name"
        const val SUBBREED = "subbreed"
    }

    open fun withArgs(vararg args: String?): String {
        return args.joinToString(
            prefix = "$route/",
            separator = "/"
        )
    }
}

sealed interface BreedsEvents {
    object Load: BreedsEvents
    class OnBreedClick(val name: String): BreedsEvents
    class OnSubbreedClick(val breed: String, val subbreed: String): BreedsEvents
    object Exit: BreedsEvents
}

interface BreedsSides {
    object Exit: BreedsSides
    class NavDogImageBreed(val breed: String): BreedsSides
    class NavDogImageSubbreed(val breed: String, val subbreed: String): BreedsSides

}

@HiltViewModel
class BreedsViewModel @Inject constructor(
    private val fetchBreedsUseCase: FetchBreedsUseCase

): ViewModel(), BaseViewModel<UiBreedsState, BreedsEvents, BreedsSides> {

    private val _uiState = MutableStateFlow<UiBreedsState>(UiBreedsState.Loading)
    override val uiState: StateFlow<UiBreedsState> = _uiState.asStateFlow()

    private val _sideEffects = MutableSharedFlow<BreedsSides>()
    override val sideEffects: SharedFlow<BreedsSides> = _sideEffects.asSharedFlow()

    init {
        handleEvent(BreedsEvents.Load)
    }

    override fun handleEvent(event: BreedsEvents) {
        viewModelScope.launch {
            when(event) {
                BreedsEvents.Load -> {
                    _uiState.value = UiBreedsState.Loading
                    fetchBreedsUseCase()
                        .onSuccess { _uiState.value = UiBreedsState.Success(it) }
                        .onFailure { _uiState.value = UiBreedsState.Error(it.toStringError()) }
                }

                is BreedsEvents.Exit -> emitSideEffect(BreedsSides.Exit)
                is BreedsEvents.OnBreedClick -> emitSideEffect(BreedsSides.NavDogImageBreed(event.name))
                is BreedsEvents.OnSubbreedClick -> emitSideEffect(
                    BreedsSides.NavDogImageSubbreed(event.breed, event.subbreed)
                )
            }
        }
    }

    override fun emitSideEffect(effect: BreedsSides) {
        viewModelScope.launch {
            _sideEffects.emit(effect)
        }
    }
}

sealed interface UiBreedsState {
    object Loading: UiBreedsState
    class Error(val resId: Int): UiBreedsState
    class Success(val breeds: List<Breed>): UiBreedsState
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun BreedItem(
    breed: Breed,
    onBreedClick: (breed: String) -> Unit,
    onSubbreedClick: (breed: String, subbreed: String) -> Unit
) {
    Column(
        modifier = Modifier.fillMaxWidth(),
        verticalArrangement = Arrangement.spacedBy(0.dp)
    ) {
        Card(
            modifier = Modifier
                .fillMaxSize()
                .height(100.dp)
                .padding(end = 80.dp),
            onClick = { onBreedClick(breed.name) },
            shape = RoundedCornerShape(topEndPercent = 20, bottomEndPercent = 20),
            colors = CardDefaults.cardColors(
                containerColor = buttonColorPrimary
            )
        ) {
            Box(
                modifier = Modifier.fillMaxSize(),
                contentAlignment = Alignment.Center
            ) {
                Text(
                    text = breed.name,
                    color = textColorPrimary,
                    fontSize = 30.sp
                )
            }
        }
        breed.subBreeds.forEach { subBreed ->
            Card(
                modifier = Modifier
                    .fillMaxWidth()
                    .height(40.dp)
                    .padding(end = 150.dp),
                onClick = { onSubbreedClick(breed.name, subBreed) },
                shape = RoundedCornerShape(topEndPercent = 50, bottomEndPercent = 50),
                colors = CardDefaults.cardColors(
                    containerColor = buttonColorPrimary
                )
            ) {
                Box(
                    modifier = Modifier.fillMaxSize(),
                    contentAlignment = Alignment.Center
                ) {
                    Text(
                        text = subBreed,
                        color = textColorSecondary,
                        fontSize = 25.sp
                    )
                }
            }
        }
    }
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun BreedsScreen(
    uiState: UiBreedsState,
    onExit: () -> Unit,
    onTryClick: () -> Unit,
    onBreedClick: (String) -> Unit,
    onSubbreedClick: (breed: String, subbreed: String) -> Unit
) {
    val scrollBehavior = TopAppBarDefaults.enterAlwaysScrollBehavior()

    Scaffold(
        modifier = Modifier
            .nestedScroll(scrollBehavior.nestedScrollConnection),
        topBar = {
            TopAppBar(
                title = {
                    Text(
                        modifier = Modifier.fillMaxWidth(),
                        text = stringResource(id = R.string.breeds),
                        color = textColorPrimary,
                        fontSize = 35.sp,
                        textAlign = TextAlign.Center,
                        fontWeight = FontWeight.Bold
                    )
                },
                actions = {
                    IconButton(onClick = onExit) {
                        Icon(
                            imageVector = Icons.Default.ExitToApp,
                            contentDescription = null,
                            tint = textColorPrimary
                        )
                    }
                },
                colors = TopAppBarDefaults.centerAlignedTopAppBarColors(
                    containerColor = backColorPrimary
                ),
                scrollBehavior = scrollBehavior
            )
        }
    ) { scaffoldPaddings ->
        Box(
            modifier = Modifier
                .fillMaxSize()
                .background(backColorPrimary)
                .padding(scaffoldPaddings),
            contentAlignment = Alignment.Center
        ) {
            when(uiState) {
                is UiBreedsState.Loading -> LinearProgressIndicator(color = textColorPrimary)
                is UiBreedsState.Error -> ErrorMessage(
                    resId = uiState.resId,
                    onTryClick = onTryClick
                )
                is UiBreedsState.Success -> BreedsContent(
                    breeds = uiState.breeds,
                    onBreedClick = onBreedClick,
                    onSubbreedClick = onSubbreedClick
                )
            }
        }
    }
}

@Composable
private fun BreedsContent(
    breeds: List<Breed>,
    onBreedClick: (String) -> Unit,
    onSubbreedClick: (breed: String, subbreed: String) -> Unit
) {
    LazyColumn(
        modifier = Modifier.fillMaxSize(),
        horizontalAlignment = Alignment.CenterHorizontally,
        verticalArrangement = Arrangement.spacedBy(20.dp)
    ) {
        items(breeds) { breed ->
            BreedItem(
                breed = breed,
                onBreedClick = onBreedClick,
                onSubbreedClick = onSubbreedClick
            )
        }
    }
}

sealed interface DogEvent {

    object Load: DogEvent
    object BackPressed: DogEvent
    object NextRandomImage: DogEvent
}

sealed interface DogSide {
    object NavBack: DogSide
}

@HiltViewModel
class DogViewModel @Inject constructor(
    private val fetchRandomImageByBreedUseCase: FetchRandomImageByBreedUseCase,
    private val fetchRandomImageBySubbreedUseCase: FetchRandomImageBySubbreedUseCase,
    savedStateHandle: SavedStateHandle

): ViewModel(), BaseViewModel<UiDogState, DogEvent, DogSide> {

    private val _uiState = MutableStateFlow<UiDogState>(UiDogState.Loading)
    override val uiState: StateFlow<UiDogState> = _uiState.asStateFlow()

    private val _sideEffect = MutableSharedFlow<DogSide>()
    override val sideEffects: SharedFlow<DogSide> = _sideEffect.asSharedFlow()

    private val breedName = savedStateHandle.get<String>(Screen.DogImage.NAME)
    private val subbreed = savedStateHandle.get<String>(Screen.DogImage.SUBBREED)
    init {
        handleEvent(DogEvent.Load)
    }

    override fun handleEvent(event: DogEvent) {
        when(event) {
            DogEvent.BackPressed -> emitSideEffect(DogSide.NavBack)
            DogEvent.NextRandomImage -> loadImage()
            DogEvent.Load -> loadImage()
        }
    }

    private fun loadImage() {
        if(breedName != null && subbreed != "null")
            fetchImageBySubbreed()

        else
            fetchImageByBreed()
    }

    private fun fetchImageByBreed() {
        if(breedName != null) {
            viewModelScope.launch {
                fetchRandomImageByBreedUseCase(breedName)
                    .onSuccess { _uiState.value = UiDogState.Success(it) }
                    .onFailure { _uiState.value = UiDogState.Error(it.toStringError()) }
            }
        } else {
            _uiState.value = UiDogState.Error(R.string.internal_err)
        }
    }

    private fun fetchImageBySubbreed() {
        if(breedName != null && subbreed != "null" && subbreed != null) {
            viewModelScope.launch {
                fetchRandomImageBySubbreedUseCase(breedName, subbreed)
                    .onSuccess { _uiState.value = UiDogState.Success(it) }
                    .onFailure { _uiState.value = UiDogState.Error(it.toStringError()) }
            }
        } else {
            _uiState.value = UiDogState.Error(R.string.internal_err)
        }
    }

    override fun emitSideEffect(effect: DogSide) {
        viewModelScope.launch {
            _sideEffect.emit(effect)
        }
    }

}

sealed interface UiDogState {
    object Loading: UiDogState
    class Error(val resId: Int): UiDogState

    class Success(val randomDogImage: RandomDogImage): UiDogState
}

@Composable
fun DogImageScreen(
    uiState: UiDogState,
    onBackPressed: () -> Unit,
    onTryClick: () -> Unit,
    onNextImageClick: () -> Unit
) {
    BackHandler {
        onBackPressed()
    }

    androidx.compose.material3.Scaffold(
        bottomBar = {
            BottomAppBar(
                floatingActionButton = {
                    FloatingActionButton(
                        onClick = onNextImageClick,
                        containerColor = buttonColorPrimary
                    ) {
                        Icon(
                            modifier = Modifier.size(24.dp),
                            imageVector = Icons.Default.ArrowForwardIos,
                            contentDescription = null,
                            tint = textColorPrimary
                        )
                    }
                },
                actions = {},
                containerColor = backColorPrimary
            )
        }
    ) { scaffoldPaddings ->
        Box(
            modifier = Modifier
                .fillMaxSize()
                .background(backColorPrimary)
                .padding(scaffoldPaddings),
            contentAlignment = Alignment.Center
        ) {
            when (uiState) {
                is UiDogState.Loading -> androidx.compose.material3.LinearProgressIndicator(
                    color = textColorPrimary
                )

                is UiDogState.Error -> ErrorMessage(
                    resId = uiState.resId,
                    onTryClick = onTryClick
                )

                is UiDogState.Success -> DogImageContent(
                    randomDogImage = uiState.randomDogImage
                )
            }
        }
    }
}

@Composable
private fun DogImageContent(
    randomDogImage: RandomDogImage
) {
    SubcomposeAsyncImage(
        modifier = Modifier
            .fillMaxWidth()
            .clip(shape = RoundedCornerShape(10))
            .padding(5.dp),
        model = randomDogImage.image,
        contentDescription = null,
    )
}

const val SPLASH_DELAY = 3000L
@Composable
fun SplashScreen(
    onNavigate: () -> Unit
) {
    val infiniteTransition = rememberInfiniteTransition(label = "")

    val rotateAnimation = infiniteTransition.animateFloat(
        initialValue = 0f,
        targetValue = -20f,
        animationSpec = infiniteRepeatable(
            animation = TweenSpec(700),
            repeatMode = RepeatMode.Reverse
        ),
        label = ""
    )
    LaunchedEffect(key1 = Unit) {
        delay(SPLASH_DELAY)
        onNavigate()
    }

    Box(
        modifier = Modifier
            .fillMaxSize()
            .background(backColorPrimary),
        contentAlignment = Alignment.Center
    ) {
        Icon(
            modifier = Modifier
                .size(200.dp)
                .rotate(rotateAnimation.value),
            painter = painterResource(id = R.drawable.pet_icon),
            contentDescription = null,
            tint = textColorPrimary
        )
    }
}

suspend fun<T> safeCall(request: suspend () -> T) =
    runCatching {
        withContext(Dispatchers.IO) {
            request()
        }
    }

fun Throwable.toStringError(): Int {
    return when(this) {
        is IOException -> R.string.io_err
        is HttpException -> R.string.our_err
        else -> R.string.unexp_err
    }
}

fun Context.findActivity(): AppCompatActivity? = when (this) {
    is AppCompatActivity -> this
    is ContextWrapper -> baseContext.findActivity()
    else -> null
}


"""
    }
    
    static func dependencies(_ mainData: MainData) -> ANDData {
        return ANDData(
            mainFragmentData: ANDMainFragment(imports: "", content: """
    Router()
"""),
            mainActivityData: ANDMainActivity(imports: "", extraFunc: "", content: ""),
            themesData: ANDThemesData(isDefault: true, content: ""),
            stringsData: ANDStringsData(additional: """
    <string name="io_err">Check your internet!</string>
    <string name="our_err">Something wrong on our side</string>
    <string name="unexp_err">Unexpected error</string>
    <string name="try_again">Try again</string>
    <string name="breeds">Breeds</string>
    <string name="internal_err">Internal error</string>
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
