import UIKit

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var drinkWaterMl = ""
    var currentIntake: Int = 0
    var intakeTimes: [String] = []
    var dailyTarget: Int = 0
    var progressLayer = CAShapeLayer()
    
    @IBOutlet weak var tblTimeDrinkWater: UITableView!
    @IBOutlet weak var lblUserDrinkTaret: UILabel!
    @IBOutlet weak var lblTapLbl300: UILabel!
    @IBOutlet weak var btnGlass: UIButton!
    @IBOutlet weak var uiViewRound: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        uiDesign()
        checkIfNewDay()
        
        // Load daily target
        dailyTarget = UserDefaults.standard.integer(forKey: "DailyDrinkWater")
        lblUserDrinkTaret.text = "/\(dailyTarget) ml"
        
        // Restore current intake
        currentIntake = UserDefaults.standard.integer(forKey: "UserCurrentIntake")
        lblTapLbl300.text = "\(currentIntake)"
        
        // Restore saved times
        if let savedTimes = UserDefaults.standard.array(forKey: "IntakeTimes") as? [String] {
            intakeTimes = savedTimes
        }
        
        tblTimeDrinkWater.delegate = self
        tblTimeDrinkWater.dataSource = self
        
        let nib = UINib(nibName: "DailyRecordsTableViewCell", bundle: nil)
        tblTimeDrinkWater.register(nib, forCellReuseIdentifier: "DailyRecordsTableViewCell")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupHalfCircleProgress()
        updateProgress(animated: false)
    }
    
    func uiDesign() {
        uiViewRound.layer.cornerRadius = uiViewRound.frame.height / 2
        uiViewRound.layer.shadowColor = UIColor.black.cgColor
        uiViewRound.layer.shadowOpacity = 0.3
        uiViewRound.layer.shadowRadius = 6
        uiViewRound.layer.shadowOffset = .zero
        uiViewRound.layer.masksToBounds = false
    }
    
    func setupHalfCircleProgress() {
        // Remove old progress layers & icons
        uiViewRound.layer.sublayers?.removeAll(where: { $0 is CAShapeLayer })
        uiViewRound.superview?.subviews.filter { $0.tag == 999 }.forEach { $0.removeFromSuperview() }
        
        let centerPoint = CGPoint(x: uiViewRound.center.x,
                                  y: uiViewRound.center.y)
        
        let radius = (uiViewRound.bounds.width / 2) + 15
        let lineWidth: CGFloat = 8
        
        let startAngle: CGFloat = .pi    // left-bottom
        let endAngle: CGFloat = 0        // right-bottom
        
        // Create path for outer half-circle
        let path = UIBezierPath(arcCenter: CGPoint(x: uiViewRound.bounds.width/2,
                                                   y: uiViewRound.bounds.height/2),
                                radius: radius,
                                startAngle: startAngle,
                                endAngle: endAngle,
                                clockwise: true)
        
        // Background arc
        let backgroundLayer = CAShapeLayer()
        backgroundLayer.path = path.cgPath
        backgroundLayer.strokeColor = UIColor.lightGray.withAlphaComponent(0.3).cgColor
        backgroundLayer.fillColor = UIColor.clear.cgColor
        backgroundLayer.lineWidth = lineWidth
        backgroundLayer.lineCap = .round
        uiViewRound.layer.addSublayer(backgroundLayer)
        
        // Progress arc
        progressLayer = CAShapeLayer()
        progressLayer.path = path.cgPath
        progressLayer.strokeColor = UIColor.systemBlue.cgColor
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.lineWidth = lineWidth
        progressLayer.strokeEnd = 0
        progressLayer.lineCap = .round
        uiViewRound.layer.addSublayer(progressLayer)
        
        // Calculate icon points (but place in superview for "outside" look)
        let iconSize: CGFloat = 24
        let iconYOffset: CGFloat = 25 // niche lane ke liye
        
        let startPoint = CGPoint(
            x: centerPoint.x - radius,
            y: centerPoint.y + iconYOffset
        )
        
        let endPoint = CGPoint(
            x: centerPoint.x + radius,
            y: centerPoint.y + iconYOffset
        )
        
        let startImageView = UIImageView(frame: CGRect(x: startPoint.x - iconSize/2,
                                                       y: startPoint.y - iconSize/2,
                                                       width: iconSize,
                                                       height: iconSize))
        startImageView.image = UIImage(named: "heart")
        startImageView.contentMode = .scaleAspectFit
        startImageView.tag = 999
        uiViewRound.superview?.addSubview(startImageView) // superview par add kiya
        
        let endImageView = UIImageView(frame: CGRect(x: endPoint.x - iconSize/2,
                                                     y: endPoint.y - iconSize/2,
                                                     width: iconSize,
                                                     height: iconSize))
        endImageView.image = UIImage(named: "drop")
        endImageView.contentMode = .scaleAspectFit
        endImageView.tag = 999
        uiViewRound.superview?.addSubview(endImageView)
    }

    
    func updateProgress(animated: Bool = true) {
        guard dailyTarget > 0 else { return }
        let progress = min(Float(currentIntake) / Float(dailyTarget), 1.0)
        
        if animated {
            let animation = CABasicAnimation(keyPath: "strokeEnd")
            animation.toValue = progress
            animation.duration = 0.4
            animation.fillMode = .forwards
            animation.isRemovedOnCompletion = false
            progressLayer.add(animation, forKey: "progressAnim")
        } else {
            progressLayer.strokeEnd = CGFloat(progress)
        }
    }
    
    func checkIfNewDay() {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())

        if let lastDate = UserDefaults.standard.object(forKey: "LastIntakeDate") as? Date {
            let lastSavedDay = calendar.startOfDay(for: lastDate)
            if today > lastSavedDay {
                // Save yesterday's intake in DailyHistory
                var dailyHistory = UserDefaults.standard.array(forKey: "DailyHistory") as? [Int] ?? []
                dailyHistory.append(currentIntake)
                UserDefaults.standard.set(dailyHistory, forKey: "DailyHistory")

                // Reset data
                UserDefaults.standard.removeObject(forKey: "UserCurrentIntake")
                UserDefaults.standard.removeObject(forKey: "IntakeTimes")
                UserDefaults.standard.set(today, forKey: "LastIntakeDate")
                currentIntake = 0
                intakeTimes = []
                lblTapLbl300.text = "0 ml"
                tblTimeDrinkWater.reloadData()
            }
        } else {
            // First launch
            UserDefaults.standard.set(today, forKey: "LastIntakeDate")
        }
    }
    func addWater(amount: Int) {
        // Current intake update karo
        currentIntake += amount
        lblTapLbl300.text = "\(currentIntake) ml"
        
        // Date formatter
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let todayStr = dateFormatter.string(from: Date())

        // UserDefaults me WaterHistory save/update
        var history = UserDefaults.standard.dictionary(forKey: "WaterHistory") as? [String: Int] ?? [:]
        history[todayStr] = (history[todayStr] ?? 0) + amount
        UserDefaults.standard.set(history, forKey: "WaterHistory")
    }

    @IBAction func btnGlass(_ sender: UIButton) {
        addWater(amount: 300)
        lblTapLbl300.text = "\(currentIntake)"
        UserDefaults.standard.set(currentIntake, forKey: "UserCurrentIntake")
        
        if currentIntake >= dailyTarget && dailyTarget > 0 {
            btnGlass.isEnabled = false
            showTargetCompletedAlert()
        }
        
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        let timeString = formatter.string(from: Date())
        intakeTimes.insert(timeString, at: 0)
        UserDefaults.standard.set(intakeTimes, forKey: "IntakeTimes")
        
        UserDefaults.standard.set(Date(), forKey: "LastIntakeDate")
        
        tblTimeDrinkWater.reloadData()
        updateProgress()
    }
    
    func showTargetCompletedAlert() {
        let alert = UIAlertController(title: "🎉 Target Completed",
                                      message: "You’ve reached your daily water goal!",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return intakeTimes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DailyRecordsTableViewCell", for: indexPath) as! DailyRecordsTableViewCell
        cell.lblTime.text = "Drank 300ml at \(intakeTimes[indexPath.row])"
        return cell
    }
}
