//
//  WeightViewController.swift
//  Water Reminder
//
//  Created by iMac on 07/08/25.
//

import Foundation
import UIKit

class WeightViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource{
    
    
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var GenderLbl: UILabel!
    
    @IBOutlet weak var weightLbl: UILabel!
    @IBOutlet weak var weightPicker: UIPickerView!
    
    var selectedGender: String = ""
    var selectedWeight: String = ""

    
    let weights = Array(30...200)
    let units = ["kg", "lbs"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        weightPicker.delegate = self
        weightPicker.dataSource = self
        
        GenderLbl.text = selectedGender
        
        if let savedWeight = UserDefaults.standard.value(forKey: "SelectedWeight") as? Int,
           let savedUnit = UserDefaults.standard.string(forKey: "SelectedUnit"),
           let weightIndex = weights.firstIndex(of: savedWeight),
           let unitIndex = units.firstIndex(of: savedUnit) {
            
            weightPicker.selectRow(weightIndex, inComponent: 0, animated: false)
            weightPicker.selectRow(unitIndex, inComponent: 1, animated: false)
            
            selectedWeight = "\(savedWeight) \(savedUnit)" // ✅ Add this line
            weightLbl.text = selectedWeight
        }

        uiDesign()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func uiDesign(){
        btnNext.layer.cornerRadius = 12
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return weights.count
        } else {
            return units.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return "\(weights[row])"
        } else {
            return units[row]
        }
        
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let weight = weights[pickerView.selectedRow(inComponent: 0)]
        let unit = units[pickerView.selectedRow(inComponent: 1)]
        
        selectedWeight = "\(weight) \(unit)" // ✅ Assign to property
        
        weightLbl.text = selectedWeight
        UserDefaults.standard.set(weight, forKey: "SelectedWeight")
        UserDefaults.standard.set(unit, forKey: "SelectedUnit")
        
        print("Selected Weight: \(selectedWeight)")
    }
    
    @IBAction func btnNext(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "BedTimeViewController")as! BedTimeViewController
     
        
        vc.selectedGender = self.selectedGender
        vc.selectedWeight = self.selectedWeight 
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    @IBAction func btnExit(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
