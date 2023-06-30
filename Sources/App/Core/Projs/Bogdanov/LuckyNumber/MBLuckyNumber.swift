//
//  File.swift
//  
//
//  Created by admin on 28.06.2023.
//

import Foundation

struct MBLuckyNumber {
    static let fileName = "MBLuckyNumber.kt"
    
    static func fileContent(
        packageName: String,
        backColorPrimary: String,
        backColorSecondary: String,
        surfaceColor: String,
        onSurfaceColor: String,
        primaryColor: String,
        onPrimaryColor: String,
        errorColor: String,
        textColorPrimary: String,
        textColorSecondary: String
    ) -> String {
        return """
package \(packageName).presentation.fragments.main_fragment

import androidx.compose.ui.graphics.Color
import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.aspectRatio
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.Button
import androidx.compose.material3.ButtonDefaults
import androidx.compose.material3.Text
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableIntStateOf
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewmodel.compose.viewModel
import com.touchlane.gridpad.GridPad
import com.touchlane.gridpad.GridPadCells
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.asStateFlow
import java.util.Random
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Typography
import androidx.compose.material3.lightColorScheme
import androidx.compose.runtime.Composable
import androidx.compose.ui.text.TextStyle
import androidx.compose.ui.text.font.FontFamily
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.sp

val backColorPrimary = Color(0xFF\(backColorPrimary))
val backColorSecondary = Color(0xFF\(backColorSecondary))
val surfaceColor = Color(0xFF\(surfaceColor))
val onSurfaceColor = Color(0xFF\(onSurfaceColor))
val primaryColor = Color(0xFF\(primaryColor))
val onPrimaryColor = Color(0xFF\(onPrimaryColor))
val errorColor = Color(0xFF\(errorColor))
val textColorPrimary = Color(0xFF\(textColorPrimary))
val textColorSecondary = Color(0xFF\(textColorSecondary))

private val LightColorScheme = lightColorScheme(
    onSurface = onSurfaceColor,
    primary = primaryColor,
    onPrimary = onPrimaryColor,
    surface = surfaceColor,
    error = errorColor,
    background = backColorPrimary,
    onBackground = backColorSecondary
)

@Composable
fun MyappTheme(
    content: @Composable () -> Unit
) {
    val colorScheme = LightColorScheme

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
        fontSize = 16.sp,
        lineHeight = 24.sp,
        letterSpacing = 0.5.sp,
        color = textColorSecondary
    ),
    displayLarge = TextStyle(
        fontFamily = FontFamily.Default,
        fontWeight = FontWeight.W500,
        fontSize = 30.sp,
        lineHeight = 30.sp,
        letterSpacing = 0.6.sp,
        textAlign = TextAlign.Center,
        color = textColorPrimary
    )
)

@Composable
fun MBLuckyNumber() {
    Column(
        modifier = Modifier
            .fillMaxSize()
            .background(
                color = MaterialTheme.colorScheme.background
            ),
        verticalArrangement = Arrangement.SpaceBetween,
        horizontalAlignment = Alignment.CenterHorizontally
    ) {
        IOScreen()
        Keyboard()
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
fun KeyboardButton(index: Int, appViewModel: AppViewModel = viewModel()) {
    val gameState = appViewModel.gameState.collectAsState()
    Button(
        modifier = Modifier
            .aspectRatio(1f)
            .padding(4.dp),
        onClick = {
            when (index) {
                11 -> appViewModel.deleteSymbol()
                9 -> appViewModel.done()
                else -> appViewModel.addSymbol(Constants.keyboardSymbols[index])
            }
        },
        shape = RoundedCornerShape(8.dp),
        enabled = gameState.value == GameState.Playing,
        colors = ButtonDefaults.buttonColors(
            containerColor = MaterialTheme.colorScheme.surface,
        )
    ) {
        Text(
            text = Constants.keyboardSymbols[index],
            style = MaterialTheme.typography.bodyLarge
        )
    }
}

@Composable
fun Keyboard(appViewModel: AppViewModel = viewModel()) {
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
                KeyboardButton(index = index)
            }
        }
    }
}

@Composable
fun IOScreen() {
    Column(
        modifier = Modifier
            .fillMaxWidth()
            .padding(8.dp)
            .background(
                color = MaterialTheme.colorScheme.background
            ),
        horizontalAlignment = Alignment.CenterHorizontally,
        verticalArrangement = Arrangement.Center
    ) {
        AttemptsDisplay()
        IODisplay()
    }
}

@Composable
fun IODisplay(appViewModel: AppViewModel = viewModel()) {
    val gameState = appViewModel.gameState.collectAsState()
    Text(
        modifier = Modifier
            .fillMaxWidth()
            .padding(top = 16.dp)
            .background(
                color = MaterialTheme.colorScheme.background
            ).border(
                width = 2.dp,
                color = MaterialTheme.colorScheme.onBackground,
                shape = RoundedCornerShape(4.dp)
            ),
        text = when (gameState.value) {
            GameState.Greeting -> "Hi! I guessed a number!\nTry to guess it!"
            GameState.Lose -> "You lost! PRESS ANY BUTTON TO RESTART"
            GameState.Playing -> appViewModel.ioText
            GameState.Win -> "You won! PRESS ANY BUTTON TO RESTART"
            else -> "Error"
        },
        style = MaterialTheme.typography.displayLarge
    )
}

@Composable
fun AttemptsDisplay(appViewModel: AppViewModel = viewModel()) {
    Box(
        modifier = Modifier
            .fillMaxWidth()
            .background(
                color = MaterialTheme.colorScheme.background
            ),
        contentAlignment = Alignment.CenterEnd
    ) {
        Text(
            style = MaterialTheme.typography.bodyLarge,
            text = "Attempts: ${appViewModel.attempts}"
        )
    }
}
"""
    }
}
