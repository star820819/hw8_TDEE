//
//  BMRViewController.swift
//  hw8_TDEE
//
//  Created by CHIEH-TING HSU on 2026/9/29.
//

import UIKit

class BMRViewController: UIViewController {
            
    @IBOutlet weak var genderMenuButton: UIButton!
    
    @IBOutlet weak var ageStepper: UIStepper!
    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var heightTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        // 設定生理性別的選項清單
        let menu = UIMenu(children: [
            UIAction(title: "男性", image: UIImage(systemName: "figure.teen"), handler: { _ in
            }),
            UIAction(title: "女性", image: UIImage(systemName: "figure.stand.dress"), handler: { _ in
            })
        ])
        genderMenuButton.menu = menu
        
        // 設定 ageStepper 的最小值、最大值和初始值
        ageStepper.minimumValue = 0
        ageStepper.maximumValue = 120
        ageStepper.stepValue = 1
        ageStepper.value = 0
    
    }
    @IBAction func stepperChanged(_ sender: UIStepper) {
        // 將 stepper 的值顯示在 ageTextField 上
        ageTextField.text = String(Int(sender.value))
    }
    
    @IBAction func ageTextFieldChanged(_ sender: UITextField) {
        // 要將 ageTextField 的 Event 設為 Editing Changed，才能在使用者輸入時觸發此方法
        // 將 ageTextField 的值轉換為 Double，並更新 stepper 的值
        if let text = sender.text,
           let age = Double(text) {
            ageStepper.value = age
        }
    }
}

#Preview {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    return storyboard.instantiateInitialViewController()!
}
