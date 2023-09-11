//
//  File.swift
//  
//
//  Created by admin on 01.08.2023.
//

import Foundation

struct VEQuizBooks: FileProviderProtocol {
    static var fileName = "\(NamesManager.shared.fileName).kt"
    
    static func fileContent(packageName: String, uiSettings: UISettings) -> String {
        return """
package \(packageName).presentation.fragments.main_fragment

import android.content.Context
import android.os.Build
import android.util.Log
import androidx.compose.animation.core.Animatable
import androidx.compose.animation.core.tween
import androidx.compose.foundation.background
import androidx.compose.foundation.isSystemInDarkTheme
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Add
import androidx.compose.material.icons.filled.Delete
import androidx.compose.material.icons.filled.Done
import androidx.compose.material.icons.filled.Refresh
import androidx.compose.material3.Card
import androidx.compose.material3.CardDefaults
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.FloatingActionButton
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.LinearProgressIndicator
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.OutlinedTextField
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.material3.Typography
import androidx.compose.material3.darkColorScheme
import androidx.compose.material3.dynamicDarkColorScheme
import androidx.compose.material3.dynamicLightColorScheme
import androidx.compose.material3.lightColorScheme
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.State
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.graphicsLayer
import androidx.compose.ui.graphics.toArgb
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.SpanStyle
import androidx.compose.ui.text.TextStyle
import androidx.compose.ui.text.buildAnnotatedString
import androidx.compose.ui.text.font.FontFamily
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.text.withStyle
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.hilt.navigation.compose.hiltViewModel
import androidx.lifecycle.SavedStateHandle
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import androidx.navigation.NavController
import androidx.navigation.NavGraphBuilder
import androidx.navigation.NavType
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import androidx.navigation.compose.rememberNavController
import androidx.navigation.navArgument
import androidx.room.ColumnInfo
import androidx.room.Dao
import androidx.room.Database
import androidx.room.Entity
import androidx.room.Insert
import androidx.room.OnConflictStrategy
import androidx.room.PrimaryKey
import androidx.room.Query
import androidx.room.Room
import androidx.room.RoomDatabase
import androidx.room.Update
import \(packageName).R
import dagger.Module
import dagger.Provides
import dagger.hilt.InstallIn
import dagger.hilt.android.lifecycle.HiltViewModel
import dagger.hilt.android.qualifiers.ApplicationContext
import dagger.hilt.components.SingletonComponent
import kotlinx.coroutines.CoroutineDispatcher
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import javax.inject.Inject
import javax.inject.Singleton

val textColorPrimary = Color(0xFF\(uiSettings.textColorPrimary ?? "FFFFFF"))
val textColorSecondary = Color(0xFF\(uiSettings.textColorSecondary ?? "FFFFFF"))
val backColorPrimary = Color(0xFF\(uiSettings.backColorPrimary ?? "FFFFFF"))
val buttonColorPrimary = Color(0xFF\(uiSettings.buttonColorPrimary ?? "FFFFFF"))

val Yellow = Color(0xFFFFEB3B)
val Green = Color(0xFF8BC34A)
val Orange = Color(0xFFFF9800)
val Colors = listOf(Yellow, Green, Orange)

@Composable
fun QuizBooksTheme(
    content: @Composable () -> Unit
) {
    MaterialTheme(
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
        letterSpacing = 0.5.sp
    )
)

class BooksRepositoryImpl(
    private val booksDao: BooksDao
): BooksRepository {

    //MARK: - BooksRepository implementation
    override suspend fun selectBooks(): List<Book> {
        return booksDao.selectAll().map { it.toBook() }
    }

    override suspend fun deleteBook(bookId: Int) {
        booksDao.deleteById(bookId = bookId)
    }

    override suspend fun updateBook(updatedBook: Book) {
        booksDao.update(entity = updatedBook.toEntity())
    }

    override suspend fun insertBook(newBook: Book) {
        booksDao.insert(entity = newBook.toEntity())
    }

    override suspend fun selectById(bookId: Int): Book {
        return booksDao.selectById(bookId).toBook()
    }
}

//MARK: - fun converters
fun BookEntity.toBook() = Book(
    bookId = bookId,
    title = title,
    author = author,
    notes = notes,
    color = color
)

fun Book.toEntity() = BookEntity(
    title = title,
    bookId = bookId,
    author = author,
    notes = notes,
    color = color
)

@Dao
interface BooksDao {

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insert(entity: BookEntity)

    @Update(onConflict = OnConflictStrategy.REPLACE)
    suspend fun update(entity: BookEntity)

    @Query("DELETE FROM ${TableNames.BOOKS_TABLE} WHERE book_id == :bookId")
    suspend fun deleteById(bookId: Int)

    @Query("SELECT * FROM ${TableNames.BOOKS_TABLE}")
    fun selectAll(): List<BookEntity>

    @Query("SELECT * FROM ${TableNames.BOOKS_TABLE} WHERE book_id == :bookId")
    fun selectById(bookId: Int): BookEntity

}

@Entity(tableName = TableNames.BOOKS_TABLE)
data class BookEntity(
    @PrimaryKey(autoGenerate = true)
    @ColumnInfo(name = "book_id") val bookId: Int = 0,
    @ColumnInfo(name = "title") val title: String,
    @ColumnInfo(name = "author") val author: String,
    @ColumnInfo(name = "notes") val notes: String,
    @ColumnInfo(name = "color") val color: Int
)

@Database(
    entities = [BookEntity::class],
    version = 1,
    exportSchema = false
)
abstract class AppDatabase: RoomDatabase() {
    abstract val booksDao: BooksDao
}

object TableNames {
    const val BOOKS_TABLE = "books"
}

@Module
@InstallIn(SingletonComponent::class)
class DataModule {

    @Provides
    @Singleton
    fun provideDatabase(
        @ApplicationContext context: Context
    ): AppDatabase {
        return Room.databaseBuilder(
            context = context,
            klass = AppDatabase::class.java,
            name = "database.db"
        ).build()
    }

    @Provides
    @Singleton
    fun provideBooksRepository(database: AppDatabase): BooksRepository {
        return BooksRepositoryImpl(
            booksDao = database.booksDao
        )
    }

    @Provides
    @Singleton
    fun provideCoroutineDispatcherIO(): CoroutineDispatcher = Dispatchers.IO

}

data class Book(
    val bookId: Int,
    val title: String,
    val author: String,
    val notes: String,
    val color: Int
)

interface BooksRepository {
    suspend fun selectBooks(): List<Book>
    suspend fun deleteBook(bookId: Int)
    suspend fun updateBook(updatedBook: Book)
    suspend fun insertBook(newBook: Book)
    suspend fun selectById(bookId: Int): Book
}

class CreateNewBookUseCase @Inject constructor(
    private val booksRepository: BooksRepository,
    private val dispatcher: CoroutineDispatcher
) {
    suspend operator fun invoke(book: Book) {
        withContext(dispatcher) { booksRepository.insertBook(book) }
    }
}

class DeleteBookByIdUseCase @Inject constructor(
    private val booksRepository: BooksRepository,
    private val dispatcher: CoroutineDispatcher
) {
    suspend operator fun invoke(bookId: Int) {
        withContext(dispatcher) {  booksRepository.deleteBook(bookId) }
    }
}

class FetchBookDetailsByIdUseCase @Inject constructor(
    private val booksRepository: BooksRepository,
    private val dispatcher: CoroutineDispatcher
) {
    suspend operator fun invoke(bookId: Int): Result<Book> =
        kotlin.runCatching { withContext(dispatcher) { booksRepository.selectById(bookId) } }
}

class UpdateBookUseCase @Inject constructor(
    private val booksRepository: BooksRepository,
    private val dispatcher: CoroutineDispatcher
) {
    suspend operator fun invoke(book: Book) {
        withContext(dispatcher) { booksRepository.updateBook(book) }
    }
}

class FetchAllBooksUseCase @Inject constructor(
    private val repository: BooksRepository,
    private val dispatcher: CoroutineDispatcher
) {
    suspend operator fun invoke(): Result<List<Book>> =
        withContext(dispatcher) { Result.success(repository.selectBooks()) }
}

fun NavGraphBuilder.splashScreen(navController: NavController) {
    composable(route = Routes.Splash) {
        SplashScreen(
            onNextDestination = {
                navController.navigate(Routes.BooksList) {
                    popUpTo(route = Routes.Splash) { inclusive = true }
                }
            }
        )
    }
}

fun NavGraphBuilder.booksList(navController: NavController) {
    composable(route = Routes.BooksList) {
        val viewModel = hiltViewModel<BooksViewModel>()
        LaunchedEffect(key1 = Unit) { viewModel.fetchBooks() }

        BooksListScreen(
            uiState = viewModel.state.value,
            onTryAgainPressed = { viewModel.fetchBooks() },
            onBookItemClick = { navController.navigate(Routes.CreateEditBooks + "/$it") },
            onAddClick = { navController.navigate(Routes.CreateEditBooks + "/0") }
        )
    }
}

fun NavGraphBuilder.createEditBook(navController: NavController) {
    composable(
        route = Routes.CreateEditBooks + "/{${Routes.Args.CREATE_EDIT_ARG}}",
        arguments = listOf(
            navArgument(Routes.Args.CREATE_EDIT_ARG) { NavType.IntType }
        )
    ) {
        val viewModel = hiltViewModel<EditBookViewModel>()

        CreateEditBookScreen(
            uiState = viewModel.state.value,
            validateState = viewModel.validateState.value,
            onDeleteBook = { bookId ->
                if(bookId != null) viewModel.deleteBookById(bookId)
                navController.popBackStack()
            },
            onCreateBook = { title, authorName, notes, color ->
                viewModel.createBook(title, authorName, notes, color)
                if(viewModel.validateState.value is ValidateState.Correct)
                    navController.popBackStack()
            },
            onUpdateBook = { title, authorName, notes, color ->
                viewModel.updateBook(title, authorName, notes, color)
                if(viewModel.validateState.value is ValidateState.Correct)
                    navController.popBackStack()
            },
        )
    }
}

@Composable
fun Router() {
    QuizBooksTheme {
        Surface(
            modifier = Modifier.fillMaxSize(),
            color = backColorPrimary
        ) {
            val navController = rememberNavController()

            NavHost(
                navController = navController,
                startDestination = Routes.Splash
            ) {
                splashScreen(navController)
                booksList(navController)
                createEditBook(navController)
            }
        }
    }
}

object Routes {
    const val Splash = "splash"
    const val BooksList = "books_list"
    const val CreateEditBooks = "create_edit_books"

    object Args {
        const val CREATE_EDIT_ARG = "create_edit_arg"
    }
}

@HiltViewModel
class BooksViewModel @Inject constructor(
    private val fetchAllBooksUseCase: FetchAllBooksUseCase
): ViewModel() {
    private val tag = this::class.java.simpleName

    private val _state = mutableStateOf<UiBooksState>(UiBooksState.Loading)
    val state: State<UiBooksState> = _state

    fun fetchBooks() {
        viewModelScope.launch {
            fetchAllBooksUseCase()
                .onFailure {
                    Log.e(tag, "fetchBooks: ", it)
                    _state.value = UiBooksState.Error(throwable = it)
                }
                .onSuccess {
                    if(it.isNotEmpty())
                        _state.value = UiBooksState.Success(it)
                    else
                        _state.value = UiBooksState.EmptyList
                }
        }
    }
}

sealed class UiBooksState {
    object Loading: UiBooksState()
    object EmptyList: UiBooksState()
    class Error(val throwable: Throwable): UiBooksState()
    class Success(val books: List<Book>): UiBooksState()
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun BookItem(
    book: Book,
    onBookItemClick: (bookId: Int) -> Unit
) {
    Card(
        modifier = Modifier.fillMaxWidth(),
        onClick = { onBookItemClick(book.bookId) },
        colors = CardDefaults.cardColors(
            containerColor = Color(book.color)
        ),
        elevation = CardDefaults.cardElevation(defaultElevation = 10.dp)
    ) {
        Column(
            modifier = Modifier
                .fillMaxWidth()
                .padding(20.dp),
            horizontalAlignment = Alignment.CenterHorizontally
        ) {
            Text(
                text = book.title,
                style = MaterialTheme.typography.titleLarge,
                color = textColorPrimary,
                textAlign = TextAlign.Center
            )
            Text(
                text = book.author,
                style = MaterialTheme.typography.titleMedium,
                color = textColorSecondary,
                textAlign = TextAlign.Center
            )
        }
    }
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun BooksListScreen(
    uiState: UiBooksState,
    onTryAgainPressed: () -> Unit,
    onBookItemClick: (bookId: Int) -> Unit,
    onAddClick: () -> Unit
) {

    Scaffold(
        modifier = Modifier.fillMaxSize(),
        floatingActionButton = {
            FloatingActionButton(
                onClick = onAddClick,
                containerColor = buttonColorPrimary
            ) {
                Icon(
                    imageVector = Icons.Default.Add,
                    contentDescription = null,
                    tint = textColorPrimary
                )
            }
        }
    ) { paddings ->
        Box(modifier = Modifier.fillMaxSize().background(backColorPrimary)) {
            when(uiState) {
                is UiBooksState.Loading -> LinearProgressIndicator(
                    modifier = Modifier.align(Alignment.Center)
                )
                is UiBooksState.Error -> ShowTryAgain(
                    modifier = Modifier.align(Alignment.Center),
                    paddingsValues = paddings,
                    onTryAgainPressed = onTryAgainPressed
                )
                is UiBooksState.Success -> {
                    BooksList(
                        items = uiState.books,
                        paddingsValues = paddings,
                        onBookItemClick = onBookItemClick
                    )
                }
                is UiBooksState.EmptyList -> ShowEmptyMessage(
                    modifier = Modifier.align(Alignment.Center)
                )
            }
        }
    }
}

@Composable
private fun BooksList(
    items: List<Book>,
    paddingsValues: PaddingValues,
    onBookItemClick: (bookId: Int) -> Unit
) {
    LazyColumn(
        modifier = Modifier
            .fillMaxSize()
            .padding(
                top = paddingsValues.calculateTopPadding() + 5.dp,
                bottom = 10.dp,
                start = 5.dp,
                end = 5.dp
            ),
        verticalArrangement = Arrangement.spacedBy(10.dp)
    ) {
        items(items) {
            BookItem(
                book = it,
                onBookItemClick = onBookItemClick
            )
        }
    }
}

@Composable
private fun ShowTryAgain(
    onTryAgainPressed: () -> Unit,
    modifier: Modifier = Modifier,
    paddingsValues: PaddingValues
) {
    Column(
        modifier = modifier
            .fillMaxWidth()
            .padding(top = paddingsValues.calculateTopPadding()),
        horizontalAlignment = Alignment.CenterHorizontally,
        verticalArrangement = Arrangement.Center
    ) {
        Text(
            text = stringResource(id = R.string.unexpected_error),
            style = MaterialTheme.typography.titleLarge,
            color = textColorPrimary
        )
        IconButton(onClick = onTryAgainPressed) {
            Icon(
                modifier = Modifier.size(60.dp),
                imageVector = Icons.Default.Refresh,
                contentDescription = null,
                tint = textColorPrimary
            )
        }
    }
}

@Composable
private fun ShowEmptyMessage(
    modifier: Modifier = Modifier
) {
    Text(
        modifier = modifier,
        text = stringResource(id = R.string.no_items),
        style = MaterialTheme.typography.titleLarge,
        color = textColorPrimary
    )
}

@HiltViewModel
class EditBookViewModel @Inject constructor(
    private val fetchBookDetailsByIdUseCase: FetchBookDetailsByIdUseCase,
    private val deleteBookByIdUseCase: DeleteBookByIdUseCase,
    private val createNewBookUseCase: CreateNewBookUseCase,
    private val updateBookUseCase: UpdateBookUseCase,
    savedStateHandle: SavedStateHandle,
): ViewModel() {

    private val _state = mutableStateOf<UiEditBookState>(UiEditBookState.Loading)
    val state: State<UiEditBookState> = _state

    private val _validateState = mutableStateOf<ValidateState>(ValidateState.Default)
    val validateState: State<ValidateState> = _validateState

    private val bookId = savedStateHandle.get<String>(Routes.Args.CREATE_EDIT_ARG)?.toInt() ?: 0

    init {
        if(bookId != 0)
            fetchBookDetails(bookId)
        else
            _state.value = UiEditBookState.NotExist
    }

    private fun validate(title: String, author: String): ValidateState {
        val res = if(title.isEmpty() && author.isEmpty())
            ValidateState.ErrorBoth
        else if(author.isEmpty())
            ValidateState.ErrorAuthor
        else if(title.isEmpty())
            ValidateState.ErrorTitle
        else
            ValidateState.Correct

        _validateState.value = res
        return res
    }

    //MARK: CRUD implementation
    fun createBook(title: String, author: String, notes: String, color: Int) {
        viewModelScope.launch {
            val validateRes = validate(title, author)
            Log.e("createBook", "validateRes: $validateRes")
            if(validateRes is ValidateState.Correct) {
                val book = Book(
                    bookId = 0,
                    title = title,
                    author = author,
                    notes = notes,
                    color = color
                )
                createNewBookUseCase(book)
            }
        }
    }

    fun updateBook(newTitle: String, newAuthor: String, newNotes: String, color: Int) {
        viewModelScope.launch {
            val validateRes = validate(newTitle, newAuthor)
            Log.e("updateBook", "validateRes: $validateRes")
            if(validateRes is ValidateState.Correct) {
                val updatedBook = Book(
                    bookId = bookId,
                    title = newTitle,
                    author = newAuthor,
                    notes = newNotes,
                    color = color
                )
                updateBookUseCase(updatedBook)
            }
        }
    }

    fun deleteBookById(bookId: Int) {
        viewModelScope.launch { deleteBookByIdUseCase(bookId = bookId) }
    }

    private fun fetchBookDetails(bookId: Int) {
        _state.value = UiEditBookState.Loading

        viewModelScope.launch {
            fetchBookDetailsByIdUseCase(bookId)
                .onSuccess { _state.value = UiEditBookState.Exist(it) }
                .onFailure { _state.value = UiEditBookState.NotExist }
        }
    }
}

sealed class UiEditBookState {
    object Loading: UiEditBookState()
    object NotExist: UiEditBookState()
    class Exist(val book: Book): UiEditBookState()
}

sealed class ValidateState {
    object ErrorTitle: ValidateState()
    object ErrorAuthor: ValidateState()
    object ErrorBoth: ValidateState()
    object Correct: ValidateState()
    object Default: ValidateState()
}

@Composable
fun CreateEditBookScreen(
    uiState: UiEditBookState,
    validateState: ValidateState,
    onDeleteBook: (bookId: Int?) -> Unit,
    onCreateBook: (title: String, author: String, notes: String, color: Int) -> Unit,
    onUpdateBook: (newTitle: String, newAuthor: String, newNotes: String, color: Int) -> Unit
) {
    val color by remember { mutableStateOf(Colors.random()) }
    var backgroundModifier by remember { mutableStateOf(backColorPrimary) }

    Box(
        modifier = Modifier
            .fillMaxSize()
            .background(backgroundModifier)
    ) {
        when(uiState) {
            is UiEditBookState.Loading -> LinearProgressIndicator(
                modifier = Modifier.align(Alignment.Center)
            )
            is UiEditBookState.NotExist -> CreateEditBookLayout(
                modifier = Modifier.align(Alignment.TopCenter),
                onDeleteBook = onDeleteBook,
                validateState = validateState,
                onCreateOrUpdateBook = { title, author, notes -> onCreateBook(title, author, notes, color.toArgb()) }
            )
            is UiEditBookState.Exist -> {
                CreateEditBookLayout(
                    modifier = Modifier.align(Alignment.TopCenter),
                    book = uiState.book,
                    onDeleteBook = onDeleteBook,
                    validateState = validateState,
                    onCreateOrUpdateBook = { title, author, notes -> onUpdateBook(title, author, notes, uiState.book.color) }
                )
                backgroundModifier = Color(uiState.book.color)
            }
        }
    }
}

@Composable
private fun CreateEditBookLayout(
    modifier: Modifier = Modifier,
    book: Book? = null,
    validateState: ValidateState,
    onDeleteBook: (bookId: Int?) -> Unit,
    onCreateOrUpdateBook: (title: String, authorName: String, notes: String) -> Unit
) {
    var title by remember { mutableStateOf(book?.title ?: "") }
    var author by remember { mutableStateOf(book?.author ?: "") }
    var notes by remember { mutableStateOf(book?.notes ?: "") }

    Column(
        modifier = modifier
            .fillMaxWidth()
            .padding(vertical = 5.dp, horizontal = 10.dp),
        horizontalAlignment = Alignment.CenterHorizontally,
        verticalArrangement = Arrangement.spacedBy(10.dp)
    ) {
        Column {
            Row(
                modifier = Modifier.padding(horizontal = 10.dp),
                verticalAlignment = Alignment.CenterVertically,
                horizontalArrangement = Arrangement.spacedBy(5.dp)
            ) {
                Column(
                    horizontalAlignment = Alignment.CenterHorizontally
                ) {
                    TitleField(
                        inputTitle = title,
                        onTitleChanged = { title = it },
                        incorrectField = validateState is ValidateState.ErrorTitle || validateState is ValidateState.ErrorBoth
                    )
                    AuthorsTextField(
                        inputAuthor = author,
                        onAuthorChanged = { author = it },
                        incorrectField = validateState is ValidateState.ErrorAuthor || validateState is ValidateState.ErrorBoth
                    )
                }
                RightSideButtons(
                    modifier = Modifier.padding(horizontal = 5.dp, vertical = 8.dp),
                    onDeleteBook = { onDeleteBook(book?.bookId) },
                    onEditBook = { onCreateOrUpdateBook(title, author, notes) }
                )
            }
            NoteField(
                inputNotes = notes,
                onNotesChanged = { notes = it }
            )
        }
    }
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
private fun TitleField(
    inputTitle: String?,
    incorrectField: Boolean,
    onTitleChanged: (newTitle: String) -> Unit
) {
    var title by remember { mutableStateOf(inputTitle) }

    OutlinedTextField(
        value = title ?: "",
        onValueChange = {
            title = it
            onTitleChanged(it)
        },
        label = {
            Text(
                text = stringResource(id = R.string.title),
                style = MaterialTheme.typography.titleMedium,
                color = textColorPrimary,
                textAlign = TextAlign.Center
            )
        },
        singleLine = true,
        textStyle = TextStyle(
            textAlign = TextAlign.Center
        ),
        isError = incorrectField
    )
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
private fun AuthorsTextField(
    modifier: Modifier = Modifier,
    incorrectField: Boolean,
    inputAuthor: String? = null,
    onAuthorChanged: (authorName: String) -> Unit
) {
    var author by remember { mutableStateOf(inputAuthor ?: "") }

    OutlinedTextField(
        modifier = modifier,
        value = author,
        onValueChange = {
            author = it
            onAuthorChanged(it)
        },
        label = {
            Text(
                text = stringResource(id = R.string.author),
                style = MaterialTheme.typography.titleMedium,
                color = textColorPrimary
            )
        },
        singleLine = true,
        textStyle = TextStyle(
            textAlign = TextAlign.Center
        ),
        isError = incorrectField
    )
}

@Composable
private fun RightSideButtons(
    modifier: Modifier = Modifier,
    onDeleteBook: () -> Unit,
    onEditBook: () -> Unit
) {
    Column(
        modifier = modifier,
        horizontalAlignment = Alignment.CenterHorizontally,
        verticalArrangement = Arrangement.SpaceBetween
    ) {
        FloatingActionButton(
            onClick = onDeleteBook,
            containerColor = buttonColorPrimary
        ) {
            Icon(
                imageVector = Icons.Default.Delete,
                contentDescription = null,
                tint = textColorPrimary
            )
        }
        Spacer(modifier = Modifier.height(10.dp))
        FloatingActionButton(
            onClick = onEditBook,
            containerColor = buttonColorPrimary
        ) {
            Icon(
                imageVector = Icons.Default.Done,
                contentDescription = null,
                tint = textColorPrimary
            )
        }
    }
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
private fun NoteField(
    modifier: Modifier = Modifier,
    inputNotes: String? = null,
    onNotesChanged: (notes: String) -> Unit
) {
    var note by remember { mutableStateOf(inputNotes ?: "") }

    OutlinedTextField(
        modifier = modifier
            .fillMaxWidth()
            .padding(horizontal = 20.dp, vertical = 10.dp)
            .verticalScroll(rememberScrollState()),
        value = note,
        onValueChange = {
            note = it
            onNotesChanged(it)
        },
        label = {
            Text(
                text = stringResource(id = R.string.note_label),
                style = MaterialTheme.typography.bodyMedium,
                color = textColorPrimary,
                textAlign = TextAlign.Center
            )
        }
    )

}

@Composable
fun SplashScreen(
    onNextDestination: () -> Unit
) {
    val rotation = remember { Animatable(initialValue = 0f) }
    LaunchedEffect(key1 = true) {
        rotation.animateTo(
            targetValue = 35f,
            animationSpec = tween(durationMillis = 3000)
        )
        onNextDestination()
    }

    Column(
        modifier = Modifier
            .fillMaxSize()
            .background(backColorPrimary),
        horizontalAlignment = Alignment.CenterHorizontally,
        verticalArrangement = Arrangement.Center
    ) {
        Icon(
            modifier = Modifier
                .size(200.dp)
                .graphicsLayer { rotationX = rotation.value },
            painter = painterResource(id = R.drawable.book_100),
            contentDescription = null,
            tint = textColorPrimary
        )
        Text(
            buildAnnotatedString {
                withStyle(style = SpanStyle(
                    color = textColorPrimary,
                    fontSize = 35.sp
                )
                ) {
                    append(stringResource(id = R.string.quiz))
                    append('\\n')
                }
                withStyle(style = SpanStyle(
                    color = textColorSecondary,
                    fontSize = 30.sp
                )
                ) {
                    append(stringResource(id = R.string.books))
                }
            },
            textAlign = TextAlign.Center
        )
    }
}
"""
    }
    
