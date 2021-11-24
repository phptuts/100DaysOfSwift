import UIKit

// Review Days variables vs constants

// creates a variable which can change
var age = 3
// change the value stored in the variable
age = 40

let name = "John"

// constants can't change
// name = "Fred"

// Use a constant where possible
// better for memory


// Data types

// Bools
// Bools can store true or false

var hasWallet = true
var payingCash: Bool
payingCash = false


// String
// Store a series of characters

var message = "Hello there!"
var data: String
data = "HELLO"

// Floats and Double
// Use doubles over floats because floats of have less accurancy

// Notice how the float cuts off the 3232
var cupsOfWater: Float
cupsOfWater = 323.23233232

var cupsOfWaterDouble: Double
cupsOfWaterDouble = 323.23233232



// Operators
// Swift has standard math operators

var b = 30
b += 30 // b = b + 30
b -= 30 // b = b - 30
b *= 40 // b = b * 40
b /= 40 // b = b / 40

// Swift has standard comparison operators

b > 40 // greater than
b < 40 // less than
b <=  40 // less than or equal to
b >= 40 // greater or equal to

// swift allows you add two strings together

var firstName = "Ash"
var lastName = "Johnson"
var fullName = firstName + " " + lastName

// swift equal comparison and not equal comparisons

var isRunning = true
!isRunning // will return false

// == compares what is on the righr and left are equal
isRunning == true // returns true because ture == true
// != comparse that right and left are not equal
isRunning != true // returns false


// String interpolation

// \(varname)

var color = "Blue"

var dogAge = 7

// you can do math operations in the \() and run functions inside \()
"My dog is \(dogAge) and in dog years is \(dogAge * 7) and has \(color.lowercased()) fur."
// Arrays

// How to create arrays

var names: [String] = []

// short hand

var birds = [String]()

// arrays by default expect to store the same datatype this is done for performance reasons

var guesses = ["Bill", "Carson", "Joe"]


// You can access elements from an array by it's index.
// Indexes start at 0

// If I want Joe from the guess I would 2

guesses[2]

// This would fail
//var guesses = ["Bill", 7, true]
// You can do this with the type any
var anyGuess: [Any] = [33, "Fred", true]


// Arrays can use + and +=
// Notice the Fred has to be array
guesses += ["Fred"]

// example of using the plus operator
var superGuessList = anyGuess + guesses

// You can use the type operator figure out the type of the array

type(of: guesses)

// Dictionaries
// Store key value pairs
// Make things more easy to read

// creates a dictionary where we the keys are string
// the values are also string
var dog = ["name": "Freshy", "Color": "yellow"]

// you access the values with [] syntax and the key
dog["name"]
dog["Color"]

// If
// used to determine whether something shoudl execute

var colorTest = "blue"

if colorTest == "blue" {
    print("You picked a blue color")
} else if colorTest == "red" {
    print("Great choice")
} else {
    print("You colors are off the else if map!")
}

// we use the not operator to test for false

var isTooYoung = false

if !isTooYoung {
    print("Please enter")
} else {
    print("Access Denied!")
}

// We can also use the && and || in if

if !isTooYoung && colorTest == "red" {
    print("Should not run because only the first thing evaluates to true")
}

if !isTooYoung || colorTest == "red" {
    print("Should run because isTooYoung is false which is what we are testing for.")
}

// Loops are used to things repeatedly

// Ranges create a series of number type

// Closed ranged

// Creates a series of number from 1 including 5
1...5

// Closed range will exclude the final number
// This will exclude 50 from the series
1..<50

// For loops can used to loop over number ranges or arrays
// should print i 5 times
for i in 1...5 {
    print(i)
}

let testers = ["john", "ash", "brandon"]

for name in testers {
    print("\(name) is my name")
}

// While loops are used for things that we don't know the end point of

var waiting = true
var counter = 1

while waiting {
    print("Counter = \(counter)")
    waiting = Bool.random()
    counter += 1
}

// You can break out of the loop with break keyword

// creates an infinite loop
// this break which will eventually get out the loop
while true {
    if Bool.random() {
        break
    }
    print("Looping around the Chrismas the tree")
}


// Use continue to skip over items or iterations in the loop
for item in ["food", "water", "gas", "beanbags"] {
    if item == "beanbags" {
        continue
    }
    
    print("Important item on list \(item)!")
}

// switch blocks

let dogPowerLevel = 33

// switch they don't use break but the fallthrough keyword to fall into the next condition
// This is the opposite of javascript
// All switch blocks have all conditions covered
// sometimes this is done with a default

switch dogPowerLevel {
case 1...50:
    print("Print once")
    fallthrough
case 1...40:
    // this will print because of the fall through
    // think of it as the opposite of break
    print("again")
default:
    print("NOTHING SHOULD PRINT")
}


