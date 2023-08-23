//
//  File.swift
//  
//
//  Created by admin on 8/17/23.
//

import Foundation

struct KLBodyTypeCalculator: FileProviderProtocol {
    static var fileName: String = "BodyTypeCalculator.kt"
    
    static func fileContent(packageName: String, uiSettings: UISettings) -> String {
        return """
package \(packageName).presentation.fragments.main_fragment

import android.widget.Toast
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.ColumnScope
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.text.KeyboardOptions
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Straighten
import androidx.compose.material3.Button
import androidx.compose.material3.ButtonDefaults
import androidx.compose.material3.Icon
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.material3.TextField
import androidx.compose.material3.TextFieldDefaults
import androidx.compose.material3.Typography
import androidx.compose.material3.lightColorScheme
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.MutableState
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.draw.drawBehind
import androidx.compose.ui.geometry.CornerRadius
import androidx.compose.ui.geometry.Size
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.PathFillType
import androidx.compose.ui.graphics.SolidColor
import androidx.compose.ui.graphics.StrokeCap
import androidx.compose.ui.graphics.StrokeJoin
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.compose.ui.graphics.vector.path
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.res.stringArrayResource
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.TextStyle
import androidx.compose.ui.text.font.Font
import androidx.compose.ui.text.font.FontFamily
import androidx.compose.ui.text.input.ImeAction
import androidx.compose.ui.text.input.KeyboardType
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.hilt.navigation.compose.hiltViewModel
import androidx.lifecycle.SavedStateHandle
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import androidx.navigation.NamedNavArgument
import androidx.navigation.NavController
import androidx.navigation.NavType
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import androidx.navigation.compose.rememberNavController
import androidx.navigation.navArgument
import com.google.accompanist.systemuicontroller.rememberSystemUiController
import \(packageName).R
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.flow.MutableSharedFlow
import kotlinx.coroutines.launch
import javax.inject.Inject

//generator
val backColorPrimary = Color(0xFF\(uiSettings.backColorPrimary ?? "FFFFFF"))
val textColorPrimary = Color(0xFF\(uiSettings.textColorPrimary ?? "FFFFFF"))
val buttonColorPrimary = Color(0xFF\(uiSettings.buttonColorPrimary ?? "FFFFFF"))
val buttonTextColorPrimary = Color(0xFF\(uiSettings.buttonTextColorPrimary ?? "FFFFFF"))
val surfaceColor = Color(0xFF\(uiSettings.surfaceColor ?? "FFFFFF"))

//other
val appleColor = Color(0xFF99A24B)
val pearColor = Color(0xFFFFC107)
val bananaColor = Color(0xFFF8D363)
val hourglassColor = Color(0xFFF0A086)

val layoutPadding = 24.dp
val iconSize = 64.dp
val cornerRadius = 16.dp

val montserratLight = FontFamily(
    Font(R.font.montserrat_light)
)

val montserratMedium = FontFamily(
    Font(R.font.montserrat_medium)
)

val smallFontSize = 16.sp
val mediumFontSize = 20.sp

val typography = Typography(
    displaySmall = TextStyle(
        fontFamily = montserratLight, fontSize = smallFontSize, color = textColorPrimary
    ),
    displayMedium = TextStyle(
        fontFamily = montserratMedium, fontSize = mediumFontSize, color = textColorPrimary
    )
)

val colorScheme = lightColorScheme(
    background = backColorPrimary,
    primaryContainer = buttonColorPrimary,
    onPrimaryContainer = buttonTextColorPrimary,
    surface = surfaceColor,
    onSurface = textColorPrimary
)

@Composable
fun BodyTypeCalculator(
    content: @Composable () -> Unit
) {
    MaterialTheme(
        colorScheme = colorScheme,
        typography = typography,
        content = content
    )
}

@Composable
fun MainScreen(navController: NavController) {
    val viewModel = hiltViewModel<MainViewModel>()
    val context = LocalContext.current

    LaunchedEffect(key1 = context) {
        viewModel.validationEvent.collect { event ->
            when (event) {
                is ValidationEvent.Failure -> {
                    Toast.makeText(
                        context,
                        context.getString(R.string.invalid_input),
                        Toast.LENGTH_SHORT
                    ).show()
                }
            }
        }
    }

    BodyTypeCalculator {
        MainScreenContent(
            state = viewModel.state,
            onEvent = viewModel::onEvent,
            onCalculate = { bodyType ->
                navController.navigate(Screen.ResultScreen.createArg(bodyType))
            }
        )
    }
}

@Composable
fun MainScreenContent(
    state: MainState,
    onEvent: (MainEvent) -> Unit,
    onCalculate: (BodyType) -> Unit
) {
    val systemUiController = rememberSystemUiController()
    val backColor = MaterialTheme.colorScheme.background
    LaunchedEffect(key1 = backColor) {
        systemUiController.setSystemBarsColor(backColor)
    }

    Column(
        modifier = Modifier
            .fillMaxSize()
            .background(MaterialTheme.colorScheme.background)
            .padding(
                top = layoutPadding,
                start = layoutPadding,
                end = layoutPadding
            ),
        horizontalAlignment = Alignment.CenterHorizontally,
        verticalArrangement = Arrangement.SpaceBetween
    ) {
        IconRow(resultIcon = null)

        Column(
            modifier = Modifier
                .clip(
                    RoundedCornerShape(
                        topStart = cornerRadius,
                        topEnd = cornerRadius
                    )
                )
                .background(surfaceColor)
                .padding(
                    top = 150.dp,
                    bottom = 32.dp,
                    start = 32.dp,
                    end = 32.dp
                )
                .fillMaxWidth()
                .weight(0.8f),
            verticalArrangement = Arrangement.SpaceBetween
        ) {
            Column(
                verticalArrangement = Arrangement.spacedBy(24.dp)
            ) {
                ParameterTextField(
                    onValueChange = {
                        onEvent(MainEvent.BustChanged(it))
                    },
                    labelRes = R.string.bust_size,
                    imeAction = ImeAction.Next,
                    isError = state.hasBustError
                )
                ParameterTextField(
                    onValueChange = {
                        onEvent(MainEvent.WaistChanged(it))
                    },
                    labelRes = R.string.waist_size,
                    imeAction = ImeAction.Next,
                    isError = state.hasWaistError
                )
                ParameterTextField(
                    onValueChange = {
                        onEvent(MainEvent.HighHipChanged(it))
                    },
                    labelRes = R.string.high_hip_size,
                    imeAction = ImeAction.Next,
                    isError = state.hasHighHipError
                )
                ParameterTextField(
                    onValueChange = {
                        onEvent(MainEvent.HipChanged(it))
                    },
                    labelRes = R.string.hip_size,
                    imeAction = ImeAction.Done,
                    isError = state.hasHipError
                )
            }

            Button(
                modifier = Modifier
                    .fillMaxWidth()
                    .height(48.dp),
                colors = ButtonDefaults.buttonColors(
                    containerColor = MaterialTheme.colorScheme.primaryContainer,
                    contentColor = MaterialTheme.colorScheme.onPrimaryContainer
                ),
                onClick = {
                    onEvent(MainEvent.Calculate(onCalculate = onCalculate))
                }
            ) {
                Text(
                    text = stringResource(id = R.string.calculate),
                    style = MaterialTheme.typography.displayMedium,
                    color = MaterialTheme.colorScheme.onPrimaryContainer
                )
            }
        }
    }
}

@Composable
fun ParameterTextField(
    isError: Boolean,
    onValueChange: (String) -> Unit,
    labelRes: Int,
    imeAction: ImeAction
) {
    var text by remember { mutableStateOf("") }

    TextField(
        modifier = Modifier
            .fillMaxWidth()
            .height(50.dp),
        textStyle = MaterialTheme.typography.displaySmall,
        value = text,
        onValueChange = {
            text = it
            onValueChange(it)
        },
        label = { Text(text = stringResource(labelRes)) },
        isError = isError,
        colors = TextFieldDefaults.colors(
            focusedLabelColor = MaterialTheme.colorScheme.onSurface,
            unfocusedLabelColor = MaterialTheme.colorScheme.onSurface,
            focusedTextColor = MaterialTheme.colorScheme.onSurface,
            unfocusedTextColor = MaterialTheme.colorScheme.onSurface,
            focusedContainerColor = MaterialTheme.colorScheme.surface,
            unfocusedContainerColor = MaterialTheme.colorScheme.surface
        ),
        leadingIcon = {
            Icon(
                imageVector = Icons.Default.Straighten,
                contentDescription = null,
                tint = MaterialTheme.colorScheme.primaryContainer
            )
        },
        trailingIcon = {
            Text(text = stringResource(id = R.string.inches))
        },
        singleLine = true,
        keyboardOptions = KeyboardOptions(
            keyboardType = KeyboardType.Number,
            imeAction = imeAction
        )
    )
}

sealed class MainEvent {
    data class BustChanged(val bust: String) : MainEvent()
    data class WaistChanged(val waist: String) : MainEvent()
    data class HighHipChanged(val highHip: String) : MainEvent()
    data class HipChanged(val hip: String) : MainEvent()
    data class Calculate(val onCalculate: (BodyType) -> Unit) : MainEvent()
}

data class MainState(
    val bust: String = "",
    val waist: String = "",
    val highHip: String = "",
    val hips: String = "",
    val hasBustError: Boolean = false,
    val hasWaistError: Boolean = false,
    val hasHighHipError: Boolean = false,
    val hasHipError: Boolean = false,
    val result: BodyType? = null
)

@HiltViewModel
class MainViewModel @Inject constructor() : ViewModel() {

    var state by mutableStateOf(MainState())
        private set

    val validationEvent = MutableSharedFlow<ValidationEvent>()

    fun onEvent(event: MainEvent) {
        when (event) {
            is MainEvent.BustChanged -> {
                state = state.copy(
                    bust = event.bust
                )
            }

            is MainEvent.WaistChanged -> {
                state = state.copy(
                    waist = event.waist
                )
            }

            is MainEvent.HighHipChanged -> {
                state = state.copy(
                    highHip = event.highHip
                )
            }

            is MainEvent.HipChanged -> {
                state = state.copy(
                    hips = event.hip
                )
            }

            is MainEvent.Calculate -> {
                val isValid = validateInputs()
                if (isValid) {
                    calculateResult()
                    state.result?.let {
                        event.onCalculate(it)
                        state = MainState()
                    }
                }
            }
        }
    }

    private fun validateInputs(): Boolean {
        val bustValid = isInputValid(state.bust) { input ->
            state = state.copy(
                bust = input
            )
        }
        val waistValid = isInputValid(state.waist) { input ->
            state = state.copy(
                waist = input
            )
        }
        val highHipValid = isInputValid(state.highHip) { input ->
            state = state.copy(
                highHip = input
            )
        }
        val hipsValid = isInputValid(state.hips) { input ->
            state = state.copy(
                hips = input
            )
        }

        state = state.copy(
            hasBustError = !bustValid,
            hasWaistError = !waistValid,
            hasHighHipError = !highHipValid,
            hasHipError = !hipsValid
        )

        val hasError = listOf(
            bustValid,
            waistValid,
            highHipValid,
            hipsValid
        ).any { !it }

        viewModelScope.launch {
            if (hasError) {
                validationEvent.emit(ValidationEvent.Failure)
            }
        }

        return !hasError
    }

    private fun isInputValid(input: String, onCommaReplaced: (String) -> Unit): Boolean {
        var param = input
        if (param.contains(',')) {
            param = param.replace(',', '.')
            onCommaReplaced(param)
        }
        return param.toFloatOrNull() != null
    }

    private fun calculateResult() {
        val bust = state.bust.toFloat()
        val waist = state.waist.toFloat()
        val highHip = state.highHip.toFloat()
        val hips = state.hips.toFloat()

        val bustHips = bust - hips
        val hipsBust = hips - bust
        val bustWaist = bust - waist
        val hipsWaist = hips - waist

        when {
            (bustHips <= 1 && hipsBust < 3.6 && bustWaist >= 9 || hipsWaist >= 10) -> {
                state = state.copy(
                    result = BodyType.HOURGLASS
                )
            }
            (hipsBust >= 3.6 && hipsBust < 10 && hipsWaist >= 9 && (highHip < 1.193 || waist < 1.193)) -> {
                state = state.copy(
                    result = BodyType.HOURGLASS_BOTTOM
                )
            }
            (bustHips > 1 && bustHips < 10 && bustWaist >= 9) -> {
                state = state.copy(
                    result = BodyType.HOURGLASS_TOP
                )
            }
            (hipsBust > 2 && hipsWaist >= 7 && (highHip >= 1.193 || waist >= 1.193)) -> {
                state = state.copy(
                    result = BodyType.PEAR_SPOON
                )
            }
            (hipsBust >= 3.6 && hipsWaist < 9) -> {
                state = state.copy(
                    result = BodyType.PEAR_TRIANGLE
                )
            }
            (bustHips >= 3.6 && bustWaist < 9) -> {
                state = state.copy(
                    result = BodyType.APPLE
                )
            }
            (hipsBust < 3.6 && bustHips < 3.6 && bustWaist < 9 && hipsWaist < 10) -> {
                state = state.copy(
                    result = BodyType.BANANA
                )
            }
            else -> {
                state = state.copy(
                    result = BodyType.OTHER
                )
            }
        }
    }
}

sealed class ValidationEvent {
    object Failure: ValidationEvent()
}

@Composable
fun ResultScreen() {
    val viewModel = hiltViewModel<ResultViewModel>()
    BodyTypeCalculator {
        ResultScreenContent(
            state = viewModel.state.value
        )
    }
}

@Composable
fun ResultScreenContent(
    state: BodyType
) {
    val systemUiController = rememberSystemUiController()

    val backColor = state.icon?.color ?: MaterialTheme.colorScheme.background

    LaunchedEffect(key1 = backColor) {
        systemUiController.setSystemBarsColor(backColor)
    }

    Column(
        modifier = Modifier
            .fillMaxSize()
            .background(backColor)
            .padding(
                top = layoutPadding,
                start = layoutPadding,
                end = layoutPadding
            ),
        horizontalAlignment = Alignment.CenterHorizontally,
        verticalArrangement = Arrangement.SpaceBetween
    ) {
        IconRow(resultIcon = state.icon)
        Column(
            modifier = Modifier
                .clip(
                    RoundedCornerShape(
                        topStart = cornerRadius,
                        topEnd = cornerRadius
                    )
                )
                .verticalScroll(rememberScrollState())
                .background(surfaceColor)
                .padding(
                    start = 24.dp,
                    end = 24.dp,
                    top = 56.dp,
                    bottom = 16.dp
                )
                .fillMaxWidth()
                .weight(0.8f),
            verticalArrangement = Arrangement.spacedBy(24.dp)
        ) {

            Text(
                modifier = Modifier.fillMaxWidth(),
                textAlign = TextAlign.Center,
                style = MaterialTheme.typography.displayMedium,
                text = stringResource(id = state.titleRes)
            )

            state.descriptionRes?.let {
                Text(
                    modifier = Modifier.fillMaxWidth(),
                    textAlign = TextAlign.Center,
                    text = stringResource(id = it),
                    style = MaterialTheme.typography.displaySmall
                )
            }

            state.styleAdviceRes?.let {
                val advice = stringArrayResource(id = it)
                Text(
                    modifier = Modifier.fillMaxWidth(),
                    textAlign = TextAlign.Center,
                    style = MaterialTheme.typography.displayMedium,
                    text = stringResource(id = R.string.style_advice)
                )
                Column(
                    modifier = Modifier.padding(
                        start = 16.dp
                    ),
                    verticalArrangement = Arrangement.spacedBy(16.dp)
                ) {
                    advice.forEach { advice ->
                        Text(
                            text = advice,
                            style = MaterialTheme.typography.displaySmall
                        )
                    }
                }
            }
        }
    }
}

@HiltViewModel
class ResultViewModel @Inject constructor(
    savedStateHandle: SavedStateHandle
) : ViewModel() {
    var state: MutableState<BodyType> = mutableStateOf(BodyType.OTHER)
        private set

    init {
        val bodyTypeName = savedStateHandle.get<String>(Screen.bodyType)
        bodyTypeName?.let {
            val bodyType = BodyType.valueOf(bodyTypeName)
            state.value = bodyType
        }
    }
}

@Composable
fun ColumnScope.IconRow(
    resultIcon: Icon?
) {
    val icons = Icon.values()

    Row(
        modifier = Modifier
            .fillMaxWidth()
            .weight(0.2f),
        horizontalArrangement = Arrangement.SpaceBetween,
        verticalAlignment = Alignment.CenterVertically
    ) {
        icons.forEach { icon ->
            if (resultIcon != null) {
                if (icon == resultIcon) {
                    IconItem(
                        modifier = Modifier
                            .size(iconSize * icon.size)
                            .drawBehind {
                                drawRoundRect(
                                    color = surfaceColor,
                                    cornerRadius = CornerRadius(50f),
                                    size = Size(this.size.width, this.size.height * 2.5f)
                                )
                            }
                            .padding(4.dp),
                        imageVector = icon.icon,
                        tint = icon.color
                    )
                } else {
                    IconItem(
                        modifier = Modifier.size(iconSize * icon.size),
                        imageVector = icon.icon,
                        tint = Color.White
                    )
                }
            } else {
                IconItem(
                    modifier = Modifier.size(iconSize * icon.size),
                    imageVector = icon.icon,
                    tint = Color.White
                )
            }
        }
    }
}

@Composable
fun IconItem(
    modifier: Modifier,
    imageVector: ImageVector,
    tint: Color
) {
    Icon(
        modifier = modifier,
        imageVector = imageVector,
        contentDescription = null,
        tint = tint
    )
}

@Composable
fun Navigation() {
    val navController = rememberNavController()

    NavHost(navController = navController, startDestination = Screen.MainScreen.route) {
        composable(route = Screen.MainScreen.route) {
            MainScreen(navController)
        }
        composable(
            route = Screen.ResultScreen.route,
            arguments = Screen.ResultScreen.listArgs
        ) {
            ResultScreen()
        }
    }
}

sealed class Screen(val route: String, val listArgs: List<NamedNavArgument>) {
    object MainScreen : Screen(route = routeMain, listArgs = emptyList())

    object ResultScreen : Screen(
        route = "$routeResult/{$bodyType}",
        listArgs = listOf(
            navArgument(bodyType) {
                type = NavType.StringType
            }
        )
    ) {
        fun createArg(bodyType: BodyType) = "$routeResult/${bodyType.name}"
    }

    companion object {
        const val routeMain = "main_screen"
        const val routeResult = "result_screen"
        const val bodyType: String = "bodyType"
    }
}

enum class BodyType(
    val icon: Icon?,
    val titleRes: Int,
    val descriptionRes: Int?,
    val styleAdviceRes: Int?
) {
    APPLE(
        icon = Icon.APPLE,
        titleRes = R.string.apple,
        descriptionRes = R.string.apple_description,
        styleAdviceRes = R.array.apple_style_advice
    ),
    PEAR_SPOON(
        icon = Icon.PEAR,
        titleRes = R.string.pear_spoon,
        descriptionRes = R.string.pear_spoon_description,
        styleAdviceRes = R.array.pear_spoon_style_advice
    ),
    PEAR_TRIANGLE(
        icon = Icon.PEAR,
        titleRes = R.string.pear_triangle,
        descriptionRes = R.string.pear_triangle_description,
        styleAdviceRes = R.array.pear_triangle_style_advice
    ),
    BANANA(
        icon = Icon.BANANA,
        titleRes = R.string.banana,
        descriptionRes = R.string.banana_description,
        styleAdviceRes = R.array.banana_style_advice
    ),
    HOURGLASS(
        icon = Icon.HOURGLASS,
        titleRes = R.string.hourglass,
        descriptionRes = R.string.hourglass_description,
        styleAdviceRes = R.array.hourglass_style_advice
    ),
    HOURGLASS_TOP(
        icon = Icon.HOURGLASS,
        titleRes = R.string.hourglass_top,
        descriptionRes = R.string.hourglass_top_description,
        styleAdviceRes = R.array.hourglass_top_style_advice
    ),
    HOURGLASS_BOTTOM(
        icon = Icon.HOURGLASS,
        titleRes = R.string.hourglass_bottom,
        descriptionRes = R.string.hourglass_bottom_description,
        styleAdviceRes = R.array.hourglass_bottom_style_advice
    ),
    OTHER(
        icon = null,
        titleRes = R.string.other_body_type,
        descriptionRes = null,
        styleAdviceRes = null
    )
}

enum class Icon(
    val color: Color,
    val icon: ImageVector,
    val size: Float
) {
    APPLE(
        color = appleColor,
        icon = AppleIcon,
        size = 1f
    ),
    PEAR(
        color = pearColor,
        icon = PearIcon,
        size = 0.9f
    ),
    BANANA(
        color = bananaColor,
        icon = BananaIcon,
        size = 0.9f
    ),
    HOURGLASS(
        color = hourglassColor,
        icon = HourglassIcon,
        size = 0.9f
    )
}

val AppleIcon: ImageVector
    get() {
        if (_apple != null) {
            return _apple!!
        }
        _apple = ImageVector.Builder(
            name = "Apple", defaultWidth = 512.0.dp, defaultHeight = 512.0.dp,
            viewportWidth = 512.0f, viewportHeight = 512.0f
        ).apply {
            path(fill = SolidColor(Color(0xFF000000)), stroke = null, strokeLineWidth = 0.0f,
                strokeLineCap = StrokeCap.Butt, strokeLineJoin = StrokeJoin.Miter, strokeLineMiter = 4.0f,
                pathFillType = PathFillType.NonZero
            ) {
                moveTo(222.49f, 112.19f)
                curveToRelative(27.0f, 21.0f, 26.56f, 62.74f, 26.53f, 64.51f)
                arcToRelative(7.0f, 7.0f, 0.0f, false, false, 6.86f, 7.13f)
                lineTo(256.0f, 183.83f)
                arcToRelative(7.0f, 7.0f, 0.0f, false, false, 7.0f, -6.86f)
                arcToRelative(113.86f, 113.86f, 0.0f, false, false, -1.71f, -20.19f)
                curveToRelative(1.1f, 0.05f, 2.19f, 0.08f, 3.29f, 0.08f)
                arcTo(70.0f, 70.0f, 0.0f, false, false, 333.87f, 78.0f)
                lineToRelative(-0.68f, -5.38f)
                lineTo(327.81f, 72.0f)
                arcToRelative(70.09f, 70.09f, 0.0f, false, false, -76.93f, 53.14f)
                arcToRelative(73.81f, 73.81f, 0.0f, false, false, -19.79f, -24.0f)
                arcToRelative(7.0f, 7.0f, 0.0f, true, false, -8.6f, 11.0f)
                close()
                moveTo(279.39f, 101.81f)
                arcToRelative(55.65f, 55.65f, 0.0f, false, true, 41.0f, -16.38f)
                arcTo(56.0f, 56.0f, 0.0f, false, true, 263.0f, 142.84f)
                arcTo(55.65f, 55.65f, 0.0f, false, true, 279.39f, 101.81f)
                close()
            }
            path(fill = SolidColor(Color(0xFF000000)), stroke = null, strokeLineWidth = 0.0f,
                strokeLineCap = StrokeCap.Butt, strokeLineJoin = StrokeJoin.Miter, strokeLineMiter = 4.0f,
                pathFillType = PathFillType.NonZero
            ) {
                moveTo(386.71f, 263.94f)
                arcToRelative(110.63f, 110.63f, 0.0f, false, false, -33.07f, -57.44f)
                arcToRelative(85.26f, 85.26f, 0.0f, false, false, -83.19f, -18.66f)
                lineTo(256.0f, 192.38f)
                lineToRelative(-14.45f, -4.54f)
                arcToRelative(85.26f, 85.26f, 0.0f, false, false, -83.19f, 18.66f)
                arcTo(111.15f, 111.15f, 0.0f, false, false, 130.79f, 330.0f)
                lineToRelative(22.83f, 56.22f)
                arcToRelative(86.87f, 86.87f, 0.0f, false, false, 80.8f, 54.39f)
                horizontalLineToRelative(43.16f)
                arcToRelative(86.87f, 86.87f, 0.0f, false, false, 80.8f, -54.39f)
                lineTo(381.21f, 330.0f)
                arcTo(110.68f, 110.68f, 0.0f, false, false, 386.71f, 263.94f)
                close()
                moveTo(368.24f, 324.72f)
                lineTo(345.4f, 380.93f)
                arcToRelative(72.89f, 72.89f, 0.0f, false, true, -67.82f, 45.66f)
                lineTo(234.42f, 426.59f)
                arcToRelative(72.89f, 72.89f, 0.0f, false, true, -67.82f, -45.66f)
                lineToRelative(-22.84f, -56.21f)
                arcToRelative(97.17f, 97.17f, 0.0f, false, true, 24.1f, -107.93f)
                arcToRelative(71.17f, 71.17f, 0.0f, false, true, 69.5f, -15.59f)
                lineToRelative(16.54f, 5.19f)
                arcToRelative(7.0f, 7.0f, 0.0f, false, false, 4.2f, 0.0f)
                lineToRelative(16.54f, -5.19f)
                arcToRelative(71.2f, 71.2f, 0.0f, false, true, 69.5f, 15.59f)
                arcToRelative(97.17f, 97.17f, 0.0f, false, true, 24.1f, 107.93f)
                close()
            }
        }
            .build()
        return _apple!!
    }

private var _apple: ImageVector? = null

val BananaIcon: ImageVector
    get() {
        if (_banana != null) {
            return _banana!!
        }
        _banana = ImageVector.Builder(
            name = "Banana", defaultWidth = 512.0.dp, defaultHeight = 512.0.dp,
            viewportWidth = 512.0f, viewportHeight = 512.0f
        ).apply {
            path(fill = SolidColor(Color(0xFF000000)), stroke = null, strokeLineWidth = 0.0f,
                strokeLineCap = StrokeCap.Butt, strokeLineJoin = StrokeJoin.Miter, strokeLineMiter = 4.0f,
                pathFillType = PathFillType.NonZero
            ) {
                moveTo(425.05f, 166.78f)
                arcToRelative(79.82f, 79.82f, 0.0f, false, false, -32.66f, -35.87f)
                lineToRelative(-3.24f, -1.9f)
                arcTo(105.1f, 105.1f, 0.0f, false, true, 359.0f, 102.46f)
                lineToRelative(-28.1f, -36.38f)
                arcToRelative(16.69f, 16.69f, 0.0f, false, false, -23.54f, -2.9f)
                lineTo(290.94f, 76.12f)
                arcToRelative(16.57f, 16.57f, 0.0f, false, false, -3.0f, 23.11f)
                lineToRelative(33.27f, 44.29f)
                lineToRelative(1.34f, 6.72f)
                lineToRelative(0.76f, 5.11f)
                curveToRelative(-7.38f, 33.53f, -27.26f, 97.87f, -75.62f, 134.0f)
                curveToRelative(-34.2f, 25.54f, -79.41f, 33.38f, -134.37f, 23.3f)
                lineTo(90.0f, 306.48f)
                arcToRelative(7.0f, 7.0f, 0.0f, false, false, -8.75f, 6.0f)
                lineToRelative(-3.57f, 31.65f)
                arcToRelative(7.0f, 7.0f, 0.0f, false, false, 3.17f, 6.68f)
                lineToRelative(15.64f, 10.0f)
                lineToRelative(0.38f, 0.23f)
                lineToRelative(44.45f, 24.61f)
                arcToRelative(7.07f, 7.07f, 0.0f, false, false, -3.93f, 2.37f)
                arcToRelative(7.0f, 7.0f, 0.0f, false, false, -1.52f, 5.62f)
                lineToRelative(5.24f, 31.41f)
                arcToRelative(7.0f, 7.0f, 0.0f, false, false, 4.89f, 5.56f)
                lineTo(163.81f, 436.0f)
                lineToRelative(0.43f, 0.11f)
                lineToRelative(53.09f, 12.32f)
                arcToRelative(155.4f, 155.4f, 0.0f, false, false, 158.22f, -56.54f)
                lineToRelative(0.68f, -0.9f)
                curveToRelative(44.0f, -58.11f, 55.86f, -128.0f, 58.0f, -176.47f)
                arcTo(104.72f, 104.72f, 0.0f, false, false, 425.05f, 166.78f)
                close()
                moveTo(92.11f, 341.35f)
                lineToRelative(2.17f, -19.26f)
                lineTo(110.0f, 326.25f)
                lineToRelative(0.52f, 0.11f)
                quadToRelative(8.69f, 1.61f, 17.07f, 2.63f)
                lineToRelative(-1.49f, 16.4f)
                arcToRelative(7.0f, 7.0f, 0.0f, false, false, 6.34f, 7.61f)
                curveToRelative(0.21f, 0.0f, 0.43f, 0.0f, 0.64f, 0.0f)
                arcToRelative(7.0f, 7.0f, 0.0f, false, false, 7.0f, -6.36f)
                lineToRelative(1.49f, -16.32f)
                curveToRelative(45.38f, 3.14f, 83.81f, -6.83f, 114.53f, -29.78f)
                curveToRelative(36.68f, -27.4f, 58.0f, -69.29f, 70.12f, -104.06f)
                curveToRelative(-0.05f, 36.51f, -6.27f, 89.53f, -36.59f, 129.28f)
                curveToRelative(-25.08f, 32.89f, -64.66f, 52.63f, -117.7f, 58.71f)
                arcToRelative(141.91f, 141.91f, 0.0f, false, true, -20.53f, -9.3f)
                lineTo(103.88f, 348.9f)
                close()
                moveTo(420.25f, 213.86f)
                curveToRelative(-2.06f, 46.44f, -13.31f, 113.4f, -55.17f, 168.63f)
                lineToRelative(-0.66f, 0.86f)
                arcToRelative(141.38f, 141.38f, 0.0f, false, true, -143.93f, 51.4f)
                lineToRelative(-52.86f, -12.27f)
                lineToRelative(-13.4f, -4.0f)
                lineToRelative(-3.18f, -19.12f)
                lineTo(167.3f, 399.0f)
                arcToRelative(4.58f, 4.58f, 0.0f, false, false, 0.53f, 0.0f)
                quadToRelative(8.68f, -0.83f, 16.94f, -2.12f)
                lineTo(188.23f, 415.0f)
                arcToRelative(7.0f, 7.0f, 0.0f, false, false, 6.87f, 5.68f)
                arcToRelative(7.45f, 7.45f, 0.0f, false, false, 1.32f, -0.12f)
                arcToRelative(7.0f, 7.0f, 0.0f, false, false, 5.56f, -8.19f)
                lineToRelative(-3.44f, -18.0f)
                curveToRelative(44.6f, -9.41f, 78.89f, -29.55f, 102.18f, -60.09f)
                curveToRelative(44.55f, -58.41f, 40.83f, -141.93f, 37.81f, -171.49f)
                arcToRelative(5.85f, 5.85f, 0.0f, false, false, -0.07f, -0.72f)
                lineToRelative(0.0f, -0.14f)
                curveToRelative(-0.65f, -6.2f, -1.25f, -9.82f, -1.28f, -10.0f)
                lineToRelative(0.0f, -0.19f)
                lineToRelative(-1.71f, -8.53f)
                lineToRelative(13.27f, -11.6f)
                arcToRelative(7.0f, 7.0f, 0.0f, true, false, -9.21f, -10.54f)
                lineToRelative(-10.65f, 9.31f)
                lineToRelative(-29.7f, -39.54f)
                arcToRelative(2.66f, 2.66f, 0.0f, false, true, 0.48f, -3.71f)
                lineTo(316.0f, 74.17f)
                arcToRelative(2.64f, 2.64f, 0.0f, false, true, 2.0f, -0.56f)
                arcToRelative(2.67f, 2.67f, 0.0f, false, true, 1.79f, 1.0f)
                lineTo(347.89f, 111.0f)
                arcToRelative(119.27f, 119.27f, 0.0f, false, false, 34.18f, 30.07f)
                lineToRelative(3.24f, 1.9f)
                arcToRelative(65.9f, 65.9f, 0.0f, false, true, 27.0f, 29.58f)
                arcTo(90.7f, 90.7f, 0.0f, false, true, 420.25f, 213.86f)
                close()
            }
        }
            .build()
        return _banana!!
    }

private var _banana: ImageVector? = null

val HourglassIcon: ImageVector
    get() {
        if (_hourglass != null) {
            return _hourglass!!
        }
        _hourglass = ImageVector.Builder(
            name = "Hourglass", defaultWidth = 128.0.dp, defaultHeight = 128.0.dp,
            viewportWidth = 128.0f, viewportHeight = 128.0f
        ).apply {
            path(fill = SolidColor(Color(0xFF000000)), stroke = null, strokeLineWidth = 0.0f,
                strokeLineCap = StrokeCap.Butt, strokeLineJoin = StrokeJoin.Miter, strokeLineMiter = 4.0f,
                pathFillType = PathFillType.NonZero
            ) {
                moveTo(75.692f, 62.983f)
                curveTo(83.673f, 57.49f, 96.946f, 44.554f, 97.471f, 19.2f)
                arcToRelative(5.757f, 5.757f, 0.0f, false, false, 4.264f, -5.549f)
                lineTo(101.735f, 6.307f)
                arcToRelative(1.75f, 1.75f, 0.0f, false, false, -1.75f, -1.75f)
                lineTo(28.015f, 4.557f)
                arcToRelative(1.75f, 1.75f, 0.0f, false, false, -1.75f, 1.75f)
                verticalLineToRelative(7.348f)
                arcTo(5.757f, 5.757f, 0.0f, false, false, 30.529f, 19.2f)
                curveToRelative(0.525f, 25.35f, 13.8f, 38.286f, 21.779f, 43.779f)
                arcToRelative(1.235f, 1.235f, 0.0f, false, true, 0.0f, 2.034f)
                curveTo(44.327f, 70.51f, 31.054f, 83.446f, 30.529f, 108.8f)
                arcToRelative(5.757f, 5.757f, 0.0f, false, false, -4.264f, 5.549f)
                verticalLineToRelative(7.348f)
                arcToRelative(1.75f, 1.75f, 0.0f, false, false, 1.75f, 1.75f)
                horizontalLineToRelative(71.97f)
                arcToRelative(1.75f, 1.75f, 0.0f, false, false, 1.75f, -1.75f)
                verticalLineToRelative(-7.348f)
                arcToRelative(5.757f, 5.757f, 0.0f, false, false, -4.264f, -5.549f)
                curveToRelative(-0.525f, -25.35f, -13.8f, -38.286f, -21.779f, -43.779f)
                arcToRelative(1.235f, 1.235f, 0.0f, false, true, 0.0f, -2.034f)
                close()
                moveTo(29.765f, 13.655f)
                verticalLineToRelative(-5.6f)
                horizontalLineToRelative(68.47f)
                verticalLineToRelative(5.6f)
                arcToRelative(2.252f, 2.252f, 0.0f, false, true, -2.25f, 2.25f)
                lineTo(32.015f, 15.905f)
                arcTo(2.252f, 2.252f, 0.0f, false, true, 29.765f, 13.655f)
                close()
                moveTo(98.235f, 114.345f)
                verticalLineToRelative(5.6f)
                lineTo(29.765f, 119.945f)
                verticalLineToRelative(-5.6f)
                arcToRelative(2.252f, 2.252f, 0.0f, false, true, 2.25f, -2.25f)
                horizontalLineToRelative(63.97f)
                arcTo(2.252f, 2.252f, 0.0f, false, true, 98.235f, 114.345f)
                close()
                moveTo(42.043f, 108.6f)
                arcToRelative(54.361f, 54.361f, 0.0f, false, true, 0.9f, -8.571f)
                arcToRelative(3.241f, 3.241f, 0.0f, false, true, 1.764f, -2.281f)
                lineToRelative(10.831f, -5.3f)
                arcToRelative(19.122f, 19.122f, 0.0f, false, true, 16.92f, 0.0f)
                lineToRelative(10.83f, 5.3f)
                arcToRelative(3.239f, 3.239f, 0.0f, false, true, 1.764f, 2.28f)
                arcToRelative(54.373f, 54.373f, 0.0f, false, true, 0.9f, 8.572f)
                close()
                moveTo(73.707f, 67.9f)
                curveToRelative(7.4f, 5.091f, 19.678f, 17.081f, 20.261f, 40.7f)
                lineTo(89.457f, 108.6f)
                arcToRelative(57.871f, 57.871f, 0.0f, false, false, -0.965f, -9.229f)
                arcTo(6.755f, 6.755f, 0.0f, false, false, 84.829f, 94.6f)
                lineTo(74.0f, 89.3f)
                arcToRelative(22.6f, 22.6f, 0.0f, false, false, -20.0f, 0.0f)
                lineTo(43.171f, 94.6f)
                arcToRelative(6.752f, 6.752f, 0.0f, false, false, -3.663f, 4.768f)
                arcToRelative(57.871f, 57.871f, 0.0f, false, false, -0.965f, 9.228f)
                lineTo(34.032f, 108.596f)
                curveTo(34.615f, 84.98f, 46.9f, 72.99f, 54.292f, 67.9f)
                arcToRelative(4.733f, 4.733f, 0.0f, false, false, 0.0f, -7.8f)
                curveToRelative(-7.4f, -5.091f, -19.677f, -17.081f, -20.26f, -40.7f)
                lineTo(93.968f, 19.4f)
                curveTo(93.385f, 43.02f, 81.1f, 55.01f, 73.707f, 60.1f)
                arcToRelative(4.734f, 4.734f, 0.0f, false, false, 0.0f, 7.8f)
                close()
            }
            path(fill = SolidColor(Color(0xFF000000)), stroke = null, strokeLineWidth = 0.0f,
                strokeLineCap = StrokeCap.Butt, strokeLineJoin = StrokeJoin.Miter, strokeLineMiter = 4.0f,
                pathFillType = PathFillType.NonZero
            ) {
                moveTo(87.338f, 33.426f)
                arcToRelative(1.75f, 1.75f, 0.0f, false, false, -2.322f, -2.121f)
                curveToRelative(-11.256f, 4.451f, -15.517f, 2.48f, -20.45f, 0.2f)
                arcToRelative(27.059f, 27.059f, 0.0f, false, false, -9.0f, -2.84f)
                arcToRelative(23.93f, 23.93f, 0.0f, false, false, -14.142f, 2.779f)
                arcToRelative(1.751f, 1.751f, 0.0f, false, false, -0.76f, 1.983f)
                curveToRelative(5.324f, 18.122f, 18.809f, 24.616f, 19.44f, 24.91f)
                arcToRelative(9.484f, 9.484f, 0.0f, false, false, 3.915f, 0.85f)
                arcToRelative(9.279f, 9.279f, 0.0f, false, false, 3.9f, -0.856f)
                lineToRelative(0.109f, -0.05f)
                curveTo(68.592f, 58.013f, 82.024f, 51.52f, 87.338f, 33.426f)
                close()
                moveTo(66.572f, 55.1f)
                lineToRelative(-0.128f, 0.059f)
                arcToRelative(5.814f, 5.814f, 0.0f, false, true, -4.918f, -0.014f)
                curveToRelative(-0.5f, -0.234f, -11.945f, -5.75f, -17.074f, -21.315f)
                arcToRelative(21.2f, 21.2f, 0.0f, false, true, 10.735f, -1.68f)
                arcTo(23.849f, 23.849f, 0.0f, false, true, 63.1f, 34.681f)
                curveToRelative(4.689f, 2.167f, 9.523f, 4.4f, 19.746f, 1.123f)
                curveTo(77.456f, 49.837f, 67.011f, 54.888f, 66.572f, 55.1f)
                close()
            }
        }
            .build()
        return _hourglass!!
    }

private var _hourglass: ImageVector? = null

val PearIcon: ImageVector
    get() {
        if (_pear != null) {
            return _pear!!
        }
        _pear = ImageVector.Builder(
            name = "Pear", defaultWidth = 512.0.dp, defaultHeight = 512.0.dp,
            viewportWidth = 512.0f, viewportHeight = 512.0f
        ).apply {
            path(fill = SolidColor(Color(0xFF000000)), stroke = null, strokeLineWidth = 0.0f,
                strokeLineCap = StrokeCap.Butt, strokeLineJoin = StrokeJoin.Miter, strokeLineMiter = 4.0f,
                pathFillType = PathFillType.NonZero
            ) {
                moveTo(348.15f, 281.66f)
                curveToRelative(-21.0f, -23.32f, -31.29f, -48.17f, -31.29f, -76.0f)
                verticalLineToRelative(-1.92f)
                arcToRelative(60.86f, 60.86f, 0.0f, true, false, -121.72f, 0.0f)
                verticalLineToRelative(1.92f)
                curveToRelative(0.0f, 27.81f, -10.22f, 52.64f, -31.25f, 75.92f)
                arcToRelative(123.81f, 123.81f, 0.0f, false, false, -32.0f, 83.69f)
                curveToRelative(0.27f, 67.18f, 55.13f, 122.62f, 122.29f, 123.58f)
                horizontalLineTo(256.0f)
                arcToRelative(124.11f, 124.11f, 0.0f, false, false, 92.13f, -207.24f)
                close()
                moveTo(333.3f, 443.21f)
                arcToRelative(109.31f, 109.31f, 0.0f, false, true, -78.92f, 31.68f)
                curveToRelative(-59.58f, -0.85f, -108.25f, -50.0f, -108.49f, -109.64f)
                arcTo(109.87f, 109.87f, 0.0f, false, true, 174.27f, 291.0f)
                curveToRelative(23.47f, -26.0f, 34.87f, -53.86f, 34.87f, -85.3f)
                verticalLineToRelative(-1.92f)
                arcToRelative(46.86f, 46.86f, 0.0f, true, true, 93.72f, 0.0f)
                verticalLineToRelative(1.92f)
                curveToRelative(0.0f, 31.41f, 11.42f, 59.33f, 34.9f, 85.35f)
                horizontalLineToRelative(0.0f)
                arcToRelative(110.1f, 110.1f, 0.0f, false, true, -4.46f, 152.16f)
                close()
            }
            path(fill = SolidColor(Color(0xFF000000)), stroke = null, strokeLineWidth = 0.0f,
                strokeLineCap = StrokeCap.Butt, strokeLineJoin = StrokeJoin.Miter, strokeLineMiter = 4.0f,
                pathFillType = PathFillType.NonZero
            ) {
                moveTo(223.05f, 63.88f)
                curveToRelative(27.0f, 21.0f, 26.56f, 62.74f, 26.52f, 64.5f)
                arcToRelative(7.0f, 7.0f, 0.0f, false, false, 6.87f, 7.14f)
                horizontalLineToRelative(0.13f)
                arcToRelative(7.0f, 7.0f, 0.0f, false, false, 7.0f, -6.87f)
                arcToRelative(113.86f, 113.86f, 0.0f, false, false, -1.71f, -20.19f)
                curveToRelative(1.09f, 0.05f, 2.19f, 0.09f, 3.28f, 0.09f)
                arcToRelative(70.0f, 70.0f, 0.0f, false, false, 69.29f, -78.82f)
                lineToRelative(-0.68f, -5.39f)
                lineToRelative(-5.38f, -0.68f)
                arcToRelative(70.06f, 70.06f, 0.0f, false, false, -76.93f, 53.15f)
                arcToRelative(73.62f, 73.62f, 0.0f, false, false, -19.8f, -24.0f)
                arcToRelative(7.0f, 7.0f, 0.0f, true, false, -8.59f, 11.05f)
                close()
                moveTo(280.0f, 53.5f)
                arcToRelative(55.69f, 55.69f, 0.0f, false, true, 41.0f, -16.38f)
                arcToRelative(56.0f, 56.0f, 0.0f, false, true, -57.4f, 57.4f)
                arcTo(55.61f, 55.61f, 0.0f, false, true, 280.0f, 53.5f)
                close()
            }
        }
            .build()
        return _pear!!
    }

private var _pear: ImageVector? = null

"""
    }
    
