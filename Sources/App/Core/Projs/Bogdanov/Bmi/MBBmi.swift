//
//  File.swift
//  
//
//  Created by admin on 28.06.2023.
//

import Foundation

struct MBBmi: FileProviderProtocol {
    static func dependencies(_ packageName: String) -> ANDData {
        return ANDData(
            mainFragmentData: ANDMainFragment(
                imports: "",
                content: """
            MBBmi()
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
    
    static let fileName = "MBBmi.kt"
    static func fileContent(
        packageName: String,
        uiSettings: UISettings
    ) -> String {
        return """
package \(packageName).presentation.fragments.main_fragment

import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.text.BasicTextField
import androidx.compose.foundation.text.KeyboardOptions
import androidx.compose.material3.Button
import androidx.compose.material3.ButtonDefaults
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.TextStyle
import androidx.compose.ui.text.font.FontStyle
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.input.ImeAction
import androidx.compose.ui.text.input.KeyboardType
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import kotlin.math.roundToInt

val backColorPrimary = Color(0xFF\(uiSettings.backColorPrimary ?? "FFFFFF"))
val backColorSecondary = Color(0xFF\(uiSettings.backColorSecondary ?? "FFFFFF"))
val textColorPrimary = Color(0xFF\(uiSettings.textColorPrimary ?? "FFFFFF"))
val textColorSecondary = Color(0xFF\(uiSettings.textColorSecondary ?? "FFFFFF"))
val buttonColorPrimary = Color(0xFF\(uiSettings.buttonColorPrimary ?? "FFFFFF"))
val buttonTextColorPrimary = Color(0xFF\(uiSettings.buttonTextColorPrimary ?? "FFFFFF"))

@Composable
fun MBBmi() {
    Column(
        modifier = Modifier
            .fillMaxSize()
            .background(backColorPrimary),
        horizontalAlignment = Alignment.CenterHorizontally,
        verticalArrangement = Arrangement.SpaceAround
    ) {
        var inputHeight by remember {
            mutableStateOf("")
        }
        var inputWeight by remember {
            mutableStateOf("")
        }
        var output by remember {
            mutableStateOf("")
        }
        Text(
            text = output,
            modifier = Modifier
                .fillMaxWidth()
                .padding(horizontal = 64.dp, vertical = 32.dp),
            textAlign = TextAlign.Center,
            fontSize = 42.sp,
            fontStyle = FontStyle.Italic,
            color = textColorPrimary
        )
        Text(
            if (output.isEmpty()) "Enter weight and height" else "",
            modifier = Modifier
                .fillMaxWidth(),
            textAlign = TextAlign.Center,
            fontSize = 30.sp,
            color = textColorPrimary
        )
        Column(
            modifier = Modifier.background(backColorPrimary)
                .padding(8.dp)
        ) {
            BasicTextField(
                modifier = Modifier
                    .background(backColorPrimary)
                    .padding(4.dp),
                value = inputWeight,
                onValueChange = { str ->
                    if (str.isNotEmpty()) {
                        str.toFloatOrNull()?.let {
                            inputWeight = str
                        }
                    } else {
                        inputWeight = str
                    }
                },
                textStyle = TextStyle(
                    fontSize = 20.sp,
                    fontWeight = FontWeight.Medium,
                    color = textColorSecondary
                ),
                keyboardOptions = KeyboardOptions(
                    keyboardType = KeyboardType.Number,
                    imeAction = ImeAction.Done
                ),
                singleLine = true
            ) { innerTextField ->
                Row(
                    modifier = Modifier
                        .padding(8.dp)
                        .background(
                            color = backColorSecondary,
                            shape = RoundedCornerShape(size = 16.dp)
                        )
                        .border(
                            width = 2.dp,
                            color = buttonTextColorPrimary,
                            shape = RoundedCornerShape(size = 16.dp)
                        )
                        .padding(all = 16.dp),
                    verticalAlignment = Alignment.CenterVertically,
                    horizontalArrangement = Arrangement.Center
                ) {
                    Text(
                        text = "Weight: ",
                        modifier = Modifier
                            .padding(4.dp),
                        fontSize = 14.sp,
                        color = textColorSecondary
                    )
                    Spacer(
                        modifier = Modifier
                            .padding(horizontal = 3.dp)
                    )
                    innerTextField()
                }
            }
            BasicTextField(
                modifier = Modifier
                    .background(backColorPrimary)
                    .padding(4.dp),
                value = inputHeight,
                onValueChange = { str ->
                    if (str.isNotEmpty()) {
                        str.toFloatOrNull()?.let {
                            inputHeight = str
                        }
                    } else {
                        inputHeight = str
                    }
                },
                textStyle = TextStyle(
                    fontSize = 20.sp,
                    fontWeight = FontWeight.Medium,
                    color = textColorSecondary
                ),
                keyboardOptions = KeyboardOptions(
                    keyboardType = KeyboardType.Number,
                    imeAction = ImeAction.Done
                ),
                singleLine = true
            ) { innerTextField ->
                Row(
                    modifier = Modifier
                        .padding(8.dp)
                        .background(
                            color = backColorSecondary,
                            shape = RoundedCornerShape(size = 16.dp)
                        )
                        .border(
                            width = 2.dp,
                            color = buttonTextColorPrimary,
                            shape = RoundedCornerShape(size = 16.dp)
                        )
                        .padding(all = 16.dp),
                    verticalAlignment = Alignment.CenterVertically,
                    horizontalArrangement = Arrangement.Center
                ) {
                    Text(
                        text = "Height: ",
                        modifier = Modifier
                            .padding(4.dp),
                        fontSize = 14.sp,
                        color = textColorSecondary
                    )
                    Spacer(
                        modifier = Modifier
                            .padding(horizontal = 3.dp)
                    )
                    innerTextField()
                }
            }
        }
        Button(
            onClick = {
                if (inputWeight.isNotEmpty() && inputHeight.isNotEmpty()) {
                    var outputFloat = calculateBMI(
                        height = inputHeight.toFloatOrNull(),
                        weight = inputWeight.toFloatOrNull()
                    ).toFloatOrNull()
                    outputFloat = outputFloat?.let { float ->
                        (float * 100).roundToInt() / 100.0f
                    }
                    output = outputFloat.toString()
                } else {
                    output = "Empty Fields"
                }

            },
            modifier = Modifier
                .fillMaxWidth()
                .padding(horizontal = 96.dp),
            shape = RoundedCornerShape(8.dp),
            colors = ButtonDefaults.buttonColors(buttonColorPrimary)
        ) {
            Text(text = "CALCULATE", modifier = Modifier.padding(8.dp), color = buttonTextColorPrimary)
        }
    }
}

private fun calculateBMI(height: Float?, weight: Float?) =
    if (height != null && weight != null) {
        val heightInMeters = height / 100
        val result = weight / (heightInMeters * heightInMeters)
        "$result"
    } else {
        "Input data is invalid"
    }

"""
    }
}
