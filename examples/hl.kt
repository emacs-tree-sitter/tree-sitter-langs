interface ExampleInterface {
    fun exampleMethod(): String
}

data class ExampleDataClass(val sample: String, val count: Int)

@Singleton
class ExampleClass : ExampleInterface {

    @Inject lateinit var service: SomeService

    val data: List<Int> = listOf(1, 2, 4)

    init {}

    override fun exampleMethod(): String {
        val result = data.map { it * 2 }.sum()
        return "result: $result"
    }
}

fun ExampleClass.exampleExtantion1(argument: String): String {
    return "var $argument, expression: ${ 1 + 1 }"
}

fun ExampleClass.exampleExtantion2(argument: String) = "$argument"

fun receiverFunction(init: ExampleClass.() -> Unit): ExampleClass {
    val example = ExampleClass()
    example.init()
    return example
}
