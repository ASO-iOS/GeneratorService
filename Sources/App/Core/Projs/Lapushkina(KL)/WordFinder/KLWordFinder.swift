//
//  File.swift
//  
//
//  Created by admin on 05.10.2023.
//

import Foundation

struct KLWordFinder: FileProviderProtocol {
    static var fileName: String = "\(NamesManager.shared.fileName).kt"
    
    static func fileContent(packageName: String, uiSettings: UISettings) -> String {
        return """
package \(packageName).presentation.fragments.main_fragment

import android.content.Context
import androidx.compose.foundation.Canvas
import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.aspectRatio
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.layout.wrapContentHeight
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.text.KeyboardOptions
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Close
import androidx.compose.material.icons.filled.Lightbulb
import androidx.compose.material3.Button
import androidx.compose.material3.ButtonDefaults
import androidx.compose.material3.Icon
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.material3.TextField
import androidx.compose.material3.TextFieldDefaults
import androidx.compose.material3.Typography
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.geometry.Offset
import androidx.compose.ui.geometry.Size
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.drawscope.DrawScope
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.AnnotatedString
import androidx.compose.ui.text.ExperimentalTextApi
import androidx.compose.ui.text.SpanStyle
import androidx.compose.ui.text.TextMeasurer
import androidx.compose.ui.text.TextStyle
import androidx.compose.ui.text.buildAnnotatedString
import androidx.compose.ui.text.drawText
import androidx.compose.ui.text.font.FontFamily
import androidx.compose.ui.text.input.KeyboardType
import androidx.compose.ui.text.rememberTextMeasurer
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.text.withStyle
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.hilt.navigation.compose.hiltViewModel
import androidx.lifecycle.SavedStateHandle
import androidx.lifecycle.ViewModel
import androidx.navigation.NamedNavArgument
import androidx.navigation.NavController
import androidx.navigation.NavType
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import androidx.navigation.compose.rememberNavController
import androidx.navigation.navArgument
import \(packageName).R
import dagger.hilt.android.lifecycle.HiltViewModel
import dagger.hilt.android.qualifiers.ApplicationContext
import javax.inject.Inject

//generator
val backColorPrimary = Color(0xFF\(uiSettings.backColorPrimary ?? "FFFFFF"))
val textColorPrimary = Color(0xFF\(uiSettings.textColorPrimary ?? "FFFFFF"))
val textColorSecondary = Color(0xFF\(uiSettings.textColorSecondary ?? "FFFFFF"))
val buttonColorPrimary = Color(0xFF\(uiSettings.buttonColorPrimary ?? "FFFFFF"))
val buttonTextColorPrimary = Color(0xFF\(uiSettings.buttonTextColorPrimary ?? "FFFFFF"))
val buttonColorSecondary = Color(0xFF\(uiSettings.buttonColorSecondary ?? "FFFFFF"))
val surfaceColor = Color(0xFF\(uiSettings.surfaceColor ?? "FFFFFF"))
val onSurfaceColor = Color(0xFF\(uiSettings.onSurfaceColor ?? "FFFFFF"))

//other
val cellColor = Color(0xFFFFFFFF)
val hintColor = Color(0xFFFFEE5E)
val disabledColor = Color(0xFF000000)

val layoutPadding = 24.dp
val buttonSpacer = 16.dp

val buttonWidth = 200.dp
val buttonHeight = 50.dp

val letterSize = 30.sp

val fontFamily = FontFamily.SansSerif
val smallFontSize = 20.sp
val mediumFontSize = 24.sp
val largeFontSize = 32.sp

val typography = Typography(
    displaySmall = TextStyle(
        fontFamily = fontFamily, fontSize = smallFontSize, color = textColorPrimary
    ),
    displayMedium = TextStyle(
        fontFamily = fontFamily, fontSize = mediumFontSize, color = textColorSecondary
    ),
    displayLarge = TextStyle(
        fontFamily = fontFamily, fontSize = largeFontSize, color = textColorPrimary
    )
)

@Composable
fun WordFinderTheme(
    content: @Composable () -> Unit
) {
    MaterialTheme(
        typography = typography,
        content = content
    )
}

@Composable
fun GameScreen(navController: NavController) {
    val viewModel = hiltViewModel<GameViewModel>()
    GameScreenContent(
        state = viewModel.state,
        onEvent = viewModel::onEvent,
        onGameFinished = {
            navController.navigate(
                Screen.RestartScreen.createArg(viewModel.state.mode, viewModel.state.score)
            ) {
                popUpTo(Screen.MenuScreen.route)
            }
        }
    )
}

@OptIn(ExperimentalTextApi::class)
@Composable
fun GameScreenContent(
    state: GameState,
    onEvent: (GameEvent) -> Unit,
    onGameFinished: () -> Unit
) {
    Column(
        modifier = Modifier
            .fillMaxSize()
            .background(backColorPrimary)
            .padding(24.dp),
        verticalArrangement = Arrangement.SpaceAround,
        horizontalAlignment = Alignment.CenterHorizontally
    ) {
        val textMeasurer = rememberTextMeasurer()

        Text(
            text = stringResource(id = R.string.game_description),
            textAlign = TextAlign.Center,
            color = textColorPrimary
        )
        Row(
            modifier = Modifier
                .fillMaxWidth()
                .wrapContentHeight(),
            verticalAlignment = Alignment.CenterVertically,
            horizontalArrangement = Arrangement.SpaceBetween
        ) {
            Text(
                text = stringResource(id = R.string.score, state.score), color = textColorPrimary
            )
            Button(
                modifier = Modifier
                    .clip(CircleShape)
                    .size(32.dp),
                onClick = { onEvent(GameEvent.GetHint) },
                colors = ButtonDefaults.buttonColors(
                    containerColor = buttonColorSecondary
                ),
                contentPadding = PaddingValues(0.dp)
            ) {
                Icon(
                    modifier = Modifier.size(16.dp),
                    imageVector = Icons.Default.Lightbulb,
                    tint = buttonTextColorPrimary,
                    contentDescription = null
                )
            }
        }
        Canvas(
            modifier = Modifier
                .fillMaxWidth()
                .aspectRatio(1f)
                .background(Color.Gray)
        ) {
            state.letters.forEach {
                letter(
                    textMeasurer,
                    it
                )
            }
        }
        TextField(
            modifier = Modifier
                .fillMaxWidth()
                .height(80.dp),
            textStyle = MaterialTheme.typography.displaySmall,
            value = state.playerText,
            onValueChange = {
                onEvent(GameEvent.CheckWord(it, onGameFinished))
            },
            label = { Text("Word", color = textColorPrimary) },
            colors = TextFieldDefaults.colors(
                focusedLabelColor = onSurfaceColor,
                unfocusedLabelColor = onSurfaceColor,
                focusedTextColor = textColorPrimary,
                unfocusedTextColor = textColorPrimary,
                focusedContainerColor = surfaceColor,
                unfocusedContainerColor = surfaceColor
            ),
            singleLine = true,
            keyboardOptions = KeyboardOptions(
                keyboardType = KeyboardType.Text
            ),
            trailingIcon = {
                Icon(
                    modifier = Modifier
                        .clickable {
                            onEvent(GameEvent.ClearText)
                        },
                    imageVector = Icons.Default.Close,
                    tint = textColorPrimary,
                    contentDescription = null
                )
            }
        )
    }
}

@OptIn(ExperimentalTextApi::class)
fun DrawScope.letter(
    textMeasurer: TextMeasurer,
    letter: LetterTile
) {
    val textSize = this.size * letter.size * 0.65f

    val letterWidth = textMeasurer.measure(
        letter.letter
    ).size.width

    val letterHeight = textMeasurer.measure(
        letter.letter
    ).size.height

    val color = when {
        letter.isEnabled && letter.isHint -> hintColor
        letter.isEnabled && !letter.isHint -> cellColor
        else -> disabledColor
    }

    drawRect(
        color = color,
        size = Size(this.size.width * letter.size, this.size.width * letter.size),
        topLeft = Offset(
            letter.x * this.size.width,
            letter.y * this.size.width
        )
    )

    drawText(
        textMeasurer = textMeasurer,
        text = letter.letter,
        size = textSize,
        topLeft = Offset(
            this.size.width * letter.size / 2 + letter.x * this.size.width - letterWidth / 2,
            this.size.width * letter.size / 2 + letter.y * this.size.width - letterHeight / 2
        )
    )
}

sealed class GameEvent {
    data class CheckWord(
        val word: String,
        val onGameFinished: () -> Unit
    ) : GameEvent()

    object ClearText : GameEvent()

    object GetHint : GameEvent()
}

data class GameState(
    val mode: Mode = Mode.THREE,
    val letters: List<LetterTile> = emptyList(),
    val words: List<String> = emptyList(),
    val score: Int = 0,
    val hint: String? = null,
    val playerText: String = ""
)

@HiltViewModel
class GameViewModel @Inject constructor(
    savedStateHandle: SavedStateHandle,
    private val game: Game
) : ViewModel() {

    var state by mutableStateOf(GameState())
        private set

    init {
        val mode = savedStateHandle.get<String>(Screen.mode)
        mode?.let {
            state = state.copy(
                mode = Mode.valueOf(mode)
            )
            game.generateWords(Mode.valueOf(mode))
            state = state.copy(
                words = game.words,
                letters = game.letterTiles
            )
        }
    }

    fun onEvent(event: GameEvent) {
        when (event) {
            is GameEvent.CheckWord -> {
                state = state.copy(
                    playerText = event.word
                )
                if (state.words.contains(event.word)) {
                    state = state.copy(
                        score = state.score + event.word.length,
                        letters = game.disableLetters(event.word, state.letters),
                        words = game.removeWordFound(event.word, state.words),
                        hint = null
                    )
                    if (state.words.isEmpty()) {
                        event.onGameFinished()
                    }
                }
            }
            is GameEvent.GetHint -> {
                if (state.hint == null) {
                    val hintWord = state.words.random()
                    state = state.copy(
                        hint = hintWord,
                        score = state.score - 1,
                        letters = game.getHintLetters(hintWord, state.letters)
                    )
                } else {
                    state.hint?.let { hintWord ->
                        val hintLetterCount = state.letters.count { it.isHint && it.word == hintWord}
                        if (hintLetterCount < hintWord.length) {
                            state = state.copy(
                                score = state.score - 1,
                                letters = game.getHintLetters(hintWord, state.letters)
                            )
                        }
                    }
                }
            }
            is GameEvent.ClearText -> {
                state = state.copy(
                    playerText = ""
                )
            }
        }
    }
}

@Composable
fun MenuScreen(navController: NavController) {
    MenuScreenContent(
        onThreeMode = { navController.navigate(Screen.GameScreen.createArg(Mode.THREE)) },
        onFourMode = { navController.navigate(Screen.GameScreen.createArg(Mode.FOUR)) },
        onFiveMode = { navController.navigate(Screen.GameScreen.createArg(Mode.FIVE)) },
        onSixMode = { navController.navigate(Screen.GameScreen.createArg(Mode.SIX)) }
    )
}

@Composable
fun MenuScreenContent(
    onThreeMode: () -> Unit,
    onFourMode: () -> Unit,
    onFiveMode: () -> Unit,
    onSixMode: () -> Unit
) {
    Column(
        modifier = Modifier
            .fillMaxSize()
            .background(backColorPrimary)
            .padding(layoutPadding),
        verticalArrangement = Arrangement.SpaceEvenly,
        horizontalAlignment = Alignment.CenterHorizontally
    ) {
        Text(
            text = stringResource(id = R.string.app_name),
            style = MaterialTheme.typography.displayLarge
        )
        Column(
            verticalArrangement = Arrangement.spacedBy(buttonSpacer)
        ) {
            GameButton(textRes = R.string.three, onClick = onThreeMode)
            GameButton(textRes = R.string.four, onClick = onFourMode)
            GameButton(textRes = R.string.five, onClick = onFiveMode)
            GameButton(textRes = R.string.six, onClick = onSixMode)
        }
    }
}

@Composable
fun RestartScreen(navController: NavController) {
    val viewModel = hiltViewModel<RestartViewModel>()
    RestartScreenContent(
        state = viewModel.state,
        onRestart = {
            navController.navigate(Screen.GameScreen.createArg(viewModel.state.mode)) {
                popUpTo(Screen.MenuScreen.route)
            }
        },
        onGoToMenu = {
            navController.navigate(Screen.MenuScreen.route) {
                popUpTo(Screen.MenuScreen.route)
            }
        }
    )
}

@Composable
fun RestartScreenContent(
    state: RestartState,
    onRestart: () -> Unit,
    onGoToMenu: () -> Unit
) {
    Column(
        modifier = Modifier
            .fillMaxSize()
            .background(backColorPrimary)
            .padding(layoutPadding),
        verticalArrangement = Arrangement.SpaceEvenly,
        horizontalAlignment = Alignment.CenterHorizontally
    ) {
        Column(
            horizontalAlignment = Alignment.CenterHorizontally,
            verticalArrangement = Arrangement.spacedBy(buttonSpacer)
        ) {
            Text(
                textAlign = TextAlign.Center,
                text = stringResource(id = R.string.score, state.score),
                color = textColorPrimary
            )
            GameButton(textRes = R.string.restart, onClick = onRestart)
            GameButton(textRes = R.string.menu, onClick = onGoToMenu)
        }
    }
}

data class RestartState(
    val mode: Mode = Mode.THREE,
    val score: Int = 0
)

@HiltViewModel
class RestartViewModel @Inject constructor(
    savedStateHandle: SavedStateHandle
) : ViewModel() {
    var state by mutableStateOf(RestartState())
        private set

    init {
        val score = savedStateHandle.get<Int>(Screen.score)
        val mode = savedStateHandle.get<String>(Screen.mode)

        if (score != null && mode != null) {
            state = state.copy(
                mode = Mode.valueOf(mode),
                score = score
            )
        }
    }
}

@Composable
fun GameButton(
    textRes: Int,
    onClick: () -> Unit
) {
    Button(
        modifier = Modifier
            .width(buttonWidth)
            .height(buttonHeight),
        onClick = onClick,
        colors = ButtonDefaults.buttonColors(
            containerColor = buttonColorPrimary,
            contentColor = buttonTextColorPrimary
        )
    ) {
        Text(text = stringResource(textRes))
    }
}

sealed class Screen(val route: String, val listArgs: List<NamedNavArgument>) {
    object MenuScreen : Screen(route = routeMenu, listArgs = emptyList())

    object GameScreen : Screen(
        route = "$routeGame/{$mode}",
        listArgs = listOf(
            navArgument(mode) {
                type = NavType.StringType
            }
        )
    ) {
        fun createArg(mode: Mode) = "$routeGame/${mode.name}"
    }

    object RestartScreen : Screen(
        route = "$routeRestart/{$mode}/{$score}",
        listArgs = listOf(
            navArgument(mode) {
                type = NavType.StringType
            },
            navArgument(score) {
                type = NavType.IntType
            }
        )
    ) {
        fun createArg(mode: Mode, score: Int) = "$routeRestart/${mode.name}/$score"
    }

    companion object {
        const val routeMenu = "menu_screen"
        const val routeGame = "game_screen"
        const val routeRestart = "restart_screen"
        const val mode: String = "mode"
        const val score: String = "score"
    }
}

@Composable
fun Navigation() {
    val navController = rememberNavController()

    NavHost(navController = navController, startDestination = Screen.MenuScreen.route) {
        composable(route = Screen.MenuScreen.route) {
            MenuScreen(navController)
        }
        composable(
            route = Screen.GameScreen.route,
            arguments = Screen.GameScreen.listArgs
        ) {
            GameScreen(navController)
        }
        composable(
            route = Screen.RestartScreen.route,
            arguments = Screen.RestartScreen.listArgs
        ) {
            RestartScreen(navController)
        }
    }
}

class Game @Inject constructor(@ApplicationContext val context: Context) {
    var words = emptyList<String>()
    var letters = emptyList<Pair<Char, String>>()
    var letterTiles = emptyList<LetterTile>()

    fun generateWords(mode: Mode) {
        words = getWordsForGame(mode)
        letters = getLettersFromWords(words)
        letterTiles = generateLetterTiles(letters, mode)
    }

    private fun getWordsForGame(mode: Mode): List<String> {
        var charCount = mode.gridSize * mode.gridSize
        var wordCount = mode.gridSize
        val words = mutableListOf<String>()

        while (wordCount >= 1) {
            val wordLength = charCount / wordCount
            val resId = getResId(wordLength)
            words.add(getRandomWord(resId))

            charCount -= wordLength
            wordCount--
        }
        return words
    }

    private fun getRandomWord(resId: Int): String {
        return context.resources.getStringArray(resId).asList().random()
    }

    private fun getResId(count: Int): Int {
        return when (count) {
            3 -> R.array.words_3
            4 -> R.array.words_4
            5 -> R.array.words_5
            6 -> R.array.words_6
            else -> 0
        }
    }

    private fun getLettersFromWords(words: List<String>): List<Pair<Char, String>> {
        val chars = mutableListOf<Pair<Char, String>>()
        words.forEach { word ->
            val wordChars = word.toCharArray().asList()
            wordChars.forEach { char ->
                chars.add(Pair(char, word))
            }
        }
        return chars.shuffled()
    }

    private fun generateLetterTiles(
        letters: List<Pair<Char, String>>,
        mode: Mode
    ): List<LetterTile> {
        val gridSize = mode.gridSize
        val tileSize = mode.tileSize
        val tileSpacer = 0.01f

        val letterTiles = mutableListOf<LetterTile>()
        var index = 0
        for (i in 0 until gridSize) {
            for (j in 0 until gridSize) {
                val letter = LetterTile(
                    letter = getAnnotatedText(letters[index].first),
                    word = letters[index].second,
                    size = tileSize,
                    x = i * tileSize + (i + 1) * tileSpacer,
                    y = j * tileSize + (j + 1) * tileSpacer
                )
                letterTiles.add(letter)
                index += 1
            }
        }

        return letterTiles
    }

    fun disableLetters(wordFound: String, list: List<LetterTile>): List<LetterTile> {
        val letters = list.toMutableList().apply {
            onEach { letterTile ->
                if (letterTile.word == wordFound) {
                    letterTile.isEnabled = false
                }
            }
        }

        return letters
    }

    fun removeWordFound(wordFound: String, list: List<String>): List<String> {
        val words = list.toMutableList().apply {
            removeIf { it == wordFound }
        }
        return words
    }

    fun getHintLetters(hintWord: String, list: List<LetterTile>): List<LetterTile> {
        val letters = list.toMutableList().apply {
            firstOrNull { !it.isHint && it.word == hintWord }?.isHint = true
        }

        return letters
    }

    private fun getAnnotatedText(
        value: Char
    ): AnnotatedString {
        return buildAnnotatedString {
            withStyle(
                style = SpanStyle(
                    fontSize = letterSize,
                )
            ) {
                append(value)
            }
        }
    }
}

data class LetterTile(
    val letter: AnnotatedString,
    val word: String,
    val x: Float = 0f,
    val y: Float = 0f,
    val size: Float = 0f,
    var isEnabled: Boolean = true,
    var isHint: Boolean = false
)

enum class Mode(val gridSize: Int, val tileSize: Float) {
    THREE(
        gridSize = 3,
        tileSize = 0.32f
    ),
    FOUR(
        gridSize = 4,
        tileSize = 0.2375f
    ),
    FIVE(
        gridSize = 5,
        tileSize = 0.188f
    ),
    SIX(
        gridSize = 6,
        tileSize = 0.155f
    )
}
"""
    }
    
