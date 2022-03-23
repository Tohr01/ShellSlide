//
//  game-algo.swift
//  ShellSlide
//
//  Created by Tohr01 on 21.03.22.
//

import Foundation

func left(_ matchfield: [[Int]]) -> [[Int]] {
    return matchfield.map{left_slide($0)}
}

func right(_ matchfield: [[Int]]) -> [[Int]] {
    return matchfield.map{left_slide($0.reversed()).reversed()}
}

func down(_ matchfield: [[Int]]) -> [[Int]] {
    let transposed_matchfield =  right(transpose(matchfield))
    return transpose(transposed_matchfield)
}

func up(_ matchfield: [[Int]]) -> [[Int]] {
    let transposed_matchfield =  left(transpose(matchfield))
    return transpose(transposed_matchfield)
}

func transpose(_ arr: [[Int]]) -> [[Int]] {
    var result_arr : [[Int]] = Array(repeating: [Int](repeating: 0, count: arr.count), count: arr[0].count)
    
    for i in arr.indices {
        for j in arr[0].indices {
            result_arr[j][i] = arr[i][j]
        }
    }
         
    return result_arr
}


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
