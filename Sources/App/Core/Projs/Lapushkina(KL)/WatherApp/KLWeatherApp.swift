//
//  File.swift
//  
//
//  Created by admin on 8/17/23.
//

import Foundation

struct KLWeatherApp: XMLFileProviderProtocol {
    static var fileName = "\(NamesManager.shared.fileName).kt"
    
    static func fileContent(packageName: String, uiSettings: UISettings) -> String {
        return """
package \(packageName).presentation.fragments.main_fragment

import android.content.Context
import android.location.Location
import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import androidx.room.Dao
import androidx.room.Database
import androidx.room.Entity
import androidx.room.Insert
import androidx.room.OnConflictStrategy
import androidx.room.PrimaryKey
import androidx.room.Query
import androidx.room.Room
import androidx.room.RoomDatabase
import com.google.android.gms.location.FusedLocationProviderClient
import com.google.android.gms.location.LocationServices
import com.google.gson.annotations.SerializedName
import \(packageName).R
import dagger.Module
import dagger.Provides
import dagger.hilt.InstallIn
import dagger.hilt.android.lifecycle.HiltViewModel
import dagger.hilt.android.qualifiers.ApplicationContext
import dagger.hilt.components.SingletonComponent
import kotlinx.coroutines.launch
import okhttp3.ResponseBody
import retrofit2.Converter
import retrofit2.Response
import retrofit2.Retrofit
import retrofit2.converter.gson.GsonConverterFactory
import retrofit2.http.GET
import java.sql.Timestamp
import java.text.SimpleDateFormat
import java.util.Date
import java.util.Locale
import java.util.TimeZone
import javax.inject.Inject
import javax.inject.Singleton

@HiltViewModel
class WeatherViewModel @Inject constructor(
    private val repository: Repository,
    private val fusedLocationProviderClient: FusedLocationProviderClient
) : ViewModel() {

    private val _weather = repository.currentWeather
    val weather: LiveData<NetworkResult<WeatherModel>> get() = _weather

    fun getWeather() {
        try {
            fusedLocationProviderClient.lastLocation
                .addOnSuccessListener { location: Location? ->
                    if (location != null) {
                        viewModelScope.launch {
                            repository.loadCurrentWeather(location.latitude, location.longitude)
                        }
                    } else {
                        _weather.value = NetworkResult.Error(null, messageId = R.string.turn_location)
                    }
                }
                .addOnFailureListener {
                    _weather.value = NetworkResult.Error(null, messageId = R.string.no_location)
                }
        } catch (e: SecurityException) {
            _weather.value = NetworkResult.Error(null, messageId = R.string.no_location)
        }
    }
}

data class WeatherModel(
    val dt: String,
    val city: String? = null,
    val temperature: Int,
    val humidity: Int,
    val windSpeed: Int,
    val pressure: Int,
    val name: String
)

sealed class NetworkResult<T>(val data: T? = null, val message: String? = null, val messageId: Int? = null) {
    class Success<T>(data: T): NetworkResult<T>(data)
    class Error<T>(message: String?, data: T? = null, messageId: Int? = null): NetworkResult<T>(data, message, messageId)
    class Loading<T>: NetworkResult<T>()
}

data class APIError(
    @SerializedName("cod")
    val code: Int?,
    @SerializedName("message")
    val message: String?
)

interface Repository {
    val currentWeather: MutableLiveData<NetworkResult<WeatherModel>>
    suspend fun loadCurrentWeather(lat: Double, lon: Double)
}

@Database(entities = [WeatherDbModel::class], version = 1, exportSchema = false)
abstract class AppDatabase : RoomDatabase() {
    abstract fun dao(): WeatherDao
}

@Dao
interface WeatherDao {
    @Query("SELECT * FROM ${WeatherDbModel.TABLE_NAME} LIMIT 1")
    suspend fun getCurrentWeather(): WeatherDbModel

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insertCurrentWeather(currentWeather: WeatherDbModel)
}

@Entity(tableName = WeatherDbModel.TABLE_NAME)
data class WeatherDbModel(
    @PrimaryKey
    val id: Int = ID,
    val dt: Long,
    val city: String,
    val temperature: Int,
    val humidity: Int,
    val windSpeed: Int,
    val pressure: Int,
    val name: String
) {
    companion object {
        const val TABLE_NAME = "weather"
        private const val ID = 1
    }
}

data class WeatherDto(
    @SerializedName("base")
    val base: String?,
    @SerializedName("cod")
    val cod: Int?,
    @SerializedName("coord")
    val coord: Coord?,
    @SerializedName("dt")
    val dt: Long,
    @SerializedName("id")
    val id: Int?,
    @SerializedName("main")
    val main: Main,
    @SerializedName("name")
    val name: String,
    @SerializedName("sys")
    val sys: Sys?,
    @SerializedName("wind")
    val wind: Wind
)

data class Coord(
    @SerializedName("lat")
    val lat: Double?,
    @SerializedName("lon")
    val lon: Double?
)

data class Main(
    @SerializedName("humidity")
    val humidity: Int,
    @SerializedName("pressure")
    val pressure: Int,
    @SerializedName("temp")
    val temp: Double,
)

data class Sys(
    @SerializedName("country")
    val country: String?,
    @SerializedName("id")
    val id: Int?,
    @SerializedName("sunrise")
    val sunrise: Long?,
    @SerializedName("sunset")
    val sunset: Long?,
    @SerializedName("type")
    val type: Int?
)

data class Wind(
    @SerializedName("speed")
    val speed: Double
)

interface ApiService {

    @GET("weather")
    suspend fun getCurrentWeather(
        @retrofit2.http.Query(QUERY_PARAM_LAT) lat: Double = 0.0,
        @retrofit2.http.Query(QUERY_PARAM_LON) lon: Double = 0.0,
        @retrofit2.http.Query(QUERY_PARAM_API_KEY) apiKey: String = "",
        @retrofit2.http.Query(QUERY_PARAM_UNITS) units: String = "metric"
    ): Response<WeatherDto>

    companion object {
        private const val QUERY_PARAM_LON = "lon"
        private const val QUERY_PARAM_LAT = "lat"
        private const val QUERY_PARAM_API_KEY = "APPID"
        private const val QUERY_PARAM_UNITS = "units"
    }
}

class RepositoryImpl @Inject constructor(
    database: AppDatabase,
    private val apiService: ApiService,
    private val errorConverter: Converter<ResponseBody, APIError>,
    private val mapper: WeatherMapper
) : Repository {

    override val currentWeather = MutableLiveData<NetworkResult<WeatherModel>>()

    private val weatherDao = database.dao()

    override suspend fun loadCurrentWeather(lat: Double, lon: Double) {
        currentWeather.postValue(NetworkResult.Loading())
        val response = apiService.getCurrentWeather(apiKey = API_KEY, lat = lat, lon = lon)
        if (response.isSuccessful && response.body() != null) {
            response.body()?.let {
                val weatherDbModel = mapper.mapWeatherDtoToDbModel(it)
                weatherDao.insertCurrentWeather(weatherDbModel)
            }
            val currentWeatherModel = mapper.mapWeatherDbModelToEntity(weatherDao.getCurrentWeather())
            currentWeather.postValue(NetworkResult.Success(currentWeatherModel))
        } else if (response.errorBody() != null) {
            response.errorBody()?.let {
                val apiError = errorConverter.convert(it)
                val currentWeatherModel =
                    mapper.mapWeatherDbModelToEntity(weatherDao.getCurrentWeather())
                currentWeather.postValue(NetworkResult.Error(apiError?.message, currentWeatherModel))
            }
        } else {
            currentWeather.postValue(NetworkResult.Error(null))
        }
    }

    companion object {
        private const val API_KEY = "0fc3826f16107b16185c108c4ff497dc"
    }
}

class WeatherMapper @Inject constructor() {

    fun mapWeatherDbModelToEntity(dbModel: WeatherDbModel) = WeatherModel(
        city = dbModel.city,
        temperature = dbModel.temperature,
        humidity = dbModel.humidity,
        windSpeed = dbModel.windSpeed,
        pressure = convertHPAToMMHG(dbModel.pressure),
        dt = convertTimestampToDate(dbModel.dt),
        name = dbModel.name
    )

    fun mapWeatherDtoToDbModel(dto: WeatherDto) = WeatherDbModel(
        city = dto.name,
        temperature = dto.main.temp.toInt(),
        humidity = dto.main.humidity,
        windSpeed = dto.wind.speed.toInt(),
        pressure = dto.main.pressure,
        dt = dto.dt,
        name = dto.name
    )

    private fun convertTimestampToDate(timestamp: Long?): String {
        if (timestamp == null) return ""
        val stamp = Timestamp(timestamp * 1000)
        val date = Date(stamp.time)
        val sdf = SimpleDateFormat(DATE_TIME_PATTERN, Locale.getDefault())
        sdf.timeZone = TimeZone.getDefault()
        return sdf.format(date)
    }

    private fun convertHPAToMMHG(hpa: Int): Int {
        return (hpa * MMHG_IN_ONE_HPA).toInt()
    }

    companion object {
        private const val MMHG_IN_ONE_HPA = 0.75

        private const val DATE_TIME_PATTERN = "dd-MM HH:mm"
    }
}

@Module
@InstallIn(SingletonComponent::class)
object AppModule {

    private const val BASE_URL = "https://api.openweathermap.org/data/2.5/"

    @Singleton
    @Provides
    fun provideDatabase(@ApplicationContext appContext: Context): AppDatabase {
        return Room
            .databaseBuilder(appContext, AppDatabase::class.java, "database-main")
            .build()
    }

    @Singleton
    @Provides
    fun provideRepository(
        database: AppDatabase,
        apiService: ApiService,
        errorConverter: Converter<ResponseBody, APIError>,
        mapper: WeatherMapper
    ): Repository = RepositoryImpl(database, apiService, errorConverter, mapper)

    @Singleton
    @Provides
    fun provideRetrofit(): Retrofit = Retrofit.Builder()
        .baseUrl(BASE_URL)
        .addConverterFactory(GsonConverterFactory.create())
        .build()

    @Singleton
    @Provides
    fun provideApiService(retrofit: Retrofit): ApiService = retrofit.create(ApiService::class.java)

    @Singleton
    @Provides
    fun provideErrorConverter(retrofit: Retrofit): Converter<ResponseBody, APIError> = retrofit.responseBodyConverter(
        APIError::class.java,
        arrayOfNulls<Annotation>(0)
    )

    @Singleton
    @Provides
    fun provideFusedLocationProvider(
        @ApplicationContext appContext: Context
    ): FusedLocationProviderClient = LocationServices.getFusedLocationProviderClient(appContext)
}
"""
    }
    
