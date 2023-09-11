//
//  File.swift
//  
//
//  Created by admin on 14.08.2023.
//

import Foundation

struct AKPokerChances: FileProviderProtocol {
    static var fileName = "\(NamesManager.shared.fileName).kt"
    
    static func fileContent(packageName: String, uiSettings: UISettings) -> String {
        return """
package \(packageName).presentation.fragments.main_fragment

import android.widget.Toast
import androidx.compose.foundation.Image
import androidx.compose.foundation.border
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.ExperimentalLayoutApi
import androidx.compose.foundation.layout.FlowRow
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.lazy.LazyRow
import androidx.compose.foundation.lazy.grid.GridCells
import androidx.compose.foundation.lazy.grid.LazyGridScope
import androidx.compose.foundation.lazy.grid.LazyVerticalGrid
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.Button
import androidx.compose.material.ButtonDefaults
import androidx.compose.material.SnackbarData
import androidx.compose.material.SnackbarHost
import androidx.compose.material.SnackbarHostState
import androidx.compose.material3.Card
import androidx.compose.material3.CardDefaults
import androidx.compose.material3.CircularProgressIndicator
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.FilterChip
import androidx.compose.material3.FilterChipDefaults
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.rememberCoroutineScope
import androidx.compose.runtime.saveable.rememberSaveable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.hilt.navigation.compose.hiltViewModel
import androidx.lifecycle.ViewModel
import androidx.navigation.NavBackStackEntry
import androidx.navigation.NavController
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import androidx.navigation.compose.rememberNavController
import \(packageName).R
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.delay
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.launch
import src.main.kotlin.Board
import src.main.kotlin.Calculator
import src.main.kotlin.CardDeck
import src.main.kotlin.GameStat
import src.main.kotlin.Hand
import javax.inject.Inject

val textColorPrimary = Color(0xFF\(uiSettings.textColorPrimary ?? "FFFFFF"))
val buttonColorPrimary = Color(0xFF\(uiSettings.buttonColorPrimary ?? "FFFFFF"))
val buttonColorSecondary = Color(0xFF\(uiSettings.buttonColorSecondary ?? "FFFFFF"))
val surfaceColor = Color(0xFF\(uiSettings.surfaceColor ?? "FFFFFF"))

fun minusPerson(currentNumber: Int): Int {
    if (currentNumber>2) {
        return currentNumber-1
    }
    return 0
}

fun plusPerson(currentNumber: Int): Int {
    if (currentNumber<10) {
        return currentNumber+1
    }
    return 0
}

fun LazyGridScope.cardItem(card: Card) {
    item {
        CardItem(card = card)
    }
}

data class Card(
    val imageRes: Int,
    val name: String
)

val cardTypeImage = listOf(R.drawable.diamond, R.drawable.club, R.drawable.heart, R.drawable.spade)

val allDiamondCards = listOf(
    Card(R.drawable.d2, "d2"),
    Card(R.drawable.d3, "d3"),
    Card(R.drawable.d4, "d4"),
    Card(R.drawable.d5, "d5"),
    Card(R.drawable.d6, "d6"),
    Card(R.drawable.d7, "d7"),
    Card(R.drawable.d8, "d8"),
    Card(R.drawable.d9, "d9"),
    Card(R.drawable.d10, "d10"),
    Card(R.drawable.dj, "dj"),
    Card(R.drawable.dq, "dq"),
    Card(R.drawable.dk, "dk"),
    Card(R.drawable.da, "da")
)

val allClubCards = listOf(
    Card(R.drawable.c2,"c2"),
    Card(R.drawable.c3,"c3"),
    Card(R.drawable.c4,"c4"),
    Card(R.drawable.c5,"c5"),
    Card(R.drawable.c6,"c6"),
    Card(R.drawable.c7,"c7"),
    Card(R.drawable.c8,"c8"),
    Card(R.drawable.c9,"c9"),
    Card(R.drawable.c10,"c10"),
    Card(R.drawable.cj,"cj"),
    Card(R.drawable.cq,"cq"),
    Card(R.drawable.ck,"ck"),
    Card(R.drawable.ca, "ca")
)

val allHeartCards = listOf(
    Card(R.drawable.h2,"h2"),
    Card(R.drawable.h3,"h3"),
    Card(R.drawable.h4,"h4"),
    Card(R.drawable.h5,"h5"),
    Card(R.drawable.h6,"h6"),
    Card(R.drawable.h7,"h7"),
    Card(R.drawable.h8,"h8"),
    Card(R.drawable.h9,"h9"),
    Card(R.drawable.h10,"h10"),
    Card(R.drawable.hj,"hj"),
    Card(R.drawable.hq,"hq"),
    Card(R.drawable.hk,"hk"),
    Card(R.drawable.ha,"ha")
)

val allSpadeCards = listOf(
    Card(R.drawable.s2,"s2"),
    Card(R.drawable.s3,"s3"),
    Card(R.drawable.s4,"s4"),
    Card(R.drawable.s5,"s5"),
    Card(R.drawable.s6,"s6"),
    Card(R.drawable.s7,"s7"),
    Card(R.drawable.s8,"s8"),
    Card(R.drawable.s9,"s9"),
    Card(R.drawable.s10,"s10"),
    Card(R.drawable.sj,"sj"),
    Card(R.drawable.sq,"sq"),
    Card(R.drawable.sk,"sk"),
    Card(R.drawable.sa,"sa")
)

@Composable
fun MySnackbar(snackbarHostState: SnackbarHostState) {

    SnackbarHost(
        hostState = snackbarHostState,
        snackbar = { snackbarData: SnackbarData ->
            Card(
                modifier = Modifier
                    .padding(16.dp)
                    .fillMaxWidth(),
                shape = RoundedCornerShape(16.dp),
                colors = CardDefaults.cardColors(containerColor = buttonColorPrimary),
            ) {
                Column(
                    modifier = Modifier
                        .padding(16.dp)
                        .fillMaxWidth(),
                ) {
                    Text(
                        text = snackbarData.message,
                        color = surfaceColor,
                        fontSize = 16.sp
                    )
                }

            }

        }
    )
}

@Composable
fun BackgroundImage() {
    Image(
        modifier = Modifier
            .fillMaxSize(),
        painter = painterResource(id = R.drawable.bg),
        contentDescription = stringResource(id = R.string.bg_image_desc),
        contentScale = ContentScale.FillBounds
    )
}

@Composable
fun TableAndPlayersScreen(entry: NavBackStackEntry, navController: NavController, viewModel: TableAndPlayersViewModel = hiltViewModel()) {

    val chosenCard = remember { mutableStateOf(entry.savedStateHandle.get<Int>("chosen_card")) }
    val chosenCardValue = remember { mutableStateOf(entry.savedStateHandle.get<String>("chosen_card_value")) }
    val buttonNextClicked = viewModel.buttonNextClicked.collectAsState().value
    val cardsOnTable = viewModel.cardsOnTable.collectAsState().value
    val playersAmount = viewModel.playersAmount.collectAsState().value
    val chancesList = viewModel.chances.collectAsState().value

    BackgroundImage()

    val snackbarHostState = remember { SnackbarHostState() }

    Column(
        modifier = Modifier
            .fillMaxSize()
            .padding(start = 16.dp, end = 16.dp, top = 24.dp),
        verticalArrangement = Arrangement.spacedBy(24.dp)
    ) {

        if (!buttonNextClicked) TextWithHints(stringResource(id = R.string.cards_for_table_text))
        else TextWithHints(stringResource(id = R.string.cards_on_table_text))


        Cards(!buttonNextClicked, navController, chosenCard.value, chosenCardValue.value)

        if (!buttonNextClicked) {

            TextWithHints(stringResource(id = R.string.players_for_table_text))

            PeopleCard(snackbarHostState)

            NextButton()

        } else {

            TextWithHints(stringResource(id = R.string.hint))

            val gameStat = GameStat.Builder()

            val freeCards = mutableListOf(
                "c2", "c3", "c4", "c5", "c6", "c7", "c8", "c9", "ct", "cj", "cq", "ck", "ca",
                "d2", "d3", "d4", "d5", "d6", "d7", "d8", "d9", "dt", "dj", "dq", "dk", "da",
                "h2", "h3", "h4", "h5", "h6", "h7", "h8", "h9", "ht", "hj", "hq", "hk", "ha",
                "s2", "s3", "s4", "s5", "s6", "s7", "s8", "s9", "st", "sj", "sq", "sk", "sa"
            )
            if (cardsOnTable.size==3) {
                freeCards.remove(cardsOnTable[0])
                freeCards.remove(cardsOnTable[1])
                freeCards.remove(cardsOnTable[2])

                gameStat.setBoard(Board(CardDeck.valueOf(cardsOnTable[0]), CardDeck.valueOf(cardsOnTable[1]), CardDeck.valueOf(cardsOnTable[2])))
            }

            Column(
                modifier = Modifier
                    .fillMaxSize()
                    .verticalScroll(rememberScrollState())
            ){
                for (person in 1..playersAmount) {
                    PersonCardsItem(freeCards, person, gameStat, chancesList)
                }

                CalculateButton(gameStat.build())
            }
        }
    }

    MySnackbar(snackbarHostState)

}

@Composable
fun TextWithHints(text: String) {
    Text(
        text = text,
        color = textColorPrimary,
        fontSize = 16.sp
    )
}

@Composable
fun PersonCardsItem(freeCards: MutableList<String>, person: Int, gameStat: GameStat.Builder, chancesList: List<Int>) {
    Card(
        modifier = Modifier
            .fillMaxWidth()
            .padding(bottom = 8.dp),
        colors = CardDefaults.cardColors(containerColor = surfaceColor)
    ) {
        Column(
            modifier = Modifier
                .fillMaxWidth()
                .padding(8.dp),
            horizontalAlignment = Alignment.Start,
            verticalArrangement = Arrangement.spacedBy(4.dp)
        ) {
            Row(
                modifier = Modifier
                    .fillMaxWidth(),
                horizontalArrangement = Arrangement.SpaceBetween
            ) {
                Text(
                    text = stringResource(id = R.string.player_number, person),
                    color = textColorPrimary,
                    fontSize = 16.sp
                )


                Text(
                    text =  if (chancesList.isNotEmpty() && chancesList.size>=person) stringResource(id = R.string.person_chance, chancesList[person-1]) else "",
                    color = textColorPrimary,
                    fontSize = 16.sp
                )
            }


            val card1 = remember { mutableStateOf((0..freeCards.size-1).random())}
            val card1ForCalculator = remember { mutableStateOf(CardDeck.valueOf(freeCards[card1.value]))}
            Text(
                text = stringResource(id = R.string.card1, freeCards[card1.value]),
                color = textColorPrimary,
                fontSize = 16.sp
            )
            freeCards.removeAt(card1.value)

            val card2 = remember { mutableStateOf((0..freeCards.size-1).random())}
            val card2ForCalculator = remember { mutableStateOf(CardDeck.valueOf(freeCards[card2.value]))}
            Text(
                text = stringResource(id = R.string.card2, freeCards[card2.value]),
                color = textColorPrimary,
                fontSize = 16.sp
            )
            freeCards.removeAt(card2.value)

            gameStat.addPlayerHand(Hand(card1ForCalculator.value, card2ForCalculator.value))
        }
    }
}

@Composable
fun PeopleCard(snackbarHostState: SnackbarHostState,viewModel: TableAndPlayersViewModel = hiltViewModel()) {

    val players = viewModel.playersAmount.collectAsState().value

    Card(
        modifier = Modifier
            .fillMaxWidth(),
        colors = CardDefaults.cardColors(containerColor = surfaceColor),
    ) {
        Row(
            modifier = Modifier
                .fillMaxWidth()
                .padding(8.dp),
            horizontalArrangement = Arrangement.SpaceBetween,
            verticalAlignment = Alignment.CenterVertically
        ) {
            Text(
                text = players.toString(),
                color = textColorPrimary,
                fontSize = 16.sp
            )


            Row(
                verticalAlignment = Alignment.CenterVertically,
                horizontalArrangement = Arrangement.spacedBy(8.dp)
            ) {
                ImageIcons(minus = true, players = players, snackbarHostState = snackbarHostState, message = R.string.error_too_little_people, image = R.drawable.minus_icon)

                ImageIcons(minus = false,players = players, snackbarHostState = snackbarHostState, message = R.string.error_too_much_people, image = R.drawable.plus_icon)
            }
        }
    }

}

@Composable
fun NextButton(viewModel: TableAndPlayersViewModel = hiltViewModel()) {

    val context = LocalContext.current

    Button(
        modifier = Modifier.fillMaxWidth(),
        onClick = {
            if (viewModel.imageForFirst.value!=0 && viewModel.imageForSecond.value!=0 && viewModel.imageForThird.value!=0)  {
                if (viewModel.cardsOnTable.value.toSet().size!=3) {
                    Toast.makeText(context, R.string.error_not_different_cards, Toast.LENGTH_SHORT).show()
                } else {
                    viewModel.changeButtonNextClicked(true)
                }
            } else {
                Toast.makeText(context, R.string.error_not_all_card, Toast.LENGTH_SHORT).show()
            }
        },
        colors = ButtonDefaults.buttonColors(backgroundColor = buttonColorPrimary),
        shape = RoundedCornerShape(12.dp)
    ) {
        androidx.compose.material.Text(
            text = stringResource(id = R.string.next_button_text),
            fontSize = 14.sp,
            color = surfaceColor
        )
    }
}

@Composable
fun ImageIcons(minus: Boolean, players: Int, snackbarHostState: SnackbarHostState, message: Int, image: Int,  viewModel: TableAndPlayersViewModel = hiltViewModel()) {
    val scope = rememberCoroutineScope()
    val context = LocalContext.current
    Image(
        modifier = Modifier
            .width(20.dp)
            .height(20.dp)
            .clickable {
                when {
                    minus && minusPerson(players) == 0 -> {
                        scope.launch {
                            snackbarHostState.showSnackbar(context.getString(message))
                        }
                    }
                    minus && minusPerson(players) != 0 -> {
                        viewModel.changePlayersAmount(players - 1)
                    }
                    !minus && plusPerson(players) == 0 -> {
                        scope.launch {
                            snackbarHostState.showSnackbar(context.getString(message))
                        }
                    } else -> {
                    viewModel.changePlayersAmount(players + 1)
                }
                }
            },
        painter = painterResource(id = image),
        contentDescription = stringResource(id = R.string.icon_desc)
    )
}

@Composable
fun ImageForCards(clicked: Int, image: Int, ableToClick: Boolean, navController: NavController, viewModel: TableAndPlayersViewModel = hiltViewModel()) {
    Image(
        modifier = Modifier
            .width(104.dp)
            .height(144.dp)
            .clickable {
                if (ableToClick) {
                    viewModel.changeClickedCard(clicked)
                    navController.navigate(Screen.CardsScreen.route)
                }
            },
        painter =  if (image!=0) painterResource(id = image) else painterResource(id = R.drawable.card_def),
        contentDescription = stringResource(id = R.string.card_image_desc)
    )
}

@Composable
fun Cards(ableToClick: Boolean, navController: NavController, chosenCard: Int?, chosenCardValue: String?,viewModel: TableAndPlayersViewModel = hiltViewModel()) {

    val clickedCard = viewModel.clickedCard.collectAsState().value

    if (chosenCard != null) {
        when(clickedCard) {
            1 -> {
                viewModel.changeImageForFirst(chosenCard)
                if (chosenCardValue != null){
                    viewModel.changeCardsOnTable(chosenCardValue,0)
                }
            }
            2 -> {
                viewModel.changeImageForSecond(chosenCard)
                if (chosenCardValue != null){
                    viewModel.changeCardsOnTable(chosenCardValue,1)
                }
            }
            3 -> {
                viewModel.changeImageForThird(chosenCard)
                if (chosenCardValue != null){
                    viewModel.changeCardsOnTable(chosenCardValue,2)
                }
            }
        }
    }

    val imageForFirst = viewModel.imageForFirst.collectAsState().value
    val imageForSecond = viewModel.imageForSecond.collectAsState().value
    val imageForThird = viewModel.imageForThird.collectAsState().value

    LazyRow(
        modifier = Modifier
            .fillMaxWidth(),
        verticalAlignment = Alignment.CenterVertically,
        horizontalArrangement = Arrangement.SpaceBetween
    ) {

        item{
            ImageForCards(1,imageForFirst, ableToClick, navController)
        }

        item{
            ImageForCards(2,imageForSecond, ableToClick, navController)
        }

        item{
            ImageForCards(3,imageForThird, ableToClick, navController)
        }

    }
}

@Composable
fun CalculateButton(gameStat: GameStat, viewModel: TableAndPlayersViewModel = hiltViewModel()) {
    val calculator = Calculator(gameStat)
    Button(
        modifier = Modifier.fillMaxWidth(),
        onClick = {
            val result = calculator.calculate()
            viewModel.changeChances(result)
        },
        colors = ButtonDefaults.buttonColors(backgroundColor = buttonColorPrimary),
        shape = RoundedCornerShape(12.dp)
    ) {
        Text(
            text = stringResource(id = R.string.calculate_button_text),
            fontSize = 14.sp,
            color = surfaceColor
        )
    }
}

@Composable
fun SplashScreen(navController: NavController) {

    LaunchedEffect(key1 = true) {
        delay(2000L)

        navController.navigate(Screen.TableAndPlayersScreen.route) {
            popUpTo(0)
        }
    }

    BackgroundImage()

    Column(
        modifier = Modifier
            .fillMaxSize(),
        verticalArrangement = Arrangement.Center,
        horizontalAlignment = Alignment.CenterHorizontally,
    ) {

        Text(
            modifier = Modifier.padding(bottom = 16.dp),
            text = stringResource(id = R.string.text_splash_screen),
            color = textColorPrimary,
            fontSize = 24.sp
        )

        CircularProgressIndicator(
            color = buttonColorPrimary
        )

    }
}

@Composable
fun CardsScreen(navController: NavController,viewModel: CardsViewModel = hiltViewModel()) {

    BackgroundImage()

    Column(
        modifier = Modifier
            .fillMaxSize()
            .padding(start = 16.dp, end = 16.dp, top = 24.dp),
        verticalArrangement = Arrangement.spacedBy(24.dp)
    ) {

        Back(navController)

        CardTypes()

        Text(
            text = stringResource(id = R.string.choose_card_text),
            color = textColorPrimary,
            fontSize = 16.sp
        )

        GridWithCards()

    }
}

@Composable
fun Back(navController: NavController, viewModel: CardsViewModel = hiltViewModel()) {

    val chosenCard = viewModel.chosenCard.collectAsState().value
    val chosenCardValue = viewModel.chosenCardValue.collectAsState().value

    Text(
        modifier = Modifier
            .clickable {
                navController.previousBackStackEntry?.savedStateHandle?.set("chosen_card", chosenCard)
                navController.previousBackStackEntry?.savedStateHandle?.set("chosen_card_value", chosenCardValue)
                navController.navigateUp()
            }
            .border(2.dp, textColorPrimary, shape = RoundedCornerShape(6.dp))
            .padding(start = 6.dp, end = 6.dp),
        text = stringResource(id = R.string.ok_text),
        color = textColorPrimary,
        fontSize = 16.sp
    )
}

@Composable
fun CardItem(card: Card, viewModel: CardsViewModel = hiltViewModel()) {

    val context = LocalContext.current

    Image(
        modifier = Modifier
            .width(104.dp)
            .height(144.dp)
            .clickable {
                Toast.makeText(context, R.string.toast_text_chosen_card, Toast.LENGTH_SHORT).show()
                viewModel.changeChosenCard(card.imageRes)
                viewModel.changeChosenCardValue(card.name)
            },
        painter = painterResource(id = card.imageRes),
        contentDescription = card.name
    )
}

@OptIn(ExperimentalLayoutApi::class, ExperimentalMaterial3Api::class)
@Composable
fun CardTypes(viewModel: CardsViewModel = hiltViewModel()) {

    val selectedItem = rememberSaveable {
        mutableStateOf(0)
    }

    FlowRow(
        horizontalArrangement = Arrangement.spacedBy(8.dp)
    ) {

        cardTypeImage.forEach { item ->

            FilterChip(
                selected = (item == selectedItem.value),
                onClick = {
                    selectedItem.value = item
                    viewModel.changeChosenCardType(item)
                },
                label = {
                    Image(
                        modifier = Modifier
                            .size(20.dp),
                        painter = painterResource(id = item),
                        contentDescription = stringResource(id = R.string.icon_desc)
                    )
                },
                colors = FilterChipDefaults.filterChipColors(
                    containerColor = buttonColorSecondary,
                    selectedContainerColor = surfaceColor
                ),
                shape = RoundedCornerShape(12.dp),
                border = null
            )
        }
    }
}

@Composable
fun GridWithCards(viewModel: CardsViewModel = hiltViewModel()) {

    val chosenType = viewModel.chosenCardType.collectAsState().value

    LazyVerticalGrid(
        columns = GridCells.Adaptive(minSize = 104.dp),
        verticalArrangement = Arrangement.spacedBy(8.dp),
        horizontalArrangement = Arrangement.spacedBy(8.dp)

    ) {

        when (chosenType) {
            R.drawable.diamond -> {
                allDiamondCards.forEach { card->
                    cardItem(card)
                }
            }

            R.drawable.club -> {
                allClubCards.forEach { card->
                    cardItem(card)
                }
            }

            R.drawable.heart -> {
                allHeartCards.forEach { card->
                    cardItem(card)
                }
            }

            R.drawable.spade -> {
                allSpadeCards.forEach { card->
                    cardItem(card)
                }
            }
        }

    }
}

@Composable
fun Navigation() {
    val navController = rememberNavController()

    NavHost(navController = navController, startDestination = Screen.SplashScreen.route) {

        composable(Screen.SplashScreen.route) {
            SplashScreen(navController)
        }

        composable(Screen.TableAndPlayersScreen.route) { entry ->
            TableAndPlayersScreen(entry, navController)
        }

        composable(Screen.CardsScreen.route) {
            CardsScreen(navController)
        }
    }
}


sealed class Screen(val route: String) {
    object SplashScreen : Screen(route = "splash_screen")
    object TableAndPlayersScreen : Screen(route = "table_and_players_screen")
    object CardsScreen : Screen(route = "cards_screen")
}

@HiltViewModel
class CardsViewModel @Inject constructor() : ViewModel() {

    private val _chosenCardType = MutableStateFlow<Int>(0)
    val chosenCardType: StateFlow<Int> = _chosenCardType
    fun changeChosenCardType(newChosenCardType: Int) {
        _chosenCardType.value = newChosenCardType
    }

    private val _chosenCard = MutableStateFlow<Int>(0)
    val chosenCard: StateFlow<Int> = _chosenCard
    fun changeChosenCard(newChosenCard: Int) {
        _chosenCard.value = newChosenCard
    }

    private val _chosenCardValue = MutableStateFlow<String>("")
    val chosenCardValue : StateFlow<String> = _chosenCardValue
    fun changeChosenCardValue (newChosenCardValue : String) {
        _chosenCardValue .value = newChosenCardValue
    }

}

@HiltViewModel
class TableAndPlayersViewModel @Inject constructor() : ViewModel() {

    private val _playersAmount = MutableStateFlow<Int>(2)
    val playersAmount: StateFlow<Int> = _playersAmount
    fun changePlayersAmount(newPlayersAmount: Int) {
        _playersAmount.value = newPlayersAmount
    }

    private val _clickedCard = MutableStateFlow<Int>(0)
    val clickedCard: StateFlow<Int> = _clickedCard
    fun changeClickedCard(newClickedCard: Int) {
        _clickedCard.value = newClickedCard
    }

    private val _imageForFirst = MutableStateFlow<Int>(0)
    val imageForFirst: StateFlow<Int> = _imageForFirst
    fun changeImageForFirst(newImageForFirst: Int) {
        _imageForFirst.value = newImageForFirst
    }

    private val _imageForSecond = MutableStateFlow<Int>(0)
    val imageForSecond: StateFlow<Int> = _imageForSecond
    fun changeImageForSecond(newImageForSecond: Int) {
        _imageForSecond.value = newImageForSecond
    }

    private val _imageForThird = MutableStateFlow<Int>(0)
    val imageForThird: StateFlow<Int> = _imageForThird
    fun changeImageForThird(newImageForThird: Int) {
        _imageForThird.value = newImageForThird
    }


    private val _cardsOnTable = MutableStateFlow<ArrayList<String>>(arrayListOf("", "", ""))
    val cardsOnTable : StateFlow<List<String>> = _cardsOnTable
    fun changeCardsOnTable (newCardsOnTable : String, i: Int) {
        _cardsOnTable.value[i] = newCardsOnTable
    }

    private val _buttonNextClicked = MutableStateFlow<Boolean>(false)
    val buttonNextClicked : StateFlow<Boolean> = _buttonNextClicked
    fun changeButtonNextClicked (newButtonNextClicked: Boolean) {
        _buttonNextClicked.value = newButtonNextClicked
    }

    private val _chances =  MutableStateFlow<List<Int>>(listOf())
    val chances: StateFlow<List<Int>> = _chances
    fun changeChances (newChances: List<Int>) {
        _chances.value = newChances
    }

}
"""
    }
    
