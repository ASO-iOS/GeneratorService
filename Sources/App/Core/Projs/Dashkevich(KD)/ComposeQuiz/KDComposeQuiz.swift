//
//  File.swift
//  
//
//  Created by admin on 11/13/23.
//

import Foundation

struct KDComposeQuiz: FileProviderProtocol {
    
    static var fileName: String = "\(NamesManager.shared.fileName).kt"
    
    static func fileContent(packageName: String, uiSettings: UISettings) -> String {
        return """
package \(packageName).presentation.fragments.main_fragment


import android.util.Log
import androidx.annotation.DrawableRes
import androidx.annotation.Keep
import androidx.annotation.StringRes
import androidx.compose.foundation.ExperimentalFoundationApi
import androidx.compose.foundation.Image
import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.pager.HorizontalPager
import androidx.compose.foundation.pager.PagerState
import androidx.compose.foundation.pager.rememberPagerState
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.ArrowBackIosNew
import androidx.compose.material3.ButtonDefaults
import androidx.compose.material3.CenterAlignedTopAppBar
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.FilledTonalButton
import androidx.compose.material3.Icon
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Text
import androidx.compose.material3.TextField
import androidx.compose.material3.TextFieldDefaults
import androidx.compose.material3.TopAppBarDefaults
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.SideEffect
import androidx.compose.runtime.collectAsState
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.TextStyle
import androidx.compose.ui.text.font.Font
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.font.toFontFamily
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.text.style.TextOverflow
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.hilt.navigation.compose.hiltViewModel
import androidx.lifecycle.SavedStateHandle
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import androidx.navigation.NavController
import androidx.navigation.NavType
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import androidx.navigation.compose.rememberNavController
import androidx.navigation.navArgument
import \(packageName).R
import com.google.accompanist.systemuicontroller.rememberSystemUiController
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.channels.Channel
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.flow.receiveAsFlow
import kotlinx.coroutines.launch
import javax.inject.Inject

val backColorPrimary = Color(0xFF\(uiSettings.backColorPrimary ?? "FFFFFF"))
val backColorSecondary = Color(0xFF\(uiSettings.backColorSecondary ?? "FFFFFF"))
val primaryColor = Color(0xFF\(uiSettings.primaryColor ?? "FFFFFF"))
val textColorPrimary = Color(0xFF\(uiSettings.textColorPrimary ?? "FFFFFF"))
val buttonColorPrimary = Color(0xFF\(uiSettings.buttonColorPrimary ?? "FFFFFF"))

val topicButton = TextStyle(
    fontSize = 18.sp,
    fontWeight = FontWeight.Normal,
)

val quizTopBar = TextStyle(
    fontSize = 20.sp,
    fontWeight = FontWeight.Bold,
)


val questionStyle = TextStyle(
    fontSize = 20.sp,
    fontWeight = FontWeight.Normal,
)

val answer = TextStyle(
    fontSize = 18.sp,
    fontWeight = FontWeight.Normal,
)

val questionButton = TextStyle(
    fontSize = 16.sp,
    fontWeight = FontWeight.Bold,
)

val defaultShape = RoundedCornerShape(14.dp)
abstract class BaseViewModel<State, Effect>(initState: State) : ViewModel() {

    private val _viewState: MutableStateFlow<State> = MutableStateFlow(initState)
    val viewState = _viewState.asStateFlow()

    private val _effects: Channel<Effect> = Channel()
    val effects: Flow<Effect> = _effects.receiveAsFlow()

    protected val state: State
        get() = viewState.value

    fun sendEffect(effect: Effect) = viewModelScope.launch {
        _effects.send(effect)
    }

    protected fun updateState(changeState: State.() -> State) {
        _viewState.value = viewState.value.changeState()
    }


}

const val DEBUG = "AppDebug"

fun Any?.logDebug(prefix: String = "", postfix: String = "") {
    val debugMessage = "$prefix $this $postfix"
    if (this is Throwable?) {
        Log.e(DEBUG, debugMessage)
    } else {
        Log.i(DEBUG, debugMessage)
    }
}


object DebugMessage {
    const val LOADING = "Loading"
    const val SUCCESS = "Success: "
    const val ERROR = "Error: "
    const val EMPTY = "Empty"
}


suspend inline fun <T> (suspend () -> Result<T>).loadAndHandleData(
    haveDebug: Boolean = false,
    onSuccess: (T) -> Unit = {},
    onEmpty: () -> Unit = {},
    onError: (Throwable) -> Unit = {},
    onLoading: () -> Unit = {}
) {
    onLoading()
    if (haveDebug) DebugMessage.LOADING.logDebug()
    this().resultHandler(
        onSuccess = { result ->
            if (haveDebug) (DebugMessage.SUCCESS + result).logDebug()
            onSuccess(result)
        },
        onEmpty = {
            if (haveDebug) DebugMessage.EMPTY.logDebug()
            onEmpty()
        },
        onError = { error ->
            if (haveDebug) (DebugMessage.ERROR + error.message).logDebug()
            onError(error)
        }
    )
}

inline fun <T> Result<T>.resultHandler(
    onSuccess: (T) -> Unit,
    onError: (Throwable) -> Unit,
    onEmpty: () -> Unit
) {
    onSuccess { value ->
        if (value is Collection<*>) {
            if (value.isEmpty()) onEmpty()
            else onSuccess(value)
        } else if (value is Map<*, *>) {
            if (value.isEmpty()) onEmpty()
            else onSuccess(value)
        } else if (value is Array<*>) {
            if (value.isEmpty()) onEmpty()
            else onSuccess(value)
        } else if (value.toString().isEmpty()) {
            onEmpty()
        } else {
            onSuccess(value)
        }
    }
    onFailure { error ->
        onError(error)
    }
}


sealed class Destinations(val route: String) {

    object Main : Destinations(Routes.MAIN) {

        fun templateRoute(): String {
            return route
        }

        fun requestRoute(): String {
            return route
        }

    }

    object Quiz : Destinations(Routes.QUIZ) {

        const val TITLE_ARG = "title"
        const val TITLE_ROUTE_ARG = "{$TITLE_ARG}"

        fun openQuiz(titleId: Int): String {
            return route.replace(TITLE_ROUTE_ARG, titleId.toString())
        }

    }

}

object Routes {

    const val MAIN = "main"
    const val QUIZ = "quiz?=${Destinations.Quiz.TITLE_ROUTE_ARG}"
}

@Composable
fun AppNavigation() {
    val navController = rememberNavController()

    NavHost(
        modifier = Modifier
            .fillMaxSize()
            .background(color = backColorPrimary),
        navController = navController,
        startDestination = Destinations.Main.route
    ) {
        composable(Destinations.Main.route) { MainDest(navController) }
        composable(
            Destinations.Quiz.route,
            arguments = listOf(
                navArgument(Destinations.Quiz.TITLE_ARG) {
                    type = NavType.IntType
                }
            )
        ) {
            QuizDest(navController)
        }
    }


}

@Composable
fun TopicButton(
    modifier: Modifier = Modifier,
    topic: Topic,
    onClick: () -> Unit
) {
    FilledTonalButton(
        modifier = modifier,
        onClick = { onClick() },
        colors = ButtonDefaults.filledTonalButtonColors(
            contentColor = backColorPrimary,
            disabledContainerColor = primaryColor,
            containerColor = primaryColor,
            disabledContentColor = backColorPrimary
        ),
        shape = defaultShape,
        contentPadding = PaddingValues(vertical = 16.dp, horizontal = 20.dp)
    ) {
        Text(
            text = stringResource(id = topic.quiz.titleId),
            color = backColorPrimary,
            style = topicButton
        )
    }
}

@Composable
fun MainContent(
    modifier: Modifier = Modifier,
    viewModel: MainViewModel,
    viewState: MainState,
    onQuizNavigate: (Int) -> Unit
) {
    Column(
        modifier = modifier,
        horizontalAlignment = Alignment.CenterHorizontally,
        verticalArrangement = Arrangement.spacedBy(14.dp, Alignment.CenterVertically)
    ) {
        Image(
            modifier = Modifier.size(150.dp),
            painter = painterResource(id = R.drawable.jetpack_compose_img),
            contentDescription = null
        )
        Spacer(modifier = Modifier.height(20.dp))
        viewState.topics.forEach { topic ->
            TopicButton(
                modifier = Modifier.fillMaxWidth(),
                topic = topic,
                onClick = {
                    onQuizNavigate(topic.quiz.titleId)
                }
            )
        }
    }
}

@Keep
enum class Topic(
    val quiz: Quiz
) {
    Begginer(begginerQuiz),
    Lifecycle(lifecycleQuiz),
    SideEffects(sideEffectQuiz)
}
@Keep
sealed interface Question {
    val text: String
    val correctAnswer: String
}
@Keep
data class ChoiceQuestion(
    override val text: String,
    val options: List<String>,
    override val correctAnswer: String,
) : Question
@Keep
data class ImageChoiceQuestion(
    @DrawableRes
    val imageId: Int,
    override val text: String,
    val options: List<String>,
    override val correctAnswer: String,
) : Question
@Keep
data class InputQuestion(
    override val text: String,
    override val correctAnswer: String,
) : Question


@Keep
data class Quiz(
    @StringRes
    val titleId: Int,
    val questions: List<Question> = emptyList()
)


val begginerQuiz = Quiz(
    titleId = R.string.begginer_topic,
    questions = listOf(
        ChoiceQuestion(
            text = "Какая парадигма заложена в Jetpack Compose?",
            options = listOf(
                "ООП парадигма. В Jetpack Copmose необходимо \\n" +
                        "   описывать объекты для создания интерфейса. Обычно это\\n" +
                        "   некоторые объекты, которые вызывают собственные методы\\n" +
                        "   или передают котроль над собой другому объекту для отрисовки.",
                "В Jeptack Compose заложен функциональный подход.\\n" +
                        "   Создание интерфейса производится с помощью вызова функций,\\n" +
                        "   которые рисуют интерфейс. Используютя уже готовые конструкции для разработки."
            ),
            correctAnswer = "В Jeptack Compose заложен функциональный подход.\\n" +
                    "   Создание интерфейса производится с помощью вызова функций,\\n" +
                    "   которые рисуют интерфейс. Используютя уже готовые конструкции для разработки."
        ),
        ChoiceQuestion(
            text = "Что такое рекомпозиция?",
            options = listOf(
                "Это изменение состояния экрана'",
                "Повторный вызов компонуемой функции с новыми значениями",
                "Вызвыется при выходе с @Composable функции"
            ),
            correctAnswer = "Повторный вызов компонуемой функции с новыми значениями"
        ),
        ChoiceQuestion(
            text = "В каком порядке запускаются функции @Composable функции?",
            options = listOf(
                "В порядке вызова функций",
                "В обратном порядке вызова функций",
                "В любом порядке",
                "Первую вызывает последней, остальные по порядку"
            ),
            correctAnswer = "В любом порядке"
        ),
        ChoiceQuestion(
            text = "В каком случае функция перекомпануется?",
            options = listOf(
                "При нажатии на экран",
                "Рекомпозиция происходит каждую секунду",
                "При изменении входного состояния",
            ),
            correctAnswer = "При изменении входного состояния"
        ),
        ChoiceQuestion(
            text = "Функции запускаются синхронно или параллельно?",
            options = listOf(
                "Синхронно",
                "Параллельно",
            ),
            correctAnswer = "Параллельно"
        ),
        ChoiceQuestion(
            text = "Сколько дорогостоящих по ресурсам и времени\\n" +
                    "рекомендуется вызывать операций в @Composable функции?",
            options = listOf(
                "Не более 3-ех операций",
                "Не одной операции",
                "1 можно, но приусловии, что есть только 1 экран",
            ),
            correctAnswer = "Не одной операции"
        ),
    )
)

val lifecycleQuiz = Quiz(
    titleId = R.string.lifecycle_topic,
    questions = listOf(
        ChoiceQuestion(
            text = "Какой жизненный цикл у @Composable функции",
            options = listOf(
                "Жизненный цикл в котром есть onCreateView, схожий с Fragment",
                "@Composable копирует жизненный цикл Activity",
                "Жизненый цикл состоит из 3 этапов: Первичная композиция, рекомпозиции и выход из функции",
            ),
            correctAnswer = "Жизненый цикл состоит из 3 этапов: Первичная композиция, рекомпозиции и выход из функции"
        ),
        ImageChoiceQuestion(
            text = "Произойдет ли рекомпозиция?",
            imageId = R.drawable.lifecycle_1_image,
            options = listOf(
                "Рекомпозиция не произойдет",
                "Рекомпозиция произойдет"
            ),
            correctAnswer = "Рекомпозиция не произойдет"
        ),
        ChoiceQuestion(
            text = "Какие типы рекомендуется использовать в состоянии?",
            options = listOf(
                "Только примивные типы",
                "Типы помеченные аннотацией @Stable",
                "Неизменяемые типы, уведомлящие композицию при изменениях",
            ),
            correctAnswer = "Неизменяемые типы, уведомлящие композицию при изменениях"
        ),
    )
)

val sideEffectQuiz = Quiz(
    titleId = R.string.side_effects,
    questions = listOf(
        ChoiceQuestion(
            text = "Когда вызывется независимый от состояния LaunchedEffect?",
            options = listOf(
                "При каждой рекомпозиции экрана",
                "Сначала вызваются все присутсвующие @Composable функции, потом LaunchedEffect",
                "При первой композиии",
            ),
            correctAnswer = "При первой композиии"
        ),
        InputQuestion(
            text = "Как называется функция, которая может создать CoroutineScope, который отмениться при выходе из этой же функции",
            correctAnswer = "rememberCoroutineScope"
        ),
        ChoiceQuestion(
            text = "Что делает DisposableEffect?",
            options = listOf(
                "Создает LaunchedEffect",
                "Вызывается при каждой рекомпозиции",
                "При выходе с экрана вызывается",
                "При изменение ключа вызывается, после изменения или выхода с Composable функции вызывает onDispose"
            ),
            correctAnswer = "При изменение ключа вызывается, после изменения или выхода с Composable функции вызывает onDispose"
        ),
        ChoiceQuestion(
            text = "Каким образом можно избежать лишних композиций, высчитывая производное состояние?",
            options = listOf(
                "Используя вычисления производного состояния и обращения к нему в Composable функции",
                "Используя dervideStateOf",
            ),
            correctAnswer = "Используя dervideStateOf"
        ),
    )
)
data class MainState(
    val topics: List<Topic> = Topic.values().toList()
)
sealed interface MainEffect {

}

@Composable
fun MainDest(navController: NavController) {
    val mainViewModel = hiltViewModel<MainViewModel>()
    val viewState = mainViewModel.viewState.collectAsState().value
    MainScreen(
        viewModel = mainViewModel,
        viewState = viewState,
        onQuizNavigate = { idTitle ->
            navController.navigate(Destinations.Quiz.openQuiz(idTitle))
        }
    )

    val systemUiController = rememberSystemUiController()
    SideEffect {
        systemUiController.setSystemBarsColor(
            color = backColorPrimary,
            darkIcons = false
        )
    }
}
@Composable
fun MainScreen(viewModel: MainViewModel, viewState: MainState, onQuizNavigate: (Int) -> Unit) {
    Scaffold(
        containerColor = backColorPrimary
    ) { paddingValues ->
        MainContent(
            modifier = Modifier
                .padding(paddingValues)
                .fillMaxSize()
                .verticalScroll(rememberScrollState())
                .padding(40.dp),
            viewModel = viewModel,
            viewState = viewState,
            onQuizNavigate = onQuizNavigate
        )
    }
    LaunchedEffect(Unit) {
        viewModel.effects.collect {

        }
    }
}

@HiltViewModel
class MainViewModel @Inject constructor(): BaseViewModel<MainState, MainEffect>(MainState()) {


}
@Composable
fun FinishContent(
    modifier: Modifier = Modifier,
    viewState: QuizState
) {
    Box(modifier = modifier, contentAlignment = Alignment.Center) {
        Column(
            modifier = Modifier
                .border(width = 2.dp, shape = defaultShape, color = backColorSecondary)
                .padding(horizontal = 20.dp, vertical = 30.dp),
            horizontalAlignment = Alignment.CenterHorizontally
        ) {
            if (viewState.finish == Finish.Ideal) {
                FinishText(
                    text = stringResource(R.string.ideal_finish),
                    maxLines = Int.MAX_VALUE
                )
            } else {
                FinishText(
                    text = stringResource(
                        R.string.correct_answers,
                        viewState.countCorrectAnswers
                    )
                )
                FinishText(
                    text = stringResource(
                        R.string.wrong_answers,
                        viewState.countNoCorrectAnswers
                    )
                )
                FinishText(
                    text = stringResource(
                        R.string.total_questions,
                        viewState.questions.size
                    )
                )
            }

        }
    }
}

@Composable
fun FinishText(text: String, maxLines: Int = 1) {
    Text(
        text = text,
        color = textColorPrimary,
        style = answer,
        textAlign = TextAlign.Center,
        maxLines = maxLines,
        overflow = TextOverflow.Ellipsis
    )
}
@Composable
fun NextButton(
    modifier: Modifier = Modifier,
    onClick: () -> Unit,
    text: String
) {
    FilledTonalButton(
        modifier = modifier,
        onClick = {
            onClick()
        },
        colors = ButtonDefaults.filledTonalButtonColors(
            disabledContainerColor = buttonColorPrimary,
            containerColor = buttonColorPrimary,
        ),
        shape = defaultShape,
        contentPadding = PaddingValues(vertical = 18.dp, horizontal = 10.dp)
    ) {
        Text(
            text = text,
            color = backColorPrimary,
            style = questionButton,
            maxLines = 1,
            overflow = TextOverflow.Ellipsis
        )
    }
}
@Composable
fun OptionCard(
    modifier: Modifier = Modifier,
    option: String,
    color: Color
) {
    Text(
        modifier = modifier,
        text = option,
        color = color,
        style = answer,
        textAlign = TextAlign.Center
    )
}
@Composable
fun QuestionBuilder(
    modifier: Modifier = Modifier,
    question: Question,
    answerField: String,
    onAnswerFieldChange: (String) -> Unit,
    answer: String,
    changeAnswer: (String) -> Unit
) {
    Column(
        modifier = modifier.verticalScroll(rememberScrollState()),
        horizontalAlignment = Alignment.CenterHorizontally,
        verticalArrangement = Arrangement.spacedBy(16.dp)
    ) {
        if (question is ImageChoiceQuestion) {
            Image(
                modifier = Modifier
                    .fillMaxWidth()
                    .height(240.dp)
                    .clip(defaultShape),
                painter = painterResource(id = question.imageId),
                contentDescription = null,
                contentScale = ContentScale.FillBounds
            )
        }
        Text(
            modifier = Modifier
                .border(shape = defaultShape, color = backColorSecondary, width = 2.dp)
                .padding(24.dp),
            text = question.text,
            color = textColorPrimary,
            style = questionStyle,
            textAlign = TextAlign.Center
        )
        Spacer(modifier = Modifier.height(14.dp))

        when(question){
            is ChoiceQuestion -> {
                OptionsColumn(options = question.options, answer = answer, onClick = changeAnswer)
            }
            is ImageChoiceQuestion -> {
                OptionsColumn(options = question.options, answer = answer, onClick = changeAnswer)
            }
            is InputQuestion -> {}
        }
        if (question is InputQuestion) {
            QuestionField(
                modifier = Modifier
                    .fillMaxWidth()
                    .height(140.dp)
                    .padding(10.dp),
                value = answerField,
                onValueChange = onAnswerFieldChange,
            )
        }

    }
}

@Composable
fun OptionsColumn(options: List<String>, answer: String, onClick: (String) -> Unit) {
    options.forEach { option ->
        val optionCardColor = if (option == answer) primaryColor else backColorSecondary
        val optionTextColr = if (option == answer) backColorPrimary else textColorPrimary
        OptionCard(
            option = option,
            modifier = Modifier
                .clickable {
                    option.logDebug()
                    onClick(option)
                }
                .fillMaxWidth()
                .background(shape = defaultShape, color = optionCardColor)
                .padding(20.dp),
            color = optionTextColr
        )
    }
}

@Composable
fun QuestionField(
    modifier: Modifier = Modifier,
    value: String,
    onValueChange: (String) -> Unit
) {
    TextField(
        value = value,
        onValueChange = onValueChange,
        modifier = modifier,
        colors = TextFieldDefaults.colors(
            focusedContainerColor = backColorSecondary,
            unfocusedContainerColor = backColorSecondary,
            focusedTextColor = textColorPrimary,
            unfocusedTextColor = textColorPrimary,
            unfocusedIndicatorColor = Color.Transparent,
            focusedIndicatorColor = Color.Transparent,
            cursorColor = textColorPrimary
        ),
        shape = defaultShape,
        textStyle = answer,
        placeholder = {
            Text(
                modifier = Modifier,
                text = stringResource(R.string.placeholed),
                color = textColorPrimary,
                style = answer,
                textAlign = TextAlign.Center
            )
        }
    )
}
@OptIn(ExperimentalFoundationApi::class)
@Composable
fun QuizContent(
    modifier: Modifier = Modifier,
    viewModel: QuizViewModel,
    viewState: QuizState,
    pagerState: PagerState,
    finish: Finish
) {
    if(finish == Finish.None) {
        HorizontalPager(pageCount = viewState.questions.size, state = pagerState, userScrollEnabled = false) { page ->
            QuestionBuilder(
                modifier = modifier,
                question = viewState.questions[page],
                answerField = viewState.answerField,
                onAnswerFieldChange = { newText ->
                    viewModel.changeAnswerField(newText)
                },
                answer = viewState.answers[page],
                changeAnswer = { newAnswer ->
                    viewModel.changeAnswer(newAnswer)
                }
            )
        }
    }else{
        FinishContent(modifier = modifier, viewState = viewState)
    }
}
@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun QuizTopBar(
    modifier: Modifier = Modifier,
    onBackNavigate: () -> Unit,
    level: Int,
    finish: Finish
) {
    val text = if (finish == Finish.None) stringResource(
        R.string.level,
        level
    ) else stringResource(R.string.result)

    CenterAlignedTopAppBar(
        title = {
            Text(
                text = text,
                color = backColorPrimary,
                style = quizTopBar,
                maxLines = 1,
                overflow = TextOverflow.Ellipsis
            )
        },
        navigationIcon = {
            if (finish == Finish.None) {
                Icon(
                    modifier = Modifier
                        .padding(14.dp)
                        .size(30.dp)
                        .clickable {
                            onBackNavigate()
                        },
                    imageVector = Icons.Default.ArrowBackIosNew,
                    contentDescription = null,
                    tint = backColorPrimary
                )
            }
        },
        colors = TopAppBarDefaults.centerAlignedTopAppBarColors(
            containerColor = primaryColor
        ),
        modifier = modifier
    )
}
data class QuizState(
    val questions: List<Question> = emptyList(),
    val answers: List<String> = emptyList(),
    val currentQuestionIndex: Int = 0,
    @StringRes
    val titleId: Int = 0,
    val answerField: String = "",
    val finish: Finish = Finish.None,
    val countCorrectAnswers: Int = 0,
    val countNoCorrectAnswers: Int = 0
)


enum class Finish{
    None,
    Default,
    Ideal
}
sealed interface QuizEffect {
    object NextPage : QuizEffect

}
@HiltViewModel
class QuizViewModel @Inject constructor(
    savedStateHandle: SavedStateHandle
) : BaseViewModel<QuizState, QuizEffect>(QuizState()) {

    init {
        savedStateHandle.get<Int>(Destinations.Quiz.TITLE_ARG)?.let { titleId ->
            initState(titleId)
        }
    }

    private fun initState(titleId: Int) = viewModelScope.launch {
        val topics = Topic.values().toList()
        updateState {
            copy(
                titleId = titleId,
                questions = topics.find { topic -> topic.quiz.titleId == titleId }?.quiz?.questions ?: emptyList()
            )
        }
        updateState {
            copy(
                answers = List(questions.size) { "" }
            )
        }
        state.questions.logDebug()
    }

    fun changeAnswerField(newText: String) = viewModelScope.launch {
        updateState {
            val list = answers.toMutableList()
            list[currentQuestionIndex] = newText
            copy(
                answerField = newText,
                answers = list
            )
        }
    }

    fun updateCurrentQuestionIndex(page: Int) = viewModelScope.launch {
        updateState {
            copy(
                currentQuestionIndex = page
            )
        }
    }

    fun changeAnswer(answer: String) = viewModelScope.launch {
        updateState {
            val list = answers.toMutableList()
            list[currentQuestionIndex] = answer
            copy(
                answers = list
            )
        }
    }

    fun finish() = viewModelScope.launch {
        val correctAnswers = state.answers.filterIndexed { index: Int, answer: String ->
            answer == state.questions[index].correctAnswer
        }
        val newFinish =
            if (correctAnswers.size == state.questions.size) Finish.Ideal else Finish.Default
        updateState {
            copy(
                finish = newFinish,
                countCorrectAnswers = correctAnswers.size,
                countNoCorrectAnswers = state.questions.size - correctAnswers.size
            )
        }
    }
}
@OptIn(ExperimentalFoundationApi::class)
@Composable
fun QuizScreen(viewModel: QuizViewModel, viewState: QuizState, onBackNavigate: () -> Unit) {
    val pagerState = rememberPagerState(viewState.currentQuestionIndex)
    Scaffold(
        containerColor = backColorPrimary,
        topBar = {
            QuizTopBar(
                onBackNavigate = { onBackNavigate() },
                level = pagerState.currentPage + 1,
                finish = viewState.finish
            )
        },
        bottomBar = {
            val (onClick, text) =
                if (viewState.finish != Finish.None) ({ onBackNavigate() }) to stringResource(R.string.home)
                else if (viewState.currentQuestionIndex == viewState.questions.size - 1) ({ viewModel.finish() }) to stringResource(
                    R.string.finish
                )
                else ({ viewModel.sendEffect(QuizEffect.NextPage) }) to stringResource(R.string.next_question)

            NextButton(
                modifier = Modifier
                    .padding(vertical = 20.dp, horizontal = 30.dp)
                    .fillMaxWidth(),
                onClick = {
                    onClick()
                },
                text = text
            )
        }
    ) { paddingValues ->
        QuizContent(
            modifier = Modifier
                .padding(paddingValues)
                .fillMaxSize()
                .padding(horizontal = 10.dp)
                .padding(top = 20.dp, bottom = 40.dp),
            viewModel = viewModel,
            viewState = viewState,
            pagerState = pagerState,
            finish = viewState.finish
        )
    }
    LaunchedEffect(Unit) {
        viewModel.effects.collect { effect ->
            when (effect) {
                QuizEffect.NextPage -> {
                    try {
                        pagerState.animateScrollToPage(pagerState.currentPage + 1)
                    } catch (ex: Exception) {
                        onBackNavigate()
                    }
                }
            }
        }
    }
    LaunchedEffect(pagerState.currentPage) {
        viewModel.updateCurrentQuestionIndex(pagerState.currentPage)
    }
}

@Composable
fun QuizDest(navController: NavController) {
    val viewModel = hiltViewModel<QuizViewModel>()
    val viewState = viewModel.viewState.collectAsState().value
    QuizScreen(viewModel = viewModel, viewState = viewState, onBackNavigate = {
        navController.popBackStack()
    })
    val systemUiController = rememberSystemUiController()
    SideEffect {
        systemUiController.apply {
            setStatusBarColor(
                color = primaryColor,
                darkIcons = false
            )
            setNavigationBarColor(
                color = backColorPrimary,
                darkIcons = false
            )
        }
    }
}
"""
    }
    
