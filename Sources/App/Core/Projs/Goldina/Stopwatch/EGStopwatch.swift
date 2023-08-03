//
//  File.swift
//  
//
//  Created by admin on 03.08.2023.
//

import Foundation

struct EGStopwatch: XMLFileProviderProtocol {
    static var fileName: String = "EGStopwatch.kt"
    
    static func fileContent(packageName: String, uiSettings: UISettings) -> String {
        return """
package \(packageName).presentation.fragments.main_fragment

import android.app.Service
import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import android.os.IBinder
import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.setValue
import androidx.lifecycle.ViewModel
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
import \(packageName).databinding.ItemLapBinding
import dagger.Module
import dagger.Provides
import dagger.hilt.InstallIn
import dagger.hilt.android.lifecycle.HiltViewModel
import dagger.hilt.android.qualifiers.ApplicationContext
import dagger.hilt.components.SingletonComponent
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.MutableSharedFlow
import kotlinx.coroutines.flow.asSharedFlow
import kotlinx.coroutines.flow.launchIn
import kotlinx.coroutines.flow.onEach
import kotlinx.coroutines.launch
import java.util.Timer
import java.util.TimerTask
import javax.inject.Inject
import javax.inject.Singleton


@Entity(tableName = "laps")
data class LapModel(
    @PrimaryKey(autoGenerate = false)
    val number: Int,
    val time: String,
)

@Database(entities = [LapModel::class], version = 1)
abstract class LapDatabase : RoomDatabase() {
    abstract fun dao(): LapDao
}

@Module
@InstallIn(SingletonComponent::class)
object AppModule {
    @Singleton
    @Provides
    fun provideDatabase(@ApplicationContext appContext: Context): LapDatabase {
        return Room
            .databaseBuilder(appContext, LapDatabase::class.java, "lap_database")
            .build()
    }

    @Singleton
    @Provides
    fun provideRepository(database: LapDatabase): LocalRepository = LocalRepositoryImpl(database)

    @Singleton
    @Provides
    fun provideSharedPreferences(
        @ApplicationContext context: Context
    ): SharedPreferences = context.getSharedPreferences(
        TimerService.TIME_EXTRA,
        Context.MODE_PRIVATE
    )
}

interface LocalRepository {

    fun getData(): Flow<List<LapModel>>

    suspend fun putData(lapItem: LapModel)

    suspend fun deleteData()

}

class LocalRepositoryImpl @Inject constructor(
    private val database: LapDatabase
) : LocalRepository {

    override fun getData(): Flow<List<LapModel>> =
        database.dao().getAllLaps()

    override suspend fun putData(lapItem: LapModel) =
        database.dao().insertLapIntoDatabase(lapItem)


    override suspend fun deleteData() =
        database.dao().removeAllFromDatabase()

}

@HiltViewModel
class MainViewModel @Inject constructor(
    private val localRepository: LocalRepository,
    private val sharedPrefs: SharedPreferences
) : ViewModel() {

    private val _laps = MutableSharedFlow<List<LapModel>>()
    val laps = _laps.asSharedFlow()

    var timeStarted by mutableStateOf(sharedPrefs.getBoolean(TimerService.TIME_UPDATED, false))
        private set

    fun timerChanged() {
        timeStarted = !timeStarted
        sharedPrefs.edit().putBoolean(TimerService.TIME_UPDATED, timeStarted).apply()
    }


    private fun updateList() {
        localRepository.getData()
            .onEach {
                _laps.emit(it)
            }
            .launchIn(viewModelScope)
    }

    fun addLap(lapItem: LapModel) {
        viewModelScope.launch {
            localRepository.putData(lapItem)
            updateList()
        }
    }

    fun removeAll() {
        viewModelScope.launch {
            localRepository.deleteData()
            updateList()
        }
    }

}


class TimerService : Service() {
    override fun onBind(intent: Intent?): IBinder? = null

    private val timer= Timer()

    override fun onStartCommand(intent: Intent, flags: Int, startId: Int): Int {

        val time = intent.getDoubleExtra(TIME_EXTRA,0.0)
        timer.scheduleAtFixedRate( MyTimerTask(time),0,1000)
        return START_STICKY
    }

    override fun onDestroy() {
        timer.cancel()
        super.onDestroy()
    }

    private inner class MyTimerTask(private var time:Double) : TimerTask(){
        override fun run() {
            val intent = Intent(TIME_UPDATED)
            time++
            intent.putExtra(TIME_EXTRA,time)
            sendBroadcast(intent)
        }

    }

    companion object{
        const val  TIME_EXTRA = "timeExtra"
        const val TIME_UPDATED ="timeUpdated"
    }

}

class LapAdapter(private val items: List<LapModel>): RecyclerView.Adapter<LapAdapter.LapViewHolder>() {


    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): LapViewHolder {
        return LapViewHolder(ItemLapBinding.inflate(LayoutInflater.from(parent.context)))
    }

    override fun getItemCount(): Int = items.size

    override fun onBindViewHolder(holder: LapViewHolder, position: Int) {
        holder.bind(items[position])
    }

    inner class LapViewHolder(private val binding: ItemLapBinding): RecyclerView.ViewHolder(binding.root) {
        fun bind(lap: LapModel)=with(itemView){
            binding.tvNumberLap.text = context.getString(R.string.lap_template,lap.number)
            binding.tvTimeLap.text= lap.time
        }
    }
}


@Dao
interface LapDao {

    @Query("SELECT * FROM laps")
    fun getAllLaps(): Flow<List<LapModel>>

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insertLapIntoDatabase(recordingItem: LapModel)

    @Query("DELETE FROM laps")
    suspend fun removeAllFromDatabase()
}
"""
    }
    
