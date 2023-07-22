//
//  File.swift
//  
//
//  Created by admin on 14.06.2023.
//

import Foundation

struct MBStopwatch: FileProviderProtocol {
    static var fileName = "MBStopwatch.kt"
    static func fileContent(
        packageName: String,
        uiSettings: UISettings
    ) -> String {
        return """
package \(packageName).presentation.fragments.main_fragment

import android.os.Build
import androidx.compose.foundation.background
import androidx.compose.foundation.isSystemInDarkTheme
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Flag
import androidx.compose.material.icons.filled.Pause
import androidx.compose.material.icons.filled.PlayArrow
import androidx.compose.material.icons.filled.Stop
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.material3.Typography
import androidx.compose.material3.darkColorScheme
import androidx.compose.material3.dynamicDarkColorScheme
import androidx.compose.material3.dynamicLightColorScheme
import androidx.compose.material3.lightColorScheme
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.scale
import androidx.compose.ui.graphics.Brush
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.text.TextStyle
import androidx.compose.ui.text.font.FontFamily
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.lifecycle.viewmodel.compose.viewModel
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.setValue
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import kotlinx.coroutines.CoroutineStart
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.Job
import kotlinx.coroutines.delay
import kotlinx.coroutines.launch

val backColor = Color(0xFF\(uiSettings.backColorPrimary ?? "FFFFFF"))
val mainTextColor = Color(0xFF\(uiSettings.textColorPrimary ?? "FFFFFF"))

val mainTextSize = \(uiSettings.textSizePrimary ?? 22)
val secondaryTextSize = \(uiSettings.textSizeSecondary ?? 16)

val mainPadding = \(uiSettings.paddingPrimary ?? 12)
val secondaryPadding = \(uiSettings.paddingSecondary ?? 8)
val tertiaryPadding = \(uiSettings.paddingSecondary ?? 8)

@Composable
fun MBStopwatch(viewModel: MainViewModel = viewModel()) {
    Column(
        modifier = Modifier
            .fillMaxSize()
                    .background(color = backColor)
            .padding(mainPadding.dp),
        horizontalAlignment = Alignment.CenterHorizontally
    ) {
        val currentTime = viewModel.allTime
        val loops = viewModel.loops
        val stopwatchState = viewModel.stopwatchState
        Spacer(modifier = Modifier.padding(secondaryPadding.dp))
        Column(
            Modifier
                .fillMaxWidth()
                    .background(color = backColor)
                .padding(mainPadding.dp),
            horizontalAlignment = Alignment.CenterHorizontally,
            verticalArrangement = Arrangement.Center
        ) {
            Text(
                modifier = Modifier
                    .padding(tertiaryPadding.dp)
                    .align(Alignment.CenterHorizontally),
                text = TimeConverters.convertMillisToNormal(currentTime),
                style = MaterialTheme.typography.displayLarge
            )
            Spacer(modifier = Modifier.padding(48.dp))
            Row(
                modifier = Modifier
                    .fillMaxWidth()
                    .background(color = backColor)
                    .padding(mainPadding.dp),
                horizontalArrangement = Arrangement.SpaceEvenly,
                verticalAlignment = Alignment.CenterVertically
            ) {
                when (stopwatchState) {
                    StopwatchState.Started -> {
                        IconButton(
                            modifier = Modifier.size(80.dp),
                            onClick = { viewModel.loop() }
                        ) {
                            Icon(
                                imageVector = Icons.Filled.Flag,
                                contentDescription = "Loop",
                                modifier = Modifier.size(80.dp),
                                tint = Color.White
                            )
                        }
                        IconButton(
                            modifier = Modifier.size(80.dp),
                            onClick = { viewModel.pauseTimer() }
                        ) {
                            Icon(
                                imageVector = Icons.Filled.Pause,
                                contentDescription = "Pause timer",
                                modifier = Modifier.size(80.dp),
                                tint = Color.White
                            )
                        }
                    }

                    StopwatchState.Paused -> {
                        IconButton(
                            modifier = Modifier.size(80.dp),
                            onClick = { viewModel.stopTimer() }
                        ) {
                            Icon(
                                imageVector = Icons.Filled.Stop,
                                contentDescription = "Stop timer",
                                modifier = Modifier.size(80.dp),
                                tint = Color.White
                            )
                        }
                        IconButton(
                            modifier = Modifier.size(80.dp),
                            onClick = { viewModel.startTimer() }
                        ) {
                            Icon(
                                imageVector = Icons.Filled.PlayArrow,
                                contentDescription = "Start timer",
                                modifier = Modifier.size(80.dp),
                                tint = Color.White
                            )
                        }
                    }
                }
            }
        }
        Spacer(modifier = Modifier.padding(16.dp))
        Row(
            modifier = Modifier
                .fillMaxWidth()
                    .background(color = backColor),
            verticalAlignment = Alignment.CenterVertically,
            horizontalArrangement = Arrangement.SpaceBetween
        ) {
            Text(
                modifier = Modifier
                    .weight(1f)
                    .padding(tertiaryPadding.dp)
                    .align(Alignment.CenterVertically),
                text = "№",
                style = MaterialTheme.typography.displayMedium
            )
            Text(
                modifier = Modifier
                    .weight(1f)
                    .padding(tertiaryPadding.dp)
                    .align(Alignment.CenterVertically),
                text = "Loop time",
                style = MaterialTheme.typography.displayMedium
            )
            Text(
                modifier = Modifier
                    .weight(1f)
                    .padding(tertiaryPadding.dp)
                    .align(Alignment.CenterVertically),
                text = "Time",
                style = MaterialTheme.typography.displayMedium
            )
        }
        LazyColumn(
            modifier = Modifier
                .fillMaxWidth()
                    .background(color = backColor)
                .weight(1f),
            verticalArrangement = Arrangement.Top,
            horizontalAlignment = Alignment.CenterHorizontally
        ) {
            items(
                items = loops,
                key = { loop ->
                    loop.number
                }
            ) { loop ->
                Row(
                    Modifier
                        .fillMaxWidth()
                    .background(color = backColor)
                        .padding(mainPadding.dp),
                    verticalAlignment = Alignment.CenterVertically,
                    horizontalArrangement = Arrangement.SpaceBetween
                ) {
                    Text(
                        modifier = Modifier
                            .weight(1f)
                            .padding(tertiaryPadding.dp)
                            .align(Alignment.CenterVertically),
                        text = loop.number.toString(),
                        style = MaterialTheme.typography.displaySmall
                    )

                    Text(
                        modifier = Modifier
                            .weight(1f)
                            .padding(tertiaryPadding.dp)
                            .align(Alignment.CenterVertically),
                        text = TimeConverters.convertMillisToSecondsWithPlus(
                            loop.loopTime
                        ),
                        style = MaterialTheme.typography.displayMedium
                    )
                    Text(
                        modifier = Modifier
                            .weight(1f)
                            .padding(tertiaryPadding.dp)
                            .align(Alignment.CenterVertically),
                        text = TimeConverters.convertMillisToSeconds(
                            loop.allTime
                        ),
                        style = MaterialTheme.typography.displayMedium
                    )
                }
            }
        }
    }
}

val Purple80 = Color(0xFFD0BCFF)
val PurpleGrey80 = Color(0xFFCCC2DC)
val Pink80 = Color(0xFFEFB8C8)

val Purple40 = Color(0xFF6650a4)
val PurpleGrey40 = Color(0xFF625b71)
val Pink40 = Color(0xFF7D5260)

private val DarkColorScheme = darkColorScheme(
    primary = Purple80,
    secondary = PurpleGrey80,
    tertiary = Pink80
)

private val LightColorScheme = lightColorScheme(
    primary = Purple40,
    secondary = PurpleGrey40,
    tertiary = Pink40
)

@Composable
fun StopwatchTheme(
    darkTheme: Boolean = isSystemInDarkTheme(),
    dynamicColor: Boolean = true,
    content: @Composable () -> Unit
) {
    val colorScheme = when {
        dynamicColor && Build.VERSION.SDK_INT >= Build.VERSION_CODES.S -> {
            val context = LocalContext.current
            if (darkTheme) dynamicDarkColorScheme(context) else dynamicLightColorScheme(context)
        }

        darkTheme -> DarkColorScheme
        else -> LightColorScheme
    }
    MaterialTheme(
        colorScheme = colorScheme,
        typography = Typography,
        content = content
    )
}

val Typography = Typography(
    bodyLarge = TextStyle(
        fontFamily = FontFamily.Default,
        fontWeight = FontWeight.Normal,
        fontSize = mainTextSize.sp,
        lineHeight = 24.sp,
        letterSpacing = 0.5.sp,
        color = mainTextColor
    ),
    displayMedium = TextStyle(
        fontSize = mainTextSize.sp,
        fontWeight = FontWeight.W300,
        textAlign = TextAlign.Center,
        color = mainTextColor
    ),
    displayLarge = TextStyle(
        fontSize = 52.sp,
        fontWeight = FontWeight.W300,
        textAlign = TextAlign.Center,
        color = mainTextColor
    ),
    displaySmall = TextStyle(
        fontSize = mainTextSize.sp,
        fontWeight = FontWeight.W700,
        textAlign = TextAlign.Center,
        color = mainTextColor
    )
)

data class Loop(
    val number: Int,
    val loopTime: Long,
    val allTime: Long
)

sealed class StopwatchState {
    object Paused : StopwatchState()
    object Started : StopwatchState()
}


class MainViewModel : ViewModel() {

    var allTime by mutableStateOf(0L)
        private set

    var stopwatchState: StopwatchState by mutableStateOf(StopwatchState.Paused)
        private set

    var loops: MutableList<Loop> = mutableListOf()
        private set

    private var timer: Job? = null

    private var lastLoop = 0L

    private fun timerBody() =
        viewModelScope.launch(start = CoroutineStart.LAZY, context = Dispatchers.IO) {
            while (true) {
                val timeBefore = System.currentTimeMillis()
                delay(75)
                allTime += System.currentTimeMillis() - timeBefore
            }
        }

    fun startTimer() {
        timer = timerBody()
        timer?.start()
        stopwatchState = StopwatchState.Started
    }

    fun stopTimer() {
        allTime = 0L
        lastLoop = 0L
        loops.clear()
    }

    fun pauseTimer() {
        timer?.cancel()
        stopwatchState = StopwatchState.Paused
    }

    fun loop() {
        loops += Loop(
            number = loops.size,
            loopTime = allTime - lastLoop,
            allTime = allTime
        )
        lastLoop = allTime
    }
}

object TimeConverters {

    fun convertMillisToNormal(timeInMillis: Long): String {
        var result = ""
        val millis = timeInMillis % 1000L
        val hours = timeInMillis / 1000L / 60L / 60L
        val minutes = (timeInMillis / 1000L / 60L) % 60L
        val seconds = (timeInMillis / 1000L) % 60L
        result += when (hours) {
            0L -> "00:"
            in 1L..9L -> "0$hours:"
            else -> "$hours:"
        }
        result += when (minutes) {
            0L -> "00:"
            in 1L..9L -> "0$minutes:"
            else -> "$minutes:"
        }
        result += when (seconds) {
            0L -> "00:"
            in 1L..9L -> "0$seconds:"
            else -> "$seconds:"
        }
        result += when (millis) {
            0L -> "000"
            in 1L..9L -> "00$millis"
            in 10L..99L -> "0$millis"
            else -> millis.toString()
        }
        return result
    }

    fun convertMillisToSecondsWithPlus(timeInMillis: Long): String {
        var result = ""
        val millis = timeInMillis % 1000L
        val hours = timeInMillis / 1000L / 60L / 60L
        val minutes = (timeInMillis / 1000L / 60L) % 60L
        val seconds = (timeInMillis / 1000L) % 60L
        result += when (hours) {
            0L -> ""
            in 1L..9L -> "0$hours:"
            else -> "$hours:"
        }
        result += when (minutes) {
            0L -> ""
            in 1L..9L -> "0$minutes:"
            else -> "$minutes:"
        }
        result += when (seconds) {
            0L -> ""
            in 1L..9L -> "0$seconds:"
            else -> "$seconds:"
        }
        result += when (millis) {
            0L -> "000"
            in 1L..9L -> "00$millis"
            in 10L..99L -> "0$millis"
            else -> millis.toString()
        }
        return "+$result"
    }

    fun convertMillisToSeconds(timeInMillis: Long): String {
        var result = ""
        val millis = timeInMillis % 1000L
        val hours = timeInMillis / 1000L / 60L / 60L
        val minutes = (timeInMillis / 1000L / 60L) % 60L
        val seconds = (timeInMillis / 1000L) % 60L
        result += when (hours) {
            0L -> ""
            in 1L..9L -> "0$hours:"
            else -> "$hours:"
        }
        result += when (minutes) {
            0L -> ""
            in 1L..9L -> "0$minutes:"
            else -> "$minutes:"
        }
        result += when (seconds) {
            0L -> "00:"
            in 1L..9L -> "0$seconds:"
            else -> "$seconds:"
        }
        result += when (millis) {
            0L -> "000"
            in 1L..9L -> "00$millis"
            in 10L..99L -> "0$millis"
            else -> millis.toString()
        }
        return result
    }
}
"""
    }
}
