//
//  File.swift
//  
//
//  Created by admin on 07.07.2023.
//

import Foundation

struct MBPassGen: FileProviderProtocol {
    static func dependencies(_ packageName: String) -> ANDData {
        return ANDData(
            mainFragmentData: ANDMainFragment(
                imports: "",
                content: """
            MBPassGen()
        """
            ),
            mainActivityData: ANDMainActivity(
                imports: "",
                extraFunc: "",
                content: ""
            ),
            buildGradleData: ANDBuildGradle(
                obfuscation: true,
                dependencies: ""
            )
        )
    }
    
    static var fileName: String = "MBPassGen.kt"
    
    static func fileContent(packageName: String, uiSettings: UISettings) -> String {
        return """
package \(packageName).presentation.fragments.main_fragment


import androidx.compose.foundation.background
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
import androidx.compose.material3.ButtonDefaults
import androidx.compose.material3.Checkbox
import androidx.compose.material3.CheckboxDefaults
import androidx.compose.material3.OutlinedButton
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.platform.LocalClipboardManager
import androidx.compose.ui.text.AnnotatedString
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewmodel.compose.viewModel
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlin.random.Random

val backColorPrimary = Color(0xFF\(uiSettings.backColorPrimary ?? "FFFFFF"))
val buttonColorPrimary = Color(0xFF\(uiSettings.buttonColorPrimary ?? "FFFFFF"))
val buttonTextColorPrimary = Color(0xFF\(uiSettings.buttonTextColorPrimary ?? "FFFFFF"))
val textColorPrimary = Color(0xFF\(uiSettings.textColorPrimary ?? "FFFFFF"))

@Composable
fun MBPassGen(appViewModel: AppViewModel = viewModel()) {
    Column(
        modifier = Modifier
            .fillMaxSize()
            .background(backColorPrimary),
        verticalArrangement = Arrangement.SpaceEvenly,
        horizontalAlignment = Alignment.CenterHorizontally
    ) {
        val mainState = appViewModel.mainState.collectAsState()

        val clipboardManager = LocalClipboardManager.current

        val outputText = when(val state = mainState.value.resultState) {
            ResultState.Failure -> "Error!\\nAll fields must not be empty!"
            ResultState.FirstEnter -> ""
            is ResultState.Success -> state.password
        }

        Text(
            modifier = Modifier
                .border(
                    width = 2.dp,
                    color = buttonColorPrimary,
                    shape = RoundedCornerShape(4.dp)
                )
                .clickable {
                    clipboardManager.setText(AnnotatedString(outputText))
                }
                .padding(4.dp)
                .defaultMinSize(minWidth = 100.dp),
            text = outputText,
            color = textColorPrimary,
            fontSize = 32.sp
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
            }, colors = ButtonDefaults.buttonColors(buttonColorPrimary)
        ) {
            Text(
                text = "Generate",
                color = buttonTextColorPrimary,
                fontSize = 32.sp
            )
        }
    }
}



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
            }, colors = CheckboxDefaults.colors(checkedColor = buttonColorPrimary, uncheckedColor = textColorPrimary)
        )
        Text(
            text = text,
            color = textColorPrimary,
            fontSize = 22.sp
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
