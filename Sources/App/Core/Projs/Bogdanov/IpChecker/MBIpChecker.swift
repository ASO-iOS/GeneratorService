//
//  File.swift
//  
//
//  Created by admin on 20.06.2023.
//

import Foundation

struct MBIpChecker {
    static let fileName = "MBIpChecker.kt"
    
    static func fileText(packageName: String) -> String {
        return """
package \(packageName).presentation.fragments.main_fragment

import android.annotation.SuppressLint
import android.content.Context
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.annotation.Keep
import androidx.fragment.app.Fragment
import androidx.fragment.app.viewModels
import androidx.lifecycle.Lifecycle
import androidx.lifecycle.LifecycleCoroutineScope
import androidx.lifecycle.LifecycleOwner
import androidx.lifecycle.ViewModel
import androidx.lifecycle.lifecycleScope
import androidx.lifecycle.repeatOnLifecycle
import androidx.lifecycle.viewModelScope
import androidx.recyclerview.widget.RecyclerView
import androidx.room.Dao
import androidx.room.Database
import androidx.room.Entity
import androidx.room.Insert
import androidx.room.OnConflictStrategy
import androidx.room.PrimaryKey
import androidx.room.Query
import androidx.room.Room
import androidx.room.RoomDatabase
import \(packageName).R
import \(packageName).databinding.FragmentHistoryBinding
import \(packageName).databinding.FragmentMainBinding
import \(packageName).databinding.RvHistoryDataItemBinding
import dagger.Module
import dagger.Provides
import dagger.hilt.InstallIn
import dagger.hilt.android.AndroidEntryPoint
import dagger.hilt.android.lifecycle.HiltViewModel
import dagger.hilt.android.qualifiers.ApplicationContext
import dagger.hilt.components.SingletonComponent
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.launch
import kotlinx.coroutines.runBlocking
import okhttp3.OkHttpClient
import okhttp3.logging.HttpLoggingInterceptor
import retrofit2.Retrofit
import retrofit2.converter.gson.GsonConverterFactory
import retrofit2.http.GET
import retrofit2.http.Path
import java.util.UUID
import javax.inject.Inject
import javax.inject.Singleton

interface RetrofitApi {

    @GET("{id}?fields=message,country,city,timezone,query")
    suspend fun getDataById(@Path("id") id: String): GeoDto

}

sealed class RequestScreenState {

    class Success(val data: GeoEntity) : RequestScreenState()

    class Failure(val message: String) : RequestScreenState()

    object Loading : RequestScreenState()
}

class RemoteDataSourceImpl @Inject constructor(
    private val retrofitApi: RetrofitApi,
) : RemoteDataSource {

    override suspend fun getGeoData(id: String): GeoDto {
        return retrofitApi.getDataById(id)
    }

}

interface RemoteDataSource {

    suspend fun getGeoData(id: String): GeoDto

}

class RecyclerViewHistoryDataAdapter :
    RecyclerView.Adapter<RecyclerViewHistoryDataAdapter.MyViewHolder>() {

    private var historyEntityList: List<HistoryEntity> = listOf()

    inner class MyViewHolder(val binding: RvHistoryDataItemBinding) :
        RecyclerView.ViewHolder(binding.root)

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): MyViewHolder {
        val binding = RvHistoryDataItemBinding
            .inflate(LayoutInflater.from(parent.context), parent, false)
        return MyViewHolder(binding)
    }

    override fun onBindViewHolder(holder: MyViewHolder, position: Int) = with(holder) {
        val context = binding.root.context
        val positionEntity = historyEntityList[position]

        with(binding) {
            tvCountryHistory.text = context.getString(R.string.country, positionEntity.country)
            tvCityHistory.text = context.getString(R.string.city, positionEntity.city)
            tvTimezoneHistory.text = context.getString(R.string.timezone, positionEntity.timezone)
            tvQueryHistory.text = context.getString(R.string.query, positionEntity.query)
        }
    }

    override fun getItemCount(): Int = historyEntityList.size

    @SuppressLint("NotifyDataSetChanged")
    fun update(newData: List<HistoryEntity>) {
        historyEntityList = newData
        notifyDataSetChanged()
    }
}


class PutLocalHistoryUseCase @Inject constructor(
    private val repository: MainRepository,
) {
    suspend operator fun invoke(historyEntity: HistoryEntity): LocalResponse =
        repository.putLocalData(historyEntity)

}

object PresentationMapper {

    fun mapGeoEntityToHistoryEntity(geoEntity: GeoEntity): HistoryEntity = with(geoEntity) {
        return HistoryEntity(
            query = query,
            country = country,
            city = city,
            timezone = timezone,
            message = message
        )
    }

}

@HiltViewModel
class MainViewModel @Inject constructor(
    private val getRemoteGeoDataUseCase: GetRemoteGeoDataUseCase,
    private val putLocalHistoryUseCase: PutLocalHistoryUseCase,
) : ViewModel() {

    private val _screenState: MutableStateFlow<RequestScreenState> =
        MutableStateFlow(RequestScreenState.Loading)
    val screenState: StateFlow<RequestScreenState> = _screenState

    fun getData(id: String) {
        viewModelScope.launch {
            _screenState.value = RequestScreenState.Loading
            when (val response = getRemoteGeoDataUseCase(id)) {
                is GeoResponse.Failure -> {
                    failureGeoResponse(response)
                }

                is GeoResponse.Success -> {
                    successGeoResponse(response)
                }
            }
        }
    }

    private fun successGeoResponse(response: GeoResponse.Success) {
        val geoEntity = response.data as GeoEntity
        val historyEntity = PresentationMapper.mapGeoEntityToHistoryEntity(geoEntity)
        when (val localResponse = insertData(historyEntity)) {
            is LocalResponse.Error -> {
                _screenState.value = RequestScreenState.Failure(message = localResponse.message)
            }

            is LocalResponse.Failure -> {
                _screenState.value = RequestScreenState.Failure(message = localResponse.message)
            }

            LocalResponse.Success -> {
                _screenState.value = RequestScreenState.Success(data = geoEntity)
            }
        }
    }

    private fun failureGeoResponse(response: GeoResponse.Failure) {
        _screenState.value = RequestScreenState.Failure(message = response.message)
    }

    private fun insertData(historyEntity: HistoryEntity): LocalResponse {
        var localResponse: LocalResponse

        runBlocking {
            localResponse = putLocalHistoryUseCase(historyEntity)
        }

        return localResponse
    }

}

class MainRepositoryImpl @Inject constructor(
    private val localDataSource: LocalDataSource,
    private val remoteDataSource: RemoteDataSource,
) : MainRepository {

    override suspend fun getRemoteData(id: String): GeoResponse {
        return try {
            val dto = remoteDataSource.getGeoData(id)
            val geoEntity = GeoMapper.mapGeoDtoToGeoEntity(dto)
            GeoResponse.Success(data = geoEntity)
        } catch (e: Exception) {
            GeoResponse.Failure(message = e.localizedMessage)
        }
    }

    override suspend fun getLocalData(): List<HistoryEntity> {
        val dtoList = localDataSource.getAllHistoryFromDatabase()
        val historyList: MutableList<HistoryEntity> = mutableListOf()
        for (dto in dtoList) {
            historyList += HistoryMapper.mapHistoryDtoToHistoryEntity(dto)
        }
        return historyList.toList()
    }

    override suspend fun putLocalData(historyEntity: HistoryEntity): LocalResponse {
        val historyDto = HistoryMapper.mapHistoryEntityToHistoryDto(historyEntity)
        var response: LocalResponse = LocalResponse.Error()

        runCatching {
            localDataSource.insertHistoryItemInDatabase(historyDto)
        }.onSuccess {
            response = LocalResponse.Success
        }.onFailure {throwable ->
            response = LocalResponse.Failure(message = throwable.localizedMessage)
        }

        return response
    }
}

interface MainRepository {

    suspend fun getRemoteData(id: String): GeoResponse

    suspend fun getLocalData(): List<HistoryEntity>

    suspend fun putLocalData(historyEntity: HistoryEntity): LocalResponse

}

sealed class LocalResponse {

    object Success : LocalResponse()

    data class Failure(val message: String) : LocalResponse()

    data class Error(val message: String = "There was some error") : LocalResponse()
    //default value when there is no success or failure

}

class LocalDataSourceImpl(
    private val appIpDatabase: IpDatabase,
) : LocalDataSource {
    override suspend fun getAllHistoryFromDatabase(): List<HistoryDto> {
        return appIpDatabase.noteDao().getAllData()
    }

    override suspend fun insertHistoryItemInDatabase(dto: HistoryDto) {
        appIpDatabase.noteDao().insert(dto)
    }
}

interface LocalDataSource {

    suspend fun getAllHistoryFromDatabase(): List<HistoryDto>

    suspend fun insertHistoryItemInDatabase(dto: HistoryDto)

}


@HiltViewModel
class HistoryViewModel @Inject constructor(
    private val getLocalHistoryUseCase: GetLocalHistoryUseCase,
) : ViewModel() {

    private val _history: MutableStateFlow<List<HistoryEntity>> =
        MutableStateFlow(listOf())
    val history: StateFlow<List<HistoryEntity>> = _history

    fun getData() {
        viewModelScope.launch {
            _history.value = getLocalHistoryUseCase().asReversed()
        }
    }
}

object HistoryMapper {

    fun mapHistoryDtoToHistoryEntity(historyDto: HistoryDto): HistoryEntity = with(historyDto) {
        return HistoryEntity(
            query = query,
            country = country,
            city = city,
            timezone = timezone,
            message = message
        )
    }

    fun mapHistoryEntityToHistoryDto(historyEntity: HistoryEntity): HistoryDto =
        with(historyEntity) {
            return HistoryDto(
                query = query,
                country = country,
                city = city,
                timezone = timezone,
                message = message
            )
        }

}

data class HistoryEntity(
    val id: String = UUID.randomUUID().toString(),
    val query: String,
    val country: String,
    val city: String,
    val timezone: String,
    val message: String? = null,
)

@Keep
@Entity(tableName = "history")
data class HistoryDto(
    @PrimaryKey
    val id: String = UUID.randomUUID().toString(),
    val query: String,
    val country: String,
    val city: String,
    val timezone: String,
    val message: String? = null,
)

class GetRemoteGeoDataUseCase @Inject constructor(
    private val repository: MainRepository,
) {
    suspend operator fun invoke(id: String) = repository.getRemoteData(id)
}

class GetLocalHistoryUseCase @Inject constructor(
    private val repository: MainRepository,
) {
    suspend operator fun invoke(): List<HistoryEntity> = repository.getLocalData()
}

sealed class GeoResponse {

    data class Success(val data: Any) : GeoResponse()

    data class Failure(val message: String) : GeoResponse()

}

object GeoMapper {

    fun mapGeoDtoToGeoEntity(geoDto: GeoDto): GeoEntity = with(geoDto) {
        return GeoEntity(
            query = query,
            country = country,
            city = city,
            timezone = timezone,
            message = message
        )
    }

}

data class GeoEntity(
    val id: String = UUID.randomUUID().toString(),
    val query: String,
    val country: String,
    val city: String,
    val timezone: String,
    val message: String? = null,
)

@Keep
data class GeoDto(
    @PrimaryKey
    val id: String = UUID.randomUUID().toString(),
    val query: String,
    val country: String,
    val city: String,
    val timezone: String,
    val message: String? = null,
)

fun LifecycleCoroutineScope.launchCoroutine(
    lifecycle: Lifecycle.State = Lifecycle.State.STARTED,
    lifecycleOwner: LifecycleOwner,
    function: suspend () -> Unit,
) {
    launch {
        lifecycleOwner.repeatOnLifecycle(lifecycle) {
            function()
        }
    }
}

@Database(entities = [HistoryDto::class], version = 1)
abstract class IpDatabase : RoomDatabase() {
    abstract fun noteDao(): AppDao
}

@Module
@InstallIn(SingletonComponent::class)
object AppModule {

    @Provides
    @Singleton
    fun provideRetrofitInstance(): RetrofitApi {

        val logging = HttpLoggingInterceptor()
        logging.setLevel(HttpLoggingInterceptor.Level.BODY)

        val httpClient = OkHttpClient.Builder()
        httpClient.addInterceptor(logging)

        return Retrofit.Builder()
            .addConverterFactory(GsonConverterFactory.create())
            .baseUrl("http://ip-api.com/json/")
            .client(httpClient.build())
            .build()
            .create(RetrofitApi::class.java) as RetrofitApi
    }

    @Provides
    @Singleton
    fun provideLocalDataSource(appIpDatabase: IpDatabase): LocalDataSource =
        LocalDataSourceImpl(appIpDatabase)

    @Provides
    @Singleton
    fun providesRemoteDataSource(retrofitApi: RetrofitApi): RemoteDataSource =
        RemoteDataSourceImpl(retrofitApi)

    @Provides
    @Singleton
    fun provideMainRepository(
        localDataSource: LocalDataSource,
        remoteDataSource: RemoteDataSource,
    ): MainRepository =
        MainRepositoryImpl(
            localDataSource = localDataSource,
            remoteDataSource = remoteDataSource
        )

    @Singleton
    @Provides
    fun provideAppDatabase(@ApplicationContext appContext: Context): IpDatabase {
        return Room
            .databaseBuilder(appContext, IpDatabase::class.java, "geo-database")
            .build()
    }

}

@Dao
interface AppDao {

    @Query("SELECT * FROM history")
    suspend fun getAllData(): List<HistoryDto>

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insert(historyDto: HistoryDto)

}


"""
    }
}
