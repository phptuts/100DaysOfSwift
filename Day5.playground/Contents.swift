import UIKit

// Functions

func hi() {
    print("Hi")
}

hi();


// Parameters

func printArea(w: Int, h: Int) {
    let area = w * h
    print("Area: \(area)")
}

printArea(w: 3, h: 5)

// Returning data

func area(w: Int, h: Int) -> Int {
    return w * h
}

print(area(w: 3, h: 44))


// Function parameters can have two names
// The "to" is the name used when calling the function
// The "email" is used inside the function
func replyEmail(to email: String)  {
    print("Sending email to \(email)")
}

replyEmail(to: "blah@gmail.com")

// omitting parameter names
// Once you remove the label you can't call the function with a label
func diameter(_ radius: Int) -> Int {
    return radius * 2
}

print(diameter(34))

// Functions can default parameters

func jokeRating(joke: String, isFunny: Bool = true)  {
    if (isFunny) {
        print("\(joke) HA HA")
    } else {
        print("\(joke) :(")
    }
}

jokeRating(joke: "One time this...")
jokeRating(joke: "These chickens were a ...", isFunny: false)

// Variadic Function
// Take in x number of arguments

func foods(foods: String...) {

    for food in foods {
        print(food)
    }
}

foods(foods: "chilli", "bread", "tacos")

// You mark that a func may throw an exception

// You can extend error
enum BadHash: Error {
    case too_easy;
}

func badData(hash: String) throws -> Bool {
    if (hash == "12345") {
        throw BadHash.too_easy
    }
    
    return true
}

do {
    try badData(hash: "12345")
    print("NOT REACHED")
} catch {
    print("Data failed")
}

// Swift makes all parameters constants by default
// if you want to change the value you must use inout which will change the value outside of the function


var name = "Fred"
print(name)
func changeName(oldName: inout String) {
    oldName = "Bill"
}

changeName(oldName: &name)

print(name)
