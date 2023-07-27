//
//  File.swift
//  
//
//  Created by admin on 02.07.2023.
//

import Foundation

struct MBRickNMorty: FileProviderProtocol {
    static func dependencies(_ packageName: String) -> ANDData {
        return ANDData(
            mainFragmentData: ANDMainFragment(
                imports: "",
                content: """
            PagingAppComposeTheme {
                MBRickNMorty()
            }
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
            implementation Dependencies.paging
            implementation Dependencies.pagingCommon
            implementation 'androidx.paging:paging-compose:3.2.0-rc01'
            implementation Dependencies.coil_compose
        """
            )
        )
    }
    
    static var fileName = "MBRickNMorty.kt"
    
    static func fileContent(packageName: String, uiSettings: UISettings) -> String {
        return """
package \(packageName).presentation.fragments.main_fragment

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.aspectRatio
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.lazy.grid.GridCells
import androidx.compose.foundation.lazy.grid.GridItemSpan
import androidx.compose.foundation.lazy.grid.LazyGridScope
import androidx.compose.foundation.lazy.grid.LazyVerticalGrid
import androidx.compose.material3.CircularProgressIndicator
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.material3.Typography
import androidx.compose.material3.lightColorScheme
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.unit.dp
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import androidx.lifecycle.viewmodel.compose.viewModel
import androidx.paging.LoadState
import androidx.paging.Pager
import androidx.paging.PagingConfig
import androidx.paging.PagingData
import androidx.paging.PagingSource
import androidx.paging.PagingState
import androidx.paging.cachedIn
import androidx.paging.compose.LazyPagingItems
import androidx.paging.compose.collectAsLazyPagingItems
import androidx.paging.compose.itemKey
import coil.compose.AsyncImage
import com.google.gson.annotations.SerializedName
import \(packageName).presentation.fragments.main_fragment.ErrorResolver.toIOErrorType
import dagger.Module
import dagger.Provides
import dagger.hilt.InstallIn
import dagger.hilt.android.lifecycle.HiltViewModel
import dagger.hilt.components.SingletonComponent
import kotlinx.coroutines.flow.Flow
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
val primaryColor = Color(0xFF\(uiSettings.primaryColor ?? "FFFFFF"))

@Composable
fun MBRickNMorty(appViewModel: AppViewModel = viewModel()) {
    val pages = appViewModel.loadData().collectAsLazyPagingItems()

    Column(modifier = Modifier.fillMaxSize().background(backColorPrimary)) {
        LazyVerticalGrid(
            columns = GridCells.Fixed(3),
        ) {
            MainPagingItems(pages)

            FirstLoadingContent(pages)

            PagingLoadingContent(pages)
        }
    }

}

interface NetworkApi {

    private companion object {
        const val UrlEndpoint = "character/"
    }

    @GET(UrlEndpoint)
    suspend fun getNewPage(@Query("page") page: Int): CharactersModel

}

interface RemoteRepository {

    fun getData() : Flow<PagingData<CharacterImage>>

}

class RemoteRepositoryImpl @Inject constructor(
    private val networkApi: NetworkApi
) : RemoteRepository {

    override fun getData() = Pager(
        config = PagingConfig(
            pageSize = 19
        ),
        pagingSourceFactory = {
            ImagesPagingSource(networkApi)
        }
    ).flow

}

@Composable
fun PagingAppComposeTheme(
    content: @Composable () -> Unit
) {
    MaterialTheme(
        colorScheme = lightColorScheme(),
        typography = Typography(),
        content = content
    )
}

@Module
@InstallIn(SingletonComponent::class)
object AppModule {

    @Provides
    @Singleton
    fun provideRetrofitApi(): NetworkApi =
        Retrofit.Builder()
            .addConverterFactory(GsonConverterFactory.create())
            .baseUrl("https://rickandmortyapi.com/api/")
            .build()
            .create(NetworkApi::class.java)

    @Provides
    @Singleton
    fun provideRemoteRepository(api: NetworkApi): RemoteRepository = RemoteRepositoryImpl(api)

}

data class CharactersModel(
    @SerializedName("results")
    val listImages: List<CharacterImage>
)

data class CharacterImage(
    val image: String
)

@HiltViewModel
class AppViewModel @Inject constructor(
    private val remoteRepository: RemoteRepository
) : ViewModel() {

    fun loadData(): Flow<PagingData<CharacterImage>> =
        remoteRepository.getData().cachedIn(viewModelScope)

}

class ImagesPagingSource(
    private val networkApi: NetworkApi
) : PagingSource<Int, CharacterImage>() {

    override fun getRefreshKey(state: PagingState<Int, CharacterImage>): Int? {
        return state.anchorPosition?.let {  pos ->
            state.closestPageToPosition(pos)?.prevKey?.plus(1)
                ?: state.closestPageToPosition(pos)?.nextKey?.minus(1)
        }
    }

    override suspend fun load(params: LoadParams<Int>): LoadResult<Int, CharacterImage> {
        return try {
            val page = params.key ?: 1
            val response = networkApi.getNewPage(page)
            LoadResult.Page(
                data = response.listImages,
                prevKey = if (page == 1) null else page.minus(1),
                nextKey = if (response.listImages.isEmpty()) null else page.plus(1)
            )
        }  catch (ioException: IOException) {
            LoadResult.Error(ioException)
        } catch (httpException: HttpException) {
            LoadResult.Error(httpException)
        }
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

    fun Throwable.toIOErrorType(): ErrorType {
        return when (this) {
            is ConnectException -> ErrorType.NoInternetConnection
            is UnknownHostException -> ErrorType.BadInternetConnection
            is SocketTimeoutException -> ErrorType.SocketTimeOut
            else -> ErrorType.Unknown
        }
    }

}

fun LazyGridScope.MainPagingItems(pages: LazyPagingItems<CharacterImage>) {
    items(
        count = pages.itemCount,
        key = pages.itemKey {
            it.image
        }
    ) { index ->
        pages[index]?.let {
            ImageView(character = it)
        }

    }
}

@Composable
fun ImageView(character: CharacterImage) {
    AsyncImage(
        model = character.image,
        contentDescription = null,
        contentScale = ContentScale.FillBounds,
        modifier = Modifier
            .aspectRatio(1f)
            .padding(6.dp)
    )
}

@Composable
fun FailureScreen(error: Throwable) {
    val errorText = when (error.toIOErrorType()) {
        ErrorResolver.ErrorType.Unauthorized -> "Unauthorized Exception"
        ErrorResolver.ErrorType.Forbidden -> "Forbidden Exception"
        ErrorResolver.ErrorType.NotFound -> "Not Found Exception"
        ErrorResolver.ErrorType.NoInternetConnection -> "No Internet Connection"
        ErrorResolver.ErrorType.BadInternetConnection -> "Bad Internet Connection"
        ErrorResolver.ErrorType.SocketTimeOut -> "Socket Exception"
        ErrorResolver.ErrorType.Unknown -> "Unknown Exception"
    }

    Column(
        modifier = Modifier
            .fillMaxSize(),
        verticalArrangement = Arrangement.SpaceEvenly,
        horizontalAlignment = Alignment.CenterHorizontally
    ) {
        Spacer(Modifier)

        Text(
            modifier = Modifier.fillMaxWidth(0.9f),
            style = MaterialTheme.typography.displayMedium,
            text = errorText
        )
    }

}

fun LazyGridScope.FirstLoadingContent(pages: LazyPagingItems<CharacterImage>) {
    item(
        span = {
            GridItemSpan(maxLineSpan)
        }
    ) {
        when (val state = pages.loadState.refresh) { //first load
            is LoadState.Error -> FailureScreen(error = state.error)

            LoadState.Loading -> {
                Column(
                    modifier = Modifier
                        .fillMaxSize(),
                    horizontalAlignment = Alignment.CenterHorizontally,
                    verticalArrangement = Arrangement.Center,
                ) {
                    CircularProgressIndicator(color = primaryColor)
                }
            }

            else -> { }
        }
    }
}fun LazyGridScope.PagingLoadingContent(pages: LazyPagingItems<CharacterImage>) {
    item(
        span = {
            GridItemSpan(maxLineSpan)
        }
    ) {
        when (val state = pages.loadState.append) {
            is LoadState.Error -> FailureScreen(error = state.error)

            is LoadState.Loading -> {
                Column(
                    modifier = Modifier
                        .fillMaxWidth(),
                    horizontalAlignment = Alignment.CenterHorizontally,
                    verticalArrangement = Arrangement.Center,
                ) {
                    CircularProgressIndicator()
                }
            }

            else -> { }
        }
    }
}
"""
    }
}
