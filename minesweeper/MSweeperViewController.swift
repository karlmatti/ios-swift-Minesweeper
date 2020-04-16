//
//  ViewController.swift
//  minesweeper
//
//  Created by Karl Matti on 09.04.2020.
//  Copyright © 2020 karlmatti. All rights reserved.
//

import UIKit


class MSweeperViewController: UIViewController {
    
    
    

    @IBOutlet weak var UIView: UIView!
    @IBOutlet weak var gameBoard: UIStackView!
    @IBOutlet weak var gameStatus: UIButton!
    @IBOutlet weak var gameBombsLeft: UILabel!
    @IBOutlet weak var gameTimer: UILabel!
    
    var buttonCounter = 0
    var flag: BooleanLiteralType = true
    var numOfPortraitRows: Int = 0
    var numOfPortraitCols: Int = 0
    var numOfLandscapeRows: Int = 0
    var numOfLandscapeCols: Int = 0
    var buttonTag: Int = 0
    var gameEngine: MSweeperEngine?
    var startGameInPortrait: DarwinBoolean = true
    var revealedGameField: Array<Array<Int>> = []
    var gameField: Array<Array<Int>> = []
    var gameState: State = .play
    var gameBombsCount: Int = 0
    var timer = Timer()
    var gameLevel: Double = 0.1
    
