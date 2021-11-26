import UIKit

struct Item {
    var price: Double
    var quanity: Int
}


var sum: (Double, Item) -> Double = { partialResult, item in
    return partialResult + item.price * Double(item.quanity)
}

struct ShoppingCart {
    private var items: [Item] = [] {
        // These go off when a property will be set
        // It takes in a closure that has a parameter called newValue
        // which is the value that it will be set to
        willSet {
            let currentTotal = self.items.reduce(0.0, sum)
            
            let newTotal = newValue.reduce(0.0, sum)
            
            print("WILL SET: Old Total: \(newTotal) | Current Total: \(currentTotal)")
        }
        
        // It takes in a closure that has a parameter called oldValue
        // which is the previous value
        didSet {
            let currentTotal = self.items.reduce(0.0, sum)
            
            let previousTotal = oldValue.reduce(0.0, sum)
            
            print("DID SET: Old Total: \(previousTotal) | New Total: \(currentTotal)")

        }
    }
    
    // This is an example of computed variable
    var total: Double {
        return self.items.reduce(0, sum)
    }
    
    mutating func addItem(_ item: Item) {
        self.items.append(item)
    }
}



var hammers = Item(price: 3, quanity: 3)
var milk = Item(price: 2, quanity: 3)

var cart = ShoppingCart()
// These will trigger the property observers
cart.addItem(hammers)
cart.addItem(milk)

// Static Properties
// Properties shared throughout the type

struct Car {
    // This creates a static property
    static var cars = 0
    
    var name: String
    
    init(name: String) {
        // This will increase the number of cars stored in the static property everytime a Car is created.
        Car.cars += 1
        self.name = name
    }
}

var beatle = Car(name: "32323")
var bug = Car(name: "323")
// There should be two cars
print("There are \(Car.cars) exist");

// Access Control

class Music {
    private var name: String
    internal var age: Int
    
    init(name: String, age: Int) {
        self.age = age
        self.name = name
    }
    
    func getName() -> String {
        return self.name
    }
}

var funMusic = Music(name: "Song", age: 33)

// This is allowed but not allowed outside of it's package
funMusic.age

// This code will fail
// funMusic.name

// This is an example of polyphorism
class Person {
    var name: String
    
    init(name: String) {
        self.name = name
    }
    
    func action() -> String {
        return "Action"
    }
}

class FirePerson: Person {
    
    override func action() -> String {
        return "Put out fire!"
    }
    
    func printAwesome() {
        print("AWESOME")
    }
}

class Coder: Person {
    override func action() -> String {
        return "Code!"
    }
    
    func printSpecial() {
        print("AWESOME")
    }
}

let people: [Person] = [Coder(name: "James"), FirePerson(name: "Ash"), Person(name: "Carson")]

// This uses a reduce and the fact that they are all Person types to loop through the code
print(people.reduce("", { acc, next in
    return acc + " | " + next.action()
}))

for person in people {
    // Typecaseing
    // Notice the as? casts it into a sub class
    if let fireperson = person as? FirePerson {
        fireperson.printAwesome()
    } else if let coder = person as? Coder {
        coder.printSpecial()
    }
    // You can also use as! but if you are wrong about the casting it will crash!
}

// Closure are functions that you can store in variable
// They are used everywhere with coco touch

let colors = ["red", "blue", "green"]

// You can use $0 to represent the first argument in a closure
// This is an example trailing closure syntax
let upperCaseColors = colors.map { $0.uppercased() }

print(upperCaseColors)


// Rewritten with trailing closure syntax
print(people.reduce("") { acc, next in
    return acc + " | " + next.action()
})
