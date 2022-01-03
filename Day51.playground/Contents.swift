import UIKit

let list = ["3", "non", "6", "5"]

// If the transformation fails it filter it out of the array and removes all
// This will print [3, 6, 5]
print(list.compactMap { Int($0) })  // $0 is the first argument in the array

// this print [Optional(3), nil, Optional(6), Optional(5)]
print(list.map { Int($0)})

// Filter
// Swift has standard filter method

// This will print [6, 5]
print(list.compactMap{ Int($0)}.filter{ $0 > 3})



// userdefault.standard.register defaults


// don't return optionals

// use an enum when you return instead of an optional


