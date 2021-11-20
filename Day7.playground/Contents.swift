import UIKit

// You can pass a closure that requires a parameter

func todo(items: [String], process: (String) -> Void) {
    for item in items {
        process(item)
    }
}

todo(items: ["read", "write", "sing"]) { (item: String) in
    print("TODO: \(item)")
}

//  You can use short to test things out

func funkyPrint(words: String, funPrint: (String) -> String) {
    let word = funPrint(words)
    print(word)
}

funkyPrint(words: "Hello World") {
    // You don't need the return or parameter
    // The first parameter is replace $0
    // Return is assumed because there is only line in the closure
     "\($0) crazy func"
}

// You can use multiple parameters in closure definition

func driveMe(goto: (String, Int) -> String) {
    print("DRivinG")
    goto("Red laKe", 30)
    print("DRIVE ComPLete")
}

driveMe {
    "Diving at speed \($1) to \($0)"
}

// function can return closure

func queueWork(item: String) -> (String) -> Void {
    return {
        print("Work Queued: \(item) when \($0)")
    }
    
}

let queuePayBills = queueWork(item: "Pay Bills")
 
queuePayBills("today")

// Captured values
// Functions save their own state

func call(phone: String) -> () -> Void {
    var calling = 0
    print("calling")
    return {
        calling += 1
        print("Called times \(calling)")
        print("Calling \(phone)")
    }
}

let call555 = call(phone: "555-5555")
call555()
call555()
call555()