    static func dependencies(_ mainData: MainData) -> ANDData {
        ANDData(mainFragmentData: ANDMainFragment(imports: "", content: """
                Navigation()
"""),
                mainActivityData: ANDMainActivity(imports: "", extraFunc: "", content: ""),
                themesData: ANDThemesData(isDefault: true, content: ""),
                stringsData: ANDStringsData(additional: """
    <string name="bust_size">Bust Size</string>
    <string name="waist_size">Waist Size</string>
    <string name="high_hip_size">High Hip Size</string>
    <string name="hip_size">Hip Size</string>

    <string name="calculate">Calculate</string>
    <string name="style_advice">Style Advice</string>
    <string name="invalid_input">Invalid Input</string>
    <string name="inches">in</string>

    <string name="other_body_type">Your body is too unique to fit in certain body type.</string>

    <string name="apple">Apple, or Inverted Triangle</string>
    <string name="apple_description">
        You have a subtle waist and a proportionally larger upper body. Your bust and shoulders are pretty broad, and the hips are slim.
    </string>
    <string-array name="apple_style_advice">
        <item>1) Highlight your legs: Since apple body types tend to have slimmer legs, draw attention to this asset by wearing skirts, dresses, or pants that flatter your lower half. Opt for styles that are tailored and slimming, such as straight-leg or bootcut pants.</item>
        <item>2) Emphasize your upper body: To balance out your proportions, focus on enhancing your upper body. Choose tops with V-necks or scoop necklines to elongate your neck and draw attention upward. Experiment with structured blazers or jackets to create the illusion of a more defined waistline.</item>
        <item>3) Choose empire waistlines: Dresses or tops with empire waistlines can be flattering for apple shapes as they cinch just below the bust, creating a more defined waistline while still providing room for the midsection.</item>
        <item>4) Go for A-line silhouettes: A-line dresses or skirts that gently flare out from the waist can help create a more hourglass-like figure. This style minimizes attention on the midsection and accentuates the hips, creating a more balanced appearance.</item>
        <item>5) Opt for monochromatic outfits: Wearing one color from head to toe can create a streamlined look, minimizing the focus on specific areas of the body. This can help create a more balanced silhouette for apple body types.</item>
        <item>6) Use accessories strategically: Draw attention away from the midsection by accessorizing with statement jewelry, scarves, or belts worn at the narrowest part of your waist. This can help create the illusion of a more defined waistline.</item>
    </string-array>

    <string name="pear_spoon">Pear, or Spoon</string>
    <string name="pear_spoon_description">
        Your hips are much larger than your bust. Your hips have a shelf-like appearance, and you have a well defined waist.
    </string>
    <string-array name="pear_spoon_style_advice">
        <item>1) Emphasize your waist: The spoon body type typically has a defined waistline, so highlight this feature by wearing clothing that cinches at the waist. Opt for fitted tops or dresses that accentuate your curves and create an hourglass silhouette.</item>
        <item>2) Choose A-line or flared skirts: A-line or flared skirts can help balance out wider hips and thighs. Look for styles that fall just above or below the knee to elongate your legs and create a more proportionate look.</item>
        <item>3) Opt for structured tops: Structured tops with shoulder pads or tailored details can help broaden the shoulders and create a more balanced upper body. Look for tops with interesting necklines, such as V-necks or boat necks, to draw attention upward.</item>
        <item>4) Avoid clingy fabrics: Avoid clingy fabrics that may highlight the wider hips and thighs. Opt for fabrics with some structure, such as cotton or denim, that will skim over your curves without clinging too tightly.</item>
        <item>5) Experiment with statement sleeves: Statement sleeves, such as bell sleeves or puffed sleeves, can add volume to the upper body and create a more balanced silhouette. Pair them with fitted bottoms to highlight your waistline.</item>
        <item>6) Play with patterns and prints: Patterns and prints can help draw attention away from the lower body and add visual interest to your overall look. Opt for tops or dresses with bold prints or patterns to divert attention to the upper body.</item>
        <item>7) Choose footwear wisely: Opt for shoes with a slight heel or wedges to elongate your legs and create a more balanced look. Avoid ankle straps that may visually cut off your legs and make them appear shorter.</item>
    </string-array>

    <string name="pear_triangle">Pear, or Triangle</string>
    <string name="pear_triangle_description">
        You have a slim upper body and wide hips (typically wider than the shoulders). The waist is not clearly accentuated.
    </string>
    <string-array name="pear_triangle_style_advice">
        <item>1) Emphasize the upper body: Since the triangle body type typically has narrower shoulders and wider hips, it\\'s important to create balance by drawing attention to the upper body. Opt for tops with interesting necklines, such as boat necks, off-the-shoulder, or halter tops. These styles will broaden your shoulders and create a more balanced silhouette.</item>
        <item>2) Choose A-line skirts and dresses: A-line skirts and dresses are perfect for triangle body types as they flare out from the waist, creating a more proportionate look. Look for skirts that hit just above or below the knee to highlight your legs and minimize attention on the hips. Avoid clingy fabrics or excessive ruffles around the hip area.</item>
        <item>3) Use patterns strategically: Incorporating patterns into your outfits can help create the illusion of a more balanced figure. Opt for tops with bold prints, horizontal stripes, or embellishments to draw attention to your upper body. Keep the bottom half simpler and opt for solid colors or smaller prints to minimize attention on the hips.</item>
        <item>4) Highlight your waist: Accentuating your waist is key for triangle body types as it helps create an hourglass shape. Look for dresses or tops with cinched waists, wrap styles, or belts to define your waistline. This will help balance out your broader hips and create a more feminine silhouette.</item>
        <item>5) Experiment with different pant styles: When it comes to pants, choose styles that add volume to your lower body to balance out your proportions. Wide-leg pants, bootcut jeans, or flared trousers can help create the illusion of fuller hips and thighs. Avoid skinny jeans or tapered pants as they can emphasize the triangle shape.</item>
        <item>6) Layer strategically: Layering can be a great way to add dimension and balance to your outfit. Opt for structured jackets or blazers that hit at the hip to add volume to your upper body. Pair them with tops that have interesting details or textures to draw attention upwards.</item>
        <item>7) Choose the right swimwear: When it comes to swimwear, opt for bikini tops with padding or push-up styles to enhance your bust and create more balance with your hips. Look for bottoms with ruching, side ties, or patterns to draw attention away from the hip area. High-waisted bikini bottoms or tankinis can also be flattering options for triangle body types.</item>
    </string-array>

    <string name="banana">Banana, or Rectangle</string>
    <string name="banana_description">
        Your hips, waist, and bust are about the same size. Your body is well proportioned and athletic in appearance.
    </string>
    <string-array name="banana_style_advice">
        <item>1) Create curves with clothing: Since the rectangle body type typically has a straight silhouette with minimal curves, it\\'s important to create the illusion of curves with your clothing choices. Look for tops and dresses with ruffles, peplum details, or draping around the bust and waist to add volume and create a more feminine shape.</item>
        <item>2) Define your waist: Enhancing your waistline is key for rectangle body types as it helps create the illusion of curves. Opt for dresses or tops with cinched waists, wrap styles, or belts to add definition to your midsection. This will help create a more hourglass-like silhouette.</item>
        <item>3) Play with different necklines: Experimenting with different necklines can help add interest and balance to your figure. Opt for tops or dresses with plunging necklines, sweetheart necklines, or scoop necks to create the illusion of a fuller bust. Avoid high necklines or boat necks that can accentuate the straightness of your body.</item>
        <item>4) Choose fitted clothing: Fitted clothing can help create the appearance of curves and add dimension to your figure. Look for tailored blazers, structured tops, and dresses that hug your body in the right places. Avoid oversized or boxy silhouettes that can make you appear shapeless.</item>
        <item>5) Add volume to your lower body: To balance out your straighter figure, choose bottoms that add volume to your lower body. Opt for skirts and dresses with flared or A-line silhouettes to create the illusion of fuller hips. Wide-leg pants, palazzo pants, or bootcut jeans can also help add curves to your lower half.</item>
        <item>6) Experiment with layering: Layering can add depth and dimension to your outfits. Try layering a fitted top under a cropped jacket or cardigan to create the illusion of a defined waist. Pair this with a skirt or pants that add volume to your lower body for a balanced look.</item>
        <item>7) Play with patterns and textures: Incorporating patterns and textures into your outfits can help create the illusion of curves and add interest to your figure. Opt for tops or dresses with bold prints, horizontal stripes, or embellishments around the bust and waist area. This will draw attention and create the appearance of curves.</item>
    </string-array>

    <string name="hourglass">Hourglass</string>
    <string name="hourglass_description">
        Your body shape is balanced and harmonious. The bust and hips are proportional and well-balanced, and the waist is clearly defined
    </string>
    <string-array name="hourglass_style_advice">
        <item>1) Emphasize your waist: The hourglass body type is characterized by a well-defined waist, so it\\'s important to highlight this feature. Opt for dresses and tops with cinched waists, wrap styles, or belts to accentuate your curves. This will help create an hourglass silhouette and showcase your natural shape.</item>
        <item>2) Choose fitted clothing: Fitted clothing is key for hourglass body types as it helps showcase your curves. Look for dresses, tops, and skirts that hug your body in all the right places. Avoid oversized or boxy silhouettes that can hide your curves and make you appear shapeless.</item>
        <item>3) V-necklines are your friend: V-necklines are particularly flattering for hourglass body types as they help elongate the neck and draw attention to the bust. Look for tops or dresses with plunging necklines, wrap styles, or sweetheart necklines to enhance your décolletage and showcase your curves.</item>
        <item>4) Embrace bodycon styles: Bodycon dresses and skirts are perfect for hourglass body types as they highlight your curves and create a sexy, feminine look. Opt for styles that are made from stretchy fabrics to ensure a comfortable fit that hugs your body in all the right places.</item>
        <item>5) Balance your proportions: Since hourglass body types have well-balanced proportions, it\\'s important to maintain this balance in your outfits. Avoid wearing overly voluminous or oversized pieces on both the top and bottom. Instead, opt for fitted tops paired with bottoms that accentuate your curves, such as pencil skirts, high-waisted jeans, or tailored trousers.</item>
        <item>6) Show off your legs: Hourglass body types often have shapely legs, so don\\'t be afraid to show them off! Opt for skirts and dresses that hit at or above the knee to highlight your legs. Pair them with heels or wedges to further elongate your silhouette.</item>
        <item>7) Experiment with different fabrics and textures: Incorporating different fabrics and textures into your outfits can add interest and dimension to your look. Opt for fabrics that drape well and hug your curves, such as silk, satin, or jersey. You can also play with textures like lace, sequins, or ruffles to enhance certain areas of your body and create visual interest.</item>
    </string-array>

    <string name="hourglass_top">Top Hourglass</string>
    <string name="hourglass_top_description">
        Your body is similar to the regular hourglass with a defined waist. Your bust is visibly larger than your hips.
    </string>
    <string-array name="hourglass_top_style_advice">
        <item>1) Balance your proportions: Hourglass top body types typically have a larger bust and narrower waist, so it\\'s important to balance your proportions. Opt for tops that highlight your waist and create a defined silhouette. Look for fitted tops with darts or princess seams that accentuate your curves without adding bulk to your bust.</item>
        <item>2) V-necklines are your friend: V-necklines are particularly flattering for hourglass top body types as they help elongate the neck and draw attention away from a larger bust. Look for tops or dresses with plunging necklines, wrap styles, or sweetheart necklines to enhance your décolletage and create a balanced look.</item>
        <item>3) Avoid high-necked or boxy tops: High-necked or boxy tops can make your bust appear larger and overwhelm your frame. Instead, opt for tops with open necklines, such as scoop necks or boat necks, to create a more balanced look. Avoid tops with ruffles or embellishments around the bust area, as they can add unnecessary volume.</item>
        <item>4) Emphasize your waist: Since hourglass top body types have a well-defined waist, it\\'s important to highlight this feature. Opt for tops with cinched waists, wrap styles, or belts to accentuate your curves. This will help create an hourglass silhouette and showcase your natural shape.</item>
        <item>5) Choose supportive bras: A properly fitting bra is essential for hourglass top body types. Invest in good quality bras that provide support and lift to enhance your bust and create a balanced look. Avoid bras that flatten or minimize your bust, as they can make you appear shapeless.</item>
        <item>6) Opt for structured jackets and blazers: Structured jackets and blazers can help balance out your proportions and create a polished look. Look for styles with nipped-in waists or peplum details that emphasize your waist and create an hourglass silhouette. Avoid boxy or oversized jackets that can hide your curves.</item>
        <item>7) Experiment with different sleeve lengths: Hourglass top body types can experiment with different sleeve lengths to create a balanced look. Opt for tops with three-quarter sleeves, cap sleeves, or flutter sleeves to draw attention away from your bust and create a more proportionate silhouette.</item>
    </string-array>

    <string name="hourglass_bottom">Bottom Hourglass</string>
    <string name="hourglass_bottom_description">
        Your body type has a clearly defined waist like the top hourglass. Your bust is smaller than the hips.
    </string>
    <string-array name="hourglass_bottom_style_advice">
        <item>1) Emphasize your curves: Hourglass bottom body types typically have a smaller waist and fuller hips and thighs. Embrace your curves by choosing bottoms that highlight your waist and enhance your hourglass shape. Opt for high-waisted skirts or pants that cinch in at the waist, creating a defined silhouette.</item>
        <item>2) Choose fitted bottoms: Fitted bottoms such as pencil skirts, tailored trousers, or skinny jeans are perfect for hourglass bottom body types. These styles will showcase your curves and create a balanced look. Avoid loose or baggy bottoms that can hide your shape and make you appear boxy.</item>
        <item>3) Look for A-line skirts: A-line skirts are a great option for hourglass bottom body types as they accentuate the waist and flare out over the hips and thighs. Choose skirts that hit just above or below the knee to create a flattering silhouette. Pair them with fitted tops to balance out your proportions.</item>
        <item>4) Avoid clingy fabrics: When it comes to choosing fabrics, avoid clingy materials that may highlight any areas you\\'re self-conscious about. Opt for structured fabrics that provide some structure and hold their shape, such as denim, tweed, or thicker cotton blends.</item>
        <item>5) Balance with tops: Since hourglass bottom body types have fuller hips and thighs, it\\'s important to balance your proportions with your tops. Choose tops that draw attention to your upper body and create a more proportionate look. Look for tops with details like ruffles, patterns, or embellishments around the bust area to add volume to your upper body.</item>
        <item>6) Experiment with different necklines: Hourglass bottom body types can experiment with different necklines to draw attention upward and create a balanced look. Try tops with boat necks, scoop necks, or off-the-shoulder styles to highlight your shoulders and bust.</item>
        <item>7) Consider shapewear: If you want to smooth out any areas or enhance your curves further, consider wearing shapewear underneath your clothing. Shapewear can help create a more streamlined silhouette and boost your confidence.</item>
    </string-array>
"""),
                colorsData: ANDColorsData(additional: ""))
    }
    
