//
//  MSweeperEngine.swift
//  minesweeper
//
//  Created by Karl Matti on 14.04.2020.
//  Copyright © 2020 karlmatti. All rights reserved.
//

import Foundation

class MSweeperEngine {
    //  State to check whether the game is currently played, won or lost. States: play, win, lose
    enum State {
        case play
        case win
        case lose
    }
    
    //  numberOfBombs calculated from percentageOfBombs given in 0.00 to 1.00 format where for example 0.50 is 50 %
    var numberOfBombs: Int
    var state: State
    /*
        gameField values are
        0-empty clicked, 1-one bomb nearby(bn), 2-two bn, 3-three bn,
        4-four bn, 5-five bn, 6-six bn, 7-seven bn,
        8-eight bn, 9-bomb clicked on, 10-bomb revealed not clicked on, 11-flag
    */
    var gameField: Array<Array<Int>>
    
    //  initializing gameField
    init(rowCount: Int, colCount : Int, percentageOfBombs: Double) {
        self.numberOfBombs = Int(Double(rowCount * colCount) * percentageOfBombs)
        self.state = .play
        self.gameField = Array(repeating: Array(repeating: 0, count: colCount), count: rowCount)
        
        /*for row in self.gameField {
            for col in row {
                print("colVal: \(col)")
            }
        }*/
        
    }
    func startGame() {
        
            
        self.gameField = generateGameField(gameFieldEmpty: self.gameField, numberOfBombs: self.numberOfBombs)
        
        for row in self.gameField {
            
            print("rowVal: \(row)")
            
        }
        
    }
   
    func generateGameField(gameFieldEmpty: Array<Array<Int>>,numberOfBombs: Int) -> Array<Array<Int>>{

        let rowCount = self.gameField.count
        let colCount = self.gameField[0].count
        let gameFieldBombs = self.generateGameBombs(gameFieldEmpty: self.gameField, numberOfBombs: numberOfBombs, rowCount: rowCount, colCount : colCount)
        let gameFieldBombsNumbers = self.generateGameNumbers(gameFieldBombs: gameFieldBombs)
        return gameFieldBombsNumbers
        
    }
    func generateGameBombs(gameFieldEmpty: Array<Array<Int>>, numberOfBombs: Int, rowCount: Int, colCount : Int) -> Array<Array<Int>>{
        var bombsLeft = numberOfBombs
        let rowCount = gameFieldEmpty.count
        let colCount = gameFieldEmpty[0].count
        var gameFieldBombs = gameFieldEmpty
        var gameBombLocations: Array<Int> = Array()
        while bombsLeft > 0{
            let newBombAt = Int.random(in: 0..<rowCount * colCount)
            if !gameBombLocations.contains(newBombAt) {
                gameBombLocations.append(newBombAt)
                bombsLeft -= 1
            }
            
        }
        var counter = 0
        
        for row in 0..<rowCount{
            for col in 0..<colCount {

                if gameBombLocations.contains(counter) {
                    gameFieldBombs[row][col] = 10
                }
                
                counter += 1
            }
        }
        return gameFieldBombs
    }
    
    func generateGameNumbers(gameFieldBombs: Array<Array<Int>>) -> Array<Array<Int>>{
        var gameFieldBombsNumbers = gameFieldBombs
        
        for row in 0..<gameFieldBombsNumbers.count{
            for col in 0..<gameFieldBombsNumbers[0].count {
                if gameFieldBombsNumbers[row][col] == 10 {
                    gameFieldBombsNumbers = updateBombNeighbours(gameFieldBombsNumbers: gameFieldBombsNumbers, row: row, col: col)
                }
            }
        }
        return gameFieldBombsNumbers
    }
    
    func updateBombNeighbours(gameFieldBombsNumbers: Array<Array<Int>>, row: Int, col: Int) -> Array<Array<Int>> {
        var gameFieldUpdatedNbrs = gameFieldBombsNumbers
        let maxRow = gameFieldBombsNumbers.count - 1
        let maxCol = gameFieldBombsNumbers[0].count - 1
        print("ubn row\(row)")
        print("ubn col\(col)")
        if row == 0 && col == 0 {  // corner
            gameFieldUpdatedNbrs[row + 1][col] += 1
            gameFieldUpdatedNbrs[row][col + 1] += 1
            
        } else if row == maxRow && col == maxCol {  // corner
            gameFieldUpdatedNbrs[row - 1][col] += 1
            gameFieldUpdatedNbrs[row][col - 1] += 1
            gameFieldUpdatedNbrs[row - 1][col - 1] += 1
        } else if row == 0 && col == maxCol {  // corner
            gameFieldUpdatedNbrs[row + 1][col] += 1
            gameFieldUpdatedNbrs[row][col - 1] += 1
            gameFieldUpdatedNbrs[row + 1][col - 1] += 1
        } else if row == maxRow && col == 0 {  // corner
            gameFieldUpdatedNbrs[row - 1][col] += 1
            gameFieldUpdatedNbrs[row][col + 1] += 1
            gameFieldUpdatedNbrs[row - 1][col + 1] += 1
        } else if row == 0 {  //  side
            gameFieldUpdatedNbrs[row + 1][col] += 1
            gameFieldUpdatedNbrs[row][col - 1] += 1
            gameFieldUpdatedNbrs[row][col + 1] += 1
            gameFieldUpdatedNbrs[row + 1][col - 1] += 1
            gameFieldUpdatedNbrs[row + 1][col + 1] += 1
        } else if col == 0 {  //  side
            gameFieldUpdatedNbrs[row + 1][col] += 1
            gameFieldUpdatedNbrs[row][col + 1] += 1
            gameFieldUpdatedNbrs[row - 1][col] += 1
            gameFieldUpdatedNbrs[row + 1][col + 1] += 1
            gameFieldUpdatedNbrs[row - 1][col + 1] += 1
        } else if row == maxRow {  //  side
            gameFieldUpdatedNbrs[row - 1][col] += 1
            gameFieldUpdatedNbrs[row][col - 1] += 1
            gameFieldUpdatedNbrs[row][col + 1] += 1
            gameFieldUpdatedNbrs[row - 1][col - 1] += 1
            gameFieldUpdatedNbrs[row - 1][col + 1] += 1
        } else if col == maxCol {  //  side
            gameFieldUpdatedNbrs[row + 1][col] += 1
            gameFieldUpdatedNbrs[row][col - 1] += 1
            gameFieldUpdatedNbrs[row - 1][col] += 1
            gameFieldUpdatedNbrs[row + 1][col - 1] += 1
            gameFieldUpdatedNbrs[row - 1][col - 1] += 1
        } else {  // other
            gameFieldUpdatedNbrs[row + 1][col] += 1
            gameFieldUpdatedNbrs[row][col - 1] += 1
            gameFieldUpdatedNbrs[row - 1][col] += 1
            gameFieldUpdatedNbrs[row][col + 1] += 1
            
            gameFieldUpdatedNbrs[row + 1][col + 1] += 1
            gameFieldUpdatedNbrs[row - 1][col + 1] += 1
            gameFieldUpdatedNbrs[row + 1][col - 1] += 1
            gameFieldUpdatedNbrs[row - 1][col - 1] += 1
            
            
        }
        for row in 0..<gameFieldUpdatedNbrs.count{
            for col in 0..<gameFieldUpdatedNbrs[0].count {
                if gameFieldUpdatedNbrs[row][col] > 8 {
                    gameFieldUpdatedNbrs[row][col] = 10
                }
            }
        }
        
        
        return gameFieldUpdatedNbrs
    }
    
    
    
    
}
