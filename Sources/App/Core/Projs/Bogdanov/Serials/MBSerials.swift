//
//  File.swift
//  
//
//  Created by admin on 27.07.2023.
//

import Foundation

struct MBSerials: FileProviderProtocol {
    static func dependencies(_ packageName: String) -> ANDData {
        return ANDData(
            mainFragmentData: ANDMainFragment(
                imports: "",
                content: """
            MBSerialsApi()
        """
            ),
            mainActivityData: ANDMainActivity(
                imports: "",
                extraFunc: "",
                content: ""
            ),
            buildGradleData: ANDBuildGradle(
                obfuscation: false,
                dependencies: """
            implementation Dependencies.okhttp
            implementation Dependencies.okhttp_login_interceptor
            implementation Dependencies.retrofit
            implementation Dependencies.converter_gson
            implementation Dependencies.coil_compose
        """
            )
        )
    }
    
    static var fileName: String = "MBSerials.kt"
    
    static func fileContent(packageName: String, uiSettings: UISettings) -> String {
        return """
package \(packageName).presentation.fragments.main_fragment

import android.util.Log
import androidx.annotation.Keep
import androidx.compose.animation.core.Animatable
import androidx.compose.animation.core.tween
import androidx.compose.foundation.ExperimentalFoundationApi
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.pager.VerticalPager
import androidx.compose.foundation.pager.rememberPagerState
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.verticalScroll
import androidx.compose.material3.Button
import androidx.compose.material3.Card
import androidx.compose.material3.LinearProgressIndicator
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.remember
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import androidx.lifecycle.viewmodel.compose.viewModel
import coil.compose.AsyncImage
import com.google.gson.annotations.SerializedName
import \(packageName).presentation.fragments.main_fragment.ErrorResolver.toHttpErrorType
import \(packageName).presentation.fragments.main_fragment.ErrorResolver.toIOErrorType
import dagger.Module
import dagger.Provides
import dagger.hilt.InstallIn
import dagger.hilt.android.lifecycle.HiltViewModel
import dagger.hilt.components.SingletonComponent
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.SupervisorJob
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import okhttp3.Interceptor
import okhttp3.OkHttpClient
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
import javax.inject.Singleton

val backColorPrimary = Color(0xFF\(uiSettings.backColorPrimary ?? "FFFFFF"))
val textColorPrimary = Color(0xFF\(uiSettings.textColorPrimary ?? "FFFFFF"))

@Composable
fun MBSerialsApi(appViewModel: AppViewModel = viewModel()) {
    val mainState = appViewModel.mainState.collectAsState()

    when (val state = mainState.value.screenState) {
        ScreenState.Loading -> LoadingScreen()
        is ScreenState.Failure -> FailureScreen(state)
        is ScreenState.Success -> SuccessScreen(state)
    }
}

interface KinopoiskApi {

    private companion object {
        const val SERIALS_ENDPOINT = "movie"
    }

    @GET(SERIALS_ENDPOINT)
    suspend fun getSerials(
        @Query("type") type: String = "tv-series"
    ): SerialsModel

}

interface RemoteRepository {

    suspend fun getData(): ScreenState

}

class RemoteRepositoryImpl @Inject constructor(
    private val kinopoiskApi: KinopoiskApi
) : RemoteRepository {

    override suspend fun getData(): ScreenState = withContext(Dispatchers.IO + SupervisorJob()) {
        try {
            ScreenState.Success(
                kinopoiskApi.getSerials()
            )
        } catch (httpException: HttpException) {
            ScreenState.Failure(
                httpException.code().toHttpErrorType()
            )
        } catch (ioException: IOException) {
            ScreenState.Failure(
                ioException.toIOErrorType()
            )
        }
    }
}

@Module
@InstallIn(SingletonComponent::class)
object AppModule {

    @Provides
    @Singleton
    fun provideRetrofitApi(): KinopoiskApi {

        val client = OkHttpClient().newBuilder()
            .addInterceptor(RetrofitClientHelper.createApiKeyInterceptor())
            .build()

        return Retrofit.Builder()
            .addConverterFactory(GsonConverterFactory.create())
            .baseUrl("https://api.kinopoisk.dev/v1.3/")
            .client(client)
            .build()
            .create(KinopoiskApi::class.java)
    }


    @Provides
    @Singleton
    fun provideRemoteRepository(
        kinopoiskApi: KinopoiskApi
    ): RemoteRepository = RemoteRepositoryImpl(kinopoiskApi)

}

@Keep
data class Poster(
    val url: String
)

@Keep
data class SerialData(
    val description: String,
    val enName: String,
    val name: String,
    val poster: Poster,
    val shortDescription: String,
    val year: Int
)

@Keep
data class SerialsModel(
    @SerializedName("docs")
    val serialsData: List<SerialData>
)

@Keep
data class MainState(
    val screenState: ScreenState
)

@Composable
fun FailureScreen(failureState: ScreenState.Failure, appViewModel: AppViewModel = viewModel()) {
    val errorText = when (failureState.errorType) {
        ErrorResolver.ErrorType.Unauthorized -> "There is no token in request!\\nTell us by mail please"
        ErrorResolver.ErrorType.Forbidden -> "Daily limit exceeded!"
        ErrorResolver.ErrorType.NotFound -> "Resource not found exception…"
        ErrorResolver.ErrorType.NoInternetConnection -> "You have no internet!\\nCheck your connection"
        ErrorResolver.ErrorType.BadInternetConnection -> "You have too slow internet speed\\ntry to cancel loadings or change your network rate"
        ErrorResolver.ErrorType.SocketTimeOut -> "Socket time out!\\nTry again later"
        ErrorResolver.ErrorType.Unknown -> "There is some unknown error!"
    }
    Column(
        modifier = Modifier
            .fillMaxSize()
            .background(backColorPrimary),
        verticalArrangement = Arrangement.SpaceAround,
        horizontalAlignment = Alignment.CenterHorizontally
    ) {
        Text(
            text = errorText,
            style = MaterialTheme.typography.bodyLarge,
            modifier = Modifier
                .fillMaxWidth()
                .padding(8.dp)
                .background(backColorPrimary),
            textAlign = TextAlign.Center
        )

        Button(
            onClick = {
                appViewModel.getSerialsData()
            }
        ) {
            Text(
                text = "Retry",
                color = textColorPrimary,
                fontSize = 22.sp
            )
        }
    }
}

@Composable
fun LoadingScreen() {
    val progress = remember {
        Animatable(0f)
    }
    LaunchedEffect(key1 = Unit) {
        progress.animateTo(
            targetValue = 1f,
            animationSpec = tween(1500)
        )
    }
    Box(
        modifier = Modifier
            .fillMaxSize()
            .background(backColorPrimary),
        contentAlignment = Alignment.Center
    ) {
        LinearProgressIndicator(
            progress = progress.value
        )
    }
}

@Composable
fun CardBodyTitle(itemData: SerialData) {
    Row(
        modifier = Modifier
            .fillMaxWidth()
            .padding(4.dp)
            .background(backColorPrimary),
        verticalAlignment = Alignment.CenterVertically,
        horizontalArrangement = Arrangement.SpaceEvenly
    ) {
        Column(
            verticalArrangement = Arrangement.Center,
            horizontalAlignment = Alignment.CenterHorizontally
        ) {
            AsyncImage(
                model = itemData.poster.url,
                contentDescription = null
            )
            Text(
                text = itemData.year.toString(),
                color = textColorPrimary,
                fontSize = 18.sp
            )
        }

        Text(
            modifier = Modifier
                .padding(4.dp)
                .background(backColorPrimary),
            text = itemData.shortDescription,
            color = textColorPrimary,
            fontSize = 18.sp
        )
    }
}

@Composable
fun CardTitle(itemData: SerialData) {
    Column(
        modifier = Modifier
            .fillMaxWidth()
            .padding(horizontal = 16.dp, vertical = 4.dp)
            .background(backColorPrimary),
        verticalArrangement = Arrangement.Center,
        horizontalAlignment = Alignment.CenterHorizontally
    ) {
        itemData.name?.let { name ->
            Text(
                text = name,
                color = textColorPrimary,
                fontSize = 26.sp
            )
        }
        itemData.enName?.let { enName ->
            Text(
                text = enName,
                color = textColorPrimary,
                fontSize = 26.sp
            )
        }
    }
}

@Composable
fun SerialItem(itemData: SerialData) {
    Card(
        modifier = Modifier
            .fillMaxSize()
            .background(backColorPrimary)
    ) {
        Column(
            modifier = Modifier
                .fillMaxSize()
                .background(backColorPrimary),
            verticalArrangement = Arrangement.SpaceBetween,
            horizontalAlignment = Alignment.CenterHorizontally
        ) {
            CardTitle(itemData = itemData)
            CardBody(itemData = itemData)
        }
    }
}

@OptIn(ExperimentalFoundationApi::class)
@Composable
fun SuccessScreen(successState: ScreenState.Success) {
    val pagerState = rememberPagerState(initialPage = 0)
    VerticalPager(
        pageCount = successState.data.serialsData.size,
        modifier = Modifier
            .fillMaxSize()
            .background(backColorPrimary),
        state = pagerState,
        pageSpacing = 16.dp,
        key = { index -> index },
        horizontalAlignment = Alignment.CenterHorizontally
    ) { pageIndex ->
        SerialItem(itemData = successState.data.serialsData[pageIndex])
    }
}

@Composable
fun CardBody(itemData: SerialData) {
    Column(
        modifier = Modifier
            .fillMaxWidth()
            .padding(4.dp)
            .background(backColorPrimary),
        verticalArrangement = Arrangement.SpaceBetween,
        horizontalAlignment = Alignment.CenterHorizontally
    ) {
        CardBodyTitle(itemData = itemData)
        Text(
            modifier = Modifier
                .fillMaxWidth()
                .padding(4.dp)
                .verticalScroll(rememberScrollState())
                .background(backColorPrimary),
            text = itemData.description,
            color = textColorPrimary,
            fontSize = 26.sp
        )
    }
}

interface ScreenState {

    object Loading : ScreenState

    data class Failure(
        val errorType: ErrorResolver.ErrorType
    ) : ScreenState

    data class Success(
        val data: SerialsModel
    ) : ScreenState

}

object RetrofitClientHelper {

    fun createApiKeyInterceptor() = Interceptor { chain ->
        val original = chain.request()
        val requestBuilder = original.newBuilder()
            .addHeader("X-API-KEY", "CRFBD55-KHDMFVM-KEPS8NH-PMX5VE9")
        val request = requestBuilder.build()
        chain.proceed(request)
    }

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

    private val _mainState = MutableStateFlow(MainState(screenState = ScreenState.Loading))
    val mainState = _mainState.asStateFlow()

    init {
        getSerialsData()
    }

    fun getSerialsData() = with(_mainState.value) {
        _mainState.value = copy(
            screenState = ScreenState.Loading
        )
        viewModelScope.launch {
            _mainState.value = copy(
                screenState = remoteRepository.getData()
            )
            Log.d("TAG", "getSerialsData: ${remoteRepository.getData()}")
        }
    }
}
"""
    }
    
    
}
