//
//  visual-helpers.swift
//  ShellSlide
//
//  Created by Tohr01 on 25.03.22.
//

import Foundation
import Chalk

/**
 - Parameter matchfield: The matchfield
 - Parameter move: The move to be made as a String (should be: "w", "a", "s" or "d")
 */
func handle_move(_ matchfield: [[Int]], move: String) -> [[Int]] {
    var mutable_matchfield = matchfield
    switch move {
    case "w":
        // Up
        mutable_matchfield = up(matchfield)
    case "a":
        // Left
        mutable_matchfield = left(matchfield)
    case "s":
        // Down
        mutable_matchfield = down(matchfield)
    case "d":
        // Right
        mutable_matchfield = right(matchfield)
    default:
        break
    }
    return mutable_matchfield
}

/**
 Formats the matchfield in a grid like pattern
 */
func print_matchfield(_ matchfield: [[Int]]) {
    let string_matchfield : [[String]] = matchfield.map { $0.map{String($0)} }
    let longest_char_num = String(Array(matchfield.joined()).sorted{$0 > $1}[0]).count
    let terminal_string_matchfield = string_matchfield.map{ str_arr -> [TerminalString] in
        return str_arr.map { str -> TerminalString in
            if str.count != longest_char_num {
                let space_amount = longest_char_num - str.count
                let space_arr = Array(repeating: " ", count: space_amount)
                
                if Int(str) != 0 {
                    return ck.green.bold.on(str.appending(space_arr.joined()))
                }
                return ck.on(str.appending(space_arr.joined()))
            }
            if Int(str) != 0 {
                return ck.green.bold.on(str)
            }
            return ck.on(str)
        }
    }
    
    for i in terminal_string_matchfield {
        for j in i {
            print(j, terminator: " ")
        }
        print()
    }
}


/**
 Prints colorful Shell Slide Logo
 */
func ascii_art() {
    let ascii = """
   _____ __         ____   _____ ___     __
  / ___// /_  ___  / / /  / ___// (_)___/ /__
  \\__ \\/ __ \\/ _ \\/ / /   \\__ \\/ / / __  / _ \\
 ___/ / / / /  __/ / /   ___/ / / / /_/ /  __/
/____/_/ /_/\\___/_/_/   /____/_/_/\\__,_/\\___/
                                              
"""
    print(
        ascii.map {
            ck.fg(.random).on(String($0))
        }
            .reduce(TerminalString()) {
                $0 + $1
            }
    )
}

/// Clears terminal screen
func clear_screen() {
    print("\u{001B}[2J")
}
