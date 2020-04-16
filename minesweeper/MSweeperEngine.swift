//
//  MSweeperEngine.swift
//  minesweeper
//
//  Created by Karl Matti on 14.04.2020.
//  Copyright © 2020 karlmatti. All rights reserved.
//

import Foundation

class MSweeperEngine {
    
    
    //  numberOfBombs calculated from percentageOfBombs given in 0.00 to 1.00 format where for example 0.50 is 50 %
    var numberOfBombs: Int
    var state: State = .play
    /*
        gameField values are
        0-zero bombs nearby(bn), 1-one bn, 2-two bn, 3-three bn,
        4-four bn, 5-five bn, 6-six bn, 7-seven bn, 8-eight bn,
        9-bomb(clicked), 10-bomb(normal)
    */
    var gameField: Array<Array<Int>>
    //  revealedGameField values are 0-not revealed tile, 1-revealed tile, 2-flag
    var revealedGameField: Array<Array<Int>>
    
    var flagCount: Int = 0
    
    //  initializing gameField
    init(rowCount: Int, colCount : Int, percentageOfBombs: Double) {
        self.numberOfBombs = Int(Double(rowCount * colCount) * percentageOfBombs)
        self.state = .play
        self.gameField = Array(repeating: Array(repeating: 0, count: colCount), count: rowCount)
        self.revealedGameField = Array(repeating: Array(repeating: 0, count: colCount), count: rowCount)
        
    }
    func getState() -> (Array<Array<Int>>, Array<Array<Int>>, State, Int) {
       /*
        print("getstate() -> revealedGameField")
        for row in self.revealedGameField {
            print("\(row)")
        }
        print("getstate() -> gameField")
        for row in self.gameField {
            print("\(row)")
        }*/
        calcWinningState()
        let bombsLeft = self.numberOfBombs - self.flagCount
        return (self.gameField, self.revealedGameField, self.state, bombsLeft)
    }
    func calcWinningState(){
        var openedTilesCount = 0
        for row in self.revealedGameField{
            for tile in row{
                if tile == 1 {
                    openedTilesCount += 1
                }
            }
        }
        let overallTilesCount = self.gameField.count * self.gameField[0].count
        let winnerTilesCount = overallTilesCount - self.numberOfBombs
        if openedTilesCount == winnerTilesCount{
            self.state = .win
        }
     
    }
    func startGame() -> (Array<Array<Int>>, Array<Array<Int>>, Int){
        
            
        self.gameField = generateGameField(gameFieldEmpty: self.gameField, numberOfBombs: self.numberOfBombs)
        self.flagCount = 0
        /*
        print("Initial gameField:")
        for row in self.gameField {
            print("\(row)")
        }
        print("Selecting 2,2")
        //handleSelection(row: 1, col: 1, flag: false)
        handleSelection(row: 2, col: 2, flag: false)
        //handleSelection(row: 3, col: 3, flag: false)
        print("gameField")
        for row in self.gameField {
            print("\(row)")
        }
        print("revealedGameField")
        for row in self.revealedGameField {
            print("\(row)")
        }*/
        return (self.gameField, self.revealedGameField, self.numberOfBombs - self.flagCount)
    }
    
    func handleSelection(row: Int, col: Int, flag: DarwinBoolean) {
        print("handleSelection(row: \(row), col: \(col)")
        if self.state == .play {
            
            if self.revealedGameField[row][col] == 0{
                if flag == true {
                    //print("self.revealedGameField[row][col] == 0 && flag == true")
                    self.revealedGameField[row][col] = 2
                    self.flagCount += 1
                } else {
                    switch self.gameField[row][col] {
                    case 0:
                        self.revealedGameField[row][col] = 1
                        revealNeighbours(row: row, col: col)
                    case 1...8:
                        self.revealedGameField[row][col] = 1
                    case 10:
                        
                        self.gameField[row][col] = 9
                        self.state = .lose
                        self.revealedGameField = Array(repeating: Array(repeating: 1, count: self.gameField[0].count), count: self.gameField.count)
                    default:
                        print("Gamefield does not have correct value at [\(row)][\(col)] which is \(self.gameField[row][col])")
                    }
                }
            } else if self.revealedGameField[row][col] == 2 && flag == true{
                self.flagCount -= 1
                self.revealedGameField[row][col] = 0
            }
            
        }
        
        
        /*
        print("gameField")
        for row in self.gameField {
            print("\(row)")
        }
        print("revealedGameField")
        for row in self.revealedGameField {
            print("\(row)")
        }
        */
    }
    
