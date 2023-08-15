//
//  File.swift
//  
//
//  Created by admin on 01.08.2023.
//

import Foundation

struct VEChargeMe: FileProviderProtocol {
    static var fileName: String = "VEChargeMe.kt"
    
    static func fileContent(packageName: String, uiSettings: UISettings) -> String {
        return """
package \(packageName).presentation.fragments.main_fragment

import android.Manifest
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.app.Service
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.media.MediaPlayer
import android.media.RingtoneManager
import android.os.Build
import android.os.IBinder
import android.provider.Settings
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.size
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Battery1Bar
import androidx.compose.material.icons.filled.Battery2Bar
import androidx.compose.material3.Button
import androidx.compose.material3.ButtonDefaults
import androidx.compose.material3.Icon
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.material3.Typography
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.toArgb
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.TextStyle
import androidx.compose.ui.text.font.FontFamily
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.core.app.NotificationCompat
import com.google.accompanist.permissions.ExperimentalPermissionsApi
import com.google.accompanist.permissions.rememberPermissionState
import com.ramcosta.composedestinations.annotation.Destination
import com.ramcosta.composedestinations.annotation.RootNavGraph
import com.ramcosta.composedestinations.navigation.DestinationsNavigator
import com.ramcosta.composedestinations.navigation.popUpTo
import \(packageName).R
import \(packageName).presentation.fragments.main_fragment.destinations.MainScreenDestination
import \(packageName).presentation.fragments.main_fragment.destinations.SplashScreenDestination
import kotlinx.coroutines.delay

val textColorPrimary = Color(0xFF\(uiSettings.textColorPrimary ?? "FFFFFF"))
val backColorPrimary = Color(0xFF\(uiSettings.backColorPrimary ?? "FFFFFF"))
val buttonColorPrimary = Color(0xFF\(uiSettings.buttonColorPrimary ?? "FFFFFF"))
val buttonColorSecondary = Color(0xFF\(uiSettings.buttonColorSecondary ?? "FFFFFF"))
val primaryColor = Color(0xFF\(uiSettings.primaryColor ?? "FFFFFF"))

val Typography = Typography(
    bodyLarge = TextStyle(
        fontFamily = FontFamily.Default,
        fontWeight = FontWeight.Normal,
        fontSize = 16.sp,
        lineHeight = 24.sp,
        letterSpacing = 0.5.sp
    )
)

@Composable
fun ChargeMeTheme(
    content: @Composable () -> Unit
) {
    MaterialTheme(
        typography = Typography,
        content = content
    )
}
class AlarmService: Service() {
    private lateinit var mediaPlayer: MediaPlayer
    private lateinit var manager: NotificationManager

    private val notification get() =
        NotificationCompat.Builder(this, Keys.TRACKING_CHANNEL_ID)
            .setAutoCancel(false)
            .setOngoing(false)
            .setContentTitle(getString(R.string.notification_title))
            .setSmallIcon(R.drawable.baseline_battery_alert_24)
            .setSound(RingtoneManager.getDefaultUri(RingtoneManager.TYPE_ALARM))
            .setVibrate(longArrayOf(1000, 1000, 1000, 1000, 1000))
            .setLights(primaryColor.toArgb(), 3000, 3000)
            .setPriority(NotificationCompat.PRIORITY_HIGH)
            .addAction(R.drawable.baseline_battery_alert_24, getString(R.string.stop), ServiceHelper.stopRingtone(this))
            .build()

    override fun onCreate() {
        super.onCreate()
        manager = getSystemService(NotificationManager::class.java)
        createNotificationChannel()
        mediaPlayer = MediaPlayer.create(this, Settings.System.DEFAULT_ALARM_ALERT_URI)
        mediaPlayer.isLooping = true
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        when(intent?.getStringExtra(Constants.ALARM_SERVICE_STATE)) {
            AlarmState.PLAYING.name -> {
                startForeground(Keys.CHANNEL_ID, notification)
                mediaPlayer.start()
            }
            AlarmState.STOPPED.name -> {
                mediaPlayer.stop()
                manager.cancel(Keys.CHANNEL_ID)
                stopSelf()
            }
            else -> ServiceHelper.playRingtone(this)
        }

        return START_NOT_STICKY
    }

    private fun createNotificationChannel() {
        val channel = NotificationChannel(
            Keys.TRACKING_CHANNEL_ID,
            Keys.NOTIFICATION_CHANNEL_NAME,
            NotificationManager.IMPORTANCE_HIGH
        )

        manager.createNotificationChannel(channel)
    }

    override fun onBind(p0: Intent?): IBinder? = null

    private object Keys {
        const val CHANNEL_ID = 123
        const val TRACKING_CHANNEL_ID = "tracking_channel_id"
        const val NOTIFICATION_CHANNEL_NAME = "notification_channel_name"
    }
}

enum class AlarmState {
    STOPPED,
    PLAYING
}

class BatteryService: Service() {
    private val receiver = BatteryReceiver()
    private val intentFilter = IntentFilter(Intent.ACTION_BATTERY_LOW)

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        registerReceiver(receiver, intentFilter)
        return START_STICKY
    }

    override fun onBind(p0: Intent?): IBinder? = null

    override fun onDestroy() {
        super.onDestroy()
        unregisterReceiver(receiver)
    }
}

object ServiceHelper {

    fun stopRingtone(context: Context): PendingIntent {
        val stopRingtoneIntent = Intent(context, AlarmService::class.java).apply {
            putExtra(Constants.ALARM_SERVICE_STATE, AlarmState.STOPPED.name)
        }
        return PendingIntent.getService(
            context,
            Constants.SERVICE_REQUEST_CODE,
            stopRingtoneIntent,
            PendingIntent.FLAG_IMMUTABLE
        )
    }

    fun playRingtone(context: Context): PendingIntent {
        val stopRingtoneIntent = Intent(context, AlarmService::class.java).apply {
            putExtra(Constants.ALARM_SERVICE_STATE, AlarmState.PLAYING.name)
        }
        return PendingIntent.getService(
            context,
            Constants.SERVICE_REQUEST_CODE,
            stopRingtoneIntent,
            PendingIntent.FLAG_IMMUTABLE
        )
    }
}

class BatteryReceiver: BroadcastReceiver() {

    override fun onReceive(context: Context?, intent: Intent?) {
        if(intent?.action == Intent.ACTION_BATTERY_LOW) {
            context?.let {
                val alarmServiceIntent = Intent(context, AlarmService::class.java).apply {
                    putExtra(Constants.ALARM_SERVICE_STATE, AlarmState.PLAYING.name)
                }

                context.startForegroundService(alarmServiceIntent)
            }
        }
    }
}

object Constants {
    const val ALARM_SERVICE_STATE = "ALARM_SERVICE_STATE"
    const val SERVICE_REQUEST_CODE = 200
}

@OptIn(ExperimentalPermissionsApi::class)
@Destination
@Composable
fun MainScreen() {
    val context = LocalContext.current

    var isServiceRunning by remember { mutableStateOf(false) }
    val intent = Intent(context, BatteryService::class.java)

    val pushPermission = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
        rememberPermissionState(
            permission = Manifest.permission.POST_NOTIFICATIONS
        )
    } else null

    LaunchedEffect(key1 = pushPermission) {
        pushPermission?.launchPermissionRequest()
    }

    Column(
        modifier = Modifier
            .fillMaxSize()
            .background(backColorPrimary),
        horizontalAlignment = Alignment.CenterHorizontally,
        verticalArrangement = Arrangement.Center
    ) {
        Icon(
            modifier = Modifier.size(200.dp),
            imageVector = Icons.Default.Battery1Bar,
            contentDescription = null,
            tint = primaryColor
        )
        Button(
            onClick = {
                isServiceRunning = !isServiceRunning

                if(isServiceRunning)
                    context.startService(intent)
                else
                    context.stopService(intent)
            },
            colors = ButtonDefaults.buttonColors(
                containerColor = if(isServiceRunning) buttonColorPrimary else buttonColorSecondary
            )
        ) {
            Text(
                text = if(!isServiceRunning)
                    stringResource(id = R.string.start_work)
                else
                    stringResource(id = R.string.stop_work),
                color = textColorPrimary
            )
        }
    }
}

const val SPLASH_DELAY = 2000L

@RootNavGraph(start = true)
@Destination
@Composable
fun SplashScreen(navigator: DestinationsNavigator) {

    LaunchedEffect(key1 = Unit) {
        delay(SPLASH_DELAY)
        navigator.navigate(MainScreenDestination()) {
            popUpTo(SplashScreenDestination) { inclusive = true }
        }
    }

    Box(
        modifier = Modifier
            .fillMaxSize()
            .background(backColorPrimary),
        contentAlignment = Alignment.Center
    ) {
        Icon(
            modifier = Modifier.size(100.dp),
            imageVector = Icons.Default.Battery2Bar,
            contentDescription = null,
            tint = primaryColor
        )
    }
}


"""
    }
    
    static func dependencies(_ mainData: MainData) -> ANDData {
        return ANDData(mainFragmentData: ANDMainFragment(imports: """
import com.ramcosta.composedestinations.DestinationsNavHost
""", content: """
    ChargeMeTheme {
        DestinationsNavHost(navGraph = NavGraphs.root)
    }
"""), mainActivityData: ANDMainActivity(imports: "", extraFunc: "", content: ""), themesData: ANDThemesData(isDefault: true, content: ""), stringsData: ANDStringsData(additional: """
    <string name="notification_title">Your battery level is low, time to charge!</string>
    <string name="stop">Stop ringtone</string>
    <string name="start_work">Start work</string>
    <string name="stop_work">Stop work</string>
"""), colorsData: ANDColorsData(additional: ""))
    }
    
    static func gradle(_ packageName: String) -> GradleFilesData {
        let projectGradle = ""
        let projectGradleName = "build.gradle"
        let moduleGradle = ""
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
    
    
}

 func gffgradle(_ packageName: String) -> GradleFilesData {
    let projectGradle = ""
    let projectGradleName = "build.gradle"
    let moduleGradle = ""
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
