//
//  File.swift
//  
//
//  Created by admin on 28.06.2023.
//

import Foundation

struct MBLuckyNumber: FileProviderProtocol {
    static func dependencies(_ packageName: String) -> ANDData {
        return ANDData(
            mainFragmentData: ANDMainFragment(
                imports: "",
                content: """
            MyappTheme {
                MBLuckyNumber()
            }
        """
            ),
            mainActivityData: ANDMainActivity(
                imports: "",
                extraFunc: "",
                content: ""
            ),
            buildGradleData: ANDBuildGradle(
                obfuscation: true,
                dependencies: """
            implementation "com.touchlane:gridpad:1.1.0"
            implementation "androidx.compose.animation:animation:1.5.0-beta01"
        """
            )
        )
    }
    
    static var fileName = "MBLuckyNumber.kt"
    
    static func fileContent(packageName: String, uiSettings: UISettings) -> String {
        return """
package \(packageName).presentation.fragments.main_fragment

import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.aspectRatio
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.Button
import androidx.compose.material3.ButtonDefaults
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableIntStateOf
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.hilt.navigation.compose.hiltViewModel
import androidx.lifecycle.ViewModel
import com.touchlane.gridpad.GridPad
import com.touchlane.gridpad.GridPadCells
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.asStateFlow
import java.util.Random

val backColorPrimary = Color(0xFF\(uiSettings.backColorPrimary ?? "FFFFFF"))
val buttonColorPrimary = Color(0xFF\(uiSettings.buttonColorPrimary ?? "FFFFFF"))
val buttonColorSecondary = Color(0xFF\(uiSettings.buttonColorSecondary ?? "FFFFFF"))
val buttonTextColorPrimary = Color(0xFF\(uiSettings.buttonTextColorPrimary ?? "FFFFFF"))
val textColorPrimary = Color(0xFF\(uiSettings.textColorPrimary ?? "FFFFFF"))


@Composable
fun MBLuckyNumber(appViewModel: AppViewModel = hiltViewModel()) {

    Column(
        modifier = Modifier
            .fillMaxSize()
            .background(
                color = backColorPrimary
            ),
        verticalArrangement = Arrangement.SpaceBetween,
        horizontalAlignment = Alignment.CenterHorizontally
    ) {
        IOScreen(appViewModel)
        Keyboard(appViewModel)
    }
}

class AppViewModel : ViewModel() {

    var ioText by mutableStateOf("")
        private set

    var attempts by mutableIntStateOf(10)
        private set

    private val _gameState = MutableStateFlow<GameState>(GameState.Greeting)
    val gameState = _gameState.asStateFlow()

    fun addSymbol(newSymbol: String) {
        if (ioText.length < 2)
            ioText += newSymbol
    }

    fun deleteSymbol() {
        if (ioText.isNotEmpty()) {
            val lastSymbol = ioText[ioText.length - 1]
            ioText = ioText.removeSuffix(lastSymbol.toString())
        }
    }

    fun restart() {
        GameHandler.restart()
        attempts = 10
        ioText = ""
        _gameState.value = GameState.Playing
    }

    fun done() {
        if (ioText.toIntOrNull() != null) {
            val result = GameHandler.check(ioText.toInt())
            attempts--
            if (result) {
                _gameState.value = GameState.Win
                return
            }
            if (attempts == 0)
                _gameState.value = GameState.Lose
            ioText = ""
        }
    }

}

sealed class GameState {
    object Lose : GameState()

    object Win : GameState()

    object Playing : GameState()

    object Greeting : GameState()
}

object Constants {

    val keyboardSymbols = listOf(
        "1", "2", "3", "4", "5", "6", "7", "8", "9", "✓", "0", "⌫"
    )

}

object GameHandler {

    private var guessedNumber = random()

    private fun random() = Random(System.currentTimeMillis()).nextInt(51)

    fun restart() {
        guessedNumber = random()
    }

    fun check(inputNumber: Int) = inputNumber == guessedNumber
}

@Composable
fun KeyboardButton(index: Int, appViewModel: AppViewModel) {
    val gameState = appViewModel.gameState.collectAsState()
    Button(
        modifier = Modifier
            .aspectRatio(1f)
            .padding(4.dp),
        onClick = {
            if (gameState.value == GameState.Playing) {
                when (index) {
                    11 -> appViewModel.deleteSymbol()
                    9 -> appViewModel.done()
                    else -> appViewModel.addSymbol(Constants.keyboardSymbols[index])
                }
            }

        },
        shape = RoundedCornerShape(8.dp),
        colors = ButtonDefaults.buttonColors(
            containerColor = if (gameState.value == GameState.Playing) buttonColorPrimary else buttonColorSecondary,
        )
    ) {
        Text(
            text = Constants.keyboardSymbols[index],
            color = buttonTextColorPrimary,
            fontSize = 32.sp
        )
    }
}

@Composable
fun Keyboard(appViewModel: AppViewModel) {
    val gameState = appViewModel.gameState.collectAsState()
    GridPad(
        modifier = Modifier
            .fillMaxWidth()
            .aspectRatio(0.75f)
            .clickable(
                enabled = gameState.value != GameState.Playing,
                onClick = {
                    appViewModel.restart()
                }
            ),
        cells = GridPadCells(
            rowCount = 4,
            columnCount = 3
        )
    ) {
        repeat(Constants.keyboardSymbols.size) { index ->
            item {
                KeyboardButton(index = index, appViewModel)
            }
        }
    }
}

@Composable
fun IOScreen(appViewModel: AppViewModel) {
    val state = appViewModel.gameState.collectAsState().value
    Column(
        modifier = Modifier
            .fillMaxWidth()
            .padding(8.dp)
            .background(
                color = backColorPrimary
            ),
        horizontalAlignment = Alignment.CenterHorizontally,
        verticalArrangement = Arrangement.Center
    ) {
        AttemptsDisplay(appViewModel)
        IODisplay(appViewModel)
        Spacer(modifier = Modifier.padding(2.dp))
        when (state) {
            GameState.Playing -> {}
            GameState.Greeting -> {
                Button(
                    onClick = { appViewModel.restart() },
                    colors = ButtonDefaults.buttonColors(containerColor = buttonColorPrimary)
                ) {
                    Text(
                        text = "Start",
                        color = buttonTextColorPrimary,
                        fontSize = 20.sp
                    )
                }
            }

            GameState.Lose -> {
                Button(
                    onClick = { appViewModel.restart() },
                    colors = ButtonDefaults.buttonColors(containerColor = buttonColorPrimary)
                ) {
                    Text(
                        text = "Restart",
                        color = buttonTextColorPrimary,
                        fontSize = 20.sp
                    )
                }
            }

            GameState.Win -> {
                Button(
                    onClick = { appViewModel.restart() },
                    colors = ButtonDefaults.buttonColors(containerColor = buttonColorPrimary)
                ) {
                    Text(
                        text = "Play Again",
                        color = buttonTextColorPrimary,
                        fontSize = 20.sp
                    )
                }
            }
        }

    }
}

@Composable
fun IODisplay(appViewModel: AppViewModel) {
    val gameState = appViewModel.gameState.collectAsState()
    Text(
        modifier = Modifier
            .fillMaxWidth()
            .padding(top = 16.dp)
            .background(
                color = backColorPrimary
            )
            .border(
                width = 2.dp,
                color = buttonColorPrimary,
                shape = RoundedCornerShape(4.dp)
            )
            .padding(12.dp),
        text = when (gameState.value) {
            GameState.Greeting -> "Hi! I guessed a number! Try to guess it!"
            GameState.Lose -> "You lost! Try Again?"
            GameState.Playing -> appViewModel.ioText
            GameState.Win -> "You won! Play Again?"
            else -> "Error"
        }, color = textColorPrimary, fontSize = 26.sp
    )
}

@Composable
fun AttemptsDisplay(appViewModel: AppViewModel) {
    Box(
        modifier = Modifier
            .fillMaxWidth()
            .background(
                color = backColorPrimary
            ),
        contentAlignment = Alignment.CenterEnd
    ) {
        Text(
            color = textColorPrimary,
            fontSize = 16.sp,
            text = "Attempts: ${appViewModel.attempts}"
        )
    }
}
"""

    }
}
