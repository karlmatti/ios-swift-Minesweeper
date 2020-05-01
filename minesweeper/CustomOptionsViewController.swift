//
//  CustomOptionsViewController.swift
//  minesweeper
//
//  Created by Karl Matti on 30.04.2020.
//  Copyright © 2020 karlmatti. All rights reserved.
//

import UIKit



class CustomOptionsViewController: UIViewController {
    @IBOutlet weak var fieldSizeUILabel: UILabel!
    @IBOutlet weak var bombsUILabel: UILabel!

    @IBOutlet weak var fieldSizeSlider: UISlider!
    @IBOutlet weak var bombsSlider: UISlider!
    var maximumBombs: Int = 4
    var currentBombs: Int = 1
    var currentFieldSize: Int = 100
    

    var optionsViewController: OptionsViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateUI()
    }

    func updateUI() {
        bombsSlider.maximumValue = Float(maximumBombs)
        bombsSlider.value = Float(currentBombs)
        bombsUILabel.text = "Bombs: \(currentBombs)"
        
        fieldSizeSlider.minimumValue = 0.2
        fieldSizeSlider.value = Float(currentFieldSize / 100)
        fieldSizeUILabel.text = "Field Size(%): \(currentFieldSize)"
    }
    
    @IBAction func FieldSizeSliderOnValueChange(_ sender: UISlider) {
        currentFieldSize = roundUp(Int(sender.value * 100), toNearest: 10)
        
        fieldSizeUILabel.text = "Field Size(%): \(currentFieldSize)"
        optionsViewController?.updateFieldSize(fieldSize: currentFieldSize)

    }
    
    @IBAction func BombsSliderOnValueChange(_ sender: UISlider) {
        currentBombs = Int(sender.value)
        bombsUILabel.text = "Bombs: \(currentBombs)"

        optionsViewController?.updateBombsValue(bombs: currentBombs)
       
    }
   
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    // Given a value to round and a factor to round to,
    // round the value DOWN to the largest previous multiple
    // of that factor.
    func roundUp(_ value: Int, toNearest: Double) -> Int {
        return Int(ceil(Double(value) / toNearest) * toNearest)
    }
}
