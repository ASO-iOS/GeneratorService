//
//  File.swift
//  
//
//  Created by admin on 20.06.2023.
//

import Foundation

struct MBIpChecker: FileProviderProtocol {
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
