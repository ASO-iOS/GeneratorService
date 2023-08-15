//
//  File.swift
//  
//
//  Created by admin on 14.08.2023.
//

import Foundation

struct KLRecorder: XMLFileProviderProtocol {
    static var fileName: String = "KLRecorder.kt"
    
    static func fileContent(packageName: String, uiSettings: UISettings) -> String {
        return """
package \(packageName).presentation.fragments.main_fragment

import android.content.Context
import android.media.MediaPlayer
import android.media.MediaRecorder
import android.os.Build
import android.os.Bundle
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.activity.OnBackPressedCallback
import androidx.core.net.toUri
import androidx.fragment.app.Fragment
import androidx.fragment.app.activityViewModels
import androidx.fragment.app.viewModels
import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import androidx.recyclerview.widget.DiffUtil
import androidx.recyclerview.widget.ItemTouchHelper
import androidx.recyclerview.widget.RecyclerView
import androidx.room.Dao
import androidx.room.Database
import androidx.room.Delete
import androidx.room.Entity
import androidx.room.Insert
import androidx.room.OnConflictStrategy
import androidx.room.PrimaryKey
import androidx.room.Query
import androidx.room.Room
import androidx.room.RoomDatabase
import \(packageName).databinding.FragmentRecordsBinding
import \(packageName).databinding.ItemRecordBinding
import \(packageName).repository.state.StateViewModel
import dagger.Module
import dagger.Provides
import dagger.hilt.InstallIn
import dagger.hilt.android.AndroidEntryPoint
import dagger.hilt.android.lifecycle.HiltViewModel
import dagger.hilt.android.qualifiers.ApplicationContext
import dagger.hilt.components.SingletonComponent
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.Job
import kotlinx.coroutines.delay
import kotlinx.coroutines.ensureActive
import kotlinx.coroutines.launch
import java.io.File
import java.text.SimpleDateFormat
import java.util.Date
import java.util.Locale
import java.util.TimeZone
import javax.inject.Inject
import javax.inject.Singleton

@HiltViewModel
class RecorderViewModel @Inject constructor(
    private val audioRecorder: AudioRecorder,
    private val repository: Repository
) : ViewModel() {

    private val _recordStatus = MutableLiveData<RecordStatus>(RecordStatus.NotRecording)
    val recordStatus: LiveData<RecordStatus> get() = _recordStatus

    private val _time = MutableLiveData(TIME_START)
    val time: LiveData<String> get() = _time

    private val timer = Timer { duration -> _time.value = duration }

    private var filename = ""
    private var filePath = ""
    private var duration = ""

    fun startRecorder(context: Context) {
        val filepath = createRecordFilename(context)
        audioRecorder.start(filepath)
        _recordStatus.value = RecordStatus.Recording
        timer.start()
    }

    fun stopRecorder() {
        audioRecorder.stop()
        _recordStatus.value = RecordStatus.NotRecording
        timer.stop()
        duration = _time.value ?: ""
        _time.value = TIME_START
    }

    fun deleteRecord() {
        File(filename).delete()
    }

    fun saveRecord() {
        val record = RecordItem(
            filename = filename,
            filePath = filePath,
            duration = duration
        )
        viewModelScope.launch {
            repository.putRecord(record)
        }
    }

    private fun createRecordFilename(context: Context): String {
        filePath = context.filesDir.absolutePath
        val sdf = SimpleDateFormat(DATE_PATTERN, Locale.getDefault())
        sdf.timeZone = TimeZone.getDefault()
        filename = sdf.format(Date())
        Log.d(this.javaClass.simpleName, filename)

        return "$filePath$filename"
    }

    companion object {
        private const val DATE_PATTERN = "dd.MM.yyyy_hh.mm.ss"
        private const val TIME_START = "00:00.00"
    }
}

@AndroidEntryPoint
class RecordsFragment : Fragment() {
    private var _binding: FragmentRecordsBinding? = null
    private val binding get() = _binding!!

    private val viewModel: PlayerViewModel by viewModels()
    private val stateViewModel: StateViewModel by activityViewModels()

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        activity?.onBackPressedDispatcher?.addCallback(this, object : OnBackPressedCallback(true) {
            override fun handleOnBackPressed() {
                stateViewModel.setMainState()
            }
        })
    }

    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View {
        _binding = FragmentRecordsBinding.inflate(inflater, container, false)
        return binding.root
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        val adapter = RecordAdapter()
        binding.rvRecords.adapter = adapter
        setupSwipeListener(binding.rvRecords, adapter)
        viewModel.records.observe(viewLifecycleOwner) {
            adapter.list = it
        }
        viewModel.playStatus.observe(viewLifecycleOwner) {
            adapter.onRecordItemClickListener = {item ->
                when (it) {
                    is PlayStatus.Playing -> {
                        viewModel.stopRecord()
                        if (item.id != viewModel.fileIdPlaying) {
                            playRecord(item)
                        }
                    }
                    else -> {
                        playRecord(item)
                    }
                }
            }
        }
    }

    override fun onDestroy() {
        super.onDestroy()
        _binding = null
    }

    private fun playRecord(item: RecordItem) {
        val filename = item.filename
        val path = item.filePath
        viewModel.playRecord("$path$filename")
        viewModel.fileIdPlaying = item.id
    }

    private fun setupSwipeListener(rvRecordList: RecyclerView, adapter: RecordAdapter) {
        val callback = object : ItemTouchHelper.SimpleCallback(
            0,
            ItemTouchHelper.LEFT or ItemTouchHelper.RIGHT
        ) {
            override fun onMove(
                recyclerView: RecyclerView,
                viewHolder: RecyclerView.ViewHolder,
                target: RecyclerView.ViewHolder
            ): Boolean {
                return false
            }

            override fun onSwiped(viewHolder: RecyclerView.ViewHolder, direction: Int) {
                val item = adapter.list[viewHolder.adapterPosition]
                viewModel.deleteRecord(item)
            }


        }
        val itemTouchHelper = ItemTouchHelper(callback)
        itemTouchHelper.attachToRecyclerView(rvRecordList)
    }
}

@HiltViewModel
class PlayerViewModel @Inject constructor(
    private val audioPlayer: AudioPlayer,
    private val repository: Repository
) : ViewModel() {

    private val _playStatus = MutableLiveData<PlayStatus>(PlayStatus.NotPlaying)
    val playStatus: LiveData<PlayStatus> get() = _playStatus

    val records = repository.getRecords()
    var fileIdPlaying = 0

    fun playRecord(filename: String) {
        Log.d(this.javaClass.simpleName, filename)
        _playStatus.value = PlayStatus.Playing
        audioPlayer.playFile(filename)
    }

    fun stopRecord() {
        audioPlayer.stop()
        _playStatus.value = PlayStatus.NotPlaying
    }

    fun deleteRecord(item: RecordItem) {
        viewModelScope.launch {
            repository.deleteRecord(item)
        }
    }
}

class RecordAdapter() : RecyclerView.Adapter<RecordViewHolder>() {

    var onRecordItemClickListener: ((RecordItem) -> Unit)? = null

    var list: List<RecordItem> = listOf()
        set(value) {
            val callback = RecordListDiffCallback(list, value)
            val diffResult = DiffUtil.calculateDiff(callback)
            diffResult.dispatchUpdatesTo(this)
            field = value
        }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): RecordViewHolder {
        val binding = ItemRecordBinding.inflate(
            LayoutInflater.from(parent.context),
            parent,
            false
        )
        return RecordViewHolder(binding)
    }

    override fun getItemCount() = list.size

    override fun onBindViewHolder(holder: RecordViewHolder, position: Int) {
        val record = list[position]
        val binding = holder.binding

        binding.root.setOnClickListener {
            onRecordItemClickListener?.invoke(record)
        }

        with(holder.binding) {
            with(record) {
                tvFilename.text = filename
                tvDuration.text = duration
            }
        }
    }
}

class RecordListDiffCallback(
    private val oldList: List<RecordItem>,
    private val newList: List<RecordItem>
) : DiffUtil.Callback() {
    override fun getOldListSize(): Int {
        return oldList.size
    }

    override fun getNewListSize(): Int {
        return newList.size
    }

    override fun areItemsTheSame(oldItemPosition: Int, newItemPosition: Int): Boolean {
        val oldItem = oldList[oldItemPosition]
        val newItem = newList[newItemPosition]
        return oldItem.id == newItem.id
    }

    override fun areContentsTheSame(oldItemPosition: Int, newItemPosition: Int): Boolean {
        val oldItem = oldList[oldItemPosition]
        val newItem = newList[newItemPosition]
        return oldItem == newItem
    }
}

class RecordViewHolder(val binding: ItemRecordBinding) : RecyclerView.ViewHolder(binding.root)

sealed class PlayStatus {
    object Playing : PlayStatus()
    object NotPlaying : PlayStatus()
}

sealed class RecordStatus {
    object Recording : RecordStatus()
    object NotRecording : RecordStatus()
}

class Timer(val onTimerTick: (String) -> Unit) {

    private var job: Job? = null

    fun start() {
        job = CoroutineScope(Dispatchers.Main).launch {
            var duration: Long
            val startTime = System.currentTimeMillis()
            while(true) {
                ensureActive()
                delay(DELAY_MILLIS)
                duration = System.currentTimeMillis() - startTime

                onTimerTick(format(duration))
            }
        }
    }

    fun stop() {
        job?.cancel()
        job = null
    }

    private fun format(duration: Long): String {
        val milliseconds: Long = (duration % 1000) / 10
        val seconds: Long = (duration / 1000) % 60
        val minutes: Long = (duration / (1000 * 60)) % 60
        val hours: Long = (duration / (1000 * 60 * 60))

        val formatted = if (hours > 0) {
            HOUR_FORMAT.format(hours, minutes, seconds, milliseconds)
        } else {
            MINUTE_FORMAT.format(minutes, seconds, milliseconds)
        }

        return formatted
    }

    companion object {
        private const val HOUR_FORMAT = "%02d:%02d:%02d.%02d"
        private const val MINUTE_FORMAT = "%02d:%02d.%02d"
        private const val DELAY_MILLIS = 100L
    }
}

class AudioPlayer @Inject constructor(@ApplicationContext val context: Context) {
    private var player: MediaPlayer? = null

    fun playFile(filename: String) {
        MediaPlayer.create(context, File(filename).toUri()).apply {
            player = this
            start()
        }
    }

    fun stop() {
        player?.stop()
        player?.release()
        player = null
    }
}

class AudioRecorder @Inject constructor(@ApplicationContext val context: Context) {
    private var recorder: MediaRecorder? = null

    private fun createRecorder(): MediaRecorder {
        return if(Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            MediaRecorder(context)
        } else MediaRecorder()
    }

    fun start(filename: String) {
        createRecorder().apply {
            setAudioSource(MediaRecorder.AudioSource.MIC)
            setOutputFormat(MediaRecorder.OutputFormat.MPEG_4)
            setAudioEncoder(MediaRecorder.AudioEncoder.AAC)
            setOutputFile(filename)

            prepare()
            start()

            recorder = this
        }
    }

    fun stop() {
        recorder?.stop()
        recorder?.release()
        recorder = null
    }
}

interface Repository {

    fun getRecords(): LiveData<List<RecordItem>>

    suspend fun putRecord(recordItem: RecordItem)

    suspend fun deleteRecord(recordItem: RecordItem)

}

@Dao
interface RecordDao {

    @Query("SELECT * FROM records")
    fun getAllAlarms(): LiveData<List<RecordItem>>

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insertAlarmIntoDatabase(recordingItem: RecordItem)

    @Delete
    suspend fun removeAlarmFromDatabase(recordingItem: RecordItem)
}

@Database(entities = [RecordItem::class], version = 1)
abstract class AppDatabase : RoomDatabase() {
    abstract fun dao(): RecordDao
}

@Entity(tableName = "records")
data class RecordItem(
    @PrimaryKey(autoGenerate = true)
    val id: Int = 0,
    val filename: String,
    val filePath: String,
    val duration: String
)

class RepositoryImpl @Inject constructor(
    private val database: AppDatabase
) : Repository {

    override fun getRecords(): LiveData<List<RecordItem>> =
        database.dao().getAllAlarms()

    override suspend fun putRecord(recordItem: RecordItem) =
        database.dao().insertAlarmIntoDatabase(recordItem)


    override suspend fun deleteRecord(recordItem: RecordItem) =
        database.dao().removeAlarmFromDatabase(recordItem)
}

@Module
@InstallIn(SingletonComponent::class)
object AppModule {

    @Singleton
    @Provides
    fun provideDatabase(@ApplicationContext appContext: Context): AppDatabase {
        return Room
            .databaseBuilder(appContext, AppDatabase::class.java, "database-main")
            .build()
    }

    @Singleton
    @Provides
    fun provideRepository(database: AppDatabase): Repository = RepositoryImpl(database)
}
"""
    }
    
