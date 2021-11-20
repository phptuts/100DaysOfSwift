import UIKit

// LOOPS can be used for ranges and arrays

// example

let ages = 1...6

for age in ages {
    print("Age \(age)")
}

let things = ["pens", "lamps", "bowls"]

for thing in things {
    print("Thing \(thing)")
}

// While loops work while a condition is true

var countDown = 10
while countDown > 0 {
    print(countDown)
    countDown -= 1
}

print("Final Count Down")

// Repeat Loop / do while

repeat {
    print("Print no matter what")
} while false

// Breaking loops

for stuff in ["ham", "slam", "cam"] {
    if stuff == "slam" {
        print("found \(stuff)")
        break
    }
    print("Discard \(stuff)")
}

// use a label + loop to break out of it
friendLoop: for friend in ["James", "Phil", "Fred"] {
    for family in ["Phil", "Tom", "Bill"] {
        if friend == family {
            print("\(friend) is a friend and family member")
            break friendLoop
        }
        print("Loop found nothing")
    }
}

// continue example skipping 3

for i in 1...4 {
    if i == 3 {
        continue
    }
    print(i)
}
