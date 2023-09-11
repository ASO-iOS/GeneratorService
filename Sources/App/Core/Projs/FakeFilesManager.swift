//
//  File.swift
//  
//
//  Created by admin on 08.09.2023.
//

import Foundation

struct FakeFilesManager {
    
    static let shared = FakeFilesManager()
    
    private init() {}
    
    func createDirectories() -> [String] {
        var dirs = Directories.allCases
        var dirList: [String] = []
        let dirCount = Int.random(in: 2...7)
        for _ in 0..<dirCount {
            let newDir = (dirs.randomElement() ?? dirs[0]).value
            dirList.append(newDir)
            dirs.removeAll(where: { $0.value == newDir})
        }
        return dirList
    }
    
    enum Directories: String, CaseIterable {
        case domain
        case main
        case present
        case utils
        case const
        case component
        case common
        case utility
        case wrapper
        case domainWrapper
        case secondView
        case mainAccess
        case access
        case viewModel
        case repo
        case cruiser
        case rate
        case findings
        case closures
        case volume
        case data
        case flash
        case finish
        case emit
        case level
        case process
        case fields
        case dto
        case random
        
        var value: String {
            switch self {
            case .domain: return "domain"
            case .main: return "main"
            case .present: return "present"
            case .utils: return "utils"
            case .const: return "const"
            case .component: return "component"
            case .common: return "common"
            case .utility: return "utility"
            case .wrapper: return "wrapper"
            case .domainWrapper: return "domain_wrapper"
            case .secondView: return "second_view"
            case .mainAccess: return "main_access"
            case .access: return "access"
            case .viewModel: return "view_model"
            case .repo: return "repo"
            case .cruiser: return "cruiser"
            case .rate: return "rate"
            case .findings: return "findings"
            case .closures: return "closures"
            case .volume: return "volume"
            case .data: return "data"
            case .flash: return "flash"
            case .finish: return "finish"
            case .emit: return "emit"
            case .level: return "level"
            case .process: return "preocess"
            case .fields: return "fields"
            case .dto: return "dto"
            case .random: return NamesManager.shared.directoryName
            }
        }
    }
    
    enum FileType: CaseIterable {
        case classFT
        case objectFT
        case sealedClassFT
        
        var name: String {
            switch self {
            case .classFT:
                return "class"
            case .objectFT:
                return "object"
            case .sealedClassFT:
                return "sealed class"
            }
        }
    }
    
    func fakeFileContent(packageName: String, endPoint: String, name: String) -> String {
         
        let funcs = self.functions.randomSample(count: Int.random(in: 5...30))
        var mFuncs: String {
            var result = ""
            funcs.forEach { item in
                result += item + "\n"
            }
            return result
        }
        return """
    package \(packageName).\(endPoint)
    
    \(funcImports)
    
    @Keep
    \(FileType.allCases.randomElement()?.name ?? "class") \(name) {
    \(mFuncs)
    }
    """
    }
    
    let funcImports = """
        import androidx.annotation.Keep
        import java.time.format.TextStyle
        import kotlin.math.pow
        import kotlin.random.Random
        """
    
    let composableImports = """
    import androidx.compose.foundation.lazy.LazyColumn
    import androidx.compose.foundation.lazy.items
    import androidx.compose.material3.Button
    import androidx.compose.material3.Text
    import androidx.compose.runtime.Composable
    """
    
    let composableFuncImports = """
        """
    
