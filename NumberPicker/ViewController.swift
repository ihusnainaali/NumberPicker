//
//  ViewController.swift
//  NumberPicker
//
//  Created by Yash Thaker on 10/06/18.
//  Copyright © 2018 Yash Thaker. All rights reserved.
//

import UIKit

class ViewController: UIViewController, TYNumberPickerDelegate {

    @IBOutlet weak var selectWeight: UIButton!
    
    let firstGradientColors: [UIColor] = [#colorLiteral(red: 0.9529411765, green: 0.5490196078, blue: 0.3490196078, alpha: 1), #colorLiteral(red: 0.968627451, green: 0.4196078431, blue: 0.4705882353, alpha: 1), #colorLiteral(red: 0.737254902, green: 0.3764705882, blue: 0.6392156863, alpha: 1)]
    let secondGradientColors: [UIColor] = [#colorLiteral(red: 0, green: 0.7764705882, blue: 1, alpha: 1), #colorLiteral(red: 0, green: 0.4470588235, blue: 1, alpha: 1)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.2039215686, green: 0.2039215686, blue: 0.2039215686, alpha: 1)
        
        selectWeight.applyGradient(colors: firstGradientColors, type: .cross)
        //selectWeight.applyGradient(colors: secondGradientColors, type: .cross)
        selectWeight.backgroundColor = .black
        selectWeight.layer.cornerRadius = 25
        selectWeight.layer.masksToBounds = true
        selectWeight.imageView?.contentMode = .scaleAspectFit
        selectWeight.setImage(#imageLiteral(resourceName: "weight").withRenderingMode(.alwaysTemplate), for: .normal)
        selectWeight.tintColor = .white
    }
    
    @IBAction func btnAction(_ sender: Any) {
        openNumberPicker()
    }
    
    func openNumberPicker() {
        let numberPicker = TYNumberPicker(self, maxNumber: 300)
        numberPicker.bgGradients = firstGradientColors
        //numberPicker.bgGradients = secondGradientColors
        numberPicker.tintColor = .white
        numberPicker.heading = "Weight"
        numberPicker.defaultSelectedNumber = 150
        
        self.present(numberPicker, animated: true, completion: nil)
    }
    
    func selectedNumber(_ number: Int) {
        print(number)
        
        self.selectWeight.setImage(UIImage(), for: .normal)
        self.selectWeight.setTitle("\(number)", for: .normal)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
}

