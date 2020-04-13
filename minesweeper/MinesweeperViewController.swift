//
//  ViewController.swift
//  minesweeper
//
//  Created by Karl Matti on 09.04.2020.
//  Copyright © 2020 karlmatti. All rights reserved.
//

import UIKit

class MinesweeperViewController: UIViewController {

    @IBOutlet weak var gameBoard: UIStackView!
    @IBOutlet weak var tileX0Y0: UITileView! {
        didSet {
            tileX0Y0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(MinesweeperViewController.handleTap(gesture:))))
        }
    }
    
    var buttonCounter = 0
    var numOfRows: Int = 0
    var numOfCols: Int = 0
    var flag: DarwinBoolean = true

    @IBAction func startGame(_ sender: UIButton) {
        if flag == true {
            drawUI()
            flag = false
        } else {
            ereaseUI()
            flag = true
        }
        

    }
    func ereaseUI() {
        //  print("erease ui\(gameBoard.arrangedSubviews.count)")
        for _ in 1...gameBoard.arrangedSubviews.count {
            rowDelete()
        }
        
    }
    func drawUI() {
        numOfRows = Int((gameBoard.frame.size.height / 55).rounded()) - 1
        numOfCols = Int((gameBoard.frame.size.width / 55).rounded()) - 1
        //  print("numOfRows\(numOfRows)")
        //  print("numOfCols\(numOfCols)")
        for _ in 1...numOfRows {
            rowAdd()
        }
        for _ in 1...numOfCols {
            columnAdd()
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
                    
                    let releaseTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MinesweeperViewController.handleTap(gesture:)))
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
        for button in subView.arrangedSubviews {
            let uiButton = button as! UIButton
            subView.removeArrangedSubview(uiButton)
            uiButton.removeFromSuperview()
       
        }
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
                
                let releaseTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MinesweeperViewController.handleTap(gesture:)))
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
    @objc func updateOrientationUI(){
        var orientationText = "Orient: "
        switch UIDevice.current.orientation {
        case .faceUp:
            orientationText += "faceUp"
        case .faceDown:
            orientationText += "faceDown"
        case .landscapeLeft:
            orientationText += "landscapeLeft"
        case .landscapeRight:
            orientationText += "landscapeRight"
            let temp = numOfCols
            numOfCols = numOfRows
            numOfRows = temp
            
        case .portrait:
            orientationText += "portrait"
            let temp = numOfCols
            numOfCols = numOfRows
            numOfRows = temp
            
        case .portraitUpsideDown:
            orientationText += "portraitUpsideDown"
        case .unknown:
            orientationText += "unknown"
        default:
            orientationText += "new"
        }
        
        print("updateOrientationUI \(orientationText)")
    }



}

