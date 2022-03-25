//
//  game-algo.swift
//  ShellSlide
//
//  Created by Tohr01 on 21.03.22.
//

import Foundation

/**
 Slides every row in the matchfield to the left
 
 - Parameter matchfield: The matchfield
 - Returns: The modified matchfield
 */
func left(_ matchfield: [[Int]]) -> [[Int]] {
    return matchfield.map{left_slide($0)}
}
/**
 Slides every row in the matchfield to the right
 
 - Parameter matchfield: The matchfield
 - Returns: The modified matchfield
 */
func right(_ matchfield: [[Int]]) -> [[Int]] {
    return matchfield.map{left_slide($0.reversed()).reversed()}
}

/**
 Slides every colum in the matchfield down
 
 - Parameter matchfield: The matchfield
 - Returns: The modified matchfield
 */
func down(_ matchfield: [[Int]]) -> [[Int]] {
    let transposed_matchfield =  right(transpose(matchfield))
    return transpose(transposed_matchfield)
}

/**
 Slides every colum in the matchfield up
 
 - Parameter matchfield: The matchfield
 - Returns: The modified matchfield
 */
func up(_ matchfield: [[Int]]) -> [[Int]] {
    let transposed_matchfield =  left(transpose(matchfield))
    return transpose(transposed_matchfield)
}

/**
 Transposes a two dimensional array
 
 - Parameter arr: The array
 
 - Returns: The transposed array
 */
func transpose(_ arr: [[Int]]) -> [[Int]] {
    var result_arr : [[Int]] = Array(repeating: [Int](repeating: 0, count: arr.count), count: arr[0].count)
    
    for i in arr.indices {
        for j in arr[0].indices {
            result_arr[j][i] = arr[i][j]
        }
    }
         
    return result_arr
}

/**
 Moves the values in a given array to the left and merges two values that are either directly next to each other or separated by zeros
 A number can only be merged once
 
 Example:
 [2, 0, 0, 2, 2, 4] will be -> [4, 2, 4, 0, 0, 0]
 
 - Parameter arr: The array
 - Returns: Merged array
 */
func left_slide(_ arr: [Int]) -> [Int] {
    // Check if arr is empty
    if arr.isEmpty { return [] }
    
    // Make arr mutable
    var mutable_arr : [Int] = []
    
    // Seperate 0's and other numbers
    var zero_arr = arr.filter{$0 == 0}
    mutable_arr = arr.filter{$0 != 0}
    
    // Keeps track of the last index that has been merged
    var last_merge_index = 0
    for _ in arr {
        // Loop through the array from the last index that has been merged to the end of the array
        for i in last_merge_index..<mutable_arr.endIndex {
            let e = mutable_arr[i]
            // Checks if element at next index is same as the current one
            if i != mutable_arr.endIndex-1 && e == mutable_arr[i+1] {
                // Merge elements and break
                mutable_arr = merge(index1: i, index2: i+1, in: mutable_arr)
                last_merge_index = i+1
                break
            }
        }
    }
    
    // Restore original length of arr by appending 0's
    zero_arr.append(contentsOf: Array(repeating: 0, count: arr.count-zero_arr.count-mutable_arr.count))
    
    // Append 0's back to arr
    mutable_arr.append(contentsOf: zero_arr)
    
    return mutable_arr
}

func merge(index1: Int, index2: Int, in arr: [Int]) -> [Int] {
    // Make array mutable
    var mutable_arr = arr
    // Calculate new value
    let merged_val = arr[index1] * 2
    // Replace index by new index
    mutable_arr[index1] = merged_val
    // Remove index2 in array
    mutable_arr.remove(at: index2)
    
    return mutable_arr
}