    func revealNeighbours(row: Int, col: Int) {
        
        let maxRow = self.gameField.count - 1
        let maxCol = self.gameField[0].count - 1
        if row == 0 && col == 0 {  // corner
            handleSelection(row: row + 1, col: col, flag: false)
            handleSelection(row: row, col: col + 1, flag: false)
            handleSelection(row: row + 1, col: col + 1, flag: false)
        } else if row == maxRow && col == maxCol {  // corner
            handleSelection(row: row - 1, col: col, flag: false)
            handleSelection(row: row, col: col - 1, flag: false)
            handleSelection(row: row - 1, col: col - 1, flag: false)
        } else if row == 0 && col == maxCol {  // corner
            handleSelection(row: row + 1, col: col, flag: false)
            handleSelection(row: row, col: col - 1, flag: false)
            handleSelection(row: row, col: col, flag: false)
        } else if row == maxRow && col == 0 {  // corner
            handleSelection(row: row - 1, col: col, flag: false)
            handleSelection(row: row, col: col + 1, flag: false)
            handleSelection(row: row - 1, col: col + 1, flag: false)
        } else if row == 0 {  //  side
            handleSelection(row: row + 1, col: col, flag: false)
            handleSelection(row: row, col: col - 1, flag: false)
            handleSelection(row: row, col: col + 1, flag: false)
            handleSelection(row: row + 1, col: col - 1, flag: false)
            handleSelection(row: row + 1, col: col + 1, flag: false)
        } else if col == 0 {  //  side
            handleSelection(row: row + 1, col: col, flag: false)
            handleSelection(row: row, col: col + 1, flag: false)
            handleSelection(row: row - 1, col: col, flag: false)
            handleSelection(row: row + 1, col: col + 1, flag: false)
            handleSelection(row: row - 1, col: col + 1, flag: false)
        } else if row == maxRow {  //  side
            handleSelection(row: row - 1, col: col, flag: false)
            handleSelection(row: row, col: col - 1, flag: false)
            handleSelection(row: row, col: col + 1, flag: false)
            handleSelection(row: row - 1, col: col - 1, flag: false)
            handleSelection(row: row - 1, col: col + 1, flag: false)
        } else if col == maxCol {  //  side
            handleSelection(row: row + 1, col: col, flag: false)
            handleSelection(row: row, col: col - 1, flag: false)
            handleSelection(row: row - 1, col: col, flag: false)
            handleSelection(row: row + 1, col: col - 1, flag: false)
            handleSelection(row: row - 1, col: col - 1, flag: false)
        } else {  // other
            handleSelection(row: row + 1, col: col, flag: false)
            handleSelection(row: row,     col: col + 1, flag: false)
            handleSelection(row: row - 1, col: col + 1, flag: false)
            handleSelection(row: row,     col: col - 1, flag: false)
            handleSelection(row: row + 1, col: col - 1, flag: false)
            handleSelection(row: row - 1, col: col - 1, flag: false)
            handleSelection(row: row + 1, col: col + 1, flag: false)
            handleSelection(row: row - 1, col: col + 1, flag: false)
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

        if row == 0 && col == 0 {  // corner
            gameFieldUpdatedNbrs[row + 1][col] += 1
            gameFieldUpdatedNbrs[row][col + 1] += 1
            gameFieldUpdatedNbrs[row + 1][col + 1] += 1
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
