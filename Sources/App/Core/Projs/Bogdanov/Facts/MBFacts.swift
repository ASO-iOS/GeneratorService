//
//  File.swift
//  
//
//  Created by admin on 26.06.2023.
//

import Foundation

struct MBFacts {
    static let fileName = "MBFacts.kt"
    
    static func fileContent(
        packageName: String,
        backColorPrimary: String,
        backColorSecondary: String,
        textColor: String
    ) -> String {
        return """
package \(packageName).presentation.fragments.main_fragment


import androidx.compose.foundation.ExperimentalFoundationApi
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.fillMaxHeight
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.pager.HorizontalPager
import androidx.compose.foundation.pager.rememberPagerState
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.verticalScroll
import androidx.compose.material3.Button
import androidx.compose.material3.Card
import androidx.compose.material3.CardDefaults
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.collectAsState
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import androidx.lifecycle.viewmodel.compose.viewModel
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
import okhttp3.OkHttpClient
import okhttp3.logging.HttpLoggingInterceptor
import retrofit2.Retrofit
import retrofit2.converter.gson.GsonConverterFactory
import retrofit2.http.GET
import javax.inject.Inject
import javax.inject.Singleton

val backColorPrimary = Color(0xFF\(backColorPrimary))
val backColorSecondary = Color(0xFF\(backColorSecondary)(
val textColor = Color(0xFF\(textColor))

@Composable
fun PageScreen(page: Int, state: FactState.Success) {
    Box(
        modifier = Modifier
            .fillMaxSize(0.95f)
            .padding(16.dp)
            .background(backColorPrimary),
        contentAlignment = Alignment.Center
    ) {
        Card(
            modifier = Modifier
                .fillMaxWidth()
                .fillMaxHeight(0.7f),
//                .background(backColorPrimary),
            shape = RoundedCornerShape(16.dp),
            elevation = CardDefaults.cardElevation(defaultElevation = 8.dp)
        ) {
            Text(
                modifier = Modifier
                    .fillMaxSize()
                    .padding(24.dp)
                    .background(backColorSecondary)
                    .verticalScroll(rememberScrollState()),
                text = state.response[page].text,
                fontSize = 36.sp,
                color = textColor,
                textAlign = TextAlign.Center
            )
        }
    }
}

@Composable
fun MBFacts(mainViewModel: MainViewModel = viewModel()) {
    val factsState = mainViewModel.factsList.collectAsState()

    when (val state = factsState.value) {
        is FactState.Failure -> ErrorScreen(state = state)

        is FactState.Success -> FactsPager(state)
    }

}

@Composable
fun ErrorScreen(state: FactState.Failure, mainViewModel: MainViewModel = viewModel()) {
    Column(
        modifier = Modifier
            .fillMaxSize()
            .padding(12.dp)
            .background(backColorPrimary),
        horizontalAlignment = Alignment.CenterHorizontally,
        verticalArrangement = Arrangement.SpaceEvenly
    ) {
        Text(
            text = state.message,
            style = MaterialTheme.typography.displayLarge,
            color = MaterialTheme.colorScheme.error
        )
        Button(
            onClick = { mainViewModel.reload() }
        ) {
            Text(
                text = "Reload",
                style = MaterialTheme.typography.displayMedium
            )
        }
    }
}

@OptIn(ExperimentalFoundationApi::class)
@Composable
fun FactsPager(state: FactState.Success, mainViewModel: MainViewModel = viewModel()) {
    val pagerState = rememberPagerState()

    HorizontalPager(
        modifier = Modifier
            .fillMaxSize()
            .background(backColorPrimary),
        pageSpacing = 8.dp,
        pageCount = state.response.size,
        state = pagerState
    ) { page ->

        LaunchedEffect(Unit) {
            if (page == state.response.size - 1)
                mainViewModel.getFact()
        }

        if (page < state.response.size)
            PageScreen(page = page, state = state)
    }
}

@Module
@InstallIn(SingletonComponent::class)
object AppModule {

    @Provides
    @Singleton
    fun provideRemoteRepository(
        retrofitApi: RetrofitApi
    ): RemoteRepository = RemoteRepositoryImpl(retrofitApi)

    @Provides
    @Singleton
    fun provideRetrofitInstance(): RetrofitApi {

        val logging = HttpLoggingInterceptor()
        logging.setLevel(HttpLoggingInterceptor.Level.BODY)

        val httpClient = OkHttpClient.Builder()
        httpClient.addInterceptor(logging)

        return Retrofit.Builder()
            .addConverterFactory(GsonConverterFactory.create())
            .baseUrl("https://uselessfacts.jsph.pl/")
            .client(httpClient.build())
            .build()
            .create(RetrofitApi::class.java)
    }
}

sealed class FactState {
    data class Success(val response: List<Response>) : FactState()

    data class Response(val text: String)
    data class Failure(val message: String) : FactState()
}

@HiltViewModel
class MainViewModel @Inject constructor(
    private val remoteRepository: RemoteRepository
) : ViewModel() {

    private val _factsList = MutableStateFlow<FactState>(FactState.Success(listOf()))
    val factsList = _factsList.asStateFlow()

    init {
        getFact()
    }

    fun getFact() {
        viewModelScope.launch {
            try {
                var currentList = (_factsList.value as FactState.Success).response
                currentList += remoteRepository.getData()
                _factsList.value = (_factsList.value as FactState.Success).copy(
                    response = currentList
                )
            } catch (e: Exception) {
                _factsList.value = FactState.Failure(e.localizedMessage)
            }

        }
    }

    fun reload(){
        _factsList.value = FactState.Success(listOf())
        getFact()
    }

}

interface RemoteRepository {

    suspend fun getData(): FactState.Response

}

class RemoteRepositoryImpl @Inject constructor(
    private val retrofitApi: RetrofitApi
) : RemoteRepository {
    override suspend fun getData(): FactState.Response = withContext(Dispatchers.IO) {
        retrofitApi.getFact()
    }
}

interface RetrofitApi {

    @GET("api/v2/facts/random?language=en")
    suspend fun getFact(): FactState.Response
}
"""
    }
}
