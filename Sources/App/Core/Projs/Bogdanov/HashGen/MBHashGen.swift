//
//  File.swift
//  
//
//  Created by admin on 27.07.2023.
//

import Foundation

struct MBHashGen: FileProviderProtocol {
    static func dependencies(_ packageName: String) -> ANDData {
        return ANDData(
            mainFragmentData: ANDMainFragment(
                imports: "",
                content: """
            MBHashGen()
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
    
    static var fileName: String = "MBHashGen.kt"
    
    static func fileContent(packageName: String, uiSettings: UISettings) -> String {
        return """
package \(packageName).presentation.fragments.main_fragment

import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.text.BasicTextField
import androidx.compose.foundation.text.KeyboardOptions
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.CopyAll
import androidx.compose.material3.Icon
import androidx.compose.material3.Scaffold
import androidx.compose.material3.SnackbarHost
import androidx.compose.material3.SnackbarHostState
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.rememberCoroutineScope
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.platform.LocalClipboardManager
import androidx.compose.ui.text.AnnotatedString
import androidx.compose.ui.text.TextStyle
import androidx.compose.ui.text.input.KeyboardType
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewmodel.compose.viewModel
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.launch

val backColorPrimary = Color(0xFF\(uiSettings.backColorPrimary ?? "FFFFFF"))
val buttonColorPrimary = Color(0xFF\(uiSettings.buttonColorPrimary ?? "FFFFFF"))
val textColorPrimary = Color(0xFF\(uiSettings.textColorPrimary ?? "FFFFFF"))

@Composable
fun MBHashGen(appViewModel: AppViewModel = viewModel()) {
    val mainState = appViewModel.mainState.collectAsState()
    val clipManager = LocalClipboardManager.current
    val coroutineScope = rememberCoroutineScope()
    val snackState = remember {
        SnackbarHostState()
    }
    Scaffold(
        modifier = Modifier.fillMaxSize(),
        snackbarHost = {
            SnackbarHost(hostState = snackState)
        }
    ) { paddingValues ->
        Column(
            modifier = Modifier
                .fillMaxSize()
                .background(backColorPrimary)
                .padding(paddingValues),
            horizontalAlignment = Alignment.CenterHorizontally,
            verticalArrangement = Arrangement.SpaceBetween
        ) {
            Box(
                modifier = Modifier
                    .fillMaxSize()
                    .weight(1f)
                    .clickable {
                        clipManager.setText(AnnotatedString(mainState.value.outputText))
                        coroutineScope.launch {
                            snackState.showSnackbar(
                                "Copied"
                            )
                        }
                    }
                    .padding(8.dp),
                contentAlignment = Alignment.BottomCenter
            ) {
                Row(
                    modifier = Modifier
                        .fillMaxWidth()
                        .padding(8.dp),
                    verticalAlignment = Alignment.CenterVertically,
                    horizontalArrangement = Arrangement.SpaceBetween
                ) {
                    Text(
                        text = "Hashcode: ${mainState.value.outputText}",
                        textAlign = TextAlign.Center,
                        color = textColorPrimary
                    )

                    Icon(
                        imageVector = Icons.Default.CopyAll,
                        contentDescription = null,
                        tint = buttonColorPrimary
                    )
                }
            }
            var inputText by remember {
                mutableStateOf("")
            }

            BasicTextField(
                value = inputText,
                onValueChange = { newInputText ->
                    if (newInputText.length < 200) { //max length of input
                        inputText = newInputText
                        appViewModel.generateHash(newInputText)
                    }
                },
                textStyle = TextStyle(color = textColorPrimary, fontSize = 24.sp),
                modifier = Modifier
                    .fillMaxSize()
                    .weight(2f)
                    .padding(8.dp)
                    .border(
                        width = 2.dp,
                        color = buttonColorPrimary,
                        shape = RoundedCornerShape(4.dp)
                    )
                    .padding(4.dp),
                keyboardOptions = KeyboardOptions(
                    keyboardType = KeyboardType.Text
                )
            ) { innerTextField ->
                innerTextField()
            }
        }
    }
}

class AppViewModel : ViewModel() {

    private val _mainState = MutableStateFlow(MainState())
    val mainState = _mainState.asStateFlow()

    fun generateHash(inputText: String) = with(_mainState.value) {
        _mainState.value = copy(
            outputText = inputText.hashCode().toString()
        )
    }
}

data class MainState(
    val outputText: String = ""
)
"""
    }
    
    
}
