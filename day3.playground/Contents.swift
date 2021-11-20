import UIKit

var greeting = "Hello, playground"

// Basic Math

let num1 = 3
let num2 = 4

// add
let res1 = num1+num2
// multiple
let res2 = num1*num2
// divide
let res3 = num1 / num2
// remainer
let res4 = num2 % num1

// overload operator like plus

let str1 = "blue"
let str2 = "red"
let strResult = str1 + str2


// You can even do it with array
// note the types must be the same
let list1 = ["balls", "plates"]

let list2 = ["cars", "mice"]

let nouns = list1 + list2

// comparison

let teamB = 32
let teamC = 30

// compares that teamB equals teamC
teamB == teamC

// compars they are not the same

teamB != teamC

let score = 30
// comparing greater than / less than
teamB > score
teamB >= score
teamB < score
teamB <= score

let b = "joe"
let c = "ash"

// This is legal because the alphabet has a orer

// a is less than b
b > c

// combining conditions

let apples = 3
let oranges = 4

// If Blocks

if apples > oranges {
    print("apples bigger")
}

// and stops when it reaches a condition that is not true
if apples > 3 && oranges < 10 {
    print("This won't print")
}

// or will keep going until it finds a condition that is true
if apples > 3 || oranges < 10 {
    print("Works")
}




// Ternary operator
// quick if else statement
let age = 12
print(age > 18 ? "Enter" : "Too Young")


// Switch

let name = "John"


switch name {
case "Ash":
    print("What up!")
    
    // Execute both because it fall through
case "John":
    print("Hello bbf!")
    fallthrough

default:
    print("Yo")
}

let weather = "sunny"

switch weather {
case "rain":
    print("Bring an umbrella")
case "snow":
    print("Wrap up warm")
case "sunny":
    print("Wear sunscreen")
    fallthrough
default:
    print("Enjoy your day!")
}


// range operators ...
// range is a series of integers between two numbers

// exmaple below stors 1,2,3,4,5


let range = 1...5

print(range)
