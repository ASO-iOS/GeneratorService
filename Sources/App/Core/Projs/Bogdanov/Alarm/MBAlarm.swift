//
//  File.swift
//  
//
//  Created by admin on 14.06.2023.
//

import Foundation

struct MBAlarm: FileProviderProtocol {
    static var fileName = "MBAlarm.kt"
    static func fileContent(
        packageName: String,
        uiSettings: UISettings
    ) -> String {
        return """
package \(packageName).presentation.fragments.main_fragment

import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import android.media.RingtoneManager
import android.os.Build
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.runtime.Composable
import androidx.core.app.NotificationCompat
import androidx.hilt.navigation.compose.hiltViewModel
import androidx.work.Worker
import androidx.work.WorkerParameters
import \(packageName).R
import \(packageName).presentation.main_activity.MainActivity
import dagger.hilt.android.lifecycle.HiltViewModel
import javax.inject.Inject
import androidx.compose.foundation.BorderStroke
import androidx.compose.foundation.background
import androidx.compose.foundation.isSystemInDarkTheme
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.ColumnScope
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.DarkMode
import androidx.compose.material.icons.filled.Delete
import androidx.compose.material3.Button
import androidx.compose.material3.ButtonDefaults
import androidx.compose.material3.DatePickerDefaults
import androidx.compose.material3.DatePickerDialog
import androidx.compose.material3.Divider
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.IconButtonDefaults
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.MaterialTheme.colorScheme
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Text
import androidx.compose.material3.TimePicker
import androidx.compose.material3.TimePickerDefaults
import androidx.compose.material3.TimePickerState
import androidx.compose.material3.Typography
import androidx.compose.material3.rememberTimePickerState
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.shadow
import androidx.compose.ui.graphics.Brush
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.text.TextStyle
import androidx.compose.ui.text.font.FontFamily
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import androidx.lifecycle.viewmodel.compose.viewModel
import androidx.room.Delete
import androidx.room.Entity
import androidx.room.Insert
import androidx.room.OnConflictStrategy
import androidx.room.PrimaryKey
import androidx.room.Query
import androidx.room.Room
import androidx.room.RoomDatabase
import androidx.work.OneTimeWorkRequestBuilder
import androidx.work.WorkManager
import dagger.Module
import dagger.Provides
import dagger.hilt.InstallIn
import dagger.hilt.android.qualifiers.ApplicationContext
import dagger.hilt.components.SingletonComponent
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.launch
import java.text.SimpleDateFormat
import java.util.concurrent.TimeUnit
import javax.inject.Singleton

val backColor = Color(0xFF\(uiSettings.backColorPrimary ?? "FFFFFF"))
val mainTextColor = Color(0xFF\(uiSettings.textColorPrimary ?? "FFFFFF"))
val mainButtonColor = Color(0xFF\(uiSettings.buttonColorPrimary ?? "FFFFFF"))
val mainTextSize = \(uiSettings.textSizePrimary ?? 18)
val mainPadding = \(uiSettings.paddingPrimary ?? 12)

val Typography = Typography(
    bodyLarge = TextStyle(
        fontFamily = FontFamily.Default,
        fontWeight = FontWeight.Normal,
        fontSize = mainTextSize.sp,
        lineHeight = 24.sp,
        letterSpacing = 0.5.sp
    ),
    displayMedium = TextStyle(
        fontFamily = FontFamily.Default,
        fontSize = mainTextSize.sp,
        lineHeight = 24.sp,
        letterSpacing = 1.sp
    ),
    displaySmall = TextStyle(
        fontFamily = FontFamily.Default,
        fontWeight = FontWeight.W300,
        fontSize = mainTextSize.sp,
        lineHeight = 24.sp,
        letterSpacing = 0.4.sp,
        textAlign = TextAlign.Center
    ),
    displayLarge = TextStyle(
        fontFamily = FontFamily.Default,
        fontWeight = FontWeight.W500,
        fontSize = mainTextSize.sp,
        lineHeight = 24.sp,
        letterSpacing = 0.4.sp,
        textAlign = TextAlign.Center
    )
)

@Composable
fun MBAlarm(viewModel: MainViewModel = hiltViewModel()) {
    AlarmTheme(darkTheme = viewModel.darkTheme) {
        Scaffold { paddingValues ->

            Column(
                modifier = Modifier
                    .background(color = backColor)
                    .padding(paddingValues),
                verticalArrangement = Arrangement.SpaceEvenly,
                horizontalAlignment = Alignment.CenterHorizontally
            ) {
                AlarmsList()
                TimePickerDisplay()
                ButtonAdd()
            }
        }
    }
}

@Composable
fun AlarmView(alarmItem: AlarmItem, viewModel: MainViewModel = viewModel()) {
    val workManager = WorkManager.getInstance(LocalContext.current)
    Row(
        modifier = Modifier
            .fillMaxWidth()
            .padding(horizontal = mainPadding.dp, vertical = mainPadding.dp)
                    .background(color = backColor),
        horizontalArrangement = Arrangement.SpaceEvenly,
        verticalAlignment = Alignment.CenterVertically
    ) {
        Text(
            text = alarmItem.timestamp,
            style = MaterialTheme.typography.displayLarge,
            color = mainTextColor
        )
        IconButton(
            onClick = {
                viewModel.removeAlarm(alarmItem)
                workManager.cancelAllWorkByTag(alarmItem.id)
            },
            colors = IconButtonDefaults.iconButtonColors(
                contentColor = colorScheme.onSurface
            )
        ) {
            Icon(
                imageVector = Icons.Default.Delete,
                contentDescription = "Remove alarm",
                tint = mainTextColor
            )
        }
    }
}

@Composable
fun ButtonAdd(viewModel: MainViewModel = viewModel()) {
    Button(
        modifier = Modifier
            .fillMaxWidth()
            .padding(
                start = mainPadding.dp,
                end = mainPadding.dp,
                bottom = mainPadding.dp,
                top = mainPadding.dp
            )
                    .background(color = backColor)
            .shadow(
                elevation = 4.dp,
                ambientColor = colorScheme.onSurface
            ),
        shape = RoundedCornerShape(8.dp),
        border = BorderStroke(
            width = 3.dp,
            color = colorScheme.onBackground
        ),
        colors = ButtonDefaults.buttonColors(
            containerColor = mainButtonColor,
            contentColor = mainTextColor
        ),
        onClick = {
            viewModel.showTimePicker()
        }
    ) {
        Text(
            text = "Add alarm",
            style = MaterialTheme.typography.displayMedium,
        )
    }
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun TimePickerDisplay(
    viewModel: MainViewModel = viewModel(),
) {
    val state = rememberTimePickerState(is24Hour = true)

    if (viewModel.timePickerState) {
        DatePickerDialog(
            onDismissRequest = {
                viewModel.hideTimePicker()
            },
            confirmButton = {
                ConfirmButton(state = state)
            },
            dismissButton = {
                DismissButton()
            },
            colors = DatePickerDefaults.colors(
                containerColor = colorScheme.surface
            )
        ) {
            TimePicker(
                modifier = Modifier
                    .align(Alignment.CenterHorizontally)
                    .padding(mainPadding.dp)
                    .background(color = backColor),
                state = state,
                colors = TimePickerDefaults.colors(
                    selectorColor = colorScheme.surface,
                    timeSelectorSelectedContainerColor = colorScheme.onPrimary,
                    timeSelectorSelectedContentColor = colorScheme.onSurface,
                    timeSelectorUnselectedContainerColor = colorScheme.onPrimary,
                    timeSelectorUnselectedContentColor = colorScheme.onSurface,
                    clockDialColor = colorScheme.onPrimary,
                    clockDialSelectedContentColor = colorScheme.onSurface,
                    clockDialUnselectedContentColor = colorScheme.onSurface
                )
            )
        }
    }
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
private fun ConfirmButton(viewModel: MainViewModel = viewModel(), state: TimePickerState) {
    val context = LocalContext.current
    Button(
        onClick = {
            viewModel.setAlarm(state = state, context = context)
        },
        colors = ButtonDefaults.buttonColors(
            containerColor = colorScheme.surface
        )
    ) {
        Text(
            text = "Confirm",
            style = MaterialTheme.typography.displayMedium,
            color = colorScheme.onSurface
        )
    }
}

@Composable
fun DismissButton(viewModel: MainViewModel = viewModel()) {
    Button(
        onClick = {
            viewModel.hideTimePicker()
        },
        colors = ButtonDefaults.buttonColors(
            containerColor = colorScheme.surface
        )
    ) {
        Text(
            text = "Dismiss",
            style = MaterialTheme.typography.displayMedium,
            color = colorScheme.onSurface
        )
    }
}

@Composable
fun ColumnScope.AlarmsList(viewModel: MainViewModel = viewModel()) {
    val listAlarms = viewModel.alarms.collectAsState(initial = listOf()).value
    LazyColumn(
        modifier = Modifier
            .fillMaxSize(0.9f)
                    .background(color = backColor)
            .weight(1f),
        horizontalAlignment = Alignment.CenterHorizontally
    ) {
        if (listAlarms.isEmpty()) {
            item {
                Spacer(modifier = Modifier.padding(32.dp))
                Text(text = "No alarm clock has been set yet", color = mainTextColor, fontSize = mainTextSize.sp)
            }
        } else {
            items(
                items = listAlarms,
                key = { listItem ->
                    listItem.id
                }
            ) { alarmItem ->
                AlarmView(alarmItem = alarmItem)
                Divider()
            }
        }


    }
}

@Composable
fun ButtonChangeTheme(viewModel: MainViewModel = viewModel()) {
    IconButton(
        onClick = {
            viewModel.changeTheme()
        },
        colors = IconButtonDefaults.iconButtonColors(
            contentColor = colorScheme.onSurface
        )
    ) {
        Icon(
            imageVector = Icons.Default.DarkMode,
            contentDescription = "Change mode",
        )
    }
}

@Composable
fun AlarmTheme(
    darkTheme: Boolean = isSystemInDarkTheme(),
    viewModel: MainViewModel = viewModel(),
    content: @Composable () -> Unit
) {
//    val colorScheme = when (viewModel.darkTheme) {
//        false -> LightColorScheme
//        true -> DarkColorScheme
//    }
//
//    val systemUiController = rememberSystemUiController()
//
//    SideEffect {
//        systemUiController.setNavigationBarColor(
//            color = colorScheme.background,
//            darkIcons = !darkTheme
//        )
//        systemUiController.setStatusBarColor(
//            color = colorScheme.background,
//            darkIcons = !darkTheme
//        )
//    }

    MaterialTheme(
//        colorScheme = colorScheme,
        typography = Typography,
        content = content
    )
}

@Entity(tableName = "alarms")
data class AlarmItem(
    val timestamp: String,
    @PrimaryKey
    val id: String
)

@Module
@InstallIn(SingletonComponent::class)
object AppModule {

    @Singleton
    @Provides
    fun provideDatabase(@ApplicationContext appContext: Context): Database {
        return Room
            .databaseBuilder(appContext, Database::class.java, "database-name")
            .build()
    }

    @Singleton
    @Provides
    fun provideRepository(database: Database): LocalRepository = LocalRepositoryImpl(database)

    @Singleton
    @Provides
    fun provideSharedPreferences(
        @ApplicationContext context: Context
    ): SharedPreferences = context.getSharedPreferences(
        Constants.SHARED_PREFERENCES_NAME,
        Context.MODE_PRIVATE
    )
}

object Constants {

    const val THEME_KEY = "THEME_KEY"

    const val SHARED_PREFERENCES_NAME = "SHARED_PREFERENCES_NAME"

}

@androidx.room.Dao
interface Dao {

    @Query("SELECT * FROM alarms")
    fun getAllAlarms(): Flow<List<AlarmItem>>

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insertAlarmIntoDatabase(recordingItem: AlarmItem)

    @Delete
    suspend fun removeAlarmFromDatabase(recordingItem: AlarmItem)
}


@androidx.room.Database(entities = [AlarmItem::class], version = 1)
abstract class Database : RoomDatabase() {
    abstract fun dao(): Dao
}

interface LocalRepository {

    fun getData(): Flow<List<AlarmItem>>

    suspend fun putData(alarmItem: AlarmItem)

    suspend fun deleteData(alarmItem: AlarmItem)

}

class LocalRepositoryImpl @Inject constructor(
    private val database: Database
) : LocalRepository {

    override fun getData(): Flow<List<AlarmItem>> =
        database.dao().getAllAlarms()

    override suspend fun putData(alarmItem: AlarmItem) =
        database.dao().insertAlarmIntoDatabase(alarmItem)


    override suspend fun deleteData(alarmItem: AlarmItem) =
        database.dao().removeAlarmFromDatabase(alarmItem)

}

@HiltViewModel
class MainViewModel @Inject constructor(
    private val localRepository: LocalRepository,
    private val sharedPrefs: SharedPreferences
) : ViewModel() {

    var timePickerState by mutableStateOf(false)
        private set

    val alarms = localRepository.getData()

    var darkTheme by mutableStateOf(sharedPrefs.getBoolean(Constants.THEME_KEY, false))
        private set

    fun changeTheme() {
        darkTheme = !darkTheme
        sharedPrefs.edit().putBoolean(Constants.THEME_KEY, darkTheme).apply()
    }

    private fun addAlarm(alarmItem: AlarmItem) {
        viewModelScope.launch {
            localRepository.putData(alarmItem)
        }
    }

    fun removeAlarm(alarmItem: AlarmItem) {
        viewModelScope.launch {
            localRepository.deleteData(alarmItem)
        }
    }

    fun hideTimePicker() {
        timePickerState = false
    }

    fun showTimePicker() {
        timePickerState = true
    }

    @OptIn(ExperimentalMaterial3Api::class)
    fun setAlarm(state: TimePickerState, context: Context) {
        val delay = (state.hour * 60 * 60 + state.minute * 60) * 1000L
        val timestamp = SimpleDateFormat("HH:mm dd.MM")
            .format(System.currentTimeMillis() + delay)

        val tag = System.currentTimeMillis().toString()

        WorkManager.getInstance(context).enqueue(
            OneTimeWorkRequestBuilder<TimerWorkManager>()
                .setInitialDelay(delay, TimeUnit.MILLISECONDS)
                .addTag(tag)
                .build()
        )
        addAlarm(AlarmItem(timestamp = timestamp, id = tag))
        hideTimePicker()
    }

}

class TimerWorkManager(
    private val context: Context,
    workerParams: WorkerParameters
) : Worker(context, workerParams) {

    override fun doWork(): Result {
        val builder = NotificationCompat.Builder(context, "tracking_channel")
            .setAutoCancel(false)
            .setOngoing(false)
            .setSmallIcon(R.drawable.baseline_access_alarm_24)
            .setContentTitle("Alarm")
            .setContentText("Wake Up!")
            .setSound(RingtoneManager.getDefaultUri(RingtoneManager.TYPE_ALARM))
            .setVibrate(longArrayOf(1000, 1000, 1000, 1000))
            .setContentIntent(pendingIntent)
            .setPriority(NotificationCompat.PRIORITY_HIGH)

        val manager = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(
                "tracking_channel", "name",
                NotificationManager.IMPORTANCE_HIGH
            )
            manager.createNotificationChannel(channel)
        }

        manager.notify(1, builder.build())

        return Result.success()
    }

    private val pendingIntent = PendingIntent.getActivity(
        context,
        0,
        Intent(context, MainActivity::class.java),
        PendingIntent.FLAG_IMMUTABLE
    )

}
"""
    }
}