    static func dependencies(_ mainData: MainData) -> ANDData {
        return ANDData(mainFragmentData: ANDMainFragment(imports: "", content: """
Router()
"""), mainActivityData: ANDMainActivity(imports: "", extraFunc: "", content: ""), themesData: ANDThemesData(isDefault: true, content: ""), stringsData: ANDStringsData(additional: """
    <string name="quiz">Quiz</string>
    <string name="books">Books</string>
    <string name="last_page">last page</string>
    <string name="unexpected_error">Unexpected error</string>
    <string name="search">Search</string>
    <string name="no_items">No items</string>
    <string name="title">Title</string>
    <string name="author">Author</string>
    <string name="note_label">Type here your notes about book</string>
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
        dataBinding true
        viewBinding true
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
    implementation Dependencies.compose_system_ui_controller
    implementation Dependencies.compose_permissions
    implementation 'androidx.work:work-runtime-ktx:2.8.1'
    implementation 'androidx.navigation:navigation-fragment:2.6.0'
        implementation Dependencies.room_runtime
    kapt Dependencies.room_compiler
    implementation Dependencies.room_ktx
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

    const val oneSignal = "4.6.7"
    const val glide = "4.14.2"
    const val swipe = "0.19.0"
    const val glide_skydoves = "1.3.9"
    const val retrofit = "2.9.0"
    const val okhttp = "4.10.0"
    const val room = "2.5.0"
    const val coil = "2.2.2"
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