    static func dependencies(_ mainData: MainData) -> ANDData {
        return ANDData(mainFragmentData: ANDMainFragment(imports: "", content: ""),
                       mainActivityData: ANDMainActivity(imports: "", extraFunc: "", content: ""),
                       themesData: ANDThemesData(isDefault: true, content: ""),
                       stringsData: ANDStringsData(additional: """
    <string name="temperature">temperature</string>
    <string name="humidity">humidity</string>
    <string name="wind">wind</string>
    <string name="pressure">pressure</string>

    <string name="degrees">%d°C</string>
    <string name="mmHG">%d mmHG</string>
    <string name="m_in_sec">%d m/s</string>
    <string name="percent">%d%%</string>

    <string name="loading">Loading…</string>
    <string name="poor_connection">Poor Internet Connection</string>
    <string name="no_location">App could not get your location…</string>
    <string name="need_location">App needs permission for your location…</string>
    <string name="turn_location">Turn your location on, please.</string>
"""),
                       colorsData: ANDColorsData(additional: """
    <color name="backColorPrimary">#\(mainData.uiSettings.backColorPrimary ?? "FFFFFF")</color>
    <color name="surfaceColor">#\(mainData.uiSettings.surfaceColor ?? "FFFFFF")</color>
    <color name="textColorPrimary">#\(mainData.uiSettings.textColorPrimary ?? "FFFFFF")</color>
    <color name="buttonTextColorPrimary">#\(mainData.uiSettings.buttonTextColorPrimary ?? "FFFFFF")</color>
"""))
    }
    
