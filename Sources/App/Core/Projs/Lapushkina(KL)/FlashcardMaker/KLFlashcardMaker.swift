//
//  File.swift
//  
//
//  Created by admin on 23.08.2023.
//

import Foundation

struct KLFlashcardMaker: FileProviderProtocol {
    static var fileName = "\(NamesManager.shared.fileName).kt"
    
    static func fileContent(packageName: String, uiSettings: UISettings) -> String {
        return """
package \(packageName).presentation.fragments.main_fragment

import android.content.Context
import androidx.compose.foundation.BorderStroke
import androidx.compose.foundation.ExperimentalFoundationApi
import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.combinedClickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Add
import androidx.compose.material.icons.filled.ArrowLeft
import androidx.compose.material.icons.filled.ArrowRight
import androidx.compose.material.icons.filled.Cancel
import androidx.compose.material.icons.filled.Delete
import androidx.compose.material.icons.filled.PlayArrow
import androidx.compose.material3.Button
import androidx.compose.material3.ButtonDefaults
import androidx.compose.material3.FloatingActionButton
import androidx.compose.material3.Icon
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.OutlinedButton
import androidx.compose.material3.Text
import androidx.compose.material3.TextField
import androidx.compose.material3.TextFieldDefaults
import androidx.compose.material3.Typography
import androidx.compose.material3.lightColorScheme
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.TextStyle
import androidx.compose.ui.text.font.FontFamily
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.compose.ui.window.Dialog
import androidx.compose.ui.window.DialogProperties
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
import androidx.room.Dao
import androidx.room.Database
import androidx.room.Delete
import androidx.room.Entity
import androidx.room.Insert
import androidx.room.OnConflictStrategy
import androidx.room.PrimaryKey
import androidx.room.Query
import androidx.room.Room
import androidx.room.RoomDatabase
import \(packageName).R
import dagger.Module
import dagger.Provides
import dagger.hilt.InstallIn
import dagger.hilt.android.lifecycle.HiltViewModel
import dagger.hilt.android.qualifiers.ApplicationContext
import dagger.hilt.components.SingletonComponent
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.collect
import kotlinx.coroutines.flow.combine
import kotlinx.coroutines.flow.flowOn
import kotlinx.coroutines.flow.map
import kotlinx.coroutines.launch
import javax.inject.Inject
import javax.inject.Singleton

//generator
val backColorPrimary = Color(0xFF\(uiSettings.backColorPrimary ?? "FFFFFF"))
val backColorSecondary = Color(0xFF\(uiSettings.backColorSecondary ?? "FFFFFF"))
val surfaceColor = Color(0xFF\(uiSettings.surfaceColor ?? "FFFFFF"))
val primaryColor = Color(0xFF\(uiSettings.primaryColor ?? "FFFFFF"))
val buttonTextColorPrimary = Color(0xFF\(uiSettings.buttonTextColorPrimary ?? "FFFFFF"))
val textColorPrimary = Color(0xFF\(uiSettings.textColorPrimary ?? "FFFFFF"))

//other
val layoutPadding = 32.dp
val layoutSpacer = 32.dp
val itemSpacer = 16.dp
val dialogSpacer = 24.dp
val dialogPadding = 24.dp

val roundedCorner = 8.dp

val iconSize = 24.dp

val textFieldHeight = 56.dp

val cardHeight = 80.dp
val cardPadding = 24.dp

val buttonPadding = 50.dp

val flashcardLearnHeight = 180.dp

const val transparentCoef = 0.8f

val fontFamily = FontFamily.Monospace

val smallFontSize = 16.sp
val mediumFontSize = 20.sp
val largeFontSize = 32.sp

val typography = Typography(
    displaySmall = TextStyle(
        fontFamily = fontFamily, fontSize = smallFontSize, color = textColorPrimary
    ),
    displayMedium = TextStyle(
        fontFamily = fontFamily, fontSize = mediumFontSize, color = textColorPrimary
    ),
    displayLarge = TextStyle(
        fontFamily = fontFamily, fontSize = largeFontSize, color = textColorPrimary
    )
)

val colorScheme = lightColorScheme(
    background = backColorPrimary,
    primary = primaryColor,
    secondary = backColorSecondary,
    onSecondary = textColorPrimary,
    primaryContainer = surfaceColor,
    onPrimaryContainer = buttonTextColorPrimary,
    secondaryContainer = surfaceColor,
    onBackground = textColorPrimary,
    surface = surfaceColor
)

@Composable
fun FlashcardTheme(
    content: @Composable () -> Unit
) {
    MaterialTheme(
        colorScheme = colorScheme,
        typography = typography,
        content = content
    )
}

@Composable
fun FlashcardScreen(
    navController: NavController,
    categoryId: Int
) {
    val viewModel = hiltViewModel<FlashcardViewModel>()
    FlashcardTheme {
        FlashcardScreenContent(
            state = viewModel.state,
            onEvent = viewModel::onEvent,
            onStart = {
                navController.navigate("${Screen.LearningScreen().route}/$categoryId")
            }
        )
    }
}

@Composable
fun FlashcardScreenContent(
    state: FlashcardState,
    onEvent: (FlashcardEvent) -> Unit,
    onStart: () -> Unit
) {
    val openDialog = remember { mutableStateOf(false) }
    val dialogFlashcard = remember { mutableStateOf<FlashcardEntity?>(null) }

    if (openDialog.value) {
        FlashcardDialog(
            onDismiss = {
                openDialog.value = false
            },
            onEvent = onEvent,
            dialogFlashcard.value
        )
    }

    Column(
        modifier = Modifier
            .background(MaterialTheme.colorScheme.background)
            .fillMaxSize()
            .padding(layoutPadding),
        horizontalAlignment = Alignment.CenterHorizontally,
        verticalArrangement = Arrangement.spacedBy(layoutSpacer)
    ) {
        Row(
            modifier = Modifier.fillMaxWidth(),
            horizontalArrangement = Arrangement.SpaceBetween
        ) {
            Text(
                text = state.category.name,
                style = MaterialTheme.typography.displayLarge
            )
            Button(
                shape = CircleShape,
                onClick = {
                    if (state.flashcards.isNotEmpty()) {
                        onStart()
                    }
                },
                colors = ButtonDefaults.buttonColors(
                    containerColor = MaterialTheme.colorScheme.primaryContainer
                )
            ) {
                Icon(Icons.Default.PlayArrow, null, tint = MaterialTheme.colorScheme.onPrimaryContainer)
            }
        }

        LazyColumn(
            modifier = Modifier.weight(1f),
            verticalArrangement = Arrangement.spacedBy(itemSpacer)
        ) {
            items(items = state.flashcards, key = { it.id }, itemContent = { item ->
                Flashcard(
                    flashcard = item,
                    onClick = {
                        onEvent(FlashcardEvent.LookAtFlashcard(item))
                        dialogFlashcard.value = item
                        openDialog.value = true
                    }
                )
            })
        }
        Row(
            modifier = Modifier.fillMaxWidth(),
            horizontalArrangement = Arrangement.End
        ) {
            FloatingActionButton(
                shape = CircleShape,
                onClick = {
                    dialogFlashcard.value = null
                    openDialog.value = true
                },
                containerColor = MaterialTheme.colorScheme.primaryContainer
            ) {
                Icon(
                    Icons.Default.Add, null, tint = MaterialTheme.colorScheme.onPrimaryContainer
                )
            }
        }
    }
}

@Composable
fun FlashcardDialog(
    onDismiss: () -> Unit,
    onEvent: (FlashcardEvent) -> Unit,
    flashcard: FlashcardEntity?
) {

    val definition = remember { mutableStateOf(flashcard?.definition ?: "") }
    val meaning = remember { mutableStateOf(flashcard?.meaning ?: "") }

    Dialog(
        onDismissRequest = onDismiss,
        properties = DialogProperties(
            dismissOnBackPress = true,
            dismissOnClickOutside = true
        )
    ) {
        Column(
            modifier = Modifier
                .clip(RoundedCornerShape(roundedCorner))
                .background(MaterialTheme.colorScheme.secondary.copy(transparentCoef))
                .padding(dialogPadding),
            horizontalAlignment = Alignment.CenterHorizontally,
            verticalArrangement = Arrangement.spacedBy(dialogSpacer)
        ) {
            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.SpaceBetween,
                verticalAlignment = Alignment.CenterVertically
            ) {
                Icon(
                    imageVector = Icons.Default.Delete,
                    contentDescription = null,
                    tint = MaterialTheme.colorScheme.secondaryContainer,
                    modifier = Modifier
                        .size(iconSize)
                        .clickable {
                            flashcard?.let {
                                onEvent(FlashcardEvent.DeleteFlashcard(it))
                                onDismiss()
                            }
                        }
                )
                Icon(
                    imageVector = Icons.Default.Cancel,
                    contentDescription = null,
                    tint = MaterialTheme.colorScheme.secondaryContainer,
                    modifier = Modifier
                        .size(iconSize)
                        .clickable {
                            onDismiss()
                        }
                )
            }
            TextField(
                modifier = Modifier
                    .fillMaxWidth()
                    .height(textFieldHeight),
                colors = TextFieldDefaults.colors(
                    unfocusedContainerColor = MaterialTheme.colorScheme.secondary.copy(
                        transparentCoef
                    ),
                    focusedContainerColor = MaterialTheme.colorScheme.secondary.copy(transparentCoef)
                ),
                value = definition.value,
                singleLine = true,
                onValueChange = { definition.value = it },
                label = {
                    Text(stringResource(id = R.string.definition))
                }
            )
            TextField(
                modifier = Modifier
                    .fillMaxWidth()
                    .height(textFieldHeight),
                colors = TextFieldDefaults.colors(
                    unfocusedContainerColor = MaterialTheme.colorScheme.secondary.copy(
                        transparentCoef
                    ),
                    focusedContainerColor = MaterialTheme.colorScheme.secondary.copy(transparentCoef)
                ),
                value = meaning.value,
                singleLine = true,
                onValueChange = { meaning.value = it },
                label = {
                    Text(stringResource(id = R.string.meaning))
                }
            )
            OutlinedButton(
                modifier = Modifier
                    .fillMaxWidth(),
                onClick = {
                    if (definition.value.isNotEmpty() && meaning.value.isNotEmpty()) {
                        if (flashcard != null) {
                            onEvent(FlashcardEvent.EditFlashcard(definition.value, meaning.value))
                        } else {
                            onEvent(FlashcardEvent.AddFlashcard(definition.value, meaning.value))
                        }
                        onDismiss()
                    }
                }
            ) {
                Text(
                    text = stringResource(id = R.string.save),
                    style = MaterialTheme.typography.displayMedium
                )
            }

        }
    }
}

@Composable
fun Flashcard(
    flashcard: FlashcardEntity,
    onClick: () -> Unit
) {
    Row(
        modifier = Modifier
            .fillMaxWidth()
            .height(cardHeight)
            .clip(RoundedCornerShape(roundedCorner))
            .background(MaterialTheme.colorScheme.surface)
            .clickable {
                onClick()
            }
            .padding(
                start = cardPadding,
                end = cardPadding
            ),
        horizontalArrangement = Arrangement.SpaceBetween,
        verticalAlignment = Alignment.CenterVertically
    ) {
        Text(
            text = stringResource(
                id = R.string.definition_meaning,
                flashcard.definition,
                flashcard.meaning
            ),
            style = MaterialTheme.typography.displayMedium
        )
    }
}

sealed class FlashcardEvent {
    data class LookAtFlashcard(val flashcard: FlashcardEntity) : FlashcardEvent()
    data class EditFlashcard(val definition: String, val meaning: String) : FlashcardEvent()
    data class AddFlashcard(val definition: String, val meaning: String) : FlashcardEvent()
    data class DeleteFlashcard(val flashcard: FlashcardEntity) : FlashcardEvent()
}

data class FlashcardState(
    val category: CategoryEntity,
    val flashcards: List<FlashcardEntity>,
    val currentFlashcard: FlashcardEntity? = null
)

@HiltViewModel
class FlashcardViewModel @Inject constructor(
    savedStateHandle: SavedStateHandle,
    private val getCategoryByIdUseCase: GetCategoryByIdUseCase,
    private val getFlashcardsByCategory: GetFlashcardsByCategory,
    private val addFlashcardUseCase: AddFlashcardUseCase,
    private val removeFlashcardUseCase: RemoveFlashcardUseCase
) : ViewModel() {

    var state by mutableStateOf(FlashcardState(CategoryEntity(), emptyList()))
        private set

    init {
        val categoryId = savedStateHandle.get<Int>(Screen.FlashcardScreen().categoryId)
        categoryId?.let {
            getFlashcards(it)
        }
    }

    private fun getFlashcards(categoryId: Int) {
        viewModelScope.launch {
            val categoryFlow =  getCategoryByIdUseCase(categoryId)
            val flashcardFlow = getFlashcardsByCategory(categoryId)

            categoryFlow.flowOn(Dispatchers.IO).combine(flashcardFlow) { category, flashcards ->
                state = state.copy(
                    category = category,
                    flashcards = flashcards
                )
            }.collect()
        }
    }

    fun onEvent(event: FlashcardEvent) {
        when (event) {
            is FlashcardEvent.AddFlashcard -> {
                viewModelScope.launch {
                    addFlashcardUseCase(
                        FlashcardEntity(
                            categoryId = state.category.id,
                            definition = event.definition,
                            meaning = event.meaning
                        )
                    )
                }
            }
            is FlashcardEvent.EditFlashcard -> {
                state.currentFlashcard?.let {
                    it.definition = event.definition
                    it.meaning = event.meaning
                    viewModelScope.launch {
                        addFlashcardUseCase(it)
                    }
                    state = state.copy(
                        currentFlashcard = null
                    )
                }
            }
            is FlashcardEvent.DeleteFlashcard -> {
                viewModelScope.launch(Dispatchers.IO) {
                    removeFlashcardUseCase(event.flashcard)
                }
            }
            is FlashcardEvent.LookAtFlashcard -> {
                state = state.copy(
                    currentFlashcard = event.flashcard
                )
            }
        }
    }
}

@Composable
fun FlashcardLearn(
    flashcard: FlashcardEntity
) {
    val isDefinition = remember { mutableStateOf(true) }

    Column(
        modifier = Modifier
            .fillMaxWidth()
            .height(flashcardLearnHeight)
            .clip(RoundedCornerShape(roundedCorner))
            .background(
                if (isDefinition.value) {
                    MaterialTheme.colorScheme.surface
                } else {
                    MaterialTheme.colorScheme.primary
                }
            )
            .clickable {
                isDefinition.value = !isDefinition.value
            }
            .padding(
                start = cardPadding,
                end = cardPadding
            ),
        horizontalAlignment = Alignment.CenterHorizontally,
        verticalArrangement = Arrangement.SpaceAround
    ) {
        Text(
            text =
            if (isDefinition.value) {
                stringResource(id = R.string.definition)
            } else {
                stringResource(id = R.string.meaning)
            },
            style = MaterialTheme.typography.displaySmall
        )
        Text(
            text =
            if (isDefinition.value) {
                flashcard.definition
            } else {
                flashcard.meaning
            },
            style = MaterialTheme.typography.displayMedium
        )
    }
}

@Composable
fun LearningScreen() {
    val viewModel = hiltViewModel<LearningViewModel>()
    FlashcardTheme {
        LearningScreenContent(
            state = viewModel.state,
            onEvent = viewModel::onEvent
        )
    }
}

@Composable
fun LearningScreenContent(
    state: LearningState,
    onEvent: (LearningEvent) -> Unit
) {
    Column(
        modifier = Modifier
            .background(MaterialTheme.colorScheme.background)
            .fillMaxSize()
            .padding(layoutPadding),
        horizontalAlignment = Alignment.CenterHorizontally,
        verticalArrangement = Arrangement.SpaceAround
    ) {
        Text(
            modifier = Modifier.fillMaxWidth(),
            text = state.category.name,
            style = MaterialTheme.typography.displayLarge,
            textAlign = TextAlign.Center
        )
        FlashcardLearn(state.currentFlashcard)
        Row(
            horizontalArrangement = Arrangement.spacedBy(buttonPadding)
        ) {
            OutlinedButton(
                onClick = { onEvent.invoke(LearningEvent.PreviousFlashcard) },
                border = BorderStroke(
                    width = 1.dp,
                    color = primaryColor
                )
            ) {
                Icon(Icons.Default.ArrowLeft, null, tint = primaryColor)
            }
            OutlinedButton(
                onClick = { onEvent.invoke(LearningEvent.NextFlashcard) },
                border = BorderStroke(
                    width = 1.dp,
                    color = primaryColor
                )
            ) {
                Icon(Icons.Default.ArrowRight, null, tint = primaryColor)
            }
        }
    }
}

sealed class LearningEvent {
    object NextFlashcard : LearningEvent()
    object PreviousFlashcard : LearningEvent()
}

data class LearningState(
    val category: CategoryEntity = CategoryEntity(),
    val currentFlashcard: FlashcardEntity = FlashcardEntity()
)

@HiltViewModel
class LearningViewModel @Inject constructor(
    savedStateHandle: SavedStateHandle,
    private val getCategoryByIdUseCase: GetCategoryByIdUseCase,
    private val getFlashcardsByCategory: GetFlashcardsByCategory
) : ViewModel() {

    private var flashcards = listOf<FlashcardEntity>()
    private var iterator = flashcards.listIterator()

    var state by mutableStateOf(LearningState())
        private set

    init {
        val categoryId = savedStateHandle.get<Int>(Screen.LearningScreen().categoryId)
        categoryId?.let {
            getFlashcards(it)
        }
    }

    private fun getFlashcards(categoryId: Int) {
        viewModelScope.launch {
            val categoryFlow = getCategoryByIdUseCase(categoryId)
            val flashcardFlow = getFlashcardsByCategory(categoryId)

            categoryFlow.flowOn(Dispatchers.IO).combine(flashcardFlow) { category, list ->
                flashcards = list
                iterator = flashcards.listIterator()
                state = state.copy(
                    category = category,
                    currentFlashcard = iterator.next()
                )
            }.collect()
        }
    }

    fun onEvent(event: LearningEvent) {
        when(event) {
            is LearningEvent.NextFlashcard -> {
                if (iterator.hasNext()) {
                    state = state.copy(
                        currentFlashcard = iterator.next()
                    )
                }
            }
            is LearningEvent.PreviousFlashcard -> {
                if (iterator.hasPrevious()) {
                    state = state.copy(
                        currentFlashcard = iterator.previous()
                    )
                }
            }
        }
    }
}

@OptIn(ExperimentalFoundationApi::class)
@Composable
fun Category(
    category: CategoryEntity,
    onClick: () -> Unit,
    onLongClick: () -> Unit
) {
    Row(
        modifier = Modifier
            .fillMaxWidth()
            .height(cardHeight)
            .clip(RoundedCornerShape(roundedCorner))
            .background(MaterialTheme.colorScheme.surface)
            .combinedClickable(
                onClick = onClick,
                onLongClick = onLongClick
            )
            .padding(
                start = cardPadding,
                end = cardPadding
            ),
        horizontalArrangement = Arrangement.Start,
        verticalAlignment = Alignment.CenterVertically
    ) {
        Text(
            text = category.name,
            style = MaterialTheme.typography.displayMedium
        )
    }
}

@Composable
fun CategoryDialog(
    onDismiss: () -> Unit,
    onEvent: (MainEvent) -> Unit,
    category: CategoryEntity?
) {
    val categoryName = remember { mutableStateOf(category?.name ?: "") }

    Dialog(
        onDismissRequest = onDismiss,
        properties = DialogProperties(
            dismissOnBackPress = true,
            dismissOnClickOutside = true
        )
    ) {
        Column(
            modifier = Modifier
                .clip(RoundedCornerShape(roundedCorner))
                .background(MaterialTheme.colorScheme.secondary.copy(transparentCoef))
                .padding(dialogPadding),
            horizontalAlignment = Alignment.CenterHorizontally,
            verticalArrangement = Arrangement.spacedBy(dialogSpacer)
        ) {
            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.SpaceBetween,
                verticalAlignment = Alignment.CenterVertically
            ) {
                Icon(
                    imageVector = Icons.Default.Delete,
                    contentDescription = null,
                    tint = MaterialTheme.colorScheme.secondaryContainer,
                    modifier = Modifier
                        .size(iconSize)
                        .clickable {
                            category?.let {
                                onEvent(MainEvent.DeleteCategory(it))
                                onDismiss()
                            }
                        }
                )
                Icon(
                    imageVector = Icons.Default.Cancel,
                    contentDescription = null,
                    tint = MaterialTheme.colorScheme.secondaryContainer,
                    modifier = Modifier
                        .size(iconSize)
                        .clickable {
                            onDismiss()
                        }
                )
            }
            TextField(
                modifier = Modifier
                    .fillMaxWidth()
                    .height(textFieldHeight),
                colors = TextFieldDefaults.colors(
                    unfocusedContainerColor = MaterialTheme.colorScheme.secondary.copy(
                        transparentCoef),
                    focusedContainerColor = MaterialTheme.colorScheme.secondary.copy(transparentCoef)
                ),
                value = categoryName.value,
                singleLine = true,
                onValueChange = { categoryName.value = it },
                label = {
                    Text(text = stringResource(id = R.string.category_name))
                }
            )
            OutlinedButton(
                modifier = Modifier
                    .fillMaxWidth(),
                onClick = {
                    if (categoryName.value.isNotEmpty()) {
                        if (category != null) {
                            onEvent(MainEvent.EditCategory(categoryName.value))
                        } else {
                            onEvent(MainEvent.AddCategory(categoryName.value))
                        }
                        onDismiss()
                    }
                }
            ) {
                Text(
                    text = stringResource(id = R.string.save),
                    style = MaterialTheme.typography.displayMedium
                )
            }

        }
    }
}

@Composable
fun MainScreen(navController: NavController) {
    val viewModel = hiltViewModel<MainViewModel>()
    FlashcardTheme {
        MainScreenContent(
            state = viewModel.state,
            onEvent = viewModel::onEvent,
            onChooseCategory = { categoryId ->
                navController.navigate("${Screen.FlashcardScreen().route}/$categoryId")
            }
        )
    }
}

@Composable
fun MainScreenContent(
    state: MainState,
    onEvent: (MainEvent) -> Unit,
    onChooseCategory: (Int) -> Unit
) {
    val openDialog = remember { mutableStateOf(false) }
    val dialogCategory = remember { mutableStateOf<CategoryEntity?>(null) }

    if (openDialog.value) {
        CategoryDialog(
            onDismiss = {
                openDialog.value = false
            },
            onEvent = onEvent,
            dialogCategory.value
        )
    }

    Column(
        modifier = Modifier
            .background(MaterialTheme.colorScheme.background)
            .fillMaxSize()
            .padding(layoutPadding),
        horizontalAlignment = Alignment.CenterHorizontally,
        verticalArrangement = Arrangement.spacedBy(layoutSpacer)
    ) {
        Text(
            text = stringResource(id = R.string.categories),
            style = MaterialTheme.typography.displayLarge
        )
        LazyColumn(
            modifier = Modifier.weight(1f),
            verticalArrangement = Arrangement.spacedBy(itemSpacer)
        ) {
            items(items = state.categories, key = { it.id }, itemContent = { item ->
                Category(
                    category = item,
                    onClick = { onChooseCategory(item.id) },
                    onLongClick = {
                        onEvent(MainEvent.LookAtCategory(item))
                        dialogCategory.value = item
                        openDialog.value = true
                    }
                )
            })
        }
        Row(
            modifier = Modifier.fillMaxWidth(),
            horizontalArrangement = Arrangement.End
        ) {
            FloatingActionButton(
                shape = CircleShape,
                onClick = {
                    dialogCategory.value = null
                    openDialog.value = true
                },
                containerColor = MaterialTheme.colorScheme.primaryContainer
            ) {
                Icon(
                    imageVector = Icons.Default.Add,
                    contentDescription = null,
                    tint = MaterialTheme.colorScheme.onPrimaryContainer
                )
            }
        }
    }
}

sealed class MainEvent {
    data class LookAtCategory(val category: CategoryEntity) : MainEvent()
    data class EditCategory(val name: String) : MainEvent()
    data class AddCategory(val name: String) : MainEvent()
    data class DeleteCategory(val category: CategoryEntity) : MainEvent()
}

data class MainState(
    val categories: List<CategoryEntity>,
    val currentCategory: CategoryEntity? = null
)

@HiltViewModel
class MainViewModel @Inject constructor(
    private val getCategoriesUseCase: GetCategoriesUseCase,
    private val removeCategoryUseCase: RemoveCategoryUseCase,
    private val addCategoryUseCase: AddCategoryUseCase
) : ViewModel() {

    var state by mutableStateOf(MainState(categories = emptyList()))
        private set

    init {
        getCategories()
    }

    private fun getCategories() {
        viewModelScope.launch {
            getCategoriesUseCase().flowOn(Dispatchers.IO).collect { list ->
                state = state.copy(
                    categories = list
                )
            }
        }
    }

    fun onEvent(event: MainEvent) {
        when(event) {
            is MainEvent.AddCategory -> {
                viewModelScope.launch {
                    addCategoryUseCase(CategoryEntity(name = event.name))
                }
            }
            is MainEvent.EditCategory -> {
                state.currentCategory?.let {
                    it.name = event.name
                    viewModelScope.launch {
                        addCategoryUseCase(it)
                    }
                }
                state = state.copy(
                    currentCategory = null
                )
            }
            is MainEvent.DeleteCategory -> {
                viewModelScope.launch(Dispatchers.IO) {
                    removeCategoryUseCase(event.category)
                }
                state = state.copy(
                    currentCategory = null
                )
            }
            is MainEvent.LookAtCategory -> {
                state = state.copy(
                    currentCategory = event.category
                )
            }
        }
    }
}

@Composable
fun Navigation() {
    val navController = rememberNavController()

    NavHost(navController = navController, startDestination = Screen.MainScreen.route) {
        composable(route = Screen.MainScreen.route) {
            MainScreen(navController = navController)
        }
        composable(
            route = "${Screen.FlashcardScreen().route}/{${Screen.FlashcardScreen().categoryId}}",
            arguments = listOf(
                navArgument(Screen.FlashcardScreen().categoryId) {
                    type = NavType.IntType
                }
            )
        ) { entry ->
            val categoryId = entry.arguments?.getInt(Screen.FlashcardScreen().categoryId)
            categoryId?.let {
                FlashcardScreen(
                    navController = navController,
                    categoryId = it
                )
            }
        }
        composable(
            route = "${Screen.LearningScreen().route}/{${Screen.LearningScreen().categoryId}}",
            arguments = listOf(
                navArgument(Screen.LearningScreen().categoryId) {
                    type = NavType.IntType
                }
            )
        ) { entry ->
            val categoryId = entry.arguments?.getInt(Screen.FlashcardScreen().categoryId)
            categoryId?.let {
                LearningScreen()
            }
        }
    }
}

sealed class Screen(val route: String) {
    object MainScreen : Screen("main_screen")

    data class FlashcardScreen(
        val categoryId: String = "categoryId"
    ) : Screen("flashcard_screen")

    data class LearningScreen(
        val categoryId: String = "categoryId"
    ) : Screen("learning_screen")
}

interface Repository {
    fun getAllCategories(): Flow<List<CategoryEntity>>
    fun getCategoryById(id: Int): Flow<CategoryEntity>
    suspend fun removeCategory(categoryEntity: CategoryEntity)
    suspend fun addCategory(categoryEntity: CategoryEntity)

    fun getFlashcardsByCategory(categoryId: Int): Flow<List<FlashcardEntity>>
    suspend fun addFlashcard(flashcardEntity: FlashcardEntity)
    suspend fun removeFlashcard(flashcardEntity: FlashcardEntity)
}

data class FlashcardEntity(
    val id: Int = 0,
    val categoryId: Int = -1,
    var definition: String = "",
    var meaning: String = ""
)

data class CategoryEntity(
    val id: Int = 0,
    var name: String = ""
)

class AddCategoryUseCase @Inject constructor(
    private val repository: Repository
) {
    suspend operator fun invoke(category: CategoryEntity) = repository.addCategory(category)
}

class AddFlashcardUseCase @Inject constructor(
    private val repository: Repository
) {
    suspend operator fun invoke(flashcard: FlashcardEntity) = repository.addFlashcard(flashcard)
}

class GetCategoriesUseCase @Inject constructor(
    private val repository: Repository
) {
    operator fun invoke() = repository.getAllCategories()
}

class GetCategoryByIdUseCase @Inject constructor(
    private val repository: Repository
) {
    operator fun invoke(id: Int) = repository.getCategoryById(id)
}

class GetFlashcardsByCategory @Inject constructor(
    private val repository: Repository
) {
    operator fun invoke(categoryId: Int) = repository.getFlashcardsByCategory(categoryId)
}

class RemoveCategoryUseCase @Inject constructor(
    private val repository: Repository
) {
    suspend operator fun invoke(category: CategoryEntity) = repository.removeCategory(category)
}

class RemoveFlashcardUseCase @Inject constructor(
    private val repository: Repository
) {
    suspend operator fun invoke(flashcard: FlashcardEntity) = repository.removeFlashcard(flashcard)
}

@Dao
interface AppDao {

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun addCategory(category: CategoryDbModel)

    @Delete
    suspend fun removeCategory(category: CategoryDbModel)

    @Query("SELECT * FROM category")
    fun getAllCategories(): Flow<List<CategoryDbModel>>

    @Query("SELECT * FROM category WHERE id = :id")
    fun getCategoryById(id: Int): Flow<CategoryDbModel>

    @Query("SELECT * FROM flashcards WHERE categoryId = :categoryId")
    fun getFlashcardsByCategory(categoryId: Int): Flow<List<FlashcardDbModel>>

    @Query("DELETE FROM flashcards WHERE categoryId = :categoryId")
    fun removeFlashcardsByCategory(categoryId: Int)

    @Delete
    suspend fun removeFlashcard(flashcard: FlashcardDbModel)

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun addFlashcard(flashcard: FlashcardDbModel)
}

@Database(entities = [CategoryDbModel::class, FlashcardDbModel::class], version = 2, exportSchema = false)
abstract class AppDatabase : RoomDatabase() {
    abstract fun dao(): AppDao
}

@Entity(tableName = "category")
data class CategoryDbModel(
    @PrimaryKey(autoGenerate = true)
    val id: Int = 0,
    val name: String
)

@Entity(tableName = "flashcards")
data class FlashcardDbModel(
    @PrimaryKey(autoGenerate = true)
    val id: Int = 0,
    val categoryId: Int,
    val definition: String,
    val meaning: String
)

class AppMapper @Inject constructor() {

    fun mapCategoryDbModelToEntity(db: CategoryDbModel) = CategoryEntity(
        id = db.id,
        name = db.name
    )

    fun mapCategoryEntityToDbModel(entity: CategoryEntity) = CategoryDbModel(
        id = entity.id,
        name = entity.name
    )

    fun mapFlashcardDbModelToEntity(db: FlashcardDbModel) = FlashcardEntity(
        id = db.id,
        categoryId = db.categoryId,
        definition = db.definition,
        meaning = db.meaning
    )

    fun mapFlashcardEntityToDbModel(entity: FlashcardEntity) = FlashcardDbModel(
        id = entity.id,
        categoryId = entity.categoryId,
        definition = entity.definition,
        meaning = entity.meaning
    )

    fun mapListCategoryDbModelToEntity(db: List<CategoryDbModel>) = db.map {
        mapCategoryDbModelToEntity(it)
    }

    fun mapListFlashcardDbModelToEntity(db: List<FlashcardDbModel>) = db.map {
        mapFlashcardDbModelToEntity(it)
    }
}

class RepositoryImpl @Inject constructor(
    private val database: AppDatabase,
    private val mapper: AppMapper
) : Repository {

    override fun getAllCategories(): Flow<List<CategoryEntity>> {
        return database.dao().getAllCategories()
            .map { return@map mapper.mapListCategoryDbModelToEntity(it) }
    }

    override fun getCategoryById(id: Int): Flow<CategoryEntity> {
        return database.dao().getCategoryById(id)
            .map { return@map mapper.mapCategoryDbModelToEntity(it) }
    }

    override suspend fun removeCategory(categoryEntity: CategoryEntity) {
        val dbCategory = mapper.mapCategoryEntityToDbModel(categoryEntity)
        database.dao().removeCategory(dbCategory)
        database.dao().removeFlashcardsByCategory(dbCategory.id)
    }

    override suspend fun addCategory(categoryEntity: CategoryEntity) {
        val dbCategory = mapper.mapCategoryEntityToDbModel(categoryEntity)
        database.dao().addCategory(dbCategory)
    }

    override fun getFlashcardsByCategory(categoryId: Int): Flow<List<FlashcardEntity>> {
        return database.dao().getFlashcardsByCategory(categoryId)
            .map { return@map mapper.mapListFlashcardDbModelToEntity(it) }
    }

    override suspend fun addFlashcard(flashcardEntity: FlashcardEntity) {
        val dbFlashcard = mapper.mapFlashcardEntityToDbModel(flashcardEntity)
        database.dao().addFlashcard(dbFlashcard)
    }

    override suspend fun removeFlashcard(flashcardEntity: FlashcardEntity) {
        val dbFlashcard = mapper.mapFlashcardEntityToDbModel(flashcardEntity)
        database.dao().removeFlashcard(dbFlashcard)
    }
}

@Module
@InstallIn(SingletonComponent::class)
object AppModule {

    @Singleton
    @Provides
    fun provideDatabase(@ApplicationContext appContext: Context): AppDatabase {
        return Room
            .databaseBuilder(appContext, AppDatabase::class.java, "database-main")
            .build()
    }

    @Singleton
    @Provides
    fun provideRepository(
        database: AppDatabase,
        mapper: AppMapper
    ): Repository = RepositoryImpl(database, mapper)
}
"""
    }
    
    static func dependencies(_ mainData: MainData) -> ANDData {
        return ANDData(mainFragmentData: ANDMainFragment(imports: "", content: """
                Navigation()
"""), mainActivityData: ANDMainActivity(imports: "", extraFunc: "", content: ""), themesData: ANDThemesData(isDefault: true, content: ""), stringsData: ANDStringsData(additional: """
    <string name="categories">Categories</string>
    <string name="definition">Definition</string>
    <string name="meaning">Meaning</string>
    <string name="category_name">Category Name</string>
    <string name="save">Save</string>
    <string name="definition_meaning">%s / %s</string>
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
apply plugin: 'kotlin-parcelize'

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
    implementation Dependencies.room_ktx
    implementation Dependencies.room_runtime
    kapt Dependencies.room_compiler
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
