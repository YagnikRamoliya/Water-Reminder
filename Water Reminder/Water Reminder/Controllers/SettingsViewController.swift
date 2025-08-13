//
//  SettingsViewController.swift
//  Water Reminder
//
//  Created by iMac on 08/08/25.
//

import Foundation
import UIKit



class SettingsViewController: UIViewController {
    
    @IBOutlet weak var lblWeight: UILabel!
    @IBOutlet weak var lblGender: UILabel!
    @IBOutlet weak var lblBedTime: UILabel!
    @IBOutlet weak var lblWakeUpTime: UILabel!
    
    @IBOutlet weak var uiVIewGenaralView: UIView!
    @IBOutlet weak var uiVIewreminderView: UIView!
    
    @IBOutlet weak var uiVIewDeveloeprView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
       takeInformation()
        uiDesign()
    }
    func uiDesign(){
        uiVIewreminderView.layer.borderColor = UIColor.black.cgColor
        uiVIewreminderView.layer.borderWidth = 1
        uiVIewreminderView.layer.cornerRadius = 16
        
        uiVIewGenaralView.layer.borderColor = UIColor.black.cgColor
        uiVIewGenaralView.layer.borderWidth = 1
        uiVIewGenaralView.layer.cornerRadius = 16
        
        
        uiVIewDeveloeprView.layer.borderColor = UIColor.black.cgColor
        uiVIewDeveloeprView.layer.borderWidth = 1
        uiVIewDeveloeprView.layer.cornerRadius = 16
        
        
        
    }
    
    func takeInformation(){
        lblGender.text = UserDefaults.standard.string(forKey: "SelectedGender")
        lblWeight.text = UserDefaults.standard.string(forKey: "SelectedWeight")
        lblBedTime.text = UserDefaults.standard.string(forKey: "BedTime")
        lblWakeUpTime.text = UserDefaults.standard.string(forKey:"wakeUpTime")
    }
    
    
    
    @IBAction func btnSheduleReminder(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ReminderscheduleVc")as! ReminderscheduleVc
        self.navigationController?.pushViewController(vc, animated: true)
        
        
    }
    
    
    
    
    @IBAction func btnSoundReminder(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ReminderSoundVc")as! ReminderSoundVc
        
            present(vc, animated: true)
    }
    
    
    @IBAction func btnRate(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier:"RatingViewController")as! RatingViewController
        
       present(vc, animated: true)
    }
    
    @IBAction func btnFeedBack(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "FeedbackViewController")as! FeedbackViewController
        
        present(vc, animated: true)
    }
}
