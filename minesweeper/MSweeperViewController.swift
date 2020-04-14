//
//  ViewController.swift
//  minesweeper
//
//  Created by Karl Matti on 09.04.2020.
//  Copyright © 2020 karlmatti. All rights reserved.
//

import UIKit


class MSweeperViewController: UIViewController {
    
    
    
    

    @IBOutlet weak var gameBoard: UIStackView!
    
    var buttonCounter = 0
    var flag: BooleanLiteralType = true
    var numOfPortraitRows: Int = 0
    var numOfPortraitCols: Int = 0
    var numOfLandscapeRows: Int = 0
    var numOfLandscapeCols: Int = 0
    var gameEngine: MSweeperEngine?
    @IBAction func startGame(_ sender: UIButton) {
        //  Calculate col and row numbers for portrait/landscape
        calculateColRow()
        gameEngine = MSweeperEngine(x: 10, y: 5, percentageOfBombs: 0.1)
        
        prepareUI()
        flag = false
        
          
        

    }
    func ereaseUI() {
        //  print("erease ui\(gameBoard.arrangedSubviews.count)")
        let countSubviews = gameBoard.arrangedSubviews.count
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
                    
                    let releaseTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MSweeperViewController.handleTap(gesture:)))
                    button.addGestureRecognizer(releaseTap)
                    //  start to write color and pick "Color Literal"
                    button.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
                    button.showElement = 3
                    //  button.setTitle("\(buttonCounter)", for: UIControl.State.normal)
                    button.heightAnchor.constraint(equalTo: button.widthAnchor, multiplier: 1.0/1.0).isActive = true
                    buttonCounter += 1
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
                
                let releaseTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MSweeperViewController.handleTap(gesture:)))
                button.addGestureRecognizer(releaseTap)
                //  start to write color and pick "Color Literal"
                button.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
                button.showElement = 3
                //  button.setTitle("\(buttonCounter)", for: UIControl.State.normal)
                button.heightAnchor.constraint(equalTo: button.widthAnchor, multiplier: 1.0/1.0).isActive = true
                
                
                buttonCounter += 1
                columnStack.addArrangedSubview(button)
                
            }
        }
        
    }
    
    
    
    @objc func handleTap(gesture: UITapGestureRecognizer){
        
        switch gesture.state {
        case .ended:
            print("tap received")
            
            if let view = gesture.view as? UITileView {
                print(view.showElement)
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
            }
        default:
            break
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateOrientationUI), name: UIDevice.orientationDidChangeNotification, object: nil)
        
        // Do any additional setup after loading the view.
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        updateTraitCollectionUI()
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
        
        
        //  Draw UI according to current orientation
        //  drawUI(boolean) where argument 'false' is portrait and 'true' is landscape
        switch UIDevice.current.orientation {
        case .faceUp:
            print("faceUp")
            //  drawUI(isLandscape: false)
        case .faceDown:
            print("faceDown")
            //  drawUI(isLandscape: false)
        case .landscapeLeft:
            print("landscapeLeft")
            drawUI(isLandscape: true)
        case .landscapeRight:
            print("landscapeRight")
            drawUI(isLandscape: true)
        case .portrait:
            print("portrait")
            drawUI(isLandscape: false)
        case .portraitUpsideDown:
            print("portraitUpsideDown")
            drawUI(isLandscape: false)
        case .unknown:
            print("unknown")
            drawUI(isLandscape: false)
        default:
            print("default")
            //  drawUI(isLandscape: false)
        }
        
        
    }
    func calculateColRow(){
        numOfPortraitRows = Int((gameBoard.frame.size.height / 55).rounded()) - 1
        numOfPortraitCols = Int((gameBoard.frame.size.width / 55).rounded()) - 1
        numOfLandscapeRows = numOfPortraitCols + 1
        numOfLandscapeCols = numOfPortraitRows - 1
        
        print("portRows\(numOfPortraitRows)")
        print("portCols\(numOfPortraitCols)")
        print("landRows\(numOfLandscapeRows)")
        print("landCols\(numOfLandscapeCols)")
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
    }
    @objc func updateOrientationUI(){
        if flag == false {
            
            prepareUI()
           
        }
        
        
        
    }



}