    static func dependencies(_ mainData: MainData) -> ANDData {
        return ANDData(mainFragmentData: ANDMainFragment(imports: "", content: """
                WordFinderTheme {
                    Navigation()
                }
"""), mainActivityData: ANDMainActivity(imports: "", extraFunc: "", content: ""), themesData: ANDThemesData(isDefault: true, content: ""), stringsData: ANDStringsData(additional: """
  <string name="score">Score: %s</string>
    <string name="hint">Hint</string>
    <string name="game_description">Letters are placed in random order. Find all hidden words.</string>
    <string name="three">3x3</string>
    <string name="four">4x4</string>
    <string name="five">5x5</string>
    <string name="six">6x6</string>
    <string name="restart">Restart</string>
    <string name="menu">Menu</string>

    <string-array name="words_3">
        <item>man</item>
        <item>six</item>
        <item>wry</item>
        <item>lip</item>
        <item>bag</item>
        <item>bed</item>
        <item>zoo</item>
        <item>ear</item>
        <item>box</item>
        <item>hug</item>
        <item>shy</item>
        <item>add</item>
        <item>fry</item>
        <item>way</item>
        <item>rot</item>
        <item>key</item>
        <item>air</item>
        <item>sip</item>
        <item>tub</item>
        <item>bat</item>
        <item>dry</item>
        <item>fit</item>
        <item>run</item>
        <item>tow</item>
        <item>dad</item>
        <item>fix</item>
        <item>beg</item>
        <item>bad</item>
        <item>sad</item>
        <item>pat</item>
        <item>gun</item>
        <item>fax</item>
        <item>far</item>
        <item>boy</item>
        <item>fat</item>
        <item>top</item>
        <item>two</item>
        <item>icy</item>
        <item>rob</item>
        <item>pot</item>
        <item>van</item>
        <item>cup</item>
        <item>dog</item>
        <item>ban</item>
        <item>end</item>
        <item>low</item>
        <item>sky</item>
        <item>day</item>
        <item>rat</item>
        <item>jar</item>
        <item>tan</item>
        <item>bow</item>
        <item>spy</item>
        <item>cub</item>
        <item>low</item>
        <item>ten</item>
        <item>can</item>
        <item>jam</item>
        <item>eye</item>
        <item>cut</item>
        <item>old</item>
        <item>war</item>
        <item>sun</item>
        <item>cap</item>
        <item>ill</item>
        <item>jam</item>
        <item>oil</item>
        <item>rub</item>
        <item>tie</item>
        <item>arm</item>
        <item>act</item>
        <item>pin</item>
        <item>ask</item>
        <item>cow</item>
        <item>mug</item>
        <item>sin</item>
        <item>toy</item>
        <item>yam</item>
        <item>use</item>
        <item>wax</item>
        <item>bat</item>
        <item>owe</item>
        <item>few</item>
        <item>tug</item>
        <item>pet</item>
        <item>hot</item>
        <item>cat</item>
        <item>ski</item>
        <item>dam</item>
        <item>try</item>
        <item>tap</item>
        <item>hat</item>
        <item>cry</item>
        <item>rub</item>
        <item>pan</item>
        <item>car</item>
        <item>pop</item>
        <item>fog</item>
        <item>tip</item>
        <item>use</item>
        <item>ray</item>
        <item>art</item>
        <item>egg</item>
        <item>saw</item>
        <item>yak</item>
        <item>hot</item>
        <item>hop</item>
        <item>bit</item>
        <item>red</item>
        <item>pie</item>
        <item>dry</item>
        <item>leg</item>
        <item>mix</item>
        <item>nut</item>
        <item>tin</item>
        <item>men</item>
        <item>lie</item>
        <item>end</item>
        <item>bee</item>
        <item>fly</item>
        <item>ice</item>
        <item>mom</item>
        <item>jog</item>
        <item>nod</item>
        <item>man</item>
        <item>pen</item>
        <item>sea</item>
        <item>ink</item>
        <item>son</item>
        <item>odd</item>
        <item>new</item>
        <item>box</item>
        <item>hum</item>
        <item>wet</item>
        <item>one</item>
        <item>rod</item>
        <item>own</item>
        <item>tax</item>
        <item>big</item>
        <item>zip</item>
        <item>toe</item>
        <item>pig</item>
    </string-array>
    <string-array name="words_4">
        <item>four</item>
        <item>whip</item>
        <item>wave</item>
        <item>play</item>
        <item>long</item>
        <item>dock</item>
        <item>dime</item>
        <item>wiry</item>
        <item>dare</item>
        <item>open</item>
        <item>many</item>
        <item>stem</item>
        <item>sink</item>
        <item>trip</item>
        <item>oven</item>
        <item>real</item>
        <item>aunt</item>
        <item>fail</item>
        <item>join</item>
        <item>gamy</item>
        <item>pies</item>
        <item>year</item>
        <item>wave</item>
        <item>nosy</item>
        <item>work</item>
        <item>yawn</item>
        <item>lake</item>
        <item>legs</item>
        <item>glow</item>
        <item>warn</item>
        <item>hard</item>
        <item>card</item>
        <item>hook</item>
        <item>book</item>
        <item>sack</item>
        <item>type</item>
        <item>fast</item>
        <item>open</item>
        <item>free</item>
        <item>heal</item>
        <item>rose</item>
        <item>fine</item>
        <item>vase</item>
        <item>mine</item>
        <item>ajar</item>
        <item>note</item>
        <item>pets</item>
        <item>tame</item>
        <item>tail</item>
        <item>sore</item>
        <item>thin</item>
        <item>coil</item>
        <item>swim</item>
        <item>save</item>
        <item>used</item>
        <item>meek</item>
        <item>camp</item>
        <item>coil</item>
        <item>clam</item>
        <item>drab</item>
        <item>peep</item>
        <item>moor</item>
        <item>tank</item>
        <item>suit</item>
        <item>grip</item>
        <item>roll</item>
        <item>roll</item>
        <item>test</item>
        <item>wash</item>
        <item>stew</item>
        <item>male</item>
        <item>true</item>
        <item>idea</item>
        <item>book</item>
        <item>land</item>
        <item>acid</item>
        <item>bomb</item>
        <item>flat</item>
        <item>part</item>
        <item>pick</item>
        <item>nine</item>
        <item>grab</item>
        <item>bulb</item>
        <item>show</item>
        <item>hall</item>
        <item>road</item>
        <item>soft</item>
        <item>eyes</item>
        <item>push</item>
        <item>tame</item>
        <item>cool</item>
        <item>obey</item>
        <item>name</item>
        <item>blot</item>
        <item>slip</item>
        <item>cute</item>
        <item>kiss</item>
        <item>beam</item>
        <item>wire</item>
        <item>miss</item>
        <item>sigh</item>
        <item>mean</item>
        <item>ripe</item>
        <item>poke</item>
        <item>trip</item>
        <item>able</item>
        <item>stop</item>
        <item>time</item>
        <item>wind</item>
        <item>sand</item>
        <item>test</item>
        <item>boat</item>
        <item>debt</item>
        <item>ugly</item>
        <item>wood</item>
        <item>cast</item>
        <item>snow</item>
        <item>iron</item>
        <item>burn</item>
        <item>self</item>
        <item>trot</item>
        <item>rule</item>
        <item>wail</item>
        <item>mute</item>
        <item>form</item>
        <item>rush</item>
        <item>slap</item>
        <item>easy</item>
        <item>vein</item>
        <item>dogs</item>
        <item>door</item>
        <item>sock</item>
        <item>zany</item>
        <item>hope</item>
        <item>tiny</item>
        <item>best</item>
        <item>fang</item>
        <item>hand</item>
        <item>milk</item>
        <item>walk</item>
        <item>tent</item>
        <item>pull</item>
        <item>skin</item>
        <item>rule</item>
        <item>near</item>
        <item>pump</item>
        <item>love</item>
        <item>play</item>
        <item>step</item>
        <item>fear</item>
        <item>busy</item>
        <item>fuel</item>
        <item>wren</item>
        <item>full</item>
        <item>name</item>
        <item>gold</item>
        <item>warm</item>
        <item>bell</item>
        <item>dust</item>
        <item>whip</item>
        <item>bite</item>
        <item>size</item>
        <item>form</item>
        <item>crow</item>
        <item>rare</item>
        <item>mend</item>
        <item>push</item>
        <item>ship</item>
        <item>past</item>
        <item>baby</item>
        <item>cure</item>
        <item>puny</item>
        <item>meal</item>
        <item>sour</item>
        <item>bury</item>
        <item>fish</item>
        <item>deer</item>
        <item>safe</item>
        <item>root</item>
        <item>rock</item>
        <item>hill</item>
        <item>kiss</item>
        <item>food</item>
        <item>ants</item>
        <item>race</item>
        <item>wall</item>
        <item>time</item>
        <item>mark</item>
        <item>soup</item>
        <item>bait</item>
        <item>wipe</item>
        <item>rely</item>
        <item>fold</item>
        <item>need</item>
        <item>town</item>
        <item>post</item>
        <item>hose</item>
        <item>kick</item>
        <item>copy</item>
        <item>foot</item>
        <item>yard</item>
        <item>need</item>
        <item>sail</item>
        <item>hope</item>
        <item>girl</item>
        <item>mind</item>
        <item>moan</item>
        <item>hang</item>
        <item>ruin</item>
        <item>yoke</item>
        <item>worm</item>
        <item>bang</item>
        <item>doll</item>
        <item>cart</item>
        <item>hunt</item>
        <item>slow</item>
        <item>jump</item>
        <item>lazy</item>
        <item>look</item>
        <item>tire</item>
        <item>lick</item>
        <item>bike</item>
        <item>care</item>
        <item>toys</item>
        <item>loaf</item>
        <item>rice</item>
        <item>seed</item>
        <item>cats</item>
        <item>talk</item>
        <item>earn</item>
        <item>fork</item>
        <item>sack</item>
        <item>bone</item>
        <item>wish</item>
        <item>grip</item>
        <item>last</item>
        <item>deep</item>
        <item>yarn</item>
        <item>kick</item>
        <item>moon</item>
        <item>dead</item>
        <item>sign</item>
        <item>pump</item>
        <item>dear</item>
        <item>wing</item>
        <item>cake</item>
        <item>wash</item>
        <item>shop</item>
        <item>chew</item>
        <item>knot</item>
        <item>tidy</item>
        <item>seat</item>
        <item>lean</item>
        <item>rail</item>
        <item>long</item>
        <item>curl</item>
        <item>room</item>
        <item>hook</item>
        <item>chop</item>
        <item>bake</item>
        <item>pack</item>
        <item>neat</item>
        <item>work</item>
        <item>flag</item>
        <item>drum</item>
        <item>twig</item>
        <item>fall</item>
        <item>knot</item>
        <item>fear</item>
        <item>file</item>
        <item>seal</item>
        <item>salt</item>
        <item>veil</item>
        <item>fowl</item>
        <item>same</item>
        <item>mate</item>
        <item>love</item>
        <item>head</item>
        <item>soak</item>
        <item>roof</item>
        <item>bolt</item>
        <item>next</item>
        <item>bare</item>
        <item>mark</item>
        <item>stir</item>
        <item>milk</item>
        <item>drop</item>
        <item>spot</item>
        <item>slim</item>
        <item>bump</item>
        <item>peel</item>
        <item>five</item>
        <item>beef</item>
        <item>week</item>
        <item>pink</item>
        <item>lock</item>
        <item>want</item>
        <item>lace</item>
        <item>heat</item>
        <item>pail</item>
        <item>jail</item>
        <item>eggs</item>
        <item>cows</item>
        <item>suck</item>
        <item>hole</item>
        <item>sail</item>
        <item>beds</item>
        <item>wise</item>
        <item>tour</item>
        <item>line</item>
        <item>cave</item>
        <item>flap</item>
        <item>silk</item>
        <item>part</item>
        <item>coal</item>
        <item>good</item>
        <item>grey</item>
        <item>zinc</item>
        <item>frog</item>
        <item>dull</item>
        <item>view</item>
        <item>move</item>
        <item>side</item>
        <item>nest</item>
        <item>gate</item>
        <item>back</item>
        <item>edge</item>
        <item>jump</item>
        <item>wool</item>
        <item>zoom</item>
        <item>help</item>
        <item>grin</item>
        <item>team</item>
        <item>lush</item>
        <item>risk</item>
        <item>pull</item>
        <item>bath</item>
        <item>back</item>
        <item>knee</item>
        <item>yell</item>
        <item>poor</item>
        <item>cook</item>
        <item>mice</item>
        <item>sign</item>
        <item>unit</item>
        <item>tart</item>
        <item>live</item>
        <item>chin</item>
        <item>lamp</item>
        <item>ball</item>
        <item>calm</item>
        <item>clap</item>
        <item>pour</item>
        <item>gaze</item>
        <item>rich</item>
        <item>turn</item>
        <item>plug</item>
        <item>step</item>
        <item>lock</item>
        <item>oval</item>
        <item>blue</item>
        <item>suit</item>
        <item>sort</item>
        <item>page</item>
        <item>head</item>
        <item>hate</item>
        <item>trap</item>
        <item>pray</item>
        <item>boil</item>
        <item>wrap</item>
        <item>nest</item>
        <item>damp</item>
        <item>rate</item>
        <item>call</item>
        <item>wary</item>
        <item>sore</item>
        <item>mere</item>
        <item>note</item>
        <item>fold</item>
        <item>toes</item>
        <item>slow</item>
        <item>left</item>
        <item>horn</item>
        <item>tall</item>
        <item>soda</item>
        <item>harm</item>
        <item>club</item>
        <item>cars</item>
        <item>rain</item>
        <item>lewd</item>
        <item>nose</item>
        <item>wink</item>
        <item>jail</item>
        <item>meat</item>
        <item>keen</item>
        <item>star</item>
        <item>rake</item>
        <item>glib</item>
        <item>mass</item>
        <item>wine</item>
        <item>wide</item>
        <item>camp</item>
        <item>bear</item>
        <item>hate</item>
        <item>army</item>
        <item>null</item>
        <item>thaw</item>
        <item>join</item>
        <item>hand</item>
        <item>sofa</item>
        <item>toad</item>
        <item>duck</item>
        <item>buzz</item>
        <item>wait</item>
        <item>bent</item>
        <item>itch</item>
        <item>rock</item>
        <item>shoe</item>
        <item>fair</item>
        <item>mine</item>
        <item>maid</item>
        <item>stay</item>
        <item>half</item>
        <item>mint</item>
        <item>gray</item>
        <item>face</item>
        <item>pine</item>
        <item>film</item>
        <item>walk</item>
        <item>sick</item>
        <item>slip</item>
        <item>icky</item>
        <item>kill</item>
        <item>pipe</item>
        <item>like</item>
        <item>snow</item>
        <item>high</item>
        <item>bead</item>
        <item>like</item>
        <item>nail</item>
        <item>heap</item>
        <item>flow</item>
        <item>vest</item>
        <item>tree</item>
        <item>desk</item>
        <item>skip</item>
        <item>nice</item>
        <item>neck</item>
        <item>fill</item>
        <item>land</item>
        <item>tick</item>
        <item>pigs</item>
        <item>farm</item>
        <item>drop</item>
        <item>song</item>
        <item>arch</item>
        <item>home</item>
        <item>turn</item>
        <item>clip</item>
        <item>loud</item>
        <item>huge</item>
        <item>load</item>
        <item>bomb</item>
        <item>shut</item>
        <item>bird</item>
        <item>plot</item>
        <item>rest</item>
        <item>list</item>
        <item>shop</item>
        <item>hurt</item>
        <item>park</item>
        <item>boot</item>
        <item>coat</item>
        <item>drag</item>
        <item>heat</item>
        <item>face</item>
        <item>peck</item>
        <item>bore</item>
        <item>fool</item>
        <item>fire</item>
        <item>soap</item>
        <item>mask</item>
        <item>kind</item>
        <item>dirt</item>
        <item>even</item>
        <item>comb</item>
        <item>base</item>
        <item>joke</item>
        <item>fade</item>
        <item>dust</item>
        <item>talk</item>
        <item>look</item>
        <item>late</item>
        <item>knit</item>
        <item>lame</item>
        <item>word</item>
        <item>last</item>
        <item>corn</item>
        <item>spot</item>
        <item>ring</item>
        <item>weak</item>
        <item>hour</item>
        <item>care</item>
        <item>blow</item>
        <item>pass</item>
        <item>pale</item>
        <item>cute</item>
        <item>loss</item>
        <item>fire</item>
        <item>rain</item>
        <item>glue</item>
        <item>cent</item>
        <item>plan</item>
        <item>vast</item>
        <item>stop</item>
        <item>fact</item>
        <item>cold</item>
        <item>warm</item>
        <item>crib</item>
        <item>pear</item>
        <item>melt</item>
        <item>tray</item>
        <item>hair</item>
        <item>drip</item>
        <item>dark</item>
        <item>move</item>
        <item>mist</item>
        <item>rude</item>
        <item>wild</item>
        <item>pest</item>
        <item>wish</item>
    </string-array>
    <string-array name="words_5">
        <item>shape</item>
        <item>print</item>
        <item>steel</item>
        <item>weigh</item>
        <item>force</item>
        <item>shock</item>
        <item>story</item>
        <item>shame</item>
        <item>brush</item>
        <item>judge</item>
        <item>jaded</item>
        <item>skirt</item>
        <item>shrug</item>
        <item>wheel</item>
        <item>visit</item>
        <item>wound</item>
        <item>tired</item>
        <item>jeans</item>
        <item>utter</item>
        <item>flaky</item>
        <item>cruel</item>
        <item>label</item>
        <item>grain</item>
        <item>smile</item>
        <item>admit</item>
        <item>anger</item>
        <item>curly</item>
        <item>daily</item>
        <item>short</item>
        <item>fresh</item>
        <item>stare</item>
        <item>trade</item>
        <item>spill</item>
        <item>geese</item>
        <item>serve</item>
        <item>rinse</item>
        <item>gusty</item>
        <item>shoes</item>
        <item>minor</item>
        <item>decay</item>
        <item>twist</item>
        <item>bored</item>
        <item>guess</item>
        <item>verse</item>
        <item>paper</item>
        <item>stiff</item>
        <item>whine</item>
        <item>exist</item>
        <item>bathe</item>
        <item>steer</item>
        <item>curve</item>
        <item>harsh</item>
        <item>witty</item>
        <item>flood</item>
        <item>rigid</item>
        <item>drink</item>
        <item>small</item>
        <item>blood</item>
        <item>proud</item>
        <item>brake</item>
        <item>stone</item>
        <item>trees</item>
        <item>allow</item>
        <item>order</item>
        <item>press</item>
        <item>rural</item>
        <item>loose</item>
        <item>smell</item>
        <item>rapid</item>
        <item>songs</item>
        <item>empty</item>
        <item>slave</item>
        <item>lucky</item>
        <item>prick</item>
        <item>judge</item>
        <item>heavy</item>
        <item>cloth</item>
        <item>honey</item>
        <item>frame</item>
        <item>brass</item>
        <item>price</item>
        <item>knife</item>
        <item>front</item>
        <item>strip</item>
        <item>dance</item>
        <item>right</item>
        <item>fancy</item>
        <item>sleep</item>
        <item>power</item>
        <item>sheep</item>
        <item>angle</item>
        <item>goofy</item>
        <item>quilt</item>
        <item>angry</item>
        <item>whirl</item>
        <item>ruddy</item>
        <item>annoy</item>
        <item>weary</item>
        <item>ducks</item>
        <item>slimy</item>
        <item>aware</item>
        <item>queue</item>
        <item>brave</item>
        <item>crack</item>
        <item>gabby</item>
        <item>trust</item>
        <item>fuzzy</item>
        <item>raise</item>
        <item>juice</item>
        <item>plant</item>
        <item>range</item>
        <item>quiet</item>
        <item>early</item>
        <item>three</item>
        <item>blind</item>
        <item>brick</item>
        <item>spray</item>
        <item>hurry</item>
        <item>aback</item>
        <item>cable</item>
        <item>shade</item>
        <item>elfin</item>
        <item>cross</item>
        <item>sound</item>
        <item>tempt</item>
        <item>table</item>
        <item>known</item>
        <item>boast</item>
        <item>drown</item>
        <item>gaudy</item>
        <item>metal</item>
        <item>shiny</item>
        <item>amuck</item>
        <item>tasty</item>
        <item>class</item>
        <item>crack</item>
        <item>trick</item>
        <item>badge</item>
        <item>quack</item>
        <item>robin</item>
        <item>plain</item>
        <item>young</item>
        <item>women</item>
        <item>guide</item>
        <item>spark</item>
        <item>teeny</item>
        <item>shake</item>
        <item>thick</item>
        <item>spark</item>
        <item>pause</item>
        <item>zippy</item>
        <item>mourn</item>
        <item>punch</item>
        <item>ahead</item>
        <item>mouth</item>
        <item>furry</item>
        <item>blink</item>
        <item>chief</item>
        <item>lowly</item>
        <item>trace</item>
        <item>count</item>
        <item>coach</item>
        <item>place</item>
        <item>kaput</item>
        <item>needy</item>
        <item>start</item>
        <item>bawdy</item>
        <item>plant</item>
        <item>wreck</item>
        <item>rifle</item>
        <item>tiger</item>
        <item>smell</item>
        <item>black</item>
        <item>wrong</item>
        <item>crush</item>
        <item>bells</item>
        <item>blush</item>
        <item>worry</item>
        <item>faint</item>
        <item>amuse</item>
        <item>taste</item>
        <item>flame</item>
        <item>smoke</item>
        <item>waste</item>
        <item>close</item>
        <item>strap</item>
        <item>fancy</item>
        <item>zebra</item>
        <item>dream</item>
        <item>tough</item>
        <item>cause</item>
        <item>dizzy</item>
        <item>noisy</item>
        <item>groan</item>
        <item>curvy</item>
        <item>cream</item>
        <item>laugh</item>
        <item>dolls</item>
        <item>round</item>
        <item>pedal</item>
        <item>actor</item>
        <item>limit</item>
        <item>macho</item>
        <item>scent</item>
        <item>testy</item>
        <item>linen</item>
        <item>lumpy</item>
        <item>taboo</item>
        <item>happy</item>
        <item>reach</item>
        <item>mixed</item>
        <item>twist</item>
        <item>spoon</item>
        <item>crawl</item>
        <item>tacit</item>
        <item>basin</item>
        <item>rebel</item>
        <item>rabid</item>
        <item>pushy</item>
        <item>place</item>
        <item>sugar</item>
        <item>rainy</item>
        <item>magic</item>
        <item>naive</item>
        <item>grate</item>
        <item>screw</item>
        <item>royal</item>
        <item>offer</item>
        <item>brief</item>
        <item>slope</item>
        <item>books</item>
        <item>truck</item>
        <item>girls</item>
        <item>agree</item>
        <item>claim</item>
        <item>spoil</item>
        <item>smash</item>
        <item>ultra</item>
        <item>fixed</item>
        <item>paste</item>
        <item>noise</item>
        <item>greet</item>
        <item>alert</item>
        <item>plant</item>
        <item>spicy</item>
        <item>erect</item>
        <item>waves</item>
        <item>knock</item>
        <item>abaft</item>
        <item>marry</item>
        <item>route</item>
        <item>flash</item>
        <item>elbow</item>
        <item>alarm</item>
        <item>watch</item>
        <item>choke</item>
        <item>overt</item>
        <item>nappy</item>
        <item>meaty</item>
        <item>occur</item>
        <item>enjoy</item>
        <item>carve</item>
        <item>nippy</item>
        <item>queen</item>
        <item>ocean</item>
        <item>field</item>
        <item>check</item>
        <item>brake</item>
        <item>empty</item>
        <item>cheer</item>
        <item>milky</item>
        <item>light</item>
        <item>level</item>
        <item>flock</item>
        <item>float</item>
        <item>river</item>
        <item>reign</item>
        <item>thing</item>
        <item>woozy</item>
        <item>store</item>
        <item>shock</item>
        <item>death</item>
        <item>clear</item>
        <item>bless</item>
        <item>alive</item>
        <item>teeth</item>
        <item>crown</item>
        <item>night</item>
        <item>level</item>
        <item>voice</item>
        <item>drain</item>
        <item>glove</item>
        <item>delay</item>
        <item>husky</item>
        <item>watch</item>
        <item>frame</item>
        <item>giant</item>
        <item>swift</item>
        <item>drunk</item>
        <item>snore</item>
        <item>touch</item>
        <item>eight</item>
        <item>nasty</item>
        <item>force</item>
        <item>curve</item>
        <item>jazzy</item>
        <item>smile</item>
        <item>doubt</item>
        <item>moldy</item>
        <item>obese</item>
        <item>broad</item>
        <item>burly</item>
        <item>spell</item>
        <item>fence</item>
        <item>hover</item>
        <item>stale</item>
        <item>laugh</item>
        <item>silly</item>
        <item>grade</item>
        <item>dress</item>
        <item>nifty</item>
        <item>cheap</item>
        <item>uncle</item>
        <item>birds</item>
        <item>crook</item>
        <item>great</item>
        <item>equal</item>
        <item>group</item>
        <item>ritzy</item>
        <item>mushy</item>
        <item>unite</item>
        <item>clean</item>
        <item>crazy</item>
        <item>store</item>
        <item>birth</item>
        <item>shade</item>
        <item>argue</item>
        <item>stick</item>
        <item>north</item>
        <item>alert</item>
        <item>train</item>
        <item>cakes</item>
        <item>juicy</item>
        <item>elite</item>
        <item>shave</item>
        <item>straw</item>
        <item>scare</item>
        <item>match</item>
        <item>crowd</item>
        <item>learn</item>
        <item>haunt</item>
        <item>murky</item>
        <item>relax</item>
        <item>bikes</item>
        <item>avoid</item>
        <item>space</item>
        <item>money</item>
        <item>drain</item>
        <item>grass</item>
        <item>plate</item>
        <item>yummy</item>
        <item>kneel</item>
        <item>steam</item>
        <item>scary</item>
        <item>ready</item>
        <item>green</item>
        <item>tooth</item>
        <item>stamp</item>
        <item>smash</item>
        <item>treat</item>
        <item>cycle</item>
        <item>trail</item>
        <item>chess</item>
        <item>water</item>
        <item>eager</item>
        <item>sniff</item>
        <item>train</item>
        <item>cause</item>
        <item>trite</item>
        <item>burst</item>
        <item>crash</item>
        <item>value</item>
        <item>jumpy</item>
        <item>earth</item>
        <item>carry</item>
        <item>start</item>
        <item>funny</item>
        <item>level</item>
        <item>peace</item>
        <item>ratty</item>
        <item>shirt</item>
        <item>scrub</item>
        <item>vague</item>
        <item>coach</item>
        <item>rings</item>
        <item>order</item>
        <item>zesty</item>
        <item>handy</item>
        <item>touch</item>
        <item>house</item>
        <item>silky</item>
        <item>super</item>
        <item>frail</item>
        <item>spade</item>
        <item>scarf</item>
        <item>x-ray</item>
        <item>solid</item>
        <item>point</item>
        <item>crime</item>
        <item>false</item>
        <item>grape</item>
        <item>event</item>
        <item>legal</item>
        <item>large</item>
        <item>jelly</item>
        <item>error</item>
        <item>floor</item>
        <item>chase</item>
        <item>stamp</item>
        <item>cover</item>
        <item>sound</item>
        <item>sharp</item>
        <item>glass</item>
        <item>spare</item>
        <item>jewel</item>
        <item>foamy</item>
        <item>board</item>
        <item>spiky</item>
        <item>cough</item>
        <item>tense</item>
        <item>month</item>
        <item>clean</item>
        <item>white</item>
        <item>cover</item>
        <item>paint</item>
        <item>coast</item>
        <item>sense</item>
        <item>thank</item>
        <item>itchy</item>
        <item>puffy</item>
        <item>frogs</item>
        <item>stage</item>
        <item>ghost</item>
        <item>snail</item>
        <item>scold</item>
        <item>heady</item>
        <item>nerve</item>
        <item>messy</item>
        <item>jolly</item>
        <item>prose</item>
        <item>giddy</item>
        <item>irate</item>
        <item>thumb</item>
        <item>faded</item>
        <item>scale</item>
        <item>aloof</item>
        <item>rhyme</item>
        <item>kitty</item>
        <item>tease</item>
        <item>cagey</item>
        <item>dirty</item>
        <item>quill</item>
        <item>wrist</item>
        <item>party</item>
        <item>shaky</item>
        <item>berry</item>
        <item>tacky</item>
        <item>match</item>
        <item>dusty</item>
        <item>trade</item>
        <item>color</item>
        <item>chalk</item>
        <item>pinch</item>
        <item>fetch</item>
        <item>whole</item>
        <item>point</item>
        <item>enter</item>
        <item>share</item>
        <item>lunch</item>
        <item>brash</item>
        <item>raspy</item>
        <item>tangy</item>
        <item>steep</item>
        <item>first</item>
        <item>wacky</item>
        <item>trick</item>
        <item>waste</item>
        <item>rough</item>
        <item>windy</item>
        <item>blade</item>
        <item>acrid</item>
        <item>reply</item>
        <item>tramp</item>
        <item>crate</item>
        <item>sleet</item>
        <item>daffy</item>
        <item>stuff</item>
        <item>sassy</item>
        <item>awful</item>
        <item>tight</item>
        <item>smart</item>
        <item>humor</item>
        <item>dress</item>
        <item>clear</item>
        <item>cheat</item>
        <item>dusty</item>
        <item>salty</item>
        <item>swing</item>
        <item>roomy</item>
        <item>awake</item>
        <item>lying</item>
        <item>quick</item>
        <item>sweet</item>
        <item>woman</item>
        <item>scene</item>
        <item>upset</item>
        <item>sulky</item>
        <item>title</item>
        <item>tense</item>
        <item>sable</item>
        <item>phone</item>
        <item>godly</item>
        <item>water</item>
        <item>fruit</item>
        <item>misty</item>
        <item>third</item>
        <item>madly</item>
        <item>offer</item>
        <item>found</item>
        <item>cough</item>
        <item>bumpy</item>
        <item>horse</item>
        <item>quiet</item>
        <item>stain</item>
        <item>skate</item>
        <item>soggy</item>
        <item>stove</item>
        <item>nutty</item>
        <item>hands</item>
        <item>flesh</item>
        <item>guide</item>
        <item>taste</item>
        <item>snake</item>
        <item>screw</item>
        <item>plane</item>
        <item>brown</item>
        <item>smoke</item>
        <item>sheet</item>
        <item>guard</item>
        <item>shelf</item>
        <item>march</item>
        <item>alike</item>
    </string-array>
    <string-array name="words_6">
        <item>potato</item>
        <item>theory</item>
        <item>minute</item>
        <item>amount</item>
        <item>clover</item>
        <item>charge</item>
        <item>crabby</item>
        <item>return</item>
        <item>babies</item>
        <item>object</item>
        <item>change</item>
        <item>switch</item>
        <item>attach</item>
        <item>ticket</item>
        <item>voyage</item>
        <item>flower</item>
        <item>unpack</item>
        <item>spring</item>
        <item>basket</item>
        <item>battle</item>
        <item>caring</item>
        <item>drawer</item>
        <item>soothe</item>
        <item>seemly</item>
        <item>button</item>
        <item>reduce</item>
        <item>uneven</item>
        <item>ablaze</item>
        <item>harbor</item>
        <item>glossy</item>
        <item>unique</item>
        <item>exotic</item>
        <item>pickle</item>
        <item>trashy</item>
        <item>bottle</item>
        <item>cherry</item>
        <item>boring</item>
        <item>snakes</item>
        <item>sneeze</item>
        <item>supply</item>
        <item>depend</item>
        <item>lively</item>
        <item>attend</item>
        <item>ragged</item>
        <item>manage</item>
        <item>smoggy</item>
        <item>female</item>
        <item>admire</item>
        <item>breezy</item>
        <item>camera</item>
        <item>action</item>
        <item>quartz</item>
        <item>amused</item>
        <item>absent</item>
        <item>offend</item>
        <item>tickle</item>
        <item>animal</item>
        <item>phobic</item>
        <item>butter</item>
        <item>riddle</item>
        <item>winter</item>
        <item>stitch</item>
        <item>regret</item>
        <item>detect</item>
        <item>refuse</item>
        <item>wonder</item>
        <item>normal</item>
        <item>sister</item>
        <item>office</item>
        <item>belong</item>
        <item>signal</item>
        <item>broken</item>
        <item>living</item>
        <item>monkey</item>
        <item>savory</item>
        <item>travel</item>
        <item>expect</item>
        <item>middle</item>
        <item>zephyr</item>
        <item>sedate</item>
        <item>rustic</item>
        <item>steady</item>
        <item>reward</item>
        <item>settle</item>
        <item>vessel</item>
        <item>desire</item>
        <item>mother</item>
        <item>elated</item>
        <item>bouncy</item>
        <item>flavor</item>
        <item>effect</item>
        <item>harass</item>
        <item>number</item>
        <item>simple</item>
        <item>writer</item>
        <item>tawdry</item>
        <item>belief</item>
        <item>please</item>
        <item>mighty</item>
        <item>guitar</item>
        <item>wrench</item>
        <item>kettle</item>
        <item>appear</item>
        <item>untidy</item>
        <item>branch</item>
        <item>polish</item>
        <item>unused</item>
        <item>divide</item>
        <item>fasten</item>
        <item>invite</item>
        <item>inject</item>
        <item>bounce</item>
        <item>doctor</item>
        <item>battle</item>
        <item>gather</item>
        <item>shaggy</item>
        <item>petite</item>
        <item>quiver</item>
        <item>wooden</item>
        <item>homely</item>
        <item>disarm</item>
        <item>school</item>
        <item>quirky</item>
        <item>second</item>
        <item>attack</item>
        <item>bubble</item>
        <item>bushes</item>
        <item>things</item>
        <item>wiggly</item>
        <item>church</item>
        <item>orange</item>
        <item>grease</item>
        <item>remain</item>
        <item>rotten</item>
        <item>upbeat</item>
        <item>employ</item>
        <item>repeat</item>
        <item>nimble</item>
        <item>rabbit</item>
        <item>watery</item>
        <item>system</item>
        <item>border</item>
        <item>loving</item>
        <item>quince</item>
        <item>spotty</item>
        <item>ground</item>
        <item>remove</item>
        <item>pretty</item>
        <item>cloudy</item>
        <item>stormy</item>
        <item>public</item>
        <item>shrill</item>
        <item>number</item>
        <item>plants</item>
        <item>silent</item>
        <item>afraid</item>
        <item>prefer</item>
        <item>classy</item>
        <item>bucket</item>
        <item>fierce</item>
        <item>pocket</item>
        <item>sprout</item>
        <item>tricky</item>
        <item>double</item>
        <item>scorch</item>
        <item>giants</item>
        <item>engine</item>
        <item>design</item>
        <item>happen</item>
        <item>absurd</item>
        <item>listen</item>
        <item>profit</item>
        <item>mature</item>
        <item>flimsy</item>
        <item>lavish</item>
        <item>pumped</item>
        <item>throat</item>
        <item>quaint</item>
        <item>punish</item>
        <item>arrest</item>
        <item>yellow</item>
        <item>behave</item>
        <item>sticks</item>
        <item>friend</item>
        <item>window</item>
        <item>lethal</item>
        <item>icicle</item>
        <item>detail</item>
        <item>tested</item>
        <item>clammy</item>
        <item>suffer</item>
        <item>abject</item>
        <item>launch</item>
        <item>brawny</item>
        <item>bleach</item>
        <item>report</item>
        <item>lonely</item>
        <item>placid</item>
        <item>little</item>
        <item>plucky</item>
        <item>houses</item>
        <item>skinny</item>
        <item>desert</item>
        <item>preach</item>
        <item>locket</item>
        <item>cellar</item>
        <item>brainy</item>
        <item>health</item>
        <item>street</item>
        <item>pricey</item>
        <item>reject</item>
        <item>copper</item>
        <item>future</item>
        <item>throne</item>
        <item>flight</item>
        <item>knotty</item>
        <item>jagged</item>
        <item>remind</item>
        <item>bridge</item>
        <item>muddle</item>
        <item>damage</item>
        <item>uppity</item>
        <item>planes</item>
        <item>trains</item>
        <item>temper</item>
        <item>joyous</item>
        <item>useful</item>
        <item>shiver</item>
        <item>afford</item>
        <item>extend</item>
        <item>melted</item>
        <item>bright</item>
        <item>regret</item>
        <item>chubby</item>
        <item>thrill</item>
        <item>liquid</item>
        <item>kindly</item>
        <item>notice</item>
        <item>motion</item>
        <item>memory</item>
        <item>squeak</item>
        <item>plough</item>
        <item>common</item>
        <item>branch</item>
        <item>porter</item>
        <item>mellow</item>
        <item>lumber</item>
        <item>finger</item>
        <item>borrow</item>
        <item>square</item>
        <item>lovely</item>
        <item>lively</item>
        <item>hungry</item>
        <item>chance</item>
        <item>snails</item>
        <item>secret</item>
        <item>squash</item>
        <item>groovy</item>
        <item>wealth</item>
        <item>change</item>
        <item>squeal</item>
        <item>repair</item>
        <item>creepy</item>
        <item>stitch</item>
        <item>sleepy</item>
        <item>excuse</item>
        <item>expand</item>
        <item>versed</item>
        <item>record</item>
        <item>tender</item>
        <item>finger</item>
        <item>record</item>
        <item>clumsy</item>
        <item>dapper</item>
        <item>circle</item>
        <item>wicked</item>
        <item>matter</item>
        <item>cooing</item>
        <item>celery</item>
        <item>violet</item>
        <item>meddle</item>
        <item>acidic</item>
        <item>bitter</item>
        <item>smelly</item>
        <item>wobble</item>
        <item>rhythm</item>
        <item>excite</item>
        <item>strong</item>
        <item>polite</item>
        <item>grubby</item>
        <item>gratis</item>
        <item>gentle</item>
        <item>vanish</item>
        <item>zonked</item>
        <item>breath</item>
        <item>measly</item>
        <item>stingy</item>
        <item>retire</item>
        <item>marble</item>
        <item>island</item>
        <item>stream</item>
        <item>craven</item>
        <item>muscle</item>
        <item>chunky</item>
        <item>untidy</item>
        <item>marked</item>
        <item>curved</item>
        <item>deeply</item>
        <item>pencil</item>
        <item>racial</item>
        <item>faulty</item>
        <item>zipper</item>
        <item>handle</item>
        <item>swanky</item>
        <item>crayon</item>
        <item>sneaky</item>
        <item>insect</item>
        <item>clever</item>
        <item>feeble</item>
        <item>somber</item>
        <item>injure</item>
        <item>paltry</item>
        <item>scrape</item>
        <item>sordid</item>
        <item>permit</item>
        <item>flower</item>
        <item>wander</item>
        <item>tumble</item>
        <item>silver</item>
        <item>advice</item>
        <item>gaping</item>
        <item>cobweb</item>
        <item>attack</item>
        <item>unruly</item>
        <item>collar</item>
        <item>bright</item>
        <item>search</item>
        <item>scarce</item>
        <item>square</item>
        <item>better</item>
        <item>bruise</item>
        <item>superb</item>
        <item>cactus</item>
        <item>invent</item>
        <item>purple</item>
        <item>narrow</item>
        <item>expert</item>
        <item>person</item>
        <item>unlock</item>
        <item>fluffy</item>
        <item>modern</item>
        <item>credit</item>
        <item>smooth</item>
        <item>escape</item>
        <item>tongue</item>
        <item>pizzas</item>
        <item>advise</item>
        <item>cattle</item>
        <item>dreary</item>
        <item>flashy</item>
        <item>hollow</item>
        <item>closed</item>
        <item>powder</item>
        <item>turkey</item>
        <item>nation</item>
        <item>sturdy</item>
        <item>market</item>
        <item>cuddly</item>
        <item>abrupt</item>
        <item>recess</item>
        <item>petite</item>
        <item>decide</item>
        <item>reason</item>
        <item>mitten</item>
        <item>greasy</item>
        <item>sneeze</item>
        <item>cannon</item>
        <item>accept</item>
        <item>oafish</item>
        <item>sponge</item>
        <item>hammer</item>
        <item>letter</item>
        <item>gifted</item>
        <item>filthy</item>
        <item>juggle</item>
        <item>innate</item>
        <item>bubble</item>
        <item>stupid</item>
        <item>intend</item>
        <item>sticky</item>
        <item>vulgar</item>
        <item>orange</item>
        <item>snotty</item>
        <item>spiffy</item>
        <item>unable</item>
        <item>silent</item>
        <item>income</item>
        <item>colour</item>
        <item>scream</item>
        <item>eggnog</item>
        <item>degree</item>
        <item>stroke</item>
        <item>sloppy</item>
        <item>needle</item>
        <item>thread</item>
        <item>aboard</item>
        <item>scared</item>
        <item>summer</item>
        <item>snatch</item>
        <item>earthy</item>
        <item>string</item>
        <item>canvas</item>
        <item>torpid</item>
        <item>growth</item>
        <item>parcel</item>
        <item>horses</item>
        <item>answer</item>
        <item>paddle</item>
        <item>arrive</item>
        <item>chilly</item>
        <item>spooky</item>
        <item>hushed</item>
        <item>sudden</item>
        <item>ignore</item>
        <item>rescue</item>
        <item>robust</item>
        <item>hammer</item>
        <item>greedy</item>
        <item>trucks</item>
        <item>murder</item>
        <item>follow</item>
        <item>dinner</item>
        <item>grumpy</item>
        <item>cheese</item>
        <item>famous</item>
        <item>poised</item>
        <item>weight</item>
        <item>bloody</item>
        <item>donkey</item>
        <item>obtain</item>
        <item>inform</item>
        <item>poison</item>
    </string-array>
"""), colorsData: ANDColorsData(additional: ""))
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
    kapt Dependencies.dagger_hilt_compiler
    kapt Dependencies.hilt_viewmodel_compiler
    
}
"""
        let moduleGradleName = "build.gradle"

        let dependencies = """
package dependencies

object Application {
    const val id = "\(packageName)"
    const val version_code = 1
    const val version_name = "1.0"
}

object Build {
    const val build_tools = "com.android.tools.build:gradle:${Versions.gradle}"
    const val kotlin_gradle_plugin = "org.jetbrains.kotlin:kotlin-gradle-plugin:${Versions.kotlin}"
    const val hilt_plugin = "com.google.dagger:hilt-android-gradle-plugin:${Versions.hilt}"
}

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
