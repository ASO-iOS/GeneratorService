//
//  File.swift
//  
//
//  Created by mnats on 13.11.2023.
//

import Foundation

struct KDExpenceTracker: FileProviderProtocol {
    static var fileName: String = "\(NamesManager.shared.fileName).kt"
    
    static func fileContent(packageName: String, uiSettings: UISettings) -> String {
        return """
package \(packageName).presentation.fragments.main_fragment

import android.content.Context
import android.util.Log
import androidx.annotation.StringRes
import androidx.compose.foundation.Canvas
import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.interaction.MutableInteractionSource
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.aspectRatio
import androidx.compose.foundation.layout.fillMaxHeight
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.text.BasicTextField
import androidx.compose.foundation.text.KeyboardOptions
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Add
import androidx.compose.material.icons.filled.ArrowBack
import androidx.compose.material.icons.filled.ArrowForward
import androidx.compose.material.icons.filled.Check
import androidx.compose.material.icons.filled.Delete
import androidx.compose.material.icons.filled.Edit
import androidx.compose.material.icons.filled.Settings
import androidx.compose.material.icons.rounded.CalendarMonth
import androidx.compose.material3.DatePicker
import androidx.compose.material3.DatePickerDefaults
import androidx.compose.material3.DateRangePicker
import androidx.compose.material3.DropdownMenuItem
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.ExposedDropdownMenuBox
import androidx.compose.material3.FloatingActionButton
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.LinearProgressIndicator
import androidx.compose.material3.LocalContentColor
import androidx.compose.material3.LocalTextStyle
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Scaffold
import androidx.compose.material3.SnackbarHost
import androidx.compose.material3.SnackbarHostState
import androidx.compose.material3.Text
import androidx.compose.material3.TextButton
import androidx.compose.material3.TextFieldDefaults
import androidx.compose.material3.rememberDatePickerState
import androidx.compose.material3.rememberDateRangePickerState
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.geometry.Offset
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.SolidColor
import androidx.compose.ui.graphics.StrokeCap
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.TextStyle
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.input.ImeAction
import androidx.compose.ui.text.input.KeyboardType
import androidx.compose.ui.text.input.VisualTransformation
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.text.style.TextOverflow
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.hilt.navigation.compose.hiltViewModel
import androidx.lifecycle.SavedStateHandle
import androidx.lifecycle.ViewModel
import androidx.lifecycle.compose.collectAsStateWithLifecycle
import androidx.lifecycle.viewModelScope
import androidx.navigation.NavController
import androidx.navigation.NavType
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import androidx.navigation.compose.rememberNavController
import androidx.navigation.navArgument
import androidx.room.ColumnInfo
import androidx.room.Dao
import androidx.room.Database
import androidx.room.Delete
import androidx.room.Embedded
import androidx.room.Entity
import androidx.room.PrimaryKey
import androidx.room.Query
import androidx.room.Relation
import androidx.room.Room
import androidx.room.RoomDatabase
import androidx.room.Transaction
import androidx.room.TypeConverter
import androidx.room.TypeConverters
import androidx.room.Upsert
import androidx.sqlite.db.SupportSQLiteDatabase
import com.google.accompanist.systemuicontroller.rememberSystemUiController
import com.google.gson.Gson
import com.google.gson.GsonBuilder
import dagger.Binds
import dagger.Module
import dagger.Provides
import dagger.hilt.InstallIn
import dagger.hilt.android.lifecycle.HiltViewModel
import dagger.hilt.android.qualifiers.ApplicationContext
import dagger.hilt.components.SingletonComponent
import kotlinx.coroutines.CoroutineDispatcher
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.channels.Channel
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.flow.first
import kotlinx.coroutines.flow.firstOrNull
import kotlinx.coroutines.flow.launchIn
import kotlinx.coroutines.flow.map
import kotlinx.coroutines.flow.onEach
import kotlinx.coroutines.flow.receiveAsFlow
import kotlinx.coroutines.flow.transform
import kotlinx.coroutines.launch
import okhttp3.OkHttpClient
import okhttp3.logging.HttpLoggingInterceptor
import okhttp3.logging.HttpLoggingInterceptor.Logger
import retrofit2.Retrofit
import retrofit2.converter.gson.GsonConverterFactory
import retrofit2.http.GET
import java.math.BigDecimal
import java.math.BigInteger
import java.util.Date
import javax.inject.Inject
import javax.inject.Singleton
import kotlin.random.Random

val backColorPrimary = Color(0xFF\(uiSettings.backColorPrimary ?? "FFFFFF"))
val primaryColor = Color(0xFF\(uiSettings.primaryColor ?? "FFFFFF"))
val textColorPrimary = Color(0xFF\(uiSettings.textColorPrimary ?? "FFFFFF"))
val buttonColorPrimary = Color(0xFF\(uiSettings.buttonColorPrimary ?? "FFFFFF"))

@Module
@InstallIn(SingletonComponent::class)
object RoomModule {
    private const val ROOM_DATABASE = "v3-room-database"


    @Volatile
    private var INSTANCE: AppDatabase? = null


    @Provides
    @Singleton
    fun provideDatabase(
        @ApplicationContext appContext: Context,
    ): AppDatabase {
        INSTANCE = Room.databaseBuilder(appContext, AppDatabase::class.java, ROOM_DATABASE)
            .addCallback(
                object : RoomDatabase.Callback() {

                    override fun onCreate(db: SupportSQLiteDatabase) {
                        super.onCreate(db)

                        val coroutineScope = CoroutineScope(Dispatchers.IO)
                        coroutineScope.launch {
                            constantsCategory.forEach { nameCategory ->
                                INSTANCE?.categoryDao()?.upsertCategory(Category(nameCategory))
                            }
                        }
                    }

                }
            )
            .build()
        return INSTANCE!!
    }

    val constantsCategory = listOf(
        "Meal", "Mode of life", "Entertainments", "Convenience"
    )


}




@Module
@InstallIn(SingletonComponent::class)
object NetworkModule {
    @Provides
    @Singleton
    fun provideInterceptor(): OkHttpClient {
        val httpLoggingInterceptor = HttpLoggingInterceptor(Logger.DEFAULT).also { interceptor ->
            interceptor.level = HttpLoggingInterceptor.Level.BODY
        }
        return OkHttpClient.Builder().addInterceptor(httpLoggingInterceptor).build()
    }

    @Provides
    @Singleton
    fun provideGson(): Gson = GsonBuilder().setLenient().create()

    @Provides
    @Singleton
    fun provideApi(okHttpClient: OkHttpClient, gson: Gson): API {
        return Retrofit.Builder()
            .baseUrl(BASE_URL)
            .addConverterFactory(GsonConverterFactory.create(gson))
            .client(okHttpClient)
            .build()
            .create(API::class.java)
    }
}




@Module
@InstallIn(SingletonComponent::class)
abstract class RepositoryModule {

    @Binds
    abstract fun provideApiRepository(apiRepositoryImpl: ApiRepositoryImpl): ApiRepository

    @Binds
    abstract fun provideRoomRepository(roomRepositoryImpl: RoomRepositoryImpl): RoomRepository

}



abstract class BaseViewModel<State, Effect>(initState: State) : ViewModel() {

    private val _viewState: MutableStateFlow<State> = MutableStateFlow(initState)
    val viewState = _viewState.asStateFlow()

    private val _effects: Channel<Effect> = Channel()
    val effects: Flow<Effect> = _effects.receiveAsFlow()

    protected val state: State
        get() = viewState.value

    protected fun updateState(changeState: State.() -> State) {
        _viewState.value = viewState.value.changeState()
    }

    fun sendEffect(effect: Effect) = viewModelScope.launch {
        _effects.send(effect)
    }


}



abstract class AsyncUseCase(
    private val dispatcher: CoroutineDispatcher = Dispatchers.IO
): UseCase


interface UseCase



const val APP_DEBUG = "AppDebug"

fun Any?.logDebug(prefix: String = "", postfix: String = "") {
    val debugMessage = "$prefix $this $postfix"
    if (this is Throwable?) {
        Log.e(APP_DEBUG, debugMessage)
    } else {
        Log.i(APP_DEBUG, debugMessage)
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




class RoomRepositoryImpl @Inject constructor(db: AppDatabase) : RoomRepository {

    private val expenseDao = db.expenseDao()
    private val mothPlanDao = db.mothPlanDao()
    private val categoryDao = db.categoryDao()
    override suspend fun deleteExpense(expense: Expense) {
        expenseDao.deleteExpense(expense)
    }

    override fun takeSpentInCategories(): Flow<List<SpentInCategory>> {
        return categoryDao.selectCategoriesWithExpenses().transform { categoryWithExpensesList ->
            emit(
                categoryWithExpensesList.mapToSpentInCategoryMoth(
                    monthPlanLambda = ::getMothPlan
                )
            )
        }
    }

    override fun takeSpentInCategoriesAndExpenses(): Flow<List<Pair<SpentInCategory, List<Expense>>>> {
        return categoryDao.selectCategoriesWithExpenses().map { categoryWithExpensesList ->
            categoryWithExpensesList.mapToSpentInCategoryAndExpenses(
                monthPlanLambda = ::getMothPlan
            )
        }
    }

    override fun takeCategories(): Flow<List<Category>> {
        return categoryDao.selectCategories()
    }

    override suspend fun updateCategory(categoryName: String, oldName: String, limit: BigDecimal) {
        return categoryDao.updateCategory(categoryName, oldName, limit)
    }

    override suspend fun addExpense(expense: Expense) {
        expenseDao.upsertExpense(expense)
    }

    override suspend fun addCategory(category: Category) {
        categoryDao.upsertCategory(category)
    }

    override suspend fun takeSpentInCategoriesYear(year: Int): List<SpentInCategory> {
        return categoryDao.selectCategoriesWithExpenses().first().mapToSpentInCategoryYear(year)
    }

    override suspend fun takeSpentInCategoriesRange(
        startDate: Date,
        endDate: Date
    ): List<SpentInCategory> {
        return categoryDao.selectCategoriesWithExpenses().first()
            .mapToSpentInCategoryRange(startDate, endDate)
    }

    override suspend fun deleteCategory(category: Category) {
        categoryDao.deleteCategory(category)
    }


    override suspend fun getMothPlan(nameCategory: String): MonthPlan {
        val date = Date()
        val moth = date.month.toLong()
        val year = date.year.toLong()
        return mothPlanDao.currentMothPlan(
            categoryName = nameCategory,
            moth = moth,
            year = year
        ) ?: MonthPlan(
            categoryName = nameCategory,
            month = moth,
            year = year,
            limit = BigDecimal.ZERO
        ).also { mothPlan ->
            mothPlanDao.upsertMothPlan(
                mothPlan
            )
        }
    }

    override suspend fun addMothPlan(monthPlan: MonthPlan) {
        mothPlanDao.upsertMothPlan(monthPlan)
    }

}





class ApiRepositoryImpl @Inject constructor(private val api: API): ApiRepository {



}



@Dao
interface MothPlanDao {

    @Upsert
    suspend fun upsertMothPlan(monthPlan: MonthPlan)


    @Query(
        "SELECT * FROM moth_plan " +
                "WHERE category_name = :categoryName AND month = :moth AND year = :year " +
        "LIMIT 1"
    )
    suspend fun currentMothPlan(categoryName: String, moth: Long, year: Long): MonthPlan?

}



@Dao
interface CategoryDao {

    @Upsert
    suspend fun upsertCategory(category: Category)

    @Transaction
    suspend fun updateCategory(categoryName: String, oldName: String, limit: BigDecimal) {
        val date = Date()
        deleteOnlyCategory(Category(oldName))
        upsertCategory(Category(categoryName))
        updateMothPlans(categoryName, oldName)
        upsertMothPlan(
            MonthPlan(
                categoryName = categoryName,
                month = date.month.toLong(),
                year = date.year.toLong(),
                limit = limit
            )
        )
        updateExpenses(categoryName, oldName)
    }

    @Transaction
    suspend fun deleteCategory(category: Category) {
        deleteOnlyCategory(category)
        deleteMothPlans(category.name)
        deleteExpenses(category.name)
    }

    @Upsert
    suspend fun upsertMothPlan(monthPlan: MonthPlan)

    @Delete
    suspend fun deleteOnlyCategory(category: Category)

    @Query("UPDATE moth_plan SET category_name = :categoryName WHERE category_name = :oldName")
    suspend fun updateMothPlans(categoryName: String, oldName: String)

    @Query("UPDATE expense SET category_name = :categoryName WHERE category_name = :oldName")
    suspend fun updateExpenses(categoryName: String, oldName: String)


    @Query("DELETE FROM moth_plan WHERE category_name = :categoryName")
    suspend fun deleteMothPlans(categoryName: String)

    @Query("DELETE FROM expense WHERE category_name = :categoryName")
    suspend fun deleteExpenses(categoryName: String)


    @Transaction
    @Query("SELECT * FROM category")
    fun selectCategoriesWithExpenses(): Flow<List<CategoryWithExpenses>>

    @Query("SELECT * FROM category")
    fun selectCategories(): Flow<List<Category>>

}



@Dao
interface ExpenseDao {

    @Upsert
    suspend fun upsertExpense(expense: Expense)

    @Delete
    suspend fun deleteExpense(expense: Expense)


}




class BigDecimalConverter {

    @TypeConverter
    fun fromBigDecimal(value: BigDecimal): String {
        return value.toString()
    }

    @TypeConverter
    fun toBigDecimal(value: String): BigDecimal {
        return value.toBigDecimal()
    }

}



class DateConverter {
    @TypeConverter
    fun fromLong(value: Date): Long {
        return value.time
    }

    @TypeConverter
    fun toDate(value: Long): Date {
        return Date(value)
    }

}




@Database(entities = [Expense::class, Category::class, MonthPlan::class], version = 1)
@TypeConverters(BigDecimalConverter::class, DateConverter::class)
abstract class AppDatabase : RoomDatabase() {

    abstract fun expenseDao(): ExpenseDao
    abstract fun categoryDao(): CategoryDao
    abstract fun mothPlanDao(): MothPlanDao
}



@Entity(tableName = "category")
data class Category(
    @ColumnInfo(name = "name")
    @PrimaryKey()
    val name: String,
)

fun emptyCategory() = Category("")






data class CategoryWithExpenses(
    @Embedded val category: Category,
    @Relation(
        parentColumn = "name",
        entity = Expense::class,
        entityColumn = "category_name"
    )
    val expenses: List<Expense>
)



@Entity(tableName = "expense")
data class Expense(
    @PrimaryKey(autoGenerate = true)
    @ColumnInfo(name = "id")
    val id: Long = 0,
    val title: String,
    val amount: BigDecimal,
    @ColumnInfo(name = "category_name")
    val categoryName: String,
    val date: Date
)



@Entity(
    tableName = "moth_plan",
    primaryKeys = ["month", "year", "category_name"]
)
data class MonthPlan(
    @ColumnInfo(name = "category_name")
    val categoryName: String,
    val month: Long,
    val year: Long,
    val limit: BigDecimal,
)



suspend fun List<CategoryWithExpenses>.mapToSpentInCategoryMoth(
    monthPlanLambda: suspend (categoryName: String) -> MonthPlan,
) = map { categoryWithExpenses ->

    with(categoryWithExpenses.category) {
        val mothPlan = monthPlanLambda(name)
        val spent = categoryWithExpenses.expenses.getMothSpent(mothPlan)
        SpentInCategory(
            name = name,
            spent = spent,
            limit = mothPlan.limit
        )
    }
}

suspend fun List<CategoryWithExpenses>.mapToSpentInCategoryAndExpenses(
    monthPlanLambda: suspend (categoryName: String) -> MonthPlan,
) =
    map { categoryWithExpenses ->
        with(categoryWithExpenses.category) {
            val mothPlan = monthPlanLambda(name)
            val spent = categoryWithExpenses.expenses.getMothSpent(mothPlan)
            val expenses = categoryWithExpenses.expenses.getMothExpenses(mothPlan)
            SpentInCategory(
                name = name,
                spent = spent,
                limit = mothPlan.limit
            ) to expenses
        }
    }

fun List<CategoryWithExpenses>.mapToSpentInCategoryYear(year: Int) =
    map { categoryWithExpenses ->
        with(categoryWithExpenses.category) {
            val spent =
                categoryWithExpenses.expenses.filter { it.date.year == year }.map { it.amount }
                    .reduceOrNull { current, next ->
                        current + next
                    } ?: BigDecimal.ZERO
            SpentInCategory(
                name = name,
                spent = spent,
                limit = BigDecimal.ZERO
            )
        }
    }

fun List<CategoryWithExpenses>.mapToSpentInCategoryRange(
    startDate: Date,
    endDate: Date
): List<SpentInCategory> = map { categoryWithExpenses ->
    with(categoryWithExpenses.category) {
        val spent =
            categoryWithExpenses.expenses.filter { expense ->
                val expenseDate = expense.date
                (expenseDate.year >= startDate.year && expenseDate.year <= endDate.year) &&
                (expenseDate.month >= startDate.month && expenseDate.month <= endDate.month) &&
                (expenseDate.day >= startDate.day && expenseDate.day <= endDate.day)
            }.map { it.amount }
                .reduceOrNull { current, next ->
                    current + next
                } ?: BigDecimal.ZERO
        SpentInCategory(
            name = name,
            spent = spent,
            limit = BigDecimal.ZERO
        )
    }
}


private fun List<Expense>.getMothSpent(monthPlan: MonthPlan): BigDecimal {
    return mapNotNull { expense ->
        if (expense.date.year.toLong() == monthPlan.year && expense.date.month.toLong() == monthPlan.month) {
            expense.amount
        } else null
    }.reduceOrNull { current, next ->
        current + next
    } ?: BigDecimal.ZERO
}

private fun List<Expense>.getMothExpenses(monthPlan: MonthPlan): List<Expense> {
    return filter { expense ->
        expense.date.year.toLong() == monthPlan.year && expense.date.month.toLong() == monthPlan.month
    }
}



interface API {



}



const val BASE_URL = ""



interface ApiRepository {
}



interface RoomRepository {

    suspend fun deleteExpense(expense: Expense)

    fun takeSpentInCategories(): Flow<List<SpentInCategory>>

    fun takeSpentInCategoriesAndExpenses(): Flow<List<Pair<SpentInCategory, List<Expense>>>>

    fun takeCategories(): Flow<List<Category>>

    suspend fun updateCategory(categoryName: String, oldName: String, limit: BigDecimal)

    suspend fun addExpense(expense: Expense)
    suspend fun addCategory(category: Category)
    suspend fun takeSpentInCategoriesYear(year: Int): List<SpentInCategory>
    suspend fun takeSpentInCategoriesRange(startDate: Date, endDate: Date): List<SpentInCategory>
    suspend fun deleteCategory(category: Category)
    suspend fun getMothPlan(nameCategory: String): MonthPlan
    suspend fun addMothPlan(monthPlan: MonthPlan)


}



data class SpentInCategory(
    val name: String,
    val spent: BigDecimal,
    val limit: BigDecimal,
)


sealed interface UIState{

    object Success: UIState
    object Error: UIState
    object Empty: UIState
    object Loading: UIState
    object None: UIState

}



@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun AppRangeDatePicker(
    onSelectedStartDate: (Date) -> Unit,
    onSelectedEndDate: (Date) -> Unit
) {
    val datePickerModifier = Modifier
        .height(400.dp)
        .fillMaxWidth()
        .background(color = primaryColor, shape = mediumShape)
    val datePickerState = rememberDateRangePickerState(
        initialSelectedStartDateMillis = Date().time,
        initialSelectedEndDateMillis = Date().time
    )
    MaterialTheme(colorScheme = MaterialTheme.colorScheme.copy(onSurfaceVariant = textColorPrimary)) {
        CompositionLocalProvider(
            LocalContentColor provides textColorPrimary,
            LocalTextStyle provides headline4.copy(color = textColorPrimary),
        ) {
            DateRangePicker(
                modifier = datePickerModifier,
                state = datePickerState,
                title = null,
                headline = null,
                showModeToggle = false,
                colors = appDatePickerColors()
            )
        }
    }
    LaunchedEffect(datePickerState.selectedEndDateMillis) {
        datePickerState.selectedEndDateMillis?.let {
            onSelectedEndDate(Date(it))
        }
    }
    LaunchedEffect(datePickerState.selectedStartDateMillis) {
        datePickerState.selectedStartDateMillis?.let {
            onSelectedStartDate(Date(it))
        }
    }
}



@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun AppDatePicker(
    onSelectedDate: (Date) -> Unit
) {
    val datePickerModifier = Modifier
        .height(400.dp)
        .fillMaxWidth()
        .background(color = primaryColor, shape = mediumShape)
    val datePickerState = rememberDatePickerState(
        initialSelectedDateMillis = Date().time
    )
    MaterialTheme(colorScheme = MaterialTheme.colorScheme.copy(onSurfaceVariant = textColorPrimary)) {
        CompositionLocalProvider(
            LocalContentColor provides textColorPrimary,
            LocalTextStyle provides headline4.copy(color = textColorPrimary),
        ) {
            DatePicker(
                modifier = datePickerModifier,
                state = datePickerState,
                title = null,
                headline = null,
                showModeToggle = false,
                colors = appDatePickerColors()
            )
        }
    }
    LaunchedEffect(datePickerState.selectedDateMillis) {
        datePickerState.selectedDateMillis?.let { millis ->
            onSelectedDate(
                Date(millis)
            )
        }
    }
}



@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun appDatePickerColors() = DatePickerDefaults.colors(
    containerColor = primaryColor,
    disabledSelectedDayContainerColor = primaryColor,
    dayInSelectionRangeContainerColor = buttonColorPrimary.copy(alpha = 0.6f),
    selectedYearContainerColor = buttonColorPrimary,
    selectedDayContainerColor = buttonColorPrimary,
    selectedYearContentColor = primaryColor,
    currentYearContentColor = textColorPrimary,
    todayDateBorderColor = backColorPrimary,//textColorPrimary
    yearContentColor = textColorPrimary,
    todayContentColor = textColorPrimary,
    selectedDayContentColor = primaryColor,
    disabledSelectedDayContentColor = textColorPrimary,
    dayContentColor = textColorPrimary,
    disabledDayContentColor = textColorPrimary,
    subheadContentColor = textColorPrimary,
    weekdayContentColor = textColorPrimary,
    headlineContentColor = textColorPrimary,
    titleContentColor = textColorPrimary,
    dayInSelectionRangeContentColor = textColorPrimary,
)



@Composable
fun TopBar(
    modifier: Modifier = Modifier,
    text: String,
    actionIcon: ImageVector,
    onActionClick: () -> Unit,
    navigationIcon: ImageVector? = null,
    onNavigationClick: () -> Unit = {},
) {
    Row(
        modifier = modifier,
        verticalAlignment = Alignment.CenterVertically,
        horizontalArrangement = Arrangement.SpaceBetween
    ) {
        Row(modifier = Modifier.fillMaxHeight(), verticalAlignment = Alignment.CenterVertically) {
            navigationIcon?.let {
                AppIcon(
                    onClick = { onNavigationClick() },
                    icon = navigationIcon,
                    iconModifier = Modifier.size(30.dp),
                    modifier = Modifier.padding(end = 10.dp),
                    tint = buttonColorPrimary
                )
            }
            Text(
                text = text,
                color = textColorPrimary,
                style = headline1,
                maxLines = 1,
                overflow = TextOverflow.Ellipsis
            )
        }

        AppIcon(
            onClick = { onActionClick() },
            icon = actionIcon,
            iconModifier = Modifier.size(30.dp),
            tint = textColorPrimary
        )
    }
}

@Composable
fun AppBar(
    text: String,
    actionIcon: ImageVector = Icons.Filled.Settings,
    onActionClick: () -> Unit,
    navigationIcon: ImageVector? = Icons.Filled.ArrowBack,
    onNavigationClick: () -> Unit = {},
) {
    val barHeight = 56.dp
    TopBar(
        modifier = Modifier
            .height(barHeight)
            .fillMaxWidth()
            .padding(horizontal = 16.dp),
        text,
        actionIcon,
        onActionClick,
        navigationIcon,
        onNavigationClick
    )
}

@Composable
fun AppIcon(
    modifier: Modifier = Modifier,
    iconModifier: Modifier = Modifier,
    onClick: () -> Unit,
    icon: ImageVector,
    tint: Color
) {
    IconButton(
        modifier = modifier,
        onClick = {
            onClick()
        },
    ) {
        Icon(
            modifier = iconModifier,
            imageVector = icon,
            contentDescription = null,
            tint = tint
        )
    }
}



@Composable
fun BudgetBanner(text: String, haveCurrency: Boolean = false, onClick: () -> Unit = {}) {
    Row(
        modifier = Modifier
            .padding(horizontal = 16.dp)
            .clickable {
                onClick()
            }
            .fillMaxWidth()
            .background(color = primaryColor, shape = mediumShape)
            .padding(10.dp)
        ,
        horizontalArrangement = Arrangement.Center,
    ) {
        Text(
            text = if (haveCurrency) " " + text + stringResource(R.string.currency) else text,
            color = textColorPrimary,
            style = largeHeadline
        )
    }
}





val headline1 = TextStyle(
    fontWeight = FontWeight.Bold,
    fontSize = 20.sp
)

val largeHeadline = TextStyle(
    fontWeight = FontWeight.Black,
    fontSize = 20.sp
)

val headline3 = TextStyle(
    fontWeight = FontWeight.Normal,
    fontSize = 20.sp
)

val headline4 = TextStyle(
    fontWeight = FontWeight.Bold,
    fontSize = 14.sp
)

val headline5 = TextStyle(

)

val headline6 = TextStyle(

)

val mediumShape = RoundedCornerShape(35.dp)

val smallShape = RoundedCornerShape(12.dp)



@Composable
fun AppNavigation() {
    val systemUiController = rememberSystemUiController()
    val navController = rememberNavController()

    NavHost(
        modifier = Modifier
            .fillMaxSize()
            .background(color = backColorPrimary),
        navController = navController,
        startDestination = Destinations.Home.route
    ) {
        composable(Destinations.Home.route) { HomeDest(navController) }
        composable(Destinations.Expense.route) { ExpenseDest(navController) }
        composable(Destinations.Calendar.route) { CalendarDest(navController) }
        composable(
            route = Destinations.Category.route navConnect routeArgument(Destinations.Category.NAME_ARGUMENT),
            arguments = listOf(
                navArgument(Destinations.Category.NAME_ARGUMENT) {
                    type = NavType.StringType
                }
            )
        ) {
            CategoryDest(navController = navController)
        }
        composable(Destinations.Categories.route) {
            CategoriesDest(navController = navController)
        }
    }

    SideEffect {
        systemUiController.setSystemBarsColor(
            color = primaryColor,
            darkIcons = false
        )
    }
}


sealed class Destinations(val route: String) {

    object Home : Destinations(Routes.HOME)
    object Expense : Destinations(Routes.EXPENSE)

    object Calendar : Destinations(Routes.CALENDAR)
    object Category : Destinations(Routes.CATEGORY){
        const val NAME_ARGUMENT = "name"
    }
    object Categories : Destinations(Routes.CATEGORIES) {




    }

}

infix fun String.navConnect(arg: String): String {
    return "$this?=$arg"
}

fun routeArgument(arg: String): String = "{$arg}"

object Routes {

    const val CATEGORIES: String = "categories"
    const val CATEGORY: String = "category"
    const val CALENDAR: String = "calendar"
    const val EXPENSE: String = "expense"
    const val HOME = "home"

}



@HiltViewModel
class HomeViewModel @Inject constructor(
    private val roomRepository: RoomRepository
) : BaseViewModel<HomeState, HomeEffect>(HomeState()) {

    init {
        collectSpentInCategories()
    }

    private fun collectSpentInCategories() =
        roomRepository.takeSpentInCategories().onEach { spentInCategories ->

            val budget = spentInCategories.map { it.limit }
                .reduceOrNull { acc, bigDecimal -> acc + bigDecimal } ?: BigDecimal.ONE
            val spent = spentInCategories.map { it.spent }
                .reduceOrNull { acc, bigDecimal -> acc + bigDecimal } ?: BigDecimal.ONE
            val remained =
                try {
                    (budget - spent) / budget
                } catch (ex: Exception) {
                    BigDecimal.ZERO
                }
            updateState {
                copy(
                    spentInCategoryList = spentInCategories,
                    budget = budget,
                    remainedFloat = remained.toFloat(),
                    percentageSlices = spentInCategories.map { spentInCategory ->
                        Pair(
                            spentInCategory.name,
                            spentInCategory.spent.toFloat() / spent.toFloat()
                        )
                    }
                )
            }
        }.launchIn(viewModelScope)


}



@Composable
fun CategoriesColumn(
    modifier: Modifier = Modifier,
    spentInCategoryList: List<SpentInCategory>
) = Column(
    modifier = modifier,
    horizontalAlignment = Alignment.CenterHorizontally,
    verticalArrangement = Arrangement.spacedBy(15.dp)
) {
    spentInCategoryList.forEach { spentInCategory ->
        CategoryBanner(
            spentInCategory = spentInCategory,
            modifier = Modifier
                .padding(horizontal = 25.dp)
                .fillMaxWidth()
        )
    }
}



@Composable
fun CategoryBanner(
    modifier: Modifier = Modifier,
    spentInCategory: SpentInCategory
) = Row(
    modifier = modifier,
    horizontalArrangement = Arrangement.SpaceBetween,
    verticalAlignment = Alignment.CenterVertically
) {
    Text(
        text = spentInCategory.name,
        color = textColorPrimary,
        style = headline3
    )
    val currency = stringResource(id = R.string.currency)
    spentInCategory.apply {
        val text = if (limit == BigDecimal.ZERO || limit.toBigInteger() == BigInteger.ONE) spent.toString() + currency else stringResource(
            R.string.spent_in_category,
            spent,
            currency,
            limit,
            currency
        )
        Text(
            text = text,
            color = textColorPrimary,
            style = headline3
        )
    }
}



@Composable
fun CategoryButton(
    modifier: Modifier = Modifier,
    onClick: () -> Unit
) {
    TextButton(
        modifier = modifier,
        onClick = onClick,
        shape = smallShape,
        contentPadding = PaddingValues(horizontal = 12.dp)
    ) {
        Text(
            text = stringResource(R.string.categories),
            color = textColorPrimary,
            style = headline4
        )
        Spacer(modifier = Modifier.width(10.dp))
        Icon(
            imageVector = Icons.Filled.ArrowForward,
            contentDescription = null,
            modifier = Modifier.padding(top = 4.dp).size(16.dp),
            tint = buttonColorPrimary
        )
    }
}



@Composable
fun HomeContent(
    modifier: Modifier = Modifier,
    viewModel: HomeViewModel,
    viewState: HomeState
) = Column(modifier = modifier, horizontalAlignment = Alignment.CenterHorizontally) {
    Spacer(modifier = Modifier.height(10.dp))
    BudgetBanner(text = viewState.budget.toString(), haveCurrency = true)
    LinearProgressIndicator(
        progress = viewState.remainedFloat,
        trackColor = primaryColor,
        color = buttonColorPrimary,
        modifier = Modifier
            .padding(horizontal = 30.dp)
            .padding(top = 10.dp, bottom = 25.dp)
            .fillMaxWidth()
            .height(30.dp)
            .clip(smallShape),
        strokeCap = StrokeCap.Square
    )

    SpentPieChart(
        percentageSlices = viewState.percentageSlices,
        modifier = Modifier
            .fillMaxWidth(0.8f)
            .aspectRatio(1f)
    )

    OptionsBar(
        modifier = Modifier
            .padding(horizontal = 25.dp)
            .fillMaxWidth(),
        onCalendarClick = {
            viewModel.sendEffect(HomeEffect.NavigateToCalendar)
        },
        onExpenseAddClick = {
            viewModel.sendEffect(HomeEffect.NavigateToExpense)
        }
    )
    CategoryButton(
        onClick = {
            viewModel.sendEffect(HomeEffect.NavigateToCategories)
        }
    )
    CategoriesColumn(
        modifier = Modifier
            .fillMaxSize()
            .padding(bottom = 30.dp),
        spentInCategoryList = viewState.spentInCategoryList
    )
}



@Composable
fun OptionsBar(
    modifier: Modifier = Modifier,
    onCalendarClick: () -> Unit,
    onExpenseAddClick: () -> Unit
) = Row(
    modifier,
    horizontalArrangement = Arrangement.SpaceBetween,
    verticalAlignment = Alignment.CenterVertically
) {
    AppIcon(
        iconModifier = Modifier.size(35.dp),
        onClick = onCalendarClick,
        icon = Icons.Rounded.CalendarMonth,
        tint = textColorPrimary
    )

    FloatingActionButton(
        modifier = Modifier.size(55.dp),
        onClick = onExpenseAddClick,
        shape = CircleShape,
        containerColor = primaryColor
    ) {
        Icon(
            imageVector = Icons.Filled.Add,
            modifier = Modifier.size(40.dp),
            contentDescription = null,
            tint = buttonColorPrimary
        )
    }
}



val colors = List(500) {
    generateRandomColor()
}

@Composable
fun SpentPieChart(
    modifier: Modifier = Modifier,
    percentageSlices: List<Pair<String, Float>>
) {
    val incomeData = percentageSlices.mapIndexed { index, slice ->
        PieChartData(
            slice.first,
            slice.second,
            colors.getOrNull(index) ?: generateRandomColor()
        )
    }
    val startAngles = calculateStartAngles(incomeData)

    Canvas(
        modifier = modifier
    ) {
        incomeData.forEachIndexed { index, pieChartData ->
            drawArc(
                color = pieChartData.color,
                startAngle = startAngles[index],
                sweepAngle = pieChartData.percentage * 360f,
                useCenter = true,
                topLeft = Offset(0f, 0f),
                size = size
            )
        }
    }
}

fun calculateStartAngles(entries: List<PieChartData>): List<Float> {
    var totalPercentage = 0f
    return entries.map { entry ->
        val startAngle = totalPercentage * 360
        totalPercentage += entry.percentage
        startAngle
    }
}


data class PieChartData(
    val label: String,
    val percentage: Float,
    val color: Color
)

fun generateRandomColor(): Color {
    val random = Random.Default
    val red = random.nextInt(0, 256)
    val green = random.nextInt(0, 256)
    val blue = random.nextInt(0, 256)
    return Color(red = red, green = green, blue = blue)
}



@Composable
fun HomeScreen(viewModel: HomeViewModel, viewState: HomeState) {
    Scaffold(
        containerColor = backColorPrimary,
        topBar = {
            AppBar(
                text = stringResource(R.string.expenses),
                onActionClick = {

                },
                navigationIcon = null
            )
        }
    ) { paddingValues ->
        HomeContent(
            modifier = Modifier
                .padding(paddingValues)
                .fillMaxSize()
                .verticalScroll(rememberScrollState()),
            viewModel = viewModel,
            viewState = viewState
        )
    }
}



data class HomeState(
    val spentInCategoryList: List<SpentInCategory> = emptyList(),
    val budget: BigDecimal = BigDecimal.ZERO,
    val remainedFloat: Float = 0f,
    val percentageSlices: List<Pair<String, Float>> = emptyList()
)


sealed interface HomeEffect {
    object NavigateToExpense : HomeEffect
    object NavigateToCalendar : HomeEffect
    object NavigateToCategories : HomeEffect


}



@Composable
fun HomeDest(navController: NavController) {
    val viewModel = hiltViewModel<HomeViewModel>()
    val viewState = viewModel.viewState.collectAsStateWithLifecycle().value
    HomeScreen(viewModel = viewModel, viewState = viewState)
    LaunchedEffect(key1 = Unit) {
        viewModel.effects.collect { effect ->
            when (effect) {
                HomeEffect.NavigateToExpense -> {
                    navController.navigate(Destinations.Expense.route)
                }

                HomeEffect.NavigateToCalendar -> {
                    navController.navigate(Destinations.Calendar.route)
                }
                HomeEffect.NavigateToCategories -> {
                    navController.navigate(Destinations.Categories.route)
                }
            }
        }
    }
}



@Composable
fun ExpenseScreen(
    viewModel: ExpenseViewModel,
    viewState: ExpenseState,
    navController: NavController
) {
    val snackbarHostState = remember { SnackbarHostState() }


    Scaffold(
        containerColor = backColorPrimary,
        topBar = {
            AppBar(
                text = stringResource(R.string.creating_an_expense),
                onActionClick = {
                    viewModel.addExpense()
                },
                onNavigationClick = {
                    viewModel.sendEffect(ExpenseEffect.NavigateBack)
                },
                actionIcon = Icons.Filled.Check
            )
        },
        snackbarHost = {
            AppSnackbar(state = snackbarHostState)
        }
    ) { paddingValues ->
        ExpenseContent(
            modifier = Modifier
                .padding(paddingValues)
                .fillMaxSize()
                .verticalScroll(rememberScrollState())
                .padding(vertical = 20.dp, horizontal = 16.dp),
            viewModel = viewModel,
            viewState = viewState
        )
    }
    val context = LocalContext.current
    LaunchedEffect(key1 = Unit) {
        viewModel.effects.collect { effect ->
            when (effect) {
                ExpenseEffect.NavigateBack -> {
                    navController.popBackStack()
                }

                is ExpenseEffect.ShowSnackbar -> {
                    snackbarHostState.showSnackbar(message = context.getString(effect.messageId))
                }

                ExpenseEffect.ExpenseAdded -> {
                    navController.popBackStack()
                }

                is ExpenseEffect.SelectedDate -> {
                    viewModel.selectDate(
                        effect.date
                    )
                }
            }
        }
    }
}

@Composable
fun AppSnackbar(
    state: SnackbarHostState,
) {
    SnackbarHost(
        hostState = state,
        modifier = Modifier
            .padding(vertical = 25.dp, horizontal = 10.dp)
            .background(color = primaryColor, shape = smallShape)

    ) { data ->
        Text(
            modifier = Modifier.padding(10.dp),
            text = data.visuals.message,
            color = textColorPrimary,
            maxLines = 2,
            overflow = TextOverflow.Ellipsis,
            style = headline3
        )
    }
}



@Composable
fun ExpenseContent(
    modifier: Modifier = Modifier,
    viewModel: ExpenseViewModel,
    viewState: ExpenseState
) = Column(
    modifier = modifier,
    horizontalAlignment = Alignment.CenterHorizontally,
    verticalArrangement = Arrangement.spacedBy(12.dp)
) {
    val textFieldModifier = remember {
        Modifier.fillMaxWidth()
    }
    AppTextField(
        modifier = textFieldModifier,
        value = viewState.title,
        onValueChanged = { newTitle ->
            viewModel.changeTitle(newTitle)
        },
        placeholder = stringResource(R.string.name)
    )
    val currency = stringResource(id = R.string.currency)
    AppTextField(
        modifier = textFieldModifier,
        value = viewState.amount,
        onValueChanged = { newTitle ->
            viewModel.changeAmount(newTitle, currency)
        },
        placeholder = stringResource(R.string.amount),
        keyboardOptions = KeyboardOptions(
            keyboardType = KeyboardType.Decimal,
            imeAction = ImeAction.Next
        )
    )
    val expandableCategory = viewState.expandableCategory
    ExposedCategories(
        expanded = expandableCategory.expanded,
        onExpandedChange = { expanded ->
            viewModel.changeExpanded(expanded)
        },
        menuItems = expandableCategory.items,
        onItemClick = { category ->
            viewModel.selectCategory(category)
        },
        onDismissRequest = {
            viewModel.dismissExpanded()
        },
        placeholder = stringResource(R.string.category),
        currentItem = expandableCategory.currentItem
    )
    AppDatePicker(
        onSelectedDate = { date ->
            viewModel.sendEffect(ExpenseEffect.SelectedDate(date))
        }
    )
}



@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun AppTextField(
    modifier: Modifier = Modifier,
    value: String,
    onValueChanged: (String) -> Unit,
    placeholder: String,
    keyboardOptions: KeyboardOptions = KeyboardOptions(
        imeAction = ImeAction.Next,
        keyboardType = KeyboardType.Text
    ),
    readOnly: Boolean = false
) {

    val interactionSource = remember { MutableInteractionSource() }

    BasicTextField(
        modifier = modifier,
        value = value,
        onValueChange = onValueChanged,
        textStyle = largeHeadline.copy(color = textColorPrimary, textAlign = TextAlign.Center),
        cursorBrush = SolidColor(textColorPrimary),
        singleLine = true,
        keyboardOptions = keyboardOptions,
        readOnly = readOnly,
    ) { innerTextField ->
        TextFieldDefaults.DecorationBox(
            value = value,
            innerTextField = innerTextField,
            enabled = true,
            singleLine = true,
            visualTransformation = VisualTransformation.None,
            interactionSource = interactionSource,
            contentPadding = PaddingValues(horizontal = 20.dp, vertical = 10.dp),
            placeholder = {
                Row(
                    modifier = Modifier.fillMaxWidth(),
                    horizontalArrangement = Arrangement.Center
                ) {
                    Text(
                        text = placeholder,
                        color = textColorPrimary,
                        style = headline4,
                        textAlign = TextAlign.Center
                    )
                }
            },
            colors = TextFieldDefaults.colors(
                unfocusedContainerColor = primaryColor,
                focusedContainerColor = primaryColor,
                unfocusedTextColor = textColorPrimary,
                focusedTextColor = textColorPrimary,
                unfocusedIndicatorColor = Color.Transparent,
                focusedIndicatorColor = Color.Transparent,
            ),
            shape = mediumShape
        )
    }
}





@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun ExposedCategories(
    modifier: Modifier = Modifier,
    expanded: Boolean,
    currentItem: Category,
    onExpandedChange: (Boolean) -> Unit,
    menuItems: List<Category>,
    onItemClick: (Category) -> Unit,
    onDismissRequest: () -> Unit,
    placeholder: String
) {
    ExposedDropdownMenuBox(
        expanded = expanded,
        onExpandedChange = onExpandedChange
    ) {
        AppTextField(
            modifier = modifier
                .fillMaxWidth(0.7f)
                .menuAnchor(),
            value = currentItem.name,
            onValueChanged = {},
            placeholder = placeholder,
            readOnly = true
        )
        ExposedDropdownMenu(
            modifier = Modifier.background(color = primaryColor),
            expanded = expanded,
            onDismissRequest = onDismissRequest
        ) {
            menuItems.forEach { category ->
                Spacer(
                    modifier = Modifier
                        .fillMaxWidth()
                        .height(1.dp)
                        .background(color = buttonColorPrimary)
                )
                DropdownMenuItem(
                    text = {
                        Box(
                            modifier = Modifier.fillMaxWidth(),
                            contentAlignment = Alignment.Center
                        ) {
                            Text(text = category.name, color = textColorPrimary, style = headline3)
                        }
                    },
                    onClick = {
                        onItemClick(category)
                    },
                    contentPadding = PaddingValues(vertical = 6.dp, horizontal = 10.dp)
                )
            }
            Spacer(
                modifier = Modifier
                    .fillMaxWidth()
                    .height(1.dp)
                    .background(color = buttonColorPrimary)
            )
        }
    }
}



@Composable
fun ExpenseDest(navController: NavController) {
    val viewModel = hiltViewModel<ExpenseViewModel>()
    val viewState = viewModel.viewState.collectAsStateWithLifecycle().value
    ExpenseScreen(viewModel = viewModel, viewState = viewState, navController = navController)

}



data class ExpenseState(
    val title: String = "",
    val amount: String = "",
    val expandableCategory: ExpandableData<Category> = ExpandableData(
        currentItem = emptyCategory(),
    ),
    val selectedDate: Date = Date()
)

data class ExpandableData<Item>(
    val currentItem: Item,
    val expanded: Boolean = false,
    val items: List<Item> = emptyList()
)



sealed interface ExpenseEffect {
    object NavigateBack : ExpenseEffect
    object ExpenseAdded : ExpenseEffect

    data class ShowSnackbar(@StringRes val messageId: Int) : ExpenseEffect
    data class SelectedDate(val date: Date) : ExpenseEffect
}



@HiltViewModel
class ExpenseViewModel @Inject constructor(
    private val roomRepository: RoomRepository
) :
    BaseViewModel<ExpenseState, ExpenseEffect>(ExpenseState()) {

    init {
        loadCategories()
    }

    fun changeTitle(newTitle: String) = viewModelScope.launch {
        updateState {
            copy(
                title = newTitle
            )
        }
    }

    fun changeAmount(newTitle: String, currency: String) = viewModelScope.launch {
        var symbolMemory = ' '
        updateState {
            copy(
                amount = newTitle.filter { char ->
                    if (char == '.' && symbolMemory != '.' && char != newTitle[0]) {
                        symbolMemory = char
                        true
                    } else char.digitToIntOrNull() is Number
                } + currency
            )
        }
    }

    private fun loadCategories() = roomRepository.takeCategories().onEach { categoryList ->
        updateState {
            val currentItem = expandableCategory.currentItem
            copy(
                expandableCategory = expandableCategory.copy(
                    items = categoryList,
                    currentItem = if (currentItem == emptyCategory() || categoryList.isEmpty()) currentItem else categoryList.first()
                )
            )
        }
    }.launchIn(viewModelScope)

    fun changeExpanded(expandedAlternative: Boolean) = viewModelScope.launch {
        updateState {
            copy(
                expandableCategory = expandableCategory.copy(
                    expanded = expandedAlternative
                )
            )
        }
    }

    fun dismissExpanded() = viewModelScope.launch {
        updateState {
            copy(
                expandableCategory = expandableCategory.copy(
                    expanded = false
                )
            )
        }
    }

    fun selectCategory(category: Category) = viewModelScope.launch {
        updateState {
            copy(
                expandableCategory = expandableCategory.copy(
                    currentItem = category,
                    expanded = false
                )
            )
        }
    }

    fun addExpense() = viewModelScope.launch {
        val amount = state.amount.filter { symbol ->
            (symbol != ' ' && symbol.digitToIntOrNull() is Number) || symbol == '.'
        }.toBigDecimalOrNull()

        if (amount != null) {
            if (amount >= BigDecimal(0)) {
                val title = state.title
                if (title.isNotEmpty()) {
                    val category = state.expandableCategory.currentItem
                    if (category != emptyCategory()) {
                        roomRepository.addExpense(
                            Expense(
                                title = title,
                                amount = amount,
                                categoryName = category.name,
                                date = state.selectedDate
                            )
                        )
                        sendEffect(ExpenseEffect.ExpenseAdded)
                    } else {
                        sendEffect(ExpenseEffect.ShowSnackbar(R.string.no_category_selected))
                    }
                } else {
                    sendEffect(ExpenseEffect.ShowSnackbar(R.string.title_is_empty))
                }
            } else sendEffect(ExpenseEffect.ShowSnackbar(R.string.invalid_numeric_format))
        } else sendEffect(ExpenseEffect.ShowSnackbar(R.string.invalid_numeric_format))
    }

    fun selectDate(date: Date) = viewModelScope.launch {
        updateState {
            copy(
                selectedDate = date
            )
        }
    }

}



@Composable
fun CalendarScreen(viewModel: CalendarViewModel, viewState: CalendarState) {
    Scaffold(
        containerColor = backColorPrimary,
        topBar = {
            val onClick = when(viewState.calendarView){
                CalendarView.Calendar -> {
                    { viewModel.sendEffect(CalendarEffect.NavigateBack) }
                }
                CalendarView.Statistic -> {
                    { viewModel.changeView() }
                }
            }
            AppBar(
                text = stringResource(R.string.calendar),
                onActionClick = {

                },
                onNavigationClick = {
                    onClick()
                }
            )
        }
    ) { paddingValues ->
        CalendarContent(
            modifier = Modifier
                .padding(paddingValues)
                .verticalScroll(rememberScrollState())
                .padding(vertical = 20.dp)
                .fillMaxSize(),
            viewModel = viewModel,
            viewState = viewState
        )
    }
}



@Composable
fun CalendarContent(
    modifier: Modifier = Modifier,
    viewModel: CalendarViewModel,
    viewState: CalendarState
) = Column(
    modifier = modifier,
    horizontalAlignment = Alignment.CenterHorizontally,
    verticalArrangement = Arrangement.spacedBy(14.dp)
) {
    when (viewState.calendarView) {
        CalendarView.Calendar -> {
            AppRangeDatePicker(
                onSelectedEndDate = { endDate ->
                    viewModel.selectEndDate(endDate)
                },
                onSelectedStartDate = { startDate ->
                    viewModel.selectStartDate(startDate)
                }
            )
            BudgetBanner(
                text = stringResource(R.string.select_year),
                haveCurrency = false,
                onClick = {
                    viewModel.sendEffect(CalendarEffect.ShowYear)
                }
            )
            BudgetBanner(
                text = stringResource(R.string.select_date),
                haveCurrency = false,
                onClick = {
                    viewModel.sendEffect(CalendarEffect.ShowSelectedDate)
                }
            )
        }

        CalendarView.Statistic -> {
            CategoriesColumn(
                modifier = Modifier
                    .fillMaxSize()
                    .padding(bottom = 30.dp),
                spentInCategoryList = viewState.spentInCategoryList
            )
        }
    }
}



@HiltViewModel
class CalendarViewModel @Inject constructor(
    private val roomRepository: RoomRepository
) :
    BaseViewModel<CalendarState, CalendarEffect>(CalendarState()) {
    fun selectEndDate(endDate: Date) = viewModelScope.launch {
        updateState {
            copy(
                endDate = endDate
            )
        }
    }

    fun selectStartDate(startDate: Date) = viewModelScope.launch {
        updateState {
            copy(
                startDate = startDate
            )
        }
    }

    fun showYear() = viewModelScope.launch {
        val result = roomRepository.takeSpentInCategoriesYear(Date().year)
        updateState {
            copy(
                spentInCategoryList = result,
                calendarView = CalendarView.Statistic
            )
        }
    }

    fun showDateRange() = viewModelScope.launch {
        val result = roomRepository.takeSpentInCategoriesRange(state.startDate, state.endDate)
        updateState {
            copy(
                spentInCategoryList = result,
                calendarView = CalendarView.Statistic
            )
        }
    }

    fun changeView() = viewModelScope.launch {
        updateState {
            copy(
                calendarView = CalendarView.Calendar
            )
        }
    }

}


sealed interface CalendarEffect {

    object NavigateBack: CalendarEffect
    object ShowYear : CalendarEffect
    object ShowSelectedDate : CalendarEffect

}



data class CalendarState(
    val calendarView: CalendarView = CalendarView.Calendar,
    val startDate: Date = Date(),
    val endDate: Date = Date(),
    val spentInCategoryList: List<SpentInCategory> = emptyList()
)


enum class CalendarView {
    Calendar, Statistic
}



@Composable
fun CalendarDest(navController: NavController) {
    val viewModel = hiltViewModel<CalendarViewModel>()
    val viewState = viewModel.viewState.collectAsStateWithLifecycle().value
    CalendarScreen(viewModel = viewModel, viewState = viewState)

    LaunchedEffect(key1 = Unit) {
        viewModel.effects.collect { effect ->
            when(effect){
                CalendarEffect.NavigateBack -> {
                    navController.popBackStack()
                }

                CalendarEffect.ShowSelectedDate -> {
                    viewModel.showDateRange()
                }
                CalendarEffect.ShowYear -> {
                    viewModel.showYear()
                }
            }
        }
    }
}



@HiltViewModel
class CategoryViewModel @Inject constructor(
    savedStateHandle: SavedStateHandle,
    private val roomRepository: RoomRepository
) :
    BaseViewModel<CategoryState, CategoryEffect>(CategoryState()) {
    fun changeNameField(newName: String) = viewModelScope.launch {
        updateState {
            copy(
                nameField = newName
            )
        }
    }

    fun changeAmountField(newAmount: String, currency: String) = viewModelScope.launch {
        var symbolMemory = ' '
        updateState {
            copy(
                limitField = newAmount.filter { char ->
                    if (char == '.' && symbolMemory != '.' && char != newAmount[0]) {
                        symbolMemory = char
                        true
                    } else char.digitToIntOrNull() is Number
                } + currency
            )
        }
    }

    init {
        savedStateHandle.initData()
    }


    private fun SavedStateHandle.initData() = viewModelScope.launch {
        get<String>(Destinations.Category.NAME_ARGUMENT)?.let { nameCategory ->
            val currentMonthPlan: MonthPlan = roomRepository.getMothPlan(nameCategory)
            updateState {
                copy(
                    selectedCategory = Category(nameCategory),
                    nameField = nameCategory,
                    limitField = currentMonthPlan.limit.toString()
                )
            }
        }
    }

    fun createCategory() = viewModelScope.launch {
        val oldName = state.selectedCategory.name
        val nameField = state.nameField.filter { s ->
            s != ' '
        }
        val limit = state.limitField.filter { symbol ->
            (symbol != ' ' && symbol.digitToIntOrNull() is Number) || symbol == '.'
        }.toBigDecimalOrNull() ?: BigDecimal.ONE
        if (oldName == "") {
            val categories = roomRepository.takeCategories().firstOrNull() ?: emptyList<Category>()
            categories.forEach {
                if (it.name == nameField) {
                    sendEffect(CategoryEffect.SnackbarMessage(R.string.name_already))
                    return@launch
                }
            }
            roomRepository.addCategory(Category(nameField))
            val date = Date()
            roomRepository.addMothPlan(
                MonthPlan(
                    categoryName = nameField,
                    month = date.month.toLong(),
                    year = date.year.toLong(),
                    limit = limit
                )
            )
            sendEffect(CategoryEffect.NavigateBack)
        } else {
            if (nameField.isNotEmpty()) {
                roomRepository.updateCategory(
                    categoryName = nameField,
                    oldName = oldName,
                    limit = limit
                )
                sendEffect(CategoryEffect.NavigateBack)
            }else sendEffect(CategoryEffect.SnackbarMessage(R.string.empty_name))
        }
    }

}



@Composable
fun CategoryContent(
    modifier: Modifier = Modifier,
    viewModel: CategoryViewModel,
    viewState: CategoryState
) = Column(
    modifier = modifier,
    horizontalAlignment = Alignment.CenterHorizontally,
    verticalArrangement = Arrangement.spacedBy(14.dp, Alignment.Top)
) {
    val textFieldModifier = remember {
        Modifier.fillMaxWidth()
    }
    AppTextField(
        modifier = textFieldModifier,
        value = viewState.nameField,
        onValueChanged = { newName ->
            viewModel.changeNameField(newName)
        },
        placeholder = stringResource(R.string.Category_name)
    )
    val currency = stringResource(id = R.string.currency)
    AppTextField(
        modifier = textFieldModifier,
        value = viewState.limitField,
        onValueChanged = { newLimit ->
            viewModel.changeAmountField(newLimit, currency)
        },
        placeholder = stringResource(R.string.limit),
        keyboardOptions = KeyboardOptions(
            keyboardType = KeyboardType.Decimal
        )
    )
}



data class CategoryState(
    val selectedCategory: Category = Category(""),
    val nameField: String = "",
    val limitField: String = ""
)


sealed interface CategoryEffect {
    class SnackbarMessage(val messageId: Int) : CategoryEffect

    object NavigateBack : CategoryEffect

}



@Composable
fun CategoryScreen(
    viewModel: CategoryViewModel,
    viewState: CategoryState,
    snackbarHostState: SnackbarHostState
) {
    Scaffold(
        containerColor = backColorPrimary,
        topBar = {
            val nameCategory = viewState.selectedCategory.name
            val appBarText = nameCategory.ifEmpty { stringResource(R.string.creating_category) }

            AppBar(
                text = appBarText,
                onActionClick = {
                    viewModel.createCategory()
                },
                onNavigationClick = {
                    viewModel.sendEffect(CategoryEffect.NavigateBack)
                },
                actionIcon = Icons.Filled.Check
            )
        },
        snackbarHost = {
            AppSnackbar(state = snackbarHostState)
        }
    ) { paddingValues ->
        CategoryContent(
            modifier = Modifier
                .padding(paddingValues)
                .fillMaxSize()
                .verticalScroll(rememberScrollState()),
            viewModel = viewModel,
            viewState = viewState
        )
    }
}



@Composable
fun CategoryDest(navController: NavController) {
    val viewModel = hiltViewModel<CategoryViewModel>()
    val viewState = viewModel.viewState.collectAsStateWithLifecycle().value
    val snackbarHostState = remember { SnackbarHostState() }
    CategoryScreen(viewModel = viewModel, viewState = viewState, snackbarHostState)

    val context = LocalContext.current
    LaunchedEffect(Unit) {
        viewModel.effects.collect { effect ->
            when (effect) {
                CategoryEffect.NavigateBack -> {
                    navController.popBackStack()
                }

                is CategoryEffect.SnackbarMessage -> {
                    snackbarHostState.showSnackbar(context.getString(effect.messageId))
                }
            }
        }
    }
}



@Composable
fun CategoriesDest(navController: NavController) {
    val viewModel = hiltViewModel<CategoriesViewModel>()
    val viewState = viewModel.viewState.collectAsStateWithLifecycle().value
    CategoriesScreen(viewModel = viewModel, viewState = viewState, navController = navController)
}




@Composable
fun CategoriesInfoColumn(
    modifier: Modifier = Modifier,
    spentInCategoryAndExpenses: List<Pair<SpentInCategory, List<Expense>>>,
    onDeleteCategory: (String) -> Unit,
    onUpdateCategory: (String) -> Unit,
    onDeleteExpense: (Expense) -> Unit
) = Column(
    modifier = modifier, horizontalAlignment = Alignment.CenterHorizontally,
) {
    spentInCategoryAndExpenses.forEach { pair ->
        CategoryOval(
            spentInCategory = pair.first,
            onDelete = { name ->
                onDeleteCategory(name)
            },
            onUpdate = { name ->
                onUpdateCategory(name)
            }
        )
        pair.second.forEach { expense ->
            CategoriesExpense(
                expense = expense,
                onDelete = { expense ->
                    onDeleteExpense(expense)
                }
            )
        }
        Spacer(modifier = Modifier.height(14.dp))
    }
}



@Composable
fun CategoryOval(
    spentInCategory: SpentInCategory,
    onDelete: (String) -> Unit,
    onUpdate: (String) -> Unit
) = Row(
    modifier = Modifier
        .fillMaxWidth()
        .background(color = primaryColor, shape = mediumShape)
        .padding(horizontal = 20.dp, vertical = 10.dp),
    verticalAlignment = Alignment.CenterVertically,
    horizontalArrangement = Arrangement.SpaceBetween
) {
    Column(modifier = Modifier.weight(2f)) {
        Text(
            text = spentInCategory.name,
            color = textColorPrimary,
            style = largeHeadline,
            maxLines = 1
        )
        Spacer(modifier = Modifier.height(3.dp))
        val currency = stringResource(id = R.string.currency)
        spentInCategory.apply {
            limit.logDebug("limit - ")
            val text =
                if (limit == BigDecimal.ZERO || limit.toBigInteger() == BigInteger.ONE) spent.toString() + currency else stringResource(
                    R.string.spent_in_category,
                    spent,
                    currency,
                    limit,
                    currency
                )
            Text(
                text = text,
                color = textColorPrimary,
                style = headline3
            )
        }
    }
    Row(modifier = Modifier.weight(1f), horizontalArrangement = Arrangement.spacedBy(2.dp)) {
        AppIcon(
            onClick = {
                onUpdate(spentInCategory.name)
            },
            icon = Icons.Filled.Edit,
            tint = textColorPrimary,
            iconModifier = Modifier.size(30.dp)
        )
        AppIcon(
            onClick = {
                onDelete(spentInCategory.name)
            },
            icon = Icons.Filled.Delete,
            tint = textColorPrimary,
            iconModifier = Modifier.size(30.dp)
        )
    }

}



@Composable
fun CategoriesContent(
    modifier: Modifier = Modifier,
    viewModel: CategoriesViewModel,
    viewState: CategoriesState
) = CategoriesInfoColumn(
    modifier = modifier,
    spentInCategoryAndExpenses = viewState.spentInCategoryAndExpenses,
    onDeleteCategory = { name ->
        viewModel.deleteCategory(name)
    },
    onDeleteExpense = { expense ->
        viewModel.deleteExpense(expense)
    },
    onUpdateCategory = { categoryName ->
        viewModel.sendEffect(CategoriesEffect.NavigateToCategory(categoryName))
    }
)



@Composable
fun CategoriesExpense(
    modifier: Modifier = Modifier,
    expense: Expense,
    onDelete: (Expense) -> Unit
) = Row(
    modifier = modifier
        .fillMaxWidth()
        .padding(horizontal = 20.dp),
    horizontalArrangement = Arrangement.SpaceBetween,
    verticalAlignment = Alignment.CenterVertically
) {
    Text(
        text = expense.title,
        maxLines = 2,
        color = textColorPrimary,
        style = headline4,
        overflow = TextOverflow.Ellipsis
    )
    Row(verticalAlignment = Alignment.CenterVertically) {
        Text(
            text = expense.amount.toString() + stringResource(id = R.string.currency),
            maxLines = 1,
            color = textColorPrimary,
            style = headline4
        )
        AppIcon(
            onClick = {
                onDelete(expense)
            },
            icon = Icons.Filled.Delete,
            tint = textColorPrimary,
            iconModifier = Modifier.size(20.dp)
        )
    }
}


sealed interface CategoriesEffect {
    object NavigateBack : CategoriesEffect
    class NavigateToCategory(val name: String) : CategoriesEffect

}



data class CategoriesState(
    val spentInCategoryAndExpenses: List<Pair<SpentInCategory, List<Expense>>> = emptyList()
)



@Composable
fun CategoriesScreen(
    viewModel: CategoriesViewModel,
    viewState: CategoriesState,
    navController: NavController
) {
    Scaffold(
        containerColor = backColorPrimary,
        topBar = {
            AppBar(
                text = stringResource(R.string.categories),
                onActionClick = {},
                onNavigationClick = {
                    viewModel.sendEffect(CategoriesEffect.NavigateBack)
                }
            )
        },
        floatingActionButton = {
            FloatingActionButton(
                onClick = {
                    viewModel.sendEffect(CategoriesEffect.NavigateToCategory(""))
                },
                containerColor = primaryColor
            ) {
                Icon(
                    modifier = Modifier.size(40.dp),
                    imageVector = Icons.Filled.Add,
                    contentDescription = null,
                    tint = buttonColorPrimary
                )
            }
        }
    ) { paddingValues ->
        CategoriesContent(
            modifier = Modifier
                .padding(paddingValues)
                .fillMaxSize()
                .verticalScroll(rememberScrollState())
                .padding(horizontal = 16.dp, vertical = 20.dp),
            viewModel = viewModel,
            viewState = viewState
        )
    }
    LaunchedEffect(Unit) {
        viewModel.effects.collect { effect ->
            when (effect) {
                CategoriesEffect.NavigateBack -> {
                    navController.popBackStack()
                }

                is CategoriesEffect.NavigateToCategory -> {
                    navController.navigate(
                        Destinations.Category.route navConnect effect.name
                    )
                }
            }
        }
    }
}



@HiltViewModel
class CategoriesViewModel @Inject constructor(
    private val roomRepository: RoomRepository,
) : BaseViewModel<CategoriesState, CategoriesEffect>(CategoriesState()) {


    init {
        collectSpentInCategories()
    }

    private fun collectSpentInCategories() =
        roomRepository.takeSpentInCategoriesAndExpenses().onEach { pair ->
            updateState {
                copy(
                    spentInCategoryAndExpenses = pair
                )
            }
        }.launchIn(viewModelScope)

    fun deleteExpense(expense: Expense) = viewModelScope.launch {
        roomRepository.deleteExpense(expense)
    }

    fun deleteCategory(name: String) = viewModelScope.launch {
        roomRepository.deleteCategory(Category(name))
    }

}


"""
    }
    
