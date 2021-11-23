import UIKit

var greeting = "Hello, playground"

// Optionals are nullable types in swift
// Put a question mark after the type to make it nullable or nil

var chickens: Int? = nil

chickens = 30

// Unwrapping optional variables

var answer: Int? = Bool.random() ? nil : 30

// if let will be true if there is not nil being stored for the answer
if let unwrappedAnswer = answer {
    print("Answer is \(unwrappedAnswer)")
} else {
    print("Answer is unknown")
}

// Guard Lets are the prefered way to unwrap in my opinion
// Only can be used in the function
// Guard let allows the unwrapped to be used outside the function

enum LOGLEVEL {
    case HIGH
    case MEDIUM
    case LOW
    case UNKNOWN
}

func log(message: String, level: LOGLEVEL?) {
    guard let actualLevel = level else {
        print("LEVEL \(LOGLEVEL.UNKNOWN) MESSAGE: \(message)")
        // Must return here
        return
    }
    
    switch actualLevel {
    case LOGLEVEL.HIGH:
        print("RED ALERT \(message)")
    case LOGLEVEL.MEDIUM:
        print("ORANGE ALERT \(message)")
    case LOGLEVEL.LOW:
        print("INFO \(message)")
        
    default:
        print("UKNOWN \(message)")
    }

}

log(message: "HELLO", level: LOGLEVEL.MEDIUM)
log(message: "HI", level: nil)
log(message: "NO!!", level: LOGLEVEL.HIGH)

// Force unwrap
// only when you are sure it's safe

let userInput = "44"

// ! is the thing that forces the unwrap  if userInput was storing blue it would crash
let userNum = Int(userInput)!

// Forced unwrapped optional types
// Dangerous

var bearCount: Int! = nil

// this would crash because it's comparing nil to a number
//print(bearCount > 20)

bearCount = 30

print(bearCount)

// Swift has the ablity to make compare if  a variable is nil
// If the variable is nil use the value on the right side of the question mark

func randonNumMaybe() -> Int? {
    return Bool.random() ?
    nil : Int.random(in: 1...100)
}

let randomNum = randonNumMaybe() ?? 0

// if random is zero it's using the nulll colapsing operator
print("Randon Number = \(randomNum) ")

// Optional chaining allows you to call properties in an object that might be nil

let nums = Bool.random() ? "HELLO" : nil

// Use the question after the variable name to optional chain
print(nums?.count ?? "nums is nil")


// Try with optionals
// It will return an optional no matter what
// nil will be for failure


enum NETWORK_ERROR: Error {
    case NETWORK
    case JSON
}


// This will work sometimes and throw an error when it does not work
func sometimesWork() throws -> String {
    if Bool.random() {
        throw NETWORK_ERROR.NETWORK
    }
    
    return "data"
}

// This is where we unwrap the function
// try? will put nil an optional if it fails
if let data = try? sometimesWork() {
    print("It sometimesWork Worked: \(data)")
} else {
    print("SOMETIME WORK FAILED")
}

// You can also use try! which fail if the function fails
// Don't use this often or at all


//if let data = try! sometimesWork() {
//    print("It sometimesWork Worked: \(data)")
//} else {
//    print("SOMETIME WORK FAILED")
//}

// Nilable constructors for structs and class

struct Member {
    
    var age: Int
    var name: String
    
    init?(age: Int, name: String) {
        // If the age is under 18
        // Member constructor will return nil
        if age < 18 {
            return nil
        }
        self.age = age
        self.name = name
    }
}

let Tom = Member(age: 12, name: "TOM")
// This should not print because it will return nill
print(Tom ?? "SHOULD BE NIL")

let BILL = Member(age: 30, name: "BILL")
// Shoudl print Bill because Bill is over 30 and won't return nil
print(BILL ?? "SHOULD NOT PRINT")

// Typecasting in swift
// use as the as? which will return nil if the typecast fails

let wordNums: [Any] = [1, "hello", 2, "blue"]

for maybe in wordNums {
    // This is the typecasting
    if let num = maybe as? Int {
        print("Maybe is a number: \(num)")
    } else {
        print("Maybe is a string: \(maybe)")
    }
}