    static func gradle(_ packageName: String) -> GradleFilesData {
        let projectGradle = """
// Top-level build file where you can add configuration options common to all sub-projects/modules.
plugins {
    id 'com.android.application' version '8.0.2' apply false
    id 'com.android.library' version '8.0.2' apply false
    id 'org.jetbrains.kotlin.android' version '1.8.20' apply false
    id 'com.google.dagger.hilt.android' version '2.44' apply false
}
"""
        let projectGradleName = "build.gradle"
        let moduleGradle = """
plugins {
    id 'com.android.application'
    id 'org.jetbrains.kotlin.android'
    id 'kotlin-kapt'
    id 'dagger.hilt.android.plugin'
}

android {
    namespace '\(packageName)'
    compileSdk 33

    defaultConfig {
        applicationId "\(packageName)"
        minSdk 24
        targetSdk 33
        versionCode 1
        versionName "1.0"

        testInstrumentationRunner "androidx.test.runner.AndroidJUnitRunner"
    }

    buildTypes {
        release {
            minifyEnabled true
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
        viewBinding true
    }
}

dependencies {

    implementation 'androidx.core:core-ktx:1.10.1'
    implementation 'androidx.appcompat:appcompat:1.6.1'
    implementation 'com.google.android.material:material:1.9.0'
    testImplementation 'junit:junit:4.13.2'
    androidTestImplementation 'androidx.test.ext:junit:1.1.5'
    androidTestImplementation 'androidx.test.espresso:espresso-core:3.5.1'

    implementation "com.google.dagger:hilt-android:2.44"
    kapt "com.google.dagger:hilt-android-compiler:2.44"

    implementation "androidx.lifecycle:lifecycle-viewmodel-ktx:2.6.1"
    implementation "androidx.lifecycle:lifecycle-livedata-ktx:2.6.1"

    implementation 'androidx.fragment:fragment-ktx:1.6.0'

    implementation "androidx.room:room-runtime:2.5.2"
    implementation 'com.google.android.material:material:1.9.0'
    kapt("androidx.room:room-compiler:2.5.2")
    implementation "androidx.room:room-ktx:2.5.2"

    implementation 'com.squareup.retrofit2:retrofit:2.9.0'
    implementation 'com.squareup.retrofit2:converter-gson:2.9.0'
    implementation "com.squareup.okhttp3:logging-interceptor:3.9.0"

    implementation 'com.google.android.gms:play-services-location:21.0.1'
}
"""
        let moduleGradleName = "build.gradle"

        let dependencies = ""
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
    
    static func cmfHandler(_ packageName: String) -> ANDMainFragmentCMF {
        return ANDMainFragmentCMF(content: """
package \(packageName).presentation.fragments.main_fragment

import android.Manifest
import android.content.pm.PackageManager
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.activity.result.contract.ActivityResultContracts
import androidx.core.app.ActivityCompat
import androidx.fragment.app.Fragment
import androidx.fragment.app.viewModels
import com.google.android.material.snackbar.Snackbar
import \(packageName).R
import \(packageName).databinding.FragmentMainBinding
import dagger.hilt.android.AndroidEntryPoint

@AndroidEntryPoint
class MainFragment : Fragment() {

    private var _binding: FragmentMainBinding? = null
    private val binding get() = _binding!!

    private val weatherViewModel: WeatherViewModel by viewModels()

    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View {
        _binding = FragmentMainBinding.inflate(inflater, container, false)
        return binding.root
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)

        val permissions = arrayOf(
            Manifest.permission.ACCESS_COARSE_LOCATION,
            Manifest.permission.ACCESS_FINE_LOCATION
        )

        if (ActivityCompat.checkSelfPermission(
                requireActivity(),
                permissions[0]
            ) == PackageManager.PERMISSION_GRANTED || ActivityCompat.checkSelfPermission(
                requireActivity(),
                permissions[1]
            ) == PackageManager.PERMISSION_GRANTED
        ) {
            weatherViewModel.getWeather()
            setViewModelObserver()
        } else {
            activityResultLauncher.launch(permissions[0])
        }
    }

    override fun onDestroy() {
        super.onDestroy()
        _binding = null
    }

    private var activityResultLauncher = registerForActivityResult(
        ActivityResultContracts.RequestPermission()
    ) { isGranted ->
        if (isGranted) {
            weatherViewModel.getWeather()
            setViewModelObserver()
        } else {
            Snackbar.make(binding.root, getString(R.string.need_location), Snackbar.LENGTH_LONG).show()
        }
    }

    private fun setViewModelObserver() {
        weatherViewModel.weather.observe(viewLifecycleOwner) { result ->
            when (result) {
                is NetworkResult.Success -> {
                    result.data?.let {
                        setCurrentWeather(it)
                    }
                }
                is NetworkResult.Error -> {
                    result.data?.let {
                        setCurrentWeather(it)
                    }
                    result.message?.let {
                        Snackbar.make(binding.root, result.message.toString(), Snackbar.LENGTH_LONG).show()
                    }
                    result.messageId?.let {
                        Snackbar.make(binding.root, getString(it), Snackbar.LENGTH_LONG).show()
                    }
                }
                is NetworkResult.Loading -> {
                    Snackbar.make(binding.root, getString(R.string.loading), Snackbar.LENGTH_SHORT).show()
                }
            }
        }
    }

    private fun setCurrentWeather(currentWeather: WeatherModel) {
        val tempTemplate = this.resources.getString(R.string.degrees)
        val pressureTemplate = this.resources.getString(R.string.mmHG)
        val humidityTemplate = this.resources.getString(R.string.percent)
        val windTemplate = this.resources.getString(R.string.m_in_sec)

        with(binding) {
            with(currentWeather) {
                tvTemperature.text = String.format(tempTemplate, temperature)
                tvPressure.text = String.format(pressureTemplate, pressure)
                tvCity.text = name
                tvHumidity.text = String.format(humidityTemplate, humidity)
                tvWind.text = String.format(windTemplate, windSpeed)
            }
        }
    }
}
""", fileName: "MainFragment.kt")
    }
    
    static func layout(_ uiSettings: UISettings) -> [XMLLayoutData] {
        let mainFragmentContent = """
<?xml version="1.0" encoding="utf-8"?>
<androidx.constraintlayout.widget.ConstraintLayout xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:app="http://schemas.android.com/apk/res-auto"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    android:paddingHorizontal="@dimen/layout_padding_horizontal"
    android:paddingVertical="@dimen/layout_padding_vertical"
    android:background="@color/backColorPrimary">

    <TextView
        android:id="@+id/tv_city"
        android:layout_width="wrap_content"
        android:layout_height="wrap_content"
        android:fontFamily="monospace"
        android:textColor="@color/textColorPrimary"
        android:textSize="@dimen/text_size_32sp"
        app:layout_constraintEnd_toEndOf="parent"
        app:layout_constraintStart_toStartOf="parent"
        app:layout_constraintTop_toTopOf="parent" />


    <androidx.cardview.widget.CardView
        android:id="@+id/weatherCard"
        style="@style/WeatherInfoCard"
        android:background="@drawable/weather_border"
        app:layout_constraintBottom_toTopOf="@+id/humidityCard"
        app:layout_constraintEnd_toEndOf="parent"
        app:layout_constraintStart_toStartOf="parent"
        app:layout_constraintTop_toBottomOf="@+id/tv_city"
        app:layout_constraintVertical_chainStyle="packed">

        <LinearLayout style="@style/CardLayout">

            <TextView
                style="@style/WeatherInfoTitle"
                android:text="@string/temperature" />

            <TextView
                android:id="@+id/tv_temperature"
                style="@style/WeatherInfo" />
        </LinearLayout>
    </androidx.cardview.widget.CardView>

    <androidx.cardview.widget.CardView
        android:id="@+id/humidityCard"
        style="@style/WeatherInfoCard"
        app:layout_constraintBottom_toTopOf="@+id/windCard"
        app:layout_constraintEnd_toEndOf="parent"
        app:layout_constraintStart_toStartOf="parent"
        app:layout_constraintTop_toBottomOf="@+id/weatherCard">

        <LinearLayout style="@style/CardLayout">

            <TextView
                style="@style/WeatherInfoTitle"
                android:text="@string/humidity" />

            <TextView
                android:id="@+id/tv_humidity"
                style="@style/WeatherInfo" />
        </LinearLayout>
    </androidx.cardview.widget.CardView>

    <androidx.cardview.widget.CardView
        android:id="@+id/windCard"
        style="@style/WeatherInfoCard"
        app:layout_constraintBottom_toTopOf="@+id/pressureCard"
        app:layout_constraintEnd_toEndOf="parent"
        app:layout_constraintStart_toStartOf="parent"
        app:layout_constraintTop_toBottomOf="@+id/humidityCard">

        <LinearLayout style="@style/CardLayout">

            <TextView
                style="@style/WeatherInfoTitle"
                android:text="@string/wind" />

            <TextView
                android:id="@+id/tv_wind"
                style="@style/WeatherInfo" />
        </LinearLayout>
    </androidx.cardview.widget.CardView>

    <androidx.cardview.widget.CardView
        android:id="@+id/pressureCard"
        style="@style/WeatherInfoCard"
        app:layout_constraintBottom_toBottomOf="parent"
        app:layout_constraintEnd_toEndOf="parent"
        app:layout_constraintStart_toStartOf="parent"
        app:layout_constraintTop_toBottomOf="@+id/windCard">

        <LinearLayout style="@style/CardLayout">

            <TextView
                style="@style/WeatherInfoTitle"
                android:text="@string/pressure" />

            <TextView
                android:id="@+id/tv_pressure"
                style="@style/WeatherInfo" />
        </LinearLayout>
    </androidx.cardview.widget.CardView>

</androidx.constraintlayout.widget.ConstraintLayout>
"""
        let mainFragmentName = "fragment_main.xml"
        return [XMLLayoutData(content: mainFragmentContent, name: mainFragmentName)]
    }
    
    static func dimens(_ uiSettings: UISettings) -> XMLLayoutData {
        return XMLLayoutData(content: """
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <dimen name="layout_padding_horizontal">50dp</dimen>
    <dimen name="layout_padding_vertical">30dp</dimen>

    <dimen name="card_corner_radius">10dp</dimen>
    <dimen name="card_padding_vertical">10dp</dimen>
    <dimen name="card_padding_horizontal">20dp</dimen>
    <dimen name="card_margin_bottom">10dp</dimen>

    <dimen name="card_width_landscape">300dp</dimen>

    <dimen name="border_stroke">2dp</dimen>

    <dimen name="text_size_16sp">16sp</dimen>
    <dimen name="text_size_24sp">24sp</dimen>
    <dimen name="text_size_32sp">32sp</dimen>

    <dimen name="top_margin_8dp">8dp</dimen>

</resources>
""", name: "dimens.xml")
    }
    
    static func styles() -> XMLLayoutData {
        return XMLLayoutData(content: """
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <style name="WeatherInfoCard">
        <item name="android:layout_height">wrap_content</item>
        <item name="android:layout_width">match_parent</item>
        <item name="cardCornerRadius">@dimen/card_corner_radius</item>
        <item name="android:layout_marginBottom">@dimen/card_margin_bottom</item>
    </style>

    <style name="CardLayout">
        <item name="android:layout_height">wrap_content</item>
        <item name="android:layout_width">match_parent</item>
        <item name="android:orientation">vertical</item>
        <item name="android:gravity">center</item>
        <item name="android:background">@drawable/weather_border</item>
        <item name="android:padding">@dimen/top_margin_8dp</item>
    </style>

    <style name="WeatherInfoTitle">
        <item name="android:textSize">@dimen/text_size_16sp</item>
        <item name="android:fontFamily">monospace</item>
        <item name="android:textColor">@color/surfaceColor</item>
        <item name="android:layout_height">wrap_content</item>
        <item name="android:layout_width">wrap_content</item>
    </style>

    <style name="WeatherInfo">
        <item name="android:textSize">@dimen/text_size_32sp</item>
        <item name="android:fontFamily">monospace</item>
        <item name="android:textColor">@color/surfaceColor</item>
        <item name="android:layout_height">wrap_content</item>
        <item name="android:layout_width">wrap_content</item>
    </style>
</resources>
""", name: "styles.xml")
    }
}
