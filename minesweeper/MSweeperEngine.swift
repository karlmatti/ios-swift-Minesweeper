//
//  MSweeperEngine.swift
//  minesweeper
//
//  Created by Karl Matti on 14.04.2020.
//  Copyright © 2020 karlmatti. All rights reserved.
//

import Foundation

class MSweeperEngine {
    enum State {
        case play
        case win
        case lose
    }
    
    let gameField: Array<Array<Int>>
    let numberOfBombs: Int
    var state: State
    

    
    init?(x: Int, y : Int, percentageOfBombs: Double) {
        self.gameField = Array(repeating: Array(repeating: 0, count: y), count: x)
        self.numberOfBombs = Int(Double(x * y) * percentageOfBombs)
        self.state = .play
        print("Hello World!")
        /*
        for i in gameField {
            for j in i {
                print("j: \(j)")
                
            }
            
        }*/
    }
    
    
    
    
    
    
    
}