    static func dependencies(_ mainData: MainData) -> ANDData {
        return ANDData(
            mainFragmentData: .init(imports: "",
                                    content: """
AppNavigation()
"""),
            mainActivityData: .empty,
            themesData: .def,
            stringsData: .init(additional: """
    <string name="begginer_topic">Composable function</string>
    <string name="lifecycle_topic">Life cycle</string>
    <string name="level">Level %d</string>
    <string name="next_question">Next question</string>
    <string name="placeholed">Enter your answer</string>
    <string name="finish">Finish</string>
    <string name="correct_answers">Correct answers - %1$s</string>
    <string name="wrong_answers">Wrong answers - %1$s</string>
    <string name="total_questions">Total questions - %1$s</string>
    <string name="ideal_finish">Congratulations, you answered all questions correctly!!</string>
    <string name="result">Result</string>
    <string name="home">Home</string>
    <string name="side_effects">Side-effects</string>
"""),
            colorsData: .empty
        )
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

plugins{
    id 'com.android.application'
    id 'org.jetbrains.kotlin.android'
    id 'kotlin-kapt'
    id 'dagger.hilt.android.plugin'
}

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
            signingConfig signingConfigs.debug
            minifyEnabled true
            shrinkResources true
            proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'), 'proguard-rules.pro'
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
    //Base
    implementation Dependencies.core_ktx
    implementation Dependencies.appcompat
    implementation Dependencies.material
    
    //Compose
    implementation Dependencies.compose_ui
    implementation Dependencies.compose_preview
    implementation Dependencies.compose_material3
    implementation Dependencies.compose_activity
    implementation Dependencies.compose_ui_tooling
    implementation Dependencies.compose_navigation
    implementation Dependencies.compose_foundation
    implementation Dependencies.compose_runtime
    implementation Dependencies.compose_runtime_livedata
    implementation Dependencies.compose_mat_icons_core
    implementation Dependencies.compose_mat_icons_core_extended
    implementation Dependencies.compose_system_ui_controller

    implementation Dependencies.coil_compose

    //Other
    implementation Dependencies.coroutines
    implementation Dependencies.fragment_ktx
    implementation Dependencies.lifecycle_viewmodel
    implementation Dependencies.lifecycle_runtime

    //DI
    implementation Dependencies.dagger_hilt
    kapt Dependencies.dagger_hilt_compiler
    kapt Dependencies.hilt_viewmodel_compiler
    implementation Dependencies.compose_hilt_nav

    //Internet
    implementation Dependencies.retrofit
    implementation Dependencies.converter_gson
    implementation Dependencies.okhttp_login_interceptor

    //Room
    kapt Dependencies.room_compiler
    implementation Dependencies.room_runtime
    implementation Dependencies.room_ktx

    
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
    const val coil = "2.4.0"
    const val exp = "0.4.8"
    const val calend = "0.5.1"
    const val paging_version = "3.1.1"
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
