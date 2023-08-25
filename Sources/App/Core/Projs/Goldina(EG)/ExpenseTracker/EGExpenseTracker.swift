//
//  File.swift
//  
//
//  Created by admin on 09.08.2023.
//

import Foundation

struct EGExpenseTracker: FileProviderProtocol {
    static var fileName: String = "EGExpenseTracker.kt"
    
    static func fileContent(packageName: String, uiSettings: UISettings) -> String {
        return """
package \(packageName).presentation.fragments.main_fragment

import android.content.Context
import android.content.SharedPreferences
import android.graphics.Paint
import androidx.compose.animation.animateColorAsState
import androidx.compose.animation.core.Animatable
import androidx.compose.animation.core.animateDpAsState
import androidx.compose.animation.core.animateFloatAsState
import androidx.compose.animation.core.tween
import androidx.compose.foundation.BorderStroke
import androidx.compose.foundation.Canvas
import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.BoxWithConstraints
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.ExperimentalLayoutApi
import androidx.compose.foundation.layout.FlowRow
import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.lazy.itemsIndexed
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.text.ClickableText
import androidx.compose.foundation.text.KeyboardOptions
import androidx.compose.material.DismissDirection
import androidx.compose.material.DismissValue
import androidx.compose.material.ExperimentalMaterialApi
import androidx.compose.material.FloatingActionButton
import androidx.compose.material.FractionalThreshold
import androidx.compose.material.Icon
import androidx.compose.material.SwipeToDismiss
import androidx.compose.material.TextField
import androidx.compose.material.TextFieldDefaults
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Add
import androidx.compose.material.icons.filled.ArrowDropDown
import androidx.compose.material.icons.filled.Cancel
import androidx.compose.material.icons.filled.Delete
import androidx.compose.material.icons.filled.Payments
import androidx.compose.material.rememberDismissState
import androidx.compose.material3.Button
import androidx.compose.material3.ButtonDefaults
import androidx.compose.material3.Card
import androidx.compose.material3.CardDefaults
import androidx.compose.material3.DropdownMenu
import androidx.compose.material3.DropdownMenuItem
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.MenuDefaults
import androidx.compose.material3.MenuItemColors
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.material3.Typography
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.ReadOnlyComposable
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.scale
import androidx.compose.ui.geometry.Size
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.drawscope.Stroke
import androidx.compose.ui.graphics.drawscope.drawIntoCanvas
import androidx.compose.ui.graphics.nativeCanvas
import androidx.compose.ui.graphics.toArgb
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.platform.LocalDensity
import androidx.compose.ui.res.stringArrayResource
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.AnnotatedString
import androidx.compose.ui.text.TextStyle
import androidx.compose.ui.text.font.FontFamily
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.input.KeyboardType
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.Dp
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.compose.ui.window.Dialog
import androidx.hilt.navigation.compose.hiltViewModel
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import androidx.navigation.NavHostController
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import androidx.navigation.compose.rememberNavController
import androidx.room.Dao
import androidx.room.Database
import androidx.room.Delete
import androidx.room.Entity
import androidx.room.Insert
import androidx.room.MapInfo
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
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.flow.launchIn
import kotlinx.coroutines.flow.map
import kotlinx.coroutines.flow.onEach
import kotlinx.coroutines.launch
import java.text.SimpleDateFormat
import java.util.Calendar
import java.util.Locale
import javax.inject.Inject
import javax.inject.Singleton
import kotlin.math.min


val errorColor = Color(0xFF\(uiSettings.errorColor ?? "FFFFFF"))
val buttonColorSecondary = Color(0xFF\(uiSettings.buttonColorSecondary ?? "FFFFFF"))
val buttonColorPrimary = Color(0xFF\(uiSettings.buttonColorPrimary ?? "FFFFFF"))
val buttonTextColorPrimary = Color(0xFF\(uiSettings.buttonTextColorPrimary ?? "FFFFFF"))
val backColorPrimary = Color(0xFF\(uiSettings.backColorPrimary ?? "FFFFFF"))
val textColorPrimary = Color(0xFF\(uiSettings.textColorPrimary ?? "FFFFFF"))
val surfaceColor = Color(0xFF\(uiSettings.surfaceColor ?? "FFFFFF"))

//const
val colorListPieChart = listOf(
    Color(0xFFa292cb),
    Color(0xFFcb92bb),
    Color(0xFFbbcb92),
    Color(0xFF92cbbf),
    Color(0xFFcb929e),
    Color(0xFFa0a3ba),
    Color(0xFFb2e4e4),
    Color(0xFFe4e4b2),
    Color(0xFF9BCDD2),
    Color(0xFFFFB07F),
    Color(0xFFFFD966),
    Color(0xFF99a5ff),
)

@Composable
fun TrackerTheme( content: @Composable () -> Unit) {
    MaterialTheme(
        typography = Typography,
        content = content
    )
}

val Typography = Typography(
    displayLarge = TextStyle(
        fontFamily = FontFamily.Default,
        fontWeight = FontWeight.W500,
        fontSize = 30.sp,
        lineHeight = 35.sp,
        letterSpacing = 0.4.sp,
        textAlign = TextAlign.Center
    )
)

object Constants {
    const val SHARED_PREFERENCES_NAME = "BALANCE"
    const val VALUE = "AMOUNT"
    const val SIGN ="SIGN"
    const val SIGN_DEFAULT ="$"
}

fun List<Float>.toPercent(): List<Float> {
    return this.map { item ->
        item * 100 / this.sum()
    }
}

interface PojoMapper<Entity, DomainModel> {

    fun mapFromEntity(entity: Entity): DomainModel

    fun mapToEntity(domainModel: DomainModel): Entity

}

@Dao
interface ExpenseDao {
    @Query("SELECT * FROM expenses")
    fun getAllExpense(): Flow<List<ExpenseEntity>>

    @Insert
    suspend fun insertExpense(expense: ExpenseEntity)

    @MapInfo(keyColumn = "categoryName", valueColumn = "categoryAmount")
    @Query("SELECT categoryName,SUM(amount) as categoryAmount FROM expenses GROUP BY categoryName")
    fun getSumAmountByCategory(): Flow<Map<String, Float>>

    @Delete
    suspend fun deleteExpense(expense: ExpenseEntity)
}

@Database(
    entities = [ExpenseEntity::class],
    version = 1,
    exportSchema = false)
abstract class ExpenseDatabase : RoomDatabase() {
    abstract fun drinksDao(): ExpenseDao

    companion object {
        const val DATABASE_NAME: String = "expense_db"
    }
}

@Entity(tableName = "expenses")
data class ExpenseEntity(
    @PrimaryKey(autoGenerate = true)
    val id: Long = 0,
    val name: String,
    val categoryName: String,
    val amount: Float,
    val date: String
)

class ExpenseMapper
@Inject
constructor() : PojoMapper<ExpenseEntity, ExpenseModel> {

    override fun mapFromEntity(entity: ExpenseEntity): ExpenseModel {
        return ExpenseModel(
            id = entity.id,
            name = entity.name,
            categoryName = entity.categoryName,
            amount = entity.amount,
            date = entity.date
        )
    }

    override fun mapToEntity(domainModel: ExpenseModel): ExpenseEntity {
        return ExpenseEntity(
            id = domainModel.id,
            name = domainModel.name,
            categoryName = domainModel.categoryName,
            amount = domainModel.amount,
            date = domainModel.date
        )
    }
}

class ExpenseRepositoryImpl @Inject constructor(
    private val expenseDao: ExpenseDao,
    private val expenseMapper: ExpenseMapper,
) : ExpenseDatabaseRepository {

    override fun getAllExpense(): Flow<List<ExpenseModel>> {
        return expenseDao.getAllExpense().map {
            it.map { expenseEntity ->
                expenseMapper.mapFromEntity(expenseEntity)
            }
        }
    }

    override suspend fun insertExpense(expense: ExpenseModel) {
        expenseDao.insertExpense(
            expenseMapper.mapToEntity(expense)
        )
    }


    override fun getSumAmountByCategory(): Flow<Map<String,Float>> {
        return expenseDao.getSumAmountByCategory()
    }

    override suspend fun deleteExpense(expense: ExpenseModel) {
        return expenseDao.deleteExpense(
            expenseMapper.mapToEntity(expense)
        )
    }


}

data class ExpenseModel(
    val id: Long = 0,
    val name: String,
    val categoryName: String,
    val amount: Float,
    val date: String
)

interface ExpenseDatabaseRepository {
    fun getAllExpense(): Flow<List<ExpenseModel>>

    suspend fun insertExpense(expense: ExpenseModel)

    fun getSumAmountByCategory():Flow<Map<String,Float>>

    suspend fun deleteExpense(expense: ExpenseModel)
}

class DeleteExpenseUseCase @Inject constructor(private val repository: ExpenseDatabaseRepository) {
    suspend operator fun invoke(expenseModel: ExpenseModel) = repository.deleteExpense(expenseModel)
}

class GetAllExpenseUseCase @Inject constructor(private val repository: ExpenseDatabaseRepository) {
    operator fun invoke() = repository.getAllExpense()
}

class GetSumAmountByCategoryUseCase  @Inject constructor(private val repository: ExpenseDatabaseRepository) {
    operator fun invoke() = repository.getSumAmountByCategory()
}

class InsertExpenseUseCase @Inject constructor(private val repository: ExpenseDatabaseRepository) {
    suspend operator fun invoke(expenseModel: ExpenseModel) = repository.insertExpense(expenseModel)
}

@Module
@InstallIn(SingletonComponent::class)
object AppModule {

    @Singleton
    @Provides
    fun provideSharedPreferences(
        @ApplicationContext context: Context
    ): SharedPreferences = context.getSharedPreferences(
        Constants.SHARED_PREFERENCES_NAME,
        Context.MODE_PRIVATE
    )

    @Provides
    @Singleton
    fun provideDatabase(
        @ApplicationContext context: Context
    ): ExpenseDatabase =
        Room.databaseBuilder(
            context, ExpenseDatabase::class.java,
            ExpenseDatabase.DATABASE_NAME
        )
            .fallbackToDestructiveMigration()
            .build()


    @Provides
    @Singleton
    fun provideRepository(
        database: ExpenseDatabase,
        expenseMapper: ExpenseMapper,
    ): ExpenseDatabaseRepository =
        ExpenseRepositoryImpl(database.drinksDao(), expenseMapper)

}

@HiltViewModel
class MainViewModel @Inject constructor(
    private val getAllExpenseUseCase: GetAllExpenseUseCase,
    private val getExpenseByCategoryUseCase: GetSumAmountByCategoryUseCase,
    private val insertExpenseUseCase: InsertExpenseUseCase,
    private val deleteExpenseUseCase: DeleteExpenseUseCase,
    private val sharedPrefs: SharedPreferences
) : ViewModel() {

    private val _listExpense = MutableStateFlow<List<ExpenseModel>>(listOf())
    val listExpense = _listExpense.asStateFlow()

    private val _listCategory = MutableStateFlow<Map<String, Float>>(mapOf())
    val listCategory = _listCategory.asStateFlow()

    var balance by mutableStateOf(sharedPrefs.getFloat(Constants.VALUE, 0f))
        private set

    var currencySign by mutableStateOf(
        sharedPrefs.getString(
            Constants.SIGN,
            Constants.SIGN_DEFAULT
        )
    )
        private set

    var totalExpense by mutableStateOf(0f)
        private set

    private val df = SimpleDateFormat("dd-MM-yyyy", Locale.getDefault())

    fun getAllExpense() {
        getAllExpenseUseCase().onEach {
            _listExpense.value = it
        }.launchIn(viewModelScope)
    }

    fun insertExpense(name: String, categoryName: String, amount: Float) {
        viewModelScope.launch {
            val time = Calendar.getInstance().time
            val expense = ExpenseModel(
                name = name,
                categoryName = categoryName,
                amount = amount,
                date = df.format(time)
            )
            insertExpenseUseCase.invoke(expense)
        }
    }

    fun deleteExpense(expenseModel: ExpenseModel) {
        viewModelScope.launch {
            deleteExpenseUseCase.invoke(expenseModel)
        }
    }

    fun getAmountByCategory() {
        getExpenseByCategoryUseCase().onEach {
            _listCategory.value = it
            recalculateBalance()
        }.launchIn(viewModelScope)
    }


    fun changeBalance(newBalance: Float, newSign: String) {
        balance = newBalance
        currencySign = newSign
        sharedPrefs.edit().putFloat(Constants.VALUE, balance).apply()
        sharedPrefs.edit().putString(Constants.SIGN, currencySign).apply()
        recalculateBalance()
    }

    private fun recalculateBalance() {
        totalExpense = _listCategory.value.values.sum()
        balance -= totalExpense
    }

}



@Composable
fun AllExpenseScreen (){
    Box(
        modifier = Modifier
            .fillMaxSize()
            .background(color = backColorPrimary)
    ){
        LazyColumnWithSwipe()
    }
}

@Composable
fun MainScreen(navController: NavHostController, viewModel: MainViewModel = hiltViewModel()) {
    Box(
        modifier = Modifier
            .fillMaxSize()
            .background(color = backColorPrimary)
    ) {
        Column(
            modifier = Modifier
                .align(Alignment.TopCenter),
            horizontalAlignment = Alignment.CenterHorizontally
        ) {
            LaunchedEffect(key1 = Unit) {
                viewModel.getAmountByCategory()
            }

            val balance = viewModel.balance
            val totalExpense = viewModel.totalExpense
            val mapCategory = viewModel.listCategory.collectAsState().value
            val sign = viewModel.currencySign ?: ""
            var showDialogBalance by remember { mutableStateOf(false) }
            if (showDialogBalance)
                CustomDialog(value = "", setShowDialog = {
                    showDialogBalance = it
                })

            Box(
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(20.dp)
            ) {
                ClickableText(
                    text = AnnotatedString(stringResource(R.string.part_amount, balance, sign)),
                    style = MaterialTheme.typography.displayLarge,
                    onClick = { showDialogBalance = true },
                    modifier = Modifier.align(Alignment.CenterStart)
                )
                Icon(
                    modifier = Modifier
                        .align(Alignment.CenterEnd)
                        .size(40.dp)
                        .clickable {
                            navController.navigate(Screens.AllExpenseScreen.route)
                        },
                    tint = buttonColorPrimary,
                    imageVector = Icons.Filled.Payments,
                    contentDescription = "All"
                )
            }

            val textTotal = stringResource(id = R.string.part_amount, totalExpense, sign)
            val listColorCategory = chartColors(mapCategory.keys)

            if (mapCategory.isNotEmpty()) {
                PieChart(
                    modifier = Modifier.padding(horizontal = 40.dp, vertical = 20.dp),
                    colors = listColorCategory,
                    inputValues = mapCategory.values.toList(),
                    textColor = MaterialTheme.colorScheme.secondary,
                    centerText = textTotal
                )
            }

            ListColumnCategory(mapCategory, sign)
        }
        FloatingActionButton(
            modifier = Modifier
                .padding(all = 20.dp)
                .align(alignment = Alignment.BottomEnd),
            backgroundColor = buttonColorPrimary,
            contentColor = buttonTextColorPrimary,
            onClick = {
                navController.navigate(Screens.NewExpenseScreen.route)
            }
        ) {
            Icon(imageVector = Icons.Filled.Add, contentDescription = "Add")
        }
    }
}
@OptIn(ExperimentalLayoutApi::class)
@Composable
fun ExpenseScreen(navController: NavHostController, viewModel: MainViewModel = hiltViewModel()) {
    Box(
        modifier = Modifier
            .fillMaxSize()
            .background(color = backColorPrimary)
    ) {
        var txtFieldName by remember { mutableStateOf("") }
        var txtFieldAmount by remember { mutableStateOf("") }
        var txtFieldError by remember { mutableStateOf("") }
        var txtFieldCategory by remember { mutableStateOf("") }
        Column(
            modifier = Modifier
                .padding(20.dp)
                .align(Alignment.TopCenter),
            horizontalAlignment = Alignment.CenterHorizontally
        ) {
            Text(
                text = stringResource(R.string.make_new_expense),
                style = MaterialTheme.typography.displayLarge,
                color = textColorPrimary
            )

            InputRow(label = stringResource(id = R.string.name),
                txtField = txtFieldName,
                inputType = KeyboardType.Text,
                txtFieldError = txtFieldError,
                onValueChange = {
                    txtFieldName = it
                })
            InputRow(label = stringResource(id = R.string.amount),
                txtField = txtFieldAmount,
                inputType = KeyboardType.Number,
                txtFieldError = txtFieldError,
                onValueChange = {
                    txtFieldAmount = it
                })
            FlowRow(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.spacedBy(3.dp),
                maxItemsInEachRow = 4,
            ) {
                val listCategory = stringArrayResource(id = R.array.categories)
                listCategory.forEach { categoryName ->
                    FlowButton(
                        modifier = Modifier.padding(2.dp),
                        text = categoryName,
                        backgroundColor = if (txtFieldCategory == categoryName) buttonColorPrimary else buttonColorSecondary,
                        onClick = {
                            txtFieldCategory = categoryName
                        }
                    )
                }
            }
        }
        val context = LocalContext.current
        Button(
            onClick = {
                if (txtFieldName.isEmpty() or txtFieldAmount.isEmpty() or txtFieldCategory.isEmpty()) {
                    txtFieldError = context.getString(R.string.error)
                    return@Button
                }
                viewModel.insertExpense(txtFieldName,txtFieldCategory,txtFieldAmount.toFloat())
                navController.navigate("main_screen") {
                    popUpTo(0)
                }
            },
            modifier = Modifier
                .fillMaxWidth()
                .align(Alignment.BottomCenter)
                .padding(30.dp),
            colors = ButtonDefaults.buttonColors(containerColor = buttonColorPrimary)
        ) {
            Text(
                text = stringResource(R.string.btn_done),
                style = MaterialTheme.typography.bodyLarge,
                color = buttonTextColorPrimary
            )
        }
    }
}

@Composable
fun FlowButton(modifier: Modifier, text: String, backgroundColor: Color, onClick: () -> Unit) {
    Button(
        modifier = modifier,
        colors = ButtonDefaults.buttonColors(containerColor = backgroundColor),
        onClick = onClick
    )
    {
        Text(
            text = text,
            style = MaterialTheme.typography.bodyMedium,
            color = buttonTextColorPrimary
        )
    }
}

@Composable
fun CardExpense(animateDp: Dp, item: ExpenseModel, sign: String) {
    Card(
        modifier = Modifier
            .fillMaxWidth()
            .padding(vertical = 2.dp),
        shape = RoundedCornerShape(10.dp),
        colors = CardDefaults.cardColors(surfaceColor),
        elevation = CardDefaults.cardElevation(animateDp)
    ) {
        Box(
            modifier = Modifier
                .fillMaxWidth()
                .padding(10.dp)
        ) {
            Text(
                modifier = Modifier.align(Alignment.TopStart),
                text = stringResource(id = R.string.item_label,item.categoryName,item.name),
                style = MaterialTheme.typography.bodyLarge,
                color = textColorPrimary
            )
            Text(
                modifier = Modifier
                    .padding(25.dp)
                    .align(Alignment.CenterStart),
                text = stringResource(id = R.string.part_amount, item.amount, sign),
                style = MaterialTheme.typography.bodyLarge,
                color = textColorPrimary
            )
            Text (
                modifier = Modifier.align(Alignment.BottomEnd),
                text = item.date,
                style = MaterialTheme.typography.bodyMedium,
                color = textColorPrimary
            )
        }
    }
}

@Composable
fun CategoryItem(item: Pair<String, Float>, color: Color, sign: String) {
    Card(
        modifier = Modifier
            .fillMaxWidth()
            .padding(vertical = 2.dp),
        shape = RoundedCornerShape(10.dp),
        colors = CardDefaults.cardColors(color),
        elevation = CardDefaults.cardElevation()
    ) {
        Box(
            modifier = Modifier
                .fillMaxWidth()
                .padding(10.dp)
        ) {
            Text(
                modifier = Modifier.align(Alignment.CenterStart),
                text = item.first,
                style = MaterialTheme.typography.bodyMedium,
                color = textColorPrimary
            )
            Text(
                modifier = Modifier.align(Alignment.CenterEnd),
                text = stringResource(id = R.string.part_amount, item.second, sign),
                style = MaterialTheme.typography.bodyMedium,
                color = textColorPrimary
            )
        }
    }
}
@Composable
fun CustomDialog(
    value: String,
    setShowDialog: (Boolean) -> Unit,
    viewModel: MainViewModel = hiltViewModel()
) {
    val context = LocalContext.current
    val txtFieldError = remember { mutableStateOf("") }
    val txtFieldCurrency = remember { mutableStateOf(context.getString(R.string.currency)) }
    val txtFieldAmount = remember { mutableStateOf(value) }

    Dialog(onDismissRequest = { setShowDialog(false) }) {
        Surface(
            shape = RoundedCornerShape(16.dp),
            color = backColorPrimary,
        ) {
            Column(
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(20.dp),
                horizontalAlignment = Alignment.CenterHorizontally
            ) {

                ContentDialog(stringResource(R.string.dialog_title), setShowDialog)

                InputRow(
                    label = stringResource(R.string.amount),
                    txtFieldError = txtFieldError.value,
                    txtField = txtFieldAmount.value,
                    inputType = KeyboardType.Number,
                    onValueChange = {
                        txtFieldAmount.value = it
                    })

                var expanded by remember {
                    mutableStateOf(false)
                }
                val suggestions = stringArrayResource(id = R.array.currency_signs)
                Box(modifier = Modifier.padding(bottom = 20.dp)) {
                    Button(
                        onClick = { expanded = !expanded },
                        colors = ButtonDefaults.buttonColors(containerColor = buttonColorSecondary)

                    ) {
                        Text(text = txtFieldCurrency.value, color = buttonTextColorPrimary)
                        Icon(
                            imageVector = Icons.Filled.ArrowDropDown,
                            contentDescription = null,
                            tint = buttonTextColorPrimary
                        )
                    }
                    DropdownMenu(
                        modifier = Modifier.background(buttonColorSecondary),
                        expanded = expanded,
                        onDismissRequest = { expanded = false },
                    ) {
                        suggestions.forEach { label ->
                            DropdownMenuItem(
                                onClick = {
                                    txtFieldCurrency.value = label
                                    expanded = false
                                },
                                text = { Text(text = label, color = buttonTextColorPrimary) })
                        }
                    }
                }

                Button(
                    onClick = {

                        if (txtFieldAmount.value.isEmpty() or txtFieldCurrency.value.isEmpty()) {
                            txtFieldError.value = context.getString(R.string.error)
                            return@Button
                        }
                        viewModel.changeBalance(
                            txtFieldAmount.value.toFloat(),
                            txtFieldCurrency.value
                        )
                        setShowDialog(false)
                    },
                    shape = RoundedCornerShape(50.dp),
                    modifier = Modifier
                        .fillMaxWidth()
                        .height(50.dp)
                        .padding(horizontal = 40.dp),

                    colors = ButtonDefaults.buttonColors(containerColor = buttonColorPrimary)
                ) {
                    Text(text = stringResource(R.string.btn_done),  color = buttonTextColorPrimary )
                }
            }
        }
    }
}

@Composable
fun ContentDialog(label: String, setShowDialog: (Boolean) -> Unit) {
    Row(
        modifier = Modifier.fillMaxWidth(),
        horizontalArrangement = Arrangement.SpaceBetween,
        verticalAlignment = Alignment.CenterVertically
    ) {
        Text(
            text = label,
            style = MaterialTheme.typography.displayLarge,
            color = textColorPrimary
        )
        Icon(
            imageVector = Icons.Filled.Cancel,
            contentDescription = "",
            tint = errorColor,
            modifier = Modifier
                .width(30.dp)
                .height(30.dp)
                .clickable { setShowDialog(false) }
        )
    }
}

@Composable
fun InputRow(
    label: String,
    txtField: String,
    txtFieldError: String,
    inputType: KeyboardType,
    onValueChange: (String) -> Unit
) {
    TextField(
        modifier =
        Modifier
            .fillMaxWidth()
            .padding(vertical = 10.dp)
            .border(
                BorderStroke(
                    width = 2.dp,
                    color = if (txtFieldError.isEmpty())
                        buttonColorPrimary
                    else errorColor
                ),
                shape = RoundedCornerShape(50.dp)
            ),
        colors = TextFieldDefaults.textFieldColors(
            backgroundColor = backColorPrimary,
            focusedIndicatorColor = backColorPrimary,
            unfocusedIndicatorColor = backColorPrimary
        ),
        placeholder = { Text(text = label) },
        value = txtField,
        keyboardOptions = KeyboardOptions(keyboardType = inputType),
        onValueChange = onValueChange
    )
}

@OptIn(ExperimentalMaterialApi::class)
@Composable
fun LazyColumnWithSwipe(viewModel: MainViewModel = hiltViewModel()) {
    LaunchedEffect(key1 = Unit) {
        viewModel.getAllExpense()
    }
    val sign = viewModel.currencySign ?: ""
    val listExpense = viewModel.listExpense.collectAsState().value.reversed()
    LazyColumn {
        items(listExpense, { expense: ExpenseModel -> expense.id }) { item ->

            val dismissState = rememberDismissState()

            if (dismissState.isDismissed(DismissDirection.EndToStart)) {
                viewModel.deleteExpense(item)
            }
            SwipeToDismiss(
                state = dismissState,
                modifier = Modifier
                    .padding(vertical = Dp(1f)),
                directions = setOf(
                    DismissDirection.EndToStart
                ),
                dismissThresholds = { direction ->
                    FractionalThreshold(if (direction == DismissDirection.EndToStart) 0.1f else 0.05f)
                },
                background = {
                    val color by animateColorAsState(
                        when (dismissState.targetValue) {
                            DismissValue.Default -> buttonTextColorPrimary //todo
                            else -> errorColor
                        }
                    )

                    val scale by animateFloatAsState(
                        if (dismissState.targetValue == DismissValue.Default) 0.75f else 1f
                    )

                    Box(
                        modifier = Modifier
                            .fillMaxSize()
                            .background(color)
                            .padding(horizontal = Dp(20f)),
                        contentAlignment = Alignment.CenterEnd
                    ) {
                        Icon(
                            imageVector = Icons.Default.Delete,
                            contentDescription = "Delete",
                            modifier = Modifier.scale(scale),
                            tint = textColorPrimary
                        )
                    }
                },
                dismissContent = {
                    val animateDp = animateDpAsState(
                        if (dismissState.dismissDirection != null) 4.dp else 0.dp
                    ).value
                    CardExpense(animateDp, item = item, sign = sign)
                }
            )

        }
    }
}

@Composable
@ReadOnlyComposable
fun chartColors(namesCategory: Set<String>): List<Color> {
    val listAllCategory = stringArrayResource(id = R.array.categories)
    val listColor = mutableListOf<Color>()
    namesCategory.forEach { categoryName ->
        val index = listAllCategory.indexOf(categoryName)
        listColor.add(colorListPieChart[index])
    }
    return listColor
}


@Composable
fun ListColumnCategory(values: Map<String, Float>, sign: String) {
    val listColorCategory = chartColors(values.keys)
    LazyColumn(
        modifier = Modifier
            .fillMaxSize(),
        contentPadding = PaddingValues(10.dp),
        verticalArrangement = Arrangement.spacedBy(2.dp),
    ) {
        itemsIndexed(values.toList()) { index, item ->
            CategoryItem(
                item = item,
                color = listColorCategory[index],
                sign = sign
            )
        }
    }
}
@Composable
fun PieChart(
    modifier: Modifier = Modifier,
    colors: List<Color>,
    inputValues: List<Float>,
    textColor: Color = textColorPrimary,
    centerText: String
) {
    val density = LocalDensity.current
    var startAngle = 270f
    val proportions = inputValues.toPercent()
    val angleProgress = proportions.map { prop ->
        360f * prop / 100
    }
    val progressSize = mutableListOf<Float>()

    LaunchedEffect(angleProgress) {
        progressSize.add(angleProgress.first())
        for (x in 1 until angleProgress.size) {
            progressSize.add(angleProgress[x] + progressSize[x - 1])
        }
    }
    val pathPortion = remember {
        Animatable(initialValue = 0f)
    }

    LaunchedEffect(inputValues) {
        pathPortion.animateTo(1f, animationSpec = tween(800))
    }

    val textFontSize = with(density) { 30.dp.toPx() }
    val textPaint = remember {
        Paint().apply {
            color = textColor.toArgb()
            textSize = textFontSize
            textAlign = Paint.Align.CENTER
        }
    }
    val sliceWidth = with(density) { 40.dp.toPx() }
    BoxWithConstraints(
        modifier = modifier.padding(horizontal = 20.dp),
        contentAlignment = Alignment.Center
    ) {

        val canvasSize = min(constraints.maxWidth, constraints.maxHeight)
        val size = Size(canvasSize.toFloat(), canvasSize.toFloat())
        val canvasSizeDp = with(density) { canvasSize.toDp() }

        Canvas(
            modifier = Modifier
                .size(canvasSizeDp)
        ) {
            angleProgress.forEachIndexed { index, angle ->
                drawArc(
                    color = colors[index],
                    startAngle = startAngle,
                    sweepAngle = angle * pathPortion.value,
                    useCenter = false,
                    size = size,
                    style = Stroke(width = sliceWidth)
                )
                startAngle += angle
            }
            drawIntoCanvas { canvas ->
                canvas.nativeCanvas.drawText(
                    centerText,
                    (canvasSize / 2) + textFontSize / 4,
                    (canvasSize / 2) + textFontSize / 4,
                    textPaint
                )
            }
        }
    }
}

@Composable
fun Navigation() {
    val navController = rememberNavController()

    NavHost(navController = navController, startDestination = Screens.MainScreen.route) {

        composable(route = Screens.MainScreen.route) {
            MainScreen(navController)
        }

        composable(route = Screens.NewExpenseScreen.route) {
            ExpenseScreen(navController)
        }

        composable(route = Screens.AllExpenseScreen.route) {
            AllExpenseScreen()
        }

    }
}

sealed class Screens(val route: String){
    object MainScreen: Screens("main_screen")
    object AllExpenseScreen: Screens("all_expense_screen")
    object NewExpenseScreen: Screens("new_expense_screen")
}




"""
    }
    
