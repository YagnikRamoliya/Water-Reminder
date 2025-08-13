import UIKit

import UIKit

class BedTimeViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var timePicker: UIPickerView!
    @IBOutlet weak var bedtimeLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    
    @IBOutlet weak var btnNext: UIButton!
    var selectedGender: String = ""
    var selectedWeight: String = ""
    
    let hours = Array(1...12)
    let minutes = Array(0...59)
    let periods = ["AM", "PM"]
    
    var selectedHour = 12
    var selectedMinute = 0
    var selectedPeriod = "AM"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Received Gender: \(selectedGender)")
        print("Received Weight: \(selectedWeight)")
        // Picker setup
        timePicker.delegate = self
        timePicker.dataSource = self
        
        // Show passed gender and weight
        genderLabel.text = selectedGender
        weightLabel.text = selectedWeight
        
        // Initial time update
        updateSelectedTimeLabel()
        uiDesign()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    func uiDesign(){
        btnNext.layer.cornerRadius = 12
    }
    
    // MARK: - PickerView DataSource & Delegate
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3 // Hour, Minute, AM/PM
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
        bedtimeLabel.text = timeString
    }
    
    
    @IBAction func btnNext(_ sender: UIButton) {
        // Save selected bedtime to UserDefaults
        let timeString = String(format: "%02d:%02d %@", selectedHour, selectedMinute, selectedPeriod)
        UserDefaults.standard.set(timeString, forKey: "BedTime")
        
        // Instantiate WakeUpViewController and pass data
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "WakeUpViewController") as! WakeUpViewController
        
        vc.selectedGender = self.selectedGender
        vc.selectedWeight = self.selectedWeight
        vc.selectedBedTime = timeString
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func btnExit(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

