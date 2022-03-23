//
//  main.swift
//  ShellSlide
//
//  Created by Tohr01 on 19.03.22.
//

import Foundation
import Chalk

var matchfield : [[Int]] = []
var highscore = 0
var current_score = 0
var game_loaded = false

// Retrieve highscore from UserDefaults
if let saved_highscore = UserDefaults.standard.value(forKey: "highscore") as? Int {
    highscore = saved_highscore
}

// Retrieve saved game
if let saved_game = UserDefaults.standard.value(forKey: "saved_game") as? [[Int]], let saved_score = UserDefaults.standard.value(forKey: "saved_score") as? Int {
    var decision : String? = nil
    // Handle load, proceed or delete savestate
    repeat {
        print(ck.bold.blueBright.on("Saved game with a score of \(saved_score) found."))
        print("Do you want to load it? [y(es) / n(o) / d(elete)]")
        let input = readLine()
        // Check validity of answer
        let valid_chars = ["y", "n", "d"]
        if let input = input?.lowercased() {
            if input.count == 1 && valid_chars.contains(where: input.contains) {
                decision = input
            }
        }
    } while decision == nil
    
    switch decision! {
    case "y":
        // Load savestate
        matchfield = saved_game
        current_score = saved_score
        game_loaded = true
    case "d":
        // Delete savestate
        UserDefaults.standard.removeObject(forKey: "saved_game")
        UserDefaults.standard.removeObject(forKey: "saved_score")
    default:
        // Continue with new game
        break
    }
}

/**
 Generates rectangular two-dimensional-array containing 0's with the given size
 
 - Parameter size: The size of the array
 
 - Returns: The array
*/
func generate_matchfield(size: Int) -> [[Int]] {
#warning("Handle size 0")
    var result : [[Int]] = []
    for _ in 0..<size {
        result.append(Array(repeating: 0, count: size))
    }
    return result
}

/**
 Randomly spawns a new element at a free location (free location = 0) in the given matchfield
 
 - Parameter matchfield: The matchfield
 
 - Returns: The modified matchfield
 */
func spawn_new_element(in matchfield: [[Int]]) -> [[Int]] {
    var new_matchfield = matchfield
    
    let available_spawn_points : [(Int, Int)] = {
        Array(matchfield.enumerated().map { (row_index, row) in
            row.enumerated().map { (colum_index, colum) -> (Int, Int)? in
                if colum == 0 {
                    return (row_index, colum_index)
                }
                return nil
            }
        }.joined())
    }().compactMap{$0}
    
    let new_spawn_pos = available_spawn_points.randomElement()!
    new_matchfield[new_spawn_pos.0][new_spawn_pos.1] = 2
    
    return new_matchfield
}

// Checks if a save game has already be loaded
if !game_loaded {
    // Clear screen
    print("\u{001B}[2J")
    
    print("Please enter the desired size of the matchfield: ")
    let size = readLine()
    
    // Generate matchfield with the given size
    if let size = size {
        matchfield = generate_matchfield(size: Int(size) ?? 4)
    } else {
        matchfield = generate_matchfield(size: 4)
    }
    
    // Spawn two pieces
    matchfield = spawn_new_element(in: matchfield)
    matchfield = spawn_new_element(in: matchfield)
}
// Clear screen
print("\u{001B}[2J")
// Checks if moves are still possible
while possible(matchfield) {
    // Prints Shell Slide Logo
    ascii_art()
    current_score = get_highest_value(in: matchfield)
    // Checks if the current score is higher than the highscore
    if current_score > highscore {
        highscore = current_score
        // Save new highscore
        UserDefaults.standard.set(highscore, forKey: "highscore")
    }
    
    print(ck.bold.on(" 👑 HIGHSCORE: \(highscore) 🎯 SCORE: \(current_score) "))
    
    print(ck.blink.on("Use W A S D to navigate"))
    print("\n")
    
    print_matchfield(matchfield)
    
    print("\n")
    print("[Type 'Save' to save the game and resume next time]")
    print("What is your next move? [ENTER]")
    
    // Request next move from the player
    var next_move : String? = nil
    repeat {
        let input = readLine()
        if let input = input?.lowercased() {
            let valid_chars = ["w", "a", "s", "d"]
            if input.count == 1 && valid_chars.contains(where: input.contains) {
                next_move = input
            } else if input == "save" {
                // Clear screen
                print("\u{001B}[2J")
                print("Saving the game and quitting...")
                UserDefaults.standard.set(matchfield, forKey: "saved_game")
                UserDefaults.standard.set(current_score, forKey: "saved_score")
                print("The application will quit now... See you soon")
                sleep(5)
                exit(0)
            }
        }
    } while next_move == nil
    matchfield = handle_move(matchfield, move: next_move!)
    matchfield = spawn_new_element(in: matchfield)
    
    // Clear screen
    print("\u{001B}[2J")
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
 Checks if moves are possible in given matchfield
 
 - Parameter matchfield: The matchfield
 
 - Returns: true if other moves are possible
 */
func possible(_ matchfield: [[Int]]) -> Bool {
    return !matchfield.filter{$0.contains(0)}.isEmpty
}

/**
 Prints Shell Slide Logo
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

func get_highest_value(in matchfield: [[Int]]) -> Int {
    return matchfield.joined().sorted{$0 > $1}[0]
}
