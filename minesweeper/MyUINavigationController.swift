//
//  UINavigationController.swift
//  minesweeper
//
//  Created by Karl Matti on 30.04.2020.
//  Copyright © 2020 karlmatti. All rights reserved.
//

import UIKit

class MyUINavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    
    print("in MyUINavigationController. Prepare for segue \(segue.identifier ?? "Segue identifier not set")")
    
        if let identifier = segue.identifier{
            switch identifier {
            case "Custom game settings":
                print("preparing for segue Custom game settings")
                if let vc = segue.destination as? CustomOptionsViewController {
                    //vc.optionsViewController = self
                }
            case "Game":
                print("in Game")
            default:
                print("Controller for \(identifier) not found!")
            }
        }
    }

}