    static func dependencies(_ mainData: MainData) -> ANDData {
        return ANDData(mainFragmentData: ANDMainFragment(imports: "", content: ""), mainActivityData: ANDMainActivity(imports: """
import \(mainData.packageName).presentation.fragments.main_fragment.RecordsFragment
""", extraFunc: "", content: "", extraStates: """
                        is FragmentState.RecordsState -> replace(RecordsFragment())
"""), themesData: ANDThemesData(isDefault: true, content: ""), stringsData: ANDStringsData(additional: """
    <string name="record_filename">%s_record_%s.mp3</string>
    <string name="timer_start">00:00:00</string>
    <string name="your_records">Your records</string>
    <string name="cancel_record">Cancel Record</string>
    <string name="record_list">Record List</string>
    <string name="make_a_record">Make a record</string>
    <string name="need_voice">App needs your voice…</string>
"""), colorsData: ANDColorsData(additional: """
    <color name="backColorPrimary">#\(mainData.uiSettings.backColorPrimary ?? "FFFFFF")</color>
    <color name="backColorSecondary">#\(mainData.uiSettings.backColorSecondary ?? "FFFFFF")</color>
    <color name="buttonColorPrimary">#\(mainData.uiSettings.buttonColorPrimary ?? "FFFFFF")</color>
    <color name="buttonColorSecondary">#\(mainData.uiSettings.buttonColorSecondary ?? "FFFFFF")</color>
    <color name="textColorPrimary">#\(mainData.uiSettings.textColorPrimary ?? "FFFFFF")</color>
    <color name="textColorSecondary">#\(mainData.uiSettings.textColorSecondary ?? "FFFFFF")</color>
    <color name="surfaceColor">#\(mainData.uiSettings.surfaceColor ?? "FFFFFF")</color>

    <color name="disabled_button_color">#9C9C9C</color>
    <color name="enabled_button_color">#5E5E5E</color>
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

    implementation("androidx.room:room-runtime:2.5.2")
    annotationProcessor("androidx.room:room-compiler:2.5.2")
    kapt("androidx.room:room-compiler:2.5.2")
    implementation("androidx.room:room-ktx:2.5.2")
}
"""
        let moduleGradleName = "build.gradle"

        let dependencies = ""
        let dependenciesName = ""

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
import androidx.fragment.app.activityViewModels
import androidx.fragment.app.viewModels
import com.google.android.material.snackbar.Snackbar
import \(packageName).R
import \(packageName).databinding.FragmentMainBinding
import \(packageName).repository.state.StateViewModel
import dagger.hilt.android.AndroidEntryPoint

@AndroidEntryPoint
class MainFragment : Fragment() {

    private var _binding: FragmentMainBinding? = null
    private val binding get() = _binding!!

    private val viewModel: RecorderViewModel by viewModels()
    private val stateViewModel: StateViewModel by activityViewModels()

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
        val permission = Manifest.permission.RECORD_AUDIO
        val permissionGranted = ActivityCompat.checkSelfPermission(requireContext(), permission) == PackageManager.PERMISSION_GRANTED

        if (!permissionGranted) {
            activityResultLauncher.launch(permission)
        } else {
            setButtonListeners()
            setViewModelObserver()
        }
    }

    private fun setViewModelObserver() {
        viewModel.time.observe(viewLifecycleOwner) {
            binding.tvTimer.text = it
        }
    }

    private fun setButtonListeners() {
        with(binding) {
            btnRecord.setOnClickListener {
                when (viewModel.recordStatus.value) {
                    is RecordStatus.Recording -> {
                        viewModel.stopRecorder()
                        viewModel.saveRecord()
                        binding.btnRecord.setImageResource(R.drawable.ic_record)
                        binding.btnDelete.isEnabled = false
                    }
                    else -> {
                        viewModel.startRecorder(requireContext())
                        binding.btnRecord.setImageResource(R.drawable.ic_stop)
                        binding.btnDelete.isEnabled = true
                    }
                }
            }
            btnDelete.setOnClickListener {
                viewModel.stopRecorder()
                viewModel.deleteRecord()
                binding.btnRecord.setImageResource(R.drawable.ic_record)
            }
            btnRecordList.setOnClickListener {
                stateViewModel.setRecordsState()
            }
        }
    }

    private var activityResultLauncher = registerForActivityResult(
        ActivityResultContracts.RequestPermission()
    ) { isGranted ->
        if (isGranted) {
            setButtonListeners()
            setViewModelObserver()
        } else {
            val snackbar = Snackbar.make(binding.root, getString(R.string.need_voice), Snackbar.LENGTH_LONG)
            snackbar.show()
            setButtonListenersNoPermission(snackbar)
        }
    }

    private fun setButtonListenersNoPermission(snackbar: Snackbar) {
        with(binding) {
            btnRecord.setOnClickListener {
                snackbar.show()
            }
            btnDelete.setOnClickListener {
                snackbar.show()
            }
            btnRecordList.setOnClickListener {
                snackbar.show()
            }
        }
    }

    override fun onDestroy() {
        super.onDestroy()
        _binding = null
    }
}
""", fileName: "MainFragment.kt")
    }
    
    static func layout(_ uiSettings: UISettings) -> [XMLLayoutData] {
        let mainFragmentName = "fragment_main.xml"
        let mainFragmentContent = """
<?xml version="1.0" encoding="utf-8"?>
<androidx.constraintlayout.widget.ConstraintLayout
    xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:app="http://schemas.android.com/apk/res-auto"
    android:background="@color/backColorPrimary"
    android:layout_width="match_parent"
    android:layout_height="match_parent">

    <TextView
        android:id="@+id/tv_timer"
        android:layout_width="wrap_content"
        android:layout_height="wrap_content"
        android:text="@string/timer_start"
        android:textSize="@dimen/textSizePrimary"
        android:textColor="@color/textColorPrimary"
        app:layout_constraintBottom_toBottomOf="parent"
        app:layout_constraintEnd_toEndOf="parent"
        app:layout_constraintStart_toStartOf="parent"
        app:layout_constraintTop_toTopOf="parent" />

    <LinearLayout
        android:layout_width="match_parent"
        android:layout_height="wrap_content"
        android:gravity="center"
        android:orientation="horizontal"
        android:layout_marginBottom="@dimen/margin_80dp"
        app:layout_constraintBottom_toBottomOf="parent">
        <ImageButton
            android:id="@+id/btn_delete"
            android:src="@drawable/ic_delete_disabled"
            android:background="@drawable/ic_ripple"
            android:contentDescription="@string/cancel_record"
            android:layout_width="@dimen/button_size"
            android:layout_height="@dimen/button_size" />
        <ImageButton
            android:id="@+id/btn_record"
            android:background="@drawable/ic_record"
            android:contentDescription="@string/make_a_record"
            android:layout_width="@dimen/button_record_size"
            android:layout_height="@dimen/button_record_size"
            android:layout_marginStart="@dimen/margin_32dp"
            android:layout_marginEnd="@dimen/margin_32dp"/>
        <ImageButton
            android:id="@+id/btn_record_list"
            android:src="@drawable/ic_record_list"
            android:contentDescription="@string/record_list"
            android:background="@drawable/ic_ripple"
            android:layout_width="@dimen/button_size"
            android:layout_height="@dimen/button_size" />
    </LinearLayout>
</androidx.constraintlayout.widget.ConstraintLayout>
"""
        
        let recordsFragmentName = "fragment_records.xml"
        let recordsFragmentContent = """
<?xml version="1.0" encoding="utf-8"?>
<androidx.constraintlayout.widget.ConstraintLayout xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:app="http://schemas.android.com/apk/res-auto"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    android:background="@color/backColorPrimary"
    xmlns:tools="http://schemas.android.com/tools">

    <TextView
        android:id="@+id/tv_title"
        android:layout_width="match_parent"
        android:layout_height="wrap_content"
        android:text="@string/your_records"
        android:gravity="center"
        android:textSize="@dimen/text_size_24sp"
        android:padding="@dimen/padding_16dp"
        android:fontFamily="monospace"
        android:textColor="@color/textColorSecondary"
        android:background="@color/backColorSecondary"
        app:layout_constraintEnd_toEndOf="parent"
        app:layout_constraintStart_toStartOf="parent"
        app:layout_constraintTop_toTopOf="parent" />

    <androidx.recyclerview.widget.RecyclerView
        android:backgroundTint="@color/backColorPrimary"
        android:id="@+id/rv_records"
        android:layout_width="match_parent"
        android:layout_height="wrap_content"
        app:layout_constraintEnd_toEndOf="parent"
        app:layout_constraintStart_toStartOf="parent"
        app:layout_constraintTop_toBottomOf="@+id/tv_title"
        app:layoutManager="androidx.recyclerview.widget.LinearLayoutManager"
        tools:itemCount="5"
        tools:listitem="@layout/item_record"/>

</androidx.constraintlayout.widget.ConstraintLayout>
"""
        
        let itemName = "item_record.xml"
        let itemContent = """
<?xml version="1.0" encoding="utf-8"?>
<androidx.constraintlayout.widget.ConstraintLayout xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:app="http://schemas.android.com/apk/res-auto"
    android:layout_width="match_parent"
    android:layout_height="wrap_content"
    android:clickable="true"
    android:background="@drawable/ic_ripple_item"
    android:padding="16dp"
    android:focusable="true">

    <TextView
        android:id="@+id/tv_filename"
        android:layout_width="match_parent"
        android:layout_height="wrap_content"
        android:fontFamily="sans-serif"
        android:textColor="@color/textColorPrimary"
        android:textSize="@dimen/text_size_24sp"
        app:layout_constraintBottom_toTopOf="@+id/tv_duration"
        app:layout_constraintStart_toStartOf="parent"
        app:layout_constraintTop_toTopOf="parent" />

    <TextView
        android:id="@+id/tv_duration"
        android:layout_width="wrap_content"
        android:layout_height="wrap_content"
        android:fontFamily="sans-serif"
        android:textSize="@dimen/text_size_16sp"
        android:textColor="@color/textColorPrimary"
        app:layout_constraintBottom_toBottomOf="parent"
        app:layout_constraintStart_toStartOf="parent"
        app:layout_constraintTop_toBottomOf="@+id/tv_filename" />
</androidx.constraintlayout.widget.ConstraintLayout>
"""
        
        return [
            XMLLayoutData(content: mainFragmentContent, name: mainFragmentName),
            XMLLayoutData(content: recordsFragmentContent, name: recordsFragmentContent),
            XMLLayoutData(content: itemContent, name: itemName)
        ]
    }
    
    static func dimens(_ uiSettings: UISettings) -> XMLLayoutData {
        return XMLLayoutData(content: """
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <dimen name="textSizePrimary">56sp</dimen>

    <dimen name="text_size_16sp">16sp</dimen>
    <dimen name="text_size_24sp">24sp</dimen>

    <dimen name="margin_80dp">80dp</dimen>
    <dimen name="margin_40dp">40dp</dimen>
    <dimen name="margin_32dp">32dp</dimen>

    <dimen name="button_record_size">72dp</dimen>
    <dimen name="button_size">56dp</dimen>

    <dimen name="padding_16dp">16dp</dimen>
</resources>
""", name: "dimens.xml")
    }
}
