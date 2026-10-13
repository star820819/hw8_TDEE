//
//  TDEEViewController.swift
//  hw8_TDEE
//
//  Created by CHIEH-TING HSU on 2026/10/11.
//

import UIKit

class TDEEViewController: UIViewController {
    // 將前一頁 BMRViewController 計算完傳過來的 BMR 存在 bmrText
    var bmrText = String()
    
    var tdeeInfo = [
        TDEEInfo(activityImage: "lv1", activityLevel: "身體活動趨於靜態", exerciseDayInfo: "(幾乎不運動)", bmrFormula: "BMR x 1.2 = ", multiplier: 1.2),
        TDEEInfo(activityImage: "lv2", activityLevel: "身體活動程度較低", exerciseDayInfo: "(每週運動 1-3 天)", bmrFormula: "BMR x 1.375 = ", multiplier: 1.375),
        TDEEInfo(activityImage: "lv3", activityLevel: "身體活動程度正常", exerciseDayInfo: "(每週運動 4-5 天)", bmrFormula: "BMR x 1.55 = ", multiplier: 1.55),
        TDEEInfo(activityImage: "lv4", activityLevel: "身體活動程度較高", exerciseDayInfo: "(每週運動 6-7 天)", bmrFormula: "BMR x 1.72 = ", multiplier: 1.72),
        TDEEInfo(activityImage: "lv5", activityLevel: "身體活動程度激烈", exerciseDayInfo: "(長時間運動或體力勞動工作)", bmrFormula: "BMR x 1.9 = ", multiplier: 1.9)
    ]
    var isLoseWeight = Bool()
    var exerciseDay = Int()
    var isLabor = Bool()

    
    @IBOutlet weak var loseWeightLabel: UILabel!
    @IBOutlet weak var tdeeFormulaLabel: UILabel!
    @IBOutlet var tdeeExerciseDayLabel: UILabel!
    @IBOutlet weak var tdeeLevelLabel: UILabel!
    @IBOutlet weak var tdeeImageView: UIImageView!
    @IBOutlet weak var isLaborSwitch: UISwitch!
    @IBOutlet weak var exerciseDayLabel: UILabel!
    @IBOutlet weak var exerciseDaySlider: UISlider!
    @IBOutlet weak var loseWeightSegmentedControl: UISegmentedControl!
    @IBOutlet weak var bmrLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bmrLabel.text = "BMR = \(bmrText)"
        isLaborSwitch.isOn = false
        updateTDEE(tdee: tdeeInfo[0])
    }
    
    @IBAction func selectionsChanged(_ sender: Any) {
        // 每次選項更改，就重新確認選項
        checkSelections()
    }
    
    @IBAction func exerciseDaySliderChanged(_ sender: UISlider) {
        // 將 slider 的 value 四捨五入
        sender.value.round()
        // 因為 value 型別為 Float，利用 Int 變為整數再顯示，才不會有.0
        exerciseDayLabel.text = Int(sender.value).description + "天"
    }
    
    func checkSelections() {
        // 判斷是否要減重
        if loseWeightSegmentedControl.selectedSegmentIndex == 0 {
            isLoseWeight = false
        } else {
            isLoseWeight = true
        }
        // 判斷每週運動幾天
        exerciseDay = Int(exerciseDaySlider.value)
        // 判斷是否為體力勞動工作
        isLabor = isLaborSwitch.isOn
        
        // 依不同選項選擇要顯示的TDEEInfo，並呼叫updateTDEE去顯示結果
        if isLabor {
            updateTDEE(tdee: tdeeInfo[4])
        } else {
            switch exerciseDay {
            case 0:
                updateTDEE(tdee: tdeeInfo[0])
            case 1...3:
                updateTDEE(tdee: tdeeInfo[1])
            case 4...5:
                updateTDEE(tdee: tdeeInfo[2])
            case 6...7:
                updateTDEE(tdee: tdeeInfo[3])
            default:
                break
            }
        }
    }
    
    func updateTDEE(tdee: TDEEInfo) {
        var tdeeResult = Double()
        tdeeResult = calculateTDEE(bmrText: self.bmrText, bmrMultiplier: tdee.multiplier, loseWeight: isLoseWeight)
        
        tdeeImageView.image = UIImage(named: tdee.activityImage)
        tdeeLevelLabel.text = tdee.activityLevel
        tdeeExerciseDayLabel.text = tdee.exerciseDayInfo
        if isLoseWeight {
            tdeeFormulaLabel.text = "建議攝取 " + String(format: "%.2f", tdeeResult)
        } else {
            tdeeFormulaLabel.text = tdee.bmrFormula + String(format: "%.2f", tdeeResult)
        }
    }
    
    func calculateTDEE(bmrText: String, bmrMultiplier: Double, loseWeight: Bool) -> Double {
        let bmr = Double(bmrText)!
        if loseWeight {
            // 要減重的話，TDEE - 300
            loseWeightLabel.text = "避免過度節食造成肌肉流失，減重期間熱量不得低於基礎代謝率，上方建議攝取為 TDEE -300 大卡。"
            return bmr * bmrMultiplier - 300
        } else {
            loseWeightLabel.text = ""
            return bmr * bmrMultiplier
        }
    }
    
}

//#Preview {
//    let storyboard = UIStoryboard(name: "Main", bundle: nil)
//    return storyboard.instantiateViewController(withIdentifier: "TDEEViewController")
//}
