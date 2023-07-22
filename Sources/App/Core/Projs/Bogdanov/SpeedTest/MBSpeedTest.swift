//
//  File.swift
//  
//
//  Created by admin on 14.06.2023.
//

import Foundation

struct MBSpeedTest: FileProviderProtocol {
    static var fileName = "MBSpeedTest.kt"
    static func fileContent(
        packageName: String,
        uiSettings: UISettings
    ) -> String {
        return """
package \(packageName).presentation.fragments.main_fragment

import android.content.Context
import android.net.ConnectivityManager
import android.net.NetworkCapabilities
import androidx.compose.animation.core.Animatable
import androidx.compose.animation.core.AnimationVector1D
import androidx.compose.animation.core.tween
import androidx.compose.foundation.Canvas
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.aspectRatio
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Typography
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.remember
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.geometry.Offset
import androidx.compose.ui.geometry.Size
import androidx.compose.ui.graphics.Brush
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.drawscope.DrawScope
import androidx.compose.ui.text.ExperimentalTextApi
import androidx.compose.ui.text.TextMeasurer
import androidx.compose.ui.text.TextStyle
import androidx.compose.ui.text.drawText
import androidx.compose.ui.text.font.FontFamily
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.rememberTextMeasurer
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp

val backColor = Color(0xFF\(uiSettings.backColorPrimary ?? "FFFFFF"))
val mainTextColor = Color(0xFF\(uiSettings.textColorPrimary ?? "FFFFFF"))
val mainButtonColor = Color(0xFF\(uiSettings.buttonColorPrimary ?? "FFFFFF"))
val lapTextColor = Color(0xFF\(uiSettings.buttonColorSecondary ?? "FFFFFF"))
val mainTextSize = \(uiSettings.textSizePrimary ?? 24)
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
fun SpeedTestTheme(
    content: @Composable () -> Unit
) {
    MaterialTheme(
        typography = Typography,
        content = content
    )
}

@Composable
fun MainScreen(downSpeed: Float, upSpeed: Float) {
    Column(
        modifier = Modifier
            .fillMaxSize()
                    .background(color = backColor),
        verticalArrangement = Arrangement.SpaceEvenly,
        horizontalAlignment = Alignment.CenterHorizontally
    ) {
        val loadFactor = upSpeed / downSpeed
        val downLoadFactor = if (loadFactor > 1f) loadFactor else 1f
        val upLoadFactor = if (loadFactor > 1f) 1f else loadFactor
        Column(
            modifier = Modifier
                .padding(mainPadding.dp)
                    .background(color = backColor),
            horizontalAlignment = Alignment.CenterHorizontally,
            verticalArrangement = Arrangement.Center
        ) {
            val angle = remember {
                Animatable(0f)
            }
            LaunchedEffect(Unit) {
                angle.animateTo(
                    targetValue = 180f * upLoadFactor,
                    animationSpec = tween(5000)
                )
            }
            SpeedCanvas(
                angle = angle,
                textMeasurer = rememberTextMeasurer(),
                speed = upSpeed.toInt(),
                secondArcBackgroundColor = mainButtonColor,
                speedType = "Upload"
            )
        }
        Column(
            modifier = Modifier
                .padding(mainPadding.dp)
                    .background(color = backColor),
            horizontalAlignment = Alignment.CenterHorizontally,
            verticalArrangement = Arrangement.Center
        ) {
            val angle = remember {
                Animatable(0f)
            }
            LaunchedEffect(Unit) {
                angle.animateTo(
                    targetValue = 180f * downLoadFactor,
                    animationSpec = tween(5000)
                )
            }
            SpeedCanvas(
                angle = angle,
                textMeasurer = rememberTextMeasurer(),
                speed = downSpeed.toInt(),
                secondArcBackgroundColor = mainButtonColor,
                speedType = "Download"
            )
        }
    }
}

@Composable
fun SpeedCanvas(
    angle: Animatable<Float, AnimationVector1D>,
    textMeasurer: TextMeasurer,
    speed: Int,
    secondArcBackgroundColor: Color,
    speedType: String
) {
    Canvas(
        modifier = Modifier
            .fillMaxWidth(0.9f)
            .aspectRatio(1f)
                    .background(color = backColor)
    ) {
        val firstArcSize = size.width
        val firstArcOffset = (size.width - firstArcSize) / 2
        val secondArcSize = firstArcSize - 100
        val secondArcOffset = firstArcOffset + (firstArcSize - secondArcSize) / 2

        drawProgressLine(
            brush = Brush.verticalGradient(colors = listOf(lapTextColor, lapTextColor)),
            angle = angle,
            firstArcSize = firstArcSize,
            firstArcOffset = firstArcOffset,
            secondArcBackgroundColor = secondArcBackgroundColor,
            secondArcSize = secondArcSize,
            secondArcOffset = secondArcOffset
        )
        drawInfo(
            textMeasurer = textMeasurer,
            speed = "${speed}mbps",
            firstArcSize = firstArcSize,
            firstArcOffset = firstArcOffset,
            textStyle = TextStyle(
                fontFamily = FontFamily.Default,
                fontWeight = FontWeight.W500,
                fontSize = mainTextSize.sp,
                lineHeight = 24.sp,
                letterSpacing = 0.4.sp,
                textAlign = TextAlign.Center,
                color = mainTextColor,
            ),
            speedType = speedType
        )
    }
}

fun DrawScope.drawProgressLine(
    brush: Brush,
    angle: Animatable<Float, AnimationVector1D>,
    firstArcSize: Float,
    firstArcOffset: Float,
    secondArcBackgroundColor: Color?,
    secondArcSize: Float,
    secondArcOffset: Float
) {
    drawArc(
        brush = brush,
        startAngle = -180f,
        sweepAngle = angle.value,
        useCenter = true,
        size = Size(firstArcSize, firstArcSize),
        topLeft = Offset(
            firstArcOffset,
            firstArcOffset
        )
    )
    secondArcBackgroundColor?.let { backgroundColor ->
        drawArc(
            color = backgroundColor,
            startAngle = -180f,
            sweepAngle = 180f,
            useCenter = true,
            size = Size(secondArcSize, secondArcSize),
            topLeft = Offset(
                secondArcOffset,
                secondArcOffset + 1 // +1 because the second arc appears a little higher than the first
            )
        )
    }
}

@OptIn(ExperimentalTextApi::class)
fun DrawScope.drawInfo(
    textMeasurer: TextMeasurer,
    speed: String,
    firstArcSize: Float,
    firstArcOffset: Float,
    textStyle: TextStyle,
    speedType: String
) {
    drawText(
        textMeasurer = textMeasurer,
        text = speed,
        size = Size(firstArcSize, firstArcSize),
        topLeft = Offset(
            x = firstArcOffset,
            y = firstArcOffset + firstArcSize / 3
        ),
        style = textStyle
    )
    drawText(
        textMeasurer = textMeasurer,
        text = speedType,
        size = Size(firstArcSize, firstArcSize),
        topLeft = Offset(
            x = firstArcOffset,
            y = firstArcOffset + firstArcSize / 2
        ),
        style = textStyle
    )
}

object ConnectManager {

    private lateinit var connectivityManager: ConnectivityManager
    private var networkCapabilities: NetworkCapabilities? = null

    private fun initialize(context: Context){
        connectivityManager = context.getSystemService(Context.CONNECTIVITY_SERVICE) as ConnectivityManager
        networkCapabilities = connectivityManager.getNetworkCapabilities(connectivityManager.activeNetwork)
    }

    fun getUploadSpeed(context: Context): Float{
        if (networkCapabilities == null)
            initialize(context)
        return (networkCapabilities?.linkUpstreamBandwidthKbps?.toFloat() ?: 0.1f) / 125f
    }

    fun getDownloadSpeed(context: Context): Float{
        if (networkCapabilities == null)
            initialize(context)
        return (networkCapabilities?.linkDownstreamBandwidthKbps?.toFloat() ?: 0.1f) / 125f
    }
}
"""
    }
}