    static func gradle(_ packageName: String) -> GradleFilesData {
        let projectGradle = """
import dependencies.Versions
import dependencies.Build

buildscript {
    ext {
        compose_version = Versions.compose
        kotlin_version = Versions.kotlin
    }

    repositories {
        gradlePluginPortal()
        google()
        mavenCentral()
    }
    dependencies {
        classpath Build.build_tools
        classpath Build.kotlin_gradle_plugin
        classpath Build.hilt_plugin
    }
}

task clean(type: Delete) {
    delete rootProject.buildDir
}
"""
        
        let projectGradleName = "build.gradle"
        let moduleGradle = """
import dependencies.Versions
import dependencies.Application
import dependencies.Dependencies

apply plugin: 'com.android.application'
apply plugin: 'org.jetbrains.kotlin.android'
apply plugin: 'kotlin-kapt'
apply plugin: 'dagger.hilt.android.plugin'

android {
    namespace Application.id
    compileSdk Versions.compilesdk

    defaultConfig {
        applicationId Application.id
        minSdk Versions.minsdk
        targetSdk Versions.targetsdk
        versionCode Application.version_code
        versionName Application.version_name

        testInstrumentationRunner "androidx.test.runner.AndroidJUnitRunner"
        vectorDrawables {
            useSupportLibrary true
        }
    }

    buildTypes {
        release {
            minifyEnabled true
            shrinkResources true
            proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'), 'proguard-rules.pro'
            signingConfig signingConfigs.debug
        }
    }
    compileOptions {
        sourceCompatibility JavaVersion.VERSION_17
        targetCompatibility JavaVersion.VERSION_17
    }
    kotlinOptions {
        jvmTarget = '17'
    }
    buildFeatures {
        compose true
    }
    composeOptions {
        kotlinCompilerExtensionVersion compose_version
    }
    bundle {
        storeArchive {
            enable = false
        }
    }
}

dependencies {

    implementation Dependencies.core_ktx
    implementation Dependencies.appcompat
    implementation Dependencies.material
    implementation Dependencies.compose_ui
    implementation Dependencies.compose_material
    implementation Dependencies.compose_preview
    implementation Dependencies.compose_material3
    implementation Dependencies.compose_activity
    implementation Dependencies.compose_ui_tooling
    implementation Dependencies.compose_navigation
    implementation Dependencies.compose_hilt_nav
    implementation Dependencies.compose_foundation
    implementation Dependencies.compose_runtime
    implementation Dependencies.compose_runtime_livedata
    implementation Dependencies.compose_mat_icons_core
    implementation Dependencies.compose_mat_icons_core_extended
    implementation Dependencies.coroutines
    implementation Dependencies.fragment_ktx
    implementation Dependencies.lifecycle_viewmodel
    implementation Dependencies.lifecycle_runtime
    implementation Dependencies.dagger_hilt
    implementation Dependencies.compose_system_ui_controller
    kapt Dependencies.dagger_hilt_compiler
    kapt Dependencies.hilt_viewmodel_compiler
}
"""
        let moduleGradleName = "build.gradle"

        let dependencies = """
package dependencies

object Versions {
    const val gradle = "8.0.0"
    const val compilesdk = 33
    const val minsdk = 24
    const val targetsdk = 33
    const val kotlin = "1.8.10"
    const val kotlin_coroutines = "1.6.3"
    const val hilt = "2.43.2"
    const val hilt_viewmodel_compiler = "1.0.0"

    const val ktx = "1.10.0"
    const val lifecycle = "2.6.1"
    const val fragment_ktx = "1.5.7"
    const val appcompat = "1.6.1"
    const val material = "1.9.0"
    const val accompanist = "0.31.1-alpha"

    const val compose = "1.4.3"
    const val compose_navigation = "2.5.0-beta01"
    const val activity_compose = "1.7.1"
    const val compose_hilt_nav = "1.0.0"
    const val compose_google_fonts = "1.4.3"

    const val oneSignal = "4.6.7"
    const val glide = "4.12.0"
    const val swipe = "0.19.0"
    const val glide_skydoves = "1.3.9"
    const val retrofit = "2.9.0"
    const val okhttp = "4.10.0"
    const val room = "2.5.0"
    const val coil = "1.3.2"
    const val exp = "0.4.8"
    const val calend = "0.5.1"
    const val paging_version = "3.1.1"
}

object Build {
    const val build_tools = "com.android.tools.build:gradle:${Versions.gradle}"
    const val kotlin_gradle_plugin = "org.jetbrains.kotlin:kotlin-gradle-plugin:${Versions.kotlin}"
    const val hilt_plugin = "com.google.dagger:hilt-android-gradle-plugin:${Versions.hilt}"
}

object Application {
    const val id = "\(packageName)"
    const val version_code = 1
    const val version_name = "1.0"
}

object Dependencies {
    const val core_ktx = "androidx.core:core-ktx:${Versions.ktx}"
    const val appcompat = "androidx.appcompat:appcompat:${Versions.appcompat}"
    const val material = "com.google.android.material:material:${Versions.material}"

    const val compose_ui = "androidx.compose.ui:ui:${Versions.compose}"
    const val compose_material = "androidx.compose.material:material:${Versions.compose}"
    const val compose_preview = "androidx.compose.ui:ui-tooling-preview:${Versions.compose}"
    const val compose_activity = "androidx.activity:activity-compose:${Versions.activity_compose}"
    const val compose_ui_tooling = "androidx.compose.ui:ui-tooling:${Versions.compose}"
    const val compose_navigation = "androidx.navigation:navigation-compose:${Versions.compose_navigation}"
    const val compose_hilt_nav = "androidx.hilt:hilt-navigation-compose:${Versions.compose_hilt_nav}"
    const val compose_foundation = "androidx.compose.foundation:foundation:${Versions.compose}"
    const val compose_runtime = "androidx.compose.runtime:runtime:${Versions.compose}"
    const val compose_material3 = "androidx.compose.material3:material3:1.1.0-rc01"
    const val compose_runtime_livedata = "androidx.compose.runtime:runtime-livedata:${Versions.compose}"
    const val compose_mat_icons_core = "androidx.compose.material:material-icons-core:${Versions.compose}"
    const val compose_mat_icons_core_extended = "androidx.compose.material:material-icons-extended:${Versions.compose}"
    const val compose_google_fonts = "androidx.compose.ui:ui-text-google-fonts:${Versions.compose_google_fonts}"

    const val coroutines = "org.jetbrains.kotlinx:kotlinx-coroutines-android:${Versions.kotlin_coroutines}"
    const val fragment_ktx = "androidx.fragment:fragment-ktx:${Versions.fragment_ktx}"
    const val compose_system_ui_controller = "com.google.accompanist:accompanist-systemuicontroller:${Versions.accompanist}"
    const val compose_permissions = "com.google.accompanist:accompanist-permissions:${Versions.accompanist}"

    const val lifecycle_viewmodel = "androidx.lifecycle:lifecycle-viewmodel-ktx:${Versions.lifecycle}"
    const val lifecycle_runtime = "androidx.lifecycle:lifecycle-runtime-ktx:${Versions.lifecycle}"

    const val retrofit = "com.squareup.retrofit2:retrofit:${Versions.retrofit}"
    const val converter_gson = "com.squareup.retrofit2:converter-gson:${Versions.retrofit}"
    const val okhttp = "com.squareup.okhttp3:okhttp:${Versions.okhttp}"
    const val okhttp_login_interceptor = "com.squareup.okhttp3:logging-interceptor:${Versions.okhttp}"

    const val room_runtime = "androidx.room:room-runtime:${Versions.room}"
    const val room_compiler = "androidx.room:room-compiler:${Versions.room}"
    const val room_ktx = "androidx.room:room-ktx:${Versions.room}"
    const val roomPaging = "androidx.room:room-paging:${Versions.room}"

    const val onesignal = "com.onesignal:OneSignal:${Versions.oneSignal}"
    
    const val swipe_to_refresh = "com.google.accompanist:accompanist-swiperefresh:${Versions.swipe}"

    const val glide = "com.github.bumptech.glide:glide:${Versions.glide}"
    const val glide_skydoves = "com.github.skydoves:landscapist-glide:${Versions.glide_skydoves}"
    const val glide_compiler = "com.github.bumptech.glide:compiler:${Versions.glide}"

    const val dagger_hilt = "com.google.dagger:hilt-android:${Versions.hilt}"
    const val dagger_hilt_compiler = "com.google.dagger:hilt-android-compiler:${Versions.hilt}"
    const val hilt_viewmodel_compiler = "androidx.hilt:hilt-compiler:${Versions.hilt_viewmodel_compiler}"
    const val coil_compose = "io.coil-kt:coil-compose:${Versions.coil}"
    const val coil_svg = "io.coil-kt:coil-svg:${Versions.coil}"
    const val expression = "net.objecthunter:exp4j:${Versions.exp}"
    const val calendar = "io.github.boguszpawlowski.composecalendar:composecalendar:${Versions.calend}"
    const val calendar_date = "io.github.boguszpawlowski.composecalendar:kotlinx-datetime:${Versions.calend}"
    const val paging = "androidx.paging:paging-runtime:${Versions.paging_version}"
    const val pagingCommon = "androidx.paging:paging-common:${Versions.paging_version}"
    const val pagingCompose = "androidx.paging:paging-compose:1.0.0-alpha18"
}
"""
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