    static func dependencies(_ mainData: MainData) -> ANDData {
        return ANDData(
            mainFragmentData: .init(imports: """

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.ui.Modifier
import \(mainData.packageName).presentation.fragments.main_fragment.AppNavigation
import \(mainData.packageName).presentation.fragments.main_fragment.backColorPrimary
""", content: """
            Box(
                modifier = Modifier
                .fillMaxSize()
                .background(color = backColorPrimary)
            )
            AppNavigation()
"""),
            mainActivityData: .empty,
            themesData: .def,
            stringsData: .init(additional: """
    <string name="expenses">Expenses</string>
    <string name="currency">" $ "</string>
    <string name="categories">Categories</string>
    <string name="spent_in_category">%1$s%2$s/ %3$s%4$s</string>
    <string name="creating_an_expense">Creating an expense</string>
    <string name="amount">Amount</string>
    <string name="name">Name</string>
    <string name="category">Category</string>
    <string name="invalid_numeric_format">Invalid numeric format</string>
    <string name="title_is_empty">Title is empty</string>
    <string name="no_category_selected">No category selected</string>
    <string name="calendar">Calendar</string>
    <string name="select_date">Select date</string>
    <string name="select_year">This year</string>
    <string name="creating_category">Creating category</string>
    <string name="Category_name">Category name</string>
    <string name="limit">Limit</string>
    <string name="empty_name">Empty name</string>
    <string name="name_already">Such a name already exists</string>
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


    implementation("androidx.lifecycle:lifecycle-runtime-compose:2.7.0-alpha02")

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

//    implementation Dependencies.calendar
//    implementation Dependencies.calendar_date

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

object Versions {
    const val gradle = "8.0.0"
    const val compilesdk = 34
    const val minsdk = 24
    const val targetsdk = 34
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
    const val calend = "1.1.1"
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
