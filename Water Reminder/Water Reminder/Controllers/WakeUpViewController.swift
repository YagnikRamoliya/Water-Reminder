//
//  WakeUpViewController.swift
//  Water Reminder
//
//  Created by iMac on 07/08/25.
//

import Foundation
import UIKit

class WakeUpViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    
    var selectedGender: String = ""
    var selectedWeight: String = ""
    var selectedBedTime: String = ""
    
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var bedTimeLabel: UILabel!
    
    @IBOutlet weak var timePicker: UIPickerView!
    @IBOutlet weak var wakeUpTimeLabel: UILabel!
    
    @IBOutlet weak var btnNext: UIButton!
    
    
    let hours = Array(1...12)
    let minutes = Array(0...59)
    let periods = ["AM", "PM"]
    
    var selectedHour = 7
    var selectedMinute = 0
    var selectedPeriod = "AM"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timePicker.delegate = self
        timePicker.dataSource = self
        
        
        genderLabel.text = selectedGender
        weightLabel.text = selectedWeight
        bedTimeLabel.text = selectedBedTime
        
        updateSelectedTimeLabel()
        uiDesign()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    func uiDesign(){
        btnNext.layer.cornerRadius = 12
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0: return hours.count
        case 1: return minutes.count
        case 2: return periods.count
        default: return 0
        }
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0: return "\(hours[row])"
        case 1: return String(format: "%02d", minutes[row])
        case 2: return periods[row]
        default: return nil
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case 0: selectedHour = hours[row]
        case 1: selectedMinute = minutes[row]
        case 2: selectedPeriod = periods[row]
        default: break
        }
        updateSelectedTimeLabel()
    }
    
    // MARK: - Helper
    
    private func updateSelectedTimeLabel() {
        let timeString = String(format: "%02d:%02d %@", selectedHour, selectedMinute, selectedPeriod)
        wakeUpTimeLabel.text = timeString
        
        
    }
    
    
    @IBAction func btnNext(_ sender: UIButton) {
        let timeString = String(format: "%02d:%02d %@", selectedHour, selectedMinute, selectedPeriod)
        UserDefaults.standard.set(timeString, forKey:"wakeUpTime")
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "DailyWaterPlanVc")as! DailyWaterPlanVc
        vc.selectedWeight = self.selectedWeight
        
        UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
        
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func btnExit(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
}