    static func dependencies(_ mainData: MainData) -> ANDData {
        return ANDData(mainFragmentData: ANDMainFragment(imports: "", content: ""), mainActivityData: ANDMainActivity(imports: "", extraFunc: "", content: ""), themesData: ANDThemesData(isDefault: true, content: ""), stringsData: ANDStringsData(additional: """
    <string name="start_time">00:00:00</string>
    <string name="start_btn">start</string>
    <string name="stop_btn">stop</string>
    <string name="reset_btn">reset</string>

    <string name="time_template">%1$s:%2$s:%3$s</string>
    <string name="lap_template">Lap %1$d</string>
    <string name="lap_btn">lap</string>
    <string name="with_0">0%s</string>
"""), colorsData: ANDColorsData(additional: """
    <color name="buttonTextColorPrimary">#FF\(mainData.uiSettings.buttonTextColorPrimary ?? "FFFFFF")</color>
    <color name="backColorPrimary">#FF\(mainData.uiSettings.backColorPrimary ?? "FFFFFF")</color>
    <color name="textColorPrimary">#\(mainData.uiSettings.textColorPrimary ?? "FFFFFF")</color>
    <color name="buttonColorPrimary">#FF\(mainData.uiSettings.buttonColorPrimary ?? "FFFFFF")</color>
"""))
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
            signingConfig signingConfigs.debug
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
        viewBinding true
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
    implementation Dependencies.okhttp
    implementation Dependencies.okhttp_login_interceptor
    kapt Dependencies.dagger_hilt_compiler
    kapt Dependencies.hilt_viewmodel_compiler
    kapt Dependencies.room_compiler
    implementation Dependencies.room_ktx
    implementation Dependencies.room_runtime

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
    
    static func cmfHandler(_ packageName: String) -> ANDMainFragmentCMF {
        return ANDMainFragmentCMF(content: """
package \(packageName).presentation.fragments.main_fragment

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.core.content.ContextCompat.RECEIVER_NOT_EXPORTED
import androidx.core.content.ContextCompat.registerReceiver
import androidx.fragment.app.Fragment
import androidx.fragment.app.viewModels
import androidx.lifecycle.Lifecycle
import androidx.lifecycle.lifecycleScope
import androidx.lifecycle.repeatOnLifecycle
import androidx.recyclerview.widget.DividerItemDecoration
import androidx.recyclerview.widget.LinearLayoutManager
import \(packageName).R
import \(packageName).databinding.FragmentMainBinding
import dagger.hilt.android.AndroidEntryPoint
import kotlinx.coroutines.launch
import kotlin.math.roundToInt


@AndroidEntryPoint
class MainFragment : Fragment() {
    private lateinit var binding: FragmentMainBinding
    private lateinit var adapter : LapAdapter
    private var timerStarted:Boolean = false
    private lateinit var serviceIntent: Intent
    private var time = 0.0
    private var sizeList = 0
    private val viewModel: MainViewModel by viewModels()
    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View {
        super.onCreateView(inflater, container, savedInstanceState)
        binding = FragmentMainBinding.inflate(layoutInflater)

        timerStarted = viewModel.timeStarted
        if (timerStarted){
            binding.btnStartStop.text = getString(R.string.stop_btn)
            binding.btnReset.text = getString(R.string.lap_btn)
            binding.tvTime.text = getStringTime(time)

        }
        updateRV()
        return binding.root
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        binding.btnStartStop.setOnClickListener {
            timerStartStop()
        }
        binding.btnReset.setOnClickListener {
            timerReset()
        }
        serviceIntent =Intent(context, TimerService::class.java)
        registerReceiver(requireContext(),updateTime, IntentFilter(TimerService.TIME_UPDATED),RECEIVER_NOT_EXPORTED)

    }

    private fun timerReset() {
        if (timerStarted){
            viewModel.addLap(LapModel(sizeList++,getStringTime(time)))
        }else {
            viewModel.removeAll()
            time=0.0
            sizeList = 0
            binding.tvTime.text = getStringTime(time)
        }
        updateRV()
    }

    private fun updateRV() {
        binding.rvLap.addItemDecoration(
            DividerItemDecoration(
                context,
                LinearLayoutManager.VERTICAL
            )
        )
        viewLifecycleOwner.lifecycleScope.launch {
            viewLifecycleOwner.repeatOnLifecycle(Lifecycle.State.STARTED){
                viewModel.laps.collect {
                    sizeList = it.size
                    adapter = LapAdapter(it)
                    binding.rvLap.adapter = adapter
                }
            }
        }
    }

    private fun timerStartStop() {
        if(timerStarted)
            timerStop()
        else timerStart()
    }

    private fun timerStart() {
        serviceIntent.putExtra(TimerService.TIME_EXTRA,time)
        context?.startService(serviceIntent)
        binding.btnReset.text = getString(R.string.lap_btn)
        binding.btnStartStop.text = getString(R.string.stop_btn)
        timerStarted = true
        viewModel.timerChanged()
    }

    private fun timerStop() {
        context?.stopService(serviceIntent)
        binding.btnReset.text = getString(R.string.reset_btn)
        binding.btnStartStop.text = getString(R.string.start_btn)
        timerStarted = false
        viewModel.timerChanged()
    }

    private val updateTime:BroadcastReceiver = object : BroadcastReceiver()
    {
        override fun onReceive(p0: Context?, p1: Intent) {
            time = p1.getDoubleExtra(TimerService.TIME_EXTRA,0.0)
            binding.tvTime.text = getStringTime(time) }

    }

    private fun getStringTime(time:Double): String {
        val resultTime = time.roundToInt()
        var hours = (resultTime % 86400/3600).toString()
        var minutes=(resultTime % 86400 % 3600/60).toString()
        var seconds = (resultTime % 86400 % 3600 % 60).toString()
        if (hours.length<2) hours = getString(R.string.with_0,hours)
        if (minutes.length<2) minutes = getString(R.string.with_0,minutes)
        if (seconds.length<2) seconds = getString(R.string.with_0,seconds)
        return getString(R.string.time_template,hours,minutes,seconds)
    }
}
""", fileName: "MainFragment.kt")
    }
    
    static func layout(_ uiSettings: UISettings) -> [XMLLayoutData] {
        let fragmentMainContent = """
<?xml version="1.0" encoding="utf-8"?>
<LinearLayout xmlns:android="http://schemas.android.com/apk/res/android"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    xmlns:app="http://schemas.android.com/apk/res-auto"
    android:orientation="vertical"
    xmlns:tools="http://schemas.android.com/tools"
    android:background="@color/backColorPrimary"
    tools:context=".presentation.fragments.main_fragment.MainFragment">

    <TextView
        android:id="@+id/tvTime"
        android:layout_width="match_parent"
        android:layout_height="wrap_content"
        android:layout_marginTop="@dimen/margin_80dp"
        android:text="@string/start_time"
        android:textSize="@dimen/textSizePrimary"
        android:textColor="@color/textColorPrimary"
        android:textAlignment="center" />
    <LinearLayout
        android:layout_width="match_parent"
        android:layout_height="wrap_content"
        android:orientation="horizontal"
        android:gravity="center_horizontal">

        <com.google.android.material.button.MaterialButton
            android:id="@+id/btnStartStop"
            android:layout_width="wrap_content"
            android:layout_height="wrap_content"
            android:textColor="@color/buttonTextColorPrimary"
            android:backgroundTint="@color/buttonColorPrimary"
            android:layout_margin="@dimen/button_margin"
            android:text="@string/start_btn"/>

        <com.google.android.material.button.MaterialButton
            android:id="@+id/btnReset"
            android:layout_width="wrap_content"
            android:layout_height="wrap_content"
            android:textColor="@color/buttonTextColorPrimary"
            android:backgroundTint="@color/buttonColorPrimary"
            android:layout_margin="@dimen/button_margin"
            android:text="@string/reset_btn"/>

    </LinearLayout>

    <androidx.recyclerview.widget.RecyclerView
        android:id="@+id/rvLap"
        android:layout_width="match_parent"
        android:layout_height="wrap_content"
        app:layoutManager="androidx.recyclerview.widget.LinearLayoutManager"
        app:reverseLayout="true"
        android:orientation="vertical"
        android:layout_margin="@dimen/rv_margin" />

</LinearLayout>
"""
        
        let fragmentMainName = "fragment_main.xml"
        
        let itemContent = """
<?xml version="1.0" encoding="utf-8"?>
<LinearLayout
    xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:app="http://schemas.android.com/apk/res-auto"
    android:layout_width="match_parent"
    android:layout_height="wrap_content"
    android:orientation="vertical"
    android:layout_margin="@dimen/item_margin">

<androidx.cardview.widget.CardView
    android:layout_width="match_parent"
    android:layout_height="wrap_content">

    <androidx.constraintlayout.widget.ConstraintLayout
        android:layout_width="match_parent"
        android:layout_height="wrap_content"
        android:background="@color/backColorPrimary"
        android:padding="@dimen/rv_margin">

        <TextView
            android:id="@+id/tvNumberLap"
            android:layout_width="wrap_content"
            android:layout_height="wrap_content"
            android:layout_marginEnd="@dimen/margin_100dp"
            android:text="@string/lap_template"
            android:textSize="@dimen/textSizeSecondary"
            app:layout_constraintBottom_toBottomOf="parent"
            app:layout_constraintEnd_toStartOf="@id/tvTimeLap"
            app:layout_constraintHorizontal_bias="0.0"
            app:layout_constraintStart_toStartOf="parent"
            app:layout_constraintTop_toTopOf="parent"
            android:textColor="@color/textColorPrimary"/>

        <TextView
            android:id="@+id/tvTimeLap"
            android:layout_width="wrap_content"
            android:layout_height="wrap_content"
            android:text="@string/time_template"
            android:textSize="@dimen/textSizeSecondary"
            app:layout_constraintBottom_toBottomOf="parent"
            app:layout_constraintEnd_toEndOf="parent"
            app:layout_constraintHorizontal_bias="1.0"
            app:layout_constraintStart_toStartOf="parent"
            app:layout_constraintTop_toTopOf="parent"
            android:textColor="@color/textColorPrimary"/>

    </androidx.constraintlayout.widget.ConstraintLayout>

</androidx.cardview.widget.CardView>
</LinearLayout>
"""
        
        let itemName = "item_lap.xml"
        return [XMLLayoutData(content: fragmentMainContent, name: fragmentMainName), XMLLayoutData(content: itemContent, name: itemName)]
    }
    
    static func dimens() -> XMLLayoutData {
        let content = """
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <dimen name="textSizeSecondary">20sp</dimen>
    <dimen name="textSizePrimary">60sp</dimen>
    <dimen name="button_margin">20dp</dimen>
    <dimen name="rv_margin">10dp</dimen>
    <dimen name="item_margin">5dp</dimen>
    <dimen name="margin_100dp">100dp</dimen>
    <dimen name="margin_80dp">80dp</dimen>
</resources>
"""
        
        let name = "dimens.xml"
        return XMLLayoutData(content: content, name: name)
    }
}
