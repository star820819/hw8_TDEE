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
    
    var gender = Gender.male // 計算BMR時，男女生算法不同，預設為男生
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 設定生理性別的選項清單
        let menu = UIMenu(children: [
            UIAction(title: "男性", image: UIImage(systemName: "figure.teen"), handler: { _ in
                self.gender = .male
                print(self.gender)
                self.updateBMR()
            }),
            UIAction(title: "女性", image: UIImage(systemName: "figure.stand.dress"), handler: { _ in
                self.gender = .female
                print(self.gender)
                self.updateBMR()
            })
        ])
        genderMenuButton.menu = menu
        
        // 設定 ageStepper 的最小值、最大值和初始值
        ageStepper.minimumValue = 0
        ageStepper.maximumValue = 100
        ageStepper.stepValue = 1
        ageStepper.value = 0
    }
    
    @IBAction func stepperChanged(_ sender: Any) {
        // 將 stepper 的值顯示在 ageTextField 上
        ageTextField.text = String(Int(ageStepper.value))
        // 因為是利用程式更改 ageTextField 的值，不會觸發IBAction inputDidChanged，所以呼叫updateBMR
        updateBMR()
    }

    @IBAction func ageTextFieldChanged(_ sender: Any) {
        // 先確認 ageTextField 的值是否能成功轉成 Double，成功再將 stepper 的值更新為該數值
        if let ageText = ageTextField.text, let age = Double(ageText) {
            ageStepper.value = age
        }
        updateBMR()
    }
    
    @IBAction func inputDidChanged(_ sender: Any) {
        // 當使用者的輸入資訊更改，呼叫 updateBMR
        updateBMR()
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "showTDEE" {
            // 檢查是否有正確的 BMR，正確才能跳到下一頁查看 TDEE
            if bmrResultLabel.text == "" {
                infoLabel.text = "請先計算出正確的BMR"
                infoLabel.textColor = .red
                return false
            }
        }
        return true
    }
    
    @IBSegueAction func showTDEE(_ coder: NSCoder) -> TDEEViewController? {
        let controller = TDEEViewController(coder: coder)
        controller?.bmrText = bmrResultLabel.text!
        return controller
    }
    
    func updateBMR() {
        // 確認checkInput是否有回傳PersonInfo物件，若為nil代表input不對，無法計算BMR
        guard let personInfo = checkInput() else {
            bmrResultLabel.text = ""
            return
        }
        
        let bmr = calculateBMR(person: personInfo)
        bmrResultLabel.text = String(format: "%.0f", bmr)
        infoLabel.text = "計算公式 (Mifflin-St Jeor formula) 9.99 × 體重 + 6.25 × 身高 - 4.92 × 年齡 +(166 × 性別 (男 1、女 0) - 161) = 基礎代謝率 (BMR)"
        infoLabel.textColor = .black
    }
    
    func checkInput() -> PersonInfo? {
        // 檢查年齡、身高、體重是否都能成功轉成Int跟Double，且年齡是否在 1~100之間、身高體重是否為正數，並將輸入錯誤的訊息存在errorMsg，輸入都正確的話回傳轉換後的資訊，不正確的話回傳nil
        var errorMsg: [String] = []
        
        var age: Int?
        var height: Double?
        var weight: Double?
        
        // 判斷年齡是否正確，且在 1~100 歲之間
        if let ageText = ageTextField.text,
           let ageValue = Int(ageText),
           ageValue > 0 && ageValue <= 100 {
            age = ageValue
        } else {
            errorMsg.append("請輸入正確的年齡(1~100歲)")
        }
        
        // 判斷身高是否正確，且為正數
        if let heightText = heightTextField.text,
           let heightValue = Double(heightText),
           heightValue > 0 {
            height = heightValue
        } else {
            errorMsg.append("請輸入正確的身高，需為正數")
        }
        
        // 判斷體重是否正確，且為正數
        if let weightText = weightTextField.text,
           let weightValue = Double(weightText),
           weightValue > 0 {
            weight = weightValue
        } else {
            errorMsg.append("請輸入正確的體重，需為正數")
        }
        
        // 將 errorMsg 依序顯示在 infoLabel，並以換行隔開
        infoLabel.text = errorMsg.joined(separator: "\n")
        infoLabel.textColor = .red
        
        // 判斷是否沒有錯誤訊息，且 age, height, weight 都是否已成功轉成 Int、Double
        guard errorMsg.isEmpty,
              let age,
              let height,
              let weight
        else {
            return nil
        }
        return PersonInfo(gender: self.gender, age: age, height: height, weight: weight)
    }
    
    func calculateBMR(person: PersonInfo) -> Double {
        var bmr = Double()
        
        if person.gender == .male {
            // 男生BMR計算
            bmr = 9.99 * person.weight + 6.25 * person.height - 4.92 * Double(person.age) + 5.0
        } else {
            // 女生BMR計算
            bmr = 9.99 * person.weight + 6.25 * person.height - 4.92 * Double(person.age) - 161.0
        }
        return bmr
    }
}

#Preview {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    return storyboard.instantiateInitialViewController()!
}
