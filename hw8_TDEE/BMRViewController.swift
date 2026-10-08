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
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var bmrResultLabel: UILabel!
    
    var gender = "Male" // 計算BMR時，男女生算法不同，預設為男生
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 設定生理性別的選項清單
        let menu = UIMenu(children: [
            UIAction(title: "男性", image: UIImage(systemName: "figure.teen"), handler: { _ in
                self.gender = "Male"
                print(self.gender)
            }),
            UIAction(title: "女性", image: UIImage(systemName: "figure.stand.dress"), handler: { _ in
                self.gender = "Female"
                print(self.gender)
            })
        ])
        genderMenuButton.menu = menu
        
        // 設定 ageStepper 的最小值、最大值和初始值
        ageStepper.minimumValue = 0
        ageStepper.maximumValue = 100
        ageStepper.stepValue = 1
        ageStepper.value = 0
    }
    
    func checkInput() -> PersonInfo? {
    // 檢查年齡、身高、體重是否都能成功轉成Int跟Double，且年齡是否在 1~100 之間、身高體重是否為正數，是的話回傳轉換後的資訊，不是的話回傳nil
        if let ageText = ageTextField.text,
            let age = Int(ageText),
           let heightText = heightTextField.text,
           let height = Double(heightText),
           let weightText = weightTextField.text,
           let weight = Double(weightText),
           age > 0,
           age <= 100,
           height > 0,
           weight > 0 {
            return PersonInfo(age: age, height: height, weight: weight)
        }
        return nil
    }
    
    @IBAction func stepperChanged(_ sender: Any) {
        // 將 stepper 的值顯示在 ageTextField 上
        ageTextField.text = String(Int(ageStepper.value))
    }

    @IBAction func ageTextFieldChanged(_ sender: Any) {
        // 先確認 ageTextField 的值是否能成功轉成 Double，成功再將 stepper 的值更新為該數值
        if let ageText = ageTextField.text, let age = Double(ageText) {
            ageStepper.value = age
        }
    }
    @IBAction func calculateBMR(_ sender: Any) {
        var bmr = Double()
        
        if let person = checkInput() {
            // 計算BMR，需注意每個型別都需為 Double，才可做運算
            if gender == "Male" {
                // 男生BMR計算
                bmr = 9.99 * person.weight + 6.25 * person.height - 4.92 * Double(person.age) + 5.0
            } else {
                // 女生BMR計算
                bmr = 9.99 * person.weight + 6.25 * person.height - 4.92 * Double(person.age) - 161.0
            }
        } 
        
        infoLabel.text = "計算公式 (Mifflin-St Jeor formula) 9.99 × 體重 + 6.25 × 身高 - 4.92 × 年齡 +(166 × 性別 (男 1、女 0) - 161) = 基礎代謝率 (BMR)"
        // 顯示 BMR 計算結果，並四捨五入至整數
        bmrResultLabel.text = String(format: "%.0f", bmr)
        
    }
}

#Preview {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    return storyboard.instantiateInitialViewController()!
}
