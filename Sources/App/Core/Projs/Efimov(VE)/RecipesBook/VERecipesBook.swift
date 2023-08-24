//
//  File.swift
//  
//
//  Created by admin on 8/21/23.
//

import Foundation

struct VERecipesBook: FileProviderProtocol {
    static var fileName: String = "RecipesBookPro.kt"
    
    static func fileContent(packageName: String, uiSettings: UISettings) -> String {
        """
package \(packageName).presentation.fragments.main_fragment

import android.text.Html
import android.widget.Toast
import androidx.activity.compose.BackHandler
import androidx.annotation.Keep
import androidx.compose.foundation.Image
import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.ArrowBack
import androidx.compose.material.icons.filled.BrokenImage
import androidx.compose.material.icons.filled.Refresh
import androidx.compose.material.icons.filled.Search
import androidx.compose.material3.Button
import androidx.compose.material3.ButtonDefaults
import androidx.compose.material3.Card
import androidx.compose.material3.CircularProgressIndicator
import androidx.compose.material3.Divider
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.IconButtonDefaults
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Text
import androidx.compose.material3.TextField
import androidx.compose.material3.TextFieldDefaults
import androidx.compose.material3.TopAppBar
import androidx.compose.material3.TopAppBarDefaults
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.collectAsState
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Brush
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.SpanStyle
import androidx.compose.ui.text.buildAnnotatedString
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.text.withStyle
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.lifecycle.SavedStateHandle
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import coil.compose.SubcomposeAsyncImage
import com.google.gson.annotations.SerializedName
import com.ramcosta.composedestinations.annotation.Destination
import com.ramcosta.composedestinations.annotation.RootNavGraph
import com.ramcosta.composedestinations.navigation.DestinationsNavigator
import \(packageName).R
import \(packageName).presentation.fragments.main_fragment.destinations.DishDetailsScreenDestination
import \(packageName).presentation.fragments.main_fragment.destinations.DishesListScreenDestination
import kotlinx.coroutines.CoroutineDispatcher
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.flow.MutableSharedFlow
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.asSharedFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import org.koin.androidx.compose.koinViewModel
import org.koin.androidx.viewmodel.dsl.viewModelOf
import org.koin.core.module.dsl.singleOf
import org.koin.dsl.module
import retrofit2.HttpException
import retrofit2.Retrofit
import retrofit2.converter.gson.GsonConverterFactory
import retrofit2.http.GET
import retrofit2.http.Path
import retrofit2.http.Query
import java.io.IOException

val textColorPrimary = Color(0xFF\(uiSettings.textColorPrimary ?? "FFFFFF"))
val textColorSecondary = Color(0xFF\(uiSettings.textColorSecondary ?? "FFFFFF"))
val backColorPrimary = Color(0xFF\(uiSettings.backColorPrimary ?? "FFFFFF"))
val surfaceColor = Color(0xFF\(uiSettings.surfaceColor ?? "FFFFFF"))
val buttonColorPrimary = Color(0xFF\(uiSettings.buttonColorPrimary ?? "FFFFFF"))

val searchGradient = listOf(backColorPrimary, surfaceColor)

@Keep
data class DishDetailsDto(
    @SerializedName("title") val title: String,
    @SerializedName("image") val image: String,
    @SerializedName("readyInMinutes") val readyInMinutes: Int,
    @SerializedName("extendedIngredients") val extendedIngredient: List<IngredientDto>,
    @SerializedName("summary") val summary: String
)

@Keep
data class IngredientDto(
    @SerializedName("name") val name: String,
    @SerializedName("amount") val amount: Float,
    @SerializedName("unit") val unit: String
)

@Keep
data class QueryResults(
    @SerializedName("results") val results: List<DishDto>
)

data class DishDto(
    @SerializedName("id") val id: Long,
    @SerializedName("title") val title: String,
    @SerializedName("image") val image: String,
)

object Endpoints {
    const val baseUrl = "https://api.spoonacular.com/"
    const val recipesEndpoint = "/recipes/complexSearch"
    const val recipesInformationEndpoint = "/recipes/{id}/information"
}

interface RecipesApi {

    @GET(Endpoints.recipesEndpoint)
    suspend fun getRecipesByQuery(
        @Query("query") query: String,
        @Query("apiKey") apiKey: String = "ce6faa1074ad42a4a4af3df53fe750a4"
    ): QueryResults

    @GET(Endpoints.recipesInformationEndpoint)
    suspend fun getRecipeInformationById(
        @Path("id") id: Long,
        @Query("apiKey") apiKey: String = "ce6faa1074ad42a4a4af3df53fe750a4"
    ): DishDetailsDto

}

fun DishDto.toRecipeItem() =
    Dish(
        id,
        title,
        image
    )

fun IngredientDto.toIngredient() =
    Ingredient(
        name,
        amount,
        unit
    )

fun DishDetailsDto.toDishDetails() =
    DishDetails(
        title = title,
        image = image,
        readyInMinutes = readyInMinutes,
        extendedIngredient = extendedIngredient.map { it.toIngredient() },
        summary = summary.fromHtml()
    )

private fun String.fromHtml() =
    Html.fromHtml(this, Html.FROM_HTML_MODE_LEGACY).toString()

class RecipesRepositoryImpl(
    private val api: RecipesApi
): RecipesRepository {

    override suspend fun getRecipesByQuery(query: String): List<Dish> {
        return api.getRecipesByQuery(query).results.map { it.toRecipeItem() }
    }

    override suspend fun getDishDetailsById(dishId: Long): DishDetails {
        return api.getRecipeInformationById(id = dishId).toDishDetails()
    }

}

fun Throwable.toResourceError(): Int {
    return when(this) {
        is IOException -> R.string.net_connection
        is HttpException -> R.string.http_connection
        else -> R.string.unexpected_error
    }
}


val dataModule = module {

    single<RecipesApi> {
        Retrofit.Builder()
            .baseUrl(Endpoints.baseUrl)
            .addConverterFactory(GsonConverterFactory.create())
            .build()
            .create(RecipesApi::class.java)
    }

    single<RecipesRepository> { RecipesRepositoryImpl(api = get()) }
    single<CoroutineDispatcher> { Dispatchers.IO }
}

val viewModelModule = module {
    viewModelOf(::FindViewModel)
    viewModelOf(::DishesListViewModel)
    viewModelOf(::DishDetailsViewModel)
}

val useCaseModule = module {
    singleOf(::SearchByQueryUseCase)
    singleOf(::GetDetailsByIdUseCase)
}

data class Dish(
    val id: Long,
    val title: String,
    val image: String
)

data class DishDetails(
    val title: String,
    val image: String?,
    val readyInMinutes: Int,
    val extendedIngredient: List<Ingredient>,
    val summary: String
)

data class Ingredient(
    val name: String,
    val amount: Float,
    val unit: String
)

interface RecipesRepository {
    suspend fun getRecipesByQuery(query: String): List<Dish>

    suspend fun getDishDetailsById(dishId: Long): DishDetails
}

class GetDetailsByIdUseCase(
    private val repository: RecipesRepository,
    private val dispatcher: CoroutineDispatcher
) {
    suspend operator fun invoke(dishId: Long) = kotlin.runCatching {
        withContext(dispatcher) { repository.getDishDetailsById(dishId) }
    }
}

class SearchByQueryUseCase(
    private val repository: RecipesRepository,
    private val dispatcher: CoroutineDispatcher
) {
    suspend operator fun invoke(query: String) = kotlin.runCatching {
        withContext(dispatcher) { repository.getRecipesByQuery(query) }
    }
}

sealed interface DishDetailsEvent {
    object LoadDetails: DishDetailsEvent
}

class DishDetailsViewModel(
    private val getDetailsByIdUseCase: GetDetailsByIdUseCase,
    savedStateHandle: SavedStateHandle
): ViewModel() {

    private val _uiState = MutableStateFlow<UiDishDetailsState>(UiDishDetailsState.Loading)
    val uiState = _uiState.asStateFlow()

    private val dishId = savedStateHandle.get<Long>("dishId")

    init {
        handleEvent(DishDetailsEvent.LoadDetails)
    }

    fun handleEvent(event: DishDetailsEvent) {
        when(event) {
            DishDetailsEvent.LoadDetails -> getDetails()
        }
    }

    private fun getDetails() {
        if(dishId == null) {
            _uiState.value = UiDishDetailsState.Error(R.string.unexpected_error)
            return
        }

        viewModelScope.launch {
            getDetailsByIdUseCase(dishId)
                .onSuccess { _uiState.value = UiDishDetailsState.Success(it) }
                .onFailure { _uiState.value = UiDishDetailsState.Error(it.toResourceError()) }
        }
    }
}

sealed interface UiDishDetailsState {
    object Loading: UiDishDetailsState
    class Error(val resId: Int): UiDishDetailsState
    class Success(val dishDetails: DishDetails): UiDishDetailsState
}

@OptIn(ExperimentalMaterial3Api::class)
@Destination
@Composable
fun DishDetailsScreen(
    dishId: Long,
    viewModel: DishDetailsViewModel = koinViewModel(),
    navigator: DestinationsNavigator
) {
    val uiState = viewModel.uiState.collectAsState().value

    Scaffold(
        topBar = {
            TopAppBar(
                title = { },
                navigationIcon = {
                    IconButton(
                        colors = IconButtonDefaults.filledIconButtonColors(
                            containerColor = surfaceColor
                        ),
                        onClick = navigator::popBackStack
                    ) {
                        Icon(
                            imageVector = Icons.Default.ArrowBack,
                            contentDescription = null,
                            tint = textColorPrimary
                        )
                    }
                },
                colors = TopAppBarDefaults.centerAlignedTopAppBarColors(
                    containerColor = Color.Transparent
                )
            )
        }
    ) { scaffoldPaddings ->
        BackgroundLayout {
            when(uiState) {
                is UiDishDetailsState.Loading -> Loader()
                is UiDishDetailsState.Error -> ErrorMessage(
                    resId = uiState.resId,
                    onTryClick = { viewModel.handleEvent(DishDetailsEvent.LoadDetails) }
                )
                is UiDishDetailsState.Success -> DishDetailsContent(
                    paddings = scaffoldPaddings,
                    dishDetails = uiState.dishDetails
                )
            }
        }
    }
}

@Composable
private fun DishDetailsContent(
    paddings: PaddingValues,
    dishDetails: DishDetails
) {
    val ingredientsPadding = PaddingValues(horizontal = 52.dp)
    val imagePadding = PaddingValues(horizontal = 20.dp)

    LazyColumn(
        modifier = Modifier
            .fillMaxSize()
            .padding(paddings),
        horizontalAlignment = Alignment.Start,
        verticalArrangement = Arrangement.spacedBy(20.dp)
    ) {
        item {
            Text(
                modifier = Modifier.fillMaxWidth(),
                text = dishDetails.title,
                color = textColorPrimary,
                fontSize = 24.sp,
                fontWeight = FontWeight.Bold,
                textAlign = TextAlign.Center
            )
        }

        item {
            Box(
                modifier = Modifier
                    .fillMaxWidth()
                    .height(250.dp)
                    .padding(imagePadding)
                    .clip(RoundedCornerShape(20))
            ) {
                SubcomposeAsyncImage(
                    modifier = Modifier
                        .align(Alignment.Center)
                        .fillMaxSize(),
                    model = dishDetails.image,
                    contentDescription = dishDetails.title,
                    loading = { Loader() },
                    contentScale = ContentScale.FillBounds,
                    error = {
                        Icon(
                            modifier = Modifier.fillMaxSize(),
                            imageVector = Icons.Default.BrokenImage,
                            contentDescription = null,
                            tint = textColorPrimary
                        )
                    }
                )
                Text(
                    modifier = Modifier
                        .align(Alignment.BottomStart)
                        .padding(start = 20.dp, bottom = 20.dp),
                    text = stringResource(id = R.string.ready_in_minutes, dishDetails.readyInMinutes),
                    color = textColorSecondary,
                    fontWeight = FontWeight.Bold,
                    fontSize = 16.sp
                )
            }
        }

        item {
            Text(
                modifier = Modifier.padding(ingredientsPadding),
                text = stringResource(id = R.string.ingredients),
                color = textColorPrimary,
                fontSize = 16.sp,
                fontWeight = FontWeight.Bold,
                textAlign = TextAlign.Center
            )
        }

        items(dishDetails.extendedIngredient) { ingredient ->
            val defaultSpanStyle = SpanStyle(
                color = textColorPrimary,
                fontSize = 14.sp,
            )

            with(ingredient) {
                Text(
                    modifier = Modifier.padding(ingredientsPadding),
                    text = buildAnnotatedString {
                        withStyle(defaultSpanStyle.copy(fontWeight = FontWeight.Bold)) {
                            append(stringResource(id = R.string.ingredients_container, amount.toStringWithFormat(), unit))
                        }
                        withStyle(defaultSpanStyle) {
                            append(" $name")
                        }
                    },
                    textAlign = TextAlign.Center
                )

                Divider(
                    modifier = Modifier.padding(ingredientsPadding)
                )
            }
        }

        item {
            Column(
                modifier = Modifier.fillMaxWidth(),
                horizontalAlignment = Alignment.CenterHorizontally,
                verticalArrangement = Arrangement.spacedBy(20.dp, Alignment.CenterVertically)
            ) {
                Text(
                    text = stringResource(id = R.string.description),
                    color = textColorPrimary,
                    fontSize = 16.sp,
                    fontWeight = FontWeight.Bold,
                    textAlign = TextAlign.Center
                )
                Text(
                    modifier = Modifier.padding(horizontal = 26.dp),
                    text = dishDetails.summary,
                    color = textColorPrimary,
                    fontSize = 16.sp,
                    textAlign = TextAlign.Start
                )
            }
        }
    }
}

sealed interface DishesListSideEffects {
    object NavBack: DishesListSideEffects

    class NavNextScreen(val dishId: Long): DishesListSideEffects

    class ShowToast(val resId: Int): DishesListSideEffects
}

class DishesListViewModel (
    private val searchByQueryUseCase: SearchByQueryUseCase,
    savedStateHandle: SavedStateHandle
): ViewModel() {

    private val _uiState = MutableStateFlow<UiDishesState>(UiDishesState.Loading)
    val uiState = _uiState.asStateFlow()

    private val _sideEffects = MutableSharedFlow<DishesListSideEffects>()
    val sideEffects = _sideEffects.asSharedFlow()

    private val _argQuery = savedStateHandle.get<String>("query") ?: ""

    init {
        handleEvent(DishListEvents.DoSearch(_argQuery))
    }

    fun handleEvent(event: DishListEvents) {
        when(event) {
            is DishListEvents.DoSearch -> doSearch(event.query)
            is DishListEvents.OpenDetails -> emitSideEffect(DishesListSideEffects.NavNextScreen(event.dishId))
            is DishListEvents.BackPressed -> emitSideEffect(DishesListSideEffects.NavBack)
        }
    }

    private fun doSearch(query: String) {
        _uiState.value = UiDishesState.Loading

        viewModelScope.launch {
            searchByQueryUseCase(query)
                .onSuccess { items ->
                    if(items.isEmpty())  {
                        emitSideEffect(DishesListSideEffects.ShowToast(resId = R.string.no_items))
                        return@onSuccess
                    }
                    _uiState.value = UiDishesState.Success(items)
                }
                .onFailure { _uiState.value = UiDishesState.Error(it.toResourceError()) }
        }
    }

    private fun emitSideEffect(effect: DishesListSideEffects) {
        viewModelScope.launch { _sideEffects.emit(effect) }
    }
}

sealed interface DishListEvents {
    class OpenDetails(val dishId: Long): DishListEvents
    class DoSearch(val query: String): DishListEvents
    object BackPressed: DishListEvents
}

sealed interface UiDishesState {
    object Loading: UiDishesState
    class Error(val resId: Int): UiDishesState
    class Success(val dishes: List<Dish>): UiDishesState
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun DishListItem(
    dish: Dish,
    onItemClick: () -> Unit
) {
    Column(
        modifier = Modifier.fillMaxWidth(),
        horizontalAlignment = Alignment.CenterHorizontally,
        verticalArrangement = Arrangement.spacedBy(5.dp)
    ) {
        Text(
            text = dish.title,
            color = textColorPrimary,
            fontSize = 24.sp,
            textAlign = TextAlign.Center
        )
        Card(
            modifier = Modifier.size(320.dp, 250.dp),
            shape = RoundedCornerShape(20),
            onClick = onItemClick
        ) {
            SubcomposeAsyncImage(
                modifier = Modifier.fillMaxSize(),
                model = dish.image,
                contentDescription = dish.title,
                loading = { Loader() },
                contentScale = ContentScale.FillBounds
            )
        }
    }
}

@Composable
fun ErrorMessage(
    resId: Int,
    onTryClick: () -> Unit
) {
    Column(
        modifier  = Modifier.fillMaxSize(),
        horizontalAlignment = Alignment.CenterHorizontally,
        verticalArrangement = Arrangement.spacedBy(20.dp, Alignment.CenterVertically)
    ) {
        Text(
            text = stringResource(id = resId),
            color = textColorPrimary,
            fontSize = 20.sp
        )

        Box(
            modifier = Modifier
                .size(200.dp)
                .clip(RoundedCornerShape(20))
                .clickable { onTryClick() }
                .background(buttonColorPrimary),
            contentAlignment = Alignment.Center
        ) {
            Icon(
                modifier = Modifier.size(70.dp),
                imageVector = Icons.Default.Refresh,
                contentDescription = null
            )
        }
    }
}

@Composable
fun Loader() {
    Column(
        modifier = Modifier.fillMaxSize(),
        horizontalAlignment = Alignment.CenterHorizontally,
        verticalArrangement = Arrangement.spacedBy(20.dp, Alignment.CenterVertically)
    ) {
        Text(
            text = stringResource(id = R.string.loading),
            color = textColorPrimary,
            fontSize = 25.sp
        )
        CircularProgressIndicator(color = textColorPrimary)
    }
}

@Destination
@Composable
fun DishesListScreen(
    query: String,
    viewModel: DishesListViewModel = koinViewModel(),
    navigator: DestinationsNavigator
) {
    val uiState = viewModel.uiState.collectAsState().value
    val context = LocalContext.current

    LaunchedEffect(key1 = Unit) {
        viewModel.sideEffects.collect { effect ->
            when(effect) {
                is DishesListSideEffects.NavBack -> navigator.popBackStack()
                is DishesListSideEffects.NavNextScreen -> navigator.navigate(
                    DishDetailsScreenDestination(dishId = effect.dishId)
                )
                is DishesListSideEffects.ShowToast -> {
                    Toast.makeText(context, effect.resId, Toast.LENGTH_SHORT).show()
                    navigator.popBackStack()
                }
            }
        }
    }

    BackHandler { viewModel.handleEvent(DishListEvents.BackPressed) }

    BackgroundLayout {
        when(uiState) {
            is UiDishesState.Loading -> Loader()
            is UiDishesState.Error -> ErrorMessage(
                resId = uiState.resId,
                onTryClick = { viewModel.handleEvent(DishListEvents.DoSearch(query)) }
            )
            is UiDishesState.Success -> DishesListLayout(
                query = query,
                dishes = uiState.dishes,
                onItemClick = { viewModel.handleEvent(DishListEvents.OpenDetails(it)) }
            )
        }
    }
}

@Composable
private fun DishesListLayout(
    query: String,
    dishes: List<Dish>,
    onItemClick: (dishId: Long) -> Unit
) {
    LazyColumn(
        modifier = Modifier.fillMaxSize(),
        contentPadding = PaddingValues(20.dp),
        verticalArrangement = Arrangement.spacedBy(40.dp),
        horizontalAlignment = Alignment.CenterHorizontally
    ) {
        item {
            SearchField(
                query = query,
                onQueryChanged = {},
                readyOnly = true,
                hideIcon = true
            )
        }

        items(dishes) { dish ->
            DishListItem(
                dish = dish,
                onItemClick = { onItemClick(dish.id) }
            )
        }
    }
}

sealed interface FindScreenEvents {
    object DoSearch: FindScreenEvents
    object BackPressed: FindScreenEvents
    class QueryChanged(val newValue: String): FindScreenEvents
}

sealed interface FindSideEffects {
    object NavBack: FindSideEffects
    class NavNextScreen(val query: String): FindSideEffects
}

class FindViewModel: ViewModel() {

    private val _uiState = MutableStateFlow(UiFindState())
    val uiState = _uiState.asStateFlow()

    private val _sideEffects = MutableSharedFlow<FindSideEffects>()
    val sideEffects = _sideEffects.asSharedFlow()

    fun handleEvent(event: FindScreenEvents) {
        when(event) {
            is FindScreenEvents.DoSearch -> emitSideEffect(
                FindSideEffects.NavNextScreen(query = _uiState.value.query)
            )
            is FindScreenEvents.QueryChanged ->
                _uiState.value = _uiState.value.copy(
                    query = event.newValue
                )
            is FindScreenEvents.BackPressed -> emitSideEffect(
                FindSideEffects.NavBack)
        }
    }

    private fun emitSideEffect(effect: FindSideEffects) {
        viewModelScope.launch {
            _sideEffects.emit(effect)
        }
    }
}

data class UiFindState(
    val query: String = "",
    val state: FindScreenState = FindScreenState.Default
)

sealed interface FindScreenState {
    object Default: FindScreenState
}

@RootNavGraph(start = true)
@Destination
@Composable
fun FindScreen(
    navigator: DestinationsNavigator,
    viewModel: FindViewModel = koinViewModel()
) {
    val uiState = viewModel.uiState.collectAsState().value

    LaunchedEffect(key1 = Unit) {
        viewModel.sideEffects.collect { effect ->
            when(effect) {
                is FindSideEffects.NavNextScreen -> navigator.navigate(
                    DishesListScreenDestination(query = effect.query)
                )
                is FindSideEffects.NavBack -> navigator.popBackStack()
            }
        }
    }

    when(uiState.state) {
        is FindScreenState.Default -> BackgroundLayout {
            FindScreenContent(
                query = uiState.query,
                onQueryChanged = { viewModel.handleEvent(FindScreenEvents.QueryChanged(it)) },
                onFindClick = { viewModel.handleEvent(FindScreenEvents.DoSearch) }
            )
        }
    }
}

@Composable
private fun FindScreenContent(
    query: String,
    onQueryChanged: (String) -> Unit,
    onFindClick: () -> Unit
) {
    Column(
        modifier = Modifier.fillMaxSize(),
        horizontalAlignment = Alignment.CenterHorizontally,
        verticalArrangement = Arrangement.spacedBy(10.dp, Alignment.CenterVertically)
    ) {
        Image(
            modifier = Modifier.size(300.dp),
            painter = painterResource(id = R.drawable.logo),
            contentDescription = null
        )

        SearchField(
            query = query,
            onQueryChanged = onQueryChanged
        )

        Button(
            modifier = Modifier.width(145.dp),
            colors = ButtonDefaults.buttonColors(
                containerColor = buttonColorPrimary
            ),
            onClick = onFindClick
        ) {
            Text(
                text = stringResource(id = R.string.find),
                color = textColorPrimary,
                fontSize = 20.sp
            )
        }

        Text(
            modifier = Modifier.padding(top = 20.dp),
            text = stringResource(id = R.string.welcome),
            color = textColorPrimary,
            fontWeight = FontWeight.Bold,
            fontSize = 18.sp,
            textAlign = TextAlign.Center
        )

        Text(
            modifier = Modifier.padding(horizontal = 30.dp),
            text = stringResource(id = R.string.welcome_description),
            color = textColorPrimary,
            fontSize = 16.sp,
            textAlign = TextAlign.Center
        )
    }
}

@Composable
fun BackgroundLayout(content: @Composable () -> Unit) {
    Box(
        modifier = Modifier.fillMaxSize(),
        contentAlignment = Alignment.Center
    ) {
        Image(
            modifier = Modifier.fillMaxSize(),
            painter = painterResource(id = R.drawable.background),
            contentScale = ContentScale.FillBounds,
            contentDescription = null
        )

        content()
    }
}

@Composable
fun SearchField(
    query: String,
    onQueryChanged: (String) -> Unit,
    readyOnly: Boolean = false,
    hideIcon: Boolean = false
) {

    val borderBrush = Brush.verticalGradient(colors = searchGradient)

    TextField(
        modifier = Modifier
            .fillMaxWidth()
            .padding(horizontal = 25.dp)
            .border(2.dp, borderBrush, RoundedCornerShape(40.dp)),
        value = query,
        onValueChange = onQueryChanged,
        leadingIcon = {
            if(!hideIcon)
                Icon(
                    imageVector = Icons.Default.Search,
                    contentDescription = null,
                    tint = textColorPrimary
                )
        },
        placeholder = {
            Text(
                text = stringResource(id = R.string.search),
                color = textColorPrimary,
                fontSize = 12.sp
            )
        },
        colors = TextFieldDefaults.colors(
            focusedContainerColor = surfaceColor,
            unfocusedContainerColor = surfaceColor,
            focusedIndicatorColor = Color.Transparent,
            unfocusedIndicatorColor = Color.Transparent
        ),
        singleLine = true,
        shape = RoundedCornerShape(40.dp),
        readOnly = readyOnly
    )
}

fun Float.toStringWithFormat(): String {
    return "%.2f".format(this)
}


"""
    }
    
