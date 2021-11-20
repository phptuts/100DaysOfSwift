import UIKit

// Structs

struct Music {
    var song: String
    let time: Int
}

var goodMusic = Music(song: "Blues", time: 33)

goodMusic.song = "Jazz"

// This is not allowed because we used let in the struct so it's read only
//goodMusic.time = 44

// Computed Properties
// They allow you to create readonly variables on the fly

struct Wallet {
    var money: Int
    
    var isRich: Bool{
        return self.money > 100
    }
}

let rich = Wallet(money: 1000)
let notRich = Wallet(money: 10)

print("rich constant is \(rich.isRich)")
print("notRich constant is \(notRich.isRich)")

// Property Observers

struct Song {
    var name: String
    var time: Int {
        didSet {
            print("Song is is now at \(time)")
        }
    }
}

var happySong = Song(name: "Happy Song", time: 0)
// each time we update time it will call the didSet Closure thing
happySong.time = 30;
happySong.time = 40;

// Struct Functions / Methods
// you mark functions that mutate the struct

struct Volume {
    var level: Int
    mutating func up() {
        self.level += 1
    }
}

var volume = Volume(level: 30)

volume.up()
print("Level is \(volume.level)")

// Mutating Methods in Structs

struct TimeLeft {
    var timeLeft: Int
    mutating func countdown() {
        self.timeLeft -= 1
    }
}

var timeLeft = TimeLeft(timeLeft: 30)
timeLeft.countdown()
timeLeft.countdown()
print("The time left \(timeLeft.timeLeft) seconds")

// Structs Strings

var str = "BLUES"

str.count
str.append("c")
print(str)

// Arrays are also structs

var foods = ["Chilli", "Sandwiches"]

foods.count
foods.append("Eggs")
print(foods)
foods.firstIndex(of: "Eggs")

