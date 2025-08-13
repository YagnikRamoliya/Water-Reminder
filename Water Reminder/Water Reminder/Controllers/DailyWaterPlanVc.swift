//
//  DailyWaterPlanVc.swift
//  Water Reminder
//
//  Created by iMac on 07/08/25.
//

import Foundation
import UIKit
class DailyWaterPlanVc: UIViewController{
    var selectedWeight: String = ""
    var drinkWaterMl : String = ""
    var initialIndex: Int = 0  // Default 0
    
    @IBOutlet weak var lblWater: UILabel!
    @IBOutlet weak var btnStart: UIButton!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let weight = UserDefaults.standard.value(forKey: "SelectedWeight") as? Int {
            print("User weight is: \(weight) kg")
            
            let recommendedWaterML = weight * 35
            lblWater.text = "\(recommendedWaterML) ml per day"
            
            // ✅ Save only the number
            UserDefaults.standard.set(recommendedWaterML, forKey: "DailyDrinkWater")
            
        } else {
            lblWater.text = "Please set your weight"
            
            // Save 0 if no weight set
            UserDefaults.standard.set(0, forKey: "DailyDrinkWater")
        }
        
        
        
        uiDesign()
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    func uiDesign(){
        btnStart.layer.cornerRadius = 12
    }
    
    
    @IBAction func btnStart(_ sender: Any) {
        let tabbar = self.storyboard?.instantiateViewController(withIdentifier: "CustomTabBar")as! CustomTabBar
        tabbar.initialIndex = 1
        self.navigationController?.pushViewController(tabbar, animated: true)
    }
}
