import UIKit

// You can create our own initializer with structs

struct Dog {
    var name: String
    
    var age = 0
    
    init(name: String) {
        self.name = name
    }
}

var fred = Dog(name: "Blue")
fred.age = 30

// Self refers the object itself
// Helpful in initializers

struct Road {
    var length: Int
    let color = "Black"
    
    init (length: Int) {
        // self.length is the object being created
        self.length = length
    }
}

// Lazy Properties
// They are loaded into memory when they are accessed
// Useful for big object I would imagine

struct Friend {
    var name: String
    // the lazy keyword will keep the object as small as possible an won't load an array into memory
    // The lazy property must have a default value attached to the struct
    // Ask Jason about lazy operators
    lazy var friendList = ["Ash", "Becca"]
    
}

var amy = Friend(name: "Amy")
// Now it's loaded into memory
print(amy.friendList)

// Structs Static
// The static is shared across all the over objects

struct Register {
    static var total = 0
    var cash: Int
    
    init(cash: Int) {
        Register.total += cash
        self.cash = cash
    }
    
    mutating func addMoney(money: Int) {
        Register.total += money
        self.cash += money
    }
}

var register1 = Register(cash: 100)
var register2 = Register(cash: 20)
var register3 = Register(cash: 30)

print("Total Money \(Register.total)")
register1.addMoney(money: 30)
print("Total Money \(Register.total)")

// Access Control

struct User {
    private var password: String
    private var username: String
    
    
    func getUserName() -> String {
        return self.username
    }
    
    func getPasswordHash() -> String {
        // Practicing closures
        // with reduce which should do what joined does.  I could not get joined to work for some reason
        // Ask Jason about why joined did not work
        return self.password.shuffled().reduce("", {
            (acc: String, next: Character) in
        return "\(acc)\(next)"
})
    }
    
    init(password: String, username: String) {
        self.username = username
        self.password = password
    }
}

var user = User(password: "BLUE MOON", username: "FRED")
print(user.getUserName())
print(user.getPasswordHash())
