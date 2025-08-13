//
//  OnboardingManager.swift
//  Water Reminder
//
//  Created by iMac on 07/08/25.
//

import Foundation

class OnboardingManager {
    static let shared = OnboardingManager()
    
    var gender: String = ""
    var weight: Int = 60
    var bedtime: Date = Date()
    var wakeUpTime: Date = Date()
    
    func save() {
        UserDefaults.standard.set(gender, forKey: "userGender")
        UserDefaults.standard.set(weight, forKey: "userWeight")
        UserDefaults.standard.set(bedtime, forKey: "userBedtime")
        UserDefaults.standard.set(wakeUpTime, forKey: "userWakeUpTime")
        UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
    }
}

