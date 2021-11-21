import UIKit

// Protocols
// force structs and classes to implement functions and properties
protocol Color {
    var color: String { get set}
}

// Dog implements Color Struc
struct Dog: Color {
    var color: String
}

var beagle = Dog(color: "red")

// Used as type hinting for function
func printColorObject(obj: Color) {
    print("The color is \(obj.color)");
}

// Example here
printColorObject(obj: beagle)

// Protocols can be inherit or be combined with each other

enum LogLevel{
    case INFO
    case WARNING
    case CRITICAL
}

protocol Logger {
    func log(message: String, level: LogLevel)
}

protocol Process {
    func process(item: String) -> String
}

protocol WhoAmI {
    var id: String { get }
}

// StringMachine inherits from multiple protocols
protocol StringMachine: Logger, Process, WhoAmI {
}

// This struct implements them
struct StringHasher: StringMachine {
    func log(message: String, level: LogLevel) {
        print("LEVEL \(level) : \(message)")
    }
    
    func process(item: String) -> String {
        self.log(message: "processing: \(item)", level: LogLevel.INFO)
        return String(item.hash)
        
    }
    
    var id: String
}

var hasher = StringHasher(id: "Mash Hash")

// This prints the has value of the string
print(hasher.process(item: "Hello"))

// Extensions
// They allow you add existing properties onto a class or struct

// You can only add computed properties
extension String {
    var numberOfVowels: Int {
        Array(self).reduce(0) { partialResult, next in
            if ["a", "e", "i", "o", "u", "y"].contains(next) {
                return partialResult + 1
            }
            return partialResult
        }
    }
    
    func evenWord() -> Bool {
        return self.count % 2 == 0
    }
}

let word = "cares"

// Should print 2 vowels
print(word.numberOfVowels)
// should print false because there are five characters
print(word.evenWord())

// Protocol + Extensions
// They must share the same name

protocol Laugh {
    func laugh()
    var word: String { get set }
}

extension Laugh {
    
    func laugh()  {
        print("HA HA \(self.word)")
    }
}

struct FunnyPerson: Laugh {
    
    
    var word: String
    
}

let mark = FunnyPerson(word: "No soap radio")

mark.laugh()