    static func dependencies(_ mainData: MainData) -> ANDData {
        return ANDData(
            mainFragmentData: ANDMainFragment(imports: """
import androidx.compose.material.Surface
import com.ramcosta.composedestinations.DestinationsNavHost
""", content: """
    Surface {
        DestinationsNavHost(navGraph = NavGraphs.root)
    }
"""),
            mainActivityData: ANDMainActivity(imports: "", extraFunc: "", content: ""),
            themesData: ANDThemesData(isDefault: true, content: ""),
            stringsData: ANDStringsData(additional: """
    <string name="find">Find</string>
    <string name="welcome">Welcome!</string>
    <string name="welcome_description">Enter the name of a dish and you will see a list of all available for cooking</string>
    <string name="search">Search</string>
    <string name="no_items">No items</string>
    <string name="net_connection">Check your internet connection!</string>
    <string name="http_connection">Somehing wrong on our side</string>
    <string name="unexpected_error">Unexpected error</string>
    <string name="loading">Loading…</string>
    <string name="ingredients">Ingredients</string>
    <string name="ingredients_container">%s %s</string>
    <string name="ready_in_minutes">%d min</string>
    <string name="description">Description</string>
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

    plugins {
        id 'com.google.devtools.ksp' version '1.8.10-1.0.9'
    }

    apply plugin: 'com.android.application'
    apply plugin: 'org.jetbrains.kotlin.android'
    apply plugin: 'com.google.dagger.hilt.android'
    apply plugin: 'kotlin-kapt'

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
            buildConfig true
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
        implementation Dependencies.compose_destinations_core
        ksp Dependencies.compose_destinations_ksp
        implementation Dependencies.calendar_compose
        implementation Dependencies.room_ktx
        implementation Dependencies.room_runtime
        implementation Dependencies.dagger_hilt
        kapt Dependencies.dagger_hilt_compiler
        implementation Dependencies.hilt_viewmodel_compiler
        ksp Dependencies.room_compiler
        implementation Dependencies.retrofit
        implementation Dependencies.converter_gson
        implementation Dependencies.coil_compose
        implementation Dependencies.koin_android
        implementation Dependencies.koin_compose
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
        const val coil = "2.4.0"
        const val exp = "0.4.8"
        const val calend = "0.5.1"
        const val paging_version = "3.1.1"

        const val compose_destination = "1.8.42-beta"
        const val moshi = "1.15.0"

        const val kotlin_serialization = "1.5.1"
        const val datastore_preferences = "1.0.0"

        const val calendar_compose = "2.3.0"

        const val desugar_version = "1.1.8"

        const val koin_version = "3.4.3"
        const val koin_ksp_version = "1.2.2"


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

        const val compose_destinations_core = "io.github.raamcosta.compose-destinations:core:${Versions.compose_destination}"
        const val compose_destinations_ksp = "io.github.raamcosta.compose-destinations:ksp:${Versions.compose_destination}"

        const val moshi = "com.squareup.moshi:moshi-kotlin:${Versions.moshi}"

        const val kotlinx_serialization = "org.jetbrains.kotlinx:kotlinx-serialization-json:${Versions.kotlin_serialization}"

        const val data_store = "androidx.datastore:datastore-preferences:${Versions.datastore_preferences}"

        const val calendar_compose = "com.kizitonwose.calendar:compose:${Versions.calendar_compose}"

        const val desugar = "com.android.tools:desugar_jdk_libs:${Versions.desugar_version}"

        const val koin_android = "io.insert-koin:koin-android:${Versions.koin_version}"
        const val koin_compose = "io.insert-koin:koin-androidx-compose:${Versions.koin_version}"
        const val koin_annotations = "io.insert-koin:koin-annotations:${Versions.koin_ksp_version}"
        const val koin_ksp_compiler = "io.insert-koin:koin-ksp-compiler:${Versions.koin_ksp_version}"
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
