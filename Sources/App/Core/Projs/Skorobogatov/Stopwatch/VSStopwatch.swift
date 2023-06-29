//
//  File.swift
//  
//
//  Created by admin on 06.06.2023.
//

import Foundation

struct VSStopwatch {
    static let fileName = "VSStopwatch.kt"
    static func fileText(
        packageName: String,
        backColor: String,
        buttonColor: String,
        buttonTextColor: String,
        mainTextColor: String
    ) -> String {
        return """
package \(packageName).presentation.fragments.main_fragment

import android.content.res.Configuration
import androidx.compose.foundation.BorderStroke
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.itemsIndexed
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.Button
import androidx.compose.material.ButtonDefaults
import androidx.compose.material.OutlinedButton
import androidx.compose.material.Scaffold
import androidx.compose.material.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.collectAsState
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Brush
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.platform.LocalConfiguration
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.hilt.navigation.compose.hiltViewModel
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.Job
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.launch
import javax.inject.Inject

val backColor = Color(0xFF\(backColor))
val buttonColor = Color(0xFF\(buttonColor))
val buttonTextColor = Color(0xFF\(buttonTextColor))
val outlineButtonColor = Color(0xFF\(buttonColor))
val outlineButtonBorderColor = Color(0xFF\(buttonColor))
val mainTextColor = Color(0xFF\(mainTextColor))
val lapTextColor = Color(0xFF\(mainTextColor))
val buttonRadius = 24.dp
val buttonsBottomPadding = 18.dp

@Composable
fun ButtonBar(
    timerState: TimerUiState.TimerState,
    viewModel: MainViewModel
) {
    Row(
        horizontalArrangement = Arrangement.spacedBy(14.dp),
        modifier = Modifier.padding(start = 14.dp, end = 14.dp, bottom = buttonsBottomPadding)
    ) {
        when (timerState) {
            is TimerUiState.TimerState.Init -> {
                Button(
                    modifier = Modifier.fillMaxWidth(0.5f),
                    shape = RoundedCornerShape(buttonRadius),
                    colors = ButtonDefaults.buttonColors(contentColor = buttonTextColor, backgroundColor = buttonColor),
                    onClick = { viewModel.start() }
                ) {
                    Text(
                        text = "Start",
                        fontSize = 28.sp,
                        fontWeight = FontWeight.Bold
                    )
                }
            }

            is TimerUiState.TimerState.Running -> {
                OutlinedButton(
                    modifier = Modifier.weight(1f),
                    shape = RoundedCornerShape(buttonRadius),
                    border = BorderStroke(2.dp, outlineButtonBorderColor),
                    colors = ButtonDefaults.buttonColors(backgroundColor = outlineButtonColor),
                    onClick = { viewModel.lap() }
                ) {
                    Text(
                        text = "Lap",
                        fontSize = 28.sp,
                        color = buttonTextColor,
                        fontWeight = FontWeight.Bold
                    )
                }
                Button(
                    modifier = Modifier.weight(1f),
                    shape = RoundedCornerShape(buttonRadius),
                    colors = ButtonDefaults.buttonColors(contentColor = buttonTextColor, backgroundColor = buttonColor),
                    onClick = { viewModel.pause() }
                ) {
                    Text(
                        text = "Pause",
                        fontSize = 28.sp,
                        fontWeight = FontWeight.Bold
                    )
                }
            }

            is TimerUiState.TimerState.Paused -> {
                OutlinedButton(
                    modifier = Modifier.weight(1f),
                    shape = RoundedCornerShape(buttonRadius),
                    border = BorderStroke(2.dp, outlineButtonBorderColor),
                    colors = ButtonDefaults.buttonColors(backgroundColor = outlineButtonColor),
                    onClick = { viewModel.reset() }
                ) {
                    Text(
                        text = "Reset",
                        fontSize = 28.sp,
                        color = buttonTextColor,
                        fontWeight = FontWeight.Bold
                    )
                }
                Button(
                    modifier = Modifier.weight(1f),
                    shape = RoundedCornerShape(buttonRadius),
                    colors = ButtonDefaults.buttonColors(contentColor = buttonTextColor, backgroundColor = buttonColor),
                    onClick = {
                        viewModel.start()
                    }
                ) {
                    Text(
                        text = "Resume",
                        fontSize = 28.sp,
                        fontWeight = FontWeight.Bold
                    )
                }
            }
        }
    }
}

data class TimerUiState(
    val time: Long = 0L,
    val laps: MutableList<Long> = mutableListOf(),
    val timerState: TimerState = TimerState.Init
) {
    sealed interface TimerState {
        object Init : TimerState
        object Running : TimerState
        object Paused : TimerState
    }
}

@HiltViewModel
class MainViewModel @Inject constructor() : ViewModel() {

    private val _state = MutableStateFlow(TimerUiState())
    val state = _state.asStateFlow()

    private var job: Job? = null

    private var startMillis: Long = 0
    private var isRunning: Boolean = false
    private var time: Long = 0

    fun pause() {
        isRunning = false
    }

    fun reset() {
        time = 0

        updateState {
            TimerUiState()
        }
    }

    fun start() {
        if (job?.isActive != true) {
            job = viewModelScope.launch(Dispatchers.Default) {
                isRunning = true
                startMillis = System.currentTimeMillis() - time

                updateState { state ->
                    state.copy(timerState = TimerUiState.TimerState.Running)
                }

                while (isRunning) {
                    time = System.currentTimeMillis() - startMillis

                    updateState { state ->
                        state.copy(time = time)
                    }
                }

                updateState { state ->
                    state.copy(timerState = TimerUiState.TimerState.Paused)
                }
            }
        }
    }

    fun lap() {
        _state.value.laps.add(time)
    }

    private fun updateState(stateScope: (TimerUiState) -> TimerUiState) {
        _state.value = stateScope(_state.value)
    }
}


@Composable
fun V1StopwatchScreen(viewModel: MainViewModel = hiltViewModel()) {

    val state = viewModel.state.collectAsState()
    val orientation = LocalConfiguration.current.orientation

    Scaffold { paddingValues ->
        Column(
            horizontalAlignment = Alignment.CenterHorizontally,
            modifier = Modifier
                .fillMaxSize()
                .padding(paddingValues)
                    .background(color = backColor)
        ) {

            Text(
                text = state.value.time.format(),
                color = mainTextColor,
                fontSize = 80.sp,
                modifier = Modifier.padding(top = if (orientation == Configuration.ORIENTATION_LANDSCAPE) 0.dp else 32.dp)
            )

            LazyColumn(
                horizontalAlignment = Alignment.CenterHorizontally,
                modifier = Modifier
                    .weight(1f)
                    .fillMaxWidth()
                    .padding(bottom = 16.dp)
            ) {
                itemsIndexed(state.value.laps) { index, time ->
                    Row(modifier = Modifier
                        .fillMaxWidth()
                        .padding(horizontal = 12.dp, vertical = 1.dp), horizontalArrangement = Arrangement.SpaceBetween, verticalAlignment = Alignment.CenterVertically) {
                        Text(
                            text = (index + 1).toString(),
                            fontSize = 24.sp,
                            textAlign = TextAlign.End,
                            color = lapTextColor
                        )
                        Text(
                            modifier = Modifier.fillMaxWidth(),
                            text = time.format(),
                            fontSize = 40.sp,
                            textAlign = TextAlign.End,
                            color = lapTextColor
                        )
                    }
                }
            }
            ButtonBar(timerState = state.value.timerState, viewModel = viewModel)
        }
    }
}

fun Long.format(): String {
    val timeMM = (this / 10 % 100).toString().padStart(2, '0')
    val timeS = (this / 1000 % 60).toString().padStart(2, '0')
    val timeM = (this / 60000).toString().padStart(2, '0')
//    return context.getString(R.string.mm_ss_time, timeM, timeS, timeMM)
    return "$timeM:$timeS.$timeMM"
}
"""
    }
}
