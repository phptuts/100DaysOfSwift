import UIKit

// Arrays

// Most common type
// Stores order

let forecastTemp = [77, 32.3, 43.3]

print("Day 1: \(forecastTemp[0])")
print("Day 2: \(forecastTemp[1])")
print("Day 3: \(forecastTemp[2])")

// This would cause a blowup because the array does not have 4 elements forecastTemp[2]

// Sets

// Store unique data only
// Use sets for unique data

let fruit = Set(["apples", "bananna", "pears", "apples"])

// Should only print 3 items dupes not allowed
print(fruit)

// Tuples
// Store a set amount of data
// The values can change but not the value types
// Use tuples for structure data

let personB = (firstName: "Amy", lastName: "Smith", age: 34)

// These will print the same thing
// You can use the labels or the numbering order
print(personB.firstName)
print(personB.0)


// Dictionaries store key value pairs like json
// The big difference is that you can't free form
// So if your first key is a string and your first value is string all other items must follow that convention

let hotelInfo = ["color": "red", "bricks": "green"]
let moo = ["nothing": "here"]
// Notice dictionaries return an optional
// because the key might not be there consider using a gaurd
print(hotelInfo["color"])


func printColor(dict: [String: String]) -> String {
    guard let color = dict["color"] else {
        return "bad key"
    }
    
    return "Color: \(color)"
}

// will print the color
print(printColor(dict: hotelInfo))
print(printColor(dict: moo))

// When accessing a dictionary you specify a default value

// print nil because of no default value
print(hotelInfo["blue"])
// prints Moo because of the default value
print(hotelInfo["blue", default: "Moo"])

// Empty Sets

var emptyStringSet = Set<String>()


//Emtpy Arra
var emptyIntArray = [Int]()
emptyIntArray.append(3)

var altSyntaxEmptyArray = Array<Int>()


// Empty Dictionary
var emptyDictionaryString = [String: Int]()
var altSyntaxEmptyDictionary = Dictionary<String, Int>()
emptyDictionaryString["Blue Team"] = 7

// Sets

// No alt syntax
var emptySet = Set<String>()


// Emuns

// Standardized way of representing things in code
// to prevent mistyping

enum FruitTypes {
    case bananna
    case pear
}

print (FruitTypes.bananna)

// Store values with each case
enum CarType: Int {
    case Ford = 3
    case Chevy = 5
}



print(CarType.Ford)

// Is the same as this
// Notice this way provides an optional which is bad
print(CarType(rawValue: 3))


// Enums can have associative values as well

enum Dishwasher {
    case WASH(dishes: Int)
    case DRY(time: Int)
}

let dishwasherState = Dishwasher.DRY(time: 10)