    @IBOutlet weak var L1: UIButton!
    @IBOutlet weak var L2: UIButton!
    @IBOutlet weak var L3: UIButton!
    func resetLevelBtnColors(){
        L1.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
        L2.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
        L3.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
    }
    @IBAction func setLevel1(_ sender: UIButton) {
        setLevel(btn: sender, level: 0.1)
    }
    @IBAction func setLevel2(_ sender: UIButton) {
        setLevel(btn: sender, level: 0.2)
    }
    @IBAction func setLevel3(_ sender: UIButton) {
        setLevel(btn: sender, level: 0.3)
    }
    func setLevel(btn: UIButton, level: Double){
        self.gameLevel = level
        startGame()
        resetLevelBtnColors()
        btn.setTitleColor(#colorLiteral(red: 0.2039215686, green: 0.7803921569, blue: 0.3490196078, alpha: 1), for: .normal)
    }
    
    @IBAction func startGame() {
        
        
        //  TODO: Fix UI
        //  TODO: Improve UI
        //  TODO: save state when changing orientation
        
        if UIDevice.current.orientation.isValidInterfaceOrientation {
            //  Calculate col and row numbers for portrait/landscape
            calculateColRow()
            gameEngine = MSweeperEngine(rowCount: numOfPortraitRows, colCount: numOfPortraitCols + 1, percentageOfBombs: self.gameLevel)
            (gameField, revealedGameField, gameBombsCount) = gameEngine?.startGame() as! (Array<Array<Int>>, Array<Array<Int>>, Int)
            prepareUI()
            flag = false
            gameStatus.setTitle("🙂", for: UIControl.State.normal)
            self.gameTimer.text = "0"
            timer.invalidate()
            timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
                
                self.gameTimer.text = String((self.gameTimer.text! as NSString).integerValue + 1)
            }
            self.gameBombsLeft.text = String(self.gameBombsCount)
        }
        

    }
    func ereaseUI() {
        //  print("erease ui\(gameBoard.arrangedSubviews.count)")
        let countSubviews = gameBoard.arrangedSubviews.count
        buttonTag = 0
        if countSubviews > 0 {
            for _ in 1...countSubviews {
                rowDelete()
            }
        }
        
        
    }
    
    
    func rowAdd() {
        if (gameBoard.arrangedSubviews.count == 0){
            columnAdd()
            return
        }
        
        let rowStack = UIStackView()
        rowStack.axis = .horizontal
        rowStack.alignment = .firstBaseline
        rowStack.distribution = .fillEqually
        rowStack.spacing = 2.0
        gameBoard.addArrangedSubview(rowStack)
        
        if let firstRowView = gameBoard.arrangedSubviews.first {
            if let firstRowStackView = firstRowView as? UIStackView {
                let columnCount = firstRowStackView.arrangedSubviews.count
                for _ in 0..<columnCount {
                    let button = UITileView()
                    button.tag = buttonTag
                    //  print("in columnAdd, bt=\(buttonTag)")
                    buttonTag += 1
                    let releaseTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MSweeperViewController.handleTap(gesture:)))
                    button.addGestureRecognizer(releaseTap)
                    //  start to write color and pick "Color Literal"
                    button.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
                    button.showElement = 0
                    //  button.setTitle("\(buttonCounter)", for: UIControl.State.normal)
                    button.heightAnchor.constraint(equalTo: button.widthAnchor, multiplier: 1.0/1.0).isActive = true
                    
                    rowStack.addArrangedSubview(button)
                }
            }
        }

    }
    
    func rowDelete() {
        let subView = gameBoard.arrangedSubviews.last as! UIStackView
        
        gameBoard.removeArrangedSubview(subView)
        subView.removeFromSuperview()
 
    
    }
    
    func columnAdd() {
        
        
        if (gameBoard.arrangedSubviews.count == 0){
            
            let columnStack = UIStackView()
            columnStack.axis = .horizontal
            columnStack.alignment = .firstBaseline
            columnStack.distribution = .fillEqually
            columnStack.spacing = 2.0
            gameBoard.addArrangedSubview(columnStack)
        }
        for subView in gameBoard.arrangedSubviews {
            if let columnStack = subView as? UIStackView {
                let button = UITileView()
                button.tag = self.buttonTag
                //  print("in columnAdd, bt=\(buttonTag)")
                self.buttonTag += 1
                
                let releaseTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MSweeperViewController.handleTap(gesture:)))
                releaseTap.numberOfTapsRequired = 1
                let releaseDoubleTap = UITapGestureRecognizer(target: self, action: #selector(MSweeperViewController.handleDoubleTap(gesture:)))
                releaseDoubleTap.numberOfTapsRequired = 2
                
                button.addGestureRecognizer(releaseTap)
                button.addGestureRecognizer(releaseDoubleTap)
                releaseTap.require(toFail: releaseDoubleTap)
                //  start to write color and pick "Color Literal"
                button.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
                button.showElement = 0
                //  button.setTitle("\(buttonCounter)", for: UIControl.State.normal)
                button.heightAnchor.constraint(equalTo: button.widthAnchor, multiplier: 1.0/1.0).isActive = true
                
                
                
                columnStack.addArrangedSubview(button)
                
            }
        }
        
    }
    
    
    @objc func handleDoubleTap(gesture: UITapGestureRecognizer) {
        switch gesture.state {
            
            case .ended:
                
                if let view = gesture.view as? UITileView {
                    let (selectedRow, selectedCol) = findClickedTile(buttonTag: view.tag)
                    gameEngine?.handleSelection(row: selectedRow, col: selectedCol, flag: true)
    
                }
            default:
                break
        }
        (self.gameField, self.revealedGameField, self.gameState, self.gameBombsCount) = gameEngine?.getState() as! (Array<Array<Int>>, Array<Array<Int>>, State, Int)
        drawElements()
    }
    @objc func handleTap(gesture: UITapGestureRecognizer){
        
        switch gesture.state {
            
            case .ended:
                //print("tap received")
                
                if let view = gesture.view as? UITileView {
                    print("clicked button: \(view.tag)")
                    let (selectedRow, selectedCol) = findClickedTile(buttonTag: view.tag)
                    
                    gameEngine?.handleSelection(row: selectedRow, col: selectedCol, flag: false)
                    /*
                    switch view.showElement {
                    case 0:
                        view.showElement = 1
                    case 1:
                        view.showElement = 2
                    case 2:
                        view.showElement = 3
                    case 3:
                        view.showElement = 4
                    case 4:
                        view.showElement = 5
                    case 5:
                        view.showElement = 0
                    default:
                        break
                    }
                    */
                }
            default:
                break
        }
        (self.gameField, self.revealedGameField, self.gameState, self.gameBombsCount) = gameEngine?.getState() as! (Array<Array<Int>>, Array<Array<Int>>, State, Int)
        drawElements()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateOrientationUI), name: UIDevice.orientationDidChangeNotification, object: nil)
        print("UIView.frame.size \(UIView.frame.size)")
        let height: Int = Int(Double(UIView.frame.size.height) * 0.8)
        let width: Int = Int(Double(UIView.frame.size.width) * 0.8)
        print("UIView.frame.size.height \(height)")
        print("UIView.frame.size.width \(width)")
        // Do any additional setup after loading the view.
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        updateTraitCollectionUI()
    }
    
    func findClickedTile(buttonTag: Int) -> (row: Int, col: Int) {
        var counter = 0
        if UIDevice.current.orientation.isLandscape == true {
            for col in 0..<numOfLandscapeCols + 1 {
                for row in (0..<numOfLandscapeRows).reversed() {
                    if counter == buttonTag {
                        //print("return (\(col),\(row))")
                        return (col, row)
                    }
                    counter += 1
                }
            }
            
        } else {
            for col in 0..<numOfPortraitCols + 1 {
                for row in 0..<numOfPortraitRows {
                if counter == buttonTag {
                    //print("return (\(row),\(col))")
                    return (row, col)
                }
                counter += 1
                }
            }
        }
        
        return (0, 0)
    }
    
    func updateTraitCollectionUI(){
        var traitText = ""
        switch traitCollection.horizontalSizeClass {
        case .compact:
            traitText = "Hor: compact"
        case .regular:
            traitText = "Hor: regular"
        case .unspecified:
            traitText = "Hor: unspecified"
        default:
            traitText = "Hor: unknown"
        }
        
        traitText += " "
        
        switch traitCollection.verticalSizeClass {
        case .compact:
            traitText += "Ver: compact"
        case .regular:
            traitText += "Ver: regular"
        case .unspecified:
            traitText += "Ver: unspecified"
        default:
            traitText += "Ver: new"
        }
        
        print("updateTraitCollectionUI \(traitText)")
    }
    
    
    
    func prepareUI() {
        
        //  TODO: React for Regular Regular trait -> change axis for some stackviews
        
        //  Draw UI according to current orientation
        //  drawUI(boolean) where argument 'false' is portrait and 'true' is landscape
        if UIDevice.current.orientation.isLandscape {
            drawUI(isLandscape: true)
        } else {
            drawUI(isLandscape: false)
        }
        /*
        switch UIDevice.current.orientation {
        case .faceUp, .faceDown, .portrait, .portraitUpsideDown:
            drawUI(isLandscape: false)
        case .landscapeLeft, .landscapeRight:
            drawUI(isLandscape: true)
        case .unknown:
            drawUI(isLandscape: false)
        default:
            drawUI(isLandscape: false)
        }
        */
    }
    
    func calculateColRow(){
        print("UIView.frame.size\(UIView.frame.size)")
        print("gameBoard.frame.size\(gameBoard.frame.size)")
        var width: CGFloat = 0
        var height: CGFloat = 0
        if UIDevice.current.orientation.isLandscape == true {
            
            height = UIView.frame.size.height * 0.9
            width = UIView.frame.size.width * 0.9 * 0.9
            
            numOfPortraitCols = Int((height / 40).rounded())
            numOfPortraitRows = Int((width / 40).rounded())
            
            numOfLandscapeCols = numOfPortraitRows - 1
            numOfLandscapeRows = numOfPortraitCols + 1
            
        } else {
            
            height = UIView.frame.size.width * 0.9
            width = UIView.frame.size.height * 0.9 * 0.9
            
            
            numOfPortraitCols = Int((height / 40).rounded())
            numOfPortraitRows = Int((width / 40).rounded())
            
            numOfLandscapeCols = numOfPortraitRows - 1
            numOfLandscapeRows = numOfPortraitCols + 1
            
        }
        
        
            
        /*
        print("portRows\(numOfPortraitRows)")
        print("portCols\(numOfPortraitCols)")
        print("landRows\(numOfLandscapeRows)")
        print("landCols\(numOfLandscapeCols)")
        */
        
         
    }
    
    
    func drawUI(isLandscape: BooleanLiteralType){
        ereaseUI()
        var numOfRows = 0
        var numOfCols = 0
        if isLandscape == true {
            numOfRows = numOfLandscapeRows
            numOfCols = numOfLandscapeCols
        } else {
            numOfRows = numOfPortraitRows
            numOfCols = numOfPortraitCols
        }
        
        for _ in 1...numOfRows {
            rowAdd()
        }
        for _ in 1...numOfCols {
            columnAdd()
        }
        //drawElements()
    }
    
    func drawElements(){
        if UIDevice.current.orientation.isLandscape == true {
            var col = gameBoard.arrangedSubviews.count - 1
                    for subView in gameBoard.arrangedSubviews {
                        
                        if let stack = subView as? UIStackView {
                            var row = 0
                            for tile in stack.arrangedSubviews{
                                if let square = tile as?UITileView {
                                    if self.revealedGameField[row][col] == 1 {
                                    //print("drawElements() ->")
                                       //print("col: \(col)")
                                       //print("row: \(row)")
                                       switch self.gameField[row][col] {
                                       case 0...8:
                                            square.setCount(count: self.gameField[row][col])
                                           square.showElement = 2
                                       case 9:
                                           square.showElement = 4
                                       case 10:
                                           square.showElement = 3
                                       default:
                                           break
                                       }
            
                                    } else if self.revealedGameField[row][col] == 2 {
                                        square.showElement = 1
                                    } else if self.revealedGameField[row][col] == 0 {
                                        square.showElement = 0
                                    }
                                }
                                
                                row += 1
                            }
                        }

                        col -= 1
                    }
        } else {
            
            //print("subView 0st element showelement \(tile?.showElement ?? -1)")
            
            //print("colCount: \(colCount)")
            //print("rowCount: \(rowCount)")
            var col = 0
            for subView in gameBoard.arrangedSubviews {
                var row = 0
                if let stack = subView as? UIStackView {
                    for tile in stack.arrangedSubviews{
                        if let square = tile as?UITileView {
                            if self.revealedGameField[col][row] == 1 {
                            //print("drawElements() ->")
                               //print("col: \(col)")
                               //print("row: \(row)")
                               switch self.gameField[col][row] {
                               case 0...8:
                                    square.setCount(count: self.gameField[col][row])
                                   square.showElement = 2
                               case 9:
                                   square.showElement = 4
                               case 10:
                                   square.showElement = 3
                               default:
                                   break
                               }
    
                            } else if self.revealedGameField[col][row] == 2 {
                                square.showElement = 1
                            } else if self.revealedGameField[col][row] == 0 {
                                square.showElement = 0
                            }
                        }
                        
                        row += 1
                    }
                }

                col += 1
            }
            
        }
        if self.gameState == .lose {
            gameStatus.setTitle("🤯", for: UIControl.State.normal)
        } else if self.gameState == .win {
            gameStatus.setTitle("🥳", for: UIControl.State.normal)
        }
        gameBombsLeft.text = String(self.gameBombsCount)
    }
    @objc func updateOrientationUI(){
        if flag == false {
            
            prepareUI()
            drawElements()
        }
        
        
        
    }



}


