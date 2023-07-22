//
//  File.swift
//  
//
//  Created by admin on 13.06.2023.
//

import Foundation

struct VSPhoneInfo: FileProviderProtocol {
    static var fileName = "VSPhoneInfo.kt"
    static func fileContent(
        packageName: String,
        uiSettings: UISettings
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
import androidx.compose.material3.TopAppBarDefaults
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

val backColorPrimary = Color(0xFF\(uiSettings.backColorPrimary ?? "3F51B5"))
val backColorSecondary = Color(0xFF\(uiSettings.backColorSecondary ?? "3F51B5"))
val surfaceColorPrimary = Color(0xFF\(uiSettings.surfaceColor ?? "071950"))
val buttonColorPrimary = Color(0xFF\(uiSettings.buttonColorPrimary ?? "348810"))
val buttonTextColorPrimary = Color(0xFF\(uiSettings.buttonTextColorPrimary ?? "FFFFFF"))
val textColorPrimary = Color(0xFF\(uiSettings.textColorPrimary ?? "FFFFFF"))

@Composable
fun PhoneInfoNavHost() {
    val navController = rememberNavController()

    NavHost(navController = navController, startDestination = Screens.MainScreen.route) {
        composable(Screens.MAIN_SCREEN) {
            PhoneFinderMainScreen(navController)
        }
    }
}

sealed class Screens(val route: String) {

    companion object {
        const val MAIN_SCREEN = "main"
    }

    object MainScreen : Screens(route = MAIN_SCREEN)
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
            colorFilter = ColorFilter.tint(textColorPrimary)
        )
        Text(modifier = Modifier.padding(top = 24.dp), text = text, color = textColorPrimary)
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
                        tint = textColorPrimary
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
                    is PhoneFinderUiState.FinderState.Init -> Text(stringResource(R.string.phone_info_topbar_title), color = textColorPrimary)
                    else -> NumberTextField(
                        value = state.number,
                        onValue = viewModel::changeNumber,
                        onAction = viewModel::getInfo
                    )
                }
            }
        },
        actions = { }
    , colors = TopAppBarDefaults.centerAlignedTopAppBarColors(containerColor = backColorSecondary)
    )
}

@Composable
fun NumberTextField(value: String, onValue: (String) -> Unit, onAction: () -> Unit) {
    Box(
        modifier = Modifier
            .background(backColorSecondary)
            .fillMaxWidth()
            .padding(horizontal = 32.dp)
    ) {
        BasicTextField(
            modifier = Modifier.align(Alignment.Center),
            value = value,
            onValueChange = onValue,
            textStyle = TextStyle(
                color = textColorPrimary,
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
                    .background(surfaceColorPrimary)
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
                .background(backColorPrimary)
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
                enabled = !state.isLoading,
                colors = ButtonDefaults.buttonColors(containerColor = buttonColorPrimary, contentColor = buttonTextColorPrimary)
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
    val timezones: List<String>
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

"""
    }
}
