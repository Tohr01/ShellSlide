//
//  game-helper.swift
//  ShellSlide
//
//  Created by Carl Raabe on 25.03.22.
//

import Foundation

/**
 Checks if moves are possible in given matchfield
 
 - Parameter matchfield: The matchfield
 
 - Returns: true if other moves are possible
 */
func possible(_ matchfield: [[Int]]) -> Bool {
    return !matchfield.filter{$0.contains(0)}.isEmpty
}


/**
 Returns the biggest value in the complete matchfield
 
 - Parameter matchfield: The matchfield
 
 - Returns: The biggest value in the matchfield as Integer
 */
func get_highest_value(in matchfield: [[Int]]) -> Int {
    return matchfield.joined().sorted{$0 > $1}[0]
}
