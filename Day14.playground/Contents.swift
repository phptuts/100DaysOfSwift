import UIKit

// Functions

// 1. start with func keyword
// 2. name of the function
// 3. ()
// 4. { code }

// Cool thing to note is you can have two functions with the
// same name that take in different parameters
func printAwesome() {
    print("Awesome")
}

func printAwesome(name: String) {
    print("Awesome, \(name)")
}

// Calling a function code below
// 1. Name
// 2. ()
// 3. Parameters inside -> ()
printAwesome()
printAwesome(name: "Ash")

// functions can have different parameter names
// one for external code calling the function and one for the internal code

// the first paramter name is external
// the second paraemter is internal
func sendEmail(to email: String) {
    print("Sending \(email) an email")
}

// notice this uses the to label
sendEmail(to: "bob@gmail.com")

// Functions can return data types
// Once you declare a function returns it must return that data type

func countCharacters(character: String, in word: String) -> Int {
    // This will filter all the letters in the word
    // That don't equal the character and return the count
    // You can't compare a Character with a string so you have convert it into a String
    // May not be efficient for memory
    return word.filter({c in character == String(c)}).count
}
let count = countCharacters(character: "i", in: "winning")
print("There are \(count) i in winning")

// Optionals are used to return nil or something
// It can happen when something can be blank or have something


func command(word: String, type: String) -> String? {
    if type == "reverse" {
        return String(word.reversed())
    }
    
    if type == "uppercase" {
        return word.uppercased()
    }

    return nil
}

if let result = command(word: "PEOPLE", type: "reverse") {
    print("People now is \(result)")
}

// notice that lowercase is not in the list
// this un wrapping will fail and will cause it fall into the else statement
if let dogName = command(word: "Freddy", type: "lowercase") {
    print("Dog name is \(dogName)!")
} else {
    print("Command does not exist")
}

// Optional Chaining

// This allows swift to execute your code until it finds a nil value
// Example

func funnyWord(word: String) -> String? {
    if word == "funny" {
        return "funny funny"
    }
    
    return nil
}

// Notice that we are filtering all the f and counting them regardless of case
let fCount = funnyWord(word: "funny")?.filter { String($0).lowercased() == "f" }.count

// Notice how letter count still returns an optional
print("Letter F Count == \(fCount)")

// Nil Collasing Operator
// if nil return use the default value on the right of the ??
// Example above

let cCount = funnyWord(word: "bird")?.filter { String($0).lowercased() == "c" }.count ?? 0

// Notice how this does not return an optional
// Making way better to print
print("Letter C Count == \(cCount)")

// Enums is a way to store a set defined values in a variables
// You can associate additional values with the variable

enum SocketError {
    case server
    case internet
    case ddos
}

enum SocketState {
    // This is an example of having  enum with an associative value
    case error(error: SocketError)
    case open
    case closed
    // This is an example of having  enum with an associative value
    case receive(message: String)
    case send(message: String)
}

let socketError = SocketState.error(error: .internet)
let socketMessage = SocketState.send(message: "Hello")
let socketRecieveMessage = SocketState.receive(message: "Hi")

func printSocketState(socket: SocketState) {
    switch socket {
    case .open:
        print("SOCKET OPEN")
    case .closed:
        print("SOCKET CLOSED")
        // We can use the where clause error to add an extra condition
    case .error(let error) where error == .ddos:
        print("Denial of service attack access denied")
    case .error:
        print("Network problems")
    case .receive(let message):
        print("Recieved \(message)")
    case .send(let message):
        print("Send \(message)")
    }
}

printSocketState(socket: socketError)
printSocketState(socket: socketMessage)
printSocketState(socket: socketRecieveMessage)

// Structs
// Are ways of modeling group data

struct Eye {
    // creates an initialize automatically
    var color: String
    var size: Int
    
    // Example of compute variable
    // meaning it's a function that gets treated a like variable
    var description: String {
        return "Eye is color \(color) and is size \(size) cm"
    }
    
    // example of creating a  method
    func sameColor(eye: Eye) -> Bool {
        return eye.color == self.color
    }
}

var eye = Eye(color: "green", size: 30)
// prints eye

// you can access properties in a struct with .property name
print(eye.color)

// calling a computed variable
print(eye.description)

// calling method on struct
print(eye.sameColor(eye: Eye(color: "blue", size: 30)))

// Swift Classes
// Classes must have initializer if they have variable, default values for class variables or nullable class variables

class Name {
    var first: String
    var last: String
    
    // Best way to do it
    init(first: String, last: String) {
        self.first = first
        self.last = last
    }
}



// Bad way of doing it!!
class NullableName {
    var first: String?
    var last: String?
}

// classes can inherit which can be used over ride methods

class Animal {
    var weight: Int
    var color: String
    
    init(weight: Int, color: String) {
        self.weight = weight
        self.color = color
    }
    
    func eat() {
        print("Eating")
    }
}

class Fish: Animal {
    
    var finColor: String
    
    // because we added finColor to fish we have to over ride the init function
    // the init function is like a constructor
    init(weight: Int, color: String, finColor: String) {
        self.finColor = finColor
        super.init(weight: weight, color: color)
    }
    
    // This will over ride eat method on animal class
    override func eat() {
        print("Eating Plankton")
    }
    
    // @objc means that objective / OS call this function
    @objc func called() {
        print("called")
    }
}

var animal = Animal(weight: 20, color: "red")
animal.eat()

var fish = Fish(weight: 30, color: "blue", finColor: "red")
fish.eat()
