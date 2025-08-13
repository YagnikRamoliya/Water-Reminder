import UIKit
import UserNotifications

class ReminderscheduleVc: UIViewController, UITableViewDataSource, UITableViewDelegate, UNUserNotificationCenterDelegate {
    
    @IBOutlet weak var selectDate: UIDatePicker!
    @IBOutlet weak var btnPlus: UIButton!
    @IBOutlet weak var tblReminder: UITableView!
    
    // Store reminders (Date objects)
    private var reminders: [Date] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tblReminder.dataSource = self
        tblReminder.delegate = self
        
        // Set datePicker mode to time only
        selectDate.datePickerMode = .time
        selectDate.preferredDatePickerStyle = .wheels
        
        // Request notification permission
        UNUserNotificationCenter.current().delegate = self
        requestNotificationPermission()
    }
    
    func requestNotificationPermission() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { granted, error in
            if granted {
                print("Notification permission granted")
            } else {
                print("Notification permission denied")
            }
        }
    }
    
    // MARK: - Add reminder button tapped
    @IBAction func btnPlusTapped(_ sender: UIButton) {
        let selectedTime = selectDate.date
        
        // Check if reminder for this time already exists (optional)
        if reminders.contains(where: { Calendar.current.isDate($0, equalTo: selectedTime, toGranularity: .minute) }) {
            showAlert(title: "Reminder already exists for this time")
            return
        }
        
        reminders.append(selectedTime)
        reminders.sort()  // Optional: keep reminders sorted
        tblReminder.reloadData()
        
        scheduleNotification(for: selectedTime)
    }
    
    // MARK: - Schedule local notification for reminder
    func scheduleNotification(for date: Date) {
        let content = UNMutableNotificationContent()
        content.title = "Water Reminder"
        content.body = "It's time to drink water!"
        
        let selectedSoundName = UserDefaults.standard.string(forKey: "selectedSound")
        
        if let soundName = selectedSoundName, !soundName.isEmpty {
            content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: soundName))
        } else {
            content.sound = UNNotificationSound.default
        }
        // Extract hour and minute components from selected date
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.hour, .minute], from: date)
        
        // Trigger every day at the selected time
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        let identifier = UUID().uuidString
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            DispatchQueue.main.async {
                if let error = error {
                    self.showAlert(title: "Failed to schedule notification: \(error.localizedDescription)")
                } else {
                    print("Notification scheduled for \(dateComponents.hour ?? 0):\(dateComponents.minute ?? 0)")
                }
            }
        }
    }
    
    // MARK: - UITableView DataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reminders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "ReminderCell", for: indexPath) as! ReminderCell
        
        let reminderDate = reminders[indexPath.row]
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        
        cell.lblTime.text = formatter.string(from: reminderDate)
        cell.uiVIew.layer.cornerRadius = 12
        return cell
    }
    
    // MARK: - Swipe to delete support
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Remove reminder from array
            reminders.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
            // Also remove scheduled notification related to this time
            // Since we used random UUIDs as identifiers,
            // you can improve by storing notification IDs alongside reminders.
            // For simplicity, cancelling all notifications and rescheduling:
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
            for reminder in reminders {
                scheduleNotification(for: reminder)
            }
        }
    }
    
    // MARK: - Helper to show alert
    
    func showAlert(title: String) {
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    // Optional: Handle notifications when app is in foreground
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler:
                                @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound]) // Show banner and play sound even when app is open
    }
    
    @IBAction func btnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

class ReminderCell: UITableViewCell{
   
    @IBOutlet weak var lblTime: UILabel!
    
    @IBOutlet weak var uiVIew: UIView!
}
