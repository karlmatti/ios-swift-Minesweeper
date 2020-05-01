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
    

    @IBOutlet weak var difficultyUISlider: UISlider!
    
    public var difficultyValue: String = "normal"  // easy, normal, hard, custom
    
    var currentTheme: String = "default"  // 'default', 'estonia
    var checkedImage = UIImage(systemName: "heart.fill")! as UIImage
    var uncheckedImage = UIImage(systemName: "heart")! as UIImage
    
    var currentFieldSize: Int = 100  // 10 % to 100 %
    
    var currentBombs: Int = 20  // 0 % to 100 %
    let easyBombs :Int = 10
    let normalBombs :Int = 20
    let hardBombs :Int = 30
    var maximumBombs: Int = 100
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        updateUI()

        
    }
    public func updateUI() {
        difficultyValueUILabel.text = difficultyValue
        themeValueUILabel.text = currentTheme
        fieldSizeValueUILabel.text = String(currentFieldSize)
        bombsValueUILabel.text = String(currentBombs)
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
                    vc.currentFieldSize = self.currentFieldSize
                    vc.currentBombs = self.currentBombs
                    vc.maximumBombs = self.maximumBombs
                }
            case "Game":
                print("in Game")
                if let vc = segue.destination as? MSweeperViewController {
                    vc.updateGameOptions(newBombs: self.currentBombs, newFieldSize: self.currentFieldSize, newTheme: self.currentTheme)
                }
            default:
                print("Controller for \(identifier) not found!")
            }
        }
        
    }
    func updateGame(){
        if self.splitViewController?.viewControllers.last is MSweeperViewController {
            print("Current splitview detail is MSweeperViewController")
            let vc = self.splitViewController?.viewControllers.last as! MSweeperViewController
            vc.updateGameOptions(newBombs: self.currentBombs, newFieldSize: self.currentFieldSize, newTheme: self.currentTheme)
        } else if self.navigationController?.viewControllers.last is MSweeperViewController {
            print("Current navigation detail is MSweeperViewController")
            let vc = self.navigationController?.viewControllers.last as! MSweeperViewController
            vc.updateGameOptions(newBombs: self.currentBombs, newFieldSize: self.currentFieldSize, newTheme: self.currentTheme)
        }
    }
    
    @IBAction func gameDifficultyOnValueChange(_ sender: UISlider) {
        let divider: Float = 1 / 3

        if sender.value <= divider { // easy
            self.difficultyValue = "easy"
            self.currentBombs = self.easyBombs
            
        } else if sender.value <= divider * 2 { // normal
            self.difficultyValue = "normal"
            self.currentBombs = self.normalBombs
            
        } else { // hard
            self.difficultyValue = "hard"
            self.currentBombs = self.hardBombs
            
        }
        self.difficultyValueUILabel.text = self.difficultyValue
        self.bombsValueUILabel.text = String(self.currentBombs)
        self.currentFieldSize = 100
        self.fieldSizeValueUILabel.text = String(self.currentFieldSize)
        updateGame()
    }
    
    public func updateBombsValue(bombs: Int) {
        self.currentBombs = bombs
        self.bombsValueUILabel.text = String(bombs)
        self.difficultyValue = "custom"
        self.difficultyValueUILabel.text = self.difficultyValue
        updateGame()
    }
    public func updateFieldSize(fieldSize: Int) {
        self.currentFieldSize = fieldSize
        self.fieldSizeValueUILabel.text = String(fieldSize)
        self.difficultyValue = "custom"
        self.difficultyValueUILabel.text = self.difficultyValue
        updateGame()
    }
    
    
    @IBOutlet weak var estoniaThemeUIButton: UIButton!
    @IBOutlet weak var defaultThemeUIButton: UIButton!
    @IBAction func handleSetThemeToDefault(_ sender: UIButton) {
        self.currentTheme = "default"
        self.themeValueUILabel.text = self.currentTheme
        sender.setImage(checkedImage, for: UIControl.State.normal)
        estoniaThemeUIButton.setImage(uncheckedImage, for: UIControl.State.normal)
        updateGame()
    }
    
    @IBAction func handleSetThemeToEstonia(_ sender: UIButton) {
        self.currentTheme = "estonia"
        self.themeValueUILabel.text = self.currentTheme
        sender.setImage(checkedImage, for: UIControl.State.normal)
        defaultThemeUIButton.setImage(uncheckedImage, for: UIControl.State.normal)
        updateGame()
    }
    
    

}