    let functions: [String] = [
        """
    fun generateRandomFileName(): String {
        val allowedChars = ('a'..'z') + ('A'..'Z')
        val fileNameLength = Random.nextInt(5, 10)
        return (1..fileNameLength)
            .map { allowedChars.random() }
            .joinToString("")
    }
""",
        """
    fun getConstantValue(): Int {
        return 42
    }
""",
        """
    fun throwException() {
        throw Exception("Exception")
    }
""",
        """
    fun infiniteRecursion() {
        infiniteRecursion()
    }
""",
        """
    fun alwaysFalse(): Boolean {
        return false
    }
""",
        """
    fun calculateSum(a: Int, b: Int): Int {
        val sum = a + b
        return sum
    }
""",
        """
    fun calculateProduct(a: Int, b: Int): Int {
        val product = a * b
        return product
    }
""",
        """
    fun calculateAverage(numbers: List<Int>): Double {
        val sum = numbers.sum()
        val average = sum.toDouble() / numbers.size
        return average
    }
""",
        """
    fun printFibonacciSeries(n: Int) {
        var a = 0
        var b = 1
        for (i in 1..n) {
            print("$a ")
            val next = a + b
            a = b
            b = next
        }
    }
""",
        """
    fun isPrimeNumber(num: Int): Boolean {
        if (num <= 1) {
            return false
        }
        for (i in 2 until num) {
            if (num % i == 0) {
                return false
            }
        }
        return true
    }
""",
        """
    fun findMax(numbers: List<Int>): Int {
        var max = Int.MIN_VALUE
        for (num in numbers) {
            if (num > max) {
                max = num
            }
        }
        return max
    }
""",
        """
    fun findMin(numbers: List<Int>): Int {
        var min = Int.MAX_VALUE
        for (num in numbers) {
            if (num < min) {
                min = num
            }
        }
        return min
    }
""",
        """
    fun reverseString(str: String): String {
        val reversed = StringBuilder()
        for (i in str.length - 1 downTo 0) {
            reversed.append(str[i])
        }
        return reversed.toString()
    }
""",
        """
    fun countVowels(str: String): Int {
        val vowels = listOf('a', 'e', 'i', 'o', 'u')
        var count = 0
        for (char in str) {
            if (char.toLowerCase() in vowels) {
                count++
            }
        }
        return count
    }
""",
        """
    fun calculateFactorial(n: Int): Long {
        if (n == 0 || n == 1) {
            return 1
        }
        return n * calculateFactorial(n - 1)
    }
""",
        """
    fun encryptString(str: String): String {
        var encrypted = ""
        for (char in str) {
            val encryptedChar = char.toInt() + 1
            encrypted += encryptedChar.toChar()
        }
        return encrypted
    }
""",
        """
    fun decryptString(str: String): String {
        var decrypted = ""
        for (char in str) {
            val decryptedChar = char.toInt() - 1
            decrypted += decryptedChar.toChar()
        }
        return decrypted
    }
""",
        """
    fun isPalindrome(str: String): Boolean {
        val reversed = str.reversed()
        return str == reversed
    }
""",
        """
    fun convertToBinary(num: Int): String {
        var quotient = num
        var binary = ""
        while (quotient > 0) {
            val remainder = quotient % 2
            binary = "$remainder$binary"
            quotient /= 2
        }
        return binary
    }
""",
        """
    fun printNumbers() {
        for (i in 1..100) {
            println(i)
        }
    }
""",
        """
    fun printAlphabet() {
        for (char in 'a'..'z') {
            println(char)
        }
    }
""",
        """
    fun printMultiplicationTable() {
        for (i in 1..10) {
            for (j in 1..10) {
                val product = i * j
                println("$i x $j = $product")
            }
        }
    }
""",
        """
    fun greet(name: String) {
        println("Hello, $name!")
    }
""",
        """
    fun printEvenNumbers() {
        for (i in 2..100 step 2) {
            println(i)
        }
    }
""",
        """
    fun printOddNumbers() {
        for (i in 1..99 step 2) {
            println(i)
        }
    }
""",
        """
    fun printSquareNumbers() {
        for (i in 1..10) {
            val square = i * i
            println("$i * $i = $square")
        }
    }
""",
        """
    fun printCubeNumbers() {
        for (i in 1..10) {
            val cube = i * i * i
            println("$i * $i * $i = $cube")
        }
    }
""",
        """
    fun printPowersOfTwo() {
        var power = 1
        while (power <= 10) {
            val result = 2.0.pow(power)
            println("2^$power = $result")
            power++
        }
    }
""",
        """
    fun printDivisibleNumbers() {
        for (i in 1..100) {
            if (i % 3 == 0 || i % 5 == 0) {
                println(i)
            }
        }
    }
""",
        """
    fun printPrimeNumbers() {
        for (i in 2..100) {
            var isPrime = true
            for (j in 2 until i) {
                if (i % j == 0) {
                    isPrime = false
                    break
                }
            }
            if (isPrime) {
                println(i)
            }
        }
    }
""",
        """
    val habbor = "lon"
    fun makeRt() {
        var a = 0
        val b = a + 1
        while (a == 0) {
            try {
                b * 3 +1
                a += 1
                a -= 1
            } catch (_: Exception) {}
        }
     }
""",
        """
    fun double(x: Int): Int {
        return 2 * x
    }
""",
        """
    fun powerOf(
        number: Int,
        exponent: Int
    ) {

    }
""",
        """
    open class A {
        open fun foo(i: Int = 10) { }
    }

    class B : A() {
        override fun foo(i: Int) {
            print("suck it")
        }
    }
""",
        """
    fun reformat(
        str: String,
        normalizeCase: Boolean = true,
        upperCaseFirstLetter: Boolean = true,
        divideByCamelHumps: Boolean = false,
        wordSeparator: Char = ' ',
    ) {
        var result = ""
        if (str.isNotBlank()) {
            if (normalizeCase) {
                result += wordSeparator
            }
        }
    }


    fun makeEasyWord(): String {
        val letter = reformat("sample").toString()
        return letter
    }
""",
        """
    fun <T> asList(vararg ts: T): List<T> {
        val result = ArrayList<T>()
        for (t in ts) // ts is an Array
            result.add(t)
        return result
    }

    val a = intArrayOf(1, 2, 3)
    val list = asList(-1, 0, *a.toTypedArray(), 4)

    class MyStringCollection {
        infix fun add(s: String) { /*...*/ }

        fun build() {
            this add "abc"
            add("abc")
        }
    }
""",
        """
    val eps = 1E-10

    private fun findFixPoint(): Double {
        var x = 1.0
        while (true) {
            val y = Math.cos(x)
            if (Math.abs(x - y) < eps) return x
            x = Math.cos(x)
        }
    }
""",
        """
    fun sumOddPositions(numbers: List<Int>): Int {
        return numbers.filterIndexed { index, _ -> index % 2 != 0 }.sum()
    }
""",
        """
    fun listToString(numbers: List<Int>): String {
        return numbers.joinToString(",")
    }
""",
        """
    fun absoluteValue(number: Int): Int {
        return if (number < 0) -number else number
    }
""",
        """
    fun isListEmpty(list: List<Any>): Boolean {
        return list.isEmpty()
    }
""",
        """
    fun toUpperCase(input: String): String {
        return input.toUpperCase()
    }
""",
        """
    fun getUniqueNumbers(numbers: List<Int>): List<Int> {
        return numbers.toSet().toList()
    }
""",
        """
    fun squareRoot(number: Double): Double {
        return Math.sqrt(number)
    }
""",
        """
    fun isStringEmpty(input: String): Boolean {
        return input.isEmpty()
    }
""",
        """
    fun calculateCubes(numbers: List<Int>): List<Int> {
        return numbers.map { it * it * it }
    }
""",
        """
    fun toBinary(number: Int): String {
        return Integer.toBinaryString(number)
    }
""",
        """
    fun filterNumbersDivisibleByThree(numbers: List<Int>): List<Int> {
        return numbers.filter { it % 3 == 0 }
    }
""",
        """
    fun numberToString(number: Int): String {
        return number.toString()
    }
""",
        """
    fun reverseStrings(strings: List<String>): List<String> {
        return strings.map { it.reversed() }
    }
""",
        """
    fun calculatePowerOfTwo(exponent: Int): Int {
        return 2.0.pow(exponent).toInt()
    }
""",
        """
    fun calculateSum(numbers: List<Int>): Int {
        return numbers.sum()
    }
""",
        """
    fun toLowerCase(input: String): String {
        return input.toLowerCase()
    }
""",
        """
    fun filterNumbersGreaterThanValue(numbers: List<Int>, value: Int): List<Int> {
        return numbers.filter { it > value }
    }
""",
        """
    fun getStringLengthWithoutSpaces(input: String): Int {
        return input.replace(" ", "").length
    }
""",
        """
    fun toDecimal(binary: String): Int {
        return Integer.parseInt(binary, 2)
    }
""",
        """
    fun calculateSquares(numbers: List<Int>): List<Int> {
        return numbers.map { it * it }
    }
""",
        """
    fun getFirstCharacter(input: String): Char {
        return input.first()
    }
""",
        """
    fun filterOddNumbers(numbers: List<Int>): List<Int> {
        return numbers.filter { it % 2 != 0 }
    }
""",
        """
    fun divide(a: Int, b: Int): Double {
        return a.toDouble() / b.toDouble()
    }
""",
        """
    fun getLastCharacter(input: String): Char {
        return input.last()
    }
""",
        """
    fun sum(a: Int, b: Int): Int {
        return a + b
    }
""",
        """
    fun isEven(number: Int): Boolean {
        return number % 2 == 0
    }
""",
        """
    fun findMaxValue(numbers: Array<Int>): Int {
        return numbers.maxOrNull() ?: throw IllegalArgumentException("Массив пуст")
    }
""",
        """
    fun stringToList(input: String): List<Char> {
        return input.toList()
    }
""",
        """
    fun concatenateStrings(strings: List<String>): String {
        return strings.joinToString(" ")
    }
""",
        """
    fun findMin(a: Int, b: Int): Int {
        return if (a < b) a else b
    }
""",
        """
    fun doubleNumbers(numbers: List<Int>): List<Int> {
        return numbers.map { it * 2 }
    }
""",
        """
    fun isNumeric(input: String): Boolean {
        return input.toDoubleOrNull() != null
    }
""",
        """
    fun factorial(n: Int): Int {
        return if (n == 0) 1 else n * factorial(n - 1)
    }
""",
        """
    fun getStringsLength(strings: List<String>): List<Int> {
        return strings.map { it.length }
    }
""",
        """
    fun isPrime(number: Int): Boolean {
        if (number <= 1) return false
        for (i in 2 until number) {
            if (number % i == 0) return false
        }
        return true
    }
""",
        """
    fun countWords(text: String): Int {
        return text.split(" ").count()
    }
""",
        """
    fun square(number: Int): Int {
        return number * number
    }
""",
        """
    fun removeDuplicates(numbers: List<Int>): List<Int> {
        return numbers.distinct()
    }
""",
        """
    fun isPositive(number: Int): Boolean {
        return number > 0
    }
""",
        """
    fun calculateProduct(numbers: List<Int>): Int {
        return numbers.reduce { product, element -> product * element }
    }
""",
        """
    fun getStringLength(input: String): Int {
        return input.length
    }
""",
        """
    fun isUniform(list: List<Int>): Boolean {
        return list.all { it == list[0] }
    }
""",
        """
    fun subtract(a: Int, b: Int): Int {
        return a - b
    }
""",
        """
    fun filterPositiveNumbers(numbers: List<Int>): List<Int> {
        return numbers.filter { it > 0 }
    }
""",
        """
    fun isPowerOfTwo(number: Int): Boolean {
        return (number and (number - 1)) == 0
    }
""",
        """
    fun findMinInt(list: List<Int>): Int {
        var min = Int.MAX_VALUE
        for (num in list) {
            if (num < min) min = num
        }
        return min
    }
""",
        """
    fun sumList(list: List<Int>): Int {
        var sum = 0
        for (num in list) {
            sum += num
        }
        return sum
    }

    fun calculateAverageValue(list: List<Int>): Double {
        val sum = sumList(list)
        return sum.toDouble() / list.size
    }

    fun calculateAverageNum(list: List<Int>): Double {
        val sum = sumList(list)
        return sum.toDouble() / list.size
    }
""",
        """
    fun factorialNum(n: Int): Int {
        var result = 1
        for (i in 1..n) {
            result *= i
        }
        return result
    }
""",
        """
    fun isPrimeFun(n: Int): Boolean {
        if (n <= 1) return false
        for (i in 2 until n) {
            if (n % i == 0) return false
        }
        return true
    }
""",
        """
    fun gcd(a: Int, b: Int): Int {
        if (b == 0) return a
        return gcd(b, a%b)
    }
""",
        """
    fun isPalindromeMain(str: String): Boolean {
        val reversed = str.reversed()
        return str == reversed
    }
""",
        """
    fun getRandomNumber(min: Int, max: Int): Int {
        return (min..max).shuffled().first()
    }
""",
        """
    fun mergeLists(list1: List<Int>, list2: List<Int>): List<Int> {
        val result = mutableListOf<Int>()
        result.addAll(list1)
        result.addAll(list2)
        return result
    }
""",
        """
    fun allMatch(list: List<Int>, condition: (Int) -> Boolean): Boolean {
        for (num in list) {
            if (!condition(num)) return false
        }
        return true
    }
"""
    ]
    
    let composableFunctions: [String] = [
            """
@Composable
fun StyledText(text: String, style: TextStyle) {
    Text(text = text)
}
""",
            """
@Composable
fun ClickableButton(text: String, onClick: () -> Unit) {
    Button(onClick = onClick) {
        Text(text = text)
    }
}
""",
            """
@Composable
fun ItemList(items: List<String>) {
    LazyColumn {
        items(items) { item ->
            Text(text = item)
        }
    }
}
""",
            """
@Composable
fun AlertDialog(message: String, onClose: () -> Unit) {
    androidx.compose.material.AlertDialog(
        onDismissRequest = onClose,
        buttons = {
            Button(onClick = onClose) {
                Text(text = "OK")
            }
        },
        text = { Text(text = message) }
    )
}
"""
    ]
}
