import UIKit

var greeting = "Hello, playground"


extension String {
    func withPrefix(_ prefix: String) -> String {
        if self.hasPrefix(prefix) {
            return self
        }
        
        return "\(prefix)\(self)"
    }
}

let world = "World"
let fire = "fire wood"

print(world.withPrefix("Hello "))
print(fire.withPrefix("fir"))

extension String {
    func isNumeric() -> Bool {
        let num = Double(self)
        
        return num != nil
    }
}

print("33.33".isNumeric())
print("beans".isNumeric())

extension String {
    func addLineBreaks() -> [String] {
        self.split(separator: "\n").map({ String($0) })
    }
}

print("this\nIs\nanother\nline".addLineBreaks())
