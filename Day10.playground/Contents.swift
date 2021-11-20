import UIKit

// You can create just like struct
// You must create it with an initializer

class Game {
    var name: String
    init(name: String) {
        self.name = name
    }
    
    // Classes can have functions just like structs
    func move(action: String) {
        print("Move \(action)")
    }
    
    // Classes can have deinit function that runs when the object is destroyed
    deinit {
        print("Game Over")
    }
}

// You can create an object just like struct
// The question mark after the makes the game variable nullable
var newGame: Game? = Game(name: "Simple Game")

// Classes can inherit from each other

class Checkers: Game {
    
    init() {
        // You always have to call the super method
        super.init(name: "Checkers")
    }
    
    // You can over ride the method in the child class
    // But the signature must match
    override func move(action: String) {
        print("Checker Player did \(action)")
    }
}

let checkerGame1 = Checkers()

// we have to use the question mark because it's nullable
newGame?.move(action: "moved to A3")

// Notice that move function the checker method
// is the one being called
checkerGame1.move(action: "moved to A3")

// Class are have shared memory

var checkersGame2 = checkerGame1
checkerGame1.name = "Chess"
// Notice how they equal each other thus sharing the same memory space
print("\(checkerGame1.name) == \(checkersGame2.name)")



// Notice the deinit is called when I set newGame to nil which is null in other languages
newGame = nil

// Final prevents child classes from being created

final class Chess: Game {
    init() {
        super.init(name: "Chess")
    }
}

// Example this is not allowed

//class SuperChess: Chess {
//
//}
