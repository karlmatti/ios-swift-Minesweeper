//
//  OptionsViewController.swift
//  minesweeper
//
//  Created by Karl Matti on 30.04.2020.
//  Copyright © 2020 karlmatti. All rights reserved.
//

import UIKit

class OptionsViewController: UIViewController {

    @IBOutlet weak var difficultyValueUILabel: UILabel!
    @IBOutlet weak var themeValueUILabel: UILabel!
    @IBOutlet weak var fieldSizeValueUILabel: UILabel!
    @IBOutlet weak var bombsValueUILabel: UILabel!
    
    @IBOutlet weak var isThemeDefaultUIImageView: UIImageView!
    @IBOutlet weak var isThemeEstoniaUIImageView: UIImageView!
    @IBOutlet weak var difficultyUISlider: UISlider!
    
    public var difficultyValue: String = "normal"  // easy, normal, hard, custom
    var themeValue: String = "Default"  // Default, Estonia
    var fieldSizeValue: String = "100"  // 100 % to 10 %
    var bombsValue: String = "20"  // 0 to squares available
    
    var checkedImage = UIImage(systemName: "heart.fill")! as UIImage
    var uncheckedImage = UIImage(systemName: "heart")! as UIImage
    
    var currentBombCount: Int = 20
    var maxBombCount: Int = 100
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        print("currentBombCount is \(currentBombCount)")
        print("fieldSizeValue is \(fieldSizeValue)")
        //updateUI()

        
    }
    public func updateUI() {
        difficultyValueUILabel.text = difficultyValue
        themeValueUILabel.text = themeValue
        fieldSizeValueUILabel.text = fieldSizeValue
        bombsValueUILabel.text = bombsValue
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        print("Prepare for segue \(segue.identifier ?? "Segue identifier not set")")
        
        if let identifier = segue.identifier{
            switch identifier {
            case "Custom game settings":
                print("preparing for segue Custom game settings")
                if let vc = segue.destination as? CustomOptionsViewController {
                    vc.optionsViewController = self
                }
            case "Game":
                print("in Game")
            default:
                print("Controller for \(identifier) not found!")
            }
        }
        
    }
    public func updateBombsValue(bombs: Int) {
        self.currentBombCount = bombs
        print("current bomb count is \(self.currentBombCount)")
    }
    
    

}

extension OptionsViewController: CustomOptionsDelegate {
    
    func updateBombs(bombCount: Int) {
        self.currentBombCount = bombCount
        print("bombCount is \(bombCount)")
    }
    func updateFieldSize(fieldSize: Int) {
        self.fieldSizeValue = String(fieldSize)
        
        print("fieldSize is \(fieldSize)")
    }
}