    static func dependencies(_ mainData: MainData) -> ANDData {
        return ANDData(mainFragmentData: ANDMainFragment(imports: "", content: """
    Navigation()
"""), mainActivityData: ANDMainActivity(imports: "", extraFunc: "", content: ""), themesData: ANDThemesData(isDefault: true, content: ""), stringsData: ANDStringsData(additional: """
    <string name="bg_image_desc">background image</string>
    <string name="text_splash_screen">Poker Calculator</string>
    <string name="cards_for_table_text">Select the cards on the table:</string>
    <string name="cards_on_table_text">Cards on the table</string>
    <string name="card_image_desc">card</string>
    <string name="players_for_table_text">Specify the number of players at the table (2 — 10):</string>
    <string name="icon_desc">icon</string>
    <string name="error_too_little_people">There cannot be less than two players</string>
    <string name="error_too_much_people">There cannot be more than ten players</string>
    <string name="next_button_text">Continue</string>
    <string name="calculate_button_text">Calculate</string>
    <string name="back_button">back</string>
    <string name="card_desc">card</string>
    <string name="back_text">Back</string>
    <string name="ok_text">Ok</string>
    <string name="choose_card_text">Card choice:</string>
    <string name="toast_text_chosen_card">The card is selected</string>
    <string name="error_not_all_card">All cards must be selected</string>
    <string name="error_not_different_cards">All cards must be different</string>
    <string name="player_number">player %1$d</string>
    <string name="card1">card 1 — %1$s</string>
    <string name="card2">card 2 — %1$s</string>
    <string name="person_chance">chances of winning: %d%%</string>
    <string name="hint">
        Hint:
        \\nc — clubs, h — hearts, d — diamonds, s — spades
        \\nt — 10, j — jack, q — queen, k — king, a — ace
    </string>
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

    api files('libs/PokerCalculator.jar')

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
    
    static let images = ["s8.webp", "ck.webp", "h8.webp", "d7.webp", "s4.webp", "h4.webp", "h5.webp", "s5.webp", "d6.webp", "h9.webp", "s9.webp", "cj.webp", "da.webp", "card_def.webp", "s10.webp", "dj.webp", "s2.webp", "ca.webp", "h2.webp", "bg.webp", "heart.webp", "c6.webp", "c10.webp", "c7.webp", "hq.webp", "diamond.webp", "sq.webp", "h3.webp", "s3.webp", "dk.webp", "plus_icon.webp", "hk.webp", "spade.webp", "sk.webp", "c8.webp", "d3.webp", "dq.webp", "c4.webp", "h10.webp", "d10.webp", "c5.webp", "minus_icon.webp", "d2.webp", "sj.webp", "c9.webp", "hj.webp", "club.webp", "ha.webp", "sa.webp", "c2.webp", "d9.webp", "h6.webp", "s6.webp", "d5.webp", "cq.webp", "d4.webp", "s7.webp", "h7.webp", "d8.webp", "c3.webp"]
}
