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
    
    var difficultyValue: String = "normal"  // easy, normal, hard, custom
    var themeValue: String = "Default"  // Default, Estonia
    var fieldSizeValue: String = "100"  // 100 % to 10 %
    var bombsValue: String = "20"  // 0 to squares available
    
    var checkedImage = UIImage(systemName: "heart.fill")! as UIImage
    var uncheckedImage = UIImage(systemName: "heart")! as UIImage
    
    var currentBombCount: Int = 20
    var maxBombCount: Int = 100
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()

        
    }
    func updateUI() {
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
                if let viewControllerWeAreSegueingTo = segue.destination as? CustomOptionsViewController {
                    viewControllerWeAreSegueingTo
                }
            case "Game":
                print("in Game")
            default:
                print("Controller for \(identifier) not found!")
            }
        }
        
    }
    

}