    static func dependencies(_ mainData: MainData) -> ANDData {
        return ANDData(mainFragmentData: ANDMainFragment(imports: "", content: """
                TrackerTheme {
                    Navigation()
                }
"""), mainActivityData: ANDMainActivity(imports: "", extraFunc: "", content: ""), themesData: ANDThemesData(isDefault: true, content: ""), stringsData: ANDStringsData(additional: """
    <string name="total_amount">"Budget: %1$.2f%2$s"</string>
    <string name="part_amount">"%1$.2f%2$s"</string>
    <string name="make_new_expense">Make new expense</string>
    <string name="btn_done">Done</string>
    <string name="error">Field can not be empty</string>
    <string name="dialog_title">Set your budget</string>
    <string name="amount">Amount</string>
    <string name="name">Name</string>
    <string name="currency">Currency</string>
    <string name="item_label">%1$s, %2$s</string>


    <string-array name="categories">
        <item>Product</item>
        <item>Health</item>
        <item>Education</item>
        <item>Clothes</item>
        <item>Home</item>
        <item>Car</item>
        <item>Public transport</item>
        <item>Hobby</item>
        <item>Sport</item>
        <item>Leisure</item>
        <item>Cafe</item>
        <item>Cosmetics</item>
    </string-array>

    <string-array name="currency_signs">
        <item>$</item>
        <item>€</item>
        <item>£</item>
        <item>¥</item>
        <item>₽</item>
        <item>₨</item>
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
            signingConfig signingConfigs.debug
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
    implementation Dependencies.room_runtime
    kapt Dependencies.room_compiler
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
