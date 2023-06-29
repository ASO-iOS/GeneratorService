//
//  File.swift
//  
//
//  Created by admin on 13.06.2023.
//

import Foundation

struct VSPhoneInfo {
    static let fileName = "VSPhoneInfo.kt"
    static func fileText(
        packageName: String,
        backColorLight: String,
        primaryColorLight: String,
        onPrimaryColorLight: String,
        secondaryColorLight: String,
        onSecondaryColorLight: String,
        tertiaryColorLight: String,
        onTertiaryColorLight: String,
        surfaceColorLight: String,
        onSurfaceColorLight: String,
        onBackgroundColorLight: String,
        backColorDark: String,
        primaryColorDark: String,
        onPrimaryColorDark: String,
        secondaryColorDark: String,
        onSecondaryColorDark: String,
        tertiaryColorDark: String,
        onTertiaryColorDark: String,
        surfaceColorDark: String,
        onSurfaceColorDark: String,
        onBackgroundColorDark: String
    ) -> String {
        return """
package \(packageName).presentation.fragments.main_fragment

import android.content.Context
import androidx.annotation.DrawableRes
import androidx.compose.animation.AnimatedContent
import androidx.compose.animation.AnimatedVisibility
import androidx.compose.animation.SizeTransform
import androidx.compose.animation.fadeIn
import androidx.compose.animation.fadeOut
import androidx.compose.animation.slideInHorizontally
import androidx.compose.animation.slideOutHorizontally
import androidx.compose.animation.with
import androidx.compose.foundation.Image
import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.isSystemInDarkTheme
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.ColumnScope
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.imePadding
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.statusBarsPadding
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.text.BasicTextField
import androidx.compose.foundation.text.KeyboardActions
import androidx.compose.foundation.text.KeyboardOptions
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.MaterialTheme.shapes
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.ArrowBack
import androidx.compose.material.icons.filled.DarkMode
import androidx.compose.material.icons.filled.Settings
import androidx.compose.material3.AlertDialog
import androidx.compose.material3.Button
import androidx.compose.material3.ButtonDefaults
import androidx.compose.material3.CenterAlignedTopAppBar
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.ListItem
import androidx.compose.material3.ListItemDefaults
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.MaterialTheme.colorScheme
import androidx.compose.material3.RadioButton
import androidx.compose.material3.RadioButtonDefaults
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Text
import androidx.compose.material3.TextButton
import androidx.compose.material3.lightColorScheme
import androidx.compose.material3.surfaceColorAtElevation
import androidx.compose.runtime.Composable
import androidx.compose.runtime.MutableState
import androidx.compose.runtime.SideEffect
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.ColorFilter
import androidx.compose.ui.graphics.painter.Painter
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.TextStyle
import androidx.compose.ui.text.input.ImeAction
import androidx.compose.ui.text.input.KeyboardType
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.datastore.preferences.core.edit
import androidx.datastore.preferences.core.stringPreferencesKey
import androidx.datastore.preferences.preferencesDataStore
import androidx.hilt.navigation.compose.hiltViewModel
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import androidx.navigation.NavController
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import androidx.navigation.compose.rememberNavController
import \(packageName).R
import com.google.accompanist.systemuicontroller.rememberSystemUiController
import com.google.gson.annotations.SerializedName
import dagger.Module
import dagger.Provides
import dagger.hilt.InstallIn
import dagger.hilt.android.lifecycle.HiltViewModel
import dagger.hilt.android.qualifiers.ApplicationContext
import dagger.hilt.components.SingletonComponent
import kotlinx.coroutines.CoroutineDispatcher
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.Job
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.flow.map
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import okhttp3.Interceptor
import okhttp3.OkHttpClient
import okhttp3.Response
import okhttp3.logging.HttpLoggingInterceptor
import retrofit2.HttpException
import retrofit2.Retrofit
import retrofit2.converter.gson.GsonConverterFactory
import retrofit2.http.GET
import retrofit2.http.Query
import java.io.IOException
import java.net.SocketTimeoutException
import javax.inject.Inject
import javax.inject.Singleton

val backColorLight = Color(0xFF\(backColorLight))
val primaryColorLight = Color(0xFF\(primaryColorLight))
val onPrimaryColorLight = Color(0xFF\(onPrimaryColorLight))
val secondaryColorLight = Color(0xFF\(secondaryColorLight))
val onSecondaryColorLight = Color(0xFF\(onSecondaryColorLight))
val tertiaryColorLight = Color(0xFF\(tertiaryColorLight))
val onTertiaryColorLight = Color(0xFF\(onTertiaryColorLight))
val surfaceColorLight = Color(0xFF\(surfaceColorLight))
val onSurfaceColorLight = Color(0xFF\(onSurfaceColorLight))
val onBackgroundColorLight = Color(0xFF\(onBackgroundColorLight))

val backColorDark = Color(0xFF\(backColorDark))
val primaryColorDark = Color(0xFF\(primaryColorDark))
val onPrimaryColorDark = Color(0xFF\(onPrimaryColorDark))
val secondaryColorDark = Color(0xFF\(secondaryColorDark))
val onSecondaryColorDark = Color(0xFF\(onSecondaryColorDark))
val tertiaryColorDark = Color(0xFF\(tertiaryColorDark))
val onTertiaryColorDark = Color(0xFF\(onTertiaryColorDark))
val surfaceColorDark = Color(0xFF\(surfaceColorDark))
val onSurfaceColorDark = Color(0xFF\(onSurfaceColorDark))
val onBackgroundColorDark = Color(0xFF\(onBackgroundColorDark))

fun NavController.navigate(screens: Screens) {
    navigate(screens.route)
}

@Composable
fun PhoneInfoNavHost() {
    val navController = rememberNavController()

    NavHost(navController = navController, startDestination = Screens.MainScreen.route) {
        composable(Screens.MAIN_SCREEN) {
            PhoneFinderMainScreen(navController)
        }
        composable(Screens.SETTINGS) {
            SettingsScreen(navController = navController)
        }
    }
}

sealed class Screens(val route: String) {

    companion object {
        const val MAIN_SCREEN = "main"
        const val SETTINGS = "settings"
    }

    object MainScreen : Screens(route = MAIN_SCREEN)
    object Settings : Screens(route = SETTINGS)
}

@Composable
fun BoxWithLabel(label: String, content: String) {
    Column(
        modifier = Modifier
            .fillMaxWidth()
            .clip(shapes.medium)
            .background(colorScheme.secondary)
            .padding(12.dp),
        verticalArrangement = Arrangement.spacedBy(12.dp)
    ) {
        Text(text = label, color = colorScheme.onSecondary)
        Text(text = content, color = colorScheme.onSecondary)
    }
}

@Composable
fun ColumnScope.Filler(text: String, @DrawableRes image: Int) {
    Column(
        modifier = Modifier
            .fillMaxWidth()
            .padding(horizontal = 32.dp)
            .weight(1f),
        horizontalAlignment = Alignment.CenterHorizontally,
        verticalArrangement = Arrangement.Center
    ) {
        Image(
            modifier = Modifier
                .padding(top = 24.dp)
                .fillMaxWidth()
                .weight(1f),
            painter = painterResource(image),
            contentDescription = null,
            contentScale = ContentScale.Fit,
            colorFilter = ColorFilter.tint(MaterialTheme.colorScheme.onBackground)
        )
        Text(modifier = Modifier.padding(top = 24.dp), text = text)
        Spacer(modifier = Modifier.weight(0.6f))
    }
}

@Composable
fun ColumnScope.FillerPhoneInfo(info: PhoneInfo) {
    Column(
        modifier = Modifier
            .weight(1f)
            .fillMaxWidth()
            .padding(start = 32.dp, top = 32.dp, end = 32.dp),
        verticalArrangement = Arrangement.spacedBy(24.dp)
    ) {
        BoxWithLabel(
            label = stringResource(R.string.phone_info_country),
            content = info.country
        )
        if (info.location != info.country && info.location.isNotEmpty()) {
            BoxWithLabel(
                label = stringResource(R.string.phone_info_region),
                content = info.location
            )
        }
        BoxWithLabel(
            label = stringResource(R.string.phone_info_timezone),
            content = info.timezones.joinToString("", limit = 5)
        )
    }
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun MainTopBar(viewModel: PhoneFinderViewModel, state: PhoneFinderUiState, navController: NavController) {
    CenterAlignedTopAppBar(
        navigationIcon = {
            AnimatedVisibility(visible = state.state !is PhoneFinderUiState.FinderState.Init, enter = fadeIn(), exit = fadeOut()) {
                IconButton(onClick = { viewModel.resetState() }) {
                    Icon(
                        imageVector = Icons.Default.ArrowBack,
                        contentDescription = stringResource(R.string.topbar_back),
                        tint = colorScheme.onSurface
                    )
                }
            }
        },
        title = {
            AnimatedContent(
                targetState = state.state,
                transitionSpec = {
                    (fadeIn() + slideInHorizontally() with fadeOut() + slideOutHorizontally { it / 2 })
                        .using(SizeTransform(clip = false))
                }
            ) { targetState ->
                when (targetState) {
                    is PhoneFinderUiState.FinderState.Init -> Text(stringResource(R.string.phone_info_topbar_title))
                    else -> NumberTextField(
                        value = state.number,
                        onValue = viewModel::changeNumber,
                        onAction = viewModel::getInfo
                    )
                }
            }
        },
        actions = {
            IconButton(onClick = { navController.navigate(Screens.Settings) }) {
                Icon(
                    imageVector = Icons.Default.Settings,
                    contentDescription = stringResource(R.string.topbar_settings),
                    tint = colorScheme.onSurface
                )
            }
        }
    )
}

@Composable
fun NumberTextField(value: String, onValue: (String) -> Unit, onAction: () -> Unit) {
    Box(
        modifier = Modifier
            .background(MaterialTheme.colorScheme.surface)
            .fillMaxWidth()
            .padding(horizontal = 32.dp)
    ) {
        BasicTextField(
            modifier = Modifier.align(Alignment.Center),
            value = value,
            onValueChange = onValue,
            textStyle = TextStyle(
                color = MaterialTheme.colorScheme.onTertiary,
                fontSize = 14.sp
            ),
            singleLine = true,
            keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Phone, imeAction = ImeAction.Search),
            keyboardActions = KeyboardActions(
                onSearch = { onAction() }
            )
        ) { innerTextField ->
            Box(
                Modifier
                    .fillMaxWidth()
                    .padding(vertical = 24.dp)
                    .clip(MaterialTheme.shapes.medium)
                    .background(MaterialTheme.colorScheme.tertiary)
                    .padding(16.dp),
                contentAlignment = Alignment.CenterStart
            ) {
                innerTextField()
            }
        }
    }
}

@Composable
fun PhoneFinderMainScreen(navController: NavController, viewModel: PhoneFinderViewModel = hiltViewModel()) {
    val state = viewModel.state.collectAsState().value

    Scaffold(
        modifier = Modifier
            .fillMaxSize()
            .imePadding()
            .statusBarsPadding(),
        topBar = { MainTopBar(viewModel = viewModel, state = state, navController = navController) }
    ) { paddingValues ->
        Column(
            modifier = Modifier
                .padding(paddingValues),
            horizontalAlignment = Alignment.CenterHorizontally
        ) {
            AnimatedVisibility(visible = state.state is PhoneFinderUiState.FinderState.Init) {
                NumberTextField(value = state.number, onValue = viewModel::changeNumber, onAction = viewModel::getInfo)
            }

            when (state.state) {
                is PhoneFinderUiState.FinderState.Init -> Filler(stringResource(R.string.init_text), R.drawable.img_phone)
                is PhoneFinderUiState.FinderState.NothingFound -> Filler(stringResource(R.string.nothing_found), R.drawable.img_nothing_found)
                is PhoneFinderUiState.FinderState.PhoneFound ->
                    if (state.state.info.isValid) FillerPhoneInfo(state.state.info)
                    else Filler(stringResource(R.string.invalid_number), R.drawable.img_nothing_found)
            }
            Button(
                modifier = Modifier.fillMaxWidth(0.8f),
                shape = MaterialTheme.shapes.medium,
                onClick = viewModel::getInfo,
                enabled = !state.isLoading
            ) {
                Text(text = stringResource(R.string.phone_picker_search))
            }
        }
    }
}

data class PhoneFinderUiState(
    val number: String = "",
    val state: FinderState = FinderState.Init,
    val isLoading: Boolean = false
) {
    sealed interface FinderState {
        object Init : FinderState
        data class PhoneFound(val info: PhoneInfo) : FinderState
        object NothingFound : FinderState
    }
}

@HiltViewModel
class PhoneFinderViewModel @Inject constructor(
    val repository: PhoneFinderRepository
) : ViewModel() {

    var job: Job? = null
    private val _state = MutableStateFlow(PhoneFinderUiState())
    val state = _state.asStateFlow()

    fun getInfo() {
        if (job?.isActive != true) {
            _state.value = state.value.copy(isLoading = true)
            job = viewModelScope.launch {
                _state.value = when (val response = repository.getPhoneInfo(state.value.number)) {
                    is SafeResponse.Error -> _state.value.copy(state = PhoneFinderUiState.FinderState.NothingFound, isLoading = false)
                    is SafeResponse.Success -> _state.value.copy(state = PhoneFinderUiState.FinderState.PhoneFound(
                        response.value
                    ), isLoading = false)
                }
            }
        }
    }

    fun changeNumber(number: String) {
        _state.value = _state.value.copy(number = number)
    }

    fun resetState() {
        _state.value = _state.value.copy(state = PhoneFinderUiState.FinderState.Init)
    }
}


@Composable
fun SettingsRadioButtonWithLabel(text: String, selected: Boolean, onClick: () -> Unit) {
    Row(
        modifier = Modifier
            .fillMaxWidth()
            .clickable(onClick = onClick)
            .padding(vertical = 8.dp, horizontal = 16.dp),
        verticalAlignment = Alignment.CenterVertically,
    ) {
        RadioButton(
            selected = selected,
            onClick = null,
            colors = RadioButtonDefaults.colors(
                unselectedColor = MaterialTheme.colorScheme.onSurface
            )
        )
        Text(modifier = Modifier.padding(start = 16.dp), text = text)
    }
}

@Composable
fun SettingsThemeDialog(
    settings: Settings,
    viewModel: SettingsViewModel,
    shouldOpenDialog: MutableState<Boolean>
) {

    if (!shouldOpenDialog.value) return

    AlertDialog(
        onDismissRequest = { shouldOpenDialog.value = false },
        title = { Text(text = stringResource(R.string.theme_dialog_title)) },
        text = {
            Column() {
                SettingsRadioButtonWithLabel(
                    text = stringResource(R.string.theme_dialog_light),
                    selected = settings.darkMode == Settings.DarkMode.Light,
                    onClick = {
                        viewModel.updateSettings(settings.copy(darkMode = Settings.DarkMode.Light))
                        shouldOpenDialog.value = false
                    }
                )

                SettingsRadioButtonWithLabel(
                    text = stringResource(R.string.theme_dialog_dark),
                    selected = settings.darkMode == Settings.DarkMode.Dark,
                    onClick = {
                        viewModel.updateSettings(settings.copy(darkMode = Settings.DarkMode.Dark))
                        shouldOpenDialog.value = false
                    }
                )

                SettingsRadioButtonWithLabel(
                    text = stringResource(R.string.theme_dialog_default),
                    selected = settings.darkMode == Settings.DarkMode.System,
                    onClick = {
                        viewModel.updateSettings(settings.copy(darkMode = Settings.DarkMode.System))
                        shouldOpenDialog.value = false
                    }
                )
            }
        },
        confirmButton = {
            TextButton(
                onClick = { shouldOpenDialog.value = false },
                colors = ButtonDefaults.textButtonColors(
                    contentColor = MaterialTheme.colorScheme.onSurface
                )
            ) {
                Text(text = stringResource(R.string.cancel))
            }
        },
        iconContentColor = MaterialTheme.colorScheme.onSurface,
        textContentColor = MaterialTheme.colorScheme.onSurface,
    )
}


@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun SettingsTopBar(navController: NavController) {
    CenterAlignedTopAppBar(
        navigationIcon = {
            IconButton(onClick = { navController.popBackStack() }) {
                Icon(
                    imageVector = Icons.Default.ArrowBack,
                    contentDescription = stringResource(id = R.string.topbar_back)
                )
            }
        },
        title = { Text(text = stringResource(id = R.string.topbar_settings)) }
    )
}

@Composable
fun SettingsMenuLink(
    modifier: Modifier = Modifier,
    enabled: Boolean = true,
    icon: Painter? = null,
    title: String,
    action: (@Composable () -> Unit)? = null,
    onClick: () -> Unit = {},
) {
    ListItem(
        modifier = modifier.clickable(enabled = enabled, onClick = onClick),
        headlineContent = { Text(text = title) },
        leadingContent = {
            icon?.let { Icon(painter = icon, contentDescription = title) }
        },
        trailingContent = { action?.invoke() }
    )
}

@Composable
fun SettingsMenuLink(
    modifier: Modifier = Modifier,
    enabled: Boolean = true,
    icon: ImageVector? = null,
    title: String,
    action: (@Composable () -> Unit)? = null,
    onClick: () -> Unit = {},
) {
    ListItem(
        modifier = modifier.clickable(enabled = enabled, onClick = onClick),
        headlineContent = { Text(text = title) },
        leadingContent = {
            icon?.let { Icon(imageVector = icon, contentDescription = title) }
        },
        trailingContent = { action?.invoke() },
        colors = ListItemDefaults.colors(
            containerColor = MaterialTheme.colorScheme.background,
            headlineColor = MaterialTheme.colorScheme.onBackground,
            trailingIconColor = MaterialTheme.colorScheme.onBackground,
            leadingIconColor = MaterialTheme.colorScheme.onBackground,
            overlineColor = MaterialTheme.colorScheme.onBackground,
        )
    )
}

@Composable
fun SettingsScreen(navController: NavController, viewModel: SettingsViewModel = hiltViewModel()) {

    val settings = viewModel.settings.collectAsState(initial = Settings()).value
    val shouldOpenThemeDialog = remember { mutableStateOf(false) }

    SettingsThemeDialog(
        settings = settings,
        viewModel = viewModel,
        shouldOpenDialog = shouldOpenThemeDialog
    )

    Scaffold(
        topBar = {
            SettingsTopBar(navController)
        }
    ) {
        Column(
            modifier = Modifier
                .fillMaxSize()
                .padding(it)
                .verticalScroll(rememberScrollState()),
        ) {

            SettingsMenuLink(
                icon = Icons.Default.DarkMode,
                title = stringResource(R.string.settings_dark_mode),
                action = { Text(text = settings.darkMode.name, style = MaterialTheme.typography.bodyLarge) }
            ) { shouldOpenThemeDialog.value = true }
        }
    }
}

@HiltViewModel
class SettingsViewModel @Inject constructor(
    private val settingsRepository: SettingsRepository
) : ViewModel() {

    val settings = settingsRepository.getSettings()

    fun updateSettings(settings: Settings) {
        viewModelScope.launch {
            settingsRepository.updateSettings(settings)
        }
    }
}

@Module
@InstallIn(SingletonComponent::class)
object PhoneFinderModule {

    private const val API_KEY = "c+bE5Ns02J8TL3dmNNLFCQ==Zqv5UjpkkbmPftVT"
    private const val BASE_URL = "https://api.api-ninjas.com"

    @Provides
    @Singleton
    fun provideApiKeyInterceptor() = ApiKeyInterceptor(API_KEY)

    @Provides
    @Singleton
    fun provideOkHttpClient(apiKeyInterceptor: ApiKeyInterceptor) = OkHttpClient.Builder()
        .addInterceptor(
            HttpLoggingInterceptor().apply { setLevel(HttpLoggingInterceptor.Level.BASIC) }
        )
        .addInterceptor(apiKeyInterceptor)
        .build()

    @Provides
    @Singleton
    fun provideRetrofit(client: OkHttpClient) = Retrofit.Builder()
        .baseUrl(BASE_URL)
        .client(client)
        .addConverterFactory(GsonConverterFactory.create())
        .build()

    @Provides
    @Singleton
    fun provideService(retrofit: Retrofit): PhoneFinderService {
        return retrofit.create(PhoneFinderService::class.java)
    }

    @Provides
    @Singleton
    fun provideRepository(service: PhoneFinderService) = PhoneFinderRepository(service)

    @Provides
    @Singleton
    fun provideDatastore(@ApplicationContext context: Context) = SettingsRepository(context)
}

sealed class RetrofitException : RuntimeException() {

    object InternalServerException : RetrofitException()
    object TooManyRequestsException : RetrofitException()
    object UnexpectedHttpException : RetrofitException()
    object SocketTimeoutException : RetrofitException()
    object IoException : RetrofitException()
}

data class Settings(
    val darkMode: DarkMode = DarkMode.System,
) {
    enum class DarkMode {
        System, Light, Dark
    }
}

class SettingsRepository(context: Context) {

    companion object {
        private const val PREFERENCES_NAME = "token_preferences"
        private val DARK_MODE = stringPreferencesKey("dark_mode")
    }

    private val Context.dataStore by preferencesDataStore(PREFERENCES_NAME)

    private val datastore = context.dataStore

    fun getSettings(): Flow<Settings> =
        datastore.data.map { prefs ->
            Settings(
                darkMode = prefs[DARK_MODE]?.let { Settings.DarkMode.valueOf(it) } ?: Settings.DarkMode.System,
            )
        }

    suspend fun updateSettings(settings: Settings) {
        datastore.edit { prefs ->
            prefs[DARK_MODE] = settings.darkMode.name
        }
    }
}

class ApiKeyInterceptor(private val apiKey: String) : Interceptor {

    override fun intercept(chain: Interceptor.Chain): Response {
        return chain.proceed(
            chain.request()
                .newBuilder()
                .addHeader("X-Api-Key", apiKey)
                .build()
        )
    }
}

class PhoneFinderRepository(
    private val service: PhoneFinderService,
) {

    suspend fun getPhoneInfo(number: String) =
        safeApiCall(Dispatchers.IO) {
            service.getPhoneInfo(number)
        }
}

interface PhoneFinderService {
    @GET("/v1/validatephone")
    suspend fun getPhoneInfo(@Query("number") number: String): PhoneInfo
}

data class PhoneInfo(
    @SerializedName("is_valid") val isValid: Boolean,
    val country: String,
    val location: String,
    val timezones: List<String>,
//    "is_formatted_properly": true,
//    "format_national": "(206) 555-0100",
//    "format_international": "+1 206-555-0100",
//    "format_e164": "+12065550100",
//    "country_code
)

suspend fun <T> safeApiCall(
    dispatcher: CoroutineDispatcher,
    apiCall: suspend () -> T
): SafeResponse<T> {
    return withContext(dispatcher) {
        try {
            SafeResponse.Success(apiCall.invoke())
        } catch (exception: Exception) {
            SafeResponse.Error(mapExceptionToNetworkException(exception))
        }
    }
}

internal fun mapExceptionToNetworkException(throwable: Throwable): RuntimeException {
    return when (throwable) {
        is HttpException -> mapErrorToNetworkException(throwable.code())
        is SocketTimeoutException -> RetrofitException.SocketTimeoutException
        is IOException -> RetrofitException.IoException
        else -> RetrofitException.UnexpectedHttpException
    }
}

internal fun mapErrorToNetworkException(code: Int): RuntimeException {
    return when (code) {
        429 -> RetrofitException.TooManyRequestsException
        500 -> RetrofitException.InternalServerException
        else -> RetrofitException.UnexpectedHttpException
    }
}

sealed interface SafeResponse<out T> {
    class Error(val error: Exception) : SafeResponse<Nothing>
    class Success<T>(val value: T) : SafeResponse<T>
}

@HiltViewModel
class MainScreenViewModel @Inject constructor(
    private val repository: SettingsRepository
) : ViewModel() {

    val settings = MutableStateFlow(Settings())

    init {
        viewModelScope.launch {
            repository.getSettings().collect {
                settings.value = it
            }
        }
    }
}




private val LightNewColors = lightColorScheme(
    background = backColorLight,
    onBackground = onBackgroundColorLight,
    primary = primaryColorLight,
    onPrimary = onPrimaryColorLight,
    secondary = secondaryColorLight,
    onSecondary = onSecondaryColorLight,
    tertiary = tertiaryColorLight,
    onTertiary = onTertiaryColorLight,
    surface = surfaceColorLight,
    onSurface = onSurfaceColorLight
)

private val DarkNewColors = lightColorScheme(
    background = backColorDark,
    onBackground = onBackgroundColorDark,
    primary = primaryColorDark,
    onPrimary = onPrimaryColorDark,
    secondary = secondaryColorDark,
    onSecondary = onSecondaryColorDark,
    tertiary = tertiaryColorDark,
    onTertiary = onTertiaryColorDark,
    surface = surfaceColorDark,
    onSurface = onSurfaceColorDark
)

@Composable
fun AppTheme(
    useDarkTheme: Boolean = isSystemInDarkTheme(),
    content: @Composable() () -> Unit
) {
    val colors = if (!useDarkTheme) LightNewColors else DarkNewColors

    val systemUiController = rememberSystemUiController()
    SideEffect {
        systemUiController.setStatusBarColor(colors.surfaceColorAtElevation(0.dp), false)
        systemUiController.setNavigationBarColor(colors.background, useDarkTheme)
    }

    MaterialTheme(
        colorScheme = colors,
        content = content
    )
}
"""
    }
}
