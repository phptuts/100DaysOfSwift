import UIKit

// Closures
// You can assign functions to a variable in swift
let work = {
    print("Working")
}

work()

// Closure parameters

let funkyName = { (name: String) in
    print("\(name)unk")
}


funkyName("Noah")

// Closures returning values

let isCoolWord = { (word: String) -> Bool in
    return word.contains("fun")
}

print(isCoolWord("funny"))
print(isCoolWord("red"))


// Closures as parameters

let operate = { (getThing: () -> String) in
    let thing = getThing()
    print("Operate \(thing)")
}

// If there are no parameters in the closure and it returns something
// use empty ()
let paino = { () -> String in
    return "Paino"
}

let dog = { () -> String in
    return "Dog"
}


operate(dog)
operate(paino)

// Trailing closure syntax

// If the last parameter is a closure
// Then we can elimate the ()
operate {
    return "red"
}
