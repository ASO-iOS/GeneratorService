//
//  File.swift
//  
//
//  Created by admin on 07.07.2023.
//

import Foundation

struct MBPassGen: FileProviderProtocol {
    static var fileName: String = "MBPassGen.kt"
    
    static func fileContent(packageName: String, uiSettings: UISettings) -> String {
        return """
package \(packageName)

import androidx.compose.foundation.border
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.defaultMinSize
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.Checkbox
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.OutlinedButton
import androidx.compose.material3.Text
import androidx.compose.material3.Typography
import androidx.compose.material3.lightColorScheme
import androidx.compose.runtime.Composable
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.LocalClipboardManager
import androidx.compose.ui.text.AnnotatedString
import androidx.compose.ui.text.TextStyle
import androidx.compose.ui.text.font.FontFamily
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewmodel.compose.viewModel
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlin.random.Random

val backColorPrimary = Color(0xFF\(uiSettings.backColorPrimary ?? "FFFFFF"))
val backColorSecondary = Color(0xFF\(uiSettings.backColorSecondary ?? "FFFFFF"))
val surfaceColor = Color(0xFF\(uiSettings.surfaceColor ?? "FFFFFF"))
val onSurfaceColor = Color(0xFF\(uiSettings.onSurfaceColor ?? "FFFFFF"))
val primaryColor = Color(0xFF\(uiSettings.primaryColor ?? "FFFFFF"))
val onPrimaryColor = Color(0xFF\(uiSettings.onPrimaryColor ?? "FFFFFF"))
val errorColor = Color(0xFF\(uiSettings.errorColor ?? "FFFFFF"))
val textColorPrimary = Color(0xFF\(uiSettings.textColorPrimary ?? "FFFFFF"))
val textColorSecondary = Color(0xFF\(uiSettings.textColorSecondary ?? "FFFFFF"))

@Composable
fun MBPassGen(appViewModel: AppViewModel = viewModel()) {
    Column(
        modifier = Modifier
            .fillMaxSize(),
        verticalArrangement = Arrangement.SpaceEvenly,
        horizontalAlignment = Alignment.CenterHorizontally
    ) {
        val mainState = appViewModel.mainState.collectAsState()

        val clipboardManager = LocalClipboardManager.current

        val outputText = when(val state = mainState.value.resultState) {
            ResultState.Failure -> "Error!\nAll fields must not be empty!"
            ResultState.FirstEnter -> ""
            is ResultState.Success -> state.password
        }

        Text(
            modifier = Modifier
                .border(
                    width = 2.dp,
                    color = MaterialTheme.colorScheme.onBackground,
                    shape = RoundedCornerShape(4.dp)
                )
                .clickable {
                    clipboardManager.setText(AnnotatedString(outputText))
                }
                .padding(4.dp)
                .defaultMinSize(minWidth = 100.dp),
            text = outputText,
            style = MaterialTheme.typography.bodyLarge
        )
        Column(
            verticalArrangement = Arrangement.Center,
            horizontalAlignment = Alignment.CenterHorizontally
        ) {
            IncludeCheckBox(
                text = "Include numbers"
            ) { newState ->
                appViewModel.changeNumbersState(newState)
            }
            IncludeCheckBox(
                text = "Include small chars"
            ) { newState ->
                appViewModel.changeSmallCharsState(newState)
            }
            IncludeCheckBox(
                "Include big chars"
            ) { newState ->
                appViewModel.changeBigCharsState(newState)
            }
            IncludeCheckBox(
                "Include symbols"
            ) { newState ->
                appViewModel.changeSymbolsState(newState)
            }

        }
        OutlinedButton(
            onClick = {
                appViewModel.confirm()
            }
        ) {
            Text(
                text = "Confirm",
                style = MaterialTheme.typography.displayLarge
            )
        }
    }
}


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
fun MBPassGenTheme(
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
fun IncludeCheckBox(
    text: String,
    onClick: (Boolean) -> Unit
) {
    var checked by remember {
        mutableStateOf(true)
    }
    Row(
        modifier = Modifier
            .fillMaxWidth()
            .padding(start = 32.dp, bottom = 8.dp),
        horizontalArrangement = Arrangement.Start,
        verticalAlignment = Alignment.CenterVertically
    ) {
        Checkbox(
            checked = checked,
            onCheckedChange = { newState ->
                checked = newState
                onClick(newState)
            }
        )
        Text(
            text = text,
            style = MaterialTheme.typography.bodyLarge
        )
    }
}

data class MainState(
    val numbersIncluded: Boolean = true,
    val smallCharsIncluded: Boolean = true,
    val bigCharsIncluded: Boolean = true,
    val symbolsIncluded: Boolean = true,
    val resultState: ResultState = ResultState.FirstEnter
)

class AppViewModel : ViewModel() {
    private val _mainState = MutableStateFlow(MainState())
    val mainState = _mainState.asStateFlow()

    fun confirm() = with(_mainState.value) {
        try {
            generate()
        } catch (exc: IllegalStateException) {
            _mainState.value = copy(
                resultState = ResultState.Failure
            )
        }

    }

    private fun generate() = with(_mainState.value) {
        if (
            !numbersIncluded &&
            !bigCharsIncluded &&
            !smallCharsIncluded &&
            !symbolsIncluded
        ) throw IllegalStateException()

        val password = MainGenerator.generatePassword(
            includeNumbers = numbersIncluded,
            includeBigChars = bigCharsIncluded,
            includeSmallChars = smallCharsIncluded,
            includeSymbols = symbolsIncluded
        )
        _mainState.value = copy(
            resultState = ResultState.Success(
                password = password
            )
        )
    }

    fun changeNumbersState(newState: Boolean) = with(_mainState.value) {
        _mainState.value = copy(
            numbersIncluded = newState
        )
    }

    fun changeBigCharsState(newState: Boolean) = with(_mainState.value) {
        _mainState.value = copy(
            bigCharsIncluded = newState
        )
    }

    fun changeSmallCharsState(newState: Boolean) = with(_mainState.value) {
        _mainState.value = copy(
            smallCharsIncluded = newState
        )
    }

    fun changeSymbolsState(newState: Boolean) = with(_mainState.value) {
        _mainState.value = copy(
            symbolsIncluded = newState
        )
    }

}

sealed interface ResultState {
    data class Success(
        val password: String = ""
    ) : ResultState

    object Failure : ResultState

    object FirstEnter : ResultState
}

object MainGenerator {

    private fun getRandomInt() = Random(System.nanoTime()).nextInt(0, 10)

    private fun getRandomBoolean() = Random(System.nanoTime()).nextBoolean()

    private val listSymbols = listOf("_", "!", "+", "?")
    private val bigCharRange = 'A'..'Z'
    private val smallCharRange = 'a'..'z'

    private fun generateNumber(): String {
        return getRandomInt().toString()
    }

    private fun generateSmallChar(): String {
        return smallCharRange.random().toString()
    }

    private fun generateBigChar(): String {
        return bigCharRange.random().toString()
    }

    private fun generateSymbol(): String {
        return listSymbols.random()
    }

    fun generatePassword(
        includeNumbers: Boolean,
        includeSmallChars: Boolean,
        includeBigChars: Boolean,
        includeSymbols: Boolean
    ): String {
        var password = ""
        while (password.length < 10) {
            if (includeNumbers && getRandomBoolean()) {
                password += generateNumber()
            }

            if (includeSmallChars && getRandomBoolean()) {
                password += generateSmallChar()
            }

            if (includeBigChars && getRandomBoolean()) {
                password += generateBigChar()
            }

            if (includeSymbols && getRandomBoolean()) {
                password += generateSymbol()
            }
        }
        return password
    }
}
"""
    }
    
    
}
